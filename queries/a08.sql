WITH mbw
AS (
  SELECT match_id,
    bowler,
    sum(CASE 
        WHEN out_type NOT IN ('run out', 'retired hurt')
          AND out_type IS NOT NULL
          THEN 1
        ELSE 0
        END) AS wickets
  FROM ball_by_ball
  GROUP BY match_id,
    bowler
  )
SELECT DISTINCT(p.player_name)
FROM player AS p,
  mbw
WHERE p.player_id = mbw.bowler
  AND mbw.wickets >= 5
ORDER BY p.player_name;
