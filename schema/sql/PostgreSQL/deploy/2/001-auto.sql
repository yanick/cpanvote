-- 
-- Created by SQL::Translator::Producer::PostgreSQL
-- Created on Sun Jan 23 15:33:29 2011
-- 
;
--
-- Table: Distributions
--
CREATE TABLE "Distributions" (
  "id" serial NOT NULL,
  "distname" character varying(30) NOT NULL,
  "foo" character varying(30),
  PRIMARY KEY ("id"),
  CONSTRAINT "unique_distname" UNIQUE ("distname")
);

;
--
-- Table: Sessions
--
CREATE TABLE "Sessions" (
  "id" character varying(72) NOT NULL,
  "session_data" text,
  "expires" integer,
  PRIMARY KEY ("id")
);

;
--
-- Table: Users
--
CREATE TABLE "Users" (
  "id" serial NOT NULL,
  "username" character varying(20) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "unique_username" UNIQUE ("username")
);

;
--
-- Table: Auth
--
CREATE TABLE "Auth" (
  "user_id" integer,
  "protocol" character varying(10) NOT NULL,
  "credential" character varying(20) NOT NULL,
  PRIMARY KEY ("protocol", "credential")
);
CREATE INDEX "Auth_idx_user_id" on "Auth" ("user_id");

;
--
-- Table: Tags
--
CREATE TABLE "Tags" (
  "id" serial NOT NULL,
  "user_id" integer,
  "name" character varying(20) NOT NULL,
  PRIMARY KEY ("id"),
  CONSTRAINT "unique_row" UNIQUE ("user_id", "name")
);
CREATE INDEX "Tags_idx_user_id" on "Tags" ("user_id");

;
--
-- Table: Votes
--
CREATE TABLE "Votes" (
  "user_id" integer NOT NULL,
  "dist_id" integer NOT NULL,
  "vote" integer,
  "comment" character varying(140),
  "instead_id" integer,
  PRIMARY KEY ("user_id", "dist_id")
);
CREATE INDEX "Votes_idx_dist_id" on "Votes" ("dist_id");
CREATE INDEX "Votes_idx_instead_id" on "Votes" ("instead_id");
CREATE INDEX "Votes_idx_user_id" on "Votes" ("user_id");

;
--
-- Table: TagDist
--
CREATE TABLE "TagDist" (
  "tag_id" integer NOT NULL,
  "dist_id" integer NOT NULL,
  PRIMARY KEY ("tag_id", "dist_id")
);
CREATE INDEX "TagDist_idx_dist_id" on "TagDist" ("dist_id");
CREATE INDEX "TagDist_idx_tag_id" on "TagDist" ("tag_id");

;
--
-- Foreign Key Definitions
--

;
ALTER TABLE "Auth" ADD FOREIGN KEY ("user_id")
  REFERENCES "Users" ("id") DEFERRABLE;

;
ALTER TABLE "Tags" ADD FOREIGN KEY ("user_id")
  REFERENCES "Users" ("id") DEFERRABLE;

;
ALTER TABLE "Votes" ADD FOREIGN KEY ("dist_id")
  REFERENCES "Distributions" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "Votes" ADD FOREIGN KEY ("instead_id")
  REFERENCES "Distributions" ("id") DEFERRABLE;

;
ALTER TABLE "Votes" ADD FOREIGN KEY ("user_id")
  REFERENCES "Users" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "TagDist" ADD FOREIGN KEY ("dist_id")
  REFERENCES "Distributions" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

;
ALTER TABLE "TagDist" ADD FOREIGN KEY ("tag_id")
  REFERENCES "Tags" ("id") ON DELETE CASCADE ON UPDATE CASCADE DEFERRABLE;

