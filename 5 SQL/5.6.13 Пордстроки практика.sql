1.
Подсчитайте количество альбомов из таблицы album, в названии которых больше 10 символов.

SELECT COUNT(*)-- подсчитайте количество альбомов  
FROM  chinook.album
WHERE LENGTH(chinook.album.title) >10 -- сформируйте корректное условие отбора необходимых альбомов 
      -- по количеству символов в названии


2.
Потренируйтесь создавать новую строку при объединении нескольких строк. Для каждого сотрудника из таблицы staff выгрузите почтовый адрес для отправки корреспонденции. 
Назовите поле post_address. Почтовый адрес отформатируйте так: Имя Фамилия, адрес, город, штат индекс, СТРАНА.
Обратите внимание на разделители: одни значения разделяются запятой, другие — простым пробелом. 
Чтобы адрес выглядел корректно, имя и фамилию пропишите с заглавной буквы, 
а название страны в верхнем регистре. Чтобы соединить строки, примените функцию CONCAT.

SELECT CONCAT(INITCAP(first_name),' ', INITCAP(last_name), ', ', address, ', ', city, ', ', state, ' ', postal_code, ', ', UPPER(country)) -- сформируйте поле post_address с необходимым оформлением
FROM chinook.staff 



3.
Выведите уникальные значения доменов из поля email таблицы client в новом поле domain_name. 
Значения выведите в формате name.domain — например, yahoo.de. Используйте функции STRPOS и SUBSTR.

SELECT DISTINCT SUBSTR(email, STRPOS(email, '@')+1) AS domain_name -- сформируйте поля с необходимым оформлением
FROM chinook.client;


4.
Перечислите через запятую с пробелом названия всех фильмов (поле title) из таблицы movie для каждой категории фильмов (поле name) из таблицы category. 
Выберите все фильмы, которые относятся к каждой категории, и выведите их в новом поле movies. 
Отсортируйте фильмы в алфавитном порядке. Чтобы связать название фильма и категорию, используйте таблицу film_category.

SELECT
      c.name,
      STRING_AGG(m.title, ', ' ORDER BY m.title) AS movies
FROM chinook.movie AS m
INNER JOIN chinook.film_category AS fc ON m.film_id = fc.film_id
INNER JOIN chinook.category AS c USING (category_id)
GROUP BY c.name

