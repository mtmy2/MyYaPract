Блокировка строк. Запросы
В прошлом уроке вы узнали, что блокировки строк бывают разными:
разделяемые (shared lock) — для чтения данных: FOR SHARE, FOR KEY SHARE.
исключительные (exclusive lock) — для изменения или удаления данных: FOR UPDATE, FOR NO KEY UPDATE.
В этом уроке вы продолжите изучать блокировки и разберёте синтаксис запросов для блокировки строк.
Базовый синтаксис блокировки строк такой:

BEGIN;

SELECT ... 
FOR вариант_блокировки
[OF имя_таблицы]
[NOWAIT] 
В начале — запрос SELECT, в конце запроса — ключевое слово FOR, а после него — один из вариантов блокировки: SHARE, KEY SHARE, UPDATE, NO KEY UPDATE.
Если в запросе используют несколько таблиц, после OF опционально можно указать имена или псевдонимы таблиц, строки в которых нужно заблокировать.
В самом конце при необходимости можно указать NOWAIT. Его используют, когда хотят, чтобы запрос не ждал, а сразу выдавал ошибку, если сейчас наложить блокировку невозможно.
Можно! Разберём синтаксис блокировки строк на примере:

BEGIN;

SELECT * 
FROM products 
WHERE price > 2000
ORDER BY price DESC
LIMIT 1 OFFSET 1
FOR SHARE
NOWAIT; 
Этот запрос откроет транзакцию, выберет из таблицы products все товары с ценой более 2000, найдёт среди них второй по цене и заблокирует строку с ним в режиме SHARE. 
Это не позволит другим транзакциям менять поля для этой строки. При этом они смогут накладывать совместимые блокировки, в том числе в режиме SHARE. 
Если захватить блокировку сразу невозможно, благодаря ключевому слову NOWAIT запрос выдаст ошибку:
ERROR: could not obtain lock on row in relation "products"

Ошибка: невозможно захватить блокировку cтроки в таблице products 
Теперь попрактикуйтесь.
Преподавателю нужно обновить информацию по среднему баллу некоторых студентов  в списке учащихся.
Подготовьте тестовые данные, выполнив этот скрипт:

DROP TABLE IF EXISTS students CASCADE;
CREATE TABLE students(
    student_id SERIAL,
    full_name VARCHAR NOT NULL,
    phone VARCHAR NOT NULL,
    address VARCHAR NULL,
    average_score NUMERIC(6,2) NULL -- средний балл
);

INSERT INTO students(full_name, phone, address)
VALUES
    ('Медведев Александр Анатольевич', '+7(111)111-11-11', NULL),
    ('Картошкина Вера Олеговна', '+7(888)888-88-88', 'Новосибирск'),
    ('Котов Сергей Дмитриевич', '+7(777)777-77-77', 'Москва'),
    ('Зайцев Андрей Алексеевич', '+7(666)666-66-66', NULL),
    ('Туя Аркадий Эрнестович', '+7(555)555-55-55', 'Ялта'),
    ('Сишарпов Николай Анатольевич', '+7(444)444-44-44', NULL),
    ('Иванов Андрей Фёдорович', '+7(333)333-33-33', NULL);

CREATE TABLE payments(
    student_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(9,2)
);
-- Для краткости запроса эту таблицу заполните одинаковыми данными по всем студентам
INSERT INTO payments
SELECT student_id, CURRENT_DATE, 100000 
FROM students; 
Преподаватель открывает транзакцию и, выполнив SELECT, блокирует некоторые строки в  справочнике студентов в режиме NO KEY UPDATE, 
потому что поле со средним баллом не является ключом, ключ — student_id.

BEGIN;
SELECT full_name, average_score
FROM students
WHERE full_name IN ('Медведев Александр Анатольевич', 'Иванов Андрей Фёдорович')
FOR NO KEY UPDATE; 
Выполните этот запрос в новой вкладке DBeaver.
Теперь в другой вкладке напишите запрос, который должен удалить студента, но пока не выполняйте его:

DELETE 
FROM students
WHERE full_name = 'Медведев Александр Анатольевич'; 
Предположите, что произойдёт?
Выберите единственный верный ответ.


Студент сразу удалится.
Удалить студента не получится — строка с его данными заблокирована в другой транзакции.

Правильный ответ
Запрос зависнет в ожидании.
Запрос будет ждать, пока снимется блокировка со строки.

Запрос выдаст ошибку.
Никаких ошибок не произойдёт, запрос просто будет ждать, пока строка станет доступна для изменения.
А вот теперь — выполните запрос.
До тех пор, пока транзакция не завершится, никто не сможет изменить или удалить строки, которые преподаватель выбрал в первом запросе, так как команда FOR NO KEY UPDATE захватила исключительную блокировку. 
При этом другие транзакции могут читать заблокированные строки. Вы можете убедиться в этом, запустив в ещё одной новой вкладке запрос:

SELECT * FROM students
WHERE full_name = 'Медведев Александр Анатольевич'; 
Запрос без проблем получил данные и отобразил их.
Теперь в первой вкладке обновите средний балл по двум студентам и завершите транзакцию, которая блокировала строки:

UPDATE students
SET average_score = 5
WHERE full_name IN ('Медведев Александр Анатольевич', 'Иванов Андрей Фёдорович');

COMMIT; 
Блокирующая транзакция завершилась. Теперь проверьте, что DELETE в другой вкладке выполнился успешно.
Если в запросе на выборку используют несколько таблиц, а заблокировать строки нужно только в некоторых из них, 
добавляют уточнение с ключевым словом OF, перечислив после него нужные таблицы или их псевдонимы, если они используются в запросе.
Например, тот же преподаватель после обновления среднего балла решил обновить данные по выплатам стипендий самым успешным студентам. 
Тогда строки в таблице со списком студентов ему блокировать не потребуется, поскольку они меняться не будут, а вот в таблице с выплатами будут:

BEGIN;

SELECT p.*
FROM students s
INNER JOIN payments AS p ON s.student_id = p.student_id  
WHERE s.full_name = 'Иванов Андрей Фёдорович'
FOR NO KEY UPDATE OF p; -- блокируем выбранные строки в таблице payments  
Что добавить к этому запросу, чтобы оптимальным образом ограничить возможность другим транзакциям менять выбираемые в этом запросе строки, при этом минимально ограничивая другие операции? 

BEGIN;
SELECT
p.*
FROM products p
INNER JOIN categories c ON c.category_id = p.category_id
WHERE c.category_name = 'Смартфоны' 
Выберите единственный верный вариант.


FOR UPDATE
Такая блокировка сработает, но дополнительно запретит другим таблицам накладывать на строки разделяемые блокировки — это излишне.

Тоже правильный ответ
FOR SHARE
FOR SHARE наложит на строки разделяемую блокировку, которая не позволит другим транзакциям или запросам как-либо изменять или удалять данные.

FOR SELECT
Такой блокировки не существует.

Неправильный ответ
FOR KEY SHARE
Такая блокировка может не сработать, так как мы не знаем, является ли поле category_name ключевым, а режим FOR KEY SHAREпозволяет изменять неключевые поля.


Выберите недостающую команду, которая позволит этому запросу не висеть в ожидании освобождения строк, если они уже заблокированы несовместимой блокировкой, а сразу отобразит ошибку:

BEGIN;
SELECT *
FROM students
FOR SHARE; 
Отметьте единственный верный ответ.


Правильный ответ
NOWAIT;
Это ключевое слово делает именно то, что нужно.

FOR NO KEY UPDATE;
Это другой режим блокировки. В этот запрос его можно добавить, только убрав FOR SHARE.

ROLLBACK;
Эта команда откатит транзакцию, но только после того, как наложит блокировку. То есть запрос всё-таки будет ожидать освобождения строк от несовместимых блокировок.

NO WAIT;
Здесь лишний пробел, такой команды не существует.

