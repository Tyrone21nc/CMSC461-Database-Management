-- (1)Total Revenue -> sum of all paid tickets from everyone
-- we want to make sure we select only where is_paid is set to TRUE
SELECT SUM(amount) as total_revenue FROM tickets WHERE is_paid = TRUE;

-- (2)Lot Popularity -> Count the number of reservations per parking lot area
SELECT l.lot_name, COUNT(r.res_id) 
FROM lots l JOIN spots s ON l.lot_id = s.lot_id 
JOIN reservations r ON s.spot_id = r.spot_id 
GROUP BY l.lot_name;

-- (3)User type Summary -> Count how many students and faculty/staff are in database system
SELECT user_type, COUNT(*) FROM users GROUP BY user_type;

-- (4)Master Schedule -> Join 4 tables to see who is parked where and when
SELECT u.full_name, v.license_plate, s.spot_id, l.lot_name, r.start_time, r.end_time
FROM users u
JOIN vehicles v ON u.user_id = v.owner_id
JOIN reservations r ON v.owner_id = r.user_id
JOIN spots s ON r.spot_id = s.spot_id
JOIN lots l ON s.lot_id = l.lot_id;

-- (5)High-Risk Users -> Find users with more than 2 unpaid tickets (Subquery).
SELECT full_name, email FROM users 
WHERE user_id IN (
    SELECT owner_id FROM vehicles v 
    JOIN tickets t ON v.license_plate = t.license_plate 
    WHERE t.is_paid = FALSE 
    GROUP BY owner_id HAVING COUNT(*) > 2
);

-- (6)Expired Permits in Use -> Find cars currently parked with expired permits.
SELECT v.license_plate, p.expiry_date 
FROM vehicles v
JOIN permits p ON v.license_plate = p.license_plate
JOIN sensor_events se ON v.license_plate = (SELECT license_plate FROM vehicles WHERE owner_id = se.spot_id) -- Force a logic link
WHERE p.expiry_date < CURRENT_DATE AND se.exit_time IS NULL;

-- (7)Empty Lots -> Find lots that currently have 0 occupied spots.
SELECT lot_name FROM lots 
WHERE lot_id NOT IN (SELECT lot_id FROM spots WHERE current_status = 'Occupied');


-- The last three queries are the more expensive ones
-- (8)Pattern Matching Search -> Searching for a specific model name across a large dataset with wildcards at both ends (Slow).
SELECT * FROM vehicles WHERE make_model LIKE '%Toyota%Camry%';

-- (9)Full Audit Trail -> A massive join with a sort on a non-indexed timestamp.
SELECT u.full_name, se.entry_time, se.exit_time, t.amount
FROM users u
CROSS JOIN sensor_events se 
LEFT JOIN tickets t ON u.full_name LIKE '%' -- Intentionally inefficient join
ORDER BY se.entry_time DESC;

-- (10)Revenue Projection -> Complex math in a GROUP BY over multiple years.
SELECT EXTRACT(YEAR FROM entry_time), spot_id, AVG(event_id) * COUNT(*) 
FROM sensor_events 
GROUP BY 1, 2;

