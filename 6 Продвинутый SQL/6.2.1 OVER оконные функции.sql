Как устроены оконные функции. Выражение OVER
В этой теме вы познакомитесь с новым инструментом — оконными функциями. Оконные функции помогают решать задачи быстрее и эффективнее. Например, они упрощают большие конструкции из подзапросов.
Что такое оконные функции
Начнём с теории. По названию понятно, что оконные функции связаны с окнами. Окном называют набор записей, объединённых по какому-либо признаку. 
Оконные функции выполняют вычисления для набора записей, объединённых по какому-либо признаку. 
Например: 
Окном может быть месяц, а оконная функция вычислит для каждой строки среднюю стоимость заказов за месяц, к которому эта строка относится. Соответственно, для строк из одного и того же месяца результат выполнения оконной функции получится одинаковым.
Если окно — клиенты, то оконная функция вычислит для каждой строки суммарную стоимость всех заказов клиента, указанного в этой строке.
Самый простой случай — когда окно совпадает со всей таблицей. Тогда оконная функция вычислит и выведет для каждой строки показатель по данным всей таблицы, например, суммарную выручку.
Рассмотрим на примере с велосипедистами. 
Представьте, что у нас есть группа велосипедистов, и каждый записывает, сколько километров он проехал на тренировке. 
Обычная агрегирующая функция вычислит средний пробег группы и покажет одно число — количество километров, которое в среднем проехал велосипедист на тренировке.
Оконная функция покажет средний показатель в строке каждого велосипедиста, и мы сможем сравнить результаты конкретного велосипедиста со средними. Мы сможем добавить ещё один столбец и вычислить в нём разность среднего показателя и конкретного показателя строки. Так мы выясним, длиннее среднего или короче заезд конкретного велосипедиста.
В заезде участвуют три велосипедиста: Петя, Маша и Оля. Показатель Пети — 3 километра, Маши — 5 километров, Оли — 4 километра. При агрегирующей функции вы получите одного число — 4. При агрегирующей оконной функции в дополнение к среднему вы сможете сравнить результаты. Отклонение в результате Пети — -1, Маши — 1, Оли — 0.
Таким образом, агрегирующая функция помогает проанализировать данные для всей группы, в то время как оконная функция предоставляет информацию о каждом участнике группы относительно остальных.
Рассмотрим пример с онлайн-магазином «Сила — в окнах». С ним вы будете работать на протяжении всей темы. База данных магазина состоит из двух схем: online_store и tools_shop. Схемы уже находятся в вашем хранилище PostgreSQL. С описанием схем можно познакомиться под катом.
Описание схем онлайн-магазина «Сила — в окнах»

Сначала применим обычную агрегирующую функцию, а затем сделаем её оконной. 
Возьмём функцию AVG и применим её к таблице с выручкой. Разберём результат работы этой функции без окна и с окном. Используем тривиальный случай: когда окно — это вся таблица. 
Работа AVG в обычном случае: 

SELECT AVG(revenue) AS total_avg
FROM online_store.orders; 
Запрос даст результат — среднее значение выручки по таблице. Мы получим одно значение: 
total_avg
5.49986
Чтобы сделать функцию оконной, зададим окно. В этом поможет выражение OVER(…). В нашем случае, когда окно — вся таблица, скобки у этого выражения останутся пустыми:

SELECT *, AVG(revenue) OVER () AS total_avg
FROM online_store.orders
LIMIT 5; 
Посмотрите на результат: 
user_id	event_dt	revenue	total_avg
55519067947	2020-06-14	5.62	5.49986
831753022495	2020-06-14	1.33	5.49986
284598472478	2020-06-14	4.93	5.49986
725363192554	2020-06-14	1.55	5.49986
324356134597	2020-06-14	9.6	5.49986
В результате запроса мы получили таблицу с такими же строками и столбцами, как и исходная, и один дополнительный столбец — в нём записано среднее значение выручки для каждого окна. Поскольку окно — это вся таблица, столбец содержит среднее по всей таблице. 
В этом отличие оконной функции от обычной — она возвращает таблицу с таким же количеством строк, что и исходная.
Действительно, тот же результат можно получить с помощью подзапроса. Например, так: 

SELECT *, (SELECT AVG(revenue) AS total_avg FROM online_store.orders)
FROM online_store.orders
LIMIT 5; 
Этот листинг выдаст тот же результат, что и оконная функция: 
user_id	event_dt	revenue	total_avg
55519067947	2020-06-14	5.62	5.49986
831753022495	2020-06-14	1.33	5.49986
284598472478	2020-06-14	4.93	5.49986
725363192554	2020-06-14	1.55	5.49986
324356134597	2020-06-14	9.6	5.49986
Но представьте, что вам нужно выгрузить не одно поле total_avg, как в предыдущем запросе, а несколько аналогичных полей. Запрос с оконной функцией будет лаконичнее.
С оконными функциями удобно работать также потому, что существует много готовых функций под наиболее частые задачи. Если вы столкнулись с новой задачей, проверьте: возможно, подходящая оконная функция уже есть в БД.
Ещё одно преимущество оконных функций — в их гибкости. Дополнительные параметры позволяют настраивать их работу под каждую задачу. С некоторыми параметрами вы познакомитесь уже в следующем уроке. 
Преимущества оконных функций — в простоте записи, большом выборе функций, гибкости.
Разберёмся подробнее, как работает OVER.
Напомним запрос с оконной функцией: 

SELECT *, AVG(revenue) OVER () AS total_avg
FROM online_store.orders
LIMIT 5; 
Запрос с выражением OVER значит следующее:
нужно разделить записи на разделы-окна по параметрам в выражении OVER,
затем посчитать среднюю выручку по записям в каждом окне.
В скобках OVER мы ничего не писали, поэтому в окно вошла вся таблица. Как указывать параметры окна, мы ещё расскажем. 
Разберём, что делает этот запрос с OVER: 
Оконная функция добавляет новое поле — total_avg.
В это поле входит результат действия функции, которая рассчитывается в зависимости от параметров в скобках. В примере это среднее по выручке.
В скобках выражения OVER ничего нет, поэтому среднее значение поля revenue рассчитывается по всей таблице.
Описание иллюстрации — в тексте выше. 
Оконной функцией может быть не только AVG. Оконных функций много, можно выделить две группы:
Агрегирующие оконные функции. Они вам хорошо знакомы — это функции AVG, MIN, MAX, SUM и COUNT и другие. Они становятся оконными только с выражением OVER. Если это выражение отсутствует, функция работает как обычная агрегирующая и возвращает только одну строку, а не набор строк.
Функции общего назначения. Их используют только как оконные, то есть нельзя вызвать их без OVER. К ним относятся функции ранжирования, смещения и другие.
Работа и устройство функций обеих групп одинаковы. Сначала мы будем рассматривать примеры на агрегирующих оконных функциях, потому что проще изучать новый материал на уже знакомых вещах. А затем перейдём к функциям общего назначения.
Покажем ещё один пример использования оконной функции — теперь с фильтрацией и сортировкой. 

SELECT *, SUM(revenue) OVER () AS revenue_sum
FROM online_store.orders 
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	revenue_sum
59432616	2020-06-17	7.59	36.84
300768196	2020-06-25	8.74	36.84
300768196	2020-06-27	5.26	36.84
840452722	2020-06-19	5.81	36.84
840452722	2020-06-21	3.17	36.84
840452722	2020-06-24	6.27	36.84
В таблице отобразились все поля таблицы orders, и к ним добавилось поле с суммой выручки. Сумма рассчитана только для тех записей, в которых user_id равен 300768196, 840452722 или 59432616. Так происходит, потому что оконные функции располагаются в блоке SELECT, где перед ними идут фильтрации WHERE. Соответственно, оконные функции отрабатывают после WHERE. Итоговая таблица отсортирована по user_id. 
Напомним, что оконная функция выдаёт значения для всех записей таблицы, поэтому выражение SUM(revenue) OVER () вернёт сумму значений в поле revenue, рассчитанную в каждой записи.
Описание иллюстрации — в тексте выше. 
Что сделает следующий запрос? Выберите один правильный вариант ответа. 

SELECT port, COUNT(port) OVER ()
FROM ports; 


Добавит в таблицу ports ещё одно поле с общим числом записей.
Оконная функция ничего не добавляет к изначальной таблице — она формирует значения в выдаче.

Выдаст одно число — количество записей в таблице.
Благодаря выражению OVER обычная агрегирующая функция станет оконной. Она выдаст ещё одно поле в дополнение к заданным.

Правильный ответ
Отобразит два поля: port и новое поле с числом записей в таблице. Это число войдёт в каждую ячейку поля.
Оконная функция выдаст отдельное поле в выборке, в этом поле будет сформировано значение количества записей для окна (в этом случае для всей таблицы).

Выведет количество значений для каждого уникального port.
Для этого нужно в скобках выражения OVER прописать дополнительные параметры. Какие именно — узнаете в следующих уроках.
В следующем уроке подробнее поговорим про ситуацию, когда окно не совпадает со всей таблицей.