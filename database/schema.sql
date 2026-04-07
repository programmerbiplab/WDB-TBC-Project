-- ============================================
-- World Hotels Booking System - Database Schema
-- Student: Biplab Prasad Gajurel
-- Date: January 11, 2025
-- Database: MySQL 8.x
-- Normalization: 3NF
-- ============================================

DROP DATABASE IF EXISTS world_hotels_db;

-- Create database
CREATE DATABASE world_hotels_db;
USE world_hotels_db;

-- ============================================
-- TABLE 1: users
-- Stores all user accounts (customers and admins)
-- ============================================
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL COMMENT 'Bcrypt hashed password',
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    phone VARCHAR(20),
    user_type ENUM('standard', 'admin') DEFAULT 'standard',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_email (email),
    INDEX idx_user_type (user_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='User accounts - customers and admins';

-- ============================================
-- TABLE 2: hotels
-- Stores information about 17 UK hotels
-- ============================================
CREATE TABLE hotels (
    hotel_id INT AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(100) NOT NULL COMMENT 'One of 17 UK cities',
    capacity INT NOT NULL COMMENT 'Total number of rooms',
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_city (city)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Hotel information for 17 UK cities';

-- ============================================
-- TABLE 3: room_types
-- Defines the 3 room types with their properties
-- ============================================
CREATE TABLE room_types (
    room_type_id INT AUTO_INCREMENT PRIMARY KEY,
    type_name VARCHAR(50) NOT NULL COMMENT 'Standard, Double, or Family',
    max_guests INT NOT NULL COMMENT '1, 2, or 4 guests maximum',
    price_multiplier DECIMAL(3,2) NOT NULL COMMENT '1.0, 1.2, or 1.5',
    has_wifi BOOLEAN DEFAULT TRUE,
    has_minibar BOOLEAN DEFAULT TRUE,
    has_tv BOOLEAN DEFAULT TRUE,
    includes_breakfast BOOLEAN DEFAULT TRUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Room type definitions with features';

-- ============================================
-- TABLE 4: rooms
-- Individual rooms in each hotel
-- Distribution: 30% Standard, 50% Double, 20% Family
-- ============================================
CREATE TABLE rooms (
    room_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_type_id INT NOT NULL,
    room_number VARCHAR(10) NOT NULL COMMENT 'Room number within hotel',
    status ENUM('available', 'booked', 'maintenance') DEFAULT 'available',
    
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_hotel_room (hotel_id, room_type_id),
    INDEX idx_status (status),
    UNIQUE KEY unique_hotel_room (hotel_id, room_number)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Individual rooms - 30% Standard, 50% Double, 20% Family';

-- ============================================
-- TABLE 5: seasons
-- Peak and Off-Peak season definitions
-- ============================================
CREATE TABLE seasons (
    season_id INT AUTO_INCREMENT PRIMARY KEY,
    season_name VARCHAR(20) NOT NULL COMMENT 'Peak or Off-Peak',
    start_month INT NOT NULL COMMENT 'Starting month (1-12)',
    end_month INT NOT NULL COMMENT 'Ending month (1-12)',
    
    CHECK (start_month >= 1 AND start_month <= 12),
    CHECK (end_month >= 1 AND end_month <= 12)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Season definitions: Peak (Apr-Aug, Nov-Dec), Off-Peak (Jan-Mar, Sep-Oct)';

-- ============================================
-- TABLE 6: prices
-- Pricing for each hotel + room type + season combination
-- 12 rows per hotel (4 seasons × 3 room types)
-- ============================================
CREATE TABLE prices (
    price_id INT AUTO_INCREMENT PRIMARY KEY,
    hotel_id INT NOT NULL,
    room_type_id INT NOT NULL,
    season_id INT NOT NULL,
    price_gbp DECIMAL(10,2) NOT NULL COMMENT 'Base price in GBP',
    
    FOREIGN KEY (hotel_id) REFERENCES hotels(hotel_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_type_id) REFERENCES room_types(room_type_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (season_id) REFERENCES seasons(season_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    UNIQUE KEY unique_price (hotel_id, room_type_id, season_id),
    INDEX idx_hotel_pricing (hotel_id, room_type_id, season_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Pricing matrix: hotel × room_type × season';

-- ============================================
-- TABLE 7: bookings
-- Customer bookings
-- Max 30 days stay, up to 90 days advance booking
-- ============================================
CREATE TABLE bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    room_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    number_of_guests INT NOT NULL COMMENT 'Up to room type max_guests',
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('confirmed', 'cancelled', 'completed') DEFAULT 'confirmed',
    
    FOREIGN KEY (user_id) REFERENCES users(user_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (room_id) REFERENCES rooms(room_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    
    INDEX idx_user_bookings (user_id),
    INDEX idx_room_bookings (room_id),
    INDEX idx_check_in (check_in_date),
    INDEX idx_status (status),
    
    CHECK (check_out_date > check_in_date),
    CHECK (DATEDIFF(check_out_date, check_in_date) <= 30),
    CHECK (number_of_guests >= 1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Customer bookings - max 30 days, 90 days advance';

-- ============================================
-- TABLE 8: booking_pricing
-- Pricing details for each booking (one-to-one with bookings)
-- Stores snapshot for audit trail
-- ============================================
CREATE TABLE booking_pricing (
    pricing_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT UNIQUE NOT NULL,
    base_price DECIMAL(10,2) NOT NULL COMMENT 'Price from prices table × nights',
    discount_percentage INT DEFAULT 0 COMMENT '0, 10, 20, or 30% based on advance days',
    discount_amount DECIMAL(10,2) DEFAULT 0.00,
    final_price DECIMAL(10,2) NOT NULL COMMENT 'base_price - discount_amount',
    cancellation_charge DECIMAL(10,2) DEFAULT 0.00 COMMENT '0%, 50%, or 100% of final_price',
    currency_code VARCHAR(3) DEFAULT 'GBP',
    
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    
    CHECK (discount_percentage IN (0, 10, 20, 30)),
    CHECK (discount_amount >= 0),
    CHECK (final_price >= 0),
    CHECK (cancellation_charge >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Booking pricing snapshot - one-to-one with bookings';

-- ============================================
-- TABLE 9: exchange_rates
-- Currency exchange rates to GBP
-- ============================================
CREATE TABLE exchange_rates (
    rate_id INT AUTO_INCREMENT PRIMARY KEY,
    currency_code VARCHAR(3) UNIQUE NOT NULL COMMENT 'ISO 4217: GBP, USD, EUR, NPR, etc.',
    currency_name VARCHAR(50) NOT NULL,
    rate_to_gbp DECIMAL(10,6) NOT NULL COMMENT 'Exchange rate to GBP (GBP = 1.0)',
    effective_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    
    INDEX idx_currency (currency_code),
    INDEX idx_active (is_active),
    
    CHECK (rate_to_gbp > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='Currency exchange rates - base currency GBP';

-- ============================================
-- VIEWS FOR COMMON QUERIES
-- ============================================

-- View: Available rooms with pricing
CREATE VIEW available_rooms_with_pricing AS
SELECT 
    r.room_id,
    r.room_number,
    h.hotel_id,
    h.city,
    h.address,
    rt.type_name AS room_type,
    rt.max_guests,
    p.price_gbp,
    s.season_name,
    r.status
FROM rooms r
JOIN hotels h ON r.hotel_id = h.hotel_id
JOIN room_types rt ON r.room_type_id = rt.room_type_id
JOIN prices p ON p.hotel_id = h.hotel_id AND p.room_type_id = rt.room_type_id
JOIN seasons s ON p.season_id = s.season_id
WHERE r.status = 'available';

-- View: Booking summary with user and hotel details
CREATE VIEW booking_summary AS
SELECT 
    b.booking_id,
    u.first_name,
    u.last_name,
    u.email,
    h.city AS hotel_city,
    rt.type_name AS room_type,
    r.room_number,
    b.check_in_date,
    b.check_out_date,
    DATEDIFF(b.check_out_date, b.check_in_date) AS nights,
    b.number_of_guests,
    bp.final_price,
    b.status,
    b.booking_date
FROM bookings b
JOIN users u ON b.user_id = u.user_id
JOIN rooms r ON b.room_id = r.room_id
JOIN hotels h ON r.hotel_id = h.hotel_id
JOIN room_types rt ON r.room_type_id = rt.room_type_id
JOIN booking_pricing bp ON b.booking_id = bp.booking_id;

-- ============================================
-- SUCCESS MESSAGE
-- ============================================
SELECT 'Database schema created successfully! 9 tables + 2 views created.' AS message;
SELECT 'Next: Run sample_data.sql to populate with test data.' AS next_step;