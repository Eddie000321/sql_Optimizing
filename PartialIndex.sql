CREATE INDEX "recents" ON "moives" ("title") WHERE "year" = 2023;

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2023; 

EXPLAIN QUERY PLAN
SELECT "title" FROM "movies" WHERE "year" = 2022;
