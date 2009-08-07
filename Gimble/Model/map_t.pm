package Gimble::Model::map_t;


use base qw(Gimble::Model);


__PACKAGE__->table('map_t');
__PACKAGE__->columns(Primary   => qw/map_id/);
__PACKAGE__->columns(Essential => qw/map_name/);


1;
