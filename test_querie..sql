-- =============================================
-- Hotel Booking DB — QA Validation Queries
-- =============================================
-- Each query = one test case
-- Expected: 0 rows = PASS | Any rows = FAIL (bug found)
-- =============================================

USE hotel_booking_db;

-- TC_001: Checkin date should always be before checkout date
-- Expected: 0 rows | If rows returned = data integrity bug
SELECT booking_id, guest_id, checkin_date, checkout_date
FROM bookings
WHERE checkin_date >= checkout_date;

-- TC_002: Total amount should never be zero or negative
-- Expected: 0 rows | If rows returned = calculation bug
SELECT booking_id, total_amount
FROM bookings
WHERE total_amount <= 0;

-- TC_003: Booking status must only be Confirmed, Cancelled, or Completed
-- Expected: 0 rows | If rows returned = invalid data inserted
SELECT booking_id, status
FROM bookings
WHERE status NOT IN ('Confirmed', 'Cancelled', 'Completed');

-- TC_004: No guest should have duplicate email addresses
-- Expected: 0 rows | If rows returned = unique constraint violation
SELECT email, COUNT(*) AS count
FROM guests
GROUP BY email
HAVING COUNT(*) > 1;

-- TC_005: Total amount must match room price x number of nights
-- Expected: 0 rows | If rows returned = billing calculation bug
SELECT
    b.booking_id,
    b.total_amount AS billed_amount,
    (r.price_per_night * DATEDIFF(b.checkout_date, b.checkin_date)) AS expected_amount
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
WHERE b.total_amount <>
    (r.price_per_night * DATEDIFF(b.checkout_date, b.checkin_date))
AND b.checkin_date < b.checkout_date;

-- TC_006: A room cannot have two confirmed bookings with overlapping dates
-- Expected: 0 rows | If rows returned = double booking bug
SELECT
    a.booking_id AS booking1,
    b.booking_id AS booking2,
    a.room_id,
    a.checkin_date, a.checkout_date
FROM bookings a
JOIN bookings b
    ON a.room_id = b.room_id
    AND a.booking_id < b.booking_id
    AND a.status = 'Confirmed'
    AND b.status = 'Confirmed'
    AND a.checkin_date < b.checkout_date
    AND a.checkout_date > b.checkin_date;

-- TC_007: Every booking must belong to a valid existing guest
-- Expected: 0 rows | If rows returned = orphan record / FK violation
SELECT b.booking_id, b.guest_id
FROM bookings b
LEFT JOIN guests g ON b.guest_id = g.guest_id
WHERE g.guest_id IS NULL;

-- TC_008: Room type must only be Single, Double, or Suite
-- Expected: 0 rows | If rows returned = invalid master data
SELECT room_id, room_type
FROM rooms
WHERE room_type NOT IN ('Single', 'Double', 'Suite');

-- =============================================
-- REPORTING QUERIES (for README screenshots)
-- =============================================

-- Summary: Total bookings by status
SELECT status, COUNT(*) AS total_bookings
FROM bookings
GROUP BY status;

-- Summary: Revenue by room type
SELECT
    r.room_type,
    COUNT(b.booking_id) AS total_bookings,
    SUM(b.total_amount) AS total_revenue
FROM bookings b
JOIN rooms r ON b.room_id = r.room_id
WHERE b.status != 'Cancelled'
GROUP BY r.room_type
ORDER BY total_revenue DESC;