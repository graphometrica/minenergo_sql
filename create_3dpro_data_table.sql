-- таблица хранит в себе очищенные данные с сайта https://3dpro.info/
DROP TABLE IF EXISTS pro_data;

CREATE TABLE pro_data
(
    id INTEGER PRIMARY KEY GENERATED ALWAYS as identity,
    timestamp TIMESTAMP,
    value DOUBLE PRECISION,
    power_system_id int,
    name TEXT
);