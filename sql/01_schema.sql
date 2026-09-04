-- Codyssey B6-1
-- 주제: 서울시 공공자전거 따릉이 대여 관리 데이터베이스
-- DBMS: MySQL 8.0

CREATE DATABASE IF NOT EXISTS codyssey_db
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE codyssey_db;

-- 재실행을 고려하여 자식 테이블부터 삭제
DROP TABLE IF EXISTS rental;
DROP TABLE IF EXISTS bike;
DROP TABLE IF EXISTS station;
DROP TABLE IF EXISTS rider;

-- 1. 따릉이 이용자
CREATE TABLE rider (
    rider_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '이용자 ID',
    name VARCHAR(100) NOT NULL COMMENT '이용자 이름',
    email VARCHAR(255) NOT NULL UNIQUE COMMENT '이메일',
    membership_type VARCHAR(30) NOT NULL COMMENT '회원 유형',
    joined_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '가입 일시'
) COMMENT='따릉이 이용자';

-- 2. 따릉이 자전거
CREATE TABLE bike (
    bike_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '자전거 ID',
    bike_code VARCHAR(50) NOT NULL UNIQUE COMMENT '자전거 식별 코드',
    model_name VARCHAR(100) COMMENT '자전거 모델명',
    status VARCHAR(30) NOT NULL COMMENT '자전거 상태',
    registered_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '등록 일시'
) COMMENT='따릉이 자전거';

-- 3. 따릉이 대여소
CREATE TABLE station (
    station_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '대여소 ID',
    station_name VARCHAR(150) NOT NULL COMMENT '대여소 이름',
    district VARCHAR(50) NOT NULL COMMENT '자치구',
    latitude DECIMAL(9,6) COMMENT '위도',
    longitude DECIMAL(9,6) COMMENT '경도',
    rack_count INT COMMENT '거치대 수'
) COMMENT='따릉이 대여소';

-- 4. 따릉이 대여 기록
CREATE TABLE rental (
    rental_id INT AUTO_INCREMENT PRIMARY KEY COMMENT '대여 기록 ID',

    rider_id INT NOT NULL COMMENT '이용자 ID',
    bike_id INT NOT NULL COMMENT '자전거 ID',
    rental_station_id INT NOT NULL COMMENT '대여 대여소 ID',
    return_station_id INT COMMENT '반납 대여소 ID',

    rented_at DATETIME NOT NULL COMMENT '대여 일시',
    returned_at DATETIME COMMENT '반납 일시',
    distance_m INT COMMENT '이동 거리(m)',
    rental_status VARCHAR(30) NOT NULL COMMENT '대여 상태',

    CONSTRAINT fk_rental_rider
        FOREIGN KEY (rider_id)
        REFERENCES rider(rider_id),

    CONSTRAINT fk_rental_bike
        FOREIGN KEY (bike_id)
        REFERENCES bike(bike_id),

    CONSTRAINT fk_rental_station
        FOREIGN KEY (rental_station_id)
        REFERENCES station(station_id),

    CONSTRAINT fk_return_station
        FOREIGN KEY (return_station_id)
        REFERENCES station(station_id)
) COMMENT='따릉이 대여 기록';