--CREATE TABLE dist_goal6 (
--    group_distance TEXT,
--    event TEXT,
--    type TEXT,
--	count_type INTEGER,
--	count_event INTEGER,
--	total_goals NUMERIC,
--	percentage_of_type NUMERIC,
--	percentage_of_goal_types NUMERIC,
--	percent_index INTEGER
--);
INSERT INTO dist_goal6 (group_distance, event, type, count_type, count_event, total_goals, percentage_of_type, percentage_of_goal_types, percent_index)
WITH YY AS(
	SELECT DISTINCT play_id, event, date, distance, type,
		CASE
		WHEN distance BETWEEN 0 AND 25.000 THEN '0 to 25'
		WHEN distance BETWEEN 25.0001 AND 50.0000 THEN '25 to 50'
		WHEN distance BETWEEN 50.0001 AND 75.0000 THEN '50 to 75'
		WHEN distance BETWEEN 75.0001 AND 100.0000 THEN '75 to 100'
		ELSE 'Out of range'
		END AS group_distance
	FROM transpose
	)
SELECT group_distance, event, type,
COUNT(type) AS count_type,
COUNT(event) AS count_event,
SUM(COUNT(event)) OVER (PARTITION BY group_distance) AS total_goals,
ROUND((COUNT(type) * 100.0) / SUM(COUNT(type)) OVER (PARTITION BY type), 2) AS percentage_of_type,
ROUND((COUNT(type) * 100.0) / SUM(COUNT(event)) OVER (PARTITION BY group_distance), 2) AS percentage_of_goal_types,
(ROUND((COUNT(type) * 100.0) / SUM(COUNT(type)) OVER (PARTITION BY type), 2) * ROUND((COUNT(type) * 100.0) / SUM(COUNT(event)) OVER (PARTITION BY group_distance) , 2))::int AS percent_index
FROM YY
WHERE event IN ('Goal') AND type IN ('Wrist Shot', 'Snap Shot', 'Slap Shot', 'Backhand', 'Tip-In', 'Deflected', 'Wrap-around')
GROUP BY group_distance, event, type
ORDER BY
  CASE 
    WHEN group_distance = '0 to 25' THEN 1
    WHEN group_distance = '25 to 50' THEN 2
    WHEN group_distance = '50 to 75' THEN 3
    WHEN group_distance = '75 to 100' THEN 4
    ELSE 5  -- 'Out of range' or other unexpected values can be placed last
  END