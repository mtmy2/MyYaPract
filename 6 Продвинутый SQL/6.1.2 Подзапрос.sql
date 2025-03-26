Чтобы написать подзапрос, после оператора FROM вместо таблицы добавляют другой запрос. 
Подставим уже написанный код, который выводит пять фильмов с наиболее высоким рейтингом.

SELECT AVG(average_rental)
FROM (.......) AS best_rating

Проверим, какую таблицу вернёт запрос с подзапросом. После SELECT укажем *, чтобы убедиться, что запрос вернёт всю таблицу без ошибок.

SELECT *
FROM (
    SELECT 
        m.rating,
        AVG(m.rental_rate) AS average_rental
    FROM chinook.movie AS m
    GROUP BY m.rating
    ORDER BY average_rental DESC
    LIMIT 5
) AS best_rating; 


Результат остался прежним. Теперь можно вычислить среднее значение. 

SELECT AVG(best_rating.average_rental)
FROM (
    SELECT m.rating,
        AVG(m.rental_rate) AS average_rental
    FROM chinook.movie AS m
    GROUP BY m.rating
    ORDER BY average_rental DESC
    LIMIT 5
) AS best_rating; 


Посчитаем, сколько раз в съёмках поучаствовала тройка самых востребованных актёров и актрис — тех, кто чаще других снимался в кино. Один фильм — одно участие.
Декомпозируем задачу:
Посчитаем, сколько фильмов приходится на каждого актёра или актрису, и выделим тройку рекордсменов по количеству фильмов. То есть найдём тройку самых востребованных.
Найдём суммарное количество того, сколько раз в фильмах участвовали самые востребованные актёры и актрисы.
Сначала разберёмся с первой подзадачей. Соединим таблицу с актёрами и актрисами и таблицу с фильмами, а затем сгруппируем данные по имени актёра или актрисы. 
Так мы посчитаем количество фильмов у каждого, а затем отсортируем это количество по убыванию и отберём первую тройку. Даже такую небольшую задачу удалось декомпозировать. 
Сразу оговоримся, что эту задачу можно решить и другими способами, но об этом поговорим в следующих уроках. 

SELECT 
    a.first_name, 
    a.last_name,
    COUNT(m.film_id) AS total_movie
FROM chinook.actor AS a 
LEFT JOIN chinook.film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN chinook.movie AS m ON m.film_id = fa.film_id
GROUP BY a.first_name, a.last_name
ORDER BY total_movie DESC
LIMIT 3; 

Первая часть задачи решена. Поместим решение в подзапрос после FROM и назначим псевдоним для получившейся таблицы. 
При использовании подзапросов соблюдайте правила стиля и обращайте внимание на отступы. Это позволит не запутаться в коде.
Выполним код с *, чтобы убедиться, что всё работает. 

SELECT *
FROM (
    SELECT 
        a.first_name, 
        a.last_name,
        COUNT(m.film_id) AS total_movie
    FROM chinook.actor AS a 
    LEFT JOIN chinook.film_actor AS fa ON a.actor_id = fa.actor_id
    LEFT JOIN chinook.movie AS m ON m.film_id = fa.film_id
    GROUP BY a.first_name, a.last_name
    ORDER BY total_movie DESC
    LIMIT 3
) AS top_actor; 


Результат не изменился. Теперь можно переходить к следующей задаче — найдём, сколько раз в съёмках участвовали трое самых востребованных актёров или актрис. Вместо * укажем функцию SUM и передадим ей поле total_movie. 

SELECT SUM(total_movie)
FROM (
    SELECT 
        a.first_name, 
        a.last_name,
        COUNT(m.film_id) AS total_movie
    FROM chinook.actor AS a 
    LEFT JOIN chinook.film_actor AS fa ON a.actor_id = fa.actor_id
    LEFT JOIN chinook.movie AS m ON m.film_id = fa.film_id
    GROUP BY a.first_name, a.last_name
    ORDER BY total_movie DESC
    LIMIT 3
) AS top_actor; 