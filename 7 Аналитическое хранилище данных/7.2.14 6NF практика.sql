1.
Для перевода таблиц nf_lesson.marketplace_craftsman_5nf и nf_lesson.craftsman_product_5nf в 6NF необходимо декомпозировать их на три таблицы:
nf_lesson.craftsman_craftsman_status_6nf
nf_lesson.marketplace_craftsman_6nf
nf_lesson.craftsman_product_6nf
Начните с таблицы nf_lesson.craftsman_craftsman_status_6nf. Создайте её с помощью команды CREATE TABLE <table_name> AS SELECT. Не забудьте добавить дату и время создания строки (колонку create_dttm).


/*Создание таблицы nf_lesson.craftsman_craftsman_status_6nf*/

DROP TABLE IF EXISTS nf_lesson.craftsman_craftsman_status_6nf;
CREATE TABLE nf_lesson.craftsman_craftsman_status_6nf AS

		/* Задайте выражение для создания колонок таблицы */
SELECT DISTINCT craftsman, craftsman_status, create_dttm

FROM nf_lesson.marketplace_craftsman_5nf;


2.
Создайте таблицу nf_lesson.marketplace_craftsman_6nf с помощью команды CREATE TABLE <table_name> AS SELECT. Не забудьте добавить дату и время создания строки (колонку create_dttm).


/*Создание таблицы nf_lesson.marketplace_craftsman_6nf*/

DROP TABLE IF EXISTS nf_lesson.marketplace_craftsman_6nf;
CREATE TABLE nf_lesson.marketplace_craftsman_6nf AS

		/* Задайте выражение для создания колонок таблицы */
SELECT DISTINCT marketplace, craftsman, create_dttm
FROM nf_lesson.marketplace_craftsman_5nf;



3.
Cоздайте таблицу nf_lesson.craftsman_product_6nf с помощью команды CREATE TABLE <table_name> AS SELECT. Не забудьте добавить дату и время создания строки (колонку create_dttm).

/*Создание таблицы nf_lesson.craftsman_product_6nf*/

DROP TABLE IF EXISTS nf_lesson.craftsman_product_6nf;
CREATE TABLE nf_lesson.craftsman_product_6nf AS

		/* Задайте выражение для создания колонок таблицы */
SELECT DISTINCT craftsman, product, create_dttm 
FROM nf_lesson.craftsman_product_5nf;