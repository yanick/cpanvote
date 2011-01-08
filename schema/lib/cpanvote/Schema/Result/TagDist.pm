package cpanvote::Schema::Result::TagDist;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('TagDist');

__PACKAGE__->add_columns(
    tag_id => { data_type => 'integer', },
    dist_id => { data_type         => 'integer', },
);

__PACKAGE__->set_primary_key(qw/ tag_id  dist_id /);

__PACKAGE__->belongs_to( dist => 'cpanvote::Schema::Result::Distributions',
'dist_id' );
__PACKAGE__->belongs_to( tag => 'cpanvote::Schema::Result::Tags',
'tag_id' );


1;

