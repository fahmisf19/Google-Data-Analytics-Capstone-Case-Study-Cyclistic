-- 1. perbandingan jenis bike vs member type
SELECT member_casual, rideable_type, COUNT(*) AS total_trip 
FROM COMBINED_CLEANED_TRIPDATA
GROUP BY member_casual, rideable_type;

-- 2. perbandingan bulan vs member type
SELECT member_casual, month, COUNT(*) AS total_trip
FROM COMBINED_CLEANED_TRIPDATA
GROUP BY member_casual, month;

-- 3. perbandingan hari dalam minggu vs member type
SELECT member_casual, day_of_week, COUNT(*) AS total_trip
FROM COMBINED_CLEANED_TRIPDATA
GROUP BY member_casual, day_of_week;

-- 4. perbandingan waktu dalam hari vs member type
SELECT member_casual, hour, COUNT(*) AS total_trip 
FROM COMBINED_CLEANED_TRIPDATA
GROUP BY member_casual, hour;

-- 5. avg end time - start time as avg ride length vs member type
SELECT member_casual, AVG(ride_time) AS average_ride_time
FROM COMBINED_CLEANED_TRIPDATA
GROUP BY member_casual;

-- 6. start lat lng vs member type
SELECT start_station_name,
    AVG(start_lat) AS start_lat, 
    AVG(start_lng) AS start_lng,  
    count(*) AS num_of_rides
FROM COMBINED_CLEANED_TRIPDATA
WHERE member_casual = 'casual'
GROUP BY start_station_name;

SELECT start_station_name,
    ROUND(AVG(CAST(start_lat AS numeric)), 4) AS start_lat, 
    ROUND(AVG(CAST(start_lng AS numeric)), 4) AS start_lng,  
    count(*) AS num_of_rides
FROM COMBINED_CLEANED_TRIPDATA
WHERE member_casual = 'casual'
GROUP BY start_station_name;

SELECT start_station_name,
    AVG(start_lat) AS start_lat, 
    AVG(start_lng) AS start_lng,  
    count(*) AS num_of_rides
FROM COMBINED_CLEANED_TRIPDATA
WHERE member_casual = 'member'
GROUP BY start_station_name;

-- 7. end lat lng vs member type

SELECT end_station_name,
    AVG(end_lat) AS end_lat, 
    AVG(end_lng) AS end_lng,  
    count(*) AS num_of_rides
FROM COMBINED_CLEANED_TRIPDATA
WHERE member_casual = 'casual'
GROUP BY end_station_name;

SELECT end_station_name,
    AVG(end_lat) AS end_lat, 
    AVG(end_lng) AS end_lng,  
    count(*) AS num_of_rides
FROM COMBINED_CLEANED_TRIPDATA
WHERE member_casual = 'member'
GROUP BY end_station_name;