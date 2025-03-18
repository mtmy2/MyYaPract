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
	prefix varchar, -- префикс в виде текста, может быть путсым
	first_name varchar NOT NULL, -- имя в виде текста, не пустой
	last_name varchar NOT NULL, -- фамилия в виде текста, не пустой
	jr varchar, -- приставка Jr. там где нобходима
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

/*заполнение таблицы brand_origin*/
INSERT INTO car_shop.brand_origin (brand_origin)
SELECT DISTINCT brand_origin FROM raw_data.sales;

-- TRUNCATE TABLE car_shop.model RESTART IDENTITY

/*заполнение таблицы brand*/
INSERT INTO car_shop.brand (brand_name, brand_origin_id)
SELECT DISTINCT 
	SPLIT_PART(s.auto, ' ', 1), 
	bo.id
FROM raw_data.sales AS s
INNER JOIN car_shop.brand_origin AS bo USING(brand_origin)

/*заполнение таблицы model*/
INSERT INTO car_shop.model (brand_id, model_name, gasoline_consumption)
SELECT DISTINCT 
	b.id,
	SUBSTR(SPLIT_PART(s.auto, ',', 1), STRPOS(SPLIT_PART(s.auto, ',', 1), ' ')+1), 
	s.gasoline_consumption
FROM raw_data.sales AS s
LEFT JOIN car_shop.brand AS b ON b.brand_name = SPLIT_PART(s.auto, ' ', 1);


/*заполнение таблицы colour*/
INSERT INTO car_shop.colour (colour)
SELECT DISTINCT 
	TRIM(SPLIT_PART(s.auto, ',', 2))
FROM raw_data.sales AS s


/*заполнение таблицы auto*/
INSERT INTO car_shop.auto (brand_id, model_id, colour_id)
SELECT 
	b.id,
	m.id,
	c.id
FROM raw_data.sales AS s
LEFT JOIN car_shop.brand AS b ON b.brand_name = SPLIT_PART(s.auto, ' ', 1)
LEFT JOIN car_shop.model AS m ON m.model_name = SUBSTR(SPLIT_PART(s.auto, ',', 1), STRPOS(SPLIT_PART(s.auto, ',', 1), ' ')+1)
LEFT JOIN car_shop.colour AS c ON c.colour = TRIM(SPLIT_PART(s.auto, ',', 2));


/*заполнение таблицы clients*/
INSERT INTO car_shop.clients (prefix, first_name, last_name, jr, phone)
SELECT DISTINCT 
	CASE 
		WHEN SPLIT_PART(s.person_name, '. ', 2) = '' THEN NULL
		WHEN SPLIT_PART(s.person_name, '. ', 2) <> '' THEN SPLIT_PART(s.person_name, '. ', 1) || '.'
	END,
	CASE 
		WHEN SPLIT_PART(s.person_name, '. ', 2) = '' THEN SPLIT_PART(SPLIT_PART(s.person_name, '. ', 1), ' ', 1)
		WHEN SPLIT_PART(s.person_name, '. ', 2) <> '' THEN SPLIT_PART(SPLIT_PART(s.person_name, '. ', 2), ' ', 1)
	END,
	CASE 
		WHEN SPLIT_PART(s.person_name, '. ', 2) = '' THEN SPLIT_PART(SPLIT_PART(s.person_name, '. ', 1), ' ', 2)
		WHEN SPLIT_PART(s.person_name, '. ', 2) <> '' THEN SPLIT_PART(SPLIT_PART(s.person_name, '. ', 2), ' ', 2)
	END,
	CASE 
		WHEN STRPOS(s.person_name, 'Jr.') > 0 THEN 'Jr.'
		ELSE NULL 
	END,
	s.phone
FROM raw_data.sales AS s;


/*заполнение таблицы sales*/
INSERT INTO car_shop.sales (auto_id, price, date, client_id, discount)
SELECT 
	a.id,
	s.price,
	s.date,
	cl.id,
	s.discount
FROM raw_data.sales AS s
LEFT JOIN car_shop.brand AS b ON b.brand_name = SPLIT_PART(s.auto, ' ', 1)
LEFT JOIN car_shop.model AS m ON m.model_name = SUBSTR(SPLIT_PART(s.auto, ',', 1), STRPOS(SPLIT_PART(s.auto, ',', 1), ' ')+1)
LEFT JOIN car_shop.colour AS c ON c.colour = TRIM(SPLIT_PART(s.auto, ',', 2))
LEFT JOIN car_shop.auto AS a ON a.brand_id = b.id AND a.model_id = m.id AND a.colour_id = c.id
LEFT JOIN car_shop.clients AS cl ON POSITION(cl.first_name || cl.last_name IN REPLACE(s.person_name, ' ', ''))>0
; 



