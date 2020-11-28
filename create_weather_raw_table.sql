--создание таблицы с сырыми данными из http://rp5.ru/, в таблице хрянятся данные о погоде в конкретном регионе каждый час, за последние 3 года
DROP TABLE IF EXISTS weather_raw;

CREATE TABLE weather_raw
(
    id INTEGER PRIMARY KEY GENERATED ALWAYS as identity,
    subject_id int,
    timestamp TIMESTAMP,
    temp DOUBLE PRECISION
);