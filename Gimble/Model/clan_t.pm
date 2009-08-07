package Gimble::Model::clan_t;
use Class::DBI::AbstractSearch;

use base qw(Gimble::Model);


__PACKAGE__->table('clan_t');
__PACKAGE__->columns(Primary   => qw/clan_id/);
__PACKAGE__->columns(Essential => qw/clan_abbrev clan_name clan_url/);

__PACKAGE__->has_many(player => 'Gimble::Model::player_t');


1;
