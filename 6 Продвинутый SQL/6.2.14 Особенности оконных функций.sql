Особенности оконных функций
В этом уроке вы узнаете, как упростить запрос с несколькими оконными функциями, а также о том, с чем оконные функции нельзя сочетать.
Описание схем онлайн-магазина «Сила — в окнах»

Сохраняем определение окна
Определение окна в выражении OVER может встречаться в запросе несколько раз. Например, в запросе ниже используются разные функции ранжирования записей: 

SELECT *,
    ROW_NUMBER() OVER (ORDER BY revenue),
    RANK() OVER (ORDER BY revenue),
    DENSE_RANK() OVER (ORDER BY revenue)
FROM online_store.orders; 
user_id	event_dt	revenue	row_number	rank	dense_rank
117600800430	2020-06-23	1	1	1	1
13263143928	2020-06-18	1	2	1	1
318506600467	2020-06-21	1	3	1	1
461670247155	2020-06-17	1	4	1	1
896743136756	2020-06-19	1	5	1	1
Вместо того чтобы повторять определение окна трижды, его можно сохранить отдельно. Для этого используют конструкцию WINDOW.

SELECT *,
    ROW_NUMBER() OVER my_window AS result1,
    RANK() OVER my_window AS result2,
    DENSE_RANK() OVER my_window AS result3
FROM online_store.orders
WINDOW my_window AS (ORDER BY revenue);  
Теперь, чтобы исправить определение окна, понадобится поменять всего одну строчку кода вместо трёх. 
В основном запросе конструкцию WINDOW указывают после оператора WHERE и до оператора ORDER BY. Синтаксис у конструкции такой: WINDOW название окна AS определение окна. В одном запросе можно записать сразу несколько определений окна. В таком случае их нужно указать через запятую, как в случае общих табличных выражений:

WHERE ...
WINDOW 
    my_window AS (ORDER BY revenue),
    one_more_window AS (PARTITION BY user_id)
ORDER BY ... 
Ограничения оконных функций
У оконных функций есть ограничения, которые нужно учитывать. Одно из таких ограничений — использование DISTINCT в аргументе оконной функции. Напомним, что ключевое слово DISTINCT помогает удалить дублирующиеся строки и его можно использовать вместе с агрегирующими функциями: COUNT(DISTINCT поле). С оконными функциями это не сработает. 
Запрос ниже не будет обработан — это особенность не только PostgreSQL, но и многих других СУБД. 

SELECT COUNT(DISTINCT user_id) OVER (ORDER BY event_dt)
FROM online_store.orders; 
Результат:
DISTINCT is not implemented for window functions

SELECT COUNT(DISTINCT user_id) OVER (ORDER BY event_dt)
      ^^^
FROM online_store.orders; 
Другое ограничение — оконные функции нельзя сочетать с группировкой. Запрос ниже тоже вызовет ошибку. 

SELECT
    event_dt, 
    COUNT(*) OVER (PARTITION BY event_dt)
FROM online_store.orders
GROUP BY 
    event_dt, 
    COUNT(*) OVER (PARTITION BY event_dt); 
Результат:
window functions are not allowed in GROUP BY

SELECT event_dt, 
       COUNT(*) OVER (PARTITION BY event_dt)
FROM online_store.orders
GROUP BY event_dt, COUNT(*) OVER (PARTITION BY event_dt);
                     ^^^ 
Невозможность сочетать оконные функции с группировкой кажется логичной, потому что особенность оконных функций в том, что данные в результате вычислений не агрегируются. 
Запрос сработает, если убрать группировку и добавить DISTINCT в начало запроса.

SELECT 
    DISTINCT 
    event_dt,
    COUNT(*) OVER (PARTITION BY event_dt)
FROM online_store.orders; 
Результат:
event_dt	count
2020-06-23	1630
2020-06-22	1408
2020-06-15	796
2020-06-26	2096
2020-06-20	1507
Похожую итоговую таблицу выдаст запрос с GROUP BY:

SELECT 
    DISTINCT 
    event_dt,
    COUNT(*)
FROM online_store.orders
GROUP BY event_dt; 
Третье ограничение — оконные функции, как и агрегирующие, нельзя использовать в условиях после WHERE. Вычисление агрегирующих и оконных функций происходит после срезов. Вспомните урок про порядок выполнения операторов из темы «Функции» предыдущего спринта — в первую очередь выполняется FROM, затем WHERE, GROUP BY, HAVING и только потом SELECT.
По этой причине запрос ниже тоже вызовет ошибку:

SELECT *,
    ROW_NUMBER() OVER (ORDER BY created_at) AS rn
    FROM tools_shop.users
FROM online_store.orders
WHERE ROW_NUMBER() OVER (ORDER BY created_at) = 100; 
Результат:

window functions are not allowed in WHERE

SELECT *,
    ROW_NUMBER() OVER (ORDER BY created_at) AS rn
    FROM tools_shop.users
FROM online_store.orders
WHERE ROW_NUMBER() OVER (ORDER BY created_at) = 100;
        ^^^ 
Выполнить такой запрос можно в два шага: сначала рассчитать оконную функцию, а затем наложить фильтр на результат.

WITH users AS (
    SELECT *,
        ROW_NUMBER() OVER (ORDER BY created_at) AS rn
    FROM tools_shop.users
)
SELECT user_id
FROM users
WHERE rn = 2021; 
Подытожим: 
в аргументе оконной функции нельзя использовать DISTINCT;
оконные функции нельзя сочетать с группировкой;
оконные функции нельзя использовать в условиях после WHERE.


