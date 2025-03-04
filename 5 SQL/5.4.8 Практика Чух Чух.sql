CREATE TABLE cargo.trains (
    id serial PRIMARY KEY,
    train_number text,
    departure_station integer REFERENCES cargo.stations(id),
    departure_date TIMESTAMP,
    arrival_station integer REFERENCES cargo.stations(id),
    arrival_date TIMESTAMP
);

