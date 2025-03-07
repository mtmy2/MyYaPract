1.
Выведите названия всех треков, добавив информацию о датах, когда эти треки покупали. Важно, чтобы в выборку вошли все треки — даже если их никто не купил. 
Чтобы получить нужный результат, надо соединить три таблицы, ведь таблица invoice, которая хранит данные о дате заказа, не содержит информации о купленных треках.
Краткий алгоритм решения:
Соедините таблицы track и invoice_line по ключу track_id.
Присоедините таблицу invoice по ключу invoice_id.
В итоговую таблицу поместите два поля: name из таблицы track и invoice_date из таблицы invoice.
Приведите дату к нужному формату.


SELECT t.name, CAST(i.invoice_date AS DATE) -- поместите поле с датой
FROM chinook.track AS t -- определите левую таблицу
LEFT JOIN chinook.invoice_line AS il ON t.track_id IS NOT DISTINCT FROM il.track_id
LEFT JOIN chinook.invoice AS i ON il.invoice_id IS NOT DISTINCT FROM i.invoice_id -- определите вариант присоединения первой таблицы
-- определите вариант присоединения второй таблицы;


2.
Отобразите названия фильмов, в которых снимались актёры и актрисы, не указанные в базе.

SELECT m.title
FROM chinook.movie AS m
LEFT JOIN chinook.film_actor AS fa on m.film_id = fa.film_id
WHERE actor_id is NULL


3.
Отобразите на экране имена исполнителей, для которых в базе данных не нашлось ни одного музыкального альбома. Чтобы написать запрос, используйте NATURAL JOIN.

SELECT a.name
FROM chinook.artist AS a
NATURAL LEFT JOIN chinook.album AS al
WHERE album_id is NULL

