# Hotel Reservation System Normalisation
Normalisation separates information into related tables to reduce repeated details and avoid inconsistent updates. The same bookings are used below. Only the fields needed to explain the changes are shown; the full design keeps the other fields from the design document.

Names and emails are fictional. Dates are shortened for readability.
## Starting booking list
| guest_id | full_name | email | Bookings |
| --- | --- | --- | --- |
| 1 | Tayo Osamor |Tayo@sampleemail.com | Room 101, Standard King, Check-in: 01-05-2026, Check-out: 05-05-2026; Room 101, Standard King, Check-in: 15-05-2026, Check-out: 20-05-2026 |
| 2 | Ella Samuel | ella@sampleemail.com | Room 102, Deluxe Queen, Check-in: 10-05-2026, Check-out: 12-05-2026 |

The first row contains two bookings in one cell. Finding a specific booking or updating room details can be awkward.
## 1NF: One value per cell
Each booking get its own row. The repeated list is removed.

| room_number | check_in_date | guest_id | full _name |
| --- | --- | --- | --- |
| 101 | 01-05-2026 | 1 | Tayo Osamor |
| 101 | 15-05-2026 | 1 | Tayo Osamor |
| 102 | 10-05-2026 | 2 | Ella Samuel |

For this example, the key is (room_number, check_in_date). Both values together identify one booking, assuming a room cannot have two active check-ins at the exact same instant. room_number alone is not enough because Room 101 appears twice.

The rows are in 1NF, but room category details and guest details are repeated across multiple rows.

## 2NF: Details depend on the whole key
2NF includes 1NF. A non-key field must not depend on only part of a combined key.

Here, room_number alone determines category_name. That detail describes the physical room, regardless of when it is booked. It moves into a separate table.

### Room details
Key: room_number.

| room_number | category_name |
| --- | --- |
| 101 | Standard King |
| 102 | Deluxe Queen |

### Reservation details
key: room_number, check_in_date. room_number links to Room details.

| room_number | check_in_date | guest_id | full_name |
| --- | --- | --- | --- |
| 101 | 01-05-2026 | 1 | Tayo Osamor |
| 101 | 15-05-2026 | 1 | Tayo Osamor |
| 102 | 10-05-2026 | 2 | Ella Samuel |

The category details no longer repeat for every reservation of a room. However, category classification details and guest details still repeat across multiple bookings.

## 3NF: Keep details with the thing they describe
3NF includes 2NF. Non-key fields must not depend on another non-key field. Two remaining splits explain the next level:

- Category attributes depend on the category classification, not directly on the physical room alone.
- full_name and email depend on guest_id, describing the guest rather than the reservation.

Splitting these results in the four final tables:

#### guest
Key: guest_id.
| guest_id | full_name | email |
| --- | --- | --- |
| 1 | Tayo Osamor | tayo@sampleemail.com |
| 2 | Ella Samuel | ella@sampleemail.com |

#### room_category
Key: category_id
| category_id | category_code | category_name |
| --- | --- | --- |
| 1 | SKG | Standard King |
| 2 | DQ | Deluxe Queen |

#### room
Key: room_id. category_id is a foreign key to room_category.
| room_id | category_id | room_number |
| --- | --- | --- |
| 1 | 1 | 101 |
| 2 | 2 | 102 |

#### reservation 
The final design uses an automatically generated reservation_id as its primary key, rather than relying on a room number and date combination to identify a booking. guest_id and room_id are foreign keys. Adding an ID is a design choice to simplify referencing, not what makes a table 3NF.
| reservation_id | guest_id | room_id | check_in_date |
| --- | --- | --- | --- |
| 1 | 1 | 1 | 01-05-2026 |
| 2 | 1 | 1 | 15-05-2026 |
| 3 | 2 | 2 | 10-05-2026 |

Now guest contact details are stored once in guest, and category titles are stored once in room_category. The IDs preserve the links so the booking details can be brought together when queried. Unique values, foreign key constraints, date checks, and active-stay rules remain necessary; normalisation does not enforce those rules by itself.

Note: The complete schema includes fields like actual_departure and status from the full design but those were left out of these summary examples for readability.