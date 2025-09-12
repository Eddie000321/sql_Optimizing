**Overview**
- A set of SQLite-based practice snippets for SQL performance tuning and concurrency. Using the `movies.db` sample database, you can experiment with indexes, covering indexes, query plans, partial indexes, transactions, locks, and race conditions.

**Requirements**
- `sqlite3` CLI must be installed.

**Quick Start**
- Run `sqlite3 movies.db`, then enable the following helpers:
  - ``.headers on``  ``.mode column``  ``.timer on``
- Execute each script from the SQLite prompt with ``.read <filename>``.
  - Example: ``.read queryPlans.sql``

**Files**
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
- `raceConditions`: Placeholder for race-condition practice (currently empty). Try opening two SQLite sessions to simulate competing updates without transactions, then resolve with transactions/locks.
- `movies.db`: SQLite database file for practice.

**Tips**
- Query plans: Inspect access paths with ``EXPLAIN QUERY PLAN <query>;`` (full scan, index scan, subquery strategy, etc.).
- Covering indexes: If all columns required by the ``SELECT`` are in the index, the engine can skip table lookups. Example: ``stars(person_id, movie_id)``.
- Composite index order: Choose the leading column(s) to maximize filtering for predicates/joins/sorts.
- Partial indexes: The index WHERE clause must logically match the query WHERE clause to be used.
- Re-running scripts: Index creation fails if the index already exists. If needed, clean up with ``DROP INDEX IF EXISTS <name>;`` before re-running.

**Notes**
- ``UPDATE`` statements in `transaction.sql` modify data. Wrap practice in a transaction and ``ROLLBACK`` when needed.
- `PartialIndex.sql` contains a table typo ("moives"). Fix to "movies" to avoid errors.
- Scripts are minimal, instructional examples. Required schemas (e.g., ``movies``, ``people``, ``stars``, ``accounts``) must exist in the DB.

**Recommended Workflow**
- 1) Run a baseline query → 2) check ``EXPLAIN QUERY PLAN`` → 3) design/create indexes → 4) check the plan again → 5) compare timings with ``.timer on`` → 6) drop unnecessary indexes with ``DROP INDEX``.

**Next Steps (Suggestions)**
- Fill in the `raceConditions` script (add two-session update/read scenarios).
- Add ``IF NOT EXISTS`` to index creation statements for idempotent runs.
- Optionally add schema init scripts (e.g., create test tables like ``accounts``).
