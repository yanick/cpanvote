#!/usr/bin/perl 

use strict;
use warnings;

use cpanvote::Schema;

my $c = cpanvote::Schema->connect( 'dbi:SQLite:dbname=./database.db' );

exit $c->deploy;




