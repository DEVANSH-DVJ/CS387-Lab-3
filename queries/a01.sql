WITH vpr
AS (
  SELECT venue_id,
    player_id,
    rank() OVER (
      PARTITION BY venue_id ORDER BY cnt DESC,
        player_name ASC
      ) AS rn
  FROM (
    SELECT v.venue_id,
      p.player_id,
      p.player_name,
      count(*) AS cnt
    FROM player AS p,
      match AS m,
      venue AS v
    WHERE p.player_id = m.man_of_match
      AND m.venue_id = v.venue_id
    GROUP BY v.venue_id,
      p.player_id
    ) AS vpc
  )
SELECT vpr.venue_id,
  v.venue_name,
  vpr.player_id,
  p.player_name
FROM vpr,
  venue AS v,
  player AS p
WHERE vpr.venue_id = v.venue_id
  AND vpr.player_id = p.player_id
  AND vpr.rn = 1;
