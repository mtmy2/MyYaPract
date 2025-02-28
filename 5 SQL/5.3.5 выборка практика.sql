SELECT name, phone, email
FROM store.suppliers


SELECT name, category, description, price
FROM store.products
WHERE category = 'Модные аксессуары' AND description ILIKE '%СИНИЙ%' AND amount>0


SELECT name, category, price, amount
FROM store.products
WHERE origin_country = 'Китай' AND (price<=1000 OR  amount<=3)
