/*Задание 2
Создайте материализованное представление, которое покажет, 
как изменяется средний чек для каждого заведения от года к году 
за все года за исключением 2023 года. 
Все столбцы со средним чеком округлите до второго знака после запятой.*/

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