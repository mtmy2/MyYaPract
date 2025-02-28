UPDATE store.products
SET origin_country = 'Китай'
WHERE code = 'BWC457030456' OR code = 'BWC450980456'


-- Имя поставщика с правильными кавычками: ОАО “Простор фантазии”
UPDATE store.suppliers
SET 
    bank_account = '4180566789764',
    bank_name = 'Банк «Котикофф»'
WHERE name = 'ОАО “Простор фантазии”';


DELETE FROM store.products
WHERE price IS NULL;


TRUNCATE TABLE store.orders RESTART IDENTITY;