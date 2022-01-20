DROP TABLE IF EXISTS ball_by_ball;

DROP TABLE IF EXISTS player_match;

DROP TABLE IF EXISTS match;

DROP TABLE IF EXISTS team;

DROP TABLE IF EXISTS player;

DROP TABLE IF EXISTS venue;

CREATE TABLE team (
  team_id INT,
  team_name TEXT,
  PRIMARY KEY (team_id)
  );

CREATE TABLE venue (
  venue_id INT,
  venue_name TEXT,
  city_name TEXT,
  country_name TEXT,
  PRIMARY KEY (venue_id)
  );

CREATE TABLE player (
  player_id INT,
  player_name TEXT,
  dob DATE,
  batting_hand TEXT,
  bowling_skill TEXT,
  country_name TEXT,
  PRIMARY KEY (player_id)
  );

CREATE TABLE match (
  match_id INT,
  season_year INT,
  team1 INT NOT NULL,
  team2 INT NOT NULL,
  venue_id INT NOT NULL,
  toss_winner INT NOT NULL,
  match_winner INT NOT NULL,
  toss_name TEXT,
  win_type TEXT,
  man_of_match INT NOT NULL,
  win_margin INT,
  PRIMARY KEY (match_id),
  FOREIGN KEY (team1) REFERENCES team(team_id),
  FOREIGN KEY (team2) REFERENCES team(team_id),
  FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
  FOREIGN KEY (toss_winner) REFERENCES team(team_id),
  FOREIGN KEY (match_winner) REFERENCES team(team_id),
  FOREIGN KEY (man_of_match) REFERENCES player(player_id)
  );

CREATE TABLE player_match (
  playermatch_key BIGINT,
  match_id INT NOT NULL,
  player_id INT NOT NULL,
  role_desc TEXT,
  team_id INT NOT NULL,
  PRIMARY KEY (playermatch_key),
  FOREIGN KEY (match_id) REFERENCES match(match_id),
  FOREIGN KEY (player_id) REFERENCES player(player_id),
  FOREIGN KEY (team_id) REFERENCES team(team_id)
  );

CREATE TABLE ball_by_ball (
  match_id INT NOT NULL,
  innings_no INT CHECK (innings_no > 0),
  over_id INT CHECK (over_id > 0),
  ball_id INT CHECK (ball_id > 0),
  runs_scored INT,
  extra_runs INT,
  out_type TEXT,
  striker INT NOT NULL,
  non_striker INT NOT NULL,
  bowler INT NOT NULL,
  PRIMARY KEY (
    match_id,
    innings_no,
    over_id,
    ball_id
    ),
  FOREIGN KEY (match_id) REFERENCES match(match_id),
  FOREIGN KEY (striker) REFERENCES player(player_id),
  FOREIGN KEY (non_striker) REFERENCES player(player_id),
  FOREIGN KEY (bowler) REFERENCES player(player_id)
  );
