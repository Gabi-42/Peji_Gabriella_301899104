-- ConstraintTests.sql
-- Deliberately invalid INSERT statements to test constraints.
-- Ran separately outside a transaction block so one error does not stop the next test.

-- Test 1: Expected error - NOT NULL violation (missing full_name)
INSERT INTO guest (guest_number, full_name, email) 
VALUES ('G999', NULL, 'noname@example.com');

-- Test 2: Expected error - UNIQUE constraint violation (duplicate email)
INSERT INTO guest (guest_number, full_name, email) 
VALUES ('G998', 'Charlie Brown', 'alice@example.com');

-- Test 3: Expected error - Foreign Key violation (non-existent category_id)
INSERT INTO room (category_id, room_number) 
VALUES (99999, '999');

-- Test 4: Expected error - Check constraint chk_dates violation (check_out before check_in)
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G001'),
    (SELECT room_id FROM room WHERE room_number = '201'),
    '10-07-2026', '05-07-2026', NULL, 'active'
);

-- Test 5: Expected error - Check constraint chk_departure violation (departure before check_in)
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G001'),
    (SELECT room_id FROM room WHERE room_number = '201'),
    '10-07-2026', '12-07-2026', '08-07-2026', 'completed'
);

-- Test 6: Expected error - Conditional Unique Index violation (Room 101 already has an 'active' reservation)
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G002'),
    (SELECT room_id FROM room WHERE room_number = '101'),
    '10-06-2026', '12-06-2026', NULL, 'active'
);

-- Verification query to check row counts after all invalid inserts fail
SELECT 
    (SELECT COUNT(*) FROM guest) AS guest_count,
    (SELECT COUNT(*) FROM room_category) AS category_count,
    (SELECT COUNT(*) FROM room) AS room_count,
    (SELECT COUNT(*) FROM reservation) AS reservation_count;

/* 
Expected counts after all invalid inserts fail:
- guest_count: 2
- category_count: 2
- room_count: 3
- reservation_count: 3
*/