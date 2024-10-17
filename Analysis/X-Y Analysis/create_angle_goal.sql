SELECT 
	a.group_angle,
    d.group_distance,
    a.event AS event_a,
	a.type AS type_a,
	d.event AS event_d,
	d.type AS type_d,
	a.percent_index,
	d.percent_index,
	a.percent_index * d.percent_index AS index
FROM 
	angle_goal6 a
CROSS JOIN 
    dist_goal6 d
--WHERE a.event = 'Goal' AND a.type = 'Tip-In' AND d.event = 'Goal' AND d.type = 'Tip-In'
ORDER BY
	CASE
	WHEN group_angle = 'a -90 to -70' THEN 1
    WHEN group_angle = 'b -70 to -50' THEN 2
    WHEN group_angle = 'c -50 to -30' THEN 3
    WHEN group_angle = 'd -30 to -10' THEN 4
	WHEN group_angle = 'e -10 to 10' THEN 5
	WHEN group_angle = 'f 10 to 30' THEN 6
    WHEN group_angle = 'g 30 to 50' THEN 7
    WHEN group_angle = 'h 50 to 70' THEN 8
    WHEN group_angle = 'i 70 to 90' THEN 9
  END,
	CASE 
    WHEN group_distance = '0 to 25' THEN 1
    WHEN group_distance = '25 to 50' THEN 2
    WHEN group_distance = '50 to 75' THEN 3
    WHEN group_distance = '75 to 100' THEN 4
  END