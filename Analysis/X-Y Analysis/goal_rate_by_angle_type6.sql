WITH YY AS(
	SELECT DISTINCT play_id, event, date, angle, type,
		CASE
		WHEN angle BETWEEN -90 AND -70.0001 THEN 'a -90 to -70'
		WHEN angle BETWEEN -70.0000 AND -50.0001 THEN 'b -70 to -50'
		WHEN angle BETWEEN -50.0000 AND -30.0001 THEN 'c -50 to -30'
		WHEN angle BETWEEN -30.0000 AND -10.0001 THEN 'd -30 to -10'
		WHEN angle BETWEEN -10.0000 AND 10.0000 THEN 'e  -10 to 10'
		WHEN angle BETWEEN 10.0001 AND 30.0000 THEN 'f   10 to 30'
    	WHEN angle BETWEEN 30.0001 AND 50.0000 THEN 'g   30 to 50'
    	WHEN angle BETWEEN 50.0001 AND 70.0000 THEN 'h   50 to 70'
    	WHEN angle BETWEEN 70.0001 AND 90 THEN 'i   70 to 90'
    	ELSE 'Out of range'  -- Handles any angles outside 0-90, just in case
  		END AS group_angle
	FROM transpose
	)
SELECT group_angle, event, type,
	COUNT(type) AS count_type, 
	COUNT(event) AS count_event,
	SUM(COUNT(event)) OVER (PARTITION BY group_angle) AS total_goals,
	ROUND((COUNT(type) * 100.0) / SUM(COUNT(type)) OVER (PARTITION BY type), 2) AS percentage_of_type,
	ROUND((COUNT(type) * 100.0) / SUM(COUNT(event)) OVER (PARTITION BY group_angle), 2) AS percentage_of_goal_types,
	(ROUND((COUNT(type) * 100.0) / SUM(COUNT(type)) OVER (PARTITION BY type), 2) * ROUND((COUNT(type) * 100.0) / SUM(COUNT(event)) OVER (PARTITION BY group_angle) , 2))::int AS percent_index
--	SUM(COUNT(type)) OVER (PARTITION BY group_angle, type) AS sum_of_shot_type,
--	ROUND(COUNT(type)/SUM(COUNT(type)) OVER (PARTITION BY group_angle, type), 2) AS percentage_a
--ROUND((COUNT(types) * 100.0) / COUNT(goals), 2) AS percentage_of_goal_types,
--ROUND((COUNT(goals) * 100.0) / SUM(COUNT(goals)) OVER (), 2) AS percentage_of_goals,
--COUNT(shots) AS shots, ROUND((COUNT(shots) * 100.0) / SUM(COUNT(shots)) OVER (), 2) AS percentage_of_shots,
--ROUND((COUNT(goals) * 100.0)/COUNT(shots), 2) AS goal_rate
FROM YY
--WHERE event IN ('Shot', 'Missed Shot', 'Blocked Shot', 'Goal') AND type IN ('Wrist Shot', 'Snap Shot', 'Slap Shot', 'Backhand', 'Tip-In', 'Deflected', 'Wrap-around')
--WHERE event IN ('Shot', 'Missed Shot', 'Blocked Shot', 'Goal') AND type IN ('Tip-In')
WHERE event IN ('Goal') AND type IN ('Wrist Shot', 'Snap Shot', 'Slap Shot', 'Backhand', 'Tip-In', 'Deflected', 'Wrap-around')
GROUP BY group_angle, event, type
ORDER BY 
  CASE 
    WHEN group_angle = 'a -90 to -70' THEN 1
    WHEN group_angle = 'b -70 to -50' THEN 2
    WHEN group_angle = 'c -50 to -30' THEN 3
    WHEN group_angle = 'd -30 to -10' THEN 4
	WHEN group_angle = 'e  -10 to 10' THEN 5
	WHEN group_angle = 'f   10 to 30' THEN 6
    WHEN group_angle = 'g   30 to 50' THEN 7
    WHEN group_angle = 'h   50 to 70' THEN 8
    WHEN group_angle = 'i   70 to 90' THEN 9
    ELSE 10  -- 'Out of range' or other unexpected values can be placed last
  END