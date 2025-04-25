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