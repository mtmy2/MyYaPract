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

CREATE SCHEMA car_shop;

CREATE TABLE car_shop.brand_origin (
	id serial PRIMARY KEY,
	brand_origin varchar UNIQUE
);

CREATE TABLE car_shop.brand (
	id serial PRIMARY KEY,
	brand_name varchar NOT NULL UNIQUE,
	brand_origin_id SMALLINT
);

CREATE TABLE car_shop.colour (
	id serial PRIMARY KEY,
	colour varchar NOT NULL UNIQUE
);

CREATE TABLE car_shop.model (
	id serial PRIMARY KEY,
	brand_id integer NOT NULL,
	model_name varchar NOT NULL,
	gasoline_consumption numeric(3, 1)
);

CREATE TABLE car_shop.auto (
	id serial PRIMARY KEY,
	brand_id integer NOT NULL,
	model_id integer NOT NULL,
	colour_id integer NOT NULL
);


CREATE TABLE car_shop.clients (
	id serial PRIMARY KEY,
	first_name varchar NOT NULL,
	last_name varchar NOT NULL,
	phone varchar
);


CREATE TABLE car_shop.sales (
	id serial PRIMARY KEY,
	auto_id integer,
	price numeric(9,2) NOT NULL CHECK(price>=0),
	date date NOT NULL DEFAULT CURRENT_DATE,
	client_id integer,
	discount SMALLINT NOT NULL CHECK(discount >=0 AND discount <= 100)
);