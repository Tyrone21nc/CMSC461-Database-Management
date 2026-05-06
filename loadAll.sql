INSERT INTO users (full_name, email, user_type) VALUES 
('John Doe', 'john@umbc.edu', 'Student'),
('Jane Smith', 'jane@umbc.edu', 'Faculty'),
('Bob Knight', 'bob@umbc.edu', 'Visitor'),
('Alice Wong', 'alice@umbc.edu', 'Student'),
('Charlie Brown', 'charlie@umbc.edu', 'Student'),
('Dave Miller', 'dave@umbc.edu', 'Faculty'),
('Eve Adams', 'eve@umbc.edu', 'Visitor'),
('Frank Wright', 'frank@umbc.edu', 'Admin'),
('Grace Hopper', 'grace@umbc.edu', 'Faculty'),
('Hank Hill', 'hank@umbc.edu', 'Student'),
('Jimmy Johns', 'jjohns@umbc.edu', 'Student');

INSERT INTO lots (lot_name, zone_type) VALUES 
('Commons Lot', 'Student'), 
('Admin Circle', 'Faculty'), 
('Visitor Row', 'Visitor'),
('Stadium Lot', 'Student'), 
('Hilltop Circle', 'Faculty'), 
('Boulevard', 'Student'),
('Library Lot', 'Faculty'), 
('Tech Park', 'Visitor'), 
('Walker Ave', 'Student'), 
('Fine Arts', 'Faculty');

INSERT INTO vehicles (license_plate, make_model, owner_id) VALUES 
('ABC-123', 'Honda Civic', 1), 
('XYZ-987', 'Tesla Model 3', 2), 
('GUEST-1', 'Ford F-150', 3),
('DEF-456', 'Toyota Corolla', 4), 
('GHI-789', 'Subaru Outback', 5), 
('JKL-012', 'BMW 325i', 6),
('MNO-345', 'Chevy Bolt', 7), 
('PQR-678', 'Audi A4', 9), 
('STU-901', 'Jeep Wrangler', 10),
('VWX-234', 'Mazda CX-5', 1);

INSERT INTO spots (lot_id, spot_number, current_status) VALUES 
(1, 'A1', 'Occupied'), 
(2, 'A2', 'Available'), 
(3, 'B1', 'Occupied'), 
(4, 'V1', 'Reserved'),
(5, 'S1', 'Available'), 
(6, 'F1', 'Available'), 
(7, 'C1', 'Occupied'), 
(8, 'L1', 'Available'),
(9, 'T1', 'Reserved'), 
(10, 'W1', 'Available');

INSERT INTO permits (license_plate, expiry_date, permit_type) VALUES 
('ABC-123', '2026-12-31', 'Commuter'), 
('XYZ-987', '2026-06-30', 'Faculty'),
('DEF-456', '2026-12-31', 'Commuter'), 
('GHI-789', '2026-12-31', 'Residential'),
('JKL-012', '2026-05-15', 'Faculty'), 
('PQR-678', '2026-12-31', 'Faculty'),
('STU-901', '2026-12-31', 'Commuter'), 
('VWX-234', '2026-12-31', 'Residential'),
('ABC-123', '2025-01-01', 'EXPIRED_TEST'), 
('XYZ-987', '2027-01-01', 'Faculty'),
('VWX-234', '2026-05-30', 'Commuter');

INSERT INTO reservations (user_id, spot_id, start_time, end_time) VALUES 
(3, 4, '2026-04-05 10:00:00', '2026-04-05 12:00:00'),
(7, 9, '2026-04-05 14:00:00', '2026-04-05 16:00:00'),
(1, 1, '2026-04-06 08:00:00', '2026-04-06 17:00:00'),
(4, 2, '2026-04-06 09:00:00', '2026-04-06 11:00:00'),
(5, 5, '2026-04-06 12:00:00', '2026-04-06 13:00:00'),
(10, 6, '2026-04-07 10:00:00', '2026-04-07 12:00:00'),
(2, 3, '2026-04-07 08:00:00', '2026-04-07 17:00:00'),
(6, 7, '2026-04-08 10:00:00', '2026-04-08 12:00:00'),
(9, 8, '2026-04-08 14:00:00', '2026-04-08 16:00:00'),
(8, 10, '2026-04-09 10:00:00', '2026-04-09 12:00:00');

INSERT INTO payments (res_id, amount, payment_method, transaction_status, processed_at) VALUES 
(1, 5.00, 'Visa', 'Success', '2026-04-05 13:00:00'), 
(2, 4.50, 'ApplePay', 'Success', '2026-04-05 17:00:00'), 
(3, 10.00, 'MasterCard', 'Success', '2026-04-06 18:00:00'),
(4, 3.00, 'Visa', 'Success', '2026-04-06 12:00:00'), 
(5, 2.50, 'CampusCard', 'Success', '2026-04-06 14:00:00'), 
(6, 5.00, 'Visa', 'Success', '2026-04-07 13:00:00'),
(7, 12.00, 'Visa', 'Success', '2026-04-07 18:00:00'), 
(8, 4.00, 'ApplePay', 'Success', '2026-04-08 13:00:00'), 
(9, 6.00, 'MasterCard', 'Success', '2026-04-08 17:00:00'),
(10, 5.00, 'Visa', 'Success', '2026-04-09 13:00:00');

INSERT INTO tickets (license_plate, violation_reason, amount, is_paid) VALUES 
('ABC-123', 'Overtime Parking', 50.00, FALSE), 
('XYZ-987', 'Wrong Zone', 75.00, TRUE),
('GUEST-1', 'No Permit', 50.00, FALSE), 
('DEF-456', 'Overtime Parking', 50.00, TRUE),
('GHI-789', 'Blocking Hydrant', 100.00, FALSE), 
('JKL-012', 'Wrong Zone', 75.00, FALSE),
('MNO-345', 'No Permit', 50.00, TRUE), 
('PQR-678', 'Overtime Parking', 50.00, FALSE),
('STU-901', 'Expired Permit', 50.00, FALSE), 
('VWX-234', 'Wrong Zone', 75.00, TRUE);
