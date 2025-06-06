Функции ранжирования. RANK() и DENSE_RANK()
Функции RANK() и DENSE_RANK() похожи на функцию ROW_NUMBER() и отличаются лишь логикой ранжирования повторяющихся значений. Как вы помните, 
в случае повтора функция ROW_NUMBER() присваивает такой записи следующий ранг, как в уже знакомом вам запросе:

SELECT *, 
    ROW_NUMBER() OVER (ORDER BY user_id)
FROM online_store.orders
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	row_number
59432616	2020-06-17	7.59	1
300768196	2020-06-25	8.74	2
300768196	2020-06-27	5.26	3
840452722	2020-06-19	5.81	4
840452722	2020-06-21	3.17	5
840452722	2020-06-24	6.27	6
Функция RANK()
Функция RANK() присваивает одинаковым значениям одинаковый ранг. Например, если на соревнованиях два спортсмена показали одинаковый результат, они поделят одно и то же место. При этом в случае совпадения рангов функция пропускает следующий, и в последовательности рангов появляются пропуски. 
Посмотрите, как это происходит на примере с той же выборкой из таблицы online_store.orders: 

SELECT *, 
    RANK() OVER (ORDER BY user_id)
FROM online_store.orders
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	rank
59432616	2020-06-17	7.59	1
300768196	2020-06-25	8.74	2
300768196	2020-06-27	5.26	2
840452722	2020-06-19	5.81	4
840452722	2020-06-21	3.17	4
840452722	2020-06-24	6.27	4
У записи с user_id, равным 840452722, ранг 4. Функция RANK() присваивает один ранг одинаковым записям, но чтобы вычислить каждый следующий ранг, к текущему номеру ранга прибавляется количество записей этого ранга. Именно поэтому ранги получились непоследовательными: 1, 2, 4. Записям со следующим user_id был бы назначен ранг 7. 
Такое ранжирование позволяет оценить разрыв между рангами по количеству значений с одинаковым рангом. 
Функция DENSE_RANK()
В отличие от функции RANK(), DENSE_RANK() не учитывает количество записей и назначает ранги последовательно. 

SELECT *, 
    DENSE_RANK() OVER (ORDER BY user_id)
FROM online_store.orders 
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	dense_rank
59432616	2020-06-17	7.59	1
300768196	2020-06-25	8.74	2
300768196	2020-06-27	5.26	2
840452722	2020-06-19	5.81	3
840452722	2020-06-21	3.17	3
840452722	2020-06-24	6.27	3
Последовательный ранг без пропусков поможет, например, составить список товаров, которые заказывают чаще всего. Функция DENSE_RANK() проранжирует товары интернет-магазина по количеству заказов, и последующая группировка выделит группы товаров по мере уменьшения количества заказов. 
Подведём итог:
Функция	Последовательны ли ранги?	Ранги у одинаковых значений	Какую задачу помогает решить
ROW_NUMBER()	да	разные	Присвоить порядковый номер строкам с учётом сортировки или последовательности, в которой они записаны в таблице
RANK()	нет	одинаковые	Оценить разрыв между рангами по количеству значений с одинаковым рангом.
DENSE_RANK()	да	одинаковые	Сгруппировать записи по мере уменьшения параметра.
Использование ORDER BY
В функциях RANK() и DENSE_RANK() всегда используется ORDER BY, чтобы задать порядок ранжирования. Можно ли использовать эти функции без него? Можно, но так как критериев для ранжирования не будет, все записи получат значение 1 — это неинформативно.

SELECT *, 
    RANK() OVER ()
FROM online_store.orders 
WHERE user_id IN (300768196, 840452722, 59432616)
ORDER BY user_id; 
user_id	event_dt	revenue	dense_rank
59432616	2020-06-17	7.59	1
300768196	2020-06-25	8.74	1
300768196	2020-06-27	5.26	1
840452722	2020-06-19	5.81	1
840452722	2020-06-21	3.17	1
840452722	2020-06-24	6.27	1
Проверьте, что результат запроса будет таким же при использовании функции DENSE_RANK().
Использование PARTITION BY
Как и для других оконных функций, при использовании RANK() и DENSE_RANK() можно задать окно оператором окна PARTITION BY. В этом случае ранжирование будет происходить внутри каждой группы отдельно.
Запрос ниже проранжирует заказы по убыванию суммы заказа за каждый день и присвоит ранг в зависимости от выбранной функции:

SELECT *, 
    RANK() OVER (PARTITION BY event_dt ORDER BY revenue DESC)    
FROM online_store.orders
WHERE user_id IN (217627310483, 642311747775, 525952011119,19002035576)
ORDER BY event_dt; 
user_id	event_dt	revenue	rank
642311747775	2020-06-14	7.72	1
642311747775	2020-06-15	3.02	1
642311747775	2020-06-20	9.97	1
217627310483	2020-06-20	9.97	1
525952011119	2020-06-20	9.95	3
19002035576	2020-06-20	8.26	4
19002035576	2020-06-26	8.46	1

SELECT *, 
    DENSE_RANK() OVER (PARTITION BY event_dt ORDER BY revenue DESC)    
FROM online_store.orders
WHERE user_id IN (217627310483, 642311747775, 525952011119,19002035576)
ORDER BY event_dt; 
user_id	event_dt	revenue	dense_rank
642311747775	2020-06-14	7.72	1
642311747775	2020-06-15	3.02	1
642311747775	2020-06-20	9.97	1
217627310483	2020-06-20	9.97	1
525952011119	2020-06-20	9.95	2
19002035576	2020-06-20	8.26	3
19002035576	2020-06-26	8.46	1
