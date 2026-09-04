-- Codyssey B6-1
-- 핵심 SQL 쿼리 15개
-- DBMS: MySQL 8.0

USE codyssey_db;

-- =========================================================
-- 기본 조회 4개
-- =========================================================

-- Query 01
-- 목적: 마포구에 위치한 대여소를 조회한다.
SELECT
    station_id,
    station_name,
    district,
    rack_count
FROM station
WHERE district = '마포구';


-- Query 02
-- 목적: 이동 거리가 5km 이상인 완료 대여 기록을 조회한다.
SELECT
    rental_id,
    rider_id,
    bike_id,
    distance_m,
    rental_status
FROM rental
WHERE distance_m >= 5000
  AND rental_status = 'completed';


-- Query 03
-- 목적: 최근 대여 기록부터 내림차순으로 조회한다.
SELECT
    rental_id,
    rider_id,
    bike_id,
    rented_at,
    rental_status
FROM rental
ORDER BY rented_at DESC;


-- Query 04
-- 목적: 이동 거리가 가장 긴 대여 기록 5개를 조회한다.
SELECT
    rental_id,
    rider_id,
    bike_id,
    distance_m
FROM rental
WHERE distance_m IS NOT NULL
ORDER BY distance_m DESC
LIMIT 5;


-- =========================================================
-- JOIN 4개
-- =========================================================

-- Query 05
-- 목적: 대여 기록과 이용자 이름을 함께 조회한다.
SELECT
    r.rental_id,
    rd.name AS rider_name,
    r.rented_at,
    r.rental_status
FROM rental r
INNER JOIN rider rd
    ON r.rider_id = rd.rider_id;


-- Query 06
-- 목적: 대여 기록과 자전거 식별 코드를 함께 조회한다.
SELECT
    r.rental_id,
    b.bike_code,
    b.model_name,
    r.rented_at,
    r.returned_at
FROM rental r
INNER JOIN bike b
    ON r.bike_id = b.bike_id;


-- Query 07
-- 목적: 각 대여 기록의 출발 대여소와 반납 대여소 이름을 함께 조회한다.
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


-- Query 08
-- 목적: 대여 기록이 없는 이용자까지 포함하여 이용 횟수를 확인한다.
SELECT
    rd.rider_id,
    rd.name,
    COUNT(r.rental_id) AS rental_count
FROM rider rd
LEFT JOIN rental r
    ON rd.rider_id = r.rider_id
GROUP BY rd.rider_id, rd.name
ORDER BY rental_count DESC;


-- =========================================================
-- 집계 3개
-- =========================================================

-- Query 09
-- 목적: 이용자별 따릉이 이용 횟수를 집계한다.
SELECT
    rd.rider_id,
    rd.name,
    COUNT(r.rental_id) AS rental_count
FROM rider rd
INNER JOIN rental r
    ON rd.rider_id = r.rider_id
GROUP BY rd.rider_id, rd.name
ORDER BY rental_count DESC;


-- Query 10
-- 목적: 자전거별 총 이동 거리를 계산한다.
SELECT
    b.bike_id,
    b.bike_code,
    SUM(r.distance_m) AS total_distance_m
FROM bike b
INNER JOIN rental r
    ON b.bike_id = r.bike_id
WHERE r.distance_m IS NOT NULL
GROUP BY b.bike_id, b.bike_code
ORDER BY total_distance_m DESC;


-- Query 11
-- 목적: 출발 대여소별 평균 이동 거리를 계산한다.
SELECT
    s.station_id,
    s.station_name,
    AVG(r.distance_m) AS avg_distance_m
FROM station s
INNER JOIN rental r
    ON s.station_id = r.rental_station_id
WHERE r.distance_m IS NOT NULL
GROUP BY s.station_id, s.station_name
ORDER BY avg_distance_m DESC;


-- =========================================================
-- 서브쿼리 1개
-- =========================================================

-- Query 12
-- 목적: 전체 평균 이동 거리보다 더 멀리 이동한 대여 기록을 조회한다.
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


-- =========================================================
-- UPDATE / DELETE 2개
-- =========================================================

-- Query 13
-- 목적: 특정 자전거의 상태를 정비 중 상태로 변경한다.
UPDATE bike
SET status = 'maintenance'
WHERE bike_code = 'SEOUL-BIKE-010';

-- 변경 결과 확인
SELECT
    bike_id,
    bike_code,
    status
FROM bike
WHERE bike_code = 'SEOUL-BIKE-010';


-- Query 14
-- 목적: 아직 반납되지 않은 테스트 대여 기록을 삭제한다.
DELETE FROM rental
WHERE rental_status = 'rented'
  AND return_station_id IS NULL;

-- 삭제 결과 확인
SELECT *
FROM rental
WHERE rental_status = 'rented';


-- =========================================================
-- INDEX 1개
-- =========================================================

-- Query 15
-- 목적: 대여 시각을 기준으로 검색하거나 정렬하는 경우의 성능 향상을 위해 인덱스를 생성한다.
CREATE INDEX idx_rental_rented_at
ON rental (rented_at);

-- 인덱스 생성 확인
SHOW INDEX FROM rental;