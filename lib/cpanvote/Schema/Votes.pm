package cpanvote::Schema::Votes;

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
    },
    comment => {
        data_type => 'varchar',
        size => 140,
    },
    instead => {
        data_type => 'integer',
    },
);

__PACKAGE__->set_primary_key(qw/ user_id dist_id /);

__PACKAGE__->belongs_to( user => 'cpanvote::Schema::Users', 'user_id' );
__PACKAGE__->belongs_to( dist => 'cpanvote::Schema::Distributions', 'dist_id' );


1;




