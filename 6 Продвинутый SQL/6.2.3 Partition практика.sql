Напишите запрос, который выведет все поля таблицы tools_shop.orders, а также два дополнительных поля:
user_sum — суммарную стоимость заказов для каждого пользователя.
sum_total — суммарную стоимость всех заказов.
Отсортируйте результирующую таблицу по полю user_id.

select *, sum(total_amt) over (partition by user_id) as user_sum, sum(total_amt) over() as sum_total
from tools_shop.orders
order by user_id

2.
Напишите запрос, который выведет все поля таблицы tools_shop.users и отдельным полем — количество пользователей в этой таблице.

select *, count(*) over ()
from tools_shop.users

3.
Напишите запрос, который выведет все поля таблицы tools_shop.orders и отдельным полем суммарную стоимость заказов каждого пользователя за тот же месяц, к которому принадлежит каждая конкретная строка. Датой заказа считается дата его создания — created_at.
Отсортируйте результирующую таблицу по пользователям и по дате создания заказа от более новых к более старым.

select *, sum(total_amt) over(partition by user_id, DATE_TRUNC('month', created_at))
from tools_shop.orders
order by user_id, created_at desc

