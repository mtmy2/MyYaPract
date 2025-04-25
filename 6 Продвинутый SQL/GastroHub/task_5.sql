/*Задание 5
Найдите самую дорогую пиццу для каждой пиццерии.*/

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