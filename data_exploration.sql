-- Check dates from combined trip data
SELECT DISTINCT EXTRACT(YEAR FROM STARTED_AT) AS YEAR, 
EXTRACT(MONTH FROM STARTED_AT) AS MONTH, 
EXTRACT(DAY FROM STARTED_AT) AS DAY
FROM COMBINED_TRIPDATA
ORDER BY YEAR, MONTH, DAY;

-- 1. ride_id

-- check length for ride_id
SELECT LENGTH(ride_id), COUNT(*) 
FROM COMBINED_TRIPDATA
GROUP BY LENGTH(ride_id);

-- it's length results in 16 letters and they all have the same length

-- check if they're unique
SELECT COUNT(DISTINCT ride_id) FROM COMBINED_TRIPDATA;

-- it produces 5.779.444 rows, same as all data combined, which is all ride_id is unique

-- 2. rideable_type

-- checking each type of bike
SELECT DISTINCT rideable_type FROM COMBINED_TRIPDATA;

-- it results in 3 different type of bike: classic_bike, docked_bike, and electric_bike

-- checking each bike number of rides
SELECT member_casual, rideable_type, COUNT(*)
FROM COMBINED_TRIPDATA
GROUP BY rideable_type;

-- i found docked_bike used by casual riders only, as it has 2% of overall data (141.535), i will change it to classic_bike

--  3. started_at and ended_at

-- check if there are null value
SELECT ride_id, started_at, ended_at
FROM COMBINED_TRIPDATA
WHERE started_at IS NULL OR ended_at IS NULL;

-- no null in these columns

-- check if there are rides that less than/equal to one minute or greater than/equal to one day
SELECT ride_id, started_at, ended_at, EXTRACT(EPOCH FROM (ended_at - started_at)) AS time_difference
FROM COMBINED_TRIPDATA
WHERE EXTRACT(EPOCH FROM (ended_at - started_at)) <= 60
OR EXTRACT(EPOCH FROM (ended_at - started_at)) >= 86400;

-- it produces 155.873 rows, we will remove this, as we only want ride with more than 
-- one minute and less than one day

-- 4. start_station_name, and start_station_id, end_station_name, and end_station_id
SELECT rideable_type, start_station_name, start_station_id, end_station_name, end_station_id
FROM COMBINED_TRIPDATA
WHERE (rideable_type = 'classic_bike' OR rideable_type = 'docked_bike') AND
(start_station_name IS NULL AND start_station_id IS NULL
OR end_station_name IS NULL AND end_station_id IS NULL);

-- it produces  5856 rows, we will remove this, because i assume classic_bike and docked_bike must start and
-- in a station, but electric_bike mustn't as when i query it produces a lot of rows (1.364.243 rows)
-- Stony Island Ave & 63rd St and Elizabeth St & Randolph St don't have station_id

-- checking station naming inconsistencies
SELECT DISTINCT start_station_name
FROM COMBINED_TRIPDATA;

SELECT DISTINCT TRIM(start_station_name)
FROM COMBINED_TRIPDATA;

SELECT DISTINCT end_station_name
FROM COMBINED_TRIPDATA;

SELECT DISTINCT TRIM(end_station_name)
FROM COMBINED_TRIPDATA;

-- they produce the same amount of rows, so there were no leading or trailing spaces

-- 5. start_lat, start_lng, end_lat, and end_lng
SELECT start_lat, start_lng, end_lat, end_lng
FROM COMBINED_TRIPDATA
WHERE start_lat IS NULL OR start_lng IS NULL
OR end_lat IS NULL OR end_lng IS NULL;
-- it produces 5795 rows, we will remove this null values within latitude and longitude

-- 6. member_casual
-- make sure there are exactly two members, casual and member
SELECT DISTINCT member_casual
FROM COMBINED_TRIPDATA;