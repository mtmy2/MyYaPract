INSERT INTO <имя таблицы> (<столбец 1>, <столбец 2>, ... <столбец n>)
VALUES (<значение 1>, <значение 2>, ... <значение n>);


CREATE TABLE office.users (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    phone VARCHAR,
    birthday DATE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    deleted_at TIMESTAMP CHECK (deleted_at >= created_at)
);

INSERT INTO office.users (name, phone, email)
VALUES ('Иванов Иван Иванович', '+7 (495) 123-56-78', 'newuseremail@yandex.ru');


INSERT INTO office.users (name, phone) 
VALUES 
    ('Петров Сергей Петрович', '+7 (495) 123-56-78');

-- ERROR: 
-- null value in column "email" of relation "users" violates not-null constraint                                         |



INSERT INTO office.users (
    id, 
    name, 
    phone, 
    email,
    birthday,
    created_at
) 
VALUES 
    (
        DEFAULT,  -- значение по умолчанию для SERIAL — автоинкрекмент
        'Петрова Ольга Петровна', 
        '+7 (495) 236-56-98', 
        'o.petrova@yandex.ru', 
        '2001-05-06', 
        DEFAULT -- значение по умолчанию — текущий момент времени
    );



INSERT INTO  office.users (name, phone, email) 
VALUES 
    ('Петров Сергей Петрович', '+7 (495) 123-56-78', 'petrov@yandex.ru'),
    ('Зайцева Елена Ивановна', '+7 (495) 345-86-98', 'zayceva@yandex.ru'),
    ('Медведев Семён Семёнович', '+7 (495) 369-85-12', 'medvedev@yandex.ru');


INSERT INTO office.users VALUES (
    DEFAULT,  -- id
    'Кузнецов Сергей Алексеевич', -- name
    'kuznetzov@yandex.ru',        -- email
    '+7 (495) 316-64-80',         -- phone
    '1985-03-16', -- birthday
    DEFAULT,      -- значение по умолчанию - текущий момент времени
    NULL          -- NULL для колонки deleted_at
);