-- Partial index demo: only helpful when WHERE matches the predicate
DROP INDEX IF EXISTS "recents";
CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;

-- Expect index usage here (predicate matches)
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2023;

-- Expect full scan or different path (predicate mismatch)
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2022;
