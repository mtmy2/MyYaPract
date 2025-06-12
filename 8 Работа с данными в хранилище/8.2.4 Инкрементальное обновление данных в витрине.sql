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


4.
Напишите SELECT-запрос с выборкой, которая должна будет заполнить витрину dwh.craftsman_report_datamart новыми данными. Новые данные для витрины сохраните в отдельную таблицу dwh.dwh_delta_insert_result.
В запросе должны быть указаны все колонки, которые есть в витрине:
в dwh_delta — craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email.
craftsman_money вычисляется как сумма всех product_price в группировке по столбцам craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, report_period минус 10%.
platform_money вычисляется как 10% от суммы product_price с группировкой по столбцам craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, report_period.
count_order вычисляется с помощью COUNT с группировкой по столбцам craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, report_period.
avg_price_order вычисляется с помощью AVG() с группировкой по столбцам craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, report_period.
avg_age_customer вычисляется с помощью AVG() с группировкой craftsman_id, craftsman_name, craftsman_address, craftsman_birthday, craftsman_email, report_period.
median_time_order_completed вычисляется с помощью агрегатной функции percentile_cont(0.5) WITHIN GROUP(ORDER BY column) — эта функция находит перцентиль, в нашем случае 50-й (0.5) от всех значений столбца. Или, другими словами, функция вернёт значение, которое равноудалено от максимального и минимального значений столбца. Медиану считайте по колонке diff_order_date.
top_product_category нужно будет посчитать в другом подзапросе и объединить её с другими колонками, потому что для расчёта этой колонки потребуется другая группировка — craftsman_id и product_type, чтобы сначала посчитать все товары по типам с помощью COUNT, а потом с помощью оконной функции RANK() OVER(PARTITION BY columnA ORDER BY columnB DESC) определить наиболее популярную категорию товара. Эта оконная функция позволяет получить рейтинг записей, в рамках указанной группы в PARTITION. Она похожа на ROW_NUMBER() и отличается только тем, что RANK() может вернуть несколько записей с одинаковым рейтингом, тогда как ROW_NUMBER() не допустит дублей. Посмотрите на примере:

WITH T(ID, SECOND_ID) AS (
    SELECT 1,1 UNION ALL
    SELECT 1,1 UNION ALL
    SELECT 1,1 UNION ALL
    SELECT 1,2
)
SELECT *,
       RANK() OVER(PARTITION BY ID ORDER BY SECOND_ID)       AS RANK,
       ROW_NUMBER() OVER(PARTITION BY ID ORDER BY SECOND_ID) AS ROW_NUMBER
FROM   T;

-- Результат
--id|second_id|rank|row_number|
----+---------+----+----------+
-- 1|        1|   1|         1|
-- 1|        1|   1|         2|
-- 1|        1|   1|         3|
-- 1|        2|   4|         4| 
    Обратите внимание, что RANK() дал первое место в рейтинге всем одинаковым значениям в строке. Вы можете самостоятельно выбрать одну запись по дополнительным параметрам или использовать все, если это необходимо. ROW_NUMBER() в отличии от RANK() нумерует строки последовательно, даже если в них есть одинаковые значения. В прекоде задания использован именно RANK(), чтобы добавить гибкости в решение и получить все строки с одинаковыми значениями — в будущем это позволит создавать более полные выборки данных.
    Недостаток RANK() в том, что он может искусственно увеличивать выборку данных. Но такое возможно, когда большое количество товаров в выборке одинаково популярно, а вероятность этого крайне мала даже в больших выборках. Если же, например, для другой задачи такая ситуация может возникать достаточно часто и при этом можно выбрать любую из одинаковых записей, то разумно использовать ROW_NUMBER().
Вычисляемые колонки с условием

Условие: если в колонке появляется определённое значение, то просуммировать это значение как единицу. Пример: sum(CASE WHEN column = 'value' THEN 1 ELSE 0 END).

count_order_created — если order_status = ‘created’.
count_order_in_progress — если order_status = ‘in progress’.
count_order_delivery — если order_status = ‘delivery’.
count_order_done — если order_status = ‘done’.
count_order_not_done — если order_status != ‘done’.
report_period — из dwh_delta.



