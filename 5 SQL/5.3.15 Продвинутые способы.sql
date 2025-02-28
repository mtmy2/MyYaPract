INSERT INTO <имя таблицы 1> (
    <поле 1 таблицы 1>,
    <поле 2 таблицы 1>,
    -- ---
    <поле n таблицы 1>
) SELECT
    <поле 1 таблицы 2>,
    <поле 2 таблицы 2>,
    -- ---
    <поле n таблицы 2>
FROM <имя таблицы 2>
-- только в случае, если вы переносите не все строки из таблицы 2 в таблицу 1
WHERE <условия>;  


CREATE TABLE store.product_price_history (
    id INT,
    price NUMERIC(9, 2),
    created_at TIMESTAMP DEFAULT current_timestamp
);

INSERT INTO store.product_price_history (id, price)
SELECT id, price FROM store.products;


INSERT INTO  store.product_equity (id, equity, report_date)
SELECT id, price * amount, current_date 
FROM store.products
WHERE amount > 0;




ON CONFLICT (<ограничение>) DO …

INSERT INTO users (name, phone, email, birthday)
VALUES ('Петрова О. П.', '+7 (495) 236-56-98', 'o.petrova@yandex.ru', '2001-05-06')
ON CONFLICT DO NOTHING;


INSERT INTO users (name, phone, email, birthday)
VALUES ('Петрова О. П.', '+7 (495) 5678888', 'o.petrova@yandex.ru', '1998-02-23')
ON CONFLICT (email) DO UPDATE SET
  name = excluded.name,
  phone = excluded.phone,
  birthday = excluded.birthday;



INSERT INTO office.users (name, phone, email)
VALUES ('Зверева Инга Фёдоровна', '+7 (495) 678-34-76', 'zvereva.if@yandex.ru')
RETURNING id, created_at, deleted_at;


UPDATE office.users
SET phone = '+7 (495) 678-34-79'
WHERE id = 11
RETURNING *;


DELETE FROM office.users
WHERE birthday ISNULL
RETURNING id, name, email;