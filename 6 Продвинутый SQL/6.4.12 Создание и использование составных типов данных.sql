Создание и использование составных типов данных
Продолжим разбирать типы данных на примере данных агрегатора Taxi Online. Вернитесь к таблице cars:
guid	gos_num	engine
Помимо типа двигателя, у автомобиля есть ряд других характеристик:
номер VIN — последовательность из семнадцати букв и цифр,
год выпуска,
цвет,
объём двигателя,
мощность двигателя в лошадиных силах (л. с.).
Каждый из этих параметров редко используют в запросах к БД, поэтому их нужно хранить достаточно компактно, не вводя множество столбцов или таблиц. При этом важно, чтобы в каждый из этих параметров гарантированно записывалось значение правильного типа — в номер VIN не попадёт boolean, а в цвет — дата. В этой ситуации удобно создать собственный составной тип данных.
Составной тип данных позволяет гибко собирать разнообразные структуры, состоящие из полей любых типов. Это может пригодиться для компактного хранения и удобной обработки второстепенной информации. 
Создаём составной тип данных
Составной тип данных — это фактически набор полей разных типов.
Чтобы создать составной тип, используют команду CREATE TYPE. При этом указывают имя нового типа, а в круглых скобках — наименования и типы полей:

CREATE TYPE <имя_схемы>.<имя_типа> AS (<имя_поля> <тип_поля>, <имя_поля_2> <тип_поля_2>, ...) 
Тип поля выбирают из всех существующих в системе типов: встроенных и пользовательских. Никакие дополнительные ограничения или значения по умолчанию при создании типа установить не получится.
Как и в случае с enum, сразу после создания типа система автоматически создаёт тип для его массива с именем _<имя_типа>.
Добавьте в схему taxi новый тип под названием car_specifications с пятью полями:

CREATE TYPE taxi.car_specifications AS (
    vin char(17),              -- VIN-номер
    manufacture_year smallint, -- год выпуска
    color text,                -- цвет
    engine_volume numeric,     -- объём двигателя
    engine_power numeric       -- мощность двигателя в л. с.
); 
Измените таблицу cars, добавив туда столбец с новым типом:

ALTER TABLE taxi.cars ADD COLUMN specifications taxi.car_specifications; 
Вставляем значения составных типов в таблицу
Есть два способа вставить значение составного типа в таблицу:
текстовая константа,
выражение ROW.
Текстовая константа
Задавать значения составным типом можно в виде текстовой константы, где в скобках перечислены значения всех полей через запятую. 
Например:

UPDATE taxi.cars SET specifications = '(AAA12345678901234,2015,белый,1.3,136)'
WHERE gos_num = 'A111AA111';
 
Если какое-то значение содержит в себе запятые или скобки, его обязательно заключают в двойные кавычки, чтобы не возникло путаницы с синтаксисом перечисления полей. В других случаях также можно использовать двойные кавычки — это не вызовет ошибки, но и не даст никаких дополнительных преимуществ.
Пробелы после запятых для чисел и булевых значений — незначимы, система их игнорирует. Однако, если после пробела идёт текстовое значение, оно так и запишется с пробелом. Например, такой запрос:

UPDATE taxi.cars SET specifications = '(AAA12345678901234, 2015, белый, 1.3, 136)'
WHERE gos_num = 'A111AA111'; 
приведёт к тому, что в поле color запишется значение ' белый'.
Ни одно из полей составного типа не является обязательным, поэтому его можно пропустить. Для этого нужно просто оставить в текстовой константе пустое место, сохранив при этом количество запятых:

UPDATE taxi.cars SET specifications = '(BBB12345678901234,2020,жёлтый,,150)'
WHERE gos_num = 'B222BB222'; 
Не оставляйте пробелов между запятыми на месте пропущенного значения — это вызовет ошибку.
В этом случае значение engine_volume равно NULL.
Если вы хотите вставить не NULL, а пустую строку или пробел, используйте двойные кавычки "":

INSERT INTO taxi.cars (gos_num, engine, specifications)
VALUES ('C333CC333', 'гибридный', '(CCC12345678901234,2018,"",1.5,120)'); 
Этот способ подойдёт только для текстовых полей — в остальных случаях он вызовет ошибку.
Выражение ROW
Выражение ROW — это конструктор строк. Он принимает в качестве аргументов перечень полей и создаёт из них строку для составного типа данных или таблицы.
Если вы используете ROW, не нужно считать вложенные кавычки, точки и запятые — значения в скобках выглядят точно так же, как выглядели бы, если бы вы записывали их по отдельности:

INSERT INTO taxi.cars (gos_num, engine, specifications)
VALUES ('E444EE444', 'гибридный', ROW('EEE12345678901234', 2018, 'чёрный', 1.5, 120)); 
Соответственно, можно спокойно вставлять значения NULL:

INSERT INTO taxi.cars (gos_num, engine, specifications)
VALUES ('M555MM555', 'гибридный', ROW('MMM12345678901234', 2021, 'чёрный', NULL, NULL)); 
Ключевое слово ROW необязательно, если в выражении определяются несколько полей, поэтому можно использовать и такой вариант записи:

INSERT INTO taxi.cars (gos_num, engine, specifications)
VALUES ('M555MM555', 'гибридный', ('MMM12345678901234',2021, 'чёрный', NULL, NULL)); 
Обращаемся к конкретному полю составного типа
Теперь разберём, как поведёт себя составной тип в запросах выборки. Для начала выберите просто значения столбца specifications:

SELECT specifications FROM taxi.cars; 
Результат выглядит так же, как выглядела бы текстовая константа при вводе:
specifications (car_specifications)
(AAA12345678901234,2015,белый,1.3,136)
(BBB12345678901234,2020,жёлтый,,150)
(CCC12345678901234,2018,2018,"",1.5,120)
(EEE12345678901234,2018,чёрный,1.5,120)
(MMM12345678901234,2021,чёрный,,)

На месте пустой строки стоят двойные кавычки, на месте значений NULL — между запятыми пусто.



Чтобы обратиться к любому полю объекта составного типа в запросе SELECT, заключите имя столбца таблицы в круглые скобки и через точку укажите имя поля типа:

(имя_столбца).имя_поля 
Если круглых скобок не будет, система посчитает, что вы пытаетесь обратиться к таблице и её столбцу.
При создании любой таблицы неявно создаётся составной тип данных, который называется так же, как сама таблица, и содержит все те же поля, что и строка таблицы.
Например, для таблицы cars этот тип будет выглядеть так:

(guid uuid, gos_num text, engine engine_type, specifications car_specifications) 
Вот как вывести только годы выпуска автомобилей:

SELECT (specifications).manufacture_year FROM taxi.cars; 
В сложных запросах из нескольких таблиц, если нужно указать, из какой именно таблицы берётся столбец, имя таблицы также заключают в скобки. 
Например, так будет выглядеть запрос из двух таблиц: cars, а также orders, в которой хранятся данные каждой поездки:

SELECT (cars.specifications).manufacture_year
FROM taxi.cars
INNER JOIN taxi.orders ON orders.car_guid = car.guid
WHERE orders.id = 12345; 
Эту конструкцию можно использовать в предложениях WHERE, ORDER BY, встроенных функциях и так далее. 
Например, так можно отсортировать автомобили по году выпуска:

SELECT * FROM taxi.cars ORDER BY (specifications).manufacture_year; 
Изменяем и вставляем отдельные поля

В запросе UPDATE, если нужно изменить конкретное поле внутри составного типа, круглые скобки опускают. 
Например, так можно изменить цвет автомобиля с государственным номером А111АА111:

UPDATE taxi.cars SET specifications.color = 'синий' WHERE gos_num = 'A111AA111'; 
Если вставляют только конкретные поля с помощью INSERT, круглые скобки также опускают.

INSERT INTO taxi.cars
    (gos_num, engine, specifications.manufacture_year, specifications.color)
VALUES ('O777OO', 'дизельный', 2019, 'зелёный'); 
В этом случае все поля, не перечисленные в INSERT, выставляют в NULL:
(,2019,зелёный,,) 
Если вы хотите более глубоко разобраться, как применять составные типы в запросах, загляните в этот раздел документации.
Необходимо создать пользовательский тип location, который хранит название города и почтовый индекс в формате integer. Выберите единственный верный синтаксис:



CREATE TYPE location (city text, post_index integer)
 
В синтаксисе обязательно использовать слово AS.

Правильный ответ

CREATE TYPE location AS (city text, post_index integer)
 
Такой запрос создаст нужный тип.


CREATE TYPE location AS (city, post_index)
 
Для каждого поля нужно обязательно указать его тип.


CREATE TYPE location AS (city text DEFAULT NULL, post_index integer)
 
При создании составных типов не получится указать значение по умолчанию.
Таблица clients_add_info состоит из двух полей: client_id типа integer и client_location типа location из предыдущего задания. Выберите правильный синтаксис для вставки данных в эту таблицу. Отметьте все верные варианты ответа.



INSERT INTO clients_add_info (client_id, client_location)
VALUES (2, ROW('(Васильково,111111)'))
 
В выражение ROW передают набор значений, а не текстовую константу.

Тоже правильный ответ

INSERT INTO clients_add_info (client_id, client_location)
VALUES (1, '("Ромашково",777777)')
 
Синтаксис корректный: текстовые значения внутри текстовой константы можно заключать в двойные кавычки.

Неправильный ответ

INSERT INTO clients_add_info (client_id, client_location)
VALUES (2, ROW("Васильково", 111111))
 
Текстовое значение, переданное в ROW, заключают в одинарные кавычки.

Правильный ответ

INSERT INTO clients_add_info (client_id, client_location)
VALUES (1, '("Ромашково",)')
 
Можно задать пустое значение для второго поля, просто не указывая ничего после запятой.

Неправильный ответ

INSERT INTO clients_add_info (client_id, client_location)
VALUES (1, '(Ромашково,NULL)')
 
NULL будет интерпретирован как текстовая константа, и при попытке вставить данные произойдёт ошибка.

Правильный ответ

INSERT INTO clients_add_info (client_id, client_location)
VALUES (2, ('Васильково',111111))
 
При вставке конкретных полей выражение ROW можно опустить.
Найдите всех клиентов, которые живут в городе Ландышево. Выберите единственный правильный ответ.



SELECT * FROM clients_add_info WHERE client_location.city = 'Ландышево'
 
Название столбца указывают в круглых скобках.


SELECT * FROM clients_add_info WHERE (location).city = 'Ландышево'
 
В круглых скобках должно стоять название столбца, а не типа.


SELECT * FROM clients_add_info WHERE client_location = 'Ландышево'
 
Нужно указать поле составного типа, по которому фильтруются данные.

Правильный ответ

SELECT * FROM clients_add_info WHERE (client_location).city = 'Ландышево'
 
Название столбца стоит в круглых скобках, а затем указано название столбца составного типа. Запрос составлен верно.
Сейчас таблица clients_add_info выглядит так:
client_id	client_location
1	(Ромашково,777777)
2	(Васильково,111111)
3	(Ландышево,333333)
Какой результат будет у такого скрипта? Выберите единственный правильный ответ.

UPDATE clients_add_info SET client_location.city = 'Полевое' WHERE client_id = 2;

SELECT client_location FROM clients_add_info WHERE client_id = 2;
 


Полевое.
Новое значение ячейки всё так же должно быть составным типом.

Правильный ответ
(Полевое,111111).
В ячейке с client_id = 2 заменилось значение поля city.

(Васильково,111111,Полевое).
Новое значение должно заменить поле city, а не добавиться как новое поле.

Ошибка выполнения из-за того, что в предложении SET название столбца не заключили в круглые скобки.
В выражении UPDATE круглые скобки не нужны.
Продолжаем работать с таблицей clients_add_info :

INSERT INTO clients_add_info (client_id, client_location.post_index)
VALUES (3, 555555);

SELECT client_location FROM clients_add_info WHERE client_id = 3;
 
Каким будет результат скрипта? Выберите единственный правильный ответ.


Ошибка, потому что название столбца не заключили в скобки.
В выражении INSERT скобки не нужны.

Ошибка, потому что в столбец client_location нужно вставлять составной тип.
Вы указали конкретное поле столбца client_location, для него не нужен составной тип.

Тоже правильный ответ
(,555555)
Первое поле пустое, а во втором — добавленное значение.

Неправильный ответ
(555555)
В результате должно остаться два поля, но первое из них будет пустым, запятую после него нужно сохранить.

