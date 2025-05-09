1.
Вы определили, что для перевода таблицы nf_lesson.source_5nf в 5NF необходимо декомпозировать её на три таблицы:
nf_lesson.marketplace_craftsman_5nf
nf_lesson.marketplace_product_5nf
nf_lesson.craftsman_product_5nf
Создайте их с помощью команды CREATE TABLE <table_name> AS SELECT.


/*Создание таблицы nf_lesson.marketplace_craftsman_5nf*/

DROP TABLE IF EXISTS nf_lesson.marketplace_craftsman_5nf;
CREATE TABLE nf_lesson.marketplace_craftsman_5nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	marketplace,

	craftsman
	
	
FROM nf_lesson.source_5nf;

/*Создание таблицы nf_lesson.marketplace_product_5nf*/

DROP TABLE IF EXISTS nf_lesson.marketplace_product_5nf;
CREATE TABLE nf_lesson.marketplace_product_5nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	marketplace,
	create_dttm,
	product
FROM nf_lesson.source_5nf;

/*Создание таблицы nf_lesson.craftsman_product_5nf*/

DROP TABLE IF EXISTS nf_lesson.craftsman_product_5nf;
CREATE TABLE nf_lesson.craftsman_product_5nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	craftsman,
	create_dttm,
	craftsman_status,
	product
FROM nf_lesson.source_5nf;


2.
Убедитесь, что соединение полученных в предыдущем задании таблиц вернёт таблицу, идентичную nf_lesson.source_5nf. Напишите нужный запрос.

/* Соединение таблиц */
SELECT distinct /* Перечислите колонки */
	mc.marketplace,
	mc.craftsman,
	mp.product,
	cp.create_dttm,
	cp.craftsman_status

FROM nf_lesson.marketplace_craftsman_5nf as mc 
join nf_lesson.marketplace_product_5nf as mp using(marketplace)
join nf_lesson.craftsman_product_5nf as cp on mp.product = cp.product and mc.craftsman=cp.craftsman and cp.create_dttm=mp.create_dttm;

/* Присоедините таблицы */