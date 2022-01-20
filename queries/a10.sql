WITH momm
AS (
  SELECT match_id,
    over_id,
    row_number() OVER (
      PARTITION BY match_id ORDER BY runs DESC,
        over_id ASC
      ) AS maxrn,
    row_number() OVER (
      PARTITION BY match_id ORDER BY runs ASC,
        over_id ASC
      ) AS minrn
  FROM (
    SELECT match_id,
      over_id,
      sum(runs_scored + extra_runs) AS runs
    FROM ball_by_ball
    GROUP BY match_id,
      innings_no,
      over_id
    ) AS mor
  )
SELECT match_id,
  over_id
FROM momm
WHERE maxrn = 1
  OR minrn = 1;
