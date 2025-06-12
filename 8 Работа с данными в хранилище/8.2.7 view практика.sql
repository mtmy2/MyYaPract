Получите информацию за месяц для отчёта из хранилища. Данные для отчёта должны быть представлены в виде MATERIALIZED VIEW.
Материализованное представление должно состоять из следующих столбцов:
total_money — общая стоимость всех заказов,
total_products — количество заказанных товаров,
avg_age_craftsman — средний возраст мастера,
avg_age_customer — средний возраст заказчика,
count_order_created — количество созданных заказов,
count_order_in_progress — количество заказов в процессе изготовки,
count_order_delivery — количество заказов в доставке,
count_order_done — количество завершённых заказов,
count_order_not_done — количество незавершённых заказов,
avg_days_complete_orders — среднее количество дней на выполнение заказа,
median_days_complete_orders — медианное количество дней на выполнение заказа.
Здесь пригодятся те же функции, которые вы использовали при реализации инкрементальной витрины данных.



--Запрос на удаление MATERIALIZED VIEW. Применять можно при необходимости
DROP MATERIALIZED VIEW IF EXISTS dwh.orders_report_materialized_view;

CREATE MATERIALIZED VIEW IF NOT EXISTS dwh.orders_report_materialized_view
AS
SELECT 	
		SUM(T1.product_price) - (SUM(T1.product_price) * 0.1) AS total_money, -- сумма денег по всем заказам
		count(t1.product_name) AS total_products, -- количество заказанных товаров
		AVG(T1.craftsman_age) AS avg_age_craftsman, -- средний возраст мастера
		AVG(T1.customer_age) AS avg_age_customer, -- средний возраст заказчика
		SUM(CASE WHEN T1.order_status = 'created' THEN 1 ELSE 0 END) AS count_order_created, -- количество созданных заказов
		SUM(CASE WHEN T1.order_status = 'in progress' THEN 1 ELSE 0 END) AS count_order_in_progress, -- количество заказов в процессе изготовки
		SUM(CASE WHEN T1.order_status = 'delivery' THEN 1 ELSE 0 END) AS count_order_delivery, -- количество заказов в доставке
		SUM(CASE WHEN T1.order_status = 'done' THEN 1 ELSE 0 END) AS count_order_done, -- количество завершённых заказов
		SUM(CASE WHEN T1.order_status != 'done' THEN 1 ELSE 0 END) AS count_order_not_done, -- количество незавершённых заказов
		AVG(T2.diff_order_date) AS avg_days_complete_orders, -- среднее количество дней на выполнение заказа
		PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY diff_order_date) AS median_days_complete_orders, -- медианное количество дней на выполнение заказа
		report_period -- отчётный месяц
	FROM (
		SELECT 	
				fo.order_id AS order_id, -- идентификатор заказа
				fo.order_completion_date AS order_completion_date, -- дата исполнения заказа
				fo.order_created_date AS order_created_date, -- дата создания заказа
				dp.product_price AS product_price, -- цена товара
				dp.product_name AS product_name, -- название товара
				fo.order_status AS order_status, -- статус выполнения заказа
				TO_CHAR(fo.order_created_date, 'yyyy-mm') AS report_period, -- год и месяц, по которому будет происходить группировка
				date_part('year', age(dc.craftsman_birthday)) AS craftsman_age, -- возраст мастера
				date_part('year', age(dcs.customer_birthday)) AS customer_age -- возраст заказчика
				FROM dwh.f_order fo 
					INNER JOIN dwh.d_product dp ON fo.product_id = dp.product_id -- присоединяем к заказам информацию по мастерам
					INNER JOIN dwh.d_craftsman dc ON fo.craftsman_id = dc.craftsman_id  -- присоединяем к заказам информацию по заказчикам
					INNER JOIN dwh.d_customer dcs ON fo.customer_id = dcs.customer_id -- присоединяем к заказам информацию по товарам
	) AS T1 -- даём имя T1 таблице, полученной из вложенного запроса выше
		LEFT JOIN ( -- присоединяем таблицу со сроками в днях по всем заказам из вложенного запроса ниже
			SELECT 	
					order_id, -- идентификатор заказа, чтобы выполнить join с таблицей T1
					order_completion_date - order_created_date AS diff_order_date -- количество дней от момента создания заказа до его выполнения
					FROM dwh.f_order inner_fo
						WHERE  inner_fo.order_completion_date IS NOT null and inner_fo.order_status = 'done' -- из списка всех заказов берём только те, которые завершились и у которых есть дата завершения заказа, чтобы избежать неполных данных в записях
		) AS T2 ON T1.order_id = T2.order_id -- даём имя вложенной таблице с количеством дней на заказ T2 и присоединяем её по order_id к таблице T1
			group by T1.report_period--напишите ваш код здесь -- группируем по месяцам итоговую таблицу
	order by total_money; -- сортируем по сумме денег

-- Запрос, который проверяет, что отчёт не пустой со строкой-примером данных                
-- SELECT * FROM dwh.orders_report_materialized_view limit 1;