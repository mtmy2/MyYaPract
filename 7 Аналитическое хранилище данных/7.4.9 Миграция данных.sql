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
	order_id,-- идентификатор заказа
  product_id,-- идентификтор товара
  craftsman_id,-- идентификатор мастера
  customer_id,-- идентификатор заказчика
  order_created_date,-- дата создания заказа
  order_completion_date,-- дата выполнения заказа
  order_status, -- статус выполнения заказа (created, in progress, delivery, done)
	load_dttm, -- дата и время загрузки
  constraints orders_pk primary key (order_id) generated always as identity,-- первичный ключ orders_pk
  constraints orders_product_fk foreign key (product_id) references dwh.d_product(product_id), -- внешний ключ orders_product_fk
  constraints orders_craftsman_fk foreign key (craftsman_id) references dwh.d_craftsman(craftsman_id),-- внешний ключ orders_craftsman_fk
  constraints orders_customer_fk foreign key (customer_id) references dwh.d_customer(customer_id)-- внешний ключ orders_customer_fk
);