1.
Для начала декомпозируйте таблицу nf_lesson.order_2nf — создайте таблицы nf_lesson.order_3nf и nf_lesson.customer_3nf, 
в которых все неключевые поля будут нетранзитивно зависеть от ключевого поля. Используйте команду CREATE TABLE <table_name> AS SELECT для создания таблицы.


/*Создание таблицы nf_lesson.order_3nf*/

DROP TABLE IF EXISTS nf_lesson.order_3nf;
CREATE TABLE nf_lesson.order_3nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	order_id, -- идентификатор заказа
    order_created_date, -- дата создания заказа
    order_completion_date, -- дата выполнения заказа
    order_status, -- статус выполнения заказа (created, in progress, delivery, done)
    customer_id, -- идентификатор заказчика
    product_id -- идентификатор изделия
FROM nf_lesson.order_2nf;

ALTER TABLE nf_lesson.order_3nf ADD CONSTRAINT pk_order_3nf PRIMARY KEY (order_id);

/*Создание таблицы nf_lesson.customer_3nf*/

DROP TABLE IF EXISTS nf_lesson.customer_3nf;
CREATE TABLE nf_lesson.customer_3nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	customer_id, -- идентификатор заказчика
    customer_name, -- имя заказчика
    customer_surname, -- фамилия заказчика
    customer_address_street, -- адрес заказчика (улица)
    customer_address_building, -- адрес заказчика (номер дома)
    customer_birthday, -- дата рождения заказчика
    customer_email -- электронная почта заказчика

FROM nf_lesson.order_2nf;

ALTER TABLE nf_lesson.customer_3nf ADD CONSTRAINT pk_customer_3nf PRIMARY KEY (customer_id);



2.
Теперь декомпозируйте таблицу nf_lesson.product_2nf. Создайте таблицы nf_lesson.product_3nf и nf_lesson.craftsman_3nf, 
в которых все неключевые поля будут нетранзитивно зависеть от ключевого поля. Используйте команду CREATE TABLE <table_name> AS SELECT для создания таблицы.

/*Создание таблиц nf_lesson.product_3nf*/

DROP TABLE IF EXISTS nf_lesson.product_3nf;
CREATE TABLE nf_lesson.product_3nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	product_id, -- идентификтор товара ручной работы
    product_name, -- название товара ручной работы
    product_description, -- описание товара ручной работы
    product_type, -- тип товара ручной работы
    product_price, -- цена товара ручной работы
    craftsman_id --
FROM nf_lesson.product_2nf;

ALTER TABLE nf_lesson.product_3nf ADD CONSTRAINT pk_product_3nf PRIMARY KEY (product_id);

/*Создание таблиц nf_lesson.craftsman_3nf*/

DROP TABLE IF EXISTS nf_lesson.craftsman_3nf;
CREATE TABLE nf_lesson.craftsman_3nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	craftsman_id, -- идентификатор мастера
    craftsman_name, -- имя мастера
    craftsman_surname, -- фамилия мастера
    craftsman_address_street, -- адрес мастера (улица)
    craftsman_address_building, -- адрес мастера (номер дома)
    craftsman_birthday, -- дата рождения мастера
    craftsman_email -- электронная почта мастера
FROM nf_lesson.product_2nf;

ALTER TABLE nf_lesson.craftsman_3nf ADD CONSTRAINT pk_craftsman_3nf PRIMARY KEY (craftsman_id);


