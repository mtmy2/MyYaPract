WITH
dwh_delta AS ( -- определяем какие данные были изменены в витрине данных или добавлены в DWH. Формируем дельту изменений.
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
			DATE_PART('year', AGE(dcs.customer_birthday)) AS customer_age,
			fo.order_completion_date - fo.order_created_date AS diff_order_date, 
			fo.order_status AS order_status,
			TO_CHAR(fo.order_created_date, 'yyyy-mm') AS report_period,
			crd.craftsman_id AS exist_craftsman_id,
			dc.load_dttm AS craftsman_load_dttm,
			dcs.load_dttm AS customers_load_dttm,
			dp.load_dttm AS products_load_dttm
			FROM dwh.f_order fo 
				INNER JOIN dwh.d_craftsman dc ON fo.craftsman_id = dc.craftsman_id 
				INNER JOIN dwh.d_customer dcs ON fo.customer_id = dcs.customer_id 
				INNER JOIN dwh.d_product dp ON fo.product_id = dp.product_id 
				LEFT JOIN dwh.craftsman_report_datamart crd ON dc.craftsman_id = crd.craftsman_id
					WHERE (fo.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart)) OR
							(dc.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart)) OR
							(dcs.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart)) OR
							(dp.load_dttm > (SELECT COALESCE(MAX(load_dttm),'1900-01-01') FROM dwh.load_dates_craftsman_report_datamart))
),
dwh_update_delta AS ( -- делаем выборку мастеров ручной работы, по которым были изменения в DWH. Значит по этим мастерам данные в витрине нужно будет обновить.
	SELECT 	
			dd.exist_craftsman_id AS craftsman_id
			FROM dwh_delta dd 
				WHERE dd.exist_craftsman_id IS NOT NULL		
),
dwh_delta_insert_result AS ( -- делаем расчёт витрины по новым данным. Этой информации по мастерам в рамках расчётного периода раньше не было, то есть это новые данные, а значит их можно просто вставить (insert) в витрину без обновления
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
				SELECT 	-- в этой выборке объединяем две внутренние выборки по расчёту столбцов витрины и применяем оконную функцию для определения самой популярной категории товаров
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
								FROM dwh_delta AS T1
									WHERE T1.exist_craftsman_id IS NULL
										GROUP BY T1.craftsman_id, T1.craftsman_name, T1.craftsman_address, T1.craftsman_birthday, T1.craftsman_email, T1.report_period
							) AS T2 
								INNER JOIN (
									SELECT 	-- Эта выборка поможет определить самый популярный товар у мастера ручной работы. Это выборка не делается в предыдущем запросе, так как нужна другая группировка. Для данных этой выборки можно применить оконную функцию, которая и покажет самую популярную категорию товаров у мастера
											dd.craftsman_id AS craftsman_id_for_product_type, 
											dd.product_type, 
											COUNT(dd.product_id) AS count_product
											FROM dwh_delta AS dd
												GROUP BY dd.craftsman_id, dd.product_type
													ORDER BY count_product DESC) AS T3 ON T2.craftsman_id = T3.craftsman_id_for_product_type
				) AS T4 WHERE T4.rank_count_product = 1 ORDER BY report_period -- условие помогает оставить в выборке первую по популярности категорию товаров
)
INSERT INTO tableA (
		columnA,
		columnB,
		columnC
	) SELECT 
			columnA
			columnB
			columnC
			FROM tableB