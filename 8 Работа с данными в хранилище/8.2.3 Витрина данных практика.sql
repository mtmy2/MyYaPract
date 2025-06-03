1.
Аналитик Елена уже проанализировала данные и написала ТЗ по витрине для вас. Подберите типы данных и напишите DDL витрины. 
В витрине должна быть представлена информация о пользователях приложения:
id — идентификатор записи с автоинкрементом по механизму GENERATED ALWAYS AS IDENTITY. Количество записей в витрине будет постоянно увеличиваться, поэтому нужен большой числовой диапазон значений. Решите самостоятельно, какой тип данных нужно использовать.
login — логин пользователя с ограничением до 32 символов.
fullname — полное имя пользователя.
age — возраст пользователя с проверкой, что значение больше 14.
created_date — дата создания аккаунта. Пример формата: 01.01.2020.
last_visit_date — дата и время последнего захода в приложение. Пример формата: 02.01.2020 12:00:00.
subscription — метка, активна или не активна подписка.
avg_time_in_app_hh — среднее время, проведённое в приложении: в часах, максимум 10 цифр до запятой и одна цифра после запятой, с проверкой, что значение не отрицательное. Пример формата: 2.3 часа.
day_max_time_in_the_app — день недели, когда пользователь проводит в среднем максимальное количество времени в приложении с проверкой, что значение не меньше 0 и не больше 8. Пример формата: 3 (среда).
activity_percentage — процент активности пользователя относительно других пользователей: максимум 10 цифр до запятой и одна цифра после запятой, с проверкой, что значение не будет отрицательным. Пример формата: 24.4% (на 24.4% активней средней активности других пользователей).
Все колонки не должны содержать NULL значения. Создайте PRIMARY KEY с именем application_users_dm_pk для колонки id.

DROP TABLE IF EXISTS public.application_users_dm;

CREATE TABLE IF NOT EXISTS public.application_users_dm (
-- напишите определение колонок здесь
  id bigint primary key constraint application_users_dm_pk GENERATED ALWAYS AS IDENTITY,
  login varchar(32),
  fullname text not null,
  age smallint check (age > 14) not null,
  created_date date not null,
  last_visit_date timestamptz not null,
  subscription Boolean not null,
  avg_time_in_app_hh numeric(11,1) constraint ch check(avg_time_in_app_hh >0) not null,
  day_max_time_in_the_app smallint check(day_max_time_in_the_app>=0 and day_max_time_in_the_app<=8) not null,
  activity_percentage decimal(11,1) not null
  
);



2.
Попробуйте переписать SQL-запрос в запрос в форме CTE.
Старый запрос:

SELECT AVG(B.salary) as avg_salary,
             B.department as department
FROM personal_data AS A 
    INNER JOIN hr_data AS B ON A.employee_id = B.employee_id
        WHERE A.age < 35 AND B.work_experience < 5
            GROUP BY B.department; 
Разделите этот запрос на три части:
Первая часть получает информацию только из таблицы hr_data с учётом опыта работы (work_experience).
Вторая часть получает информацию только из таблицы personal_data с учётом возраста (age).
Третья часть объединяет данные из двух предыдущих и выдаёт результат группировки по отделам (department) и агрегации среднего по зарплате (salary).


WITH 
hr AS (
-- первая часть получает информацию только из таблицы hr_data с учётом опыта работы (work_experience)
Select 
  *
from hr_data
where work_experience < 5
), 
personal AS (
-- вторая часть получает информацию только из таблицы personal_data с учётом возраста (age)
Select 
  *
from personal_data
where age < 35
)

-- третья часть объединяет данные из двух предыдущих и выдаёт результат группировки по отделам (department) и агрегации среднего по зарплате (salary)
Select 
  AVG(a.salary) as avg_salary,
  a.department as department
from hr as a
inner join personal as b on a.employee_id = b.employee_id
group by a.department
;

