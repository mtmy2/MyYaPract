SELECT *  -- здесь можно перечислить отдельные столбцы или вычисляемые выражения
FROM left_table 
[уточнение_типа_соединения] JOIN right_table  -- уточнение опционально
ON условие_соединения;


SELECT *
FROM left_table
JOIN right_table
ON left_table.id = right_table.foreigh_key_id;



Внутреннее соединение INNER JOIN можно получить и как декартово произведение таблиц с фильтром WHERE, 
где строки, для которых условие истинно, войдут в результирующую выборку. 

SELECT *
FROM left_table, right_table
WHERE left_table.id = right_table.foreigh_key_id;


SELECT *
FROM star.clients, star.purchases 
WHERE clients.id = purchases.client_id;


SELECT *
FROM star.clients
INNER JOIN star.purchases
ON clients.id = purchases.client_id;


Первый способ — на месте таблицы purchases написать ещё одно выражение INNER JOIN между таблицами purchases и products. Например: 

SELECT *
FROM star.clients
INNER JOIN (star.purchases INNER JOIN star.products ON purchases.product_id = products.id)
ON clients.id = purchases.client_id;


В нём таблицы соединяют последовательно: сначала указывают пару таблиц и их условие соединения, 
потом к получившемуся результату добавляют ещё одну таблицу с очередным условием, 
потом ещё одну и так далее, пока не кончатся таблицы, которые надо соединить. 

SELECT *
FROM star.clients
JOIN star.purchases ON clients.id = purchases.client_id
JOIN star.products ON purchases.product_id = products.id;


SELECT 
    clients.surname,
    clients.name,
    products.name,
    products.type
FROM star.clients
JOIN star.purchases ON clients.id = purchases.client_id
JOIN star.products ON purchases.product_id = products.id;


Если названия столбцов уникальны для соединённой таблицы (как surname и type в примере выше), 
то запрос отработает и без указания исходных таблиц после SELECT:

SELECT surname, type FROM ...


Для столбцов с неуникальными именами обязательно надо указать исходную таблицу:

SELECT surname, type, products.name FROM ...


Чтобы узнать пользователей, которые ничего не купили, 
надо присоединить к таблице с клиентами таблицу с покупками, 
а затем отфильтровать полученную таблицу по принципу «где покупки отсутствуют».

SELECT *
FROM star.clients
LEFT JOIN star.purchases
ON clients.id = purchases.client_id
WHERE purchases.id IS NULL;



SELECT products.*
FROM star.products
LEFT JOIN star.purchases
ON purchases.product_id = products.id
WHERE purchases.product_id is NULL;