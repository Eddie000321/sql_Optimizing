Overview
- Use this template to record before/after performance and plans. Re-run 3–5 times and take the average.

Environment
- DB: movies.db
- SQLite: sqlite3 --version = <fill>
- Settings: .headers on, .mode column, .timer on

Query: Tom Hanks movie titles (coveringIndexes.sql)
- Baseline plan (no person_index):
  - EXPLAIN notes: <full scan / nested lookup / etc>
  - Runtime (ms): run1 <..>, run2 <..>, run3 <..> → avg <..>
- After index person_index(person_id, movie_id):
  - EXPLAIN notes: <index scan on stars, lookup on movies>
  - Runtime (ms): run1 <..>, run2 <..>, run3 <..> → avg <..>
- Delta: <percentage improvement>

Query: Partial index recents (PartialIndex.sql)
- Plan with WHERE year=2023: <uses recents index>
- Plan with WHERE year=2022: <no use; full scan or different index>

Transaction Consistency (transaction.sql)
- Before: balances: id=1 <..>, id=2 <..>
- After atomic transfer: balances: id=1 <..>, id=2 <..>
- After failed transfer + ROLLBACK: balances unchanged: <..>

Locking (Locks.sql)
- Session 1 held EXCLUSIVE lock; Session 2 write blocked until COMMIT.

