SELECT 
    category,
    (sales_q_4::real/(sales_q_1 + sales_q_2 + sales_q_3 + sales_q_4)) ---::NUMERIC(3, 2)
FROM store.sales_report
ORDER BY category ASC;


SELECT
    name,
    CASE
        WHEN origin_country != 'Россия' THEN 'Импорт'
        ELSE 'Россия'
    END origin
FROM store.products



UPDATE store.products
SET 
    price = CASE
        WHEN origin_country = 'Россия' THEN price*0.95
        WHEN origin_country = 'Турция' THEN price*1.03
        ELSE COALESCE (price, 100)
    END
WHERE amount>0;


