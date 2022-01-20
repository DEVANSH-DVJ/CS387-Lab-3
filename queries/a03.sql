WITH bwbfr
AS (
  SELECT bowler,
    numwkts,
    numballs,
    (numwkts * 1.0 / numballs) * 6.0 AS frac,
    dense_rank() OVER (
      ORDER BY (numwkts * 1.0 / numballs) * 6.0 DESC
      ) AS rn
  FROM (
    SELECT bowler,
      sum(CASE 
          WHEN out_type NOT IN ('run out', 'retired hurt')
            AND out_type IS NOT NULL
            THEN 1
          ELSE 0
          END) AS numwkts,
      count(*) AS numballs
    FROM ball_by_ball
    GROUP BY bowler
    ) AS bwb
  )
SELECT p.player_id,
  p.player_name,
  bwbfr.numwkts,
  bwbfr.numballs,
  bwbfr.frac
FROM player AS p,
  bwbfr
WHERE p.player_id = bwbfr.bowler
  AND bwbfr.rn <= 5
ORDER BY bwbfr.rn ASC,
  p.player_id ASC;
