-- наименования товаров, отсутствующих на складе или удалённых
SELECT name FROM store.products WHERE amount = 0 OR deleted_at IS NOT NULL;

-- имена и телефоны пользователей, родившихся в 1973 году
SELECT name, phone 
FROM office.users 
WHERE birthday >= '1973-01-01' AND birthday <= '1973-12-31';

-- наименования товаров в категориях "Аксессуары для телефонов" или "Модные аксессуары"  
SELECT name 
FROM store.products 
WHERE category = 'Аксессуары для телефонов' OR category = 'Модные аксессуары';

/*
наименования всех товаров, 
кроме категорий "«Аксессуары для телефонов" или "Модные аксессуары"  
*/
SELECT name 
FROM store.products 
WHERE NOT (
    category = 'Аксессуары для телефонов' OR 
    category = 'Модные аксессуары'
);



SELECT name, amount 
FROM store.products 
WHERE 
    (category = 'Аксессуары для телефонов' OR category = 'Модные аксессуары')
    AND
    amount > 0;



/*
наименования товаров 
в категориях "Аксессуары для телефонов" или "Модные аксессуары" 
*/ 
SELECT name 
FROM  store.products 
WHERE category IN ('Аксессуары для телефонов', 'Модные аксессуары');

/*
наименования всех товаров 
кроме категорий "Аксессуары для автомобилей" и "Разное"
*/
SELECT name 
FROM store.products 
WHERE category NOT IN ('Аксессуары для автомобилей', 'Разное');

/*
имена и телефоны пользователей, родившихся в 1973 году
*/
SELECT name, phone 
FROM office.users 
WHERE birthday BETWEEN '1973-01-01' AND  '1973-12-31';




<строка> LIKE <шаблон>;
<строка> NOT LIKE <шаблон>;


/*

выберите товары, в описании которых
есть слово бежевый/ая/ое 
для поиска используйте шаблон '%бежев%',
совпадающий со всеми формами слова
*/
SELECT name 
FROM store.products 
WHERE description LIKE '%бежев%';

/*
если, наоборот, нужно найти все товары, 
кроме бежевых, примените
оператор NOT LIKE 
*/

SELECT name 
FROM store.products 
WHERE description NOT LIKE '%бежев%';


SELECT name, description, price
FROM store.products 
WHERE name LIKE '%Ремешок%';


SELECT name, description, price
FROM store.products 
WHERE name LIKE '%Ремешок%' OR description LIKE '%Ремешок%';


SELECT name, description, price
FROM  store.products 
WHERE name ILIKE '%Ремешок%' OR description ILIKE '%Ремешок%';