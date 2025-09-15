-- Schema/init for practice tables (student-friendly, safe to re-run)
PRAGMA foreign_keys = ON;

-- Accounts table for transaction/locking/race-condition exercises
CREATE TABLE IF NOT EXISTS accounts (
  id INTEGER PRIMARY KEY,
  owner TEXT NOT NULL,
  balance INTEGER NOT NULL
);

-- Seed data only if empty
INSERT INTO accounts (id, owner, balance)
SELECT 1, 'Alice', 100
WHERE NOT EXISTS (SELECT 1 FROM accounts WHERE id = 1);

INSERT INTO accounts (id, owner, balance)
SELECT 2, 'Bob', 100
WHERE NOT EXISTS (SELECT 1 FROM accounts WHERE id = 2);

-- Optional: sanity check
SELECT * FROM accounts ORDER BY id;

