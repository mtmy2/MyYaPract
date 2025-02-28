CREATE TABLE office.users (
    name VARCHAR NOT NULL,
    email VARCHAR,
    phone VARCHAR,
    birthday DATE,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);



CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2),
    amount INTEGER DEFAULT 0,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP
);



CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2),
    amount INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);


CREATE TABLE office.users (
    name VARCHAR NOT NULL,
    email VARCHAR UNIQUE,
    phone VARCHAR,
    birthday DATE,
    created_at TIMESTAMP,
    deleted_at TIMESTAMP 
);



 CREATE TABLE office.users (
     name VARCHAR NOT NULL,
     email VARCHAR NOT NULL UNIQUE,
     phone VARCHAR,
     birthday DATE,
     created_at TIMESTAMP,
     deleted_at TIMESTAMP 
);


 CREATE TABLE office.users (
     name VARCHAR NOT NULL,
     email VARCHAR NOT NULL CONSTRAINT users_email_unique UNIQUE,
     phone VARCHAR,
     birthday DATE,
     created_at TIMESTAMP,
     deleted_at TIMESTAMP
);


CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2),
    amount INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    CONSTRAINT products_name_description_unique UNIQUE(name, description)
);



CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2),
    amount INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL,
    UNIQUE(name, description)  -- Указание ограничения без имени.
);


CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2) CHECK(price > 0),
    amount INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);


CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2),
    amount INTEGER NOT NULL DEFAULT 0 CHECK(amount >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);


 CREATE TABLE office.users (
     name VARCHAR NOT NULL,
     email VARCHAR NOT NULL UNIQUE,
     phone VARCHAR,
     birthday DATE,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     deleted_at TIMESTAMP CHECK (deleted_at >= created_at)
);



CREATE TABLE shop.products (
    name VARCHAR,
    description TEXT,
    price NUMERIC(9, 2) CONSTRAINT products_price_positive CHECK(price > 0),
    amount INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP NULL
);



 CREATE TABLE office.users (
     name VARCHAR NOT NULL,
     email VARCHAR NOT NULL UNIQUE,
     phone VARCHAR,
     birthday DATE,
     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
     deleted_at TIMESTAMP,
     CONSTRAINT users_cant_deleted_before_created CHECK (deleted_at >= created_at)
);