-- =============================================
-- Hotel Booking System — Test Database Schema
-- =============================================
CREATE DATABASE IF NOT EXISTS hotel_booking_db;
DROP TABLE IF EXISTS `BOOKING`;
TRUNCATE TABLE `booking`;
USE hotel_booking_db;
CREATE TABLE IF NOT EXISTS guest (
    guest_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15),
    created_at DATE NOT NULL
);
CREATE TABLE IF NOT EXISTS room (
    room_id INT PRIMARY KEY AUTO_INCREMENT,
    room_number VARCHAR(10) UNIQUE NOT NULL,
    room_type VARCHAR(20) NOT NULL,  -- Single, Double, Suite
    price_per_night DECIMAL(8,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE
);

CREATE TABLE IF NOT EXISTS booking (
    booking_id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    checkin_date DATE NOT NULL,
    checkout_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) DEFAULT 'Confirmed', -- Confirmed, Cancelled, Completed
    FOREIGN KEY (guest_id) REFERENCES guests(guest_id),
    FOREIGN KEY (room_id) REFERENCES rooms(room_id)
);

-- =============================================
-- Sample Test Data
-- =============================================
INSERT INTO guests 
(first_name, last_name, email, phone, created_at) 
VALUES 
('Papu',   'Shh',    'prati@email.com', '9876543410', '2024-02-10'),
('Riyaa',   'Mehta',  'riya_78@email.com',  '9876543211', '2024-02-15'),
('Arjun',  'Patel',  'arjun90@email.com', '9876543212', '2024-03-01'),
('Sneha',  'Joshi',  'snehaa1@email.com', NULL,         '2024-03-10'),
('Vikram', 'Nair',   'vikram34@email.com','9876543214', '2024-04-05');


INSERT INTO rooms VALUES
(1, '101', 'Single', 1500.00, TRUE),
(2, '102', 'Double', 2500.00, TRUE),
(3, '201', 'Suite',  5000.00, FALSE),
(4, '202', 'Double', 2500.00, TRUE),
(5, '301', 'Single', 1500.00, TRUE);

INSERT INTO bookings VALUES
(1, 1, 2, '2024-05-01', '2024-05-04', 7500.00,  'Confirmed'),
(2, 2, 3, '2024-05-10', '2024-05-12', 10000.00, 'Completed'),
(3, 3, 1, '2024-05-15', '2024-05-10', 7500.00,  'Confirmed'),  -- BUG: checkin > checkout
(4, 4, 4, '2024-06-01', '2024-06-03', 5000.00,  'Confirmed'),
(5, 5, 2, '2024-06-10', '2024-06-12', 9999.00,  'InvalidStatus'), -- BUG: wrong status
(6, 1, 1, '2024-07-01', '2024-07-03', 0.00,     'Confirmed');  -- BUG: zero amount