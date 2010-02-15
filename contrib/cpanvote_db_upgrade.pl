  use strict;
  use cpanvote::Schema;
  use Getopt::Long;
  use Pod::Usage;

GetOptions(
    'dsn=s'            => \my $dsn,
    'user=s'           => \my $user,
    'password=s'       => \my $password,
) or die pod2usage;

  my $schema = cpanvote::Schema->connect(
    $dsn,
    $user,
    $password,
  );

  my $x = $schema->resultset('Users');

  if (!$schema->get_db_version()) {
    # schema is unversioned
    $schema->deploy();
  } else {
    $schema->upgrade();
  }
