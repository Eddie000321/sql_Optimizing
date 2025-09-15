-- Reset helper for accounts demo balances
-- Restores id=1 and id=2 to 100 within a single transaction
BEGIN TRANSACTION;
UPDATE accounts SET balance = 100 WHERE id = 1;
UPDATE accounts SET balance = 100 WHERE id = 2;
COMMIT;

-- Sanity check
SELECT * FROM accounts ORDER BY id;

