**개요**
- SQLite 기반의 SQL 성능 최적화·동시성 실습 스니펫 모음입니다. `movies.db` 샘플 DB를 대상으로 인덱스, 커버링 인덱스, 실행 계획, 부분 인덱스, 트랜잭션, 락(잠금), 레이스 컨디션 등을 실험합니다.

**요구 사항**
- `sqlite3` CLI가 설치되어 있어야 합니다.

**빠른 시작**
- `sqlite3 movies.db` 실행 후 아래 보조 설정을 켭니다.
  - ``.headers on``  ``.mode column``  ``.timer on``
- 각 스크립트는 SQLite 프롬프트에서 ``.read <파일명>`` 으로 실행합니다.
  - 예: ``.read queryPlans.sql``

**파일 안내**
- `indexes.sql`: 단일 컬럼 인덱스와 단순 탐색
  - ``CREATE INDEX "title_index" ON "movies" ("title");``
  - ``SELECT * FROM "movies" WHERE "title" = 'Cars';``
- `coveringIndexes.sql`: 커버링 인덱스와 실행 시간 관찰
  - ``CREATE INDEX "person_index" ON "stars" ("person_id", "movie_id");``
  - ``EXPLAIN QUERY PLAN`` 과 실제 ``SELECT`` 실행. ``.timer on`` 사용으로 시간 측정.
- `queryPlans.sql`: 실행 계획 비교와 인덱스 효과 관찰
  - 기준 쿼리 → ``EXPLAIN QUERY PLAN`` → 인덱스 생성(``stars(person_id)``, ``people(name)``) → 다시 ``EXPLAIN QUERY PLAN`` → 인덱스 정리(``DROP INDEX "person_index";``).
- `PartialIndex.sql`: 부분 인덱스와 조건 매칭
  - ``CREATE INDEX "recents" ON "moives" ("title") WHERE "year" = 2023;``
  - 이어서 ``EXPLAIN QUERY PLAN`` 으로 ``year=2023`` vs ``year=2022`` 조건의 차이를 확인.
  - 참고: 테이블명 오탈자("moives" → "movies"). 실제 사용 시 아래처럼 수정하세요:
    - ``CREATE INDEX "recents" ON "movies" ("title") WHERE "year" = 2023;``
- `transaction.sql`: 트랜잭션, 원자성, 롤백
  - 트랜잭션 없이 각각 ``UPDATE`` → 트랜잭션으로 묶어서 ``BEGIN TRANSACTION``/``COMMIT`` → 오류 상황에서 ``ROLLBACK``.
  - 예제 테이블: ``accounts(id, balance)`` 를 가정합니다.
- `Locks.sql`: 쓰기 락 실습
  - ``BEGIN EXCLUSIVE TRANSACTION;`` 로 쓰기 잠금 획득. 다른 세션에서 동시 쓰기가 대기/실패하는지 관찰합니다.
- `raceConditions`: 레이스 컨디션 실습용 플레이스홀더(현재 내용 없음). 두 개의 SQLite 세션을 열어 트랜잭션 없이 경쟁 갱신을 시뮬레이션한 뒤, 트랜잭션/락으로 해결하는 흐름을 추가해 보세요.
- `movies.db`: 실습용 SQLite DB 파일.

**실행 팁**
- 실행 계획: ``EXPLAIN QUERY PLAN <쿼리>;`` 로 접근 방식(풀스캔/인덱스스캔/서브쿼리 전략 등)을 확인합니다.
- 커버링 인덱스: ``SELECT`` 에 필요한 컬럼이 모두 인덱스에 있으면 테이블 접근을 건너뛸 수 있습니다. 예) ``stars(person_id, movie_id)``.
- 복합 인덱스 순서: 조건/조인/정렬에서 선행 컬럼이 더 많이 필터링되도록 순서를 설계하세요.
- 부분 인덱스: 인덱스의 WHERE 절과 쿼리의 WHERE 절이 논리적으로 일치해야 활용됩니다.
- 반복 실행 시: 이미 존재하는 인덱스가 있으면 생성이 실패합니다. 필요시 ``DROP INDEX IF EXISTS <이름>;`` 로 정리한 뒤 재실행하세요.

**주의 사항**
- `transaction.sql` 의 ``UPDATE`` 는 실제 데이터를 변경합니다. 실습은 트랜잭션으로 감싸고, 필요 시 ``ROLLBACK`` 하세요.
- `PartialIndex.sql` 의 테이블 오탈자("moives")를 수정하지 않으면 오류가 발생합니다.
- 스크립트는 설명 목적의 최소 예시입니다. 스키마(예: ``movies``, ``people``, ``stars``, ``accounts``)는 DB에 존재해야 합니다.

**추천 워크플로우**
- 1) 기준 쿼리 실행 → 2) ``EXPLAIN QUERY PLAN`` 확인 → 3) 인덱스 설계/생성 → 4) 다시 실행 계획 확인 → 5) ``.timer on`` 으로 시간 비교 → 6) 불필요한 인덱스는 ``DROP INDEX`` 로 정리.

**다음 작업(제안)**
- `raceConditions` 스크립트 채우기(두 세션에서 동시 갱신/조회 시나리오 추가).
- 인덱스 생성문에 ``IF NOT EXISTS`` 추가하여 재실행 친화성 개선.
- 필요 시 스키마 초기화용 스크립트 추가(``accounts`` 등 테스트 테이블 생성).

