UPDATE <имя таблицы>
SET 
-- список обновляемых полей и их новых значениий через запятую
-- в таком формате
    <поле 1> = <значение 1>,
    <поле 2> = <значение 2>,
    -- ...
    <поле n> = <значение n>
WHERE <условия>;



UPDATE office.users
SET phone = '+7 (123) 456-78-90'
WHERE name = 'Иванов Иван Иванович';


UPDATE office.users
SET 
    phone = '+7 (123) 456-78-90',
    email = 'ivanov.i@mail.ru'
WHERE name = 'Иванов Иван Иванович';



UPDATE store.products
SET price = price * 1.1;


/*этим запросом добавиться 10% наценка только на категории 
'Аксессуары для автомобилей' и 'Аксессуары для телефонов'*/
UPDATE store.products
SET price = price * 1.1
WHERE category IN ('Аксессуары для автомобилей', 'Аксессуары для телефонов');

-- 5% наценка только на категорию 'Модные аксессуары'
UPDATE store.products
SET price = price * 1.05
WHERE category IN ('Модные аксессуары');

-- 15% наценка на все остальные категории, т.е. те, которые не в 3-х предыдущих
UPDATE store.products
SET price = price * 1.15
WHERE category NOT IN ('Аксессуары для автомобилей', 'Аксессуары для телефонов', 'Модные аксессуары');


UPDATE store.products
SET price = price * 0.8
WHERE category = 'Напитки' AND amount <= 100;


