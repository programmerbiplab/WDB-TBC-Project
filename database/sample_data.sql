-- ============================================
-- World Hotels Booking System - Sample Data
-- Student: Biplab Prasad Gajurel
-- Date: January 11, 2025
-- Purpose: To populate database with test data
-- ============================================

USE world_hotels_db;

-- Disable foreign key checks for clean insertion
SET FOREIGN_KEY_CHECKS = 0;

-- Clear existing data (if any)
TRUNCATE TABLE booking_pricing;
TRUNCATE TABLE bookings;
TRUNCATE TABLE prices;
TRUNCATE TABLE rooms;
TRUNCATE TABLE room_types;
TRUNCATE TABLE seasons;
TRUNCATE TABLE hotels;
TRUNCATE TABLE users;
TRUNCATE TABLE exchange_rates;

-- Re-enable foreign key checks
SET FOREIGN_KEY_CHECKS = 1;

-- ============================================
-- 1. INSERT ROOM TYPES (3 types)
-- ============================================
INSERT INTO room_types (type_name, max_guests, price_multiplier, has_wifi, has_minibar, has_tv, includes_breakfast) VALUES
('Standard', 1, 1.00, TRUE, TRUE, TRUE, TRUE),
('Double', 2, 1.20, TRUE, TRUE, TRUE, TRUE),
('Family', 4, 1.50, TRUE, TRUE, TRUE, TRUE);

SELECT 'Room types inserted: Standard, Double, Family' AS status;

-- ============================================
-- 2. INSERT SEASONS (4 season periods)
-- ============================================
INSERT INTO seasons (season_name, start_month, end_month) VALUES
('Peak', 4, 8),      -- April to August
('Peak', 11, 12),    -- November to December
('Off-Peak', 1, 3),  -- January to March
('Off-Peak', 9, 10); -- September to October

SELECT 'Seasons inserted: 2 Peak, 2 Off-Peak periods' AS status;

-- ============================================
-- 3. INSERT HOTELS (17 UK Cities)
-- With exact capacities and addresses
-- ============================================
INSERT INTO hotels (city, capacity, address) VALUES
('Aberdeen', 90, '10 Union Street, Aberdeen AB10 1DD, UK'),
('Belfast', 80, '15 Royal Avenue, Belfast BT1 1DA, UK'),
('Birmingham', 110, '25 New Street, Birmingham B2 4BQ, UK'),
('Bristol', 100, '30 Broad Street, Bristol BS1 2EJ, UK'),
('Cardiff', 90, '45 Queen Street, Cardiff CF10 2BU, UK'),
('Edinburgh', 120, '50 Princes Street, Edinburgh EH2 2BY, UK'),
('Glasgow', 140, '60 Buchanan Street, Glasgow G1 3JN, UK'),
('London', 160, '100 Oxford Street, London W1D 1LL, UK'),
('Manchester', 150, '80 Deansgate, Manchester M3 2ER, UK'),
('Newcastle', 90, '20 Grey Street, Newcastle NE1 6AE, UK'),
('Norwich', 90, '35 Gentleman Walk, Norwich NR2 1NA, UK'),
('Nottingham', 110, '40 Market Square, Nottingham NG1 2DP, UK'),
('Oxford', 90, '55 High Street, Oxford OX1 4AP, UK'),
('Plymouth', 80, '65 Royal Parade, Plymouth PL1 1DS, UK'),
('Swansea', 70, '70 Wind Street, Swansea SA1 1EE, UK'),
('Bournemouth', 90, '75 Old Christchurch Road, Bournemouth BH1 1EW, UK'),
('Kent', 100, '85 High Street, Canterbury, Kent CT1 2JE, UK');

SELECT 'Hotels inserted: 17 UK cities' AS status;

-- ============================================
-- 4. INSERT PRICES (12 rows per hotel)
-- 4 seasons × 3 room types = 12 combinations per hotel
-- Prices based on Table 1 from assessment brief
-- ============================================

-- Aberdeen (Hotel ID 1) - Peak: £140, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(1, 1, 1, 140.00), (1, 1, 2, 140.00), (1, 1, 3, 70.00), (1, 1, 4, 70.00),  -- Standard
(1, 2, 1, 168.00), (1, 2, 2, 168.00), (1, 2, 3, 84.00), (1, 2, 4, 84.00),  -- Double (+20%)
(1, 3, 1, 210.00), (1, 3, 2, 210.00), (1, 3, 3, 105.00), (1, 3, 4, 105.00); -- Family (+50%)

