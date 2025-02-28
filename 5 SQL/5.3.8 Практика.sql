SELECT name, description, origin_country, price
FROM store.products
WHERE category = 'Модные аксессуары' and  amount>0
ORDER BY price DESC NULLS LAST



SELECT name, description, origin_country, price
FROM store.products
WHERE category = 'Модные аксессуары' AND amount > 0
ORDER BY price DESC
LIMIT 5
OFFSET 10;


SELECT DISTINCT origin_country
FROM store.products
WHERE amount > 0
ORDER BY origin_country;


SELECT DISTINCT ON (origin_country) origin_country, price 
FROM store.products
WHERE amount > 0
ORDER BY origin_country, price;