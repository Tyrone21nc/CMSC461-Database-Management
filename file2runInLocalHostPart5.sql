-- We first add the table
CREATE TABLE sensor_events (
    event_id SERIAL PRIMARY KEY,
    spot_id INT REFERENCES spots(spot_id),
    entry_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    exit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_times CHECK (exit_time >= entry_time)
);

-- find a currently available spot
SELECT spot_id, current_status FROM spots WHERE spot_id = 2;

-- insert something in that spot
INSERT INTO sensor_events (spot_id, entry_time, exit_time) 
VALUES (2, CURRENT_TIMESTAMP, NULL);	
-- the 1 is for spot_id, like the one above

-- we print it again
SELECT spot_id, current_status FROM spots WHERE spot_id = 2;



-- we check the number of tickets we're at now
SELECT COUNT(*) FROM tickets;	-- We show the current # of tickets in the DB

-- 
UPDATE reservations SET end_time = (CURRENT_TIMESTAMP - INTERVAL '1 hour') WHERE res_id = 2;
UPDATE spots SET current_status = 'Occupied' WHERE spot_id = (SELECT spot_id FROM reservations WHERE res_id = 2); 


--The function
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
-- then calling the function
CALL generate_tickets();
SELECT * FROM tickets ORDER BY ticket_id DESC LIMIT 2;

