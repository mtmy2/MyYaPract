/*Задание 1
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