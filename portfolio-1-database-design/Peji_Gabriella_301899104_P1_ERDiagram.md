# Hotel Reservation System ER Diagram
This diagram shows the four (4) tables, their field and how they connect
erDiagram
    direction LR
    GUEST {
        bigint guest_id PK
        varchar guest_number UK
        varchar full_name
        varchar email UK
    }
    ROOM_CATEGORY {
        bigint category_id PK
        varchar category_code UK
        varchar category_name
    }
    ROOM {
        bigint room_id PK
        bigint category_id FK
        varchar room_number UK
    }
    RESERVATION {
        bigint reservation_id PK
        bigint guest_id FK
        bigint room_id FK
        date check_in_date
        date check_out_date
        date actual_departure "optional"
        varchar status
    }
    ROOM_CATEGORY ||--o{ ROOM : "contains"
    GUEST ||--o{ RESERVATION : "makes"
    ROOM ||--o{ RESERVATION : "has"

##  Reading the diagram
Explanation of Key Terms and Symbols
### Keys and Constraints
- PK (Primary Key): A unique identifier for every single record in a table. For example, guest_id ensures every guest profile has a distinct, non-repeating identifier.
- FK (Foreign Key): A field that links a record in one table to the primary key of another table, establishing a relationship. For example, category_id in the room table points to category_id in room_category to show which type the room is.
- UK (Unique Key): Ensures that no two rows share the same value in that specific column. For example, email in the guest table is marked UK so that two guests cannot register with the exact same email address.

### Relationship Symbols
The diagram uses standard Crow's Foot notation to show how tables connect:
- || (Mandatory One): Indicates that the entity on that end must exist and has a strict cardinality of exactly one.
- o{ (Optional Many): Indicates that a related entity can have zero, one, or multiple associated records.

Case Study Example: The line between GUEST and RESERVATION (GUEST ||--o{ RESERVATION) means that a guest can have zero or multiple reservations over time, but every single reservation must belong to exactly one guest.