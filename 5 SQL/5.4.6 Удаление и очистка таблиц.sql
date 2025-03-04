DROP TABLE cargo.stations;

DROP TABLE cargo.stations CASCADE;


SELECT * FROM cargo.routes;


--удаляем внешний ключ
ALTER TABLE cargo.clients_discounts DROP CONSTRAINT clients_discount_client_id_fkey;
--добавляем новый внешний ключ с действием ON DELETE CASCADE
ALTER TABLE cargo.clients_discounts ADD FOREIGN KEY (client_id) REFERENCES clients ON DELETE CASCADE;
--пробуем удалить таблицу
DROP TABLE cargo.clients;



