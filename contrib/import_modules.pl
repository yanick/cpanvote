#!/usr/bin/perl 

use strict;
use warnings;

use 5.010;

use Data::Dumper;
use DBI;

my $dbh = DBI->connect('dbi:SQLite:dbname=/home/yanick/.cpan/cpandb.sql');

use cpanvote::Schema;

my $schema = cpanvote::Schema->connect( 'dbi:SQLite:dbname=db.sqlite' );

my $c = $dbh->prepare( 'SELECT dist_name from dists' );
$c->execute;

while ( my ( $distname ) = $c->fetchrow ) {
    next if $schema->resultset('Distributions')->find({distname => $distname});

    say "creating entry for $distname";
    $schema->resultset('Distributions')->create({distname => $distname });
}
