CREATE TABLE cargo.trains (
    id serial PRIMARY KEY,
    train_number text,
    departure_station integer REFERENCES cargo.stations(id),
    departure_date TIMESTAMP,
    arrival_station integer REFERENCES cargo.stations(id),
    arrival_date TIMESTAMP
);

CREATE TABLE cargo.car_types (
    id integer PRIMARY KEY,
    car_type_name TEXT
);


INSERT INTO cargo.car_types (id, car_type_name)
VALUES 
    (1, 'вагон'),
    (2, 'локомотив'),
    (3, 'полувагон'),
    (4, 'рефрижератор'),
    (5, 'технический')

CREATE TABLE cargo.cars (
    id SERIAL PRIMARY KEY,
    car_number TEXT,
    car_type_id integer references cargo.car_types(id) default 1
);

CREATE TABLE cargo.cars_in_trains (
    id serial PRIMARY KEY,
    train_id integer REFERENCES cargo.trains(id),
    car_id integer REFERENCES cargo.cars(id),
    attach_date TIMESTAMP,
    detach_date TIMESTAMP
);


CREATE TABLE CARGO.cars_have_no_passports (
    id serial PRIMARY KEY,
    car_id INTEGER UNIQUE REFERENCES cargo.cars(id),
    date_entry TIMESTAMP
);


ALTER TABLE cargo.shipments ADD COLUMN cars_in_trains_id integer REFERENCES cargo.cars_in_trains(id)


