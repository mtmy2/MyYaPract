1.
С помощью функции GENERATE_SERIES сгенерируйте последовательность дат (stat_date) в интервале c 1 по 31 августа 2023 года с интервалом в три дня.

SELECT GENERATE_SERIES('2023-08-01', '2023-08-31', '3 DAYS'::INTERVAL)::DATE AS stat_date