# Portfolio 2 Query Processing and Optimisation

## Queries and results
Three core queries were executed against the hotel reservation database. The first query joined reservations, guests, rooms, and room categories to list active bookings, returning 1 row (Alice Smith, Room 101, Standard King). The second query used a NOT EXISTS condition to locate rooms lacking an active stay, correctly identifying Room 102 and Room 201. The third query combined a LEFT JOIN and GROUP BY on room categories to count physical rooms per category, successfully reporting 1 Deluxe Suite and 2 Standard Kings.

## Index comparions
The separate p2_benchmark.reservation_history table contains 100,000 generated rows using guest and room identifiers. The Portfolio 1 records remain unchanged. This test table is created with CREATE TABLE AS and does not copy the operational table's constraints.

The same query selects reservations checking in from March 1, 2026 to March 31, 2026. It returns 4,161 rows before and after adding idx_reservation_history_check_in on check_in_date. ANALYZE refreshes the test table statistics before measurement. Each phase has one warm-up and three measured EXPLAIN (ANALYZE, BUFFERS) runs.

| Measurement | Before index | After index |
| --- | --- | --- |
| Scan type | Seq Scan | Bitmap Heap Scan |
| Three execution times (ms) | 8.776,7.090,7.637| 2.433, 1.683, 1.563 |
| Median time (ms) | 7.941637 | 1.683 |
| Shared buffer hits, third run | 960 | 3915 |

## Performance analysis
Before indexing, PostgreSQL scans 100,000 rows and removes 95,839 through the date filter using a sequential scan. After indexing, the bitmap scan finds the 4,161 matching entries, reducing the median execution time from 7.637 ms to 1.683 ms and buffer hits from 960 to 915. Both phases use cached data; the variable before-index times also show that this shared Codespace is not a controlled production benchmark. The result applies to this narrow date range, not every query. An index uses extra storage and adds maintenance work when records change.

## Files

- [SQL queries](Peji_Gabriella_301899104_P2_Queries.sql)
- [Test data, execution plans and index SQL](Peji_Gabriella_301899104_P2_Optimisation.sql)
- [Screenshots](Screenshots/): QueryResults, BeforeIndex and AfterIndex.

## Reference

[PostgreSQL 16 — Using EXPLAIN](https://www.postgresql.org/docs/16/using-explain.html).