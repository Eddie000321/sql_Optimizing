-- Race condition demos (run in two separate sqlite3 sessions)
-- Pre-req: run schema.sql once to ensure accounts exists

-- Scenario A: Lost update due to read-modify-write in app layer
-- (Demonstrates why we should use set-based updates or transactions)

-- Session 1
-- Step A1: Read current balance
--   SELECT balance FROM accounts WHERE id = 1;  -- suppose 100
-- Step A2: Compute new balance client-side (e.g., 100 - 10 = 90)
-- Step A3: Write computed value (without re-reading)
--   UPDATE accounts SET balance = 90 WHERE id = 1; -- overwrites

-- Session 2
-- Step B1: Read current balance (before S1 writes)
--   SELECT balance FROM accounts WHERE id = 1;  -- also 100
-- Step B2: Compute new balance client-side (e.g., 100 + 10 = 110)
-- Step B3: Write computed value (races with Session 1)
--   UPDATE accounts SET balance = 110 WHERE id = 1; -- last writer wins

-- Result: One update is lost because both overwrote based on stale reads.
-- Fix 1: Use set-based arithmetic to avoid lost updates
--   UPDATE accounts SET balance = balance - 10 WHERE id = 1;
--   UPDATE accounts SET balance = balance + 10 WHERE id = 1;

-- Fix 2: Use transactions to enforce isolation
-- Session 1
--   BEGIN IMMEDIATE; -- acquire write lock early
--   UPDATE accounts SET balance = balance - 10 WHERE id = 1;
--   COMMIT;
-- Session 2 (started during S1) will block/fail until COMMIT

-- Scenario B: Non-atomic transfer without transaction
-- Session 1
--   UPDATE accounts SET balance = balance - 10 WHERE id = 1; -- debit
--   -- crash or delay here -> inconsistent state visible to others
-- Session 2
--   SELECT * FROM accounts; -- observes intermediate, inconsistent state
-- Fix: wrap in a transaction so both statements succeed or none
--   BEGIN TRANSACTION;
--   UPDATE accounts SET balance = balance - 10 WHERE id = 1;
--   UPDATE accounts SET balance = balance + 10 WHERE id = 2;
--   COMMIT;

