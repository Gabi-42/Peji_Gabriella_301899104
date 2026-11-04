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


## Scope
This scope covers a single hotel property managing fictional guest profiles, room categories, physical rooms, and standard reservations. Payments, invoicing, and external payment gateway integrations are excluded. Reservations map to specific room categories rather than specific physical room numbers at the time of booking, with room assignment handled at check-in.