SELECT 'Hello,'
UNION
SELECT 'world!';


SELECT 'Hello,' 
UNION 
SELECT 'dear' 
UNION 
SELECT 'world!';


SELECT 1, 'Hello,' 
UNION 
SELECT 2, 'dear' 
UNION 
SELECT 3, 'world!';


SELECT 1 as id, 'Hello,' as word
UNION 
SELECT 2, 'dear' 
UNION 
SELECT 3, 'world!'
ORDER BY id;


SELECT 1, 'Hello,'
UNION
SELECT 2, 'dear'
UNION
SELECT 3, 'world!'
ORDER BY 1;



SELECT 1 as id, 'Hello,' as word
UNION
(SELECT * FROM (VALUES (2, 'dear'), (2, 'dear again')) AS temp_table LIMIT 1)
UNION
SELECT 3, 'world!'
ORDER BY id;


По умолчанию UNION удаляет все дубликаты строк, и вот в таком запросе:

SELECT 1 UNION SELECT 1; 
вернётся только одна строка с числом 1.


Можно оставить в запросе все строки, в том числе дубликаты. Для этого нужно указать после UNION ключевое слово ALL (пер. с англ. — все).

SELECT 1 UNION ALL SELECT 1; 

UNION ALL работает значительно быстрее обычного UNION, 
так как не задействует механизм проверки дубликатов в результате. 
Мы рекомендуем использовать UNION ALL  везде, где это возможно и не мешает вашим задачам.


SELECT last_name, first_name 
FROM chinook.client 
WHERE city = 'Edmonton'

UNION

SELECT last_name, first_name 
FROM chinook.staff 
WHERE city = 'Edmonton';



Необходимо найти все продукты, которые есть и в таблице «Товары в наличии», и в таблице «Популярные товары».

SELECT product_name FROM products_in_stock
INTERSECT
SELECT product_name FROM popular_products; 


Необходимо найти все товары, которые заказывают и в интернет-магазине, и в офлайн-бутике.

SELECT product_name FROM online_orders
INTERSECT
SELECT product_name FROM in_store_orders; 



Необходимо найти все продукты, которые есть в таблице «Популярные товары», но которых нет в таблице «Товары в наличии».

SELECT product_name FROM popular_products
EXCEPT
SELECT product_name FROM products_in_stock; 


Необходимо найти все пиццы, которые покупают только в кафе, но не берут на вынос.

SELECT pizza_name FROM cafe_orders
EXCEPT
SELECT pizza_name FROM takeout_orders; 


Комбинации операторов
Операторы можно комбинировать — и получать разные выборки для разных целей. 
Чтобы запросы выполнялись в нужном порядке, необходимо проставлять круглые скобки вокруг запросов. 
Иначе результат может сильно отличаться от ожидаемого.

(SELECT 1 UNION SELECT 2)   -- шаг 1
INTERSECT                   -- шаг 3
(SELECT 2 UNION SELECT 3);  -- шаг 2 
В запросе выше: 
на первом шаге мы получили выборку из двух строк с числами 1 и 2,
на втором шаге — получили выборку из двух строк с числами 2 и 3,
на третьем шаге получаем пересечение выборок из 1 и 2 шага, то есть их общие строки — это единственная строка с числом 2.
Уберём скобки в запросе:

SELECT 1 UNION SELECT 2   -- шаг 2
INTERSECT                 -- шаг 1
SELECT 2 UNION SELECT 3;  -- шаг 3 
Порядок шагов поменялся. Без круглых скобок UNION и EXCEPT объединяются слева направо, 
но оператор INTERSECT имеет больший приоритет, чем первые два. Таким образом, 
сначала  будет вычислен запрос SELECT 2 INTERSECT SELECT 2 — в результате получится строка с числом 2. 
Затем запрос выполнит остальные шаги. В итоге выведутся три строки с числами 1, 2, 3.


(SELECT 1 UNION SELECT 2)   -- шаг 1
EXCEPT                      -- шаг 3
(SELECT 2 UNION SELECT 3);  -- шаг 2



SELECT 1 UNION SELECT 2   -- шаг 1
EXCEPT                    -- шаг 2
SELECT 2 UNION SELECT 3;  -- шаг 3