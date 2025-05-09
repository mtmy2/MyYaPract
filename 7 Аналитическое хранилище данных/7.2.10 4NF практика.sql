

Чтобы перевести таблицу nf_lesson.source_4nf в 4NF, декомпозируйте её на две: nf_lesson.subject_teacher_4nf и nf_lesson.subject_book_4nf. 
Используйте команду CREATE TABLE <table_name> AS SELECT для создания таблицы.

/*Создание таблицы nf_lesson.subject_teacher_4nf*/

DROP TABLE IF EXISTS nf_lesson.subject_teacher_4nf;
CREATE TABLE nf_lesson.subject_teacher_4nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	subject,
	teacher
FROM nf_lesson.source_4nf;

/*Создание таблицы nf_lesson.subject_book_4nf*/

DROP TABLE IF EXISTS nf_lesson.subject_book_4nf;
CREATE TABLE nf_lesson.subject_book_4nf AS
SELECT DISTINCT 

		/* Задайте выражение для создания колонок таблицы */
	subject,
	book
FROM nf_lesson.source_4nf;