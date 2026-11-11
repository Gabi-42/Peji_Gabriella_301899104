-- Check the Room 102 currently has no active reservations
SELECT reservation_id, room_id, status 
FROM reservation 
WHERE room_id = 5;

-- Customize primary command line prompt
\set PROMPT1 'Session A%x%R%# '

-- insert active reservation for Room 102
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status)
VALUES (6, 5, '2026-07-01', '2026-07-05', NULL, 'active');
-- STOP. Leave this transaction open. move to the second terminal now.

-- Commit first transaction to permanently save reservation for Room 102
COMMIT;
-- Switch to Session B: its INSERT should now fail