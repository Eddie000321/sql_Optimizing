-- Locking demo: acquire a write lock and observe blocking

-- Session 1:
BEGIN EXCLUSIVE TRANSACTION; -- holds a RESERVED/EXCLUSIVE lock
-- Try some work here, e.g. update
UPDATE accounts SET balance = balance + 1 WHERE id = 1;
-- Keep the transaction open to observe blocking from Session 2

-- Session 2 (separate sqlite3 process):
-- This write will wait/fail while Session 1 holds the exclusive lock
-- UPDATE accounts SET balance = balance + 1 WHERE id = 2;

-- When done in Session 1:
COMMIT; -- releases the lock
