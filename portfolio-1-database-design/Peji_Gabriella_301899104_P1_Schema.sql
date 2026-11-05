BEGIN;

-- Table for registered hotel guests
CREATE TABLE guest (
    guest_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    guest_number VARCHAR(30) UNIQUE NOT NULL,
    full_name VARCHAR(120) NOT NULL,
    email VARCHAR(254) UNIQUE NOT NULL
);

-- Table for room categories (e.g., Standard King, Deluxe Suite)
CREATE TABLE room_category (
    category_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_code VARCHAR(20) UNIQUE NOT NULL,
    category_name VARCHAR(100) NOT NULL
);

-- Table for physical rooms belonging to a category
CREATE TABLE room (
    room_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id BIGINT NOT NULL REFERENCES room_category(category_id),
    room_number VARCHAR(20) UNIQUE NOT NULL
);

-- Table for guest reservations and stays
CREATE TABLE reservation (
    reservation_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    guest_id BIGINT NOT NULL REFERENCES guest(guest_id),
    room_id BIGINT NOT NULL REFERENCES room(room_id),
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    actual_departure DATE,
    status VARCHAR(20) NOT NULL,
    CONSTRAINT chk_dates CHECK (check_out_date > check_in_date),
    CONSTRAINT chk_departure CHECK (actual_departure IS NULL OR actual_departure >= check_in_date)
);

-- Ensure a physical room has at most one active stay at a time (Rule 4)
CREATE UNIQUE INDEX idx_room_active_stay 
ON reservation (room_id) 
WHERE status = 'active';

-- Note: Rule 8 (preventing edits to finalised or cancelled reservations) 
-- and complex date-overlap validation require application-level transaction 
-- logic and cannot be fully enforced by table definitions alone.