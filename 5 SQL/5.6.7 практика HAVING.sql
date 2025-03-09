1.
Сравните фильмы разных возрастных рейтингов. 
Найдите среднее значение цены аренды фильма в поле rental_rate для каждого рейтинга (поле rating). 
Оставьте в таблице только те записи, в которых среднее значение rental_rate больше 3.

SELECT 
    rating,
    AVG(rental_rate) -- укажите нужные поля
FROM chinook.movie
GROUP BY rating-- сгруппируйте данные
HAVING AVG(rental_rate) > 3-- пропишите условие;


2.
Изучите заказы, которые оформили в сентябре 2011 года. 
Сравните общую сумму выручки (поле total) за каждый день этого месяца: выведите день в формате '2011-09-01' и сумму. 
Информацию о дате заказа хранит поле invoice_date. 
Измените тип данных в этом поле, чтобы использовать операторы для работы с датой. 
Оставьте в таблице только те значения суммы, которые больше 1 и меньше 10.

SELECT 
    CAST(invoice_date as DATE),
    SUM(total)-- укажите нужные поля
FROM chinook.invoice
WHERE invoice_date BETWEEN  '2011-09-01' AND '2011-09-30' -- пропишите условие
GROUP BY invoice_date -- сгруппируйте данные
HAVING 
    SUM(total) > 1
    AND SUM(total) < 10 -- добавьте условие;

3.
Посчитайте пропуски в поле с почтовым индексом billing_postal_code для каждой страны (поле billing_country). 
Получите срез: в таблицу должны войти только те записи, в которых поле billing_address не содержит слов Street, Way, Road или Drive.
Отобразите в таблице страну и число пропусков, если их больше 10.

SELECT 
    billing_country, 
    COUNT(*)-- укажите нужные поля
FROM chinook.invoice
WHERE 
    (billing_address NOT LIKE '%Street'
    OR billing_address NOT LIKE '%Way'
    OR billing_address NOT LIKE '%Road'
    OR billing_address NOT LIKE '%Drive')
    AND billing_postal_code IS NULL-- пропишите условие
GROUP BY billing_country -- сгруппируйте данные
HAVING Count(*) > 10;-- пропишите условие;


4.
Выведите все альбомы, сумма стоимости треков в которых меньше 5 долларов (цены в столбце unit_price таблицы track указаны в долларах). 
Отсортируйте альбомы от самых дорогих к самым дешёвым. Результат должен содержать два столбца — название альбома (столбец title таблицы album) 
и сумму стоимости треков из этого альбома. Столбцу c суммой дайте псевдоним album_price.

SELECT 
    a.title,
    SUM(t.unit_price) AS album_price
FROM
    chinook.track AS t
    INNER JOIN chinook.album AS a USING (album_id)
GROUP BY a.title
HAVING SUM(t.unit_price)<5
ORDER BY album_price DESC


5.
Группировку можно использовать для поиска и вывода дубликатов по определённым столбцам. 
Найдите в таблице client повторяющиеся имена клиентов, для этого выведите два столбца — имя клиента (first_name) и количество строк с таким именем.

SELECT 
    c.first_name,
    COUNT(*)
FROM chinook.client AS c
GROUP BY c.first_name
HAVING COUNT(*)>1