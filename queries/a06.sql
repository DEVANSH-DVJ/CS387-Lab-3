WITH mior
AS (
  SELECT match_id,
    innings_no,
    over_id,
    sum(runs_scored + extra_runs) AS runs
  FROM ball_by_ball
  GROUP BY match_id,
    innings_no,
    over_id
  HAVING sum(runs_scored + extra_runs) > 12
  )
SELECT mior.match_id,
  mior.innings_no,
  mior.over_id
FROM mior,
  match
WHERE mior.match_id = match.match_id
  AND match.win_type = 'runs';
