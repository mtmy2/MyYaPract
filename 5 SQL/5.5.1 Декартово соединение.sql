create schema if not exists star;
create table star.clients (
    id serial primary key,
    surname text not NULL,
    name text not null,
    phone text
);


DROP SCHEMA IF EXISTS star CASCADE;
CREATE SCHEMA IF NOT EXISTS star;
CREATE TABLE IF NOT EXISTS star.clients (
    id SERIAL PRIMARY KEY,
    surname TEXT NOT NULL, -- фамилия покупателя
    name TEXT NOT NULL, -- имя покупателя
    phone TEXT -- телефон покупателя
);

create table if not exists star.products (
    id serial primary key,
    name text,
    type text
);




DROP SCHEMA IF EXISTS star CASCADE;
CREATE SCHEMA IF NOT EXISTS star;
CREATE TABLE IF NOT EXISTS star.clients (
    id SERIAL PRIMARY KEY,
    surname TEXT NOT NULL, -- фамилия покупателя
    name TEXT NOT NULL, -- имя покупателя
    phone TEXT -- телефон покупателя
);
CREATE TABLE star.products (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL, -- наименование товара
    type TEXT NOT NULL -- тип товара
);
create table star.purchases (
    id serial primary key,
    client_id integer references star.clients(id),
    product_id integer references star.products(id)
);


Чтобы получить декартово произведение таблиц в SQL, можно просто перечислить их через запятую в выражении FROM:

SELECT * FROM star.clients, star.products;


Более предпочтительный и понятный для другого инженера данных вариант — использовать выражение CROSS JOIN (пер. с англ. — перекрёстное соединение).

SELECT * FROM star.clients CROSS JOIN star.products;




Это корректный запрос, в котором используется перекрёстное соединение. 
Он может быть выполнен даже в пустой БД PostgreSQL. 
Не выполняя запрос, попробуйте определить, какой получится результат. 

SELECT number1 * number2
FROM 
    (VALUES (9)) AS nums1 (number1),
    (VALUES (1),(2),(3)) AS nums2 (number2);
   
Три строки с числами 9, 18, 27.
Здесь использовано перекрёстное соединение, значит, количество строк считается перемножением количества исходных строк, получится: 
$1 \cdot 3 = 3$ строки. В SELECT написано умножение, значит, числа перемножатся. 
В итоге получится три строки с числами 9, 18, 27.








