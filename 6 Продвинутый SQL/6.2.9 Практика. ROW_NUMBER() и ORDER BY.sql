1.
Выведите все поля таблицы tools_shop.items, добавив поле с рангом записи.

select *, row_number() over()
from tools_shop.items
    

2.
Проранжируйте все поля в таблице tools_shop.users по дате регистрации — от меньшей к большей. Напишите запрос, который выведет идентификатор пользователя с рангом 2021.

WITH users AS (
    SELECT *,
        row_number() over(order by created_at) as id
    FROM tools_shop.users
)
SELECT user_id
FROM users
WHERE id = 2021


3.
Проранжируйте записи в таблице tools_shop.orders за каждую дату оплаты заказа по их стоимости — от большей к меньшей. 
Напишите запрос, который выведет для каждой даты номер заказа с рангом 4. 
В итоговой таблице у вас должно получиться два столбца — paid_dt и order_id.



with ranged_table as 
    (select *, 
        row_number() over(partition by cast(paid_at as date) order by total_amt desc) as rang
    from tools_shop.orders)
Select 
    cast(paid_at as date) as paid_dt,
    order_id
from ranged_table
where rang = 4
