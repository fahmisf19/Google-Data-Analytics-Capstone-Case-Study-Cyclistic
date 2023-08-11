-- removing trip that less than one minute and more than one day
CREATE TEMP TABLE REMOVE_ID_TIME_ROWS AS
(
    SELECT ride_id
    FROM COMBINED_TRIPDATA
    WHERE EXTRACT(EPOCH FROM (ended_at - started_at)) <= 60
    OR EXTRACT(EPOCH FROM (ended_at - started_at)) >= 86400
);

CREATE TEMP TABLE CLEANED_TIME AS
(
    SELECT *
    FROM COMBINED_TRIPDATA
    WHERE ride_id NOT IN
    (
        SELECT ride_id
        FROM REMOVE_ID_TIME_ROWS
    )
);

-- remove trip where rideable_type are classic_bike and docked_bike and they don't have start or end 
-- station
CREATE TEMP TABLE REMOVE_ID_NULL_STATION AS
(
    SELECT ride_id
    FROM CLEANED_TIME
    WHERE (rideable_type = 'classic_bike' OR rideable_type = 'docked_bike') AND
    (start_station_name IS NULL AND start_station_id IS NULL
    OR end_station_name IS NULL AND end_station_id IS NULL)
);

CREATE TEMP TABLE CLEANED_TIME_STATION AS
(
    SELECT *
    FROM CLEANED_TIME
    WHERE ride_id NOT IN
    (
        SELECT ride_id
        FROM REMOVE_ID_NULL_STATION
    )
);

-- remove trips that had null vales in either its start_lat, start_ltd, end_lat, end_ltd
CREATE TEMP TABLE REMOVE_ID_NULL_LAT_LTD AS
(
    SELECT ride_id
    FROM CLEANED_TIME_STATION
    WHERE start_lat IS NULL OR start_lng IS NULL
    OR end_lat IS NULL OR end_lng IS NULL
);

CREATE TABLE COMBINED_CLEANED_TRIPDATA AS
SELECT ride_id, 
REPLACE(rideable_type, 'docked_bike', 'classic_bike') AS rideable_type,
started_at, ended_at, EXTRACT(EPOCH FROM (ended_at - started_at))/60 AS ride_time,
CASE
    WHEN EXTRACT(MONTH FROM started_at) = 1 THEN 'January'
    WHEN EXTRACT(MONTH FROM started_at) = 2 THEN 'February'
    WHEN EXTRACT(MONTH FROM started_at) = 3 THEN 'March'
    WHEN EXTRACT(MONTH FROM started_at) = 4 THEN 'April'
    WHEN EXTRACT(MONTH FROM started_at) = 5 THEN 'May'
    WHEN EXTRACT(MONTH FROM started_at) = 6 THEN 'June'
    WHEN EXTRACT(MONTH FROM started_at) = 7 THEN 'July'
    WHEN EXTRACT(MONTH FROM started_at) = 8 THEN 'August'
    WHEN EXTRACT(MONTH FROM started_at) = 9 THEN 'September'
    WHEN EXTRACT(MONTH FROM started_at) = 10 THEN 'October'
    WHEN EXTRACT(MONTH FROM started_at) = 11 THEN 'November'
    ELSE 'December'
END AS month,
CASE
    WHEN EXTRACT(isodow FROM started_at) = 1 THEN 'Monday'
    WHEN EXTRACT(isodow FROM started_at) = 2 THEN 'Tuesday'
    WHEN EXTRACT(isodow FROM started_at) = 3 THEN 'Wednesday'
    WHEN EXTRACT(isodow FROM started_at) = 4 THEN 'Thursday'
    WHEN EXTRACT(isodow FROM started_at) = 5 THEN 'Friday'
    WHEN EXTRACT(isodow FROM started_at) = 6 THEN 'Saturday'
    ELSE'Sunday' 
END AS day_of_week,
EXTRACT(HOUR FROM started_at) AS hour,
start_station_name, start_station_id, end_station_name, end_station_id,
start_lat, start_lng, end_lat, end_lng, member_casual
FROM CLEANED_TIME_STATION
WHERE ride_id NOT IN
(
    SELECT ride_id
    FROM REMOVE_ID_NULL_LAT_LTD
);
