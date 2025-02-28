CREATE DATABASE market OWNER dba;

CREATE SCHEMA shop;

CREATE SCHEMA IF NOT EXISTS shop;
-- NOTICE:  schema "shop" already exists, skipping CREATE SCHEMA



CREATE TABLE <схема>.<имя таблицы> (
    <имя поля 1> <тип поля 1>,
    <имя поля 2> <тип поля 2>,
    ....
    <имя поля n> <тип поля n>
);


CREATE SCHEMA IF NOT EXISTS office;


CREATE TABLE office.users (
    name VARCHAR,
    email VARCHAR,
    phone VARCHAR,
    birthday DATE,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);


SELECT name FROM users WHERE created_at >= '2023-01-01 00:00:00'; 


CREATE TABLE cars (
    model VARCHAR,
    number VARCHAR,
    manufacturer_code INTEGER,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);



SELECT
    model,
    number,
    manufacturer_code 
FROM cars
WHERE manufacturer_code = 99;



CREATE TABLE drivers (
    name VARCHAR,
    birthday DATE,
    license_type VARCHAR,
    license_number VARCHAR,
    employed_from DATE,
    dismissed_at DATE
);



CREATE TABLE sandbox.products (
    id SMALLINT,
    name VARCHAR,
    description TEXT,
    category CHARACTER VARYING,
    price NUMERIC,
    amount INTEGER,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);