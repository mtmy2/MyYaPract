1.
Для отчёта нужно добавить к каждой строке таблицы заказов tools_shop.orders общее количество заказов, оформленных в этот же день. 
Выведите все поля таблицы и новое поле с количеством заказов orders_cnt.

select *, count(*) over(partition by created_at) as orders_cnt
from tools_shop.orders

2.
Рассчитайте долю стоимости каждого заказа из таблицы tools_shop.orders от общей суммы выручки за месяц в процентах. 
В результирующей выборке соберите все поля  tools_shop.order и новое поле revenue. Приведите значение процента к целому числу.

select *, round((total_amt/sum(total_amt) over (partition by date_trunc('month', cast(paid_at as date)))*100), 0) as revenue
from tools_shop.orders

