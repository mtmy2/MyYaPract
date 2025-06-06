Инкрементальное обновление данных в витрине
Как мы уже говорили, полностью перестраивать витрину при изменениях — не всегда эффективно: процесс может занять время, ресурсы и при этом обновить лишь малую часть информации. Обновлять витрины удобнее с помощью инкрементальной загрузки. 
Что такое инкрементальная загрузка
Инкрементальная загрузка — это метод обновления витрины, когда изменяются не все данные, а только те, что получили новые значения. Этот подход более сложный, чем простой пересчёт всей витрины: процесс разбивается на несколько этапов и создаётся дополнительная таблица. 
Существует два основных способа инкрементальной загрузки:
Первый способ предполагает наличие дополнительной таблицы, в которой каждая строчка — время последнего обновления данных в витрине на основе даты их загрузки в DWH.
Второй способ подразумевает использование паттерна Transactional Outbox.
Паттерн подробнее рассмотрим в следующем уроке, а пока разберём первый способ на примере: реализуем инкрементальную загрузку витрины, которая содержит отчёт по мастерам ручной работы. 
Как обновлять витрину инкрементально: способ 1
DDL витрины с отчётом выглядит следующим образом:

DROP TABLE IF EXISTS dwh.craftsman_report_datamart;

CREATE TABLE IF NOT EXISTS dwh.craftsman_report_datamart (
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL, -- идентификатор записи
    craftsman_id BIGINT NOT NULL, -- идентификатор мастера
    craftsman_name VARCHAR NOT NULL, -- Ф. И. О. мастера
    craftsman_address VARCHAR NOT NULL, -- его адрес
    craftsman_birthday DATE NOT NULL, -- дата рождения
    craftsman_email VARCHAR NOT NULL, -- электронная почта
    craftsman_money NUMERIC(15,2) NOT NULL, -- сумма денег, которую мастер заработал за месяц (-10% на платформы)
    platform_money BIGINT NOT NULL, -- сумма денег, которая заработала платформа с продаж мастера за месяц
    count_order BIGINT NOT NULL, -- количество заказов у мастера за месяц
    avg_price_order NUMERIC(10,2) NOT NULL, -- средняя стоимость одного заказа у мастера за месяц
    avg_age_customer NUMERIC(3,1) NOT NULL, -- средний возраст покупателей
    median_time_order_completed NUMERIC(10,1), -- медианное время в днях от момента создания заказа до его завершения за месяц
    top_product_category VARCHAR NOT NULL, -- самая популярная категория товаров у этого мастера за месяц
    count_order_created BIGINT NOT NULL, -- количество созданных заказов за месяц
    count_order_in_progress BIGINT NOT NULL, -- количество заказов в процессе изготовки за месяц
    count_order_delivery BIGINT NOT NULL, -- количество заказов в доставке за месяц
    count_order_done BIGINT NOT NULL, -- количество завершённых заказов за месяц
    count_order_not_done BIGINT NOT NULL, -- количество незавершённых заказов за месяц
    report_period VARCHAR NOT NULL, -- отчётный период (год и месяц)
    CONSTRAINT craftsman_report_datamart_pk PRIMARY KEY (id)
); 
Реализуем пошагово инкрементальную загрузку: каждый шаг — это некоторый блок кода, который будет добавлен в общий CTE-запрос. CTE-запрос, который будет выполнять инкрементальную загрузку, будет выглядеть так:

DROP TABLE IF EXISTS dwh.load_dates_craftsman_report_datamart;

CREATE TABLE IF NOT EXISTS dwh.load_dates_craftsman_report_datamart (
-- Шаг 1
);

