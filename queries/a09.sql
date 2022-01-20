WITH tdn
AS (
  SELECT toss_winner AS team_id,
    count(*) AS den,
    count(CASE 
        WHEN toss_winner = match_winner
          THEN 1
        ELSE NULL
        END) AS num
  FROM match
  GROUP BY toss_winner
  )
SELECT t.team_name,
  round(tdn.num * 100.0 / tdn.den, 3)
FROM team AS t,
  tdn
WHERE t.team_id = tdn.team_id
  AND tdn.den > 0
  AND tdn.num > 0
ORDER BY t.team_name ASC;
