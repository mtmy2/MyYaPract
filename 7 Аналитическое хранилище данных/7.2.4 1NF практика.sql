1NF: практика
Таблица source1.craft_market_wide ждёт не дождётся, когда она наконец станет соответствовать критериям первой нормальной формы. Напомним их:
в таблице нет дублирующих строк;
данные каждого столбца таблицы приведены к одному типу;
атрибуты таблицы приведены к атомарному виду (то есть их нельзя поделить на более мелкие составные значения).


1.
Создайте схему nf_lesson.
В Postgres таблицы можно создавать из результатов запроса с помощью команды CREATE TABLE <table_name> AS SELECT…. Подробнее об этом способе создания таблиц можно почитать тут. Создайте таблицу nf_lesson.preparatory_1_1nf с помощью запроса из таблицы source1.craft_market_wide следующих полей:
id
craftsman_name
craftsman_address
customer_name
customer_address


/* Создание схемы nf_lesson */
create schema nf_lesson;

/* Создание таблицы nf_lesson.preparatory_1_1nf */

DROP TABLE IF EXISTS nf_lesson.preparatory_1_1nf;
CREATE TABLE nf_lesson.preparatory_1_1nf AS
SELECT
	id, -- идентификатор записи
	craftsman_name,
    craftsman_address,
    customer_name,
    customer_address
	/* Задайте выражение для создания колонок таблицы */
FROM source1.craft_market_wide;

/* Задание первичного ключа таблицы */
ALTER TABLE nf_lesson.preparatory_1_1nf ADD CONSTRAINT pk_preparatory_1_1nf PRIMARY KEY (id);


2.
Имена и фамилии из полей craftsman_name и customer_name нужно разделить и сложить в разные колонки новой таблицы. Для этого используйте функцию regexp_split_to_array(<column_name>, шаблон). Она разделяет содержимое строки конкретной колонки, используя в качестве разделителя шаблон. Шаблон задаётся регулярным выражением.
В случае с именами и фамилиями, как разбить колонку на две, подскажет пробел. Функция будет выглядеть так: regexp_split_to_array(<column_name>, '\s+'), где: 
<column_name> — имя колонки, содержимое которой вы разделяете по пробелу;
'\s+' — шаблон, состоящий из специального символа «\s», обозначающего пробел, и «+», обозначающего, что данный символ (пробел) встречается в строке один или более раз.
Подробнее о функции regexp_split_to_array() и регулярных выражениях можно почитать тут. 
Напишите запрос, который вернёт:
id
craftsman_name
craftsman_surname
craftsman_address
customer_name
customer_surname
customer_address
В качестве таблицы-источника используйте nf_lesson1.preparatory_1_1nf.
Из результатов запроса из первого пункта с помощью команды CREATE TABLE <table_name> AS SELECT… создайте таблицу nf_lesson.preparatory_2_1nf.

/* Запрос */
SELECT id, -- идентификатор записи 
	/* Задайте выражение для создания колонок:*/
		(regexp_split_to_array(craftsman_name , '\s+'))[1] AS craftsman_name,		-- имя мастера
		(regexp_split_to_array(craftsman_name , '\s+'))[2] AS craftsman_surname,		-- фамилия мастера
		(regexp_split_to_array(craftsman_address , '\s'))[1] AS craftsman_address,		-- адрес мастера
            (regexp_split_to_array(customer_name , '\s+'))[1] AS customer_name,			-- имя заказчика
            (regexp_split_to_array(customer_name , '\s+'))[2] AS customer_surname,-- фамилия заказчика
		(regexp_split_to_array(customer_address , '\s'))[1] AS customer_address	-- адрес заказчика		
			
 
FROM nf_lesson.preparatory_1_1nf;

/* Создание таблицы nf_lesson.preparatory_2_1nf */

DROP TABLE IF EXISTS nf_lesson.preparatory_2_1nf;
CREATE TABLE nf_lesson.preparatory_2_1nf AS
SELECT id, -- идентификатор записи 
	/* Задайте выражение для создания колонок:*/
		(regexp_split_to_array(craftsman_name , '\s+'))[1] AS craftsman_name,		-- имя мастера
		(regexp_split_to_array(craftsman_name , '\s+'))[2] AS craftsman_surname,		-- фамилия мастера
		(regexp_split_to_array(craftsman_address , '\s'))[1]::varchar AS craftsman_address,		-- адрес мастера
		(regexp_split_to_array(customer_name , '\s+'))[1] AS customer_name,			-- имя заказчика
		(regexp_split_to_array(customer_name , '\s+'))[2] AS customer_surname,-- фамилия заказчика
		(regexp_split_to_array(customer_address , '\s'))[1]::varchar AS customer_address	-- адрес заказчика		
FROM nf_lesson.preparatory_1_1nf;

/* Задание первичного ключа таблицы */
ALTER TABLE nf_lesson.preparatory_2_1nf ADD CONSTRAINT pk_preparatory_2_1nf PRIMARY KEY (id);



3.
Когда названия улиц и номера домов хранятся в одной колонке, проводить аналитику по каждой из этих сущностей крайне неудобно. Нужно их разделить и сложить в разные колонки. Для этого используйте функцию regexp_match(<column_name>, шаблон). Она ищет подстроку по заданному шаблону в строке в нужной вам колонке.
Адреса мастеров и заказчиков — это номера домов, которые состоят из цифр, и названия улиц, которые состоят из одного или нескольких слов. Чтобы найти подстроку, содержащую только цифры, необходимо выполнить SELECT regexp_match(<column_name>, '\d+') FROM <table_name>, где '\d+' — шаблон, состоящий из специального символа «\d», обозначающего цифры от 0 до 9, и «+», показывающего, что данный символ (цифры) встречается в строке один или более раз. 
Запрос, который вернёт строку, содержащую одно или более слов, разделённых пробелами, выглядит так: SELECT (regexp_match(<column_name>, '[a-zA-Z]+[a-zA-Z\s]+'))[1] FROM <table_name>, где '[a-zA-Z]+[a-zA-Z\s]+' — это регулярное выражение, которое соответствует последовательности символов, начинающихся с одной или более букв от a до z в нижнем или верхнем регистре, а затем содержащих любую комбинацию букв и пробелов. Здесь:
[a-zA-Z]+ означает одну или более букв от a до z независимо от регистра;
[a-zA-Z\s]+ означает одну или более последовательности символов, состоящих из букв и пробелов.
Так, регулярное выражение '[a-zA-Z]+[a-zA-Z\s]+' будет соответствовать, например, ‘Marquette’ или ‘Briar Crest Crossing’.
Подробнее о функции regexp_match() и регулярных выражениях можно почитать тут.
Напишите запрос, который вернёт:
id
craftsman_name
craftsman_surname
craftsman_address_building
craftsman_address_street
customer_name
customer_surname
customer_address_building
customer_address_street
В качестве таблицы-источника используйте nf_lesson.preparatory_2_1nf.
Из результатов запроса из первого пункта с помощью команды CREATE TABLE <table_name> AS SELECT… создайте таблицу nf_lesson.preparatory_3_1nf.

/* Запрос */
SELECT  id, -- идентификатор записи
		craftsman_name,		-- имя мастера
		craftsman_surname,		-- фамилия мастера
		(regexp_match(craftsman_address, '\d+'))[1] as craftsman_address_building,		-- номер дома мастера
		(regexp_match(craftsman_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as craftsman_address_street,		-- название улицы мастера
		customer_name,		-- имя заказчика
		customer_surname,	-- фамилия заказчика
		(regexp_match(customer_address, '\d+'))[1] as customer_address_building,		-- номер дома заказчика
		(regexp_match(customer_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as customer_address_street		-- название улицы заказчикаFROM nf_lesson.preparatory_2_1nf;
FROM nf_lesson.preparatory_2_1nf;

/* Создание таблицы nf_lesson.preparatory_3_1nf */

DROP TABLE IF EXISTS nf_lesson.preparatory_3_1nf;
CREATE TABLE nf_lesson.preparatory_3_1nf AS
SELECT  id, -- идентификатор записи
		craftsman_name,		-- имя мастера
		craftsman_surname,		-- фамилия мастера
		(regexp_match(craftsman_address, '\d+'))[1] as craftsman_address_building,		-- номер дома мастера
		(regexp_match(craftsman_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as craftsman_address_street,		-- название улицы мастера
		customer_name,		-- имя заказчика
		customer_surname,	-- фамилия заказчика
		(regexp_match(customer_address, '\d+'))[1] as customer_address_building,		-- номер дома заказчика
		(regexp_match(customer_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as customer_address_street		-- название улицы заказчикаFROM nf_lesson.preparatory_2_1nf;
FROM nf_lesson.preparatory_2_1nf;
/* Задание первичного ключа таблицы */
ALTER TABLE nf_lesson.preparatory_3_1nf ADD CONSTRAINT pk_preparatory_3_1nf PRIMARY KEY (id);



4.
Создайте таблицу nf_lesson.craft_market_wide_1nf — это должна быть первая нормальная форма для модели данных таблицы source1.craft_market_wide. 
Для создания таблицы используйте команду CREATE TABLE <table_name> AS SELECT <columns_list> FROM <source_table_name>. 
Используйте наработки из предыдущих заданий, чтобы разделить данные в неатомарных колонках на несколько полей.


/* Создание таблицы nf_lesson.craft_market_wide_1nf */

DROP TABLE IF EXISTS nf_lesson.craft_market_wide_1nf;
CREATE TABLE nf_lesson.craft_market_wide_1nf AS
SELECT
	id, -- идентификатор записи
	craftsman_id,
	(regexp_split_to_array(craftsman_name , '\s+'))[1] AS craftsman_name,
	(regexp_split_to_array(craftsman_name , '\s+'))[2] AS craftsman_surname,
	(regexp_match(craftsman_address, '\d+'))[1] as craftsman_address_building,		-- номер дома мастера
	(regexp_match(craftsman_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as craftsman_address_street,	
	craftsman_birthday,
	craftsman_email,
	product_id,
	product_name,
	product_description,
	product_type,
	product_price,
	order_id,
	order_created_date,
	order_completion_date,
	order_status,
	customer_id,
	(regexp_split_to_array(customer_name , '\s+'))[1] AS customer_name,			-- имя заказчика
	(regexp_split_to_array(customer_name , '\s+'))[2] AS customer_surname,
	(regexp_match(customer_address, '\d+'))[1] as customer_address_building,		-- номер дома заказчика
	(regexp_match(customer_address, '[a-zA-Z]+[a-zA-Z\s]+'))[1]::text as customer_address_street,
	customer_birthday,
	customer_email
	/* Задайте выражение для создания колонок таблицы */
FROM source1.craft_market_wide;

ALTER TABLE nf_lesson.craft_market_wide_1nf ADD CONSTRAINT pk_craft_market_wide_1nf PRIMARY KEY (id);