CREATE SCHEMA cargo;


CREATE TABLE cargo.clients (
    id integer PRIMARY KEY,
    name text,
    phone text
);


CREATE TABLE cargo.speeds (
    id integer PRIMARY KEY,
    type text,
    coeff numeric(2)
);



CREATE TABLE cargo.shipments (
    id integer PRIMARY KEY,
    datetime timestamp,
    freight text,
    sender_id integer REFERENCES cargo.clients,
    receiver_id integer REFERENCES cargo.clients,
    speed_id integer REFERENCES cargo.speeds
);



CREATE TABLE cargo.clients_discounts (
    id integer PRIMARY KEY,
    client_id integer REFERENCES cargo.clients UNIQUE,
    discount numeric
);



CREATE TABLE cargo.stations (
    id integer PRIMARY KEY,
    station_code integer,
    station_name text,
    station_rw text
);

CREATE TABLE cargo.routes (
    id integer PRIMARY KEY,
    shipment_id integer REFERENCES cargo.shipments,
    station_id integer REFERENCES cargo.stations,
    date_arrival date
);



INSERT INTO cargo.clients (id, name, phone) 
VALUES 
    (1, 'Кузнецов Игорь Николаевич',79112223344),
    (2, 'ООО “Ручки-попрыгучки”', 79225556677),
    (3, 'Кузнецов Николай Петрович', 79441112233),
    (4, 'ООО “Всем по принтеру”', 79338889900),
    (5, 'ООО “Волнующий тюльпан”', 79554445566);

INSERT INTO cargo.speeds (id, type, coeff) 
VALUES 
    (1, 'Грузовая',1),
    (2, 'Пассажирская', 1.6),
    (3, 'Большая', 2.1);

INSERT INTO cargo.shipments (id, datetime, freight, sender_id, receiver_id, speed_id) 
VALUES 
    (1, to_timestamp('10.05.2023 17:10:00', 'dd.mm.yyyy hh24:mi:ss'), 'Личные вещи', 1, 3, 1),
    (2, to_timestamp('12.05.2023 11:30:00', 'dd.mm.yyyy hh24:mi:ss'), 'Канцтовары', 2, 4, 1),
    (3, to_timestamp('24.05.2023 09:00:00', 'dd.mm.yyyy hh24:mi:ss'), 'Упаковочные материалы', 4, 5, 3);

INSERT INTO cargo.clients_discounts (id, client_id, discount) 
VALUES 
    (1, 4, 5.0);

INSERT INTO cargo.stations (id, station_code, station_name, station_rw) 
VALUES 
    (1, 11111, 'Лапочкинск', 'Октябрьская ЖД'),
    (2, 22222, 'Радужный город', 'Октябрьская ЖД'),
    (3, 33333, 'Морковный хутор', 'Московская ЖД'),
    (4, 44444, 'Городищево', 'Московская ЖД'),
    (5, 55555, 'Береговское', 'Московская ЖД');

INSERT INTO cargo.routes (id, shipment_id, station_id, date_arrival) 
VALUES 
    (1, 1, 2, to_date('10.05.2023', 'dd.mm.yyyy')),
    (2, 1, 3, to_date('13.05.2023', 'dd.mm.yyyy')),
    (3, 3, 3, to_date('24.05.2023', 'dd.mm.yyyy')),
    (4, 3, 5, to_date('26.05.2023', 'dd.mm.yyyy')),
    (5, 2, 5, to_date('12.05.2023', 'dd.mm.yyyy'));



INSERT INTO cargo.clients_discounts (id, client_id, discount) 
VALUES 
    (2, 100, 10.0);


DELETE FROM cargo.stations WHERE id = 3;




-- удаляем внешний ключ
ALTER TABLE cargo.routes DROP CONSTRAINT routes_station_id_fkey;
-- добавляем новый внешний ключ с действием ON DELETE CASCADE
ALTER TABLE cargo.routes ADD FOREIGN KEY (station_id) REFERENCES cargo.stations ON DELETE CASCADE;
-- пробуем удалить строку из stations
DELETE FROM cargo.stations WHERE id = 3;
-- проверяем, что строки из routes также удалились
SELECT * FROM cargo.routes;



--удаляем внешний ключ
ALTER TABLE cargo.routes DROP CONSTRAINT routes_station_id_fkey;
--добавляем новый внешний ключ с действием ON DELETE RESTRICT
ALTER TABLE cargo.routes ADD FOREIGN KEY (station_id) REFERENCES cargo.stations ON DELETE RESTRICT;
--пробуем удалить строку из stations
DELETE FROM cargo.stations WHERE id = 2;



DELETE FROM cargo.stations WHERE id = 1;
SELECT * FROM cargo.stations WHERE id = 1;