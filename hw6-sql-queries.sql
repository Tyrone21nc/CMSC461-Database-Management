CALL generate_tickets();
SELECT * FROM tickets ORDER BY ticket_id DESC LIMIT 2;



BEGIN;
-- Go to Spots table and check if spot 1 is available
SELECT current_status FROM spots WHERE spot_id = 1 FOR UPDATE; 

-- Now, we reserve the spot, where the spot_id is 1
UPDATE spots SET current_status = 'Occupied' WHERE spot_id = 1;
INSERT INTO reservations (user_id, spot_id, start_time, end_time) 
VALUES (1, 1, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP + INTERVAL '2 hours');

COMMIT;

-- ==========================================================
-- TRANSACTION 2: THE CONFLICTING REQUEST (Session B)
-- ==========================================================
-- Starting another transaction
BEGIN;
-- Try to check the same spot while Session A is still there
SELECT current_status FROM spots WHERE spot_id = 1 FOR UPDATE; 
-- NOTE: This query will wait until Session A runs "commit" or "rollback".

-- Then after the wait/pause period, it will say 'Occupied' 
-- and the application logic should prevent the second booking.
ROLLBACK;
















-- 1: Issuing a Permit using the "issue_permit_secure" function
-- Testing a successful issuance
SELECT issue_permit_secure('ABC-123', '2026-12-31', 'Commuter');
-- Verify it was added
SELECT * FROM permits WHERE license_plate = 'ABC-123';





-- 2: Changing a spot to occupied when a user parks in there
-- Check the initial status of the spot
SELECT spot_id, current_status FROM spots WHERE spot_id = 5;
-- Insert sensor event (this is what triggers the update)
INSERT INTO sensor_events (spot_id, entry_time) VALUES (5, NOW());
-- Check updated status
SELECT spot_id, current_status FROM spots WHERE spot_id = 5;



-- 3: Testing for reservation time frame violation and updating
-- Since we just occupied spot_id 5, we can now set a reservation for it
UPDATE reservations 
SET end_time = CURRENT_TIMESTAMP - INTERVAL '1 hour' 
WHERE spot_id = 5;
-- Then we check the DB for a violation
CALL generate_tickets();
-- Then we make sure a ticket was actually generated for the correct parking spot violation
SELECT t.ticket_id, t.license_plate, t.violation_reason, t.amount, t.is_paid
FROM tickets t
JOIN vehicles v ON t.license_plate = v.license_plate
JOIN reservations r ON v.owner_id = r.user_id
WHERE r.spot_id = 5;
SELECT * FROM tickets WHERE ticket_id=5;



-- 4: Concurrency Control
-- 4: Session A
-- Starting the transaction
BEGIN;
-- Lock the spot so no one else can touch it
SELECT * FROM spots WHERE spot_id = 6 FOR UPDATE; -- This area is now locked because this user is using it

COMMIT;

