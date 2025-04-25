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