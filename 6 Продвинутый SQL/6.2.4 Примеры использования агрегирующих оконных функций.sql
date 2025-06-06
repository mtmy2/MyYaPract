Примеры использования агрегирующих оконных функций
В предыдущих уроках познакомились с принципом работы оконных функций. В этом уроке мы подробнее поговорим об агрегирующих оконных функциях и разберём больше практических примеров их применения. 
Под катом — описание данных онлайн-магазина «Сила — в окнах».
Описание схем БД онлайн-магазина «Сила — в окнах»

AVG
Функция AVG используется для расчёта среднего значения по какому-либо полю. Например, рассчитаем среднюю стоимость заказа за день. Объединив данные в окно по дате заказа event_dt, можно найти средний чек revenue по каждому дню. 

SELECT *,
    AVG(revenue) OVER (PARTITION BY event_dt) AS avg_rev
FROM online_store.orders
WHERE user_id IN (240493073664,268983139241); 
user_id	event_dt	revenue	avg_rev
268983139241	2020-06-14	7.46	8.595
240493073664	2020-06-14	9.73	8.595
268983139241	2020-06-15	7.57	8.43
240493073664	2020-06-15	9.29	8.43
268983139241	2020-06-16	2.0	4.88
240493073664	2020-06-16	7.76	4.88
240493073664	2020-06-18	4.38	4.38
Значение avg_rev по каждому дню совпадает у всех пользователей. 
Здесь и далее фильтр WHERE используется в примерах запросов только чтобы ограничить результирующую таблицу и сделать её более наглядной. Проверьте в своём DBeaver, что такая же средняя дневная стоимость заказа будет у других пользователей, делавших заказ в эти же дни. Для этого достаточно убрать часть запроса с WHERE.
Как и в случае с обычными агрегирующими функциями, результат оконной функции можно округлить. Обратите внимание на аргумент, который передают функции ROUND:

SELECT *,
    ROUND(AVG(revenue) OVER (PARTITION BY event_dt), 2) AS avg_rev
FROM online_store.orders
WHERE user_id IN (240493073664,268983139241); 
user_id	event_dt	revenue	avg_rev
268983139241	2020-06-14	7.46	8.60
240493073664	2020-06-14	9.73	8.60
268983139241	2020-06-15	7.57	8.43
240493073664	2020-06-15	9.29	8.43
268983139241	2020-06-16	2.0	4.88
240493073664	2020-06-16	7.76	4.88
240493073664	2020-06-18	4.38	4.38
MAX
С помощью функции MAX можно найти максимальное значение поля. Чтобы оценить, как часто пользователи делают покупки в интернет-магазине, найдём дату последнего заказа для каждого пользователя, то есть «максимальную» дату заказа. Будем использовать функцию MAX, а данные объединим в окно по идентификатору пользователя user_id. 

SELECT *,
    MAX(event_dt) OVER (PARTITION BY user_id) AS last_order_dt
FROM online_store.orders
WHERE user_id IN (791717634817,643364441897); 
user_id	event_dt	revenue	last_order_dt
643364441897	2020-06-14	7.92	2020-06-26
643364441897	2020-06-15	6.38	2020-06-26
643364441897	2020-06-26	1.85	2020-06-26
791717634817	2020-06-14	6.73	2020-06-19
791717634817	2020-06-19	2.5	2020-06-19
MIN
Если для анализа нужен первый заказ пользователя в интернет-магазине, например, чтобы потом рассчитать, сколько времени проходит от регистрации до первого заказа, используйте функцию MIN. Выражение MIN(event_dt) OVER (PARTITION BY user_id) вернёт минимальное значение даты заказа event_dt для каждого окна с идентификатором пользователя.

    SELECT *,
        MIN(event_dt) OVER (PARTITION BY user_id) AS user_min
    FROM online_store.orders 
    WHERE user_id IN (300768196, 840452722, 59432616)
    ORDER BY user_id; 
user_id	event_dt	revenue	user_min
59432616	2020-06-17	7.59	2020-06-17
300768196	2020-06-25	8.74	2020-06-25
300768196	2020-06-27	5.26	2020-06-25
840452722	2020-06-19	5.81	2020-06-19
840452722	2020-06-21	3.17	2020-06-19
840452722	2020-06-24	6.27	2020-06-19
Если все значения в поле, по которому формируют окна, уникальны, оконная функция будет рассчитана для каждой записи отдельно. В поле event_dt нет повторяющихся значений, поэтому функция MIN(revenue) OVER (PARTITION BY event_dt) вернёт значение revenue в каждой записи. 

SELECT *,
    MIN(revenue) OVER (PARTITION BY event_dt) 
FROM online_store.orders 
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	min
59432616	2020-06-17	7.59	7.59
300768196	2020-06-25	8.74	8.74
300768196	2020-06-27	5.26	5.26
840452722	2020-06-19	5.81	5.81
840452722	2020-06-21	3.17	3.17
840452722	2020-06-24	6.27	6.27
SUM
Функция SUM рассчитывает сумму значений по заданному окну. Сформировав окна по event_dt, можно посчитать сумму выручки за каждый день. 

SELECT *,
    SUM(revenue) OVER (PARTITION BY event_dt) AS daily_rev
FROM online_store.orders
WHERE event_dt BETWEEN '2020-06-14' AND '2020-06-16'; 
user_id	event_dt	revenue	daily_rev
1054208389	2020-06-16	1.69	6778.23
1223594570	2020-06-15	3.17	4294.93
1366418076	2020-06-14	1.9	3154.60
1366418076	2020-06-15	1.35	4294.93
1398251690	2020-06-14	1.9	3154.60
2208605687	2020-06-16	8.52	6778.23
2394026308	2020-06-15	6.19	4294.93
Здесь приведена только часть результата. Запустите запрос в DBeaver и проверьте, что и для других пользователей суммарная выручка за эти дни будет такой же.
COUNT
Если нужно узнать количество записей в выборке на каждое окно, используется функция COUNT. Объединив данные по пользователям, можно посчитать, сколько заказов сделал каждый из них.

SELECT *,
    COUNT(*) OVER (PARTITION BY user_id) AS orders_cnt
FROM online_store.orders
WHERE user_id IN (792032546, 1223594570, 4731868407); 
user_id	event_dt	revenue	orders_cnt
792032546	2020-06-20	3.04	1
1223594570	2020-06-15	3.17	2
1223594570	2020-06-20	5.8	2
4731868407	2020-06-19	1.07	3
4731868407	2020-06-20	4.29	3
4731868407	2020-06-24	5.43	3
Операции с агрегирующими оконными функциями
При расчёте одного поля можно использовать сразу несколько оконных функций. Например, посчитаем отношение суммы заказов каждого пользователя к количеству заказов, которые пользователь сделал. Для этого отдельно посчитаем оконную функцию для суммы заказов и для их количества, а затем поделим первую на вторую. Результат запишем в поле orders_calc.

SELECT *,
    SUM(revenue) OVER (PARTITION BY user_id)/COUNT(*) OVER (PARTITION BY user_id) AS orders_calc
FROM online_store.orders
WHERE user_id IN (792032546, 1223594570, 4731868407); 
Ошибки нет. Полученный результат в таблице ниже:
user_id	event_dt	revenue	orders_calc
792032546	2020-06-20	3.04	3.0400
1223594570	2020-06-15	3.17	4.4850
1223594570	2020-06-20	5.8	4.4850
4731868407	2020-06-19	1.07	3.5967
4731868407	2020-06-20	4.29	3.5967
4731868407	2020-06-24	5.43	3.5967
А ещё в этом случае вычисление можно упростить, потому что в результате деления мы получили среднюю сумму заказа на каждого пользователя. Проверьте, что с функцией AVG результат получится таким же.


