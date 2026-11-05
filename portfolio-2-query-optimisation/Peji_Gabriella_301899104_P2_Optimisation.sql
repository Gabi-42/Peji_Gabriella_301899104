-- Create a separate benchmark schema to keep Portfolio 1 tables unchanged
CREATE SCHEMA IF NOT EXISTS p2_benchmark;

-- Create a synthetic reservation history table and populate it with 100,000 rows
CREATE TABLE p2_benchmark.reservation_history AS
SELECT 
    ROW_NUMBER() OVER () AS reservation_id,
    (random() * 999 + 1)::BIGINT AS guest_id,
    (random() * 199 + 1)::BIGINT AS room_id,
    '2025-01-01'::DATE + (random() * 730)::INTEGER AS check_in_date,
    '2025-01-01'::DATE + (random() * 730)::INTEGER + (1 + random() * 5)::INTEGER AS check_out_date,
    CASE WHEN random() < 0.3 THEN NULL ELSE '2025-01-01'::DATE + (random() * 730)::INTEGER + 2 END AS actual_departure,
    CASE (random() * 2)::INTEGER 
        WHEN 0 THEN 'active' 
        WHEN 1 THEN 'completed' 
        ELSE 'cancelled' 
    END AS status
FROM generate_series(1, 100000);

-- Refresh table statistics so the query planner makes informed decisions
ANALYZE p2_benchmark.reservation_history;

-- Verify the total row count
SELECT COUNT(*) AS total_rows FROM p2_benchmark.reservation_history;

-- Baseline execution plan before creating an index (Sequential Scan)
EXPLAIN (ANALYZE, BUFFERS)
SELECT reservation_id, guest_id, room_id, check_in_date, status
FROM p2_benchmark.reservation_history
WHERE check_in_date >= '2026-03-01' AND check_in_date <= '2026-03-31';

-- Create a B-tree index on check_in_date to optimize date filtering
CREATE INDEX idx_reservation_history_check_in 
ON p2_benchmark.reservation_history (check_in_date);

-- Refresh statistics after adding the index
ANALYZE p2_benchmark.reservation_history;

-- Optimized execution plan after creating the index (Index Scan or Bitmap Index Scan)
EXPLAIN (ANALYZE, BUFFERS)
SELECT reservation_id, guest_id, room_id, check_in_date, status
FROM p2_benchmark.reservation_history
WHERE check_in_date >= '2026-03-01' AND check_in_date <= '2026-03-31';

