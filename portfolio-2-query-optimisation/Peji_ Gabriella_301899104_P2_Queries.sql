-- Query 1: List active reservations with guest names and room details
-- This query joins the reservation table with guest, room, and room category tables to retrieve and display detailed information for all currently active bookings.
SELECT 
    g.full_name,
    r.room_number,
    rc.category_name,
    res.check_in_date,
    res.check_out_date
FROM reservation res
JOIN guest g ON res.guest_id = g.guest_id
JOIN room r ON res.room_id = r.room_id
JOIN room_category rc ON r.category_id = rc.category_id
WHERE res.status = 'active'
ORDER BY res.check_in_date, r.room_number;

-- Query 2: Find rooms that do not currently have an active reservation
-- This query identifies all physical rooms that are not currently booked by checking for the absence of active reservations. It joins the room and room category tables to provide additional context about each available room.
SELECT 
    r.room_number,
    rc.category_name
FROM room r
JOIN room_category rc ON r.category_id = rc.category_id
WHERE NOT EXISTS (
    SELECT 1 
    FROM reservation res 
    WHERE res.room_id = r.room_id 
      AND res.status = 'active'
)
ORDER BY r.room_number;

-- Query 3: Count physical rooms per category, retaining categories with zero rooms using LEFT JOIN
-- This query uses a LEFT JOIN from room categories to physical rooms to calculate the total number of rooms in each category, ensuring any category with zero rooms would still appear in the output.
SELECT 
    rc.category_code,
    rc.category_name,
    COUNT(r.room_id) AS room_count
FROM room_category rc
LEFT JOIN room r ON rc.category_id = r.category_id
GROUP BY rc.category_id, rc.category_code, rc.category_name
ORDER BY rc.category_code;