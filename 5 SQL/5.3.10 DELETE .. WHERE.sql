DELETE FROM <имя таблицы>
WHERE <условие>;


DELETE FROM store.products
WHERE amount = 0;



DELETE FROM store.products;



TRUNCATE TABLE <имя таблицы>;



TRUNCATE TABLE <имя таблицы> RESTART IDENTITY;


DELETE FROM office.users WHERE phone IS NULL;


