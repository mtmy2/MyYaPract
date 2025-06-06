Блокировка таблиц. Запросы
В предыдущих уроках вы узнали, что такое блокировки строк и как их применять на практике. В этом уроке вы разберёте блокировки на уровне таблиц.
Блокировка таблицы целиком пригодится, когда нужно изменить сразу множество записей. 
Также PostgreSQL автоматически блокирует таблицы при выполнении некоторых операций, при которых блокировка отдельных строк не имеет смысла. Например, 
DROP TABLE, TRUNCATE, ALTER TABLE и других.
Когда пользователь хочет заблокировать строки с помощью команды 
SELECT … FOR SHARE/UPDATE, PostgreSQL автоматически блокирует таблицу целиком, таким образом запрещая другим процессам проводить несовместимые операции. Например, пока пользователь в транзакции заблокировал несколько строк с помощью SELECT … FOR SHARE, блокировка на уровне таблицы не позволит другим пользователям запустить такие операции, как ALTER TABLE или DROP TABLE.
Рассмотрим, как накладывать явные блокировки на таблицу.
Аналогично явным блокировкам строк, чтобы заблокировать таблицу, открывают транзакцию с помощью оператора BEGIN и внутри активной транзакции используют оператор для блокировки таблиц LOCK TABLE.
Общий синтаксис такой:

LOCK TABLE имя_таблицы IN уровень_блокировки MODE; 
Например:

BEGIN;
LOCK TABLE products IN ACCESS SHARE MODE; 
Здесь LOCK TABLE блокирует таблицу products в заданном режиме — ACCESS SHARE, пока текущая транзакция не завершится с помощью ROLLBACK или COMMIT;.
Блокировка не ограничивает никакие операции для транзакции, внутри которой она наложена. Ограничения касаются лишь других транзакций.
Со всеми режимами блокировок, которые можно использовать с командой LOCK TABLE, вы можете познакомиться в документации. В уроке разберём три блокировки, которые с наибольшей вероятностью пригодятся вам в работе:
ACCESS SHARE — самая нестрогая блокировка. Её автоматически запрашивают все запросы, которые читают данные из таблиц, но не меняют их. Ручное применение этого режима пригодится в случае, когда важно, чтобы никакой внешний процесс не помешал вашей транзакции делать выборку из таблицы и не наложил несовместимую блокировку.
EXCLUSIVE — совместима только с чтением таблицы и несовместима с любыми изменениями данных в ней, даже с оператором SELECT .. FOR UPDATE/SELECT .. FOR NO KEY UPDATE. Одновременно на таблице может быть только одна блокировка EXCLUSIVE. Пригодится, когда нужно запретить другим транзакциям редактировать данные в таблице, но оставить им возможность эти данные читать.
ACCESS EXCLUSIVE — самая строгая блокировка, не совместима ни с какими другими блокировками. Это единственный режим, который не даёт запрашивать никакие данные из таблицы и блокирует даже SELECT. Именно такую блокировку накладывает команда LOCK TABLE, если запустить её без явного указания режима. Блокировку ACCESS EXCLUSIVE на одной таблице одномоментно может удерживать лишь одна транзакция. Пригодится, чтобы запретить другим пользователям смотреть данные в таблице, пока вы эти данные редактируете.
Чтобы не снижать производительность системы, лучше выбирать наименее строгий режим, который подходит для ваших целей.
Если на таблицу другой транзакцией наложена несовместимая блокировка, команда LOCK TABLE подождёт, пока несовместимую блокировку снимут, после чего захватит блокировку. Когда несколько транзакций пытаются наложить блокировки, эти блокировки становятся в очередь и выполняются в порядке выполнения запросов. 
Если же по каким-то причинам нужно, чтобы LOCK TABLE не ждала освобождения таблицы, а выдала ошибку, если невозможно наложить блокировку прямо сейчас, используют ключевое слово NOWAIT.
Вот как всё это работает на практике.
Запустите DBeaver и создайте тестовую таблицу для фирмы «Бобры», которая продаёт стройматериалы:

-- Создаём таблицу 
CREATE TABLE materials(
    id_material serial,                 -- идентификатор товара
    name varchar not null,     -- наименование товара
    price numeric(15,4) not null, -- цена за единицу
    unit varchar not null,      -- единицы измерения
    qty    int not null default(0)        -- наличие на складе
);

-- Наполняем минимальными тестовыми данными
INSERT INTO materials(name, price, unit, qty)
VALUES
    ('Щебень гранитный фр. 2-5', 3700, 'тонна', 800),
    ('Щебень известняк фр. 20-40', 1800, 'тонна', 500),
    ('Керамзит фр.10/20', 1850, 'м3', 500),
    ('Песок речной', 2500, 'тонна', 900); 
Поставщик прислал новый прайс-лист, и теперь контент-менеджеру вручную нужно обновить цены в системе на некоторые материалы. У менеджеров по продажам не должно быть возможности оформлять заказы, пока цены не обновятся — цены на часть позиций в системе уже неактуальны, и продать по ним товары магазин не может.
Контент-менеджер начинает обновлять цены. Прежде всего, он блокирует таблицу с материалами так, чтобы никто не мог её прочитать и получить неактуальную цену.
Откройте новую вкладку в DBeaver и запустите этот скрипт:

BEGIN;
LOCK TABLE materials; 
Он аналогичен скрипту:

BEGIN;
LOCK TABLE materials IN ACCESS EXCLUSIVE MODE; 
Этот скрипт запрашивает для таблицы materials блокировку в режиме по умолчанию ACCESS EXCLUSIVE. Это самый строгий уровень блокировки — единственный, который не позволит сделать SELECT к заблокированной таблице.
Чтобы посмотреть, действительно ли блокировка выполнена, понадобится уникальный идентификатор процесса — process id, pid. Чтобы его получить, в текущем окне DBeaver запустите запрос:

SELECT pg_backend_pid(); 
Теперь откройте новую вкладку в DBeaver и выполните такой запрос, подставив в него полученный pid:

SELECT 
    c.relname, -- имя таблицы
    l.pid,     -- идентификатор процесса
    l.mode,    -- режим блокировки
    l.granted -- выдана ли блокировка
FROM pg_locks l
LEFT JOIN pg_class c ON c.oid = l.relation 
WHERE c.relname = 'materials'
AND l.pid = -- сюда подставьте ваш pid 
Этот запрос получает данные о блокировках из встроенного представления pg_locks, добавляя имя объектов из системного каталога pg_class. Фильтр на таблицу products в WHERE отсекает лишние строки, отображающие автоматические блокировки, которые вам сейчас неактуальны.
Вот что должно получиться:
relname	pid	mode	granted
materials	[ваш pid]	AccessExclusiveLock	true
Таблица materials заблокирована — в поле mode указан режим блокировки 
ACCESS EXCLUSIVE, а в колонке granted — значение true. Теперь контент-менеджер может спокойно и не торопясь обновлять необходимые данные в той же транзакции.
Допустим, в это же время менеджер по продажам хочет посмотреть цену, чтобы сообщить её покупателю, и делает SELECT из таблицы:

SELECT * FROM materials WHERE name = 'Песок речной'; 
Откройте новую вкладку в DBeaver и запустите этот запрос.
Что произошло при выполнении запроса? Выберите единственный верный ответ.


Запрос выдал ошибку.
Запрос завис — он ждёт, пока таблица освободится.

Запрос успешно выполнился.
Если запрос выполнен не в окне с начатой транзакцией, он будет ждать, когда таблица освободится и только после этого выполнится.

Правильный ответ
Запрос висит и ждёт выполнения.
Блокировка ACCESS EXCLUSIVE, наложенная в транзакции, не позволяет другим процессам запрашивать данные из таблицы materials, пока транзакция не завершится.
Итак, запрос не выполнился, а ждёт, пока с таблицы снимут блокировку. 
Теперь откройте новую вкладку (это не должна быть вкладка с запущенной транзакцией или с заблокированным запросом), и выполните такой запрос SELECT:

SELECT
    c.relname, -- имя таблицы
    l.pid,     -- идентификатор процесса
    l.mode,    -- режим блокировки
    l.granted, -- выдана ли блокировка
    pg_blocking_pids(l.pid) -- id процесса, который блокирует текущий
FROM pg_locks l
LEFT JOIN pg_class c ON c.oid = l.relation
WHERE c.relname = 'materials'; 
Вот что должно получиться:
relname	pid	mode	granted	pg_blocking_pids
materials	[Ваш pid]	AccessShareLock	false	{[Ваш pid из транзакции]}
materials	[Ваш pid из транзакции]	AccessExclusiveLock	true	{}
В колонке mode видно, что запрос продавца пытается наложить блокировку ACCESS SHARE, но пока у него это не получилось — в колонке granted значение false. 
В последней колонке с помощью встроенной функции pg_blocking_pids выводится pid транзакции, блокирующей запрошенный процесс. Если таких транзакций несколько — выводится их список.
Если менеджер по продажам захочет, чтобы его запрос не ждал, пока таблица освободится, а сразу выдавал ошибку, когда данные получить невозможно, он напишет такой запрос:

BEGIN;
-- добавлен NOWAIT, чтобы не ждать, пока таблица освободится
LOCK TABLE materials in ACCESS SHARE MODE NOWAIT;
SELECT * FROM materials WHERE name like 'Керамзит%';
COMMIT; 
Выполните запрос в отдельной вкладке DBeaver.
Этот запрос попытается установить блокировку ACCESS SHARE, не сможет и благодаря NOWAIT сразу же выдаст сообщение об ошибке:
ERROR: could not obtain lock on relation "materials" 
Ошибка говорит, что не получилось наложить блокировку на таблицу materials.
Контент-менеджер, заблокировавший таблицу с товарами, закончил обновление цен и завершил транзакцию, выполнив COMMIT. После этого блокировка с таблицы снялась, и теперь все ожидающие запросы смогут продолжить свою работу. 
Завершите транзакцию в самом первом запросе, который накладывал блокировку ACCESS EXCLUSIVE, и посмотрите на результат выборки запроса SELECT, который был заблокирован этой транзакцией.
Подробнее изучить команду LOCK TABLE вы можете в документации PostgreSQL.
Сотрудник автосалона информирует клиента о цене на авто и не хочет, чтобы цену изменили, пока клиент принимает решение. Какой скрипт нужно выполнить менеджеру внутри транзакции? Выберите единственный верный ответ.


Тоже правильный ответ

LOCK TABLE cars in EXCLUSIVE MODE;
SELECT * FROM cars; 
Блокировка EXCLUSIVE на уровне таблицы не позволит никому менять в ней данные.


LOCK TABLE cars EXCLUSIVE;
SELECT * FROM cars; 

Неправильный ответ

LOCK TABLE cars;
SELECT * FROM cars; 
Этот запрос наложит блокировку уровня ACCESS EXCLUSIVE, который не позволит другим процессам читать данные из таблицы. Такое ограничение излишне.


LOCK TABLE cars with ACCESS SHARE MODE; 
SELECT * FROM cars; 
Разработчик банковского ПО допустил ошибку, которая повредила данные в таблице с проводками (carry), и суммы по дебету и кредиту разошлись. Нужно срочно исправить ситуацию, а пока никто не должен получить некорректные данные из этой таблицы. Какой скрипт выполнить, чтобы заблокировать доступ к таблице? Выберите все верные варианты.


Правильный ответ

BEGIN;
LOCK TABLE carry; 
Этот запрос откроет транзакцию и наложит на таблицу блокировку ACCESS EXCLUSIVE — это режим по умолчанию для команды LOCK TABLE. После этого другие процессы не смогут читать данные из таблицы.


LOCK TABLE carry; 

Правильный ответ

BEGIN;
LOCK TABLE carry in ACCESS EXCLUSIVE MODE; 
Этот запрос откроет транзакцию и наложит на таблицу блокировку ACCESS EXCLUSIVE, что не позволит никому выбирать данные из этой таблицы.


BEGIN;
LOCK TABLE carry in EXCLUSIVE MODE; 

