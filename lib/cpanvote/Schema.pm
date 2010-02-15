package cpanvote::Schema;

use strict;
use warnings;

use base qw/DBIx::Class::Schema::Versioned/;

our $VERSION = '0.01';

__PACKAGE__->load_namespaces;
__PACKAGE__->upgrade_directory('/home/yanick/work/perl-modules/cpanvote/sql');

1;
