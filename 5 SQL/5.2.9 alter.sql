ALTER TABLE office.users ADD COLUMN address TEXT; 

ALTER TABLE office.users ALTER COLUMN address TYPE VARCHAR;

ALTER TABLE office.users DROP COLUMN address;

ALTER TABLE office.users ALTER COLUMN phone SET NOT NULL;

ALTER TABLE office.users ALTER COLUMN phone DROP NOT NULL;

ALTER TABLE <имя_таблицы> 
    ADD CONSTRAINT <имя_ограничения>
    UNIQUE (<имя_столбца>); 
-- если нужно обеспечить уникальность по нескольким столбцам,
-- перечисляем их имена через запятую:
-- <имя_столбца1, имя_столбца2, ...>


-- так вы зададите уникальность номера телефона в столбце
ALTER TABLE office.users ADD CONSTRAINT users_phone_unique UNIQUE (phone);

-- так вы избежите повтора сочетания серии и номера паспорта в таблице
ALTER TABLE persons
    ADD CONSTRAINT persons_passport_unique 
    UNIQUE (passport_series, passport_number);


ALTER TABLE <имя_таблицы> DROP CONSTRAINT <имя_ограничения>;


ALTER TABLE <имя_таблицы> 
    ADD PRIMARY KEY (<имя_столбца>); 
-- или несколько имен в случае композитного PK

ALTER TABLE <имя_таблицы> DROP CONSTRAINT <имя_первичного_ключа>;



ALTER TABLE office.users DROP CONSTRAINT users_pkey;
ALTER TABLE office.users ADD PRIMARY KEY (id);