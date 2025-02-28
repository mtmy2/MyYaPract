SELECT DISTINCT category FROM store.products;


SELECT DISTINCT category 
FROM store.products 
WHERE amount > 0
ORDER BY category ASC;


SELECT DISTINCT ON (category) category, price
FROM store.products
ORDER BY category ASC, price DESC NULLS LAST;