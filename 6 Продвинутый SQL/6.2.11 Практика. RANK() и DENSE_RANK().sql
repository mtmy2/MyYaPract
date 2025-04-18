1.
Проранжируйте записи в таблице tools_shop.order_x_item в зависимости от значения item_id — от меньшего к большему. 
Записи с одинаковым item_id должны получить один ранг. Ранги можно указать непоследовательно.

select *, rank() over(order by item_id)
from tools_shop.order_x_item

2.
Менеджеры магазина «Сила в окнах» заметили, что в базе данных есть большое количество клиентов с одинаковыми именами и фамилиями, но разными адресами почт. 
Они решили разобраться с этой ситуацией и попросили для каждого сочетания фамилии last_name и имени first_name проранжировать записи в таблице tools_shop.users 
в зависимости от значения в поле created_at — от большего к меньшему. Записи с одинаковым значением created_at должны получить один ранг. Ранги должны быть указаны последовательно.

select last_name, first_name, dense_rank() over(partition by concat(last_name, first_name ) order by created_at desc)
from tools_shop.users