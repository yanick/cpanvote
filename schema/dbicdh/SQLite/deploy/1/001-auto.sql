-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue Jan  4 16:49:51 2011
-- 

;
BEGIN TRANSACTION;
--
-- Table: Distributions
--
CREATE TABLE Distributions (
  id INTEGER PRIMARY KEY NOT NULL,
  distname varchar(30) NOT NULL
);
CREATE UNIQUE INDEX unique_distname ON Distributions (distname);
--
-- Table: Users
--
CREATE TABLE Users (
  id INTEGER PRIMARY KEY NOT NULL,
  username varchar(20) NOT NULL,
  password varchar(20) NOT NULL
);
CREATE UNIQUE INDEX unique_username ON Users (username);
--
-- Table: Tags
--
CREATE TABLE Tags (
  id INTEGER PRIMARY KEY NOT NULL,
  user_id integer,
  name varchar(20) NOT NULL
);
CREATE INDEX Tags_idx_user_id ON Tags (user_id);
CREATE UNIQUE INDEX unique_row ON Tags (user_id, name);
--
-- Table: Votes
--
CREATE TABLE Votes (
  user_id integer NOT NULL,
  dist_id integer NOT NULL,
  vote integer,
  comment varchar(140),
  instead_id integer,
  PRIMARY KEY (user_id, dist_id)
);
CREATE INDEX Votes_idx_dist_id ON Votes (dist_id);
CREATE INDEX Votes_idx_instead_id ON Votes (instead_id);
CREATE INDEX Votes_idx_user_id ON Votes (user_id);
--
-- Table: TagDist
--
CREATE TABLE TagDist (
  tag_id integer NOT NULL,
  dist_id integer NOT NULL,
  PRIMARY KEY (tag_id, dist_id)
);
CREATE INDEX TagDist_idx_dist_id ON TagDist (dist_id);
CREATE INDEX TagDist_idx_tag_id ON TagDist (tag_id);
COMMIT