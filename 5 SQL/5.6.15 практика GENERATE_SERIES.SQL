1.
С помощью функции GENERATE_SERIES сгенерируйте последовательность дат (stat_date) в интервале c 1 по 31 августа 2023 года с интервалом в три дня.

SELECT GENERATE_SERIES('2023-08-01', '2023-08-31', '3 DAYS'::INTERVAL)::DATE AS stat_date


2.
Для тестирования базы данных необходимо сгенерировать 50 строк по определённому шаблону:
user_id — идентификатор пользователя, шесть заглавных букв английского алфавита;
reg_dt — случайная дата в интервале от 20 до 30 августа 2023 года включительно.

SELECT setseed(0); /* Не удаляйте эту строчку, она позволяет зафиксировать генерацию рандомных значений*/
SELECT 
    /* к функции генерации случайной буквы добавьте агрегирующую функцию */
    STRING_AGG(CHR(ASCII('A') + FLOOR(RANDOM()*26)::integer), '') AS user_id, 
    /* сгенерируйте случайную дату */ 
    ('2023-08-20'::DATE + round(RANDOM() * 10 )*('24 hours'::interval))::date AS reg_dt
FROM 
    /* задайте множество от 1 до 6 
       для определения количества символов в user_id */ 
    GENERATE_SERIES(1, 6, 1) AS char_num,
    /* задайте множество от 1 до 50 в качестве количества строк */ 
    GENERATE_SERIES(1, 50, 1) AS line_num
GROUP BY line_num


3.
Используя данные таблицы invoice, подсчитайте сумму заказа (total_sum) за каждый день (check_date) в ноябре 2013 года. 
Если в какой-то из дней не было заказов, замените NULL на 0. 
Результат отсортируйте по дате в порядке возрастания. Данные check_date приведите к дате.

SELECT
    check_date::DATE,
    CASE
        WHEN SUM(total) IS NOT NULL THEN  SUM(total)
        ELSE 0
    END AS total_sum
FROM GENERATE_SERIES('2013-11-01'::date, '2013-11-30'::date, '1 DAYS'::INTERVAL) AS check_date
LEFT JOIN chinook.invoice AS i ON check_date = i.invoice_date::DATE 
GROUP BY check_date
ORDER BY check_date

