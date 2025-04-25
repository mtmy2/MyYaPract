/*Задание 6
В Gastro Hub решили проверить новую продуктовую гипотезу и поднять цены на капучино. 
Маркетологи компании собрали совещание, чтобы обсудить, на сколько стоит поднять цены. 
В это время для отчётности использовать старые цены нельзя. После обсуждения решили увеличить цены на капучино на 20%.
Обновите данные по ценам так, чтобы до завершения обновления никто не вносил других изменений в цены этих заведений. 
В заведениях, где цены не меняются, данные о меню должны остаться в полном доступе.
Поясните принятое решение в комментариях к скрипту.*/

BEGIN;

WITH bavereges AS (
	SELECT -- создаем таблицу с напитками с отдельным столбцом для цены. столбцы название кафе, название напитка, цена
		DISTINCT name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Кофе')::text, ',', 1), '(""')::text AS coffe_name,
		TRIM(SPLIT_PART(jsonb_each(menu -> 'Кофе')::text, ',', 2), ')')::integer AS coffe_price
	FROM cafe.restaurants
	GROUP BY name, coffe_name, coffe_price
	)
new_price AS (
	SELECT --из предыдущей таблицы делаем срез по напитку Капучино и увеличиваем цену в 1.2 раза
		name,
		coffe_name,
		coffe_price * 1.2 AS cappucino_new_price
	FROM bavereges
	WHERE coffe_name = 'Капучино'
	FOR UPDATE) -- для блокировки данных строк используем исключительную блокировку на время транзакции
UPDATE cafe.restaurants AS r
SET menu = jsonb_set(menu, '{Кофе, Капучино}', np.cappucino_new_price::text) -- вставляем новую цену в меню в те строки где есть капучино
FROM new_price AS np
WHERE np.name=r.name;

COMMIT;