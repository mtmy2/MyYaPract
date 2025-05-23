Вторая нормальная форма (2NF)
Продолжим убирать из таблицы избыточность.
В каждом заказе есть поля с повторяющимися значениями: order_id, client_id и order_date. Это лишняя информация, которая занимает место на диске и тратит ресурсы на обработку — в случае изменения какого-нибудь из этих полей (например, в случае изменения клиента, привязанного к заказу) вместо одной строки придётся исправлять несколько. Да и первичный ключ для таблицы orders после того, как вы привели её к 1NF, состоит из двух полей — Order_id и Detail_id. Напомним, вы привели её к 1NF в уроке про первую нормальную форму, когда заметили, что поле Details можно разложить ещё на несколько полей.
Order_id	Client_id	Client	Order_date	Detail_id	Detail_name	Detail_num
1	4	Mark	2021-10-01	1	laptop	1
1	4	Mark	2021-10-01	2	laptop case	1
2	6	Inna	2021-10-02	1	t-shirt	2
2	6	Inna	2021-10-02	2	snickers	1
Чтобы исправить недостатки моделирования, нужно воспользоваться второй нормальной формой. 
Чтобы перевести модель данных в 2NF, должны выполняться следующие критерии:
модель данных находится в 1NF;
у всех таблиц модели есть первичный ключ;
неключевые поля таблиц зависят от первичного ключа.
Таким образом, вторая нормальная форма предписывает хранить каждую сущность в отдельной таблице. Из таблицы выше можно выделить две сущности: order и details.
Таблица orders:
Order_id	Client_id	Client	Order_date
1	4	Mark	2021-10-01
2	6	Inna	2021-10-02
Таблица details:
Order_id	Detail_id	Detail_name	Detail_num
1	1	laptop	1
1	2	laptop case	1
2	1	t-shirt	2
2	2	snickers	1
Теперь таблица соответствует критериям 2NF, а вы можете переходить к практическим заданиям.