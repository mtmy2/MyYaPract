1.
Напишите запрос к таблице tools_shop.orders, который выведет:
дату и время оплаты заказа paid_at;
сумму заказа total_amt;
сумму заказа с накоплением cum_sum, отсортированную по возрастанию даты и времени оплаты заказа.

select 
    paid_at,
    total_amt,
    sum(total_amt) over (order by paid_at) as cum_sum
from tools_shop.orders

2.
Напишите запрос к таблице tools_shop.orders, который выведет:
идентификатор пользователя user_id;
дату и время оплаты заказа paid_at;
сумму заказа total_amt;
сумму заказа с накоплением для каждого пользователя cum_sum, отсортированную по возрастанию даты и времени оплаты заказа.

select
    user_id,
    paid_at,
    total_amt,
    sum(total_amt) over (partition by user_id order by paid_at) cum_sum
from tools_shop.orders


3.
Напишите запрос к таблице tools_shop.orders, который выведет:
месяц оплаты заказа в формате '2016-02-01', приведённый к типу date, — первый день месяца;
сумму заказа total_amt;
сумму заказов по месяцам с накоплением, отсортированную по месяцу оплаты заказа.

select
    date_trunc('Month', paid_at)::date as month,
    total_amt,
    sum(total_amt) over (partition by date_trunc('Month', paid_at)::date order by date_trunc('Month', paid_at)::date) as cum_sum
from tools_shop.orders


4.
Рассчитайте сумму трат на привлечение пользователей с накоплением по месяцам с 2017 по 2018 год включительно.
Напишите запрос к таблице tools_shop.costs, который выведет уникальные записи из двух столбцов:
месяц формирования заказа, приведённый к типу date — в формате '2016-02-01';
сумму трат на текущий месяц с накоплением.

select
    distinct date_trunc('Month', created_at)::date as month,
    sum(costs) over (partition by date_trunc('Month', created_at)::date ) as cost_sum
from tools_shop.costs
where extract(year from created_at) between 2017 and 2018
group by costs, month


