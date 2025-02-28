CREATE stock (
    name TEXT,
    stock_in INTEGER,
    stock_out INTEGER
);

INSERT INTO stock (name, stock_in, stock_out)
VALUES
    ('Ремешок силиконовый для часов', 60, 20),
    ('Ремешок для часов кожаный', 33, 12);



SELECT name, stock_out, stock_in, stock_out / stock_in FROM store.stock;


CAST(<значение> AS <новый тип>)


SELECT 
    name, 
    stock_out, 
    stock_in, 
    CAST(stock_out AS real) / stock_in 
FROM store.stock;


<значение>::<новый тип>


SELECT 
    name, 
    stock_out, 
    stock_in, 
    stock_out::real / stock_in 
FROM store.stock;


SELECT 
    name, 
    stock_out, 
    stock_in, 
    (stock_out::real / stock_in)::numeric(3, 2)
FROM store.stock; 



SELECT created_at::date FROM users;


SELECT created_at::time FROM users;