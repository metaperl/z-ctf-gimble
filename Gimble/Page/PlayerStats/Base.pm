package Gimble::Page::PlayerStats::Base;

use base qw(Gimble::Page::Base);

use Gimble::Model::player_t;

sub template {  require html::player_stats;  html::player_stats->new }

sub engine { 
  my($self, $tree) = @_;

  my $player = Gimble::Model::player_t->retrieve($self->param('player_id'));
  my $player_id = $player->player_id;

  $tree->content_handler(screen_name => $player->screen_name);

  $tree->content_handler(rating => $player->elo_rating);

  my ($stats) = Gimble::Model::player_t->search_overall_stats;

  $tree->content_handler($_ => sprintf "%.0f", $stats->$_) 
      for qw(max_elo min_elo avg_elo) ;

  my($wins) = Gimble::Model::player_t->search_wins($player_id);
  my($losses) = Gimble::Model::player_t->search_losses($player_id);
  my($draws) = Gimble::Model::player_t->search_draws($player_id, $player_id);

  my $W = $self->fint($wins->wins);
  my $L = $self->fint($losses->losses);
  my $D = $self->fint($draws->draws);

  my $T = ($W+$L+$D);

  $tree->content_handler(wins => $W);
  $tree->content_handler(losses => $L);
  $tree->content_handler(draws => $D);

  $tree->content_handler( 
    win_percent => $T ? sprintf "%.2f %", ($W / $T)*100 : 'n/a'
   );

  warn $wins->wins;
  warn $losses->losses;
  warn $draws->draws;
}
1;
