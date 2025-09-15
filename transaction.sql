-- Transaction demos (requires accounts table; run schema.sql first if needed)

-- Independent updates (non-atomic) – observe intermediate states
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
SELECT * FROM "accounts";
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
SELECT * FROM "accounts";

-- Atomic transfer using transaction (all or nothing)
BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
COMMIT;
SELECT * FROM "accounts";

-- Simulate failure mid-transfer; verify ROLLBACK restores prior state
BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
-- Intentional error: table/column that does not exist to trigger failure
UPDATE "accountZZ" SET "balance" = 0 WHERE "id" = 9999; -- will fail
ROLLBACK;
SELECT * FROM "accounts";
