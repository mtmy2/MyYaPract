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
	type cafe.restaurant_type,
	menu jsonb);
	
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
INSERT INTO cafe.restaurants (name, type, menu)
SELECT DISTINCT cafe_name, TYPE::cafe.restaurant_type, m.menu
FROM raw_data.sales s
LEFT JOIN raw_data.menu m USING (cafe_name);

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


/*Задание 3
Найдите топ-3 заведения, где чаще всего менялся менеджер за весь период.*/

SELECT 
	r.name,
	count(*)
FROM cafe.restaurant_manager_work_dates
LEFT JOIN cafe.restaurants AS r 
USING(restaurant_uuid)
GROUP BY r.name
ORDER BY count(*) DESC
LIMIT 3


/*Задание 4
Найдите пиццерию с самым большим количеством пицц в меню. Если таких пиццерий несколько, выведите все.*/

WITH pizzas_cafe AS (
	SELECT 
		name,
		jsonb_each(menu -> 'Пицца') AS pizza
	FROM cafe.restaurants
	GROUP BY name, pizza
	),
	pizzas_count AS (
	SELECT
		name,
		count(*) AS pizza_count,
		DENSE_RANK() OVER(ORDER BY count(*) DESC) AS cafe_rank
	FROM pizzas_cafe
	GROUP BY name
	ORDER BY pizza_count DESC)
SELECT 
	name,
	pizza_count
FROM pizzas_count
WHERE pizza_count = (SELECT max(pizza_count) FROM pizzas_count)




Задание 5
Найдите самую дорогую пиццу для каждой пиццерии.

WITH pizzas_ranged_price AS (
	SELECT 
		DISTINCT name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Пицца')::text, ',', 1), '(""')::text AS pizza_name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Пицца')::text, ',', 2), ')')::integer AS pizza_price,
		DENSE_RANK() OVER(PARTITION BY name ORDER BY TRIM(SPLIT_PART(jsonb_each(menu -> 'Пицца')::text, ',', 2), ')')::integer DESC) AS price_rank
	FROM cafe.restaurants
	GROUP BY name, pizza_name, pizza_price)
SELECT
	name,
	'Пицца' AS type,
	pizza_name,
	pizza_price
FROM pizzas_ranged_price
WHERE price_rank = 1
ORDER BY pizza_price DESC;


Задание 6
В Gastro Hub решили проверить новую продуктовую гипотезу и поднять цены на капучино. 
Маркетологи компании собрали совещание, чтобы обсудить, на сколько стоит поднять цены. 
В это время для отчётности использовать старые цены нельзя. После обсуждения решили увеличить цены на капучино на 20%.
Обновите данные по ценам так, чтобы до завершения обновления никто не вносил других изменений в цены этих заведений. 
В заведениях, где цены не меняются, данные о меню должны остаться в полном доступе.
Поясните принятое решение в комментариях к скрипту.

BEGIN;

WITH bavereges AS (
	SELECT -- создаем таблицу с напитками с отдельным столбцом для цены. столбцы название кафе, название напитка, цена
		DISTINCT name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Кофе')::text, ',', 1), '(""')::text AS coffe_name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Кофе')::text, ',', 2), ')')::integer AS coffe_price
	FROM cafe.restaurants
	GROUP BY name, coffe_name, coffe_price
	)
new_price AS (
	SELECT --из предыдущей таблицы делаем срез по напитку Капучино и увеличиваем цену в 1.2 раза
		name,
		coffe_name,
		coffe_price * 1.2 AS cappucino_new_price
	FROM bavereges
	WHERE coffe_name = 'Капучино'
	FOR UPDATE) -- для блокировки данных строк используем исключительную блокировку на время транзакции
UPDATE cafe.restaurants AS r
SET menu = jsonb_set(menu, '{Кофе, Капучино}', np.cappucino_new_price::text) -- вставляем новую цену в меню в те строки где есть капучино
FROM new_price AS np
WHERE np.name=r.name;

COMMIT;