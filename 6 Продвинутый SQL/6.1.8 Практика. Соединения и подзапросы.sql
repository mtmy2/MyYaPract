1.
Составьте сводную таблицу. Посчитайте заказы, оформленные за каждый месяц в течение нескольких лет: с 2011 по 2013 год включительно. 
Итоговая таблица должна включать четыре поля: invoice_month, year_2011, year_2012, year_2013. Поле invoice_month должно хранить месяц в виде числа от 1 до 12. 
Если данные за какой-то месяц отсутствуют, номер такого месяца всё равно должен попасть в таблицу.
В этом задании не будет подсказок. Используйте любые методы, которые посчитаете нужными.

select 
    invoice_month,
    year_2011_table.year_2011,
    year_2012_table.year_2012,
    year_2013_table.year_2013
from
    (select
        extract(Month from cast(invoice_date as date)) as invoice_month
    from
        chinook.invoice
    group by invoice_month) as invoice_month_table
inner join
    (select
        count(*) as year_2011,
        extract(Month from cast(invoice_date as date)) as invoice_month
    from
        chinook.invoice
    where extract(Year from cast(invoice_date as date))=2011
    group by invoice_month) as year_2011_table using(invoice_month)
inner join
    (select
        count(*) as year_2012,
        extract(Month from cast(invoice_date as date)) as invoice_month
    from
        chinook.invoice
    where extract(Year from cast(invoice_date as date))=2012
    group by invoice_month) as year_2012_table using(invoice_month)
inner join
    (select
        count(*)  as year_2013,
        extract(Month from cast(invoice_date as date)) as invoice_month
    from
        chinook.invoice
    where extract(Year from cast(invoice_date as date))=2013
    group by invoice_month) as year_2013_table using(invoice_month)


2.
Отберите уникальные фамилии пользователей, которые:
оформили хотя бы один заказ в январе 2013 года,
а также сделали хотя бы один заказ в любом другом месяце того же года.
Данные по заказам можно найти в таблице invoice. Пользователей, которые оформили заказы только в январе, 
а в остальное время ничего не заказывали, в таблицу включать не нужно.

select
    distinct last_name
from
    (select 
        invoice_id, 
        customer_id,
        last_name
    from chinook.invoice
    left join chinook.client as с Using(customer_id)
    where cast(invoice_date as date)>='2013-01-01' and cast(invoice_date as date)<='2013-01-31') as t_01_2013
inner join
    (select 
        invoice_id, 
        customer_id
    from chinook.invoice
    left join chinook.client as с Using(customer_id)
    where cast(invoice_date as date)>='2013-01-31' and cast(invoice_date as date)<='2013-12-31') as t_2013
    using(customer_id);



3.
Сформируйте статистику по категориям фильмов. Отобразите в итоговой таблице два поля:
название категории,
число уникальных фильмов из этой категории.
Фильмы для второго поля нужно отобрать по условию. 
Посчитайте фильмы только с теми актёрами и актрисами, которые больше семи раз снимались в фильмах, вышедших после 2013 года. 
Назовите поля name_category и total_films соответственно. 
Отсортируйте таблицу по количеству фильмов от большего к меньшему, а затем по полю с названием категории в лексикографическом порядке — по возрастанию.

select 
    name as name_category,
    count(distinct a.film_id) as total_films
from chinook.category c
LEFT JOIN chinook.film_category fc on c.category_id = fc.category_id
LEFT JOIN chinook.film_actor a on fc.film_id = a.film_id
where 
    actor_id IN (
        select actor_id
        from chinook.film_actor a
        left join chinook.movie m on a.film_id = m.film_id
        where release_year > 2013
        group by actor_id
        HAVING count(actor_id) > 7)
    Group By name
ORDER BY total_films DESC, name_category ASC;

