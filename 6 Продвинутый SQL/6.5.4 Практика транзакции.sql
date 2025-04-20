1.
У интернет-магазина товаров для дома есть таблица, где хранятся данные по товарам, с такой структурой:

CREATE SCHEMA household;
CREATE TABLE household.products
(
    id INTEGER PRIMARY KEY,
    product_desc VARCHAR NOT NULL,
    product_amount SMALLINT NOT NULL,
    modify_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
); 
Вот данные, которые нужно занести в таблицу:
id	product_desc	product_amount
1	Тостер	10
2	Микроволновая печь	5
3	Кофеварка	15
4	Пылесос	8
5	Утюг	12
Напишите транзакцию для добавления данных, каждую строку таблицы добавьте отдельным запросом.



begin;
    insert into household.products (id, product_desc, product_amount, modify_date)
    values
    (
        1,
        'Тостер',
        10,
        current_timestamp
    );

    insert into household.products (id, product_desc, product_amount, modify_date)
    values
    (
        2,
        'Микроволновая печь',
        5,
        current_timestamp
    );

    insert into household.products (id, product_desc, product_amount, modify_date)
    values
    (
        3,
        'Кофеварка',
        15,
        current_timestamp
    );

    insert into household.products (id, product_desc, product_amount, modify_date)
    values
    (
        4,
        'Пылесос',
        8,
        current_timestamp
    );

    insert into household.products (id, product_desc, product_amount, modify_date)
    values
    (
        5,
        'Утюг',
        12,
        current_timestamp
    );
Commit;



2.
Коллеги из отдела новых поступлений прислали код, чтобы добавить новые товары в таблицу:

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (9, 'Электрочайник', 11);

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (10, 'Хлебопечка', 4);

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (1, 'Пылесос ручной', 3);

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (2, 'Мясорубка', 8);

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (13, 'Соковыжималка', 6);

INSERT INTO household_products (id, product_desc, product_amount)
VALUES (14, 'Кофемолка', 9); 
Возможно, они ещё не видели данные, которые вы уже успели добавить.
Модифицируйте присланный код таким образом, чтобы в таблицу попали только те товары, которые можно добавить с учётом уже внесённых вами данных. При этом выполните все запросы в одной транзакции. Код запросов INSERT менять нельзя.



Begin;
INSERT INTO household.products (id, product_desc, product_amount)
VALUES (9, 'Электрочайник', 11);

INSERT INTO household.products (id, product_desc, product_amount)
VALUES (10, 'Хлебопечка', 4);

savepoint s1;
INSERT INTO household.products (id, product_desc, product_amount)
VALUES (1, 'Пылесос ручной', 3);

INSERT INTO household.products (id, product_desc, product_amount)
VALUES (2, 'Мясорубка', 8);
rollback to s1;

INSERT INTO household.products (id, product_desc, product_amount)
VALUES (13, 'Соковыжималка', 6);

INSERT INTO household.products (id, product_desc, product_amount)
VALUES (14, 'Кофемолка', 9);
commit;