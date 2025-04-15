1.
В магазине музыки и фильмов Chinook существует доска почёта. На неё попадают сотрудники отдела продаж, которые оформили для клиентов покупок на наибольшую сумму. 
Чтобы следить за показателями сотрудников, создайте в схеме chinook представление top_salesman, которое будет выводить фамилию (last_name), имя (first_name) и сумму продаж (total_sum) для всех сотрудников из таблицы staff. Результаты в выводе представления отсортируйте по убыванию столбца total_sum.


-- Напишите запрос для создания представления здесь.
create view chinook.top_salesman as 
    with salesmen as  
        (select 
            s.employee_id,
            sum(i.total) as total_sum
        from chinook.invoice as i 
        left join chinook.client as c using(customer_id) 
        left join chinook.staff as s on (c.support_rep_id = s.employee_id)
        group by employee_id
        order by total_sum desc)

    select
        last_name,
        first_name,
        total_sum
    from 
        salesmen 
    left join chinook.staff using(employee_id)




2.
Создайте представление happy_new_year с единственным столбцом days, которое вернёт целое число, равное количеству дней до 1 января следующего года.
Чтобы дать наименование столбцу представления, можно использовать оператор  AS. Другой вариант — написать его название в скобках happy_new_year(days). При выполнении задания воспользуйтесь вторым вариантом.


-- Напишите запрос для создания представления здесь.
create view happy_new_year as 
    select 
        '2026-01-01'::date - CURRENT_DATE as days
    


3.
В базе данных есть представление happy_new_year, которое вы создали раньше. Поменяйте тип данных, который возвращает представление, 
с целого числа на interval. Подберите нужный способ изменения представления.


-- Напишите запрос (или несколько запросов) для изменения представления.

DROP VIEW happy_new_year ;
CREATE VIEW happy_new_year AS
    select 
    ('2026-01-01'::date - CURRENT_DATE)*'1 day'::interval as days


4.
Коллеги попросили переименовать представление happy_new_year и присвоить ему имя v_days_before_new_year. Сделайте это одним запросом.

-- Напишите запрос для переименования представления здесь.

alter view happy_new_year rename to v_days_before_new_year;