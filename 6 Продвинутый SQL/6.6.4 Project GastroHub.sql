/* Этап 1. Создание дополнительных таблиц*/

--содание схемы
CREATE SCHEMA GastroHub;

/*Шаг 1. Создайте enum cafe.restaurant_type с типом заведения coffee_shop, restaurant, bar, pizzeria. */
CREATE type GastroHub.cafe_restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');
