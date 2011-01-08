package cpanvote::Schema::Result::Distributions;

use strict;
use warnings;

use base qw/DBIx::Class/;

use List::MoreUtils qw/ uniq /;

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
       foo => {
        data_type => 'varchar',
        size => 30,
        is_nullable => 1,
    },
);
__PACKAGE__->add_unique_constraint( unique_distname => ['distname'], );

__PACKAGE__->set_primary_key('id');

__PACKAGE__->has_many( 'votes', 'cpanvote::Schema::Result::Votes', 'dist_id' );
__PACKAGE__->has_many( 'disttags', 'cpanvote::Schema::Result::TagDist', 'dist_id' );
__PACKAGE__->many_to_many( 'tags', 'disttags', 'tag' );

sub tagnames {
    my $self = shift;

    return uniq map { $_->name } $self->tags;
}

1;


