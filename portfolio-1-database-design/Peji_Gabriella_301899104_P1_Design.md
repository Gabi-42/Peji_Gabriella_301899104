# Hotel Reservation System Database Design

## Entities
I chose four entities for my hotel reservation system:
| Entity | Information stored |
| --- | --- |
| `guest` | A registered customer who makes bookings and stays at the hotel |
| `room_category` | A catalogue classification of accommodation types, such as Standard King or Deluxe Suite |
| `room` | One physical room located in the hotel building |
| `reservation` | A booking record linking a guest to a specific physical room for a given date range |

I kept room category and physical room separate. For example, the hotel may have twelve rooms in the Standard King category. I record the category details once, give each physical room its own unique room number, and use the reservation to record which room a guest occupies.

## Attributes and keys
I use an automatically generated ID for each record. Unique means no repeated values. Required means the value cannot be NULL.
| Entity | Attributes and proposed PostgreSQL types | Keys and required values |
| --- | --- | --- |
| `guest` | `guest_id` BIGINT; `guest_number` VARCHAR(30); `full_name` VARCHAR(120); `email` VARCHAR(254) | PK: `guest_id`. Unique: `guest_number` and `email` separately. All required. |
| `room_category` | `category_id` BIGINT; `category_code` VARCHAR(20); `category_name` VARCHAR(100) | PK: `category_id`. Unique: `category_code`. All required. |
| `room` | `room_id` BIGINT; `category_id` BIGINT; `room_number` VARCHAR(20) | PK: `room_id`. FK: `category_id` → `room_category.category_id`. Unique: `room_number`. All required. |
| `reservation` | `reservation_id` BIGINT; `guest_id` BIGINT; `room_id` BIGINT; `check_in_date` DATE; `check_out_date` DATE; `actual_departure` DATE; `status` VARCHAR(20)	| PK: `reservation_id`. FKs: `guest_id` → `guest.guest_id`; `room_id` → `room.room_id`. All required except `actual_departure` |

BIGINT holds whole numbers. VARCHAR holds text up to a specified character limit. DATE stores calendar dates. I leave actual_departure empty until the guest checks out.

## Relationships
| Tables linked | Relationship | Meaning |
| --- | --- | --- |
| `room_category` → `room` | |One to many | A room category can have one or more physical rooms; each physical room belongs to exactly one room category. |
| `guest` → `reservation` | One to many | A guest can have zero or more reservations; each reservation belongs to exactly one guest. |
| `room` → `reservation` | One to many over time | A physical room can have zero or more historical reservations; each reservation refers to exactly one physical room. |

For example, Room 101 can be booked in June and again in July. I keep both reservation records, but only one active booking can occupy the room at a time. A foreign key links the records; it does not stop overlapping booking dates by itself.

## Business rules and constraints
- Rules 1 and 2: Guest numbers, emails, and room numbers are unique.

- Rules 2 and 3: Required foreign keys link each physical room to an existing room category, and each reservation to an existing guest and room.

- Rule 4: Each physical room can have at most one active stay at a time. The database design uses transaction logic or exclusion constraints to prevent overlapping active reservations for the same room.

- Rule 5: guest_id can repeat in reservation, allowing a guest to hold multiple upcoming bookings for different dates or rooms.

- Rules 6 and 7: Date checks require the check-out date to be after the check-in date, and any actual departure date to be on or after check-in.

-  Rule 8: Cancelling a reservation updates its status without deleting history. A finalized or cancelled reservation cannot be edited. This rule requires transaction logic.

Room availability can be calculated from reservation dates and status, so the design has no separate availability column.
