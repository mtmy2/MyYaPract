/* Исходнфе данные */

CREATE SCHEMA raw_data;

CREATE TABLE raw_data.sales (
	id INTEGER PRIMARY KEY,
	auto VARCHAR,
	gasoline_consumption NUMERIC(3, 1),
	price NUMERIC(9, 2),
	date DATE,
	person_name VARCHAR,
	phone VARCHAR,
	discount INTEGER,
	brand_origin VARCHAR
);

COPY raw_data.sales FROM 'D:\YaPract\CARS.CSV' WITH CSV DELIMITER ',' NULL 'null' HEADER;




/* Создание структуры */

CREATE SCHEMA car_shop;

CREATE TABLE car_shop.brand_origin (
	id serial PRIMARY KEY,
	brand_origin varchar UNIQUE -- название страны в тектсовом виде 
);

CREATE TABLE car_shop.brand (
	id serial PRIMARY KEY,
	brand_name varchar NOT NULL UNIQUE, -- название страны в тектсовом виде
	brand_origin_id SMALLINT -- список стран будет коротким
);

CREATE TABLE car_shop.colour (
	id serial PRIMARY KEY,
	colour varchar NOT NULL UNIQUE -- цвет в виде текста, уникальный, не пустой
);

CREATE TABLE car_shop.model (
	id serial PRIMARY KEY,
	brand_id integer NOT NULL,
	model_name varchar NOT NULL, -- модель в виде текста, не пустой, возможно может повторяться у разных бренодов
	gasoline_consumption numeric(3, 1) -- двзначное число с дробной частью
);

CREATE TABLE car_shop.auto (
	id serial PRIMARY KEY,
	brand_id integer NOT NULL,
	model_id integer NOT NULL,
	colour_id integer NOT NULL
);


CREATE TABLE car_shop.clients (
	id serial PRIMARY KEY,
	first_name varchar NOT NULL, -- имя в виде текста, не пустой
	last_name varchar NOT NULL, -- фамилия в виде текста, не пустой
	phone varchar -- телефон в виде текста, может быть пустым
);


CREATE TABLE car_shop.sales (
	id serial PRIMARY KEY,
	auto_id integer,
	price numeric(9,2) NOT NULL CHECK(price>=0), -- число до 7 занков и 2 знаков после запятой, проверка неотрицательных значений
	date date NOT NULL DEFAULT CURRENT_DATE, -- дата, не путстая, по умолчанию текущая дата при создании записи
	client_id integer, 
	discount SMALLINT NOT NULL CHECK(discount >=0 AND discount <= 100) -- число от 0 до 100, не путое
);




/* Заполнение данными */

INSERT INTO car_shop.brand_origin (brand_origin)
SELECT DISTINCT brand_origin FROM raw_data.sales;



