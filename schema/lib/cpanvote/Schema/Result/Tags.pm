package cpanvote::Schema::Result::Tags;

use strict;
use warnings;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);

__PACKAGE__->table('Tags');

__PACKAGE__->add_columns(
    id => { data_type => 'integer', 
        is_auto_increment => 1 },
    user_id => {
        data_type         => 'integer',
        is_nullable => 1,
    },
    name => {
        data_type => 'varchar',
        size => 20,
    },
);

__PACKAGE__->set_primary_key(qw/ id /);
__PACKAGE__->add_unique_constraint( unique_row => [ qw/ user_id name / ] );

__PACKAGE__->belongs_to( user => 'cpanvote::Schema::Result::Users', 'user_id' );

__PACKAGE__->has_many( 'disttags', 'cpanvote::Schema::Result::TagDist', 'tag_id' );
__PACKAGE__->many_to_many( 'dists', 'disttags', 'dist' );

1;
