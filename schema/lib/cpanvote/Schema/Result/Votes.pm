package cpanvote::Schema::Result::Votes;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('Votes');

__PACKAGE__->add_columns(
    user_id => {
        data_type         => 'integer',
    },
    dist_id => {
        data_type   => 'integer',
    },
    vote => {
        data_type => 'integer',
        is_nullable => 1,
    },
    comment => {
        data_type => 'varchar',
        size => 140,
        is_nullable => 1,
    },
    instead_id => {
        data_type => 'integer',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key(qw/ user_id dist_id /);

__PACKAGE__->belongs_to( user => 'cpanvote::Schema::Result::Users', 'user_id' );
__PACKAGE__->belongs_to( dist => 'cpanvote::Schema::Result::Distributions', 'dist_id' );
__PACKAGE__->belongs_to( instead => 'cpanvote::Schema::Result::Distributions', 'instead_id' );


1;




