CASE 
    WHEN <условие 1> THEN <результат в случае, если условие 1 верно>
    WHEN <условие 2> THEN <результат в случае, если условие 2 верно> 
-- опционально
    ---
    WHEN <условие n> THEN <результат в случае, если условие n верно> 
-- опционально    
      ELSE <результат в случае, если ни одно из условий не верно>      
-- опционально
END;



SELECT 
    name,
    CASE
          /*если значение amount больше 0, значит товар есть*/
          WHEN amount > 0 THEN 'В наличии'
        /*во всех остальных случаях товар отсутствует*/
        ELSE 'Отсутствует'
    END
FROM store.products;


SELECT 
    name,
    CASE
        WHEN amount >= 10 THEN 'Достаточно'
        WHEN amount > 0 THEN 'Заканчивается'
        ELSE 'Отсутствует'
    END
FROM store.products;


/*
При любом количестве товара этот запрос не вернёт результат 'Достаточно'
Потому что при любом положительном количестве сработает первое условие
и вернётся результат 'Заканчивается', 
а в случае amount <= 0 вернётся 'Отсутствует' 
*/
SELECT
    name,
    CASE
        WHEN amount > 0 THEN 'Заканчивается'
        WHEN amount >= 10 THEN 'Достаточно'
        ELSE 'Отсутствует'
    END
FROM store.products;


UPDATE store.products
SET price = CASE
      WHEN category IN ('Аксессуары для автомобилей', 'Аксессуары для телефонов') THEN price * 1.1
    WHEN category IN ('Модные аксессуары') THEN price * 1.05
    ELSE price * 1.15
END;


SELECT
    name,
    CASE
        WHEN birthday >= '2001-01-01' THEN 'XXI'
    END
FROM office.users;


SELECT
    name AS user,
    CASE
        WHEN birthday >= '2001-01-01'::DATE THEN 'XXI'
        WHEN birthday >= '1901-01-01'::DATE THEN 'XX'
          ELSE 'Не указан'
    END century
FROM office.users;


SELECT name, email FROM office.users u;

-- псевдоним таблицы можно использовать как префикс к имени столбца
SELECT u.name, u.email FROM office.users u; 



SELECT 
    name,
    CASE
          /*если значение birthday NULL, заменяем его на '1900-01-01'*/ 
          WHEN birthday IS NULL THEN '1900-01-01'
          /*во всех остальных случаях оставляем заданную дату*/
          ELSE birthday
    END birthday /*это все еще поле birthday*/
FROM office.users;


COALESCE(val1[, val2, ...., val_n])

SELECT 
    name,
    COALESCE (birthday,'1900-01-01') AS birthday
FROM office.users;


SELECT COALESCE (null, 3, null, 56);