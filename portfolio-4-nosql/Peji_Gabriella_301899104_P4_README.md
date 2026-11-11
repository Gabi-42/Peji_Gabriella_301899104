# Portfolio 4 NoSQL and Advanced Data Models

## Document model
The hotel_nosql_db database contains a hotel_events collection.
Each document records one guest check-in or room status update event. Its fields are _id, event_id, type, timestamp, guest, room, and details. Guest profile details (guest_number, full_name) and physical room attributes (room_number, category_code) are embedded directly in the event document. Check-in details include key card status, deposit amounts, and staff identifiers, while room status updates record occupancy status and housekeeping inspection notes.

Example check-in document:
```javascript
{
  "_id": "EVT-101",
  "event_id": "E001",
  "type": "check_in",
  "timestamp": ISODate("2026-06-01T14:30:00Z"),
  "guest": {
    "guest_number": "G001",
    "full_name": "Alice Smith"
  },
  "room": {
    "room_number": "101",
    "category_code": "SKG"
  },
  "details": {
    "key_card_issued": true,
    "deposit_paid": 150.00,
    "front_desk_staff": "Staff_A"
  }
}
```

## Implementation and results
Four fictional documents were inserted into MongoDB using mongosh. The total document count query returned 4. The room history query for Room 101 returned EVT-101 (check-in) followed by EVT-102 (room status update) in chronological order. Searching details.key_card_issued for true returned EVT-101 (Alice Smith) and EVT-103 (Bob Jones). These event logs were entered independently; the PostgreSQL operational schema and records remained unchanged.

## Why MongoDB fits
A document structure allows an event to store its guest, room, and event-specific details in a single self-contained unit. Check-in events and housekeeping status updates can vary in structure without requiring empty fields or artificial schema alterations. Storing each event as a separate document allows audit logs to grow indefinitely without expanding single records beyond document size limits. The embedded guest and room fields serve as historical snapshots of the stay at that point in time and do not automatically sync with relational updates. PostgreSQL remains responsible for core schema integrity and transaction enforcement. This example does not enforce SQL foreign keys within MongoDB or synchronize the two storage engines.

## Files
- [MongoDB implementation and queries](Peji_Gabriella_301899104_P4_MongoDB.js)
- [Setup and connection check](Peji_Gabriella_301899104_P4_Setup.md)
- [Screenshots](Screenshots/): MongoDBConnection and EventsAndQueries.

The implementation script stops if borrowing_events already contains documents. It uses printjson to display results when executed as a saved file; it should not be rerun against the populated exercise collection.

## References

- [MongoDB — Data Modeling](https://www.mongodb.com/docs/manual/data-modeling/)
- [MongoDB — insertMany](https://www.mongodb.com/docs/manual/reference/method/db.collection.insertmany/)
- [MongoDB — Query Embedded Documents](https://www.mongodb.com/docs/manual/tutorial/query-embedded-documents/)