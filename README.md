# hotel-booking-sql-qa
# Hotel Booking System — SQL QA Validation Project

A database validation project simulating real-world QA testing on a hotel booking system.  
Validates data integrity, business rules, and referential constraints using SQL test cases.

## Tools Used
- MySQL 8.0
- SQL (DDL + DML + DQL)
- Manual test case design

## Database Schema

| Table | Description |
|---|---|
| `guests` | Guest master data |
| `rooms` | Room inventory and pricing |
| `bookings` | Booking transactions with status |

## Test Cases — 8 SQL Validations

| TC ID | Test Description | Type | Expected Result |
|---|---|---|---|
| TC_001 | Checkin date must be before checkout date | Date logic | 0 rows (FAIL = bug) |
| TC_002 | Total amount must never be zero or negative | Amount validation | 0 rows |
| TC_003 | Booking status must be valid enum value | Data integrity | 0 rows |
| TC_004 | No duplicate guest emails | Uniqueness check | 0 rows |
| TC_005 | Billing amount matches room price × nights | Calculation check | 0 rows |
| TC_006 | No overlapping confirmed bookings for same room | Business rule | 0 rows |
| TC_007 | Every booking linked to a valid guest | Referential integrity | 0 rows |
| TC_008 | Room type must be Single, Double, or Suite | Master data check | 0 rows |

## Bugs Found (Intentional Test Data)

| Bug | Query | Description |
|---|---|---|
| BUG-001 | TC_001 | Booking #3 has checkin date after checkout date |
| BUG-002 | TC_002 | Booking #6 has total_amount = 0.00 |
| BUG-003 | TC_003 | Booking #5 has status = 'InvalidStatus' |

## How to Run

```sql
-- Step 1: Setup
mysql -u root -p < schema.sql

-- Step 2: Run validations
mysql -u root -p hotel_booking_db < test_queries.sql
```

## Key Learnings
- Designed SQL test cases to validate business logic, not just data presence
- Identified 3 intentional data bugs using WHERE-based negative test queries
- Applied JOIN-based validation for referential integrity and billing accuracy