-- создаём таблицу dwh.dwh_delta_insert_result: делаем расчёт витрины по новым данным 
-- этой информации по мастерам в рамках расчётного периода раньше не было. Это новые данные, которые можно просто вставить (insert) в витрину без обновления
DROP TABLE IF EXISTS dwh.dwh_delta_insert_result;
CREATE TABLE IF NOT EXISTS dwh.dwh_delta_insert_result AS ( 
	SELECT  
			T4.craftsman_id AS craftsman_id,
			T4.craftsman_name AS craftsman_name,
			T4.craftsman_address AS craftsman_address,
			T4.craftsman_birthday AS craftsman_birthday,
			T4.craftsman_email AS craftsman_email,
			T4.craftsman_money AS craftsman_money,
			T4.platform_money AS platform_money,
			T4.count_order AS count_order,
			T4.avg_price_order AS avg_price_order,
			T4.avg_age_customer AS avg_age_customer,
			T4.product_type AS top_product_category,
			T4.median_time_order_completed AS median_time_order_completed,
			T4.count_order_created AS count_order_created,
			T4.count_order_in_progress AS count_order_in_progress,
			T4.count_order_delivery AS count_order_delivery,
			T4.count_order_done AS count_order_done,
			T4.count_order_not_done AS count_order_not_done,
			T4.report_period AS report_period 
			FROM (
				SELECT 	-- в этой выборке объединяем две внутренние выборки по расчёту столбцов витрины и применяем оконную функцию, чтобы определить самую популярную категорию товаров
						*,
						RANK() OVER(PARTITION BY T2.craftsman_id ORDER BY count_product DESC) AS rank_count_product 
						FROM ( 
							SELECT -- в этой выборке делаем расчёт по большинству столбцов, так как все они требуют одной и той же группировки, кроме столбца с самой популярной категорией товаров у мастера. Для этого столбца сделаем отдельную выборку с другой группировкой и выполним join
								t1.craftsman_id as craftsman_id,
								t1.craftsman_name as craftsman_name, 
								t1.craftsman_address as craftsman_address,
								t1.craftsman_birthday as craftsman_birthday,
								t1.craftsman_email as craftsman_email,
								SUM(T1.product_price) - (SUM(T1.product_price) * 0.1) as craftsman_money,
								SUM(T1.product_price) * 0.1 AS platform_money,
								COUNT(order_id) AS count_order,
								AVG(T1.product_price) AS avg_price_order,
								AVG(T1.customer_age) AS avg_age_customer,
								PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY diff_order_date) AS median_time_order_completed,
								SUM(CASE WHEN T1.order_status = 'created' THEN 1 ELSE 0 END) AS count_order_created,
								SUM(CASE WHEN T1.order_status = 'in progress' THEN 1 ELSE 0 END) AS count_order_in_progress,
								SUM(CASE WHEN T1.order_status = 'delivery' THEN 1 ELSE 0 END) AS count_order_delivery,
								SUM(CASE WHEN T1.order_status = 'done' THEN 1 ELSE 0 END) AS count_order_done,
								SUM(CASE WHEN T1.order_status != 'done' THEN 1 ELSE 0 END) AS count_order_not_done,
								T1.report_period AS report_period
								FROM dwh.dwh_delta AS T1
									WHERE T1.exist_craftsman_id IS NULL
										GROUP BY T1.craftsman_id, T1.craftsman_name, T1.craftsman_address, T1.craftsman_birthday, T1.craftsman_email, T1.report_period
							) AS T2 
								INNER JOIN (
									SELECT 	-- эта выборка поможет определить самый популярный товар у мастера. Это выборка не делается в предыдущем запросе, так как нужна другая группировка. Для данных этой выборки можно применить оконную функцию, которая и покажет самую популярную категорию товаров у мастера
											dd.craftsman_id as craftsman_id_for_product_type,
											dd.product_type,
											COUNT(dd.product_id) AS count_product
											FROM dwh.dwh_delta AS dd
												GROUP BY dd.craftsman_id, dd.product_type
													ORDER BY count_product DESC) AS T3 ON T2.craftsman_id = T3.craftsman_id_for_product_type
				) AS T4 WHERE T4.rank_count_product = 1 ORDER BY report_period -- условие помогает оставить в выборке первую по популярности категорию товаров
);

-- проверка данных
-- SELECT * FROM dwh.dwh_delta_insert_result;




5.
Расчёт витрины для данных обновления очень похож на расчёт витрины для данных вставки. 
Его можно делать по аналогии с расчётом витрины для данных с одним лишь нюансом: для начала нужно получить конкретные данные по колонкам, 
которые нужно пересчитать вместе с новыми данными. Это означает, что для существующих в хранилище мастеров появились новые данные по их заработку, 
продаже и прочим атрибутам. Для них нужно обновить итоговый отчёт. 
Попробуйте самостоятельно, по аналогии с шагом 4, выполнить расчёт витрины для данных обновления. 
В select должны присутствовать все те же колонки, что и на предыдущем шаге. Сохраните результаты в отдельную таблицу dwh.dwh_delta_update_result.



-- создаём таблицу dwh_delta_update_result: делаем перерасчёт для существующих записей витрины данных, так как данные обновились за отчётные периоды 
-- логика похожа на insert, но нужно достать конкретные данные из DWH
DROP TABLE IF EXISTS dwh.dwh_delta_update_result;
CREATE TABLE IF NOT EXISTS dwh.dwh_delta_update_result AS ( 
	SELECT 
			T4.craftsman_id AS craftsman_id,
			T4.craftsman_name AS craftsman_name,
			T4.craftsman_address AS craftsman_address,
			T4.craftsman_birthday AS craftsman_birthday,
			T4.craftsman_email AS craftsman_email,
			T4.craftsman_money AS craftsman_money,
			T4.platform_money AS platform_money,
			T4.count_order AS count_order,
			T4.avg_price_order AS avg_price_order,
			T4.avg_age_customer AS avg_age_customer,
			T4.product_type AS top_product_category,
			T4.median_time_order_completed AS median_time_order_completed,
			T4.count_order_created AS count_order_created,
			T4.count_order_in_progress AS count_order_in_progress,
			T4.count_order_delivery AS count_order_delivery, 
			T4.count_order_done AS count_order_done, 
			T4.count_order_not_done AS count_order_not_done,
			T4.report_period AS report_period 
			FROM (
				SELECT 	-- в этой выборке объединяем две внутренние выборки по расчёту столбцов витрины и применяем оконную функцию, чтобы определить самую популярную категорию товаров
						*,
						RANK() OVER(PARTITION BY T2.craftsman_id ORDER BY count_product DESC) AS rank_count_product 
						FROM (
							SELECT -- в этой выборке делаем расчёт по большинству столбцов, так как все они требуют одной и той же группировки, кроме столбца с самой популярной категорией товаров у мастера. Для этого столбца сделаем отдельную выборку с другой группировкой и выполним join
								T1.craftsman_id AS craftsman_id,
								T1.craftsman_name AS craftsman_name,
								T1.craftsman_address AS craftsman_address,
								T1.craftsman_birthday AS craftsman_birthday,
								T1.craftsman_email AS craftsman_email,
								SUM(T1.product_price) - (SUM(T1.product_price) * 0.1) AS craftsman_money,
								SUM(T1.product_price) * 0.1 AS platform_money,
								COUNT(order_id) AS count_order,
								AVG(T1.product_price) AS avg_price_order,
								AVG(T1.customer_age) AS avg_age_customer,
								PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY diff_order_date) AS median_time_order_completed,
								SUM(CASE WHEN T1.order_status = 'created' THEN 1 ELSE 0 END) AS count_order_created, 
								SUM(CASE WHEN T1.order_status = 'in progress' THEN 1 ELSE 0 END) AS count_order_in_progress, 
								SUM(CASE WHEN T1.order_status = 'delivery' THEN 1 ELSE 0 END) AS count_order_delivery, 
								SUM(CASE WHEN T1.order_status = 'done' THEN 1 ELSE 0 END) AS count_order_done, 
								SUM(CASE WHEN T1.order_status != 'done' THEN 1 ELSE 0 END) AS count_order_not_done,
								T1.report_period AS report_period
								FROM (
									SELECT 	-- в этой выборке достаём из DWH обновлённые или новые данные по мастерам, которые уже присутствуют в витрине
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
											to_char(fo.order_created_date, 'yyyy-mm') AS report_period
											FROM dwh.f_order fo 
												INNER JOIN dwh.d_craftsman dc ON fo.craftsman_id = dc.craftsman_id 
												INNER JOIN dwh.d_customer dcs ON fo.customer_id = dcs.customer_id 
												INNER JOIN dwh.d_product dp ON fo.product_id = dp.product_id
												INNER JOIN dwh.dwh_update_delta ud ON fo.craftsman_id = ud.craftsman_id
								) AS T1
									GROUP BY T1.craftsman_id, T1.craftsman_name, T1.craftsman_address, T1.craftsman_birthday, T1.craftsman_email, T1.report_period
							) AS T2 
								INNER JOIN (
									SELECT 	-- эта выборка поможет определить самый популярный товар у мастера. Выборка не делается в предыдущем запросе, так как нужна другая группировка. Для данных этой выборки можно применить оконную функцию, которая и покажет самую популярную категорию товаров у мастера
											dd.craftsman_id AS craftsman_id_for_product_type, 
											dd.product_type, 
											COUNT(dd.product_id) AS count_product
											FROM dwh.dwh_delta AS dd
												GROUP BY dd.craftsman_id, dd.product_type
													ORDER BY count_product DESC) AS T3 ON T2.craftsman_id = T3.craftsman_id_for_product_type
				) AS T4 WHERE T4.rank_count_product = 1 ORDER BY report_period
);

-- проверка данных
-- SELECT * FROM dwh.dwh_delta_update_result;



6.
Попробуйте написать INSERT FROM SELECT для вставки данных в dwh.craftsman_report_datamart из блока dwh_delta_insert_result.


insert into dwh.craftsman_report_datamart
(
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    craftsman_money,
    platform_money,
    count_order,
    avg_price_order,
    avg_age_customer,
    median_time_order_completed,
    top_product_category,
    count_order_created,
    count_order_in_progress,
    count_order_delivery,
    count_order_done,
    count_order_not_done,
    report_period
) 
select
    craftsman_id,
    craftsman_name,
    craftsman_address,
    craftsman_birthday,
    craftsman_email,
    craftsman_money,
    platform_money,
    count_order,
    avg_price_order,
    avg_age_customer,
    median_time_order_completed,
    top_product_category,
    count_order_created,
    count_order_in_progress,
    count_order_delivery,
    count_order_done,
    count_order_not_done,
    report_period
from dwh.dwh_delta_insert_result


7.
Напишите UPDATE FROM SELECT для обновления данных в витрине dwh.craftsman_report_datamart из блока dwh_delta_update_result.

UPDATE dwh.craftsman_report_datamart SET
    craftsman_name = updates.craftsman_name, 
    craftsman_address = updates.craftsman_address, 
    craftsman_birthday = updates.craftsman_birthday, 
    craftsman_email = updates.craftsman_email, 
    craftsman_money = updates.craftsman_money, 
    platform_money = updates.platform_money, 
    count_order = updates.count_order, 
    avg_price_order = updates.avg_price_order, 
    avg_age_customer = updates.avg_age_customer, 
    median_time_order_completed = updates.median_time_order_completed, 
    top_product_category = updates.top_product_category, 
    count_order_created = updates.count_order_created, 
    count_order_in_progress = updates.count_order_in_progress, 
    count_order_delivery = updates.count_order_delivery, 
    count_order_done = updates.count_order_done,
    count_order_not_done = updates.count_order_not_done, 
    report_period = updates.report_period
  FROM (
    SELECT 
      craftsman_id,
      craftsman_name,
      craftsman_address,
      craftsman_birthday,
      craftsman_email,
      craftsman_money,
      platform_money,
      count_order,
      avg_price_order,
      avg_age_customer,
      median_time_order_completed,
      top_product_category,
      count_order_created,
      count_order_in_progress,
      count_order_delivery,
      count_order_done,
      count_order_not_done,
      report_period 
      FROM dwh.dwh_delta_update_result) AS updates
  WHERE dwh.craftsman_report_datamart.craftsman_id = updates.craftsman_id