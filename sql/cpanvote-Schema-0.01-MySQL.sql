-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Sun Feb 14 16:22:47 2010
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `Distributions`;

--
-- Table: `Distributions`
--
CREATE TABLE `Distributions` (
  `id` integer NOT NULL auto_increment,
  `distname` varchar(30) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `unique_distname` (`distname`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `Users`;

--
-- Table: `Users`
--
CREATE TABLE `Users` (
  `id` integer NOT NULL auto_increment,
  `username` varchar(20) NOT NULL,
  `password` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE `unique_username` (`username`)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS `Votes`;

--
-- Table: `Votes`
--
CREATE TABLE `Votes` (
  `user_id` integer NOT NULL,
  `dist_id` integer NOT NULL,
  `vote` integer NOT NULL,
  `comment` varchar(140) NOT NULL,
  `instead` integer NOT NULL,
  INDEX Votes_idx_dist_id (`dist_id`),
  INDEX Votes_idx_user_id (`user_id`),
  PRIMARY KEY (`user_id`, `dist_id`),
  CONSTRAINT `Votes_fk_dist_id` FOREIGN KEY (`dist_id`) REFERENCES `Distributions` (`id`),
  CONSTRAINT `Votes_fk_user_id` FOREIGN KEY (`user_id`) REFERENCES `Users` (`id`)
) ENGINE=InnoDB;

SET foreign_key_checks=1;

