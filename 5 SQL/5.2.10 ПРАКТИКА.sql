CREATE TABLE store.service_points (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT NOT NULL,
    manager TEXT NOT NULL,
    opens_at TIME NOT NULL,
    closes_at TIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE service_points ADD COLUMN days_off TEXT;



ALTER TABLE service_points 
    ADD CONSTRAINT check_close_time
    CHECK (closes_at>opens_at);



/* 
исправьте код запроса ниже так, чтобы добавить
колонки comments и debt к таблице suppliers
*/
ALTER TABLE suppliers
    ADD COLUMN comments TEXT,
    ADD COLUMN debt DECIMAL(12, 2);