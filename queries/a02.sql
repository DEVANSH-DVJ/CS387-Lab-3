WITH sr
AS (
  SELECT striker,
    avg_runs,
    rank() OVER (
      ORDER BY avg_runs DESC
      ) AS rn
  FROM (
    SELECT striker,
      sum(runs_scored) * 1.0 / count(DISTINCT match_id) * 1.0 AS avg_runs
    FROM ball_by_ball
    GROUP BY striker
    ) AS sa
  )
SELECT p.player_id,
  p.player_name,
  sr.avg_runs
FROM player AS p,
  sr
WHERE p.player_id = sr.striker
  AND sr.rn <= 10
ORDER BY sr.rn ASC;
