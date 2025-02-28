SELECT <столбец 1>, <столбец 2>, … <столбец n> 
FROM <имя таблицы> 
WHERE <условие> -- не обязательно
ORDER BY <параметр сортировки 1>, <параметр сортировки 2>, 
         ... <параметр сортировки n>;


SELECT name FROM office.users ORDER BY name ASC;

SELECT name, amount, price FROM store.products ORDER BY amount DESC, price ASC;


SELECT id, name, birthday FROM office.users ORDER BY birthday DESC NULLS LAST;


SELECT name, price 
FROM store.products 
-- отсортирует по убыванию цены (не забудьте поместить NULLS в конец)
ORDER BY price DESC NULLS LAST 
-- из отсортированного списка возьмёт три первых строки
LIMIT 3; 

SELECT name, birthday 
FROM office.users 
ORDER BY birthday ASC -- отсортирует пользователей по дате рождения
LIMIT 1 -- возьмёт одного старейшего пользователя;



SELECT name, price 
FROM store.products
-- отфильтрует товары, в которых цена не указана
WHERE price IS NOT NULL
-- отсортирует по возрастанию цены
ORDER BY price ASC
-- из отсортированного списка выведет все товары за исключением
-- первых десяти
OFFSET 10; 


SELECT name, description
FROM store.products 
ORDER BY name ASC -- отсортирует по имени
LIMIT 30; -- возьмёт первые 30 записей для первой страницы



SELECT name, description
FROM store.products 
ORDER BY name ASC -- отсортирует по имени
OFFSET 30 -- пропустит первые 30 строк, показанных на первой странице
LIMIT 30; -- возьмёт следующие 30 записей для второй страницы
