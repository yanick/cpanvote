#!/usr/bin/env perl

use strict;
use warnings;
use cpanvote::Schema;

my $schema = cpanvote::Schema->connect('dbi:SQLite:mydb');

$dh->deploy;
