1.
Перепишите один из своих прошлых запросов с использованием ключевого слова WITH. 
Сначала получите 40 самых длинных фильмов, аренда которых составляет больше двух долларов. Затем проанализируйте данные о возрастных рейтингах отобранных фильмов. Выгрузите в итоговую таблицу такие поля:
rating — возрастной рейтинг;
length — минимальное, максимальное и среднее значения длительности, назовите поля min_length, max_length и avg_length соответственно;
rental_rate — минимум, максимум и среднее для цены просмотра, назовите поля min_rental_rate, max_rental_rate, avg_rental_rate соответственно.
Отсортируйте финальную таблицу по средней длительности фильма по возрастанию.


with
    films_40_usd_2 as 
    (select *
    from chinook.movie
    where rental_rate>2
    order by length desc
    limit 40)

select 
    rating,
    min(length) as min_length,
    max(length) as max_length,
    avg(length) as avg_length,
    min(rental_rate) as min_rental_rate,
    max(rental_rate) as max_rental_rate,
    avg(rental_rate) as avg_rental_rate
from films_40_usd_2
group by rating
order by avg_length


2.
Проанализируйте данные из таблицы invoice за 2012 и 2013 годы. В итоговую таблицу должны войти поля:
month — номер месяца;
sum_total_2012 — выручка за этот месяц в 2012 году;
sum_total_2013 — выручка за этот месяц в 2013 году;
perc — процент, который отображает, насколько изменилась месячная выручка в 2013 году по сравнению с 2012 годом.
Округлите значение в поле perc до ближайшего целого числа. Отсортируйте таблицу по значению в поле month от меньшего к большему.


-- Чтобы получить округлённый процент изменения выручки, используйте формулу:
--ROUND((sum_total_2013 - sum_total_2012) * 100 / sum_total_2012) as perc

with data_2012 as
    (select
        extract (Month from cast(invoice_date as date)) as month,
        sum(total) as sum_total_2012
    from
        chinook.invoice
    where extract (Year from cast(invoice_date as date))=2012
    group by month),
    data_2013 as
    (select
        extract (Month from cast(invoice_date as date)) as month,
        sum(total) as sum_total_2013
    from
        chinook.invoice
    where extract (Year from cast(invoice_date as date))=2013
    group by month)


select
    month,
    sum_total_2012,
    sum_total_2013,
    ROUND((sum_total_2013 - sum_total_2012) * 100 / sum_total_2012) as perc
from data_2012
left join data_2013 using(month)
order by month