WITH
dwh_delta AS (
    -- Шаг 2
),
dwh_update_delta AS (
    -- Шаг 3
),
dwh_delta_insert_result AS (
    -- Шаг 4
),
dwh_delta_update_result AS (
    -- Шаг 5
),
insert_delta AS (
    -- Шаг 6
),
update_delta AS (
    -- Шаг 7
),
insert_load_date AS (
    -- Шаг 8
)
SELECT 'increment datamart'; 
CTE-запрос получается достаточно большим (8 шагов), а это только его скелет, без основного кода. Каждый шаг в CTE — это отдельная задача. Удержать в голове, что происходит на каждом шаге, бывает очень сложно, поэтому попробуем каждый шаг выделить в таблицу.
Шаг 1. Создать дополнительную таблицу
В дополнительной таблице — две основные колонки: id записи, дата и время загрузки новых данных. Дата и время загрузки будут определяться как максимальное время из всего, что было загружено в хранилище. На основе даты вы будете принимать решение о том, какие данные были изменены или добавлены.
Шаг 2. Выбрать из хранилища только изменённые или новые данные
Чтобы определить, какие данные были изменены или добавлены, нужно добавить в запрос следующее условие: дата загрузки данных в DWH должна быть старше даты из дополнительной таблицы. Выборка из новых или изменённых данных называется дельтой.
Шаг 3. Определить, какие данные из дельты нужно обновить
Части данных в витрине раньше не было, поэтому их нужно вставить с помощью INSERT, а другая часть уже была — их значения нужно обновить с помощью UPDATE.
Стоит отметить, что в классическом случае исторические данные в витрине не обновляются и инкременты добавляются независимо друг от друга, даже если появилась новая информация о старых фактах. Для решения учебной задачи важен факт изменения исторических данных и их влияние на витрину независимо от периода расчёта, так как это может затронуть решения бизнеса. Поэтому текущая реализация будет немного отличаться от классической инкрементальной загрузки с учётом обновления исторических данных. Такой подход можно назвать MERGE REFRESH.
Шаг 4. Выполнить расчёт витрины только для данных, которые нужно вставить
В dwh_update_delta находятся craftsman_id, которые нужно обновить. А те данные, что нужно добавить, — в блоке dwh_delta с exist_craftsman_id is NULL.
Шаг 5. Выполнить расчёт витрины для данных, которые нужно обновить
Расчёт витрины для данных обновления похож на расчёт витрины для данных вставки, есть лишь один нюанс: для начала нужно получить конкретные данные по колонкам, которые нужно пересчитать вместе с новыми данными. Для существующих в хранилище мастеров ручной работы появились новые данные об их заработке, продаже и прочим атрибутам, и теперь нужно обновить для них итоговый отчёт.
Шаг 6. Выполнить вставку новых данных в витрину
Вы уже получили выборку, которую нужно вставить в блоке dwh_delta_insert_result. Осталось вставить новые данные в витрину. Для этого используйте конструкцию INSERT FROM SELECT (иногда INSERT AS SELECT). Аргументами для INSERT будет выборка SELECT из таблицы.
Пример.
Шаг 7. Выполнить обновление изменённых данных в витрине
Вы уже получили выборку, которую нужно обновить в блоке dwh_delta_update_result. Осталось воспользоваться конструкцией UPDATE FROM SELECT (иногда UPDATE AS SELECT). Эта конструкция тоже предполагает, что аргументами для UPDATE будет выборка SELECT из таблицы. Пример:

UPDATE tableA SET
        columnA = tableB.columnA, 
        columnB = tableB.columnB, 
        columnC = tableB.columnC
    FROM (
        SELECT 
            columnId,
            columnA,
            columnB,
            columnC) AS tableB
    WHERE tableA.columnId = tableB.columnId 
Шаг 8. Выполнить вставку максимальной даты загрузки из дельты в дополнительную таблицу
При вставке максимальной даты загрузки из дельты, во время следующей загрузки данных в витрину запрос на получение дельты будет учитывать только вновь добавленные или изменённые данные с более поздней датой загрузки.
В предыдущих заданиях вы обновили витрину. Чтобы в следующий раз снова посчитать именно дельту, а не все значения из хранилища, вам нужно добавить информацию о дате последнего обновления в таблицу загрузок.





Практика:


1.
Создайте DDL таблицы загрузок в схеме dwh и назовите её следующим образом: load_dates_craftsman_report_datamart.
В таблице должны присутствовать такие колонки:
id — идентификатор записи;
load_dttm — дата загрузки данных.
Создайте PRIMARY KEY с именем load_dates_craftsman_report_datamart_pk для колонки id.



DROP TABLE IF EXISTS dwh.load_dates_craftsman_report_datamart;

CREATE TABLE IF NOT EXISTS dwh.load_dates_craftsman_report_datamart (
-- напишите код здесь
    id BIGINT GENERATED ALWAYS AS IDENTITY NOT NULL,
    load_dttm date not null,
    constraint load_dates_craftsman_report_datamart_pk primary key(id)
);



