Отберите названия уникальных категорий фильмов, в которых снималась Эмили Ди (англ. Emily Dee).

SELECT DISTINCT c.name
FROM chinook.film_actor AS fa
LEFT JOIN chinook.film_category AS fcat ON fcat.film_id = fa.film_id
LEFT JOIN chinook.actor AS a ON a.actor_id = fa.actor_id
LEFT JOIN chinook.category AS c ON c.category_id = fcat.category_id
WHERE a.first_name = 'Emily' AND a.last_name = 'Dee' 


На очереди — сотрудники (таблица staff). У некоторых сотрудников есть менеджеры — их идентификаторы указаны в поле reports_to. 
Посмотрите внимательно на схему базы: таблица staff отсылает сама к себе. Это нормально, можно не создавать новую таблицу с менеджерами. 
Разберёмся в иерархии команды. Отобразите таблицу с двумя полями: в первое поле внесите фамилии всех сотрудников, 
а во второе — фамилии их менеджеров. Назовите поля employee_last_name и manager_last_name.

SELECT s.last_name AS employee_last_name, manager.last_name as manager_last_name
FROM chinook.staff as s
LEFT JOIN chinook.staff as manager ON s.reports_to = manager.employee_id