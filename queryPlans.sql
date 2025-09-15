-- Query plan comparison: before vs after indexes
-- Clean slate for idempotency
DROP INDEX IF EXISTS "person_index";
DROP INDEX IF EXISTS "name_index";

-- Baseline plan (likely full scans / less optimal joins)
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);

-- Add helpful indexes
CREATE INDEX "person_index" ON "stars" ("person_id");
CREATE INDEX "name_index" ON "people" ("name");

-- Improved plan should favor index scans/lookups
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);

-- Cleanup (optional)
DROP INDEX IF EXISTS "person_index";
DROP INDEX IF EXISTS "name_index";


