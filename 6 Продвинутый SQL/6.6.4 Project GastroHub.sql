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

-- Таблица restaurants
INSERT INTO cafe.restaurants (name, type)
SELECT DISTINCT cafe_name, TYPE::cafe.restaurant_type
FROM raw_data.sales s;

-- Таблица managers
INSERT INTO cafe.managers (name, phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales s;

-- Таблица cafe.restaurant_manager_work_dates
INSERT INTO cafe.restaurant_manager_work_dates 
	(
	restaurant_uuid,
	manager_uuid,
	start_date,
	end_date
	)
SELECT 
	r.restaurant_uuid AS restaurant_uuid, 
	m.manager_uuid AS manager_uuid,
	min(s.report_date),
	max(s.report_date)
FROM cafe.managers m CROSS JOIN cafe.restaurants r
LEFT JOIN raw_data.sales s 
ON (r.name = s.cafe_name AND m.name = s.manager)
WHERE s.report_date IS NOT NULL
GROUP BY r.restaurant_uuid, m.manager_uuid;

-- Таблица cafe.sales
INSERT INTO cafe.sales 
	(
	date,
	restaurant_uuid,
	avg_check
	)
SELECT
	s.report_date,
	r.restaurant_uuid, 
	sum(s.avg_check)
FROM raw_data.sales AS s
LEFT JOIN cafe.restaurants AS r 
ON (r.name = s.cafe_name)
GROUP BY s.report_date, r.restaurant_uuid;



/*Этап 2. Создание представлений и написание аналитических запросов
Дополнительные таблицы готовы, теперь — пора представлений и запросов.

Задание 1
Чтобы выдать премию менеджерам, нужно понять, 
у каких заведений самый высокий средний чек. 
Создайте представление, которое покажет топ-3 заведения внутри каждого 
типа заведений по среднему чеку за все даты. 
Столбец со средним чеком округлите до второго знака после запятой.*/

CREATE VIEW cafe.tops_cafe AS
	WITH ranged_cafes AS (	
		SELECT 
			r.name, 
			r.TYPE,
			round(avg(s.avg_check)) AS avg,
			ROW_NUMBER() OVER (PARTITION BY r.TYPE ORDER BY round(avg(s.avg_check)) DESC) AS ranged
		FROM cafe.restaurants AS r
		LEFT JOIN cafe.sales AS s 
		USING(restaurant_uuid)
		GROUP BY r.type, r.name
		ORDER BY r.TYPE
		)
	SELECT 
		name AS Название_заведения,
		TYPE AS Тип_заведения,
		avg AS Средний_чек
	FROM ranged_cafes
	WHERE ranged >=1 AND ranged <=3;


Задание 2
Создайте материализованное представление, которое покажет, 
как изменяется средний чек для каждого заведения от года к году 
за все года за исключением 2023 года. 
Все столбцы со средним чеком округлите до второго знака после запятой.

CREATE MATERIALIZED VIEW cafe.avg_per_years AS
WITH grouped_per_year AS (	
	SELECT 
		EXTRACT(YEAR FROM s.date) AS Year, 
		r.name,
		r.TYPE,
		round(avg(s.avg_check), 2) AS Current_year
	FROM cafe.sales AS s
	LEFT JOIN cafe.restaurants AS r 
	USING(restaurant_uuid)
	GROUP BY r.name, r.TYPE, EXTRACT(YEAR FROM s.date)
	ORDER BY EXTRACT(YEAR FROM s.date)
	)
SELECT 
	*,
	lag(Current_year) OVER (PARTITION BY name ORDER BY Year) AS Previous_year,
	round((Current_year - (lag(Current_year) OVER (PARTITION BY name ORDER BY Year)))/Current_year*100,2) AS Change
FROM grouped_per_year;


