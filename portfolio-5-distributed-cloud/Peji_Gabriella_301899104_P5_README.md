# Portfolio 5 Distributed and Cloud Database Exercise

## Current setup
Based on previous MongoDB setup notes, the current implementation uses a single, standalone MongoDB instance (hotel_nosql_db) intended for local development and testing. The actual production topology, multi-node configuration, and failover tests have not been deployed or verified for this environment.

## Proposed replication
To provide high availability for hotel event logs (such as guest check_in events), I propose a three-member replica set deployed across separate physical hosts or failure zones, following standard architecture (MongoDB Replication).

| Member | Starting role | Location |
| --- | --- | --- |
| Node 1 | Primary | Failure Zone A |
| Node 2 | Secondary | Failure Zone B |
| Node 3 | Secondary | Failure Zone C |

Failure and consistency
If the primary node fails, the remaining secondaries detect the outage and automatically hold an election to choose a new primary (Replica Set Elections). Write operations are briefly interrupted during this transition. If a majority of voting members cannot communicate, the set becomes read-only and rejects new writes. Configuring majority write concern ensures data is safely written to a majority of nodes before confirmation, minimizing rollback risks during a failover (Write Concern), though network lag can introduce slight replication delays on secondaries. Relational transaction rules and authoritative operational data remain handled by PostgreSQL.

## Sharding and cloud deployment
Sharding distributes subsets of data across multiple servers, whereas replication copies the identical dataset for redundancy. For the hotel events dataset, it does not require sharding due to size, as it easily fits on a single node. For cloud deployment, security controls such as TLS transport encryption, IP access lists, and user authentication are essential, along with managed backup and restore features (Atlas Backup and Restore). Cloud hosting introduces recurring subscription costs and management overhead, while horizontal sharding adds query routing complexity (Sharding). Furthermore, MongoDB replication operates independently and does not automatically replicate or synchronize data with the PostgreSQL database.

## References from mongodb.com
- [Replication](https://www.mongodb.com/docs/manual/replication/)
- [Election](https://www.mongodb.com/docs/v8.0/core/replica-set-elections/)
- [Write Concern](https://www.mongodb.com/docs/v8.0/reference/write-concern/)
- [Sharding](https://www.mongodb.com/docs/manual/sharding/)
- [Backup options](https://www.mongodb.com/docs/atlas/backup-restore-cluster/)

