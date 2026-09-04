-- =========================================================
-- Codyssey B6-1
-- 서울시 공공자전거 따릉이 대여 관리 DB
-- 전체 실행 스크립트
-- =========================================================
--
-- 실행 방법:
-- mysql> SOURCE C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/sql/03_queries.sql;
--
-- 결과 저장 위치:
-- C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/
--
-- 주의:
-- tee / notee 는 MySQL CLI 명령이므로 세미콜론(;)을 붙이지 않는다.
-- =========================================================


-- =========================================================
-- 0. DB 초기화
-- =========================================================

SOURCE C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/sql/01_schema.sql;
SOURCE C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/sql/02_seed.sql;

USE codyssey_db;


-- =========================================================
-- Query 01
-- 기본 조회 / WHERE
-- 목적: 마포구에 위치한 대여소를 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_01.txt

SELECT
    station_id,
    station_name,
    district,
    rack_count
FROM station
WHERE district = '마포구';

notee


-- =========================================================
-- Query 02
-- 기본 조회 / WHERE
-- 목적: 이동 거리가 5km 이상인 완료 대여 기록을 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_02.txt

SELECT
    rental_id,
    rider_id,
    bike_id,
    distance_m,
    rental_status
FROM rental
WHERE distance_m >= 5000
  AND rental_status = 'completed';

notee


-- =========================================================
-- Query 03
-- 기본 조회 / ORDER BY
-- 목적: 최근 대여 기록부터 내림차순으로 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_03.txt

SELECT
    rental_id,
    rider_id,
    bike_id,
    rented_at,
    rental_status
FROM rental
ORDER BY rented_at DESC;

notee


-- =========================================================
-- Query 04
-- 기본 조회 / ORDER BY + LIMIT
-- 목적: 이동 거리가 가장 긴 대여 기록 5개를 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_04.txt

SELECT
    rental_id,
    rider_id,
    bike_id,
    distance_m
FROM rental
WHERE distance_m IS NOT NULL
ORDER BY distance_m DESC
LIMIT 5;

notee


-- =========================================================
-- Query 05
-- INNER JOIN
-- 목적: 대여 기록과 이용자 이름을 함께 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_05.txt

SELECT
    r.rental_id,
    rd.name AS rider_name,
    r.rented_at,
    r.rental_status
FROM rental r
INNER JOIN rider rd
    ON r.rider_id = rd.rider_id;

notee


-- =========================================================
-- Query 06
-- INNER JOIN
-- 목적: 대여 기록과 자전거 식별 코드를 함께 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_06.txt

SELECT
    r.rental_id,
    b.bike_code,
    b.model_name,
    r.rented_at,
    r.returned_at
FROM rental r
INNER JOIN bike b
    ON r.bike_id = b.bike_id;

notee


-- =========================================================
-- Query 07
-- INNER JOIN + LEFT JOIN
-- 목적: 출발 대여소와 반납 대여소 이름을 함께 조회한다.
--
-- 출발 대여소:
-- rental_station_id 는 NOT NULL 이므로 INNER JOIN
--
-- 반납 대여소:
-- 아직 대여 중이면 return_station_id 가 NULL일 수 있으므로 LEFT JOIN
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_07.txt

SELECT
    r.rental_id,
    s1.station_name AS rental_station,
    s2.station_name AS return_station,
    r.rented_at,
    r.returned_at
FROM rental r
INNER JOIN station s1
    ON r.rental_station_id = s1.station_id
LEFT JOIN station s2
    ON r.return_station_id = s2.station_id;

notee


-- =========================================================
-- Query 08
-- LEFT JOIN + GROUP BY + COUNT
-- 목적: 대여 기록이 없는 이용자까지 포함하여 이용 횟수를 확인한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_08.txt

SELECT
    rd.rider_id,
    rd.name,
    COUNT(r.rental_id) AS rental_count
FROM rider rd
LEFT JOIN rental r
    ON rd.rider_id = r.rider_id
GROUP BY
    rd.rider_id,
    rd.name
ORDER BY rental_count DESC;

notee


