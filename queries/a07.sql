WITH pr
AS (
  SELECT player_name,
    rank() OVER (
      ORDER BY ps.sixes DESC,
        p.player_name ASC
      ) AS rn
  FROM (
    SELECT b.striker AS player_id,
      count(*) AS sixes
    FROM ball_by_ball AS b,
      match AS m
    WHERE m.match_id = b.match_id
      AND m.season_year = 2013
      AND b.runs_scored = 6
    GROUP BY b.striker
    ) AS ps,
    player AS p
  WHERE ps.player_id = p.player_id
  )
SELECT player_name
FROM pr
WHERE rn <= 5
ORDER BY rn ASC;
