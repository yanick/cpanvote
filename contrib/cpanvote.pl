#!/usr/bin/perl 

use strict;
use warnings;

use Getopt::Long;
use REST::Client;
use JSON;

GetOptions(
    'yeah!'      => \my $yeah,
    'neah!'      => \my $neah,
    'meh!'       => \my $meh,
    'instead=s'  => \my $instead,
    'comment=s'  => \my $comment,
    'user=s'     => \my $username,
    'password=s' => \my $password,
    'register!'  => \my $register,
);


die "user and password required\n" unless $username and $password;

my $client = REST::Client->new( follow => 1, useragent => My::Agent->new );
$client->setHost('http://localhost:3000');

exit register_user() if $register;

die "has to use exactly use one of --yeah, --neah or --meh"
  if 1 != grep { defined $_ } $yeah, $neah, $meh;

my $dist = shift;

$dist =~ s/::/-/g;

my $vote = $yeah ? 1 : $neah ? -1 : 0;


my %data;

$data{vote}    = $vote;
$data{comment} = $comment if $comment;
$data{instead} = $instead if $instead;

$client->PUT(
    "dist/$dist/vote",
    encode_json( \%data ),
    { 'content-type' => 'application/json' } );

print $client->responseContent;

sub register_user {
    my %data = (
        username => $username,
        password => $password,
    );

    $client->PUT(
        'register',
        encode_json( \%data ),
        { 'content-type' => 'application/json' } );

    print $client->responseContent, "\n";
}

package My::Agent;

use parent 'LWP::UserAgent';

sub get_basic_credentials {
    return ( 'yanick', 'foo' );
}

1;

