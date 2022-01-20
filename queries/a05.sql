WITH mp2r3rn
AS (
  WITH mp2r3 AS (
      WITH msnr AS (
          SELECT match_id,
            striker,
            non_striker,
            sum(runs_scored) AS runs
          FROM ball_by_ball
          GROUP BY match_id,
            striker,
            non_striker
          )
      SELECT msnr1.match_id AS match_id,
        msnr1.striker AS p1,
        msnr2.striker AS p2,
        msnr1.runs AS r1,
        msnr2.runs AS r2,
        msnr1.runs + msnr2.runs AS pship_runs
      FROM msnr AS msnr1,
        msnr AS msnr2
      WHERE msnr1.match_id = msnr2.match_id
        AND msnr1.striker = msnr2.non_striker
        AND msnr1.non_striker = msnr2.striker
        AND (
          (msnr1.runs > msnr2.runs)
          OR (
            msnr1.runs = msnr2.runs
            AND msnr1.striker > msnr2.striker
            )
          )
      )
  SELECT *,
    rank() OVER (
      PARTITION BY match_id ORDER BY pship_runs DESC
      ) AS rn
  FROM mp2r3
  )
SELECT match_id,
  p1,
  p2,
  r1,
  r2,
  pship_runs
FROM mp2r3rn
WHERE rn = 1
ORDER BY pship_runs DESC,
  match_id ASC;
