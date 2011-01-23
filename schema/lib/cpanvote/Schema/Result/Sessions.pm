package cpanvote::Schema::Result::Sessions;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('Sessions');

__PACKAGE__->add_columns(
    id => {
        data_type => 'varchar',
        size => 72,
        is_nullable => 0,
    },
    session_data => {
        data_type => 'text',
        is_nullable => 1,
    },
    expires => {
        data_type => 'integer',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key('id');

1;
