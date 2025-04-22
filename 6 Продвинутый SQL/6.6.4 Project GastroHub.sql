/* Этап 1. Создание дополнительных таблиц*/

--содание схемы
CREATE SCHEMA cafe;

/*Шаг 1. Создайте enum cafe.restaurant_type с типом заведения coffee_shop, restaurant, bar, pizzeria. */
CREATE type cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

/*Шаг 2. Создайте таблицу cafe.restaurants с информацией о ресторанах. 
В качестве первичного ключа используйте случайно сгенерированный uuid. 
Таблица хранит: restaurant_uuid, название заведения, 
тип заведения, который вы создали на первом шаге, и меню.*/
CREATE TABLE cafe.restaurants
	(restaurant_uuid UUID DEFAULT GEN_RANDOM_UUID(),
	name varchar NOT NULL UNIQUE,
	type cafe.restaurant_type);
	
/*Шаг 3. Создайте таблицу cafe.managers с информацией о менеджерах. 
В качестве первичного ключа используйте случайно сгенерированный uuid. 
Таблица хранит: manager_uuid, имя менеджера и его телефон.*/
CREATE TABLE cafe.managers
	(manager_uuid UUID DEFAULT GEN_RANDOM_UUID(),
	name varchar NOT NULL,
	phone varchar);
	
/*Шаг 4. Создайте таблицу cafe.restaurant_manager_work_dates. 
Таблица хранит: restaurant_uuid, manager_uuid, дату начала работы в ресторане и дату окончания работы в ресторане 
(придумайте названия этим полям). 
Задайте составной первичный ключ из двух полей: restaurant_uuid и manager_uuid. 
Работа менеджера в ресторане от даты начала до даты окончания — единый период, без перерывов.*/
CREATE TABLE cafe.restaurant_manager_work_dates
	(restaurant_uuid UUID NOT NULL, 
	manager_uuid UUID NOT NULL,
	start_date DATE NOT NULL,
	end_date DATE NOT NULL,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
	);
	

/*Шаг 5. Создайте таблицу cafe.sales со столбцами: 
date, restaurant_uuid, avg_check. 
Задайте составной первичный ключ из даты и uuid ресторана.*/
CREATE TABLE cafe.sales
	(date date NOT NULL, 
	restaurant_uuid UUID NOT NULL,
	avg_check NUMERIC NOT NULL,
	PRIMARY KEY (date, restaurant_uuid)
	);
	
/*Шаг 6. Наполните все созданные таблицы данными, которые хранятся в дампе.*/
