-- (1) Simple Index on License Plate (Commonly used in JOINS)
CREATE INDEX idx_vehicle_plate ON vehicles(license_plate);

-- (2) Simple Index on User Type (Used for filtering/reports)
CREATE INDEX idx_user_type ON users(user_type);

-- (3) Composite Index (Requirement: At least 1)
-- Speeds up queries searching for specific spots within specific lots
CREATE INDEX idx_lot_spot_status ON spots(lot_id, current_status);

-- (4) B-Tree Index on Timestamp (Speeds up the Audit Trail query)
CREATE INDEX idx_sensor_entry ON sensor_events(entry_time);

-- (5) Gin Index (Optional/Advanced) or another B-Tree 
-- Speeds up searching for owners in the vehicles table
CREATE INDEX idx_vehicle_owner ON vehicles(owner_id);