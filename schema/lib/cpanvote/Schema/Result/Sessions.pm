package cpanvote::Schema::Result::Sessions;

use base qw/DBIx::Class/;

__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('Sessions');
__PACKAGE__->add_columns(qw/id session_data expires/);
__PACKAGE__->set_primary_key('id');

1;
