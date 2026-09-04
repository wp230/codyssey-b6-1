-- Codyssey B6-1
-- 샘플 데이터 입력 스크립트

USE codyssey_db;

-- 1. rider
INSERT INTO rider (name, email, membership_type, joined_at) VALUES
('김민수', 'minsu.kim@example.com', '정기권', '2026-01-05 09:15:00'),
('이서연', 'seoyeon.lee@example.com', '정기권', '2026-01-11 14:20:00'),
('박준호', 'junho.park@example.com', '일일권', '2026-02-02 11:05:00'),
('최유진', 'yujin.choi@example.com', '정기권', '2026-02-14 08:40:00'),
('정하늘', 'haneul.jung@example.com', '일일권', '2026-03-01 16:30:00'),
('강도윤', 'doyoon.kang@example.com', '정기권', '2026-03-19 10:10:00'),
('윤지우', 'jiwoo.yoon@example.com', '정기권', '2026-04-03 12:25:00'),
('한예린', 'yerin.han@example.com', '일일권', '2026-04-22 18:45:00'),
('오시우', 'siwoo.oh@example.com', '정기권', '2026-05-09 07:50:00'),
('임수빈', 'subin.lim@example.com', '일일권', '2026-05-21 13:35:00');

-- 2. bike
INSERT INTO bike (bike_code, model_name, status, registered_at) VALUES
('SEOUL-BIKE-001', '일반형', 'available', '2025-01-10 09:00:00'),
('SEOUL-BIKE-002', '일반형', 'available', '2025-01-10 09:05:00'),
('SEOUL-BIKE-003', '일반형', 'rented', '2025-01-12 10:00:00'),
('SEOUL-BIKE-004', '새싹형', 'available', '2025-01-15 11:00:00'),
('SEOUL-BIKE-005', '일반형', 'maintenance', '2025-01-20 13:00:00'),
('SEOUL-BIKE-006', '일반형', 'available', '2025-02-01 09:30:00'),
('SEOUL-BIKE-007', '새싹형', 'available', '2025-02-03 14:15:00'),
('SEOUL-BIKE-008', '일반형', 'rented', '2025-02-07 08:45:00'),
('SEOUL-BIKE-009', '일반형', 'available', '2025-02-15 16:10:00'),
('SEOUL-BIKE-010', '새싹형', 'available', '2025-02-21 12:00:00');

-- 3. station
INSERT INTO station
(station_name, district, latitude, longitude, rack_count) VALUES
('홍대입구역 2번출구', '마포구', 37.556010, 126.923630, 20),
('합정역 5번출구', '마포구', 37.549460, 126.913740, 15),
('신촌역 4번출구', '서대문구', 37.555130, 126.936890, 20),
('여의나루역 1번출구', '영등포구', 37.527100, 126.932900, 30),
('서울역 12번출구', '중구', 37.554680, 126.970610, 25),
('광화문역 6번출구', '종로구', 37.571700, 126.976300, 20),
('강남역 10번출구', '강남구', 37.497950, 127.027620, 30),
('잠실역 2번출구', '송파구', 37.513260, 127.100130, 25),
('건대입구역 1번출구', '광진구', 37.540370, 127.069230, 20),
('노원역 5번출구', '노원구', 37.655130, 127.061370, 15);

-- 4. rental
INSERT INTO rental (
    rider_id,
    bike_id,
    rental_station_id,
    return_station_id,
    rented_at,
    returned_at,
    distance_m,
    rental_status
) VALUES
(1, 1, 1, 3, '2026-09-01 08:10:00', '2026-09-01 08:32:00', 4200, 'completed'),
(2, 2, 2, 1, '2026-09-01 09:05:00', '2026-09-01 09:21:00', 2800, 'completed'),
(3, 3, 3, 5, '2026-09-01 10:20:00', '2026-09-01 11:02:00', 7100, 'completed'),
(4, 4, 4, 6, '2026-09-01 12:00:00', '2026-09-01 12:28:00', 5100, 'completed'),
(5, 6, 1, 2, '2026-09-02 07:45:00', '2026-09-02 08:00:00', 2300, 'completed'),
(1, 7, 3, 1, '2026-09-02 18:10:00', '2026-09-02 18:36:00', 3900, 'completed'),
(6, 8, 7, 4, '2026-09-03 08:30:00', '2026-09-03 09:12:00', 8500, 'completed'),
(7, 9, 8, 9, '2026-09-03 14:15:00', '2026-09-03 14:44:00', 4600, 'completed'),
(8, 10, 9, 8, '2026-09-03 17:00:00', '2026-09-03 17:31:00', 4900, 'completed'),
(9, 1, 6, 5, '2026-09-04 06:50:00', '2026-09-04 07:20:00', 5400, 'completed'),
(2, 2, 5, 6, '2026-09-04 09:10:00', '2026-09-04 09:27:00', 2500, 'completed'),
(10, 4, 10, 9, '2026-09-04 11:40:00', '2026-09-04 12:15:00', 6200, 'completed'),
(3, 6, 7, 8, '2026-09-04 13:00:00', '2026-09-04 13:19:00', 3200, 'completed'),
(4, 7, 4, 3, '2026-09-04 15:10:00', '2026-09-04 15:42:00', 5800, 'completed'),
(5, 8, 2, NULL, '2026-09-04 16:00:00', NULL, NULL, 'rented');

-- 데이터 개수 확인
SELECT COUNT(*) AS rider_count FROM rider;
SELECT COUNT(*) AS bike_count FROM bike;
SELECT COUNT(*) AS station_count FROM station;
SELECT COUNT(*) AS rental_count FROM rental;