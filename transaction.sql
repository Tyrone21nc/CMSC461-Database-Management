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
-- Start a transaction
BEGIN;

-- Try to check the SAME spot while Session A is still "thinking"
SELECT current_status FROM spots WHERE spot_id = 1 FOR UPDATE; 
-- NOTE: This query will HANG (wait) until Session A runs COMMIT or ROLLBACK.

-- Once it unfreezes, it will see the spot is now 'Occupied' 
-- and your application logic should prevent the second booking.
ROLLBACK;