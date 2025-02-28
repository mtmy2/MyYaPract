CREATE TABLE  store.product_categories (
    id SMALLSERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO store.product_categories 
-- допишите запрос
SELECT DISTINCT ON (category) id, category FROM store.products





INSERT INTO store.suppliers (
    name,
    address,
    email,
    phone
)
/*
закончите запрос (UPSERT)
*/
VALUES 
    ('ООО “Солёный персик”', 'г. Владимир, ул. Белая, д. 3-Б, к. 1', 'sol.pers@yandex.ru', '8674-34-92'),
    ('ОАО “Простор фантазии”', 'г. Самара, ул. Тухачевского, д. 231', 'office@profant.ru', '6985-256-66')
ON CONFLICT (name) DO UPDATE SET
    address = excluded.address,
    email = excluded.email,
    phone = excluded.phone;



UPDATE store.products
SET 
    price = price*1.05
WHERE origin_country = 'Китай'
RETURNING name
/*
допишите запрос, чтобы обновить данные и вернуть наименования изменённых товаров 
*/