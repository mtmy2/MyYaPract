
Часто таблицы соединяют уже после того, как получили срез и сгруппировали данные. 
Причина проста: соединение больших таблиц занимает много времени. 
Таблицу лучше предварительно обработать, а уже потом соединять данные.
Разберём на примере. Нужно получить таблицу, в которую войдут пять стран — лидеров по количеству заказов. 
Для каждой страны отобразим число зарегистрированных пользователей. 


Готовим промежуточные таблицы
Первый подзапрос отберёт пять стран с наибольшим количеством заказов.

SELECT 
    billing_country AS country,
    COUNT(total) AS total_invoice
FROM chinook.invoice
GROUP BY billing_country
ORDER BY total_invoice DESC
LIMIT 5; 
Данные в таблице сгруппированы по стране. Таблица отсортирована по убыванию количества заказов и ограничена первыми пятью записями.


Теперь нужно сформировать вторую таблицу — посчитать число зарегистрированных пользователей на страну. Получать срез или сортировать данные не нужно. Отобрать данные можно после соединения.

SELECT 
    country AS country,
    COUNT(customer_id) AS total_clients
FROM chinook.client
GROUP BY country; 


Две таблицы сформированы. Можно их проанализировать:
У таблиц есть общее поле со страной — country. С помощью этого поля их можно соединить.
В итоговую таблицу должны войти не все страны, а только пять — с наибольшим числом заказов. Список этих стран находится в первой таблице, значит, эту таблицу можно назначить «левой» и применить LEFT JOIN.
Осталось разобраться с тем, как соединить таблицы, сформированные подзапросами. 


Соединяем результаты подзапросов
Напомним правила соединения таблиц:
После оператора FROM назначают первую таблицу.
Затем следует выбранный оператор соединения — LEFT JOIN.
После оператора указывают вторую таблицу и поля, по которым соединяют данные.
Теперь можно добавить подзапросы вместо таблиц. Напомним: чтобы избежать ошибок, подзапросам нужно добавлять псевдоним.

SELECT *
FROM
  (SELECT billing_country AS country,
          COUNT(total) AS total_invoice
   FROM chinook.invoice
   GROUP BY billing_country
   ORDER BY total_invoice DESC
   LIMIT 5) AS i
LEFT JOIN
  (SELECT country AS country,
          COUNT(customer_id) AS total_clients
   FROM chinook.client
   GROUP BY country) AS c ON i.country = c.country;


   Таблицы соединены по полю country. Тип соединения — LEFT JOIN, поэтому в таблице остались данные только о пяти странах. 

Можно ли было использовать другой тип соединения? 
Да, в качестве оператора соединения подошёл бы и INNER JOIN: если пользователи сделали заказы, то они зарегистрированы, 
а значит, выбранные по наибольшему количеству заказов страны не пропадут из выборки после соединения. 
Таблицу можно улучшить: убрать повторяющееся поле country и добавить сортировку по наибольшему количеству заказов. 

SELECT i.country,
       i.total_invoice,
       c.total_clients
FROM
  (SELECT billing_country AS country,
          COUNT(total) AS total_invoice
   FROM chinook.invoice
   GROUP BY billing_country
   ORDER BY total_invoice DESC
   LIMIT 5) AS i
LEFT JOIN
  (SELECT country AS country,
          COUNT(customer_id) AS total_clients
   FROM chinook.client
   GROUP BY country) AS c ON i.country = c.country
ORDER BY i.total_invoice DESC; 


Вместо того чтобы сначала соединять таблицы, а потом убирать лишнее, можно сформировать несколько подзапросов и соединить результаты.

Иногда при записи данных возникают ошибки. Проверим корректность внесённых данных за 2010 год. 
Для этого сравним помесячно общую сумму заказов с общей стоимостью треков, которые были включены в заказ. 
Если все корректно, эти две суммы должны совпадать.

В базе данных это будут: 
сумма поля total из таблицы invoice,
произведение полей unit_price и quantity из таблицы invoice_line.
Описание таблиц invoice и invoice_line можно посмотреть под катом.

Подсчитаем для каждого месяца сумму total, используя таблицу invoice.
Присоединим таблицу invoice к invoice_line, чтобы получить дату покупки трека.
В получившейся таблице подсчитаем сумму произведения полей unit_price и quantity для каждого месяца.
Соединим результаты первого и второго запросов.

Напишем первый подзапрос:

SELECT EXTRACT(MONTH FROM CAST(invoice_date AS date)) AS month_invoice,
       SUM(total) AS sum_of_total
FROM chinook.invoice
WHERE EXTRACT(YEAR FROM CAST(invoice_date AS date)) = 2010
GROUP BY month_invoice; 


Второй подзапрос немного сложнее — понадобится присоединить таблицу с подробностями о заказах:

SELECT EXTRACT(MONTH FROM CAST(invoice_date AS date)) AS month_invoice,
       SUM(unit_price*quantity) AS sum_of_price
FROM chinook.invoice AS i
LEFT JOIN chinook.invoice_line AS il ON i.invoice_id = il.invoice_id
WHERE EXTRACT(YEAR FROM CAST(invoice_date AS date)) = 2010
GROUP BY month_invoice; 

Последний шаг — соединить таблицы по общему месяцу. Для соединения используем оператор INNER JOIN. 
В обоих подзапросах поле month_invoice формируется из таблицы invoice,  
поэтому у каждой строки из одного подзапроса точно найдётся пара в другом, и при внутреннем соединении данные не потеряются. 

SELECT t_1.month_invoice,
       sum_of_total,
       sum_of_price
FROM
  (SELECT EXTRACT(MONTH FROM CAST(invoice_date AS date)) AS month_invoice,
          SUM(total) AS sum_of_total
   FROM chinook.invoice
   WHERE EXTRACT(YEAR
                 FROM CAST(invoice_date AS date)) = 2010
   GROUP BY month_invoice) AS t_1
INNER JOIN
  (SELECT EXTRACT(MONTH FROM CAST(invoice_date AS date)) AS month_invoice,
          SUM(unit_price*quantity) AS sum_of_price
   FROM chinook.invoice AS i
   LEFT JOIN chinook.invoice_line AS il ON i.invoice_id = il.invoice_id
   WHERE EXTRACT(YEAR
                 FROM CAST(invoice_date AS date)) = 2010
   GROUP BY month_invoice) AS t_2 ON t_1.month_invoice = t_2.month_invoice; 

