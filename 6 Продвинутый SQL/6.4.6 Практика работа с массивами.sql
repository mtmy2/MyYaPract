1.
Напишите запрос, который добавит в таблицу vendors сведения о новом поставщике. Наименование поставщика — ООО «Фермерский дом», ИНН 5918456654. Значение guid сгенерируйте самостоятельно.

Insert into crispy_selery.vendors (guid, name, inn)
values (
        GEN_RANDOM_UUID(),
        'ООО «Фермерский дом»',
        '5918456654')

2.
В таблице week_revenue есть данные о выручке за неделю, которая началась 07.08.2023. Найдите выручку третьего магазина в четверг на этой неделе.

select revenue[4][3] from crispy_selery.week_revenue where date_begin=to_date('07.08.2023', 'DD.MM.YYYY')

3.
В таблице week_revenue есть данные о выручке за четыре дня недели, начинающейся с 21.08.2023. Добавьте к ним данные о выручке за пятницу:

UPDATE crispy_selery.week_revenue 
SET revenue = ARRAY_APPEND(revenue, '{133, 62, 106}')
WHERE date_begin=to_date('21.08.2023', 'DD.MM.YYYY')

4.
Определите, сколько дней в неделе, начавшейся 07.08.2023, выручка второго магазина была больше 80.

SELECT count(*) FROM 
	(select UNNEST(ARRAY[revenue[1:7][2:2]]) AS revenue
    from crispy_selery.week_revenue
    where date_begin=to_date('07.08.2023', 'DD.MM.YYYY')) as t
WHERE t.revenue > 80


5.
Определите, за сколько дней отображена информация о выручке в строке с date_begin = 28.08.2023.

select 
    ARRAY_LENGTH(ARRAY[revenue], 2) AS revenue
from crispy_selery.week_revenue
where date_begin=to_date('28.08.2023', 'DD.MM.YYYY')


6.
Определите, сколько было недель, когда выручка хотя бы одного из магазинов хотя бы в один день была не меньше 140.

select count(*)
from crispy_selery.week_revenue
where 140 <= any(revenue)