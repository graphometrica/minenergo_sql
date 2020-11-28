--Таблица для хранения данных из яндекса, по индексу самоизоляции в разных регионах
DROP TABLE IF EXISTS isolation_history;

CREATE TABLE isolation_history
(
    id INTEGER PRIMARY KEY GENERATED ALWAYS as identity,
    subject_id int,
    timestamp TIMESTAMP,
    isolation_rate DOUBLE PRECISION
);