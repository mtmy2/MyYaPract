CREATE SCHEMA test_schema_1;
CREATE SCHEMA test_schema_2;
CREATE TABLE test_schema_1.table_1 (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL
);
CREATE TABLE test_schema_2.table_1 (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);


DROP TABLE test_schema_2.table_1;
DROP SCHEMA test_schema_2;
DROP SCHEMA test_schema_1 CASCADE;

