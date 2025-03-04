<столбец_дочерней_таблицы> <тип_столбца> REFERENCES <имя_родительской_таблицы> (<столбец_родительской таблицы>)


CREATE TABLE cargo.shipments (
    id integer PRIMARY KEY,
    datetime timestamp,
    freight text,
    sender_id integer REFERENCES cargo.clients (id),
    receiver_id integer REFERENCES cargo.clients (id),
    speed_id integer REFERENCES cargo.speeds (id)
)



ALTER TABLE cargo.shipments ADD FOREIGN KEY (sender_id) REFERENCES clients (id)



CREATE TABLE cargo.shipments (
    id integer PRIMARY KEY,
    datetime timestamp,
    freight text,
    sender_id integer CONSTRAINT fk_shipments_clients_sender_id REFERENCES cargo.clients,
    receiver_id integer CONSTRAINT fk_shipments_clients_receiver_id REFERENCES cargo.clients,
    speed_id integer CONSTRAINT fk_shipments_speed_speed_id REFERENCES cargo.speeds
)



CREATE TABLE cargo.shipments (
    id integer PRIMARY KEY,
    datetime timestamp,
    freight text,
    sender_id integer REFERENCES cargo.clients ON DELETE RESTRICT,
    receiver_id integer REFERENCES cargo.clients ON DELETE RESTRICT,
    speed_id integer REFERENCES cargo.speeds ON DELETE RESTRICT
);


ALTER TABLE cargo.shipments DROP CONSTRAINT shipments_speed_id_fkey;