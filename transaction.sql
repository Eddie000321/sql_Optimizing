UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;

SELECT * FROM "accounts";

UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;

SELECT * FROM "accounts";

BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
COMMIT;

SELECT * FROM "accounts";

UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
/* Runtime error*/

BEGIN TRANSACTION;
UPDATE "accounts" SET "balance" = "balance" + 10 WHERE "id" = 2;
UPDATE "accounts" SET "balance" = "balance" - 10 WHERE "id" = 1;
/* Runtime Error*/
ROLLBACK;

