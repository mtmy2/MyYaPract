В онлайн-магазине «Электронное безумие» случился сбой в БД. Из-за этого в процессе обработки покупок произошла ошибка — записали неверные данные. 
Два клиента совершили покупки из Стамбула, а в базе данных сохранилось, что покупки из Москвы. 
По словам менеджеров, ошибка произошла 23 мая 2023 года, имена клиентов: Роберт Иванов и Антон Земекис. Нужно исправить ошибку. 

CREATE SCHEMA IF NOT EXISTS madness;

-- Удалим таблицы, если они были созданы до нас
DROP TABLE IF EXISTS madness.clients CASCADE;
DROP TABLE IF EXISTS madness.purchases CASCADE;
DROP TABLE IF EXISTS madness.products CASCADE;

-- Создадим таблицы с данными о покупателях
CREATE TABLE IF NOT EXISTS madness.clients (
    id SERIAL PRIMARY KEY,
    surname CHARACTER VARYING NOT NULL, -- фамилия покупателя
    name CHARACTER VARYING NOT NULL, -- имя покупателя
    phone CHARACTER VARYING -- телефон покупателя
);

-- Создадим таблицы с данными о товарах
CREATE TABLE madness.products (
    id SERIAL PRIMARY KEY,
    name CHARACTER VARYING NOT NULL, -- наименование товара
    type CHARACTER VARYING NOT NULL -- тип товара
);

-- Создадим таблицы с информацией о продажах
CREATE TABLE madness.purchases (
    id SERIAL PRIMARY KEY,
    client_id INTEGER REFERENCES madness.clients(id), -- идентификатор клиента (внешний ключ)
    product_id INTEGER REFERENCES madness.products(id), -- идентификатор товара (внешний ключ)
    purchase_date TIMESTAMPTZ, -- время покупки
    billing_city CHARACTER VARYING, -- город платежа
    billing_country CHARACTER VARYING, -- страна платежа
    total NUMERIC(10,2) NOT NULL -- стоимость
);

INSERT INTO madness.clients (name, surname, phone)
VALUES
    ('Роберт', 'Иванов', '654-42-18'),
    ('Антон', 'Иванов', '664-42-28'),
    ('Роберт', 'Земекис', NULL),
    ('Антон', 'Земекис', '234-55-91'),
    ('Роберт', 'Сергеев', NULL),
    ('Сергей', 'Сергеев', '321-55-91');

INSERT INTO madness.products (name , type)
VALUES
    ('Азбука', 'Книга'),
    ('SQL-тренажёр', 'Программа'),
    ('Звуки природы', 'Аудиотрек');
   
INSERT INTO madness.purchases 
    (client_id, product_id, purchase_date, billing_city, billing_country, total)
VALUES 
    (1, 1, '2023-05-01 12:00:00', 'Париж', 'Франция', 100.1),
    (1, 2, '2023-05-23 12:00:00', 'Москва', 'Россия', 200.2),
    (1, 3, '2023-05-24 13:00:00', 'Москва', 'Россия', 300.3),
    (2, 1, '2023-05-23 12:00:00', 'Париж', 'Франция', 10.1),
    (3, 2, '2023-05-23 15:00:00', 'Москва', 'Россия', 44.44),
    (3, 3, '2023-05-23 16:00:00', 'Париж', 'Франция', 55.55),
    (4, 1, '2023-05-23 00:00:00', 'Москва', 'Россия', 66.66),
    (4, 2, '2023-05-23 23:59:59', 'Москва', 'Россия', 77.77),
    (5, 3, '2023-05-23 12:00:00', 'Пекин', 'Китай', 88.88),
    (5, 1, '2023-06-01 12:00:00', 'Пекин', 'Китай', 99.99);



Проверка данных
-- запрос с JOIN
SELECT
    p.*
