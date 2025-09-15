-- Basic single-column index demo (idempotent)
DROP INDEX IF EXISTS "title_index";
CREATE INDEX "title_index" ON "movies" ("title");

-- Expect index lookup (not full scan) on title equality
EXPLAIN QUERY PLAN
SELECT * FROM "movies" WHERE "title" = 'Cars';
