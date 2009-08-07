package Gimble::Model::battle_t;

use base qw(Gimble::Model);



__PACKAGE__->table('battle_t');
__PACKAGE__->columns( Primary => 'battle_id' );

__PACKAGE__->columns(
  Essential => qw/winning_player_id losing_player_id creation_datetime battle_result/
 );

__PACKAGE__->columns(
  TEMP => qw/battle_fmt winning_player losing_player/
 );

__PACKAGE__->set_sql(recent_results => q{
   SELECT DATE_FORMAT(creation_datetime,'%%b %%d') as battle_fmt, battle_t.*, wp.screen_name as winning_player,lp.screen_name as losing_player 
     FROM battle_t INNER JOIN player_t wp ON (winning_player_id=wp.player_id) 
          INNER JOIN player_t lp ON (losing_player_id=lp.player_id)
 ORDER BY creation_datetime DESC
    LIMIT 80
});

__PACKAGE__->set_sql(recent_resultz => q{
   SELECT CONCAT(EXTRACT(YEAR FROM creation_datetime), '-' , EXTRACT(MONTH FROM creation_datetime), '-', EXTRACT(DAY FROM creation_datetime)) as battle_fmt, battle_t.*, wp.screen_name as winning_player,lp.screen_name as losing_player 
     FROM battle_t INNER JOIN player_t wp ON (winning_player_id=wp.player_id) 
          INNER JOIN player_t lp ON (losing_player_id=lp.player_id)
 ORDER BY creation_datetime DESC
    LIMIT 40
});

1;
