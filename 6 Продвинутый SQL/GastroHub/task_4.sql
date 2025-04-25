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