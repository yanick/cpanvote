package cpanvote::Schema::Result::Users;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('Users');

__PACKAGE__->add_columns(
    id => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    username => {
        data_type   => 'varchar',
        size        => 20,
        is_nullable => 0,
    },
);

__PACKAGE__->add_unique_constraint( unique_username => ['username'], );

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many( 'votes', 'cpanvote::Schema::Result::Votes', 'user_id' );

1;
