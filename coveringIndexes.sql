-- Covering index demo: stars(person_id, movie_id) can satisfy inner query
-- Idempotent index creation
DROP INDEX IF EXISTS "person_index";
DROP INDEX IF EXISTS "name_index";
CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");
CREATE INDEX "name_index" ON "people" ("name");

-- Plan should show index usage on stars and people(name) if available
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);

-- Cleanup (optional)
DROP INDEX IF EXISTS "person_index";
DROP INDEX IF EXISTS "name_index";

.timer on
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
