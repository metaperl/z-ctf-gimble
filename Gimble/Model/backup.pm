package Gimble::Model::backup;

use base qw(Gimble::Model);

__PACKAGE__->set_sql(lock_tables => q{
   LOCK TABLES
});

__PACKAGE__->set_sql(flush_tables => q{
  FLUSH TABLES
});

1;
