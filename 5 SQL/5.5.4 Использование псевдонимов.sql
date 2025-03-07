SELECT 
    c.surname,
    c.name,
    pr.name,
    pr.type
FROM star.clients c
INNER JOIN star.purchases pu ON c.id = pu.client_id  -- у нас 2 таблицы на букву p, поэтому pu
INNER JOIN star.products pr ON pu.product_id = pr.id;  -- а тут pr


SELECT * FROM my_super_table mst;


SELECT * FROM my_super_table AS mst;


Соединение таблицы с самой собой
Иногда псевдонимы используют не для удобства, а по необходимости — бывают ситуации, 
когда запрос можно написать только с псевдонимами, а без них не получится. 
Например, когда таблица соединяется сама с собой. 
Разберём на примере. Создадим таблицу менеджеров. 
Некоторые из них могут быть руководителями других менеджеров:

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name character varying NOT NULL, -- имя
    manager_id integer  -- ссылка на руководителя
);

Выполним запрос, который получит всех руководителей и их подчинённых. 
Для этого надо присвоить таблице people два разных псевдонима, 
а затем соединить её с самой собой и прописать условие соединения.

SELECT manager.name AS manager_name, subordinate.name AS subordinate_name
FROM people AS manager 
INNER JOIN people AS subordinate ON manager.id = subordinate.manager_id;



SELECT *
FROM star.clients p 
INNER JOIN star.purchases c 
ON p.id = c.client_id;



SELECT *
FROM star.clients AS purchases 
INNER JOIN star.purchases AS clients 
ON purchases.id = clients.client_id;



SELECT c.id, p.surname, c.name, p.phone
FROM star.clients c
JOIN star.clients p 
ON c.id = p.id;
