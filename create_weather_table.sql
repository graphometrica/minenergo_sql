--Скрипт создает табличку, где будут содержаться исторические данные о погоде
DROP TABLE IF EXISTS weather_history;

CREATE TABLE weather_history
(
    id INTEGER PRIMARY KEY GENERATED ALWAYS as identity,
    subject_id int,
    timestamp TIMESTAMP,
    middle_temp DOUBLE PRECISION
);