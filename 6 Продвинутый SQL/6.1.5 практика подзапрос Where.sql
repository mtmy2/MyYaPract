/*1.
В трёх первых заданиях вам нужно написать запрос для сравнения выручки в разных странах по заказам с определёнными условиями по такому алгоритму:
Написать подзапрос, который выгрузит заказы, где больше пяти треков.
Написать подзапрос, который найдёт среднее значение цены одного трека.
Объединить эти подзапросы в основной запрос, в котором станет известно минимальное, максимальное и среднее значение выручки для каждой страны.

В этом задании напишите код для первого подзапроса. 
Таблица invoice_line хранит информацию о купленных треках. 
Выгрузите из неё только те заказы (поле invoice_id), которые включают больше пяти треков.*/

SELECT il.invoice_id
from chinook.invoice_line as il
group by invoice_id
having count(il.invoice_id)>5 



/*2.
Теперь напишите код для второго подзапроса. С помощью той же таблицы (invoice_line) найдите среднее значение цены одного трека (поле unit_price).*/

select avg(il.unit_price)
from chinook.invoice_line as il

/*
3.
Объедините написанные запросы из предыдущих заданий в подзапросе и напишите основной запрос. Используйте в подзапросах код, написанный в предыдущих заданиях, он уже дан в прекоде. 
Для каждой страны (поле billing_country) посчитайте минимальное, максимальное и среднее значение выручки из поля total. 
Назовите поля так: min_total, max_total и avg_total, каждое из полей округлите до двух знаков после запятой. Нужные поля для выгрузки хранит таблица invoice.
При подсчёте учитывайте только те заказы, которые включают более пяти треков. Стоимость заказа должна превышать среднюю цену одного трека.
Отсортируйте итоговую таблицу по двум полям: сначала по значению в поле avg_total от большего к меньшему, затем по названию страны billing_country в алфавитном порядке.
Вот пример итоговой таблицы, которую нужно получить в результате запроса (страны и цифры приведены для наглядности, результат будет другим):*/

SELECT 
    i.billing_country,
    round(min(i.total), 2) as min_total,
    round(max(i.total), 2) as max_total,
    round(avg(i.total), 2) as avg_total
from chinook.invoice as i
where (i.total > (
    SELECT AVG(unit_price)
    FROM chinook.invoice_line
    ))
    and invoice_id in (
        SELECT invoice_id
        FROM chinook.invoice_line
        GROUP BY invoice_id
        HAVING COUNT(invoice_id) > 5
    )
group by i.billing_country   
order by avg_total desc, billing_country


/*
4.
Отберите два самых коротких по продолжительности трека и выгрузите названия их жанров.*/

select g.name
from chinook.genre as g
where g.genre_id in ( 
    select 
        t.genre_id
    from chinook.track as t
    order by t.milliseconds
    limit 2)


/*
5.
Выгрузите уникальные названия городов, в которых стоимость заказов превышает максимальное значение за 2009 год.*/

select
    distinct i.billing_city
from chinook.invoice as i
where total > (
    select max(i.total)
    from chinook.invoice as i
    where EXTRACT (YEAR FROM i.invoice_date::date) = 2009
)


/*6.
Посчитайте по категориям фильмов среднее значение продолжительности этих фильмов. Сделайте это только для тех фильмов, которые попадают в возрастной рейтинг с самыми дорогими для аренды фильмами.
Найдите возрастной рейтинг с самыми дорогими для аренды фильмами: посчитайте среднюю стоимость аренды фильмов (столбец rental_rate) каждого рейтинга из таблицы movie.
Отсортируйте значения в обратном порядке и возьмите название рейтинга из первой строки.
Выведите названия категорий фильмов с этим рейтингом.
Добавьте поле avg_length со средним значением продолжительности фильмов.
В результате должна получиться такая таблица (значения приведены для примера, результат будет другой):*/

select 
    c.name,
    avg(m.length) as avg_length
from chinook.movie as m
left join chinook.film_category as fc using(film_id)
left join chinook.category as c using(category_id)
where m.rating in ( 
    select 
        m.rating
    from chinook.movie as m
    group by m.rating
    order by avg(m.rental_rate) desc 
    limit 1
    )
group by c.name