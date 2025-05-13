Создание процессов миграции данных
Чтобы успешно выполнить некоторые задания, вам понадобится оператор MERGE. Синтаксис оператора выглядит так:

MERGE INTO target_table AS t
USING source_table AS s
ON <condition>
WHEN MATCHED THEN
    <update_statement>
WHEN NOT MATCHED THEN
    <insert_delete_statement > 
target_table  — целевая таблица, над которой будут выполняться преобразования с помощью операторов UPDATE, INSERT или DELETE.
source_table  — таблица, содержащая данные, которые будут использоваться для обновления или вставки строк в target_table.
condition — условие поиска пересекающихся полей в таблицах source_table и target_table.
update_statement — SQL-запрос, используемый для обновления строк в target_table.
insert_delete_statement — SQL-запрос, используемый для вставки или удаления строк в target_table.
Пример
В таблице new_client есть поля client_name, client_email. Эта таблица отражает все обновления электронных почт клиентов, а также содержит записи со всеми новыми клиентами. Используя эту таблицу, нужно обновить существующий справочник клиентов client.

MERGE INTO client AS trg
USING new_client AS src
ON src.client_name = trg.client_name
WHEN MATCHED THEN
    UPDATE SET client_email = src.client_email, update_dttm = CURRENT_TIMESTAMP
WHEN NOT MATCHED THEN
  INSERT (client_name, client_email, update_dttm)
  VALUES (src.client_name, src.client_email, CURRENT_TIMESTAMP); 
Если бы таблица new_client содержала только новые строки и обновление существующих не требовалось, использовался бы скрипт с пропущенным блоком WHEN MATCHED THEN:

MERGE INTO client AS trg
USING new_client AS src
ON src.client_name = trg.client_name
WHEN NOT MATCHED THEN
  INSERT (client_name, client_email, update_dttm)
  VALUES (src.client_name, src.client_email, CURRENT_TIMESTAMP); 
Если бы существовала таблица deleted_client, содержащая имена удалённых клиентов, и этих клиентов нужно было удалить из client, скрипт выглядел бы так:

MERGE INTO client AS trg
USING deleted_client AS src
ON src.client_name = trg.client_name
WHEN MATCHED THEN
  DELETE; 
Подробнее об операторе MERGE можно почитать здесь.


1.
Напишите DDL для создания таблицы факта f_order в схеме dwh. Таблица должна содержать поля:
order_id — идентификатор заказа;
product_id — идентификатор товара ручной работы;
craftsman_id — идентификатор мастера;
customer_id — идентификатор заказчика;
order_created_date — дата создания заказа;
order_completion_date — дата выполнения заказа;
order_status — статус выполнения заказа (created, in progress, delivery, done);
load_dttm — дата и время загрузки.
При создании полей ориентируйтесь на типы данных в источниках.
Создайте идентификатор с автоинкрементом с помощью GENERATED ALWAYS AS IDENTITY. Помните, что это первичный ключ.
Создайте внешние ключи с именами fk_product, fk_craftsman, fk_customer для полей product_id, craftsman_id и customer_id соответственно.
DDL должен содержать скрипт удаления и создания таблицы, а также комментарии для таблицы и полей.

/* cоздание таблицы факта "Заказы" */
DROP TABLE IF EXISTS dwh.f_order;
CREATE TABLE dwh.f_order (
	order_id bigint generated always as identity,-- идентификатор заказа
  product_id int8 not null,-- идентификтор товара
  craftsman_id int8 not null,-- идентификатор мастера
  customer_id int8 not null,-- идентификатор заказчика
  order_created_date date not null,-- дата создания заказа
  order_completion_date date not null,-- дата выполнения заказа
  order_status varchar not null, -- статус выполнения заказа (created, in progress, delivery, done)
	load_dttm timestamp not null, -- дата и время загрузки
  constraint orders_pk primary key (order_id), -- первичный ключ orders_pk
  constraint orders_product_fk foreign key (product_id) references dwh.d_product(product_id) ON DELETE restrict, -- внешний ключ orders_product_fk
  constraint orders_craftsman_fk foreign key (craftsman_id) references dwh.d_craftsman(craftsman_id) ON DELETE restrict,-- внешний ключ orders_craftsman_fk
  constraint orders_customer_fk foreign key (customer_id) references dwh.d_customer(customer_id) ON DELETE restrict-- внешний ключ orders_customer_fk
);
COMMENT ON TABLE dwh.f_order IS 'Таблица фактов "Заказы"';
COMMENT ON COLUMN dwh.f_order.order_id IS 'Идентификатор заказа';
COMMENT ON COLUMN dwh.f_order.product_id IS 'Идентификатор товара';
COMMENT ON COLUMN dwh.f_order.craftsman_id IS 'идентификатор мастера';
COMMENT ON COLUMN dwh.f_order.order_created_date IS 'дата создания заказа';
COMMENT ON COLUMN dwh.f_order.order_completion_date IS 'дата выполнения заказа';
COMMENT ON COLUMN dwh.f_order.order_status IS 'статус выполнения заказа (created, in progress, delivery, done)';
COMMENT ON COLUMN dwh.f_order.load_dttm IS 'дата и время загрузки';


2.
Напишите универсальный скрипт для обновления данных в таблицах. Нужно учесть, что каждый день в источнике появляются новые или обновлённые данные, а старые — удаляются. 
Для начала вам надо собрать данные из всех источников — схем source1, source2 и source3 — в одном месте. Создайте временную таблицу tmp_sources с помощью CREATE TEMP TABLE <table_name> AS. Используйте UNION, чтобы объединить содержимое всех трёх источников.
Временная таблица должна содержать поля:
order_id — идентификатор заказа;
order_created_date — дата создания заказа;
order_completion_date — дата выполнения заказа;
order_status — статус заказа;
craftsman_id — идентификатор мастера;
craftsman_name — имя мастера;
craftsman_address — адрес мастера;
craftsman_birthday — день рождения мастера;
craftsman_email — электронная почта мастера;
product_id — идентификатор товара;
product_name — наименование товара;
product_description — описание товара;
product_type — тип товара;
product_price — цена товара;
customer_id — идентификатор заказчика;
customer_name — имя заказчика;
customer_address — адрес заказчика;
customer_birthday — день рождения заказчика;
customer_email — электронная почта заказчика.



/* собираем временную таблицу с данными из всех источников */
DROP TABLE IF EXISTS tmp_sources;
CREATE TEMP TABLE tmp_sources AS 
  (
    select 
      order_id,
      order_created_date,
      order_completion_date,
      order_status,
      craftsman_id,
      craftsman_name,
      craftsman_address,
      craftsman_birthday,
      craftsman_email,
      product_id,
      product_name,
      product_description,
      product_type,
      product_price,
      customer_id,
      customer_name,
      customer_address,
      customer_birthday,
      customer_email
    from dwh.source1.craft_market_wide
    union
    select 
      cmoc.order_id,
      cmoc.order_created_date,
      cmoc.order_completion_date,
      cmoc.order_status,
      cmoc.craftsman_id,
      cmmp.craftsman_name,
      cmmp.craftsman_address,
      cmmp.craftsman_birthday,
      cmmp.craftsman_email,
      cmmp.product_id,
      cmmp.product_name,
      cmmp.product_description,
      cmmp.product_type,
      cmmp.product_price,
      cmoc.customer_id,
      cmoc.customer_name,
      cmoc.customer_address,
      cmoc.customer_birthday,
      cmoc.customer_email
    from dwh.source2.craft_market_orders_customers as cmoc
    left join dwh.source2.craft_market_masters_products as cmmp using(order_id) 
    union
    select 
      cmo.order_id,
      cmo.order_created_date,
      cmo.order_completion_date,
      cmo.order_status,
      cmo.craftsman_id,
      cmc.craftsman_name,
      cmc.craftsman_address,
      cmc.craftsman_birthday,
      cmc.craftsman_email,
      cmo.product_id,
      cmo.product_name,
      cmo.product_description,
      cmo.product_type,
      cmo.product_price,
      cmo.customer_id,
      cmcu.customer_name,
      cmcu.customer_address,
      cmcu.customer_birthday,
      cmcu.customer_email
    from dwh.source3.craft_market_orders as cmo
    left join dwh.source3.craft_market_craftsmans as cmc using(craftsman_id)
    left join dwh.source3.craft_market_customers as cmcu using(customer_id) 
  );
/*Вывод содержимого временной таблицы*/
SELECT * FROM tmp_sources;