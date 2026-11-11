-- Start from the Portfolio 1 sample data. Run the sections in order, once.
-- Commit a valid status change for reservation_id 6 (Bob Jones' cancelled reservation)
BEGIN;
UPDATE reservation 
SET status = 'active' 
WHERE reservation_id = 6 AND status = 'cancelled';
COMMIT;

-- Repeat check to demonstrate idempotency, Expected: UPDATE 0, not a new status change
UPDATE reservation 
SET status = 'active' 
WHERE reservation_id = 6 AND status = 'cancelled';

-- Begin another transaction to demonstrate rollback behavior
BEGIN;
-- Valid change: Update Bob Jones' name
UPDATE guest SET full_name = 'Robert Jones' WHERE guest_id = 6;

-- Deliberate violation: Try to update Bob's email to match Alice's existing email ('alice@example.com')
UPDATE guest SET email = 'alice@example.com' WHERE guest_id = 6;
ROLLBACK;

-- Check that the committed status change persisted
SELECT reservation_id, status FROM reservation WHERE reservation_id = 6;

-- Check that the valid name change from the rolled-back transaction was discarded
SELECT guest_id, full_name, email FROM guest WHERE guest_id = 6;