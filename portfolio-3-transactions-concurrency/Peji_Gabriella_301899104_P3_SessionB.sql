-- Customize primary command line prompt
\pset pager off
\set PROMPT1 'Session B%x%R%# '
-- Insert a conflicting active reservation for the same room
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
BEGIN;

INSERT INTO reservation (guest_id, room_id, check_in_date, check_out_date, actual_departure, status)
VALUES (5, 5, '2026-07-03', '2026-07-07', NULL, 'active');
-- Expected: 0. Session A's new reservation is not committed yet.
-- WAIT here. Switch to Session A  and COMMIT.
-- Expected error output after COMMIT in Session A

ROLLBACK;

--Query to verify only Session A's booking was committed and Session B's conflicting booking was rejected
SELECT reservation_id, guest_id, room_id, check_in_date, status 
FROM reservation 
WHERE room_id = 5 
ORDER BY reservation_id;