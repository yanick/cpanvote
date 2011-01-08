-- Convert schema '/home/yanick/work/perl-modules/cpanvote/schema/dbicdh/_source/deploy/1/001-auto.yml' to '/home/yanick/work/perl-modules/cpanvote/schema/dbicdh/_source/deploy/2/001-auto.yml':;

;
BEGIN;

;
ALTER TABLE Distributions ADD COLUMN foo varchar(30);

;

COMMIT;

