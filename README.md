# Relational Database design & core sql 
This project demonstrates relational modeling, shcema design, SQL curd operations, joins, transaction handling, data integrity using postgresql.


## Key Concepts
- Normalized relational schema
- Primary and foreign keys
- Constrainst (not null, unique, check)
- Transactional sQL (ACID)
- Data quality checks

## How to Run
1. Create a postgreSQL database (postgres)
2. Run sQL files in order:
    - 01_schema_tables.sql
    - 03_seed_data.sql
    - 04_core_queries.sql
    - 05_transactions.sql
    
## Notes
This prject focuses on core relational design.  
Advanced SQL objects (views, indexes, procedures, triggers) are in project/repo2.

##Engineering Notes & Lessons Learned

- Implemented database roles and privileges to separate ownership from application access, reinforcing least-privilege principles.
- Resolved client-side filesystem permission issues when capturing query output, distinguishing OS-level permissions from database access control.
- Refactored transactional SQL to eliminate hard-coded identifiers by using RETURNING with CTEs, ensuring referential integrity.
- Verified foreign key constraints correctly prevent invalid writes and trigger automatic rollbacks.
- Improved reporting accuracy by replacing inner joins with left joins to surface data quality issues.
- Transaction demo intentionally triggers a foreign key violation to show rollback behavior and data integrity under ACID

