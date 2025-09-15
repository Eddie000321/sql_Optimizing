-- Covering index demo: stars(person_id, movie_id) can satisfy inner query
-- Idempotent index creation
DROP INDEX IF EXISTS "person_index";
CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");

-- Plan should show index usage on stars and people(name) if available
EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);

.timer on
SELECT "title" FROM "movies" WHERE "id" IN (
    SELECT "movie_id" FROM "stars" WHERE "person_id" = (
        SELECT "id" FROM "people" WHERE "name" = 'Tom Hanks'
    )
);