2.
Напишите SQL-запрос, который получает только обновлённые или новые данные из хранилища в схеме dwh. Данные нужно сохранить в таблицу dwh.dwh_delta — они будут использованы в следующих шагах.
Для этого понадобится объединить данные из таблиц: dwh.f_order, dwh.d_craftsman, dwh.d_customer, dwh.d_product с данными из витрины dwh.craftsman_report_datamart. Выберите только те данные, дата загрузки которых не превышает дату из таблицы загрузок dwh.load_dates_craftsman_report_datamart.
В SELECT-запросе нужно получить следующие столбцы:
craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, craftsman_load_dttm — из таблицы dwh.d_craftsman;
order_id — из dwh.f_order;
product_id, product_price, product_type — из таблицы dwh.d_product;
customer_age — можно получить из поля customer_birthday таблицы dwh.d_customer при помощи функции date_part('year', age(column));
diff_order_date — можно получить как разность значений из колонок order_completion_date и order_created_date из таблицы dwh.f_order;
order_status — из таблицы dwh.f_order;
report_period — можно получить из поля order_created_date таблицы dwh.f_order при помощи функции to_char(column, ‘yyyy-mm’);
exist_craftsman_id — можно получить из таблицы dwh.craftsman_report_datamart (эта колонка нужна, чтобы понять, какие craftsman_id уже есть в витрине, нужно ли применить к ним UPDATE или INSERT);
craftsman_load_dttm — из таблицы dwh.d_craftsman;
customers_load_dttm — из таблицы dwh.d_customer;
products_load_dttm — из таблицы dwh.d_product.
Первый раз инкрементальная загрузка сработает как полное перестроение витрины: изначально витрина пустая, поэтому нужно будет загрузить в неё все данные. Чтобы в витрину данные попали в первый раз, надо сначала в таблицу загрузок вставить значение с минимальной датой, чтобы началась первая загрузка. Возьмите в качестве такого значения '1900-01-01’.


'''-- первая таблица dwh_delta: определяем, какие данные были изменены в витрине данных или добавлены в DWH 
-- формируем дельту изменений'''
DROP TABLE IF EXISTS dwh.dwh_delta;
CREATE TABLE IF NOT EXISTS dwh.dwh_delta AS (
	SELECT 	
			dc.craftsman_id AS craftsman_id,
			dc.craftsman_name AS craftsman_name,
			dc.craftsman_address AS craftsman_address,
			dc.craftsman_birthday AS craftsman_birthday,
			dc.craftsman_email AS craftsman_email,
			fo.order_id AS order_id,
			dp.product_id AS product_id,
			dp.product_price AS product_price,
			dp.product_type AS product_type,
			date_part('year', age(dcs.customer_birthday)) AS customer_age,
			fo.order_completion_date - fo.order_created_date AS diff_order_date, 
			fo.order_status AS order_status,
			to_char(fo.order_created_date, 'yyyy-mm') AS report_period,
			crd.craftsman_id AS exist_craftsman_id,
			dc.load_dttm AS craftsman_load_dttm,
			dc.load_dttm AS customers_load_dttm,
			dp.load_dttm AS products_load_dttm
			FROM dwh.f_order fo 
				INNER JOIN dwh.d_craftsman dc ON fo.craftsman_id = dc.craftsman_id 
				INNER JOIN dwh.d_customer dcs ON fo.customer_id = dcs.customer_id -- напишите код здесь 
				INNER JOIN dwh.d_product dp ON fo.product_id = dp.product_id -- напишите код здесь 
				LEFT JOIN dwh.craftsman_report_datamart crd ON fo.order_id = crd.id  -- напишите код здесь 
					WHERE fo.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart) OR
								dcs.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart) OR
								dp.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart) OR
								dc.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart)
);



3.
В выборке dwh.dwh_delta содержится информация о новых и обновлённых данных. Чтобы определить, какие данные надо обновить, напишите SELECT-запрос в таблицу dwh.dwh_delta, который вернёт craftsman_id только изменённых данных.


-- создаём таблицу dwh.dwh_update_delta: делаем выборку мастеров, по которым были изменения в DWH. Данные по этим мастерам нужно будет обновить в витрине.
DROP TABLE IF EXISTS dwh.dwh_update_delta;
CREATE TABLE IF NOT EXISTS dwh.dwh_update_delta AS (
	SELECT dd.craftsman_id 
    FROM dwh.dwh_delta dd 
    where dd.exist_craftsman_id is not NULL	
);

-- проверка данных
---SELECT * FROM dwh.dwh_update_delta;