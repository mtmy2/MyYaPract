1.
Перед открытием интернет-магазин Chinook наполняли данными с помощью импортёра-обработчика. 
Импорт данных произошёл с неточностями. Так, в базе данных есть категория фильмов “Children”, 
но при импорте данных некоторые фильмы из этой категории получили рейтинг 'NC-17' (лица 17-летнего возраста и младше на фильм не допускаются). 
Дети и подростки не могут посмотреть часть контента. 
Чтобы дать возможность юным зрителям смотреть детские фильмы — у этих фильмов должен быть рейтинг 'R' (лица, не достигшие 17-летнего возраста, 
допускаются на фильм только в сопровождении одного из родителей либо законного представителя). 
Составьте команду UPDATE для смены рейтинга фильмов.

UPDATE chinook.movie AS m
    SET 
        rating = 'R'
FROM chinook.film_category AS fc
INNER JOIN chinook.category AS c USING (category_id)
WHERE 
    m.film_id = fc.film_id
    AND c.name = 'Children'
    AND m.rating = 'NC-17'; 

2.
В этом году юбилей у актёра Джонни Кейджа (англ. Johnny Cage). В юбилейной рекламной кампании участвует и интернет-магазин Chinook. 
В рамках кампании нужно дополнить описание фильмов, в которых принимал участие актёр, фразой 'Actor Johnny Cage takes part in the film.'. 
Составьте команду UPDATE, которая дополнит поле description в таблице movie фразой 'Actor Johnny Cage takes part in the film.', 
для фильмов, где принимал участие этот актёр.
Для решения задания вам пригодится строковая операция конкатенации ||:

text || text → text 
Выражение description || '. Actor Johnny Cage takes part in the film.' добавляет фразу справа, 
в результате получается нужная строка. В прекоде это уже есть.

UPDATE chinook.movie AS m
SET description = description || '. Actor Johnny Cage takes part in the film.'
-- допишите остальное;
FROM chinook.film_actor AS fa
INNER JOIN chinook.actor AS a USING (actor_id)
WHERE 
    m.film_id = fa.film_id
    AND a.first_name = 'Johnny'
    AND a.last_name = 'Cage'


3.
Стало известно, что трек Balls to the Wall был продан «в чудовищном качестве» — именно так описывают его разгневанные клиенты. 
15 ноября 2010 года трек в продаже заменили, но заменить уже проданный трек на трек с надлежащим качеством оказалось невозможно. 
Покупателям вернули деньги, осталось актуализировать базу данных. 
Начальник IT-службы дал указание удалить в таблице invoice_line записи о продажах, которые относятся к треку Balls to the Wall до его замены. 
Составьте команду DELETE для удаления этих записей из таблицы invoice_line.

DELETE FROM chinook.invoice_line AS il
USING chinook.invoice AS i, chinook.track AS t
WHERE 
    il.invoice_id = i.invoice_id
    AND t.track_id = il.track_id
    AND t.name = 'Balls to the Wall'
    AND i.invoice_date < '2010-11-15'

