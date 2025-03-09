1.
Посчитайте минимальный, максимальный и средний год выпуска фильмов (release_year) из таблицы movie. Средний год округлите до целого числа.

SELECT MIN(release_year), MAX(release_year), ROUND(avg(release_year)) From CHINOOK.MOVIE;





2.
Посчитайте, сколько пропусков содержит поле fax из таблицы client.
SELECT COUNT(*) FROM chinook.client as C WHERE C.FAX IS NULL



3.
В таблице media_type есть пять типов треков. Из них четыре относятся к аудио — содержат в поле media_type.name слово audio, 
— а один относится к видео: Protected MPEG-4 video file. Посчитайте, сколько стоит приобрести все видеотреки. 
Цена треков указана в столбце unit_price таблицы track.

SELECT SUM(unit_price) 
FROM chinook.track AS t
INNER JOIN chinook.media_type AS mt USING (media_type_id)
WHERE 
    mt.name = 'Protected MPEG-4 video file'

    