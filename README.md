**Overview**
- Student-friendly SQLite lab to test core SQL theory with hands-on experiments. Using `movies.db`, verify how indexes affect query plans and latency, and how transactions/locks prevent concurrency anomalies.

**Requirements**
- `sqlite3` CLI must be installed.

**Quick Start**
- Run `sqlite3 movies.db`, then enable the following helpers:
  - ``.headers on``  ``.mode column``  ``.timer on``
- Initialize practice tables (optional): ``.read schema.sql``
- Execute each script from the SQLite prompt with ``.read <filename>``.
  - Example: ``.read queryPlans.sql``

**Files**
- `schema.sql`: Creates `accounts` table and seeds rows (safe to re-run)
- `indexes.sql`: Single-column index and basic lookups
  - ``CREATE INDEX "title_index" ON "movies" ("title");``
  - ``SELECT * FROM "movies" WHERE "title" = 'Cars';``
- `coveringIndexes.sql`: Covering index and runtime observation
  - ``CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");``
  - Use ``EXPLAIN QUERY PLAN`` and then run the actual ``SELECT``. Use ``.timer on`` to measure time.
- `queryPlans.sql`: Compare query plans and observe index impact
  - Baseline query → ``EXPLAIN QUERY PLAN`` → create indexes (``stars(person_id)``, ``people(name)``) → run ``EXPLAIN QUERY PLAN`` again → clean up with ``DROP INDEX "person_index";``
- `PartialIndex.sql`: Partial index and predicate matching
  - ``CREATE INDEX "recents" ON "moives" ("title") WHERE "year" = 2023;``
  - Then use ``EXPLAIN QUERY PLAN`` to compare conditions ``year = 2023`` vs ``year = 2022``.
  - Note: there is a table name typo ("moives" → "movies"). For actual use, fix it as:
    - ``CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;``
- `transaction.sql`: Transactions, atomicity, rollback
  - Issue standalone ``UPDATE`` statements → group them with ``BEGIN TRANSACTION``/``COMMIT`` → simulate errors and use ``ROLLBACK``.
  - Example table assumption: ``accounts(id, balance)``.
- `Locks.sql`: Write lock exercise
  - Acquire a write lock with ``BEGIN EXCLUSIVE TRANSACTION;``. In another session, observe concurrent writes waiting/failing.
- `raceConditions.sql`: Two-session lost update and non-atomic transfer demos with fixes.
- `movies.db`: SQLite database file for practice.

**Tips**
- Query plans: Inspect access paths with ``EXPLAIN QUERY PLAN <query>;`` (full scan, index scan, subquery strategy, etc.).
- Covering indexes: If all columns required by the ``SELECT`` are in the index, the engine can skip table lookups. Example: ``stars(person_id, movie_id)``.
- Composite index order: Choose the leading column(s) to maximize filtering for predicates/joins/sorts.
- Partial indexes: The index WHERE clause must logically match the query WHERE clause to be used.
- Re-running scripts: Index creation fails if the index already exists. If needed, clean up with ``DROP INDEX IF EXISTS <name>;`` before re-running.

**Notes**
- ``UPDATE`` statements in `transaction.sql` modify data. Wrap practice in a transaction and ``ROLLBACK`` when needed.
- Scripts are minimal, instructional examples. Required schemas (e.g., ``movies``, ``people``, ``stars``) exist in `movies.db`. The lab-specific `accounts` table is created by `schema.sql`.

**Recommended Workflow**
- 1) Baseline query → 2) ``EXPLAIN QUERY PLAN`` → 3) add/remove indexes (hypothesis) → 4) re-check plan → 5) measure with ``.timer on`` → 6) record in `MEASUREMENTS.md` → 7) clean up with ``DROP INDEX``.

**Learning Goals (Student Level)**
- Explain full scan vs index scan from a real plan.
- Show covering index benefit by skipping table lookups.
- Design partial indexes that match predicates and verify when they’re used.
- Enforce atomicity/isolation with transactions and observe lock behavior.

**Next Steps (Suggestions)**
- Extend `raceConditions.sql` with snapshot tests for different isolation modes.
- Add more composite index order experiments (leading column selectivity).
