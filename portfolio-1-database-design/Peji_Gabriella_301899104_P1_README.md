# Portfolio 1 Database Design and Modelling

## Case study
A hotel reservation system stores guest profiles, room categories, physical rooms, and booking history. Front desk staff can process check-ins and check-outs, while guests create and manage their bookings. The database tracks room availability, active stays, guest records, and payments.

## Users
Guests use system to search for available rooms, make bookings, and cancel reservations. Front desk staff register guests, process check-ins and check-outs, and update room status. Hotel managers can maintain room records and review occupancy data.

## Main operations
Register a guest; add a room category and physical rooms; create a reservation; process a check-in; process a check-out; process payments; cancel a reservation; and view available rooms for specific dates.

## Business rules
1. Each guest has a unique guest ID and email address.
2. Each physical room has a unique room number and belongs to one room category. A room category can contain multiple rooms. 
3. Each reservation refers to one existing guest and one room category.
4. A physical room can have at most one active guest stay at a time.
5. A guest can hold multiple upcoming reservations, provided the dates do not overlap.
6. The check-out date must be later than the check-in date. Staff specify both dates upon booking.
7. The actual departure date remains empty until check-out and check-out cannot precede check-in.
8. A cancellation updates the booking status without deleting history. A finalized or cancelled reservation cannot be edited.

## Design and implementation files
| File | Contents |
| --- | --- |
| [Design](Peji_Gabriella_301899104_P1_Design.md) | Entities, attributes, keys and relationships. |
| [ER Diagrams](Peji_Gabriella_301899104_P1_ERDiagram.md) | Entity-Relationship diagram and key/relationship explanations. |
| [Normalisation](Peji_Gabriella_301899104_P1_Normalisation.md) | Normalisation process breaking down records from 1NF to 3NF. |
| [Schema](Peji_Gabriella_301899104_P1_Schema.sql) | Table definitions, keys and constraints. |
| [Sample Data](Peji_Gabriella_301899104_P1_SampleData.sql) | Valid sample dataset representing active, completed, and cancelled stays. |
| [Constraint Test](Peji_Gabriella_301899104_P1_ConstraintsTests.sql) | Negative test statements verifying schema constraints |
| [Screenshots](Screenshots/) | Saved commands and results. |


## Scope
This scope covers a single hotel property managing fictional guest profiles, room categories, physical rooms, and standard reservations. Payments, invoicing, and external payment gateway integrations are excluded. Reservations map to specific room categories rather than specific physical room numbers at the time of booking, with room assignment handled at check-in.

## Implementation
The database runs on PostgreSQL in GitHub Codespaces. Its name is hotel_portfolio. The PostgreSQL 16 schema implements four core tables: guest, room_category, room, and reservation. Primary keys are established using automatically generated identities, and foreign keys enforce referential integrity between categories and rooms, as well as guests and reservations. Unique constraints secure email addresses, guest numbers, category codes, and room numbers.

A conditional unique index on the reservation table ensures that each physical room can have at most one active stay at a time. The database setup was validated by executing the sample data script within a transaction block and running negative constraint tests separately outside transactions.

## Test results
Executing SampleData.sql successfully loaded valid records across different guest and reservation states. The negative tests in ConstraintsTests.sql functioned as expected: violations of NOT NULL requirements, duplicate unique keys, invalid foreign key references, and check constraint failures (such as check-out dates preceding check-in dates or departure dates occurring before check-in) were all successfully rejected by the database engine. Furthermore, the conditional unique index correctly prevented overlapping active reservations for the same physical room.

 Final verification queries confirmed the expected table row counts after all invalid inserts failed: 2 guests, 2 room categories, 3 physical rooms, and 3 reservations. Rule 8, which prevents edits to finalised or cancelled bookings, depends on application-level transaction logic rather than database constraints alone and was handled via design documentation.