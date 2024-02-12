CREATE TABLE conditions (
    time TIMESTAMPTZ NOT NULL,
    location TEXT NOT NULL,
    temperature DOUBLE PRECISION,
    humidity DOUBLE PRECISION,
    summary TEXT,
    PRIMARY KEY(time, location)
);
SELECT create_hypertable('conditions', 'time');

SELECT add_retention_policy('conditions', INTERVAL '30 days');

