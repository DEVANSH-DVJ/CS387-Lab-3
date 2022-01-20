WITH ybrr
AS (
  SELECT year,
    batsman,
    runs,
    rank() OVER (
      PARTITION BY year ORDER BY runs DESC,
        batsman ASC
      ) AS rn
  FROM (
    SELECT m.season_year AS year,
      b.striker AS batsman,
      sum(b.runs_scored) AS runs
    FROM ball_by_ball AS b,
      match AS m
    WHERE b.match_id = m.match_id
    GROUP BY m.season_year,
      b.striker
    ) AS ysr
  ),
ybwr
AS (
  SELECT year,
    bowler,
    wickets,
    rank() OVER (
      PARTITION BY year ORDER BY wickets DESC,
        bowler ASC
      ) AS rn
  FROM (
    SELECT m.season_year AS year,
      b.bowler AS bowler,
      sum(CASE 
          WHEN out_type NOT IN ('run out', 'retired hurt')
            AND out_type IS NOT NULL
            THEN 1
          ELSE 0
          END) AS wickets
    FROM ball_by_ball AS b,
      match AS m
    WHERE b.match_id = m.match_id
    GROUP BY m.season_year,
      b.bowler
    ) AS ysr
  )
SELECT ybwr.year,
  ybrr.batsman,
  ybrr.runs,
  ybwr.bowler,
  ybwr.wickets
FROM ybrr,
  ybwr
WHERE ybwr.year = ybrr.year
  AND ybwr.rn = ybrr.rn
  AND ybwr.rn <= 3
ORDER BY ybwr.year ASC,
  ybwr.rn ASC;