-- =========================================================
-- Query 09
-- INNER JOIN + GROUP BY + COUNT
-- 목적: 실제 이용 기록이 있는 이용자별 대여 횟수를 집계한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_09.txt

SELECT
    rd.rider_id,
    rd.name,
    COUNT(r.rental_id) AS rental_count
FROM rider rd
INNER JOIN rental r
    ON rd.rider_id = r.rider_id
GROUP BY
    rd.rider_id,
    rd.name
ORDER BY rental_count DESC;

notee


-- =========================================================
-- Query 10
-- INNER JOIN + GROUP BY + SUM
-- 목적: 자전거별 총 이동 거리를 계산한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_10.txt

SELECT
    b.bike_id,
    b.bike_code,
    SUM(r.distance_m) AS total_distance_m
FROM bike b
INNER JOIN rental r
    ON b.bike_id = r.bike_id
WHERE r.distance_m IS NOT NULL
GROUP BY
    b.bike_id,
    b.bike_code
ORDER BY total_distance_m DESC;

notee


-- =========================================================
-- Query 11
-- INNER JOIN + GROUP BY + AVG
-- 목적: 출발 대여소별 평균 이동 거리를 계산한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_11.txt

SELECT
    s.station_id,
    s.station_name,
    AVG(r.distance_m) AS avg_distance_m
FROM station s
INNER JOIN rental r
    ON s.station_id = r.rental_station_id
WHERE r.distance_m IS NOT NULL
GROUP BY
    s.station_id,
    s.station_name
ORDER BY avg_distance_m DESC;

notee


-- =========================================================
-- Query 12
-- 서브쿼리
-- 목적: 전체 평균 이동 거리보다 더 멀리 이동한 기록을 조회한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_12.txt

SELECT
    rental_id,
    rider_id,
    bike_id,
    distance_m
FROM rental
WHERE distance_m > (
    SELECT AVG(distance_m)
    FROM rental
    WHERE distance_m IS NOT NULL
)
ORDER BY distance_m DESC;

notee


-- =========================================================
-- Query 13
-- UPDATE
-- 목적: 특정 자전거의 상태를 maintenance 로 변경하고 결과를 확인한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_13.txt

SELECT
    bike_id,
    bike_code,
    status
FROM bike
WHERE bike_code = 'SEOUL-BIKE-010';

UPDATE bike
SET status = 'maintenance'
WHERE bike_code = 'SEOUL-BIKE-010';

SELECT
    bike_id,
    bike_code,
    status
FROM bike
WHERE bike_code = 'SEOUL-BIKE-010';

notee


-- =========================================================
-- Query 14
-- DELETE
-- 목적: 아직 반납되지 않은 테스트 대여 기록을 삭제하고 전후를 확인한다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_14.txt

SELECT
    rental_id,
    rider_id,
    bike_id,
    rental_status,
    return_station_id
FROM rental
WHERE rental_status = 'rented'
  AND return_station_id IS NULL;

DELETE FROM rental
WHERE rental_status = 'rented'
  AND return_station_id IS NULL;

SELECT
    rental_id,
    rider_id,
    bike_id,
    rental_status,
    return_station_id
FROM rental
WHERE rental_status = 'rented'
  AND return_station_id IS NULL;

notee


-- =========================================================
-- Query 15
-- INDEX
--
-- 목적:
-- 실제 서비스에서는 대여 기록이 많이 누적될 수 있다.
-- rented_at 은 기간 검색, 최신순 조회, 시간순 정렬 등에
-- 자주 사용될 수 있으므로 인덱스를 생성한다.
--
-- MySQL InnoDB의 일반 인덱스는 B+Tree 기반이다.
-- =========================================================

tee C:/Users/kwonu/Desktop/codyssey/codyssey-b6-1/results/query_15.txt

CREATE INDEX idx_rental_rented_at
ON rental (rented_at);

SHOW INDEX
FROM rental
WHERE Key_name = 'idx_rental_rented_at';

notee


-- =========================================================
-- 전체 완료
-- =========================================================

SELECT 'All 15 queries completed.' AS result;