Начнём с целых строк. Вот что можно сделать с ними, используя функции и операторы:
LENGTH — посчитать количество символов в строке.
LOWER, UPPER и INITCAP — изменить регистр символа в строке.
CONCAT, CONCAT_WS и || — объединить несколько строк в одну.
STRING_AGG — объединить несколько строк в одну при агрегации данных.


Например, нужно посчитать количество символов в названии фильма из таблицы movie. Значения необходимо отсортировать в порядке увеличения количества символов в названии фильма. Это можно сделать таким запросом:

SELECT title, LENGTH(title) AS len
FROM chinook.movie
ORDER BY len
LIMIT 10;   


Функции LOWER и UPPER переводят символы строки в нижний и верхний регистр соответственно. 
Например, нужно перевести названия фильмов в нижний и верхний регистры:

SELECT title, LOWER(title) AS lower_title, UPPER(title) AS upper_title
FROM chinook.movie
LIMIT 5; 


Функция INITCAP переводит первую букву каждого слова в строке в верхний регистр, а остальные — в нижний. В результате каждое новое слово в строке будет написано с заглавной буквы. Словами считаются последовательности алфавитно-цифровых символов, разделённые любыми другими символами. 
Например, можно использовать эту функцию, чтобы записать Ф. И. О. в общепринятом формате — с заглавной буквы:

SELECT INITCAP('рИМСКИЙ-корсаков николай андреевич'); 

Римский-Корсаков Николай Андреевич

Функцию CONCAT используют для объединения — или конкатенации — нескольких строк в одну новую строку. 
Функция берёт строки, перечисленные в запросе через запятую, объединяет их и возвращает новую строку с объединёнными данными. 
Количество строк, которые необходимо объединить, может быть любым. Строки объединяются без пробелов или других разделителей, 
поэтому, если разделитель нужен, его тоже необходимо прописать в запросе. В примере ниже отдельно прописан ‘ - ‘, ‘ (‘  и ‘)’. 
Также если нужно, можно добавить к конкатенации любую строку, главное обрамить ее кавычками с обеих сторон. 
Например, нужно собрать расширенную информацию о каждом фильме из таблицы movie в формате год — название (описание):

SELECT CONCAT(release_year, ' — ', title, ' (', description, ')') AS movie_info
FROM chinook.movie
LIMIT 5; 


Объединяя строки, функция CONCAT игнорирует значения NULL. 
Например, в таблице invoice первые три строки столбца billing_state содержат NULL, но это не помешало объединить несколько строк этой таблицы в одну:

SELECT billing_city, billing_state, billing_country,
    CONCAT(billing_city, ' ',  billing_state, ' ', billing_country) AS concat_data
FROM chinook.invoice
LIMIT 5; 



Общий синтаксис похож на CONCAT, за исключением того, что в начале задаётся разделитель строк: CONCAT_WS('разделитель', 'строка_1', 'строка_2', … 'строка_n'). 
Например, нужно соединить имя, фамилию и email сотрудника из таблицы staff, используя пробел в качестве разделителя. Запрос с CONCAT_WS будет таким: 

SELECT CONCAT_WS(' ', first_name, last_name, email) AS staff_info
FROM chinook.staff
LIMIT 5; 


||
Также для объединения заданных значений в одну строку можно использовать оператор конкатенации ||. Это аналог функции CONCAT. В запросе его размещают между значениями, которые нужно объединить. Вот так:

SELECT (release_year || ' — ' || title || ' (' || description || ')') AS movie_info
FROM movie
LIMIT 5; 



В отличие от функции CONCAT, оператор || не сможет объединить последовательность значений, содержащих NULL. В этом случае результатом станет NULL:

SELECT billing_city, billing_state, billing_country,
    (billing_city || ' ' || billing_state || ' ' || billing_country) AS concat_data
FROM chinook.invoice
LIMIT 5; 



STRING_AGG — объединяем несколько строк в одну
Функциями CONCAT и CONCAT_WS можно объединить значения из нескольких столбцов одной строки таблицы в единую текстовую строку. Однако бывает, 
что нужно объединить несколько значений одного столбца при агрегации данных в одну строку. 
Для этого применяют агрегатную функцию STRING_AGG. Она соединяет все значения, отличные от NULL, 
в единую строку в виде списка. Нужный разделитель также прописывают в запросе. В качестве разделителя можно использовать всё что угодно, кроме NULL.
Общий синтаксис функции такой: 

STRING_AGG('строка', 'разделитель'[ORDER BY порядок сортировки значений])
-- то, что написано в квадратных скобках опционально - можно добавлять, а можно и нет 
Например, нужно собрать в новой строке названия всех треков из таблицы track для каждого альбома из таблицы album:

SELECT a.title AS album, STRING_AGG(t.name, ', ') AS track_list
FROM chinook.track t
INNER JOIN chinook.album a ON t.album_id = a.album_id 
GROUP BY a.title
LIMIT 3; 



Также STRING_AGG позволяет отсортировать значения в списке с помощью ORDER BY. 
Например, нужно перечислить фамилии и имена всех сотрудников таблицы staff в разрезе города. Значения строки staff, 
то есть сочетания имени и фамилии сотрудника, нужно отсортировать в алфавитном порядке по фамилии:

SELECT 
    city, 
    STRING_AGG((first_name || ' ' || last_name), ', ' ORDER BY last_name) AS staff
FROM chinook.staff
GROUP BY city; 


Тип	Название	Что делает
Функция	LENGTH	Подсчитывает количество символов в строке.
Функция	LOWER	Изменяет регистр символа в строке на нижний.
Функция	UPPER	Изменяет регистр символа в строке на верхний.
Функция	INITCAP	Переводит первую букву каждого слова в строке в верхний регистр, а остальные — в нижний.
Функция	CONCAT	Объединяет несколько строк в одну.
Функция	CONCAT_WS	Объединяет несколько строк в одну с фиксированным разделителем.
Оператор	||	Объединяет несколько строк в одну.
Функция	STRING_AGG	Объединяет несколько строк в одну при агрегации данных.