Индексы на практике
В этом уроке разберём планы запросов с каждым типом индекса. Для изучения работы индексов вам понадобится достаточно большая демонстрационная БД. Такую БД предоставляет Postgres Professional. Информация о ней располагается здесь.
Демонстрационную БД можно скачать и импортировать локально. Для этого перейдите по ссылке выше.
Hash
Для начала давайте рассмотрим hash-индекс. Он самый простой, потому что данные индексируются для запросов с проверкой эквивалентности — применением оператора =.
Выполним запрос без индекса:

EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code = '321';

--QUERY PLAN                                                   |
---------------------------------------------------------------+
--Seq Scan on flights  (cost=0.00..5323.84 rows=12484 width=63)|
--  Filter: (aircraft_code = '321'::bpchar)                    | 
Seq Scan on flights из плана говорит о том, что таблица была полностью последовательно просканирована, и вернулись все записи, соответствующие условию aircraft_code = '321'. В cost — условная стоимость запроса.
Построим hash-индекс:

CREATE INDEX flights_hash_index ON bookings.flights using hash(aircraft_code);

-- убедимся, что индекс создан
SELECT * FROM pg_indexes WHERE tablename = 'flights';

--schemaname|tablename|indexname                                |tablespace|indexdef                                                                                                                      |
------------+---------+-----------------------------------------+----------+------------------------------------------------------------------------------------------------------------------------------+
--bookings  |flights  |flights_flight_no_scheduled_departure_key|          |CREATE UNIQUE INDEX flights_flight_no_scheduled_departure_key ON bookings.flights USING btree (flight_no, scheduled_departure)|
--bookings  |flights  |flights_pkey                             |          |CREATE UNIQUE INDEX flights_pkey ON bookings.flights USING btree (flight_id)                                                  |
**--bookings  |flights  |flights_hash_index                       |          |CREATE INDEX flights_hash_index ON bookings.flights USING hash (aircraft_code)                                                |** 
Выполним тот же запрос, но теперь с индексом:

EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code = '321';
--QUERY PLAN                                                                           |
---------------------------------------------------------------------------------------+
--Bitmap Heap Scan on flights  (cost=400.75..3194.80 rows=12484 width=63)              |
--  Recheck Cond: (aircraft_code = '321'::bpchar)                                      |
--  ->  Bitmap Index Scan on flights_hash_index  (cost=0.00..397.63 rows=12484 width=0)|
--        Index Cond: (aircraft_code = '321'::bpchar)                                  |

-- при этом другое условие уже выполняется без индекса
EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code < '321';
--QUERY PLAN                                                  |
--------------------------------------------------------------+
--Seq Scan on flights  (cost=0.00..5323.84 rows=8172 width=63)|
--  Filter: (aircraft_code < '321'::bpchar)                   | 
Bitmap Index Scan говорит о том, что запрос обратился к индексированным данным, а не выполнял полный скан таблицы. Для полученных данных из индекса выполнена перепроверка условия (Recheck Cond): действительно ли данные удовлетворяют условиям запроса. Общая стоимость ощутимо снизилась с 5323.84 до 3194.80. Если изменить условие с aircraft_code = '321' на aircraft_code < '321', то снова будет происходить сканирование всей таблицы с большой условной стоимостью.
Hash-индекс не будет уменьшаться в размерах, если удалить часть проиндексированных строк. Это обусловлено его внутренним устройством. Чтобы перестроить его с нуля, нужно выполнить либо REINDEX, либо VACUUM FULL. Команда VACUUM FULL выполняет не только реиндексацию. Узнать подробнее об этой команде можно здесь.
B-tree
B-tree используется по умолчанию, если не указывать конкретный тип индекса при создании. B-tree достаточно универсальный и поэтому — самый распространённый.
Создадим индекс на той же таблице по тому же полю, предварительно удалив старый индекс:

DROP INDEX bookings.flights_hash_index;
SELECT * FROM pg_indexes WHERE tablename = 'flights' AND indexname = 'flights_hash_index';
--schemaname|tablename|indexname|tablespace|indexdef|
------------+---------+---------+----------+--------+

EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code = '321';

--QUERY PLAN                                                   |
---------------------------------------------------------------+
--Seq Scan on flights  (cost=0.00..5323.84 rows=12484 width=63)|
--  Filter: (aircraft_code = '321'::bpchar)                    |

CREATE INDEX flights_btree_index ON bookings.flights using btree(aircraft_code);
SELECT * FROM pg_indexes WHERE tablename = 'flights' AND indexname = 'flights_btree_index';
--schemaname|tablename|indexname          |tablespace|indexdef                                                                        |
------------+---------+-------------------+----------+--------------------------------------------------------------------------------+
--bookings  |flights  |flights_btree_index|          |CREATE INDEX flights_btree_index ON bookings.flights USING btree (aircraft_code)| 
Выполним пару запросов с условиями = и <:

EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code = '321';
--QUERY PLAN                                                                            |
----------------------------------------------------------------------------------------+
--Bitmap Heap Scan on flights  (cost=141.05..2935.10 rows=12484 width=63)               |
--  Recheck Cond: (aircraft_code = '321'::bpchar)                                       |
--  ->  Bitmap Index Scan on flights_btree_index  (cost=0.00..137.92 rows=12484 width=0)|
--        Index Cond: (aircraft_code = '321'::bpchar)                                   |

EXPLAIN
SELECT * FROM bookings.flights WHERE aircraft_code < '321';
--QUERY PLAN                                                                          |
--------------------------------------------------------------------------------------+
--Bitmap Heap Scan on flights  (cost=91.63..2831.78 rows=8172 width=63)               |
--  Recheck Cond: (aircraft_code < '321'::bpchar)                                     |
--  ->  Bitmap Index Scan on flights_btree_index  (cost=0.00..89.58 rows=8172 width=0)|
--        Index Cond: (aircraft_code < '321'::bpchar)                                 | 
Если указано условие <, B-tree позволяет получать данные из индекса быстрее, чем hash-индекс.
GiST
Чтобы посмотреть на то, как будет работать GiST, создадим подходящую таблицу: таблицу с координатами аэропортов, где координата — это тип point.

CREATE TABLE airports_coordinates AS SELECT airport_code, airport_name, point(longitude,latitude) as coordinates FROM airports; 
В колонке coordinates содержится значение по оси X (longitude) и значение по оси Y (latitude) в качестве координат аэропорта.
На графике по оси X располагается longitude, по оси Y — latitude. Четыре зелёные точки (0:0, 1:1, 2:4, 4:2) указывают на координаты аэропортов…
Получим все аэропорты, которые попадают в площадь прямоугольника с координатами крайних точек по диагонали (0,0), (100,100).
На график добавился выделенный зелёным цветом прямоугольник с координатами крайних точек (0,0), (100,100). В его границы попали ещё несколько координат аэропортов, также выделенных зелёным цветом. Несколько аэропортов (оранжевые точки) оказались за границами прямоугольника.
Для этого воспользуемся операторами <@, который означает «содержится в», и box '(x1,y1),(x2,y2)’,'
 который задаёт прямоугольник с диагональю от x1,y1 до x2,y2. Чтобы посмотреть другие операторы для координатной плоскости, загляните сюда.
Отключим также последовательное сканирование как предпочтительный вариант выполнения запроса, если существуют другие варианты, например построенные индексы. Делается это с помощью команды SET enable_seqscan = off.

SET enable_seqscan = off;

EXPLAIN
SELECT * FROM airports_coordinates WHERE coordinates <@ BOX '(0,0),(100,100)';

--QUERY PLAN                                                                             |
-----------------------------------------------------------------------------------------+
--Seq Scan on airports_coordinates  (cost=10000000000.00..10000000002.30 rows=1 width=37)|
--  Filter: (coordinates <@ '(100,100),(0,0)'::box)                                      |
--JIT:                                                                                   |
--  Functions: 2                                                                         |
--  Options: Inlining true, Optimization true, Expressions true, Deforming true          | 
Seq Scan выполняется, значит, других вариантов получить данные по запросу, кроме полного сканирования таблицы, нет. 
Строим GiST-индекс по координатам:

CREATE INDEX airports_coordinates_gist_index ON airports_coordinates USING GIST(coordinates);

SELECT * FROM pg_indexes WHERE tablename = 'airports_coordinates' AND indexname = 'airports_coordinates_gist_index';
--schemaname|tablename           |indexname                      |tablespace|indexdef                                                                                              |
------------+--------------------+-------------------------------+----------+------------------------------------------------------------------------------------------------------+
--bookings  |airports_coordinates|airports_coordinates_gist_index|          |CREATE INDEX airports_coordinates_gist_index ON bookings.airports_coordinates USING gist (coordinates)| 
Выполняем запрос:

EXPLAIN
SELECT * FROM airports_coordinates WHERE coordinates <@ BOX '(0,0),(100,100)';
--QUERY PLAN                                                                                                 |
-------------------------------------------------------------------------------------------------------------+
--Index Scan using airports_coordinates_gist_index on airports_coordinates  (cost=0.14..8.15 rows=1 width=37)|
--  Index Cond: (coordinates <@ '(100,100),(0,0)'::box)                                                      | 
Происходит Index Scan, и планировщик может более адекватно оценить стоимость подобного запроса. GiST-индекс хорошо работает с типами данных, где нельзя однозначно определить отношение больше или меньше. По столбцу координат не удастся построить B-tree, так как непонятно, как сравнивать значения.
SP-GiST
Для демонстрации SP-GiST подойдёт тот же пример, что и для GiST. Поддержка операторов у них одинаковая. Но индексы различаются по своему внутреннему устройству, поэтому в каких-то случаях один индекс будет работать эффективнее, а другой — хуже. 
На этот раз применим оператор >^. Запрос с таким оператором вернёт все точки, которые находятся строго выше заданной точки на координатной плоскости. 
Удалим старый индекс GiST и проверим, как выполнится запрос. Затем построим новый индекс SP-GiST.

DROP INDEX airports_coordinates_gist_index;

SELECT * FROM pg_indexes WHERE tablename = 'airports_coordinates' AND indexname = 'airports_coordinates_gist_index';
--schemaname|tablename|indexname|tablespace|indexdef|
------------+---------+---------+----------+--------+

EXPLAIN
SELECT * FROM airports_coordinates WHERE coordinates >^ '(10,10)';
--QUERY PLAN                                                                              |
------------------------------------------------------------------------------------------+
--Seq Scan on airports_coordinates  (cost=10000000000.00..10000000002.30 rows=10 width=37)|
--  Filter: (coordinates >^ '(10,10)'::point)                                             |
--JIT:                                                                                    |
--  Functions: 2                                                                          |
--  Options: Inlining true, Optimization true, Expressions true, Deforming true           |

CREATE INDEX airports_coordinates_spgist_index ON airports_coordinates USING SPGIST(coordinates);

SELECT * FROM pg_indexes WHERE tablename = 'airports_coordinates' AND indexname = 'airports_coordinates_spgist_index';
--schemaname|tablename           |indexname                        |tablespace|indexdef                                                                                                  |
------------+--------------------+---------------------------------+----------+----------------------------------------------------------------------------------------------------------+
--bookings  |airports_coordinates|airports_coordinates_spgist_index|          |CREATE INDEX airports_coordinates_spgist_index ON bookings.airports_coordinates USING spgist (coordinates)| 
Когда GiST был удалён и заново запущен запрос, выполнился Seq Scan. Но был построен новый SP-GiST, поэтому можно снова выполнить запрос:

EXPLAIN
SELECT * FROM airports_coordinates WHERE coordinates >^ '(10,10)';
--QUERY PLAN                                                                                                    |
----------------------------------------------------------------------------------------------------------------+
--Index Scan using airports_coordinates_spgist_index on airports_coordinates  (cost=0.14..8.31 rows=10 width=37)|
--  Index Cond: (coordinates >^ '(10,10)'::point)                                                               | 
Был использован Index Scan using airports_coordinates_spgist_index, при этом стоимость запросов получилась почти одинаковой — что с GiST, что с SP-GiST.
GIN
GIN-индекс позволяет решать задачи полнотекстового поиска: находить текст, который содержит искомые лексемы. Чтобы выполнялся запрос полнотекстового поиска, нужно перевести текст в тип tsvector. Перевести текст в tsvector можно с помощью метода to_tsvector(’text’).
Искусственно создадим новую табличку для полнотекстового поиска с двумя столбцами:
document — столбец с документом;
document_ts — столбец с лексемами.
Создадим таблицу на основе столбца contact_data в таблице tickets. В contact_data лежит JSONB, но мы специально из него сделаем текст для демонстрации.

CREATE TABLE doc_search_table AS SELECT contact_data::TEXT AS document, TO_TSVECTOR(contact_data::TEXT) AS document_ts FROM tickets; 
Теперь сделаем полнотекстовый запрос. Единственный оператор, который используется с полнотекстовым поиском, это @@. После него идёт функция TO_TSQUERY('*condition*'), которая принимает логическое выражение для условия поиска через логические операторы.

EXPLAIN
SELECT document FROM doc_search_table WHERE document_ts @@ TO_TSQUERY('email & phone');
--QUERY PLAN                                                                              |
------------------------------------------------------------------------------------------+
--Gather  (cost=1000.00..539683.34 rows=1600345 width=51)                                 |
--  Workers Planned: 2                                                                    |
--  ->  Parallel Seq Scan on doc_search_table  (cost=0.00..378648.84 rows=666810 width=51)|
--        Filter: (document_ts @@ to_tsquery('email & phone'::text))                      |
--JIT:                                                                                    |
--  Functions: 4                                                                          |
--  Options: Inlining true, Optimization true, Expressions true, Deforming true           | 
В запросе мы ищем только те документы, которые содержат email и phone. Из плана запроса видно, что запускаются параллельные задачи на последовательное сканирование таблицы (Parallel Seq Scan on doc_search_table) — это единственный вариант в текущем состоянии получить нужные данные.
Построим GIN и снова выполним запрос:

CREATE INDEX doc_search_gin_index ON doc_search_table USING GIN(document_ts);

SELECT * FROM pg_indexes WHERE tablename = 'doc_search_table' AND indexname = 'doc_search_gin_index';
--schemaname|tablename       |indexname           |tablespace|indexdef                                                                              |
------------+----------------+--------------------+----------+--------------------------------------------------------------------------------------+
--bookings  |doc_search_table|doc_search_gin_index|          |CREATE INDEX doc_search_gin_index ON bookings.doc_search_table USING gin (document_ts)|

EXPLAIN
SELECT document FROM doc_search_table WHERE document_ts @@ TO_TSQUERY('email & phone');
--QUERY PLAN                                                                                          |
------------------------------------------------------------------------------------------------------+
--Gather  (cost=15792.84..406974.79 rows=1600592 width=51)                                            |
--  Workers Planned: 2                                                                                |
--  ->  Parallel Bitmap Heap Scan on doc_search_table  (cost=14792.84..245915.59 rows=666913 width=51)|
--        Recheck Cond: (document_ts @@ to_tsquery('email & phone'::text))                            |
--        ->  Bitmap Index Scan on doc_search_gin_index  (cost=0.00..14392.69 rows=1600592 width=0)   |
--              Index Cond: (document_ts @@ to_tsquery('email & phone'::text))                        |
--JIT:                                                                                                |
--  Functions: 4                                                                                      |
--  Options: Inlining false, Optimization false, Expressions true, Deforming true                     | 
Общая стоимость запроса заметно снизилась (Bitmap Index Scan on doc_search_gin_index).
BRIN
BRIN-индекс эффективнее работает, если данные в столбцах коррелируют с их физическим расположением в таблице. Если запрос без ORDER BY возвращает данные в большинстве своём в упорядоченном состоянии, например, от большего к меньшему или наоборот, то BRIN можно смело применять. Преимущество индекса — для огромных таблиц он занимает мало места и ускоряет последовательный поиск.
Возьмём одну из самых больших таблиц в БД — boarding_passes. Таблица чуть больше одного гигабайта, но для демонстрации подойдёт.
Выполним запрос без индекса:

EXPLAIN
SELECT * FROM boarding_passes WHERE boarding_no = 10;

--QUERY PLAN                                                                           |
---------------------------------------------------------------------------------------+
--Gather  (cost=1000.00..111417.67 rows=108584 width=25)                               |
--  Workers Planned: 2                                                                 |
--  ->  Parallel Seq Scan on boarding_passes  (cost=0.00..99559.27 rows=45243 width=25)|
--        Filter: (boarding_no = 10)                                                   |
--JIT:                                                                                 |
--  Functions: 2                                                                       |
--  Options: Inlining false, Optimization false, Expressions true, Deforming true      | 
Было запущено параллельное сканирование таблицы с фильтрацией по условию запроса (Parallel Seq Scan on boarding_passes).
Построим индекс, который должен немного ускорить это сканирование:

SELECT * FROM pg_indexes WHERE tablename = 'boarding_passes' AND indexname = 'boarding_passes_brin_index';
--schemaname|tablename|indexname|tablespace|indexdef|
------------+---------+---------+----------+--------+

CREATE INDEX boarding_passes_brin_index on boarding_passes USING brin(boarding_no);

SELECT * FROM pg_indexes WHERE tablename = 'boarding_passes' AND indexname = 'boarding_passes_brin_index';
--schemaname|tablename      |indexname                 |tablespace|indexdef                                                                                    |
------------+---------------+--------------------------+----------+--------------------------------------------------------------------------------------------+
--bookings  |boarding_passes|boarding_passes_brin_index|          |CREATE INDEX boarding_passes_brin_index ON bookings.boarding_passes USING brin (boarding_no)| 
Выполним запрос:

EXPLAIN
SELECT * FROM boarding_passes WHERE boarding_no = 10;

--QUERY PLAN                                                                                          |
------------------------------------------------------------------------------------------------------+
--Gather  (cost=1057.10..109674.27 rows=108584 width=25)                                              |
--  Workers Planned: 2                                                                                |
--  ->  Parallel Bitmap Heap Scan on boarding_passes  (cost=57.10..97815.87 rows=45243 width=25)      |
--        Recheck Cond: (boarding_no = 10)                                                            |
--        ->  Bitmap Index Scan on boarding_passes_brin_index  (cost=0.00..29.96 rows=7580116 width=0)|
--              Index Cond: (boarding_no = 10)                                                        |
--JIT:                                                                                                |
--  Functions: 2                                                                                      |
--  Options: Inlining false, Optimization false, Expressions true, Deforming true                     | 
BRIN-индекс применяется для поиска данных, удовлетворяющих условиям, при этом общая стоимость запроса немного снизилась. Размер построенного индекса совсем небольшой:

SELECT pg_size_pretty(pg_total_relation_size('boarding_passes_brin_index'));

--pg_size_pretty|
----------------+
--56 kB         | 
На выбор индекса влияют много факторов: тип данных, применение операторов в условиях, решаемая задача и даже корреляция данных с их физическим расположением. Чтобы оптимизировать запрос, корректно работайте с индексами. Больше о советах по оптимизации — в следующем уроке.


