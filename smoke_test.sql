-- These queries will open a temporary table for our test
CREATE TABLE smoke_test (
    id SERIAL PRIMARY KEY,
    test_message TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Then we fill it with some data, which will be type TEXT
INSERT INTO smoke_test (test_message) 
VALUES ('Connection Successful'), ('Database is Writable');

-- We select the data to test the reading
SELECT * FROM smoke_test;   -- We select everything from smoke test

