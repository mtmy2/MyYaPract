1.
Создайте схему model_lesson.
Напишите DDL(Data Definition Language) для создания таблиц измерений d_product, d_shop и d_customer в схеме model_lesson.
DDL должен содержать скрипт удаления и создания таблицы.
Колонки не должны содержать значения NULL.
Создайте идентификатор с автоинкрементом. Помните, что это первичный ключ. Выполнить этот пункт можно с помощью уже знакомого вам SERIAL или с помощью GENERATED ALWAYS AS IDENTITY.
Для определения состава колонок измерений вы можете свериться со схемой модели из предыдущего урока.

/* Создание измерения "Товары" */
DROP TABLE IF EXISTS model_lesson.d_product;
CREATE TABLE model_lesson.d_product (
  product_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, --идентификатор товара
  product_name text not null --наименование товара
);

/* Создание измерения "Магазины" */
DROP TABLE IF EXISTS model_lesson.d_shop;
CREATE TABLE model_lesson.d_shop (
  shop_id bigint PRIMARY KEY GENERATED ALWAYS AS IDENTITY, --идентификатор магазина
  shop_name text not null, --название магазина
  shop_address json not null --адрес магазина
);

/* Создание измерения "Покупатели" */
DROP TABLE IF EXISTS model_lesson.d_customer;
CREATE TABLE model_lesson.d_customer (
  customer_id bigint primary key GENERATED always as identity,--идентификатор покупателя
  customer_name text not null,--имя покупателя
  customer_phone_number text not null, --номер телефона покупателя
	customer_address json not null--адрес покупателя
);


2.
Напишите DDL для создания таблицы факта f_order в схеме model_lesson.
DDL должен содержать скрипт удаления и создания таблицы.
Колонки не должны содержать значения NULL.
Создайте идентификатор с автоинкрементом с помощью GENERATED ALWAYS AS IDENTITY. Помните, что это первичный ключ.
Создайте внешние ключи с именами fk_product, fk_shop, fk_customer для полей product_id, shop_id и customer_id соответственно.


DROP TABLE IF EXISTS model_lesson.f_order;
CREATE TABLE model_lesson.f_order (
	order_id bigint primary key generated always as identity,--идентификатор заказа
  create_dttm timestamp not null, --дата создания заказа
  shop_id bigint not null, --идентификатор магазина
  product_id bigint not null, --идентификатор товара
  item_count integer not null,--количество единиц товара
  customer_id bigint not null, --идентификатор покупателя
  order_status text,--статус заказа
  CONSTRAINT fk_product FOREIGN KEY(product_id) REFERENCES model_lesson.d_product(product_id), --внешний ключ fk_product
  CONSTRAINT fk_shop FOREIGN KEY(shop_id) REFERENCES model_lesson.d_shop(shop_id), --внешний ключ fk_shop
  CONSTRAINT fk_customer FOREIGN KEY(customer_id) REFERENCES model_lesson.d_customer(customer_id) --внешний ключ fk_customer
);



3.
Чтобы из вашей «звезды» получилась «снежинка», нужно добавить в неё измерение d_address, которое будет связано с измерениями d_customer и d_shop.
Напишите DDL для создания таблицы измерения d_address в схеме model_lesson.
DDL должен содержать скрипт удаления и создания таблицы.
Колонки не должны содержать значения NULL.
Создайте идентификатор с автоинкрементом с помощью GENERATED ALWAYS AS IDENTITY. Помните, что это первичный ключ.
Обратите внимание, что вместо одного поля address таблица должна содержать несколько других:
address_json — адрес в формате JSON (JSON);
city — город (TEXT);
street — улица (TEXT);
house — номер дома (TEXT);
post_index — почтовый индекс (TEXT);
В таблицах model_lesson.d_shop и model_lesson.d_customer исправьте колонки customer_address и shop_address на customer_address_id и shop_address_id соответственно.
Эти колонки должны иметь тип BIGINT и являться внешними ключами, ссылающимися на d_address.address_id.


/* Создание измерения "Адреса" */
DROP TABLE IF EXISTS model_lesson.d_address;
CREATE TABLE model_lesson.d_address (
  address_id bigint primary key generated always as identity,--идентификатор адреса
  address_json json not null,--адрес в формате JSON
  city text not null,--город
  street text not null,--улица
  house text not null,--номер дома
  post_index text not null --почтовый индекс
);

/*Переименование столбца в model_lesson.d_shop*/
ALTER TABLE model_lesson.d_shop RENAME COLUMN shop_address TO shop_address_id;--
/*Изменение типа столбца в model_lesson.d_shop*/
ALTER TABLE model_lesson.d_shop ALTER COLUMN shop_address_id TYPE bigint USING Null;--
/*Добавление внешнего ключа для model_lesson.d_shop*/
ALTER TABLE model_lesson.d_shop ADD FOREIGN KEY (shop_address_id) REFERENCES model_lesson.d_address(address_id);--

/*Переименование столбца в model_lesson.d_customer*/
ALTER TABLE model_lesson.d_customer RENAME COLUMN customer_address TO customer_address_id;--
/*Изменение типа столбца в model_lesson.d_customer*/
ALTER TABLE model_lesson.d_customer ALTER COLUMN customer_address_id TYPE bigint USING Null;--
/*Добавление внешнего ключа для model_lesson.d_customer*/
ALTER TABLE model_lesson.d_customer ADD FOREIGN KEY (customer_address_id) REFERENCES model_lesson.d_address(address_id);--



4.
Сначала необходимо заполнить измерения и только потом — факты, поскольку в фактах есть поля с идентификаторами из измерений. В этом задании разберёмся с измерениями.
Заполните таблицу model_lesson.d_address уникальными значениями из полей shop_address и customer_address.

Например, в поле customer_address лежат такие данные в формате JSON:

json
 {
     "house": "1/1", 
     "street": "ул. Труда", 
     "cityName": "Магнитогорск", 
     "postIndex": "455021"
 }
 

Их нужно разложить в таблицу model_lesson.d_address в поля:

address_id — идентификатор адреса (BIGINT);
address_json — адрес в формате JSON (JSON);
city — город (TEXT);
street — улица (TEXT);
house — номер дома (TEXT);
post_index — почтовый индекс (TEXT);
Это можно сделать так:

INSERT INTO model_lesson.d_address (city, street, house, post_index)
SELECT
      customer_address AS address_json,
  (customer_address ->> 'cityName')::text AS city,
  (customer_address ->> 'street')::text AS street,
  (customer_address ->> 'house')::text AS house,
  (customer_address ->> 'postIndex')::text AS post_index
FROM source4.order 
Для объединения данных из полей shop_address и customer_address используйте команду UNION.
Заполните измерение model_lesson.d_product уникальными значениями из поля product_name таблицы source4.order.
Заполните измерение model_lesson.d_shop уникальными значениями из поля shop_name таблицы source4.order, а поле shop_address_id — идентификатором из таблицы  model_lesson.d_address.  
Чтобы получить идентификатор адреса, соедините таблицы source4.order и model_lesson.d_address по ключу shop_address::text = address_json::text.
Заполните измерение model_lesson.d_customer уникальными значениями из поля customer_name и customer_phone_number таблицы source4.order, а поле customer_address_id — идентификатором из таблицы model_lesson.d_address.  
Чтобы достать идентификатор адреса, соедините таблицы source4.order и model_lesson.d_address по ключу customer_address::text = address_json::text.

/* Заполнение таблицы model_lesson.d_address */
INSERT INTO model_lesson.d_address (address_json, city, street, house, post_index)
SELECT/* Запрос */
  customer_address as address_json,
  (customer_address ->> 'cityName')::text AS city,
  (customer_address ->> 'street')::text AS street,
  (customer_address ->> 'house')::text AS house,
  (customer_address ->> 'postIndex')::text AS post_index
from source4.order
union all
SELECT /* Запрос */
  shop_address as address_json,
  (shop_address ->> 'cityName')::text AS city,
  (shop_address ->> 'street')::text AS street,
  (shop_address ->> 'house')::text AS house,
  (shop_address ->> 'postIndex')::text AS post_index
from source4.order;

/* Заполнение таблицы model_lesson.d_product */
INSERT INTO model_lesson.d_product (product_name)
SELECT DISTINCT /* Запрос */
  product_name
from source4.order;

/* Заполнение таблицы model_lesson.d_shop */
INSERT INTO model_lesson.d_shop (shop_name, shop_address_id)
SELECT DISTINCT/* Запрос */
  o.shop_name as shop_name,
  a.address_id as shop_address_id
from source4.order o
left join model_lesson.d_address as a on o.shop_address::text=a.address_json::text;

/* Заполнение таблицы model_lesson.d_customer */
INSERT INTO model_lesson.d_customer (customer_name, customer_phone_number, customer_address_id)
SELECT DISTINCT/* Запрос */
  o.customer_name as customer_name,
  o.customer_phone_number as customer_phone_number,
  a.address_id as customer_address_id
from source4.order o
left join model_lesson.d_address as a on o.customer_address::text=a.address_json::text;


5.
Вспомните, как вы заполняли таблицы с внешними ключами model_lesson.d_shop и model_lesson.d_customer. Для таблицы фактов model_lesson.f_order алгоритм действий примерно такой же: нужно соединить таблицу-источник source4.order с таблицами измерений, из которых, в свою очередь, нужно достать идентификаторы. Но обо всём по порядку.
Присоедините к source4.order таблицу model_lesson.d_address.
В качестве ключей соединения используйте shop_address и address_json, приведённые к типу TEXT.
Для таблицы model_lesson.d_address используйте псевдоним a_shop.
Присоедините к source4.order таблицу model_lesson.d_address.
В качестве ключей соединения используйте customer_address и address_json, приведённые к типу TEXT.
Для таблицы model_lesson.d_address используйте алиас a_customer.
Присоедините к source4.order таблицу model_lesson.d_product.
В качестве ключей соединения используйте product_name и product_name.
Присоедините к source4.order таблицу model_lesson.d_shop.
В качестве ключей соединения используйте:
shop_name и shop_name;
address_id и shop_address_id.
Присоедините к source4.order таблицу model_lesson.d_customer.
В качестве ключей соединения используйте:
customer_name и customer_name;
customer_phone_number и customer_phone_number;
address_id и customer_address_id.
Заполните таблицу model_lesson.f_order полями:
create_dttm из таблицы source4.order;
shop_id из таблицы model_lesson.d_shop;
product_id из таблицы model_lesson.d_product;
item_count из таблицы source4.order;
customer_id из таблицы model_lesson.d_customer;
order_status из таблицы source4.order.


/* Заполнение таблицы model_lesson.f_order */
INSERT INTO model_lesson.f_order (create_dttm, shop_id, product_id, item_count, customer_id, order_status)
SELECT
	/* Запрос для колонок */
  create_dttm as create_dttm,
  s.shop_id as shop_id,
  p.product_id as product_id,
  item_count as item_count,
  c.customer_id as customer_id,
  order_status as order_status
FROM source4.order o
  JOIN model_lesson.d_address shop_a on o.shop_address::text = shop_a.address_json::text -- условие присоединения таблицы
  JOIN model_lesson.d_address customer_a on o.customer_address::text = customer_a.address_json::text -- условие присоединения таблицы
  JOIN model_lesson.d_product p using(product_name) -- условие присоединения таблицы
  JOIN model_lesson.d_shop s ON o.shop_name = s.shop_name AND shop_a.address_id = s.shop_address_id -- условие присоединения таблицы
  JOIN model_lesson.d_customer c ON o.customer_name = c.customer_name AND o.customer_phone_number = c.customer_phone_number AND customer_a.address_id = c.customer_address_id;  -- условие присоединения таблицы
  