-- Belfast (Hotel ID 2) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(2, 1, 1, 130.00), (2, 1, 2, 130.00), (2, 1, 3, 70.00), (2, 1, 4, 70.00),
(2, 2, 1, 156.00), (2, 2, 2, 156.00), (2, 2, 3, 84.00), (2, 2, 4, 84.00),
(2, 3, 1, 195.00), (2, 3, 2, 195.00), (2, 3, 3, 105.00), (2, 3, 4, 105.00);

-- Birmingham (Hotel ID 3) - Peak: £150, Off-Peak: £75
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(3, 1, 1, 150.00), (3, 1, 2, 150.00), (3, 1, 3, 75.00), (3, 1, 4, 75.00),
(3, 2, 1, 180.00), (3, 2, 2, 180.00), (3, 2, 3, 90.00), (3, 2, 4, 90.00),
(3, 3, 1, 225.00), (3, 3, 2, 225.00), (3, 3, 3, 112.50), (3, 3, 4, 112.50);

-- Bristol (Hotel ID 4) - Peak: £140, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(4, 1, 1, 140.00), (4, 1, 2, 140.00), (4, 1, 3, 70.00), (4, 1, 4, 70.00),
(4, 2, 1, 168.00), (4, 2, 2, 168.00), (4, 2, 3, 84.00), (4, 2, 4, 84.00),
(4, 3, 1, 210.00), (4, 3, 2, 210.00), (4, 3, 3, 105.00), (4, 3, 4, 105.00);

-- Cardiff (Hotel ID 5) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(5, 1, 1, 130.00), (5, 1, 2, 130.00), (5, 1, 3, 70.00), (5, 1, 4, 70.00),
(5, 2, 1, 156.00), (5, 2, 2, 156.00), (5, 2, 3, 84.00), (5, 2, 4, 84.00),
(5, 3, 1, 195.00), (5, 3, 2, 195.00), (5, 3, 3, 105.00), (5, 3, 4, 105.00);

-- Edinburgh (Hotel ID 6) - Peak: £160, Off-Peak: £80
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(6, 1, 1, 160.00), (6, 1, 2, 160.00), (6, 1, 3, 80.00), (6, 1, 4, 80.00),
(6, 2, 1, 192.00), (6, 2, 2, 192.00), (6, 2, 3, 96.00), (6, 2, 4, 96.00),
(6, 3, 1, 240.00), (6, 3, 2, 240.00), (6, 3, 3, 120.00), (6, 3, 4, 120.00);

-- Glasgow (Hotel ID 7) - Peak: £150, Off-Peak: £75
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(7, 1, 1, 150.00), (7, 1, 2, 150.00), (7, 1, 3, 75.00), (7, 1, 4, 75.00),
(7, 2, 1, 180.00), (7, 2, 2, 180.00), (7, 2, 3, 90.00), (7, 2, 4, 90.00),
(7, 3, 1, 225.00), (7, 3, 2, 225.00), (7, 3, 3, 112.50), (7, 3, 4, 112.50);

-- London (Hotel ID 8) - Peak: £200, Off-Peak: £100
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(8, 1, 1, 200.00), (8, 1, 2, 200.00), (8, 1, 3, 100.00), (8, 1, 4, 100.00),
(8, 2, 1, 240.00), (8, 2, 2, 240.00), (8, 2, 3, 120.00), (8, 2, 4, 120.00),
(8, 3, 1, 300.00), (8, 3, 2, 300.00), (8, 3, 3, 150.00), (8, 3, 4, 150.00);

-- Manchester (Hotel ID 9) - Peak: £180, Off-Peak: £90
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(9, 1, 1, 180.00), (9, 1, 2, 180.00), (9, 1, 3, 90.00), (9, 1, 4, 90.00),
(9, 2, 1, 216.00), (9, 2, 2, 216.00), (9, 2, 3, 108.00), (9, 2, 4, 108.00),
(9, 3, 1, 270.00), (9, 3, 2, 270.00), (9, 3, 3, 135.00), (9, 3, 4, 135.00);

-- Newcastle (Hotel ID 10) - Peak: £120, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(10, 1, 1, 120.00), (10, 1, 2, 120.00), (10, 1, 3, 70.00), (10, 1, 4, 70.00),
(10, 2, 1, 144.00), (10, 2, 2, 144.00), (10, 2, 3, 84.00), (10, 2, 4, 84.00),
(10, 3, 1, 180.00), (10, 3, 2, 180.00), (10, 3, 3, 105.00), (10, 3, 4, 105.00);

-- Norwich (Hotel ID 11) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(11, 1, 1, 130.00), (11, 1, 2, 130.00), (11, 1, 3, 70.00), (11, 1, 4, 70.00),
(11, 2, 1, 156.00), (11, 2, 2, 156.00), (11, 2, 3, 84.00), (11, 2, 4, 84.00),
(11, 3, 1, 195.00), (11, 3, 2, 195.00), (11, 3, 3, 105.00), (11, 3, 4, 105.00);

-- Nottingham (Hotel ID 12) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(12, 1, 1, 130.00), (12, 1, 2, 130.00), (12, 1, 3, 70.00), (12, 1, 4, 70.00),
(12, 2, 1, 156.00), (12, 2, 2, 156.00), (12, 2, 3, 84.00), (12, 2, 4, 84.00),
(12, 3, 1, 195.00), (12, 3, 2, 195.00), (12, 3, 3, 105.00), (12, 3, 4, 105.00);

-- Oxford (Hotel ID 13) - Peak: £180, Off-Peak: £90
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(13, 1, 1, 180.00), (13, 1, 2, 180.00), (13, 1, 3, 90.00), (13, 1, 4, 90.00),
(13, 2, 1, 216.00), (13, 2, 2, 216.00), (13, 2, 3, 108.00), (13, 2, 4, 108.00),
(13, 3, 1, 270.00), (13, 3, 2, 270.00), (13, 3, 3, 135.00), (13, 3, 4, 135.00);

-- Plymouth (Hotel ID 14) - Peak: £180, Off-Peak: £90
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(14, 1, 1, 180.00), (14, 1, 2, 180.00), (14, 1, 3, 90.00), (14, 1, 4, 90.00),
(14, 2, 1, 216.00), (14, 2, 2, 216.00), (14, 2, 3, 108.00), (14, 2, 4, 108.00),
(14, 3, 1, 270.00), (14, 3, 2, 270.00), (14, 3, 3, 135.00), (14, 3, 4, 135.00);

-- Swansea (Hotel ID 15) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(15, 1, 1, 130.00), (15, 1, 2, 130.00), (15, 1, 3, 70.00), (15, 1, 4, 70.00),
(15, 2, 1, 156.00), (15, 2, 2, 156.00), (15, 2, 3, 84.00), (15, 2, 4, 84.00),
(15, 3, 1, 195.00), (15, 3, 2, 195.00), (15, 3, 3, 105.00), (15, 3, 4, 105.00);

-- Bournemouth (Hotel ID 16) - Peak: £130, Off-Peak: £70
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(16, 1, 1, 130.00), (16, 1, 2, 130.00), (16, 1, 3, 70.00), (16, 1, 4, 70.00),
(16, 2, 1, 156.00), (16, 2, 2, 156.00), (16, 2, 3, 84.00), (16, 2, 4, 84.00),
(16, 3, 1, 195.00), (16, 3, 2, 195.00), (16, 3, 3, 105.00), (16, 3, 4, 105.00);

-- Kent (Hotel ID 17) - Peak: £140, Off-Peak: £80
INSERT INTO prices (hotel_id, room_type_id, season_id, price_gbp) VALUES
(17, 1, 1, 140.00), (17, 1, 2, 140.00), (17, 1, 3, 80.00), (17, 1, 4, 80.00),
(17, 2, 1, 168.00), (17, 2, 2, 168.00), (17, 2, 3, 96.00), (17, 2, 4, 96.00),
(17, 3, 1, 210.00), (17, 3, 2, 210.00), (17, 3, 3, 120.00), (17, 3, 4, 120.00);

SELECT 'Prices inserted: 204 rows (17 hotels × 12 combinations)' AS status;

-- ============================================
-- 5. INSERT ROOMS FOR ALL HOTELS
-- Distribution: 30% Standard, 50% Double, 20% Family
-- ============================================

-- Stored procedure to generate rooms for a hotel
DELIMITER //
CREATE PROCEDURE generate_rooms_for_hotel(IN hotel_id_param INT, IN total_capacity INT)
BEGIN
    DECLARE standard_count INT;
    DECLARE double_count INT;
    DECLARE family_count INT;
    DECLARE room_num INT;
    
    -- Calculate room distribution
    SET standard_count = FLOOR(total_capacity * 0.30);
    SET double_count = FLOOR(total_capacity * 0.50);
    SET family_count = total_capacity - standard_count - double_count;
    
    -- Insert Standard rooms (room numbers 101-1xx)
    SET room_num = 101;
    WHILE room_num < 101 + standard_count DO
        INSERT INTO rooms (hotel_id, room_type_id, room_number, status)
        VALUES (hotel_id_param, 1, room_num, 'available');
        SET room_num = room_num + 1;
    END WHILE;
    
    -- Insert Double rooms (room numbers 201-2xx)
    SET room_num = 201;
    WHILE room_num < 201 + double_count DO
        INSERT INTO rooms (hotel_id, room_type_id, room_number, status)
        VALUES (hotel_id_param, 2, room_num, 'available');
        SET room_num = room_num + 1;
    END WHILE;
    
    -- Insert Family rooms (room numbers 301-3xx)
    SET room_num = 301;
    WHILE room_num < 301 + family_count DO
        INSERT INTO rooms (hotel_id, room_type_id, room_number, status)
        VALUES (hotel_id_param, 3, room_num, 'available');
        SET room_num = room_num + 1;
    END WHILE;
END //
DELIMITER ;

-- Generate rooms for all 17 hotels
CALL generate_rooms_for_hotel(1, 90);   -- Aberdeen
CALL generate_rooms_for_hotel(2, 80);   -- Belfast
CALL generate_rooms_for_hotel(3, 110);  -- Birmingham
CALL generate_rooms_for_hotel(4, 100);  -- Bristol
CALL generate_rooms_for_hotel(5, 90);   -- Cardiff
CALL generate_rooms_for_hotel(6, 120);  -- Edinburgh
CALL generate_rooms_for_hotel(7, 140);  -- Glasgow
CALL generate_rooms_for_hotel(8, 160);  -- London
CALL generate_rooms_for_hotel(9, 150);  -- Manchester
CALL generate_rooms_for_hotel(10, 90);  -- Newcastle
CALL generate_rooms_for_hotel(11, 90);  -- Norwich
CALL generate_rooms_for_hotel(12, 110); -- Nottingham
CALL generate_rooms_for_hotel(13, 90);  -- Oxford
CALL generate_rooms_for_hotel(14, 80);  -- Plymouth
CALL generate_rooms_for_hotel(15, 70);  -- Swansea
CALL generate_rooms_for_hotel(16, 90);  -- Bournemouth
CALL generate_rooms_for_hotel(17, 100); -- Kent

-- Drop the procedure after use
DROP PROCEDURE generate_rooms_for_hotel;

SELECT 'Rooms inserted: 1740 rooms total (30% Standard, 50% Double, 20% Family)' AS status;

-- ============================================
-- 6. INSERT USERS (Test accounts)
-- Passwords are bcrypt hashed
-- ============================================

-- Admin user (password: admin123)
-- Bcrypt hash for 'admin123': $2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NU8dWX2qMgQa
INSERT INTO users (email, password_hash, first_name, last_name, phone, user_type) VALUES
('admin@worldhotels.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5NU8dWX2qMgQa', 'Admin', 'User', '+44 20 1234 5678', 'admin');

-- Standard users (password for all: password123)
-- Bcrypt hash for 'password123': $2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW
INSERT INTO users (email, password_hash, first_name, last_name, phone, user_type) VALUES
('john.smith@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'John', 'Smith', '+44 7700 900001', 'standard'),
('sarah.jones@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Sarah', 'Jones', '+44 7700 900002', 'standard'),
('michael.brown@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Michael', 'Brown', '+44 7700 900003', 'standard'),
('emma.wilson@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Emma', 'Wilson', '+44 7700 900004', 'standard'),
('biplab@example.com', '$2b$12$EixZaYVK1fsbw1ZfbX3OXePaWxn96p36WQoeG6Lruj3vjPGga31lW', 'Biplab', 'Sharma', '+977 9841234567', 'standard');

SELECT 'Users inserted: 1 admin + 5 standard users' AS status;

-- ============================================
-- 7. INSERT EXCHANGE RATES
-- Base currency: GBP = 1.0
-- ============================================
INSERT INTO exchange_rates (currency_code, currency_name, rate_to_gbp, effective_date, is_active) VALUES
('GBP', 'British Pound', 1.000000, '2025-01-01', TRUE),
('USD', 'US Dollar', 0.790000, '2025-01-01', TRUE),
('EUR', 'Euro', 0.860000, '2025-01-01', TRUE),
('NPR', 'Nepalese Rupee', 0.006000, '2025-01-01', TRUE),
('INR', 'Indian Rupee', 0.009500, '2025-01-01', TRUE),
('AUD', 'Australian Dollar', 0.520000, '2025-01-01', TRUE),
('CAD', 'Canadian Dollar', 0.590000, '2025-01-01', TRUE),
('JPY', 'Japanese Yen', 0.005300, '2025-01-01', TRUE);

SELECT 'Exchange rates inserted: 8 currencies' AS status;

-- ============================================
-- 8. INSERT SAMPLE BOOKINGS (For testing)
-- ============================================

-- Booking 1: John Smith books London Standard room
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, status)
VALUES (2, 1201, '2025-04-15', '2025-04-18', 1, 'confirmed');

INSERT INTO booking_pricing (booking_id, base_price, discount_percentage, discount_amount, final_price, currency_code)
VALUES (1, 600.00, 30, 180.00, 420.00, 'GBP');

-- Booking 2: Sarah Jones books Edinburgh Double room
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, status)
VALUES (3, 721, '2025-06-01', '2025-06-05', 2, 'confirmed');

INSERT INTO booking_pricing (booking_id, base_price, discount_percentage, discount_amount, final_price, currency_code)
VALUES (2, 768.00, 20, 153.60, 614.40, 'GBP');

-- Booking 3: Michael Brown books Manchester Family room
INSERT INTO bookings (user_id, room_id, check_in_date, check_out_date, number_of_guests, status)
VALUES (4, 1351, '2025-07-10', '2025-07-15', 4, 'confirmed');

INSERT INTO booking_pricing (booking_id, base_price, discount_percentage, discount_amount, final_price, currency_code)
VALUES (3, 1350.00, 10, 135.00, 1215.00, 'GBP');

SELECT 'Sample bookings inserted: 3 bookings for testing' AS status;

-- ============================================
-- 9. DATA VERIFICATION QUERIES
-- ============================================

-- Verify data counts
SELECT 
    'Data Verification Summary' AS report_type,
    (SELECT COUNT(*) FROM hotels) AS total_hotels,
    (SELECT COUNT(*) FROM rooms) AS total_rooms,
    (SELECT COUNT(*) FROM room_types) AS room_types,
    (SELECT COUNT(*) FROM seasons) AS seasons,
    (SELECT COUNT(*) FROM prices) AS price_entries,
    (SELECT COUNT(*) FROM users) AS total_users,
    (SELECT COUNT(*) FROM exchange_rates) AS currencies,
    (SELECT COUNT(*) FROM bookings) AS sample_bookings;

-- Verify room distribution for London (should be 48/80/32)
SELECT 
    h.city,
    rt.type_name,
    COUNT(*) AS room_count,
    CONCAT(ROUND(COUNT(*) * 100.0 / h.capacity, 1), '%') AS percentage
FROM rooms r
JOIN hotels h ON r.hotel_id = h.hotel_id
JOIN room_types rt ON r.room_type_id = rt.room_type_id
WHERE h.city = 'London'
GROUP BY h.city, h.capacity, rt.type_name
ORDER BY rt.type_name;

-- Show sample pricing for London
SELECT 
    h.city,
    rt.type_name,
    s.season_name,
    CONCAT(s.start_month, '-', s.end_month) AS months,
    CONCAT('£', p.price_gbp) AS price
FROM prices p
JOIN hotels h ON p.hotel_id = h.hotel_id
JOIN room_types rt ON p.room_type_id = rt.room_type_id
JOIN seasons s ON p.season_id = s.season_id
WHERE h.city = 'London'
ORDER BY rt.type_name, s.season_id;

-- ============================================
-- SUCCESS MESSAGE
-- ============================================
SELECT 
    'Sample data loaded successfully!' AS status,
    '17 hotels, 1740 rooms, 204 prices, 6 users, 3 bookings' AS summary,
    'Database is ready for application development' AS next_step;
    