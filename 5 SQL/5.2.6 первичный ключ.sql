CREATE TABLE office.users (
    name VARCHAR NOT NULL,
    email VARCHAR PRIMARY KEY,
    phone VARCHAR,
    birthday DATE,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP 
);



CREATE TABLE persons (
    name VARCHAR NOT NULL,
    birthday DATE,
    passport_series VARCHAR,
    passport_number VARCHAR,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP,
    PRIMARY KEY (passport_series, passport_number)
);


CREATE TABLE office.users (
    id INTEGER PRIMARY KEY,
    name varchar,
    email varchar,
    phone varchar,
    birthday date,
    created_at timestamp,
    deleted_at timestamp
);


CREATE TABLE office.users (
    id SERIAL PRIMARY KEY,
    name varchar,
    email varchar,
    phone varchar,
    birthday date,
    created_at timestamp,
    deleted_at timestamp
);