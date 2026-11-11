// Peji_Gabriella_301899104_P4_MongoDB.js
db = db.getSiblingDB("hotel_events");


// Verify collection is empty before insertion
db.hotel_events.countDocuments();

// The following four documents represent two distinct hotel event types (check_in and room_status_update) stored in a single collection, utilizing identifiers
db.hotel_events.insertMany([
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
  },
  {
    "_id": "EVT-102",
    "event_id": "E002",
    "type": "room_status_update",
    "timestamp": ISODate("2026-06-01T15:00:00Z"),
    "guest": null,
    "room": {
      "room_number": "101",
      "category_code": "SKG"
    },
    "details": {
      "status": "Occupied",
      "housekeeping_notes": "Cleaned and inspected prior to check-in"
    }
  },
  {
    "_id": "EVT-103",
    "event_id": "E003",
    "type": "check_in",
    "timestamp": ISODate("2026-06-02T16:15:00Z"),
    "guest": {
      "guest_number": "G002",
      "full_name": "Bob Jones"
    },
    "room": {
      "room_number": "102",
      "category_code": "SKG"
    },
    "details": {
      "key_card_issued": true,
      "deposit_paid": 200.00,
      "front_desk_staff": "Staff_B"
    }
  },
  {
    "_id": "EVT-104",
    "event_id": "E004",
    "type": "room_status_update",
    "timestamp": ISODate("2026-06-02T17:00:00Z"),
    "guest": null,
    "room": {
      "room_number": "102",
      "category_code": "SKG"
    },
    "details": {
      "status": "Occupied",
      "housekeeping_notes": "Standard setup completed"
    }
  }
]);

// Verify the number of documents inserted into the collection. Expectation : 4 documents should be present in the collection.
db.hotel_events.countDocuments();

//order the events for room 101 by timestamp in ascending order
db.hotel_events.find({ "room.room_number": "101" }).sort({ timestamp: 1 });

//nested query to find all check-in events where a key card was issued
db.hotel_events.find({ "details.key_card_issued": true });