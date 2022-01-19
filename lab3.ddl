DROP TABLE ball_by_ball;

DROP TABLE player_match;

DROP TABLE match;

DROP TABLE team;

DROP TABLE player;

DROP TABLE venue;

--Team id and name
CREATE TABLE team (
  team_id INT,
  team_name TEXT,
  PRIMARY KEY (team_id)
  );

--Player information
CREATE TABLE player (
  player_id INT,
  player_name TEXT,
  dob DATE,
  batting_hand TEXT,
  bowling_skill TEXT,
  country_name TEXT,
  PRIMARY KEY (player_id)
  );

--Venue information
CREATE TABLE venue (
  venue_id INT,
  venue_name TEXT,
  city_name TEXT,
  country_name TEXT,
  PRIMARY KEY (venue_id)
  );

--Match information
CREATE TABLE match (
  match_id INT,
  season_year INT,
  team1 INT,
  team2 INT,
  venue_Id INT,
  toss_winner INT,
  match_winner INT,
  toss_name TEXT CHECK (
    toss_name = 'field'
    OR toss_name = 'bat'
    ),
  win_type TEXT CHECK (
    win_type = 'wickets'
    OR win_type = 'runs'
    OR win_type IS NULL
    ),
  man_of_match INT,
  win_margin INT,
  PRIMARY KEY (match_id),
  FOREIGN KEY (venue_id) REFERENCES venue ON DELETE SET NULL,
  FOREIGN KEY (team1) REFERENCES team ON DELETE SET NULL,
  FOREIGN KEY (team2) REFERENCES team ON DELETE SET NULL,
  FOREIGN KEY (toss_winner) REFERENCES team ON DELETE SET NULL,
  FOREIGN KEY (match_winner) REFERENCES team ON DELETE SET NULL,
  FOREIGN KEY (man_of_match) REFERENCES player ON DELETE SET NULL
  );

--For each match contains all players along with their role and team
CREATE TABLE player_match (
  playermatch_key BIGINT,
  match_id INT,
  player_id INT,
  role_desc TEXT CHECK (
    role_desc = 'Player'
    OR role_desc = 'Keeper'
    OR role_desc = 'CaptainKeeper'
    OR role_desc = 'Captain'
    ),
  team_id INT,
  PRIMARY KEY (playermatch_key),
  FOREIGN KEY (match_id) REFERENCES match ON DELETE SET NULL,
  FOREIGN KEY (player_id) REFERENCES player ON DELETE SET NULL,
  FOREIGN KEY (team_id) REFERENCES team ON DELETE SET NULL
  );

--Information for each ball
CREATE TABLE ball_by_ball (
  match_id INT,
  innings_no INT CHECK (
    innings_no = 1
    OR innings_no = 2
    ),
  over_id INT,
  ball_id INT,
  runs_scored INT CHECK (
    runs_scored BETWEEN 0
      AND 6
    ),
  extra_runs INT,
  out_type TEXT CHECK (
    out_type = 'caught'
    OR out_type = 'caught and bowled'
    OR out_type = 'bowled'
    OR out_type = 'stumped'
    OR out_type = 'retired hurt'
    OR out_type = 'keeper catch'
    OR out_type = 'lbw'
    OR out_type = 'run out'
    OR out_type = 'hit wicket'
    OR out_type IS NULL
    ),
  striker INT,
  non_striker INT,
  bowler INT,
  PRIMARY KEY (
    match_id,
    innings_no,
    over_id,
    ball_id
    ),
  FOREIGN KEY (match_id) REFERENCES match ON DELETE SET NULL,
  FOREIGN KEY (striker) REFERENCES player ON DELETE SET NULL,
  FOREIGN KEY (non_striker) REFERENCES player ON DELETE SET NULL,
  FOREIGN KEY (bowler) REFERENCES player ON DELETE SET NULL
  );
