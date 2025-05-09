1.
Изучите данные в таблице nf_lesson.craft_market_wide_1nf. Убедитесь, что таблица не соответствует критериям 2NF. 
Проверьте, есть ли в идентификаторах craftsman_id, product_id, order_id и customer_id поля с повторяющимися значениями. Для этого напишите для каждого поля запрос, используя агрегатную функцию COUNT(*). Она поможет подсчитать количество строк с одним и тем же идентификатором. 
Рекомендуем проводить группировку по полю-идентификатору, а также использовать после группировки предложение HAVING COUNT(*) > 1 для то


/* Поиск дублирующихся идентификаторов */

SELECT /* Задайте запрос для подсчёта строк из таблицы nf_lesson.craft_market_wide_1nf с группировкой по полю craftsman_id */
    craftsman_id,
    count(*)
from nf_lesson.craft_market_wide_1nf
group by craftsman_id
HAVING COUNT(*) > 1;

SELECT /* Задайте запрос для подсчёта строк из таблицы nf_lesson.craft_market_wide_1nf с группировкой по полю product_id */
    product_id,
    count(*)
from nf_lesson.craft_market_wide_1nf
group by product_id
HAVING COUNT(*) > 1;

SELECT /* Задайте запрос для подсчёта строк из таблицы nf_lesson.craft_market_wide_1nf с группировкой по полю order_id*/
    order_id,
    count(*)
from nf_lesson.craft_market_wide_1nf
group by order_id
HAVING COUNT(*) > 1;


SELECT /* Задайте запрос для подсчёта строк из таблицы nf_lesson.craft_market_wide_1nf с группировкой по полю customer_id */    
    customer_id,
    count(*)
from nf_lesson.craft_market_wide_1nf
group by customer_id
HAVING COUNT(*) > 1;



2.
Чтобы перевести таблицу nf_lesson.craft_market_wide_1nf во вторую нормальную форму, нужно разделить её на две сущности — order и product. В order будет храниться информация о заказе и покупателе, а в product — об изделии и мастере.
Создайте таблицу nf_lesson.order_2nf для выделенной сущности order. Используйте команду CREATE TABLE <table_name> AS SELECT для создания таблицы.

/*Создание таблиц nf_lesson.order_2nf*/

DROP TABLE IF EXISTS nf_lesson.order_2nf;
CREATE TABLE nf_lesson.order_2nf AS
SELECT DISTINCT 
        /* Задайте выражение для создания колонок таблицы */
        order_id, -- идентификатор заказа
        order_created_date, -- дата создания заказа
        order_completion_date, -- дата выполнения заказа
        order_status, -- статус выполнения заказа (created, in progress, delivery, done)
        customer_id, -- идентификатор заказчика
        customer_name, -- имя заказчика
        customer_surname, -- фамилия заказчика
        customer_address_street, -- адрес заказчика (улица)
        customer_address_building, -- адрес заказчика (номер дома)
        customer_birthday, -- дата рождения заказчика
        customer_email, -- электронная почта заказчика
        product_id -- идентификатор изделия
FROM nf_lesson.craft_market_wide_1nf;

ALTER TABLE nf_lesson.order_2nf ADD CONSTRAINT pk_order_2nf PRIMARY KEY (order_id);




3.
Создайте таблицу nf_lesson.product_2nf для выделенной сущности product. Используйте команду CREATE TABLE <table_name> AS SELECT для создания таблицы.

/*Создание таблиц nf_lesson.product_2nf*/

DROP TABLE IF EXISTS nf_lesson.product_2nf;
CREATE TABLE nf_lesson.product_2nf AS
SELECT DISTINCT
        product_id, -- идентификтор товара ручной работы
        product_name, -- название товара ручной работы
        product_description, -- описание товара ручной работы
        product_type, -- тип товара ручной работы
        product_price, -- цена товара ручной работы
        craftsman_id, -- идентификатор мастера
        craftsman_name, -- имя мастера
        craftsman_surname, -- фамилия мастера
        craftsman_address_street, -- адрес мастера (улица)
        craftsman_address_building, -- адрес мастера (номер дома)
        craftsman_birthday, -- дата рождения мастера
        craftsman_email -- электронная почта мастера
FROM nf_lesson.craft_market_wide_1nf; 

ALTER TABLE nf_lesson.product_2nf ADD CONSTRAINT pk_product_2nf PRIMARY KEY (product_id);