FROM madness.purchases AS p
INNER JOIN madness.clients AS cl ON (p.client_id = cl.id) -- условие соединения
WHERE 
    ((cl.name = 'Роберт' AND cl.surname = 'Иванов') -- поиск клиента Роберт Иванов
    OR -- или
    (cl.name = 'Антон' AND cl.surname = 'Земекис')) -- поиск клиента Антон Земекис
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате поставки 23.05.2023 г.
    AND p.purchase_date < '2023-05-24';


-- запрос в виде декартова произведения с фильтром WHERE
SELECT
    p.*
FROM madness.purchases AS p, madness.clients AS cl 
WHERE
    p.client_id = cl.id -- условие соединения таблиц
    AND
    ((cl.name = 'Роберт' AND cl.surname = 'Иванов') -- поиск клиента Роберт Иванов
    OR -- или
    (cl.name = 'Антон' AND cl.surname = 'Земекис')) -- поиск клиента Антон Земекис
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате продажи 23.05.2023 г.
    AND p.purchase_date < '2023-05-24';



Синтаксис команды UPDATE для двух связанных таблиц

UPDATE <имя_таблицы_1> -- таблица, в которой надо обновить значения
        SET 
                -- что именно надо обновить
            <имя_столбца 1> = <значение 1>,
            <имя_столбца 2> = <значение 2>,
            ...
            <имя_столбца n> = <значение n>
FROM <имя_таблицы_2> -- таблица, в которой ищем условие
WHERE
    -- условие соединения таблиц <имя_таблицы_1> и <имя_таблицы_2> 
    <имя_таблицы_1>.поле = <имя_таблицы_2>.поле 
    AND <условия на ограничения данных>;





UPDATE madness.purchases AS p -- таблица, в которую вносим обновление
    SET 
        billing_city = 'Стамбул',
        billing_country = 'Турция'
FROM madness.clients AS cl -- связанная таблица
WHERE
    p.client_id = cl.id -- условие соединения таблиц
    AND -- условия на ограничения выборки
    ((cl.name = 'Роберт' AND cl.surname = 'Иванов') -- поиск клиента Роберт Иванов
    OR
    (cl.name = 'Антон' AND cl.surname = 'Земекис')) -- поиск клиента Антон Земекис
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате продажи 23.05.2023г.
    AND p.purchase_date < '2023-05-24';



Проверка обновления
SELECT
    p.*
FROM madness.purchases AS p
INNER JOIN madness.clients AS cl ON (p.client_id = cl.id)
WHERE 
    ((cl.name = 'Роберт' AND cl.surname = 'Иванов') -- поиск клиента Роберт Иванов
    OR -- или
    (cl.name = 'Антон' AND cl.surname = 'Земекис')) -- поиск клиента Антон Земекис
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате поставки 23.05.2023 г.
    AND p.purchase_date < '2023-05-24';



UPDATE madness.purchases AS p -- таблицу, в которую вносим обновление
    SET 
        billing_city = 'Стамбул',
        billing_country = 'Турция'
FROM madness.clients AS cl -- связанная таблица
WHERE
    p.client_id = cl.id -- условие соединения таблиц
    AND -- условия на ограничения выборки
    ((cl.name = 'Роберт' AND cl.surname = 'Иванов') -- поиск клиента Роберт Иванов
    OR
    (cl.name = 'Антон' AND cl.surname = 'Земекис')) -- поиск клиента Антон Земекис
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате поставки 23.05.2023г.
    AND p.purchase_date < '2023-05-24'
RETURNING p.*;



Например, обновление данных в таблице purchases для левого внешнего соединения таблиц 
purchases и clients (то есть для покупок, которые совершили выбранные клиенты,
 а также для покупок, у которых клиенты не указаны) выглядит так:

UPDATE madness.purchases AS p 
    SET 
        billing_city = 'Стамбул',
        billing_country = 'Турция'
FROM madness.clients AS cl
WHERE
    ( -- здесь начинается условие фильтрации строк по признаку клиента.
        ( -- начало условия для варианта INNER JOIN
            p.client_id = cl.id
            AND
            (
                (cl.name = 'Роберт' AND cl.surname = 'Иванов')
                OR
                (cl.name = 'Антон' AND cl.surname = 'Земекис')
            )
        )
        OR -- или строки, где client_id - пустое значение. 
        -- Это как раз строки, получаемые при левом внешнем соединении
        client_id IS NULL
    )
    AND p.purchase_date >= '2023-05-23' -- ограничение по дате не меняется
    AND p.purchase_date < '2023-05-24'; 



UPDATE для трёх связанных таблиц
У менеджеров «Электронного безумия» снова проблема! В программе, 
которая обрабатывала продажи, обнаружилась ошибка. 
Оказывается, весь июнь 2023 года при внесении данных о покупке товара «Азбука» 
программа удаляла номер телефона покупателя.
Менеджеры самостоятельно выяснили, что такой клиент был, 
к счастью, один — Роберт Сергеев. Его фактический номер телефона — 112-83-75.

-- SELECT c JOIN
SELECT
    cl.* -- выведем все колонки таблицы clients
FROM madness.clients AS cl
-- соединяем таблицу clients и purchases
INNER JOIN madness.purchases AS p ON (p.client_id = cl.id)
-- соединяем таблицу purchases и products
INNER JOIN madness.products AS pr ON (pr.id = p.product_id)
WHERE 
    pr.name = 'Азбука' -- ограничение по товару
    AND p.purchase_date >= '2023-06-01' -- ограничение по месяцу 06.2023г.
    AND p.purchase_date < '2023-07-01'
    AND cl.phone IS NULL; -- убедимся, что номер телефона клиента не заполнен



-- SELECT без JOIN
SELECT
    cl.* -- выведем все колонки таблицы clients
FROM madness.clients AS cl, madness.purchases AS p, madness.products AS pr
WHERE
    p.client_id = cl.id -- соединяем таблицу clients и purchases
    AND pr.id = p.product_id -- соединяем таблицу purchases и products
    -- ограничение выборки
    AND pr.name = 'Азбука' -- ограничение по товару
    AND p.purchase_date >= '2023-06-01' -- ограничение по месяцу 06.2023 г.
    AND p.purchase_date < '2023-07-01'
    AND cl.phone IS NULL; -- убедимся, что номер телефона клиента не заполнен


В случае соединения трёх и более таблиц можно составить гибридный вариант UPDATE: 
первую и вторую таблицы соединить через условие соединения после слова WHERE, 
а вторую и третью — по синтаксису запроса SELECT с JOIN. В общем выглядит так: 

UPDATE <имя_таблицы_1> SET 
    <имя_столбца 1> = <значение 1>,
    <имя_столбца 2> = <значение 2>,
    ...
    <имя_столбца n> = <значение n>
FROM <имя_таблицы_2>
[тип_соединения] JOIN <имя_таблицы_3> ON <имя_таблицы_2>.поле = <имя_таблицы_3>.поле
WHERE
    -- условие соединения таблиц <имя_таблицы_1> и <имя_таблицы_2> 
    <имя_таблицы_1>.поле = <имя_таблицы_2>.поле 
    AND <условия на ограничения данных>;


UPDATE madness.clients AS cl -- таблица, в которую вносим правки
    SET phone = '112-83-75'
FROM madness.purchases AS p -- первая связанная таблица
INNER JOIN madness.products AS pr --вторая связанная таблица
ON (pr.id = p.product_id) -- соединение первой и второй связанной таблицы 
WHERE
    p.client_id = cl.id -- условие соединения таблиц clients и purchases
    AND pr.name = 'Азбука' -- ограничение по наименованию товара
    AND p.purchase_date >= '2023-06-01' -- ограничение по месяцу 06.2023г.
    AND p.purchase_date < '2023-07-01'
    AND cl.phone IS NULL; -- номер телефона не заполнен