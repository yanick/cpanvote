-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Jan 23 15:33:29 2011
-- 
;
SET foreign_key_checks=0;
--
-- Table: `Distributions`
--
CREATE TABLE `Distributions` (
  `id` integer NOT NULL auto_increment,
  `distname` varchar(30) NOT NULL,
  `foo` varchar(30),
  PRIMARY KEY (`id`),
  UNIQUE `unique_distname` (`distname`)
) ENGINE=InnoDB;
--
-- Table: `Sessions`
--
CREATE TABLE `Sessions` (
  `id` varchar(72) NOT NULL,
  `session_data` text,
  `expires` integer,
  PRIMARY KEY (`id`)
);
--
-- Table: `Users`
--
CREATE TABLE `Users` (
  `id` integer NOT NULL auto_increment,
  `username` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `unique_username` (`username`)
) ENGINE=InnoDB;
--
-- Table: `Auth`
--
CREATE TABLE `Auth` (
  `user_id` integer,
  `protocol` varchar(10) NOT NULL,
  `credential` varchar(20) NOT NULL,
  INDEX `Auth_idx_user_id` (`user_id`),
  PRIMARY KEY (`protocol`, `credential`),
  CONSTRAINT `Auth_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB;
--
-- Table: `Tags`
--
CREATE TABLE `Tags` (
  `id` integer NOT NULL auto_increment,
  `user_id` integer,
  `name` varchar(20) NOT NULL,
  INDEX `Tags_idx_user_id` (`user_id`),
  PRIMARY KEY (`id`),
  UNIQUE `unique_row` (`user_id`, `name`),
  CONSTRAINT `Tags_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB;
--
-- Table: `Votes`
--
CREATE TABLE `Votes` (
  `user_id` integer NOT NULL,
  `dist_id` integer NOT NULL,
  `vote` integer,
  `comment` varchar(140),
  `instead_id` integer,
  INDEX `Votes_idx_dist_id` (`dist_id`),
  INDEX `Votes_idx_instead_id` (`instead_id`),
  INDEX `Votes_idx_user_id` (`user_id`),
  PRIMARY KEY (`user_id`, `dist_id`),
  CONSTRAINT `Votes_fk_dist_id` FOREIGN KEY (`dist_id`) REFERENCES `Distributions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `Votes_fk_instead_id` FOREIGN KEY (`instead_id`) REFERENCES `Distributions` (`id`),
  CONSTRAINT `Votes_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
--
-- Table: `TagDist`
--
CREATE TABLE `TagDist` (
  `tag_id` integer NOT NULL,
  `dist_id` integer NOT NULL,
  INDEX `TagDist_idx_dist_id` (`dist_id`),
  INDEX `TagDist_idx_tag_id` (`tag_id`),
  PRIMARY KEY (`tag_id`, `dist_id`),
  CONSTRAINT `TagDist_fk_dist_id` FOREIGN KEY (`dist_id`) REFERENCES `Distributions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `TagDist_fk_tag_id` FOREIGN KEY (`tag_id`) REFERENCES `Tags` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;
SET foreign_key_checks=1