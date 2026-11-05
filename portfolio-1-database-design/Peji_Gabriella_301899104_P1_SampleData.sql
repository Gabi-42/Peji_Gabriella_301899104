-- SampleData.sql
-- A small, valid dataset representing hotel records across different states,
-- wrapped in a transaction block.

BEGIN;

-- 1. Insert sample guests using fictional names and example.com emails
INSERT INTO guest (guest_number, full_name, email) 
VALUES 
    ('G001', 'Alice Smith', 'alice@example.com'),
    ('G002', 'Bob Jones', 'bob@example.com');

-- 2. Insert room categories
INSERT INTO room_category (category_code, category_name) 
VALUES 
    ('SKG', 'Standard King'),
    ('DSU', 'Deluxe Suite');

-- 3. Insert physical rooms, looking up category IDs
INSERT INTO room (category_id, room_number) 
VALUES 
    ((SELECT category_id FROM room_category WHERE category_code = 'SKG'), '101'),
    ((SELECT category_id FROM room_category WHERE category_code = 'SKG'), '102'),
    ((SELECT category_id FROM room_category WHERE category_code = 'DSU'), '201');

-- 4. Insert reservations representing different states (active, completed, cancelled)
-- Active reservation for Alice in Room 101
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G001'),
    (SELECT room_id FROM room WHERE room_number = '101'),
    '01-06-2026', '05-06-2026', NULL, 'active'
);

-- Completed stay for Bob in Room 102 (has actual departure date)
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G002'),
    (SELECT room_id FROM room WHERE room_number = '102'),
    '02-06-2026', '04-06-2026', '04-06-2026', 'completed'
);

-- Cancelled reservation for Alice in Room 201
INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status) 
VALUES (
    (SELECT guest_id FROM guest WHERE guest_number = 'G001'),
    (SELECT room_id FROM room WHERE room_number = '201'),
    '10-06-2026', '12-06-2026', NULL, 'cancelled'
);

COMMIT;