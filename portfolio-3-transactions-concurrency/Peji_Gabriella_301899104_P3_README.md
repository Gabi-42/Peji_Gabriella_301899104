# Portfolio 3 Transactions and Concurrency

## Commit and rollback
The commit and rollback exercise verified how transaction blocks group multiple SQL operations to ensure atomicity. Within the hotel database, a cancelled reservation status was successfully updated and permanently saved using COMMIT. A separate transaction updated a guest record but included a deliberate unique email constraint violation, prompting an error that allowed the entire transaction to be safely discarded via ROLLBACK with no partial updates persisting.

## Isolation and concurrency control
A two-session concurrency test demonstrated database isolation and locking behavior using our unique partial index on active room stays. When Session A inserted an active stay for Room 102 and kept it uncommitted, Session B's conflicting insert paused and waited for the lock to release. Once Session A committed, Session B unblocked, encountered the unique constraint error, and rolled back, proving that database controls successfully prevent overlapping active stays.

## Conclusion
Overall, Portfolio 3 confirmed that PostgreSQL transaction management and unique indexing effectively maintain data consistency under concurrent access. Commits securely save valid multi-step workflows, rollbacks discard corrupted or aborted changes, and constraints prevent conflicting room reservations, ensuring reliable multi-user operations for the hotel reservation system.
## Files

- [Commit and rollback SQL](Peji_Gabriella_301899104_P3_Transactions.sql)
- [Session A SQL](Peji_Gabriella_301899104_P3_SessionA.sql)
- [Session B SQL](Peji_Gabriella_301899104_P3_SessionB.sql)
- [Screenshots](Screenshots/): CommitRollback, SessionsWaiting and ConcurrencyResult.

Run the two-session examples in the codelab's A → B → A → B order, not as two complete scripts executed sequentially.

## References

- [PostgreSQL 16 — Transactions](https://www.postgresql.org/docs/16/tutorial-transactions.html)
- [PostgreSQL 16 — Transaction Isolation](https://www.postgresql.org/docs/16/transaction-iso.html)
- [PostgreSQL 16 — Unique Indexes](https://www.postgresql.org/docs/16/indexes-unique.html)