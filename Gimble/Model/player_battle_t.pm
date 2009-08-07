package Gimble::Model::player_battle_t;

use base qw(Gimble::Model);

__PACKAGE__->table('player_t');
__PACKAGE__->columns(Primary => qw/player_id battle_id/);


__PACKAGE__->has_a(battle_id => 'Gimble::Model::battle_t');
__PACKAGE__->has_many(player => 'Gimble::Model::player_t');

1;
