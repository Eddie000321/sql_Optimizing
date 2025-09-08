DROP INDEX IF EXISTS "recents";
CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2023; 

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2022;
