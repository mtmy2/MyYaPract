Например, такой запрос выведет среднюю сумму заказов в Осло, округлённую до целого числа:

SELECT ROUND(AVG(total))
FROM chinook.invoice
WHERE billing_city = 'Oslo';


Теперь можно выгрузить среднюю сумму заказов для каждого города с помощью группировки. 

-- нужно указать поля и необходимые вычисления
SELECT billing_city, ROUND(AVG(total))
FROM chinook.invoice -- добавить таблицу
GROUP BY billing_city -- здесь указывают поле, по которому группируют данные, т.е. город
LIMIT 5; 

Сравните эту таблицу с результатом запроса с ключевым словом DISTINCT:

SELECT DISTINCT 
    invoice_date::date, 
    billing_country
FROM invoice
ORDER BY invoice_date DESC
LIMIT 10; 
С помощью ключевого слова DISTINCT можно получить похожую выдачу, но без поля с результатом агрегирующей функции COUNT. 
В остальном две таблицы похожи, потому что оператор GROUP BY собрал группы по всем комбинациям в полях invoice_date и billing_country.


Если в запросе используется выражение GROUP BY, то в SELECT должны быть указаны либо те столбцы, которые используются в GROUP BY, либо агрегирующие функции.
Например, в этом запросе столбец billing_country указан в SELECT без агрегирующей функции, но не указан как столбец группировки в GROUP BY:

SELECT 
    invoice_date::date,
    billing_country,
    COUNT(total)
FROM chinook.invoice
GROUP BY invoice_date::date  -- группируем только по дате, но не по стране
ORDER BY invoice_date DESC
LIMIT 10; 
Поэтому запрос приведёт к ошибке: