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
    from source1.craft_market_wide
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
    from source2.craft_market_orders_customers as cmoc
    left join source2.craft_market_masters_products as cmmp on cmoc.craftsman_id = cmmp.craftsman_id and cmoc.product_id=cmmp.product_id 
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
    from source3.craft_market_orders as cmo
    left join source3.craft_market_craftsmans as cmc using(craftsman_id)
    left join source3.craft_market_customers as cmcu using(customer_id) 
  );
/*Вывод содержимого временной таблицы*/
SELECT * FROM tmp_sources;


3.
Заполните таблицу фактов dwh.f_orders данными. 
Для этого используйте соединение временной таблицы с данными из источников tmp_sources и таблиц измерений dwh.d_craftsman, dwh.d_customer, dwh.d_products. 
Дату обновления записей примите равной dwh.d_products.load_dttm.

/* заполнение таблицы фактов "Заказы" */
INSERT INTO dwh.f_order(
	product_id, -- идентификатор товара
	craftsman_id, -- идентификатор мастера
	customer_id, -- идентификатор заказчика
	order_created_date, -- дата создания заказа
	order_completion_date, -- дата выполнения заказа
	order_status, -- статус выполнения заказа (created, in progress, delivery, done)
	load_dttm -- дата и время загрузки
	)
/* запрос датасета для вставки */
SELECT
src.product_id,-- идентификатор товара
  src.craftsman_id,-- идентификатор мастера
  src.customer_id,-- идентификатор заказчика
  src.order_created_date,-- дата создания заказа
  src.order_completion_date,-- дата выполнения заказа
  src.order_status,-- статус выполнения заказа (created, in progress, delivery, done)
  dp.load_dttm -- дата и время загрузки
FROM tmp_sources src
join dwh.d_craftsman dc ON dc.craftsman_name = src.craftsman_name and dc.craftsman_email = src.craftsman_email 
join dwh.d_customer dcust ON dcust.customer_name = src.customer_name and dcust.customer_email = src.customer_email 
join dwh.d_product dp ON dp.product_name = src.product_name and dp.product_description = src.product_description and dp.product_price = src.product_price; 



4.
Если задача подразумевает выполнение двух разных операторов (UPDATE и INSERT или UPDATE и DELETE) на одной таблице в зависимости от условия, которое проверяет наличие или отсутствие связанных записей в другой таблице, удобно использовать оператор MERGE. 
Обновите и добавьте новые данные в измерения. Выполните следующие шаги:
 1. Создать временную таблицу tmp_sources  с данными из всех источников.
 2. Обновить в таблице dwh.d_craftsman строки, бизнес-ключ которых (craftsman_name и craftsman_email) встречается во временной таблице tmp_sources. Далее вставить новые строки (с новым сочетанием полей сraftsman_name и craftsman_email). Используйте MERGE.
 3. Обновить в таблице dwh.d_products строки, бизнес-ключ которых (product_name , product_description и product_price) встречается во временной таблице tmp_sources. Далее вставить новые строки (с новым сочетанием полей product_name, product_description и product_price). Используйте MERGE.
 4. Обновить в таблице dwh.d_customer строки, бизнес-ключ которых (customer_name и customer_email) встречается во временной таблице tmp_sources. Далее вставить новые строки (с новым сочетанием полей customer_name и customer_email). Используйте MERGE.
На источнике каждый день данные будут зачищаться, а вместо них будут появляться новые строки или изменённые старые: ключ у строки будет тот же, но некоторые атрибуты обновятся, например, статус или дата выполнения заказа. Пока что заказчику не важна историчность в хранилище: не храните все версии обновлённой строки, а только изменяйте старую строку.
Ежедневное обновление данных должно состоять из следующих этапов:
Извлечение данных из источников и размещение их во временной таблице.
Обновление в хранилище строк, что были обновлены на источнике за последние сутки, то есть строк, ключи которых встречаются во временной таблице.
Запись новых данных в хранилище.

/* создание таблицы tmp_sources с данными из всех источников */
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
    from source1.craft_market_wide
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
    from source2.craft_market_orders_customers as cmoc
    left join source2.craft_market_masters_products as cmmp on cmoc.craftsman_id = cmmp.craftsman_id and cmoc.product_id=cmmp.product_id 
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
    from source3.craft_market_orders as cmo
    left join source3.craft_market_craftsmans as cmc using(craftsman_id)
    left join source3.craft_market_customers as cmcu using(customer_id) 
  );
/* скрипт для сборки датасета */
INSERT INTO dwh.f_order(
	product_id, -- идентификатор товара
	craftsman_id, -- идентификатор мастера
	customer_id, -- идентификатор заказчика
	order_created_date, -- дата создания заказа
	order_completion_date, -- дата выполнения заказа
	order_status, -- статус выполнения заказа (created, in progress, delivery, done)
	load_dttm -- дата и время загрузки
	)
/* запрос датасета для вставки */
SELECT
src.product_id,-- идентификатор товара
  src.craftsman_id,-- идентификатор мастера
  src.customer_id,-- идентификатор заказчика
  src.order_created_date,-- дата создания заказа
  src.order_completion_date,-- дата выполнения заказа
  src.order_status,-- статус выполнения заказа (created, in progress, delivery, done)
  dp.load_dttm -- дата и время загрузки
FROM tmp_sources src
join dwh.d_craftsman dc ON dc.craftsman_name = src.craftsman_name and dc.craftsman_email = src.craftsman_email 
join dwh.d_customer dcust ON dcust.customer_name = src.customer_name and dcust.customer_email = src.customer_email 
join dwh.d_product dp ON dp.product_name = src.product_name and dp.product_description = src.product_description and dp.product_price = src.product_price; 


/* обновление существующих записей и добавление новых в dwh.d_craftsmans */
MERGE INTO dwh.d_craftsman d
USING (SELECT DISTINCT craftsman_name, craftsman_address, craftsman_birthday, craftsman_email FROM tmp_sources) t
ON d.craftsman_name = t.craftsman_name AND d.craftsman_email = t.craftsman_email/* скрипт условия для соединения таблиц */
WHEN MATCHED THEN
  UPDATE SET 
  craftsman_address = t.craftsman_address, 
  craftsman_birthday = t.craftsman_birthday, 
  load_dttm = current_timestamp
WHEN NOT MATCHED THEN
  INSERT (craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, load_dttm)
  VALUES (t.craftsman_name, t.craftsman_address, t.craftsman_birthday, t.craftsman_email, current_timestamp);

/* обновление существующих записей и добавление новых в dwh.d_products*/
MERGE INTO dwh.d_product d
USING (SELECT DISTINCT product_name, product_description, product_type, product_price from tmp_sources) t
ON d.product_name = t.product_name AND d.product_description = t.product_description AND d.product_price = t.product_price/* скрипт условия для соединения таблиц */
WHEN MATCHED THEN
  UPDATE SET 
  product_type = t.product_type, 
  load_dttm = current_timestamp/* скрипт обновления полей таблицы */
WHEN NOT MATCHED THEN
  INSERT (product_name, product_description, product_type, product_price, load_dttm)
  VALUES (t.product_name, t.product_description, t.product_type, t.product_price, current_timestamp);

/* обновление существующих записей и добавление новых в dwh.d_customer*/
MERGE INTO dwh.d_customer d
USING (SELECT DISTINCT customer_name, customer_address, customer_birthday, customer_email from tmp_sources) t
ON d.customer_name = t.customer_name AND d.customer_email = t.customer_email /* скрипт условия для соединения таблиц */
WHEN MATCHED THEN
  UPDATE SET 
  customer_address= t.customer_address, 
  customer_birthday= t.customer_birthday, 
  load_dttm = current_timestamp /* скрипт обновления полей таблицы */
WHEN NOT MATCHED THEN
  /* скрипт вставки новых строк в таблицу */
  INSERT (customer_name, customer_address, customer_birthday, customer_email, load_dttm)
  VALUES (t.customer_name, t.customer_address, t.customer_birthday, t.customer_email, current_timestamp); 



  5.
Если задача подразумевает выполнение двух разных операторов (UPDATE и INSERT или UPDATE и DELETE) на одной таблице в зависимости от условия, которое проверяет наличие или отсутствие связанных записей в другой таблице, удобно использовать оператор MERGE. 
В предыдущем задании вы обновили и добавили строки в измерения, сейчас же пришло время фактовой таблицы. 
Выполните следующие шаги:
 1. Создать временную таблицу tmp_sources_fact  путём соединения временной таблицы tmp_sources и dwh.d_craftsmans, dwh.d_products, dwh.d_customer по ключам. Таблица должна содержать поля:
product_id — идентификатор товара;
craftsman_id — идентификатор мастера;
customer_id — идентификатор заказчика;
order_created_date — дата создания заказа;
order_completion_date — дата выполнения заказа;
order_status — статус выполнения заказа;
load_dttm — время заполнения таблицы примите за current_timestamp;
Обновить в таблице dwg.f_orders строки, ключ которых (product_id, craftsman_id, customer_id и order_created_date) встречается в tmp_sources_fact . Далее вставить новые строки с новым сочетанием полей product_id, craftsman_id, customer_id и order_created_date. Используйте MERGE.
Ежедневное обновление данных должно состоять из следующих этапов:
Извлечение данных из источников и размещение их во временной таблице.
Обновление в хранилище строк, что были обновлены на источнике за последние сутки, то есть строк, ключи которых встречаются во временной таблице.
Запись новых данных в хранилище.


/* создание таблицы tmp_sources с данными из всех источников */
DROP TABLE IF EXISTS tmp_sources;
CREATE TEMP TABLE tmp_sources AS 
SELECT  order_id,
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
  FROM source1.craft_market_wide
UNION
SELECT  t2.order_id,
		t2.order_created_date,
		t2.order_completion_date,
		t2.order_status,
		t1.craftsman_id,
		t1.craftsman_name,
		t1.craftsman_address,
		t1.craftsman_birthday,
		t1.craftsman_email,
		t1.product_id,
		t1.product_name,
		t1.product_description,
		t1.product_type,
		t1.product_price,
		t2.customer_id,
		t2.customer_name,
		t2.customer_address,
		t2.customer_birthday,
		t2.customer_email 
  FROM source2.craft_market_masters_products t1 
    JOIN source2.craft_market_orders_customers t2 ON t2.product_id = t1.product_id and t1.craftsman_id = t2.craftsman_id 
UNION
SELECT  t1.order_id,
		t1.order_created_date,
		t1.order_completion_date,
		t1.order_status,
		t2.craftsman_id,
		t2.craftsman_name,
		t2.craftsman_address,
		t2.craftsman_birthday,
		t2.craftsman_email,
		t1.product_id,
		t1.product_name,
		t1.product_description,
		t1.product_type,
		t1.product_price,
		t3.customer_id,
		t3.customer_name,
		t3.customer_address,
		t3.customer_birthday,
		t3.customer_email
  FROM source3.craft_market_orders t1
    JOIN source3.craft_market_craftsmans t2 ON t1.craftsman_id = t2.craftsman_id 
    JOIN source3.craft_market_customers t3 ON t1.customer_id = t3.customer_id;  
   
   
/* создание таблицы tmp_sources_fact */
DROP TABLE IF EXISTS tmp_sources_fact;
CREATE TEMP TABLE tmp_sources_fact AS 
/* Код запроса */
select 
  pr.product_id,
  cr.craftsman_id,
  cu.customer_id,
  src.order_created_date,
  src.order_completion_date,
  src.order_status,
  current_timestamp as load_dttm
from tmp_sources as src
left join dwh.d_craftsman as cr on cr.craftsman_name = src.craftsman_name AND cr.craftsman_email = src.craftsman_email
left join dwh.d_product as pr on pr.product_name = src.product_name AND pr.product_description = src.product_description AND pr.product_price = src.product_price
left join dwh.d_customer as cu on cu.customer_name = src.customer_name AND cu.customer_email = src.customer_email;


/* Обновление существующих записей и добавление новых в dwh.f_order */
MERGE INTO dwh.f_order f
USING tmp_sources_fact t
ON f.product_id = t.product_id AND f.craftsman_id = t.craftsman_id AND f.customer_id = t.customer_id
  /* скрипт условия для соединения таблиц */
WHEN MATCHED THEN
  UPDATE SET 
  order_completion_date = t.order_completion_date,
  order_status = t.order_status,
  load_dttm = current_timestamp
  /* Скрипт обновления полей таблицы */
WHEN NOT MATCHED THEN
  /* скрипт вставки новых строк в таблицу */
  INSERT (product_id, craftsman_id, customer_id, order_created_date, order_completion_date, order_status, load_dttm)
  VALUES (t.product_id, t.craftsman_id, t.customer_id, t.order_created_date, t.order_completion_date, t.order_status, current_timestamp); 