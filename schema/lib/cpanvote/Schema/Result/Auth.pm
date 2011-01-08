package cpanvote::Schema::Result::Auth;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('Auth');

__PACKAGE__->add_columns(
    user_id => {
        data_type         => 'integer',
        is_nullable => 1,
    },
    protocol => {
        is_nullable => 0,
        data_type => 'varchar',
        size => 10,
    },
    credential => {
        data_type   => 'varchar',
        size        => 20,
        is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key('protocol', 'credential');

__PACKAGE__->belongs_to( 'user', 'cpanvote::Schema::Result::Users', 'user_id' );

1;


