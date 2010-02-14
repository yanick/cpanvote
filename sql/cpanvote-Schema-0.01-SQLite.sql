-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sun Feb 14 16:22:47 2010
-- 


BEGIN TRANSACTION;

--
-- Table: Distributions
--
DROP TABLE Distributions;

CREATE TABLE Distributions (
  id INTEGER PRIMARY KEY NOT NULL,
  distname varchar(30) NOT NULL
);

CREATE UNIQUE INDEX unique_distname ON Distributions (distname);

--
-- Table: Users
--
DROP TABLE Users;

CREATE TABLE Users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(20) NOT NULL,
  password varchar(20) NOT NULL
);

CREATE UNIQUE INDEX unique_username ON Users (username);

--
-- Table: Votes
--
DROP TABLE Votes;

CREATE TABLE Votes (
  user_id integer NOT NULL,
  dist_id integer NOT NULL,
  vote integer NOT NULL,
  comment varchar(140) NOT NULL,
  instead integer NOT NULL,
  PRIMARY KEY (user_id, dist_id)
);

CREATE INDEX Votes_idx_dist_id ON Votes (dist_id);

CREATE INDEX Votes_idx_user_id ON Votes (user_id);

COMMIT;
