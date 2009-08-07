use strict;
use base qw(Gimble::Model::backup);


DBI->trace(2);
__PACKAGE__->sql_lock_tables;

__PACKAGE__->sql_flush_tables;

