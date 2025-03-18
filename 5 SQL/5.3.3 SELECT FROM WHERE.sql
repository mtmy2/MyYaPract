SELECT <столбец 1>, <столбец 2>, … <столбец n> 
FROM <имя таблицы>;


SELECT name, phone FROM office.users;

SELECT * FROM <имя таблицы>;



SELECT <столбец 1>, <столбец 2>, … <столбец n> 
FROM <имя таблицы> 
WHERE <условие>;


SELECT phone 
FROM office.users 
WHERE name = 'Иванов Иван Иванович';


-- наименования товаров, количество которых больше нуля  
SELECT name FROM store.products WHERE amount > 0;

-- наименования и количество товаров, цена которых больше или равна 100  
SELECT name, amount FROM store.products WHERE price >= 100;

-- имена и дни рождения пользователей, у которых отсутствует дата удаления
SELECT name, birthday FROM office.users WHERE deleted_at IS NULL; 



SELECT name, price FROM store.products WHERE category = 'Напитки';


SELECT name FROM office.users WHERE birthday IS NOT NULL;