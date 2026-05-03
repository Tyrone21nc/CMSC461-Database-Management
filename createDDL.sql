CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    user_type VARCHAR(20) CHECK (user_type IN ('Student', 'Faculty', 'Visitor', 'Admin'))
);

CREATE TABLE vehicles (
    license_plate VARCHAR(20) PRIMARY KEY,  -- renamed to match references
    make_model VARCHAR(50),
    owner_id INT REFERENCES users(user_id) ON DELETE CASCADE
);

CREATE TABLE lots (
    lot_id SERIAL PRIMARY KEY,
    lot_name VARCHAR(50) NOT NULL,
    zone_type VARCHAR(20) NOT NULL
);

CREATE TABLE spots (
    spot_id SERIAL PRIMARY KEY,
    lot_id INT REFERENCES lots(lot_id) ON DELETE CASCADE,
    spot_number VARCHAR(10) NOT NULL,
    current_status VARCHAR(20) CHECK (current_status IN ('Available', 'Occupied', 'Reserved'))
);

CREATE TABLE reservations (
    res_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(user_id) ON DELETE CASCADE,
    spot_id INT REFERENCES spots(spot_id) ON DELETE CASCADE,
    start_time TIMESTAMP NOT NULL,
    end_time TIMESTAMP NOT NULL
);

CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    res_id INT REFERENCES reservations(res_id) ON DELETE CASCADE,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50), 
    transaction_status VARCHAR(20) DEFAULT 'Success',
    processed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE tickets (
    ticket_id SERIAL PRIMARY KEY,
    license_plate VARCHAR(20) REFERENCES vehicles(license_plate),
    violation_reason VARCHAR(100),
    amount DECIMAL(10,2) DEFAULT 50.00,
    is_paid BOOLEAN DEFAULT FALSE
);

CREATE TABLE permits (
    permit_id SERIAL PRIMARY KEY,
    license_plate VARCHAR(20) REFERENCES vehicles(license_plate),
    expiry_date DATE NOT NULL,
    permit_type VARCHAR(50) NOT NULL
);



-- Creating another table for Part 5 of the project
-- The Sensor Table: Create a sensor_events table (Columns: 
-- event_id, spot_id, entry_time, exit_time).
-- When a car pulls in, a row with these values is created 
-- corresponding to the vehicle
CREATE TABLE sensor_events (
    event_id SERIAL PRIMARY KEY,
    spot_id INT REFERENCES spots(spot_id),
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    exit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_times CHECK (exit_time >= entry_time)
);


-- The Trigger: Write a function and a trigger that says:
-- "When a new row enters sensor_events with an entry time, 
-- change that Spot's current_status to 'Occupied'."
-- The Function: Logic to change spot status
CREATE OR REPLACE FUNCTION update_spot_on_arrival()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE spots 
    SET current_status = 'Occupied' 
    WHERE spot_id = NEW.spot_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- Second: The Trigger (Link it to the table)
CREATE TRIGGER trg_car_arrival
AFTER INSERT ON sensor_events
FOR EACH ROW
EXECUTE FUNCTION update_spot_on_arrival();
--+++
SELECT trigger_name, event_manipulation, event_object_table, action_statement
FROM information_schema.triggers
WHERE event_object_table = 'sensor_events';
INSERT INTO sensor_events (spot_id, entry_time) VALUES (10, NOW());
SELECT * FROM spots WHERE spot_id = 10;


-- The Function: Create a permit_issuance function. It should check 
-- if a user is a 'Student' before allowing a 'Commuter' permit to be inserted.
CREATE OR REPLACE FUNCTION issue_permit_secure(p_plate VARCHAR, p_expiry DATE, p_type VARCHAR)
RETURNS TEXT AS $$
DECLARE
    v_user_type VARCHAR;
BEGIN
    -- Look up the user type based on the vehicle owner
    SELECT u.user_type INTO v_user_type
    FROM users u
    JOIN vehicles v ON u.user_id = v.owner_id
    WHERE v.license_plate = p_plate;

    -- Business Rule Check
    IF p_type = 'Commuter' AND v_user_type != 'Student' THEN
        RETURN 'Error: Commuter permits are reserved for Students only.';
    ELSE
        INSERT INTO permits (license_plate, expiry_date, permit_type)
        VALUES (p_plate, p_expiry, p_type);
        RETURN 'Success: Permit issued to ' || v_user_type;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- The Stored Procedure: Write a procedure called generate_tickets. 
-- It should look for reservations where end_time has passed but 
-- the spot is still 'Occupied', then insert a row into the tickets table.
CREATE OR REPLACE PROCEDURE generate_tickets()
AS $$
BEGIN
    INSERT INTO tickets (license_plate, violation_reason, amount, is_paid)
    SELECT v.license_plate, 'Overtime Parking', 50.00, FALSE
    FROM reservations r
    JOIN vehicles v ON r.user_id = v.owner_id
    JOIN spots s ON r.spot_id = s.spot_id
    WHERE r.end_time < CURRENT_TIMESTAMP  -- Reservation is over
    AND s.current_status = 'Occupied'     -- Car hasn't left
    -- Ensure we don't duplicate the same ticket
    AND NOT EXISTS (
        SELECT 1 FROM tickets t 
        WHERE t.license_plate = v.license_plate 
        AND t.violation_reason = 'Overtime Parking'
        AND t.is_paid = FALSE
    );
END;
$$ LANGUAGE plpgsql;


-- The Views: Create View_CurrentAvailability (joining Lots and 
-- Spots) and View_ActivePermits (filtering by expiry_date > CURRENT_DATE).
-- View 1: Real-time availability by lot
CREATE VIEW View_CurrentAvailability AS
SELECT l.lot_name, COUNT(s.spot_id) AS available_spots
FROM lots l
JOIN spots s ON l.lot_id = s.lot_id
WHERE s.current_status = 'Available'
GROUP BY l.lot_name;

-- View 2: List of active permits (not yet expired)
CREATE VIEW View_ActivePermits AS
SELECT license_plate, permit_type, expiry_date
FROM permits
WHERE expiry_date > CURRENT_DATE;

