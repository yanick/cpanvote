package cpanvote::Schema::Distributions;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('Distributions');

__PACKAGE__->add_columns(
    id => {
        data_type         => 'integer',
        is_auto_increment => 1,
    },
    distname => {
        data_type   => 'varchar',
        size        => 30,
        is_nullable => 0,
    },
);
__PACKAGE__->add_unique_constraint( unique_distname => ['distname'], );

__PACKAGE__->set_primary_key('id');

1;


