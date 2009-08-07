package Gimble::Page::Home::Base;
use strict;

use base qw(Gimble::Page::Base);

use Gimble::Model::battle_t;

sub battle_result {
  my ($results) = @_;

  my $r = $results ? 'defeated' : 'drew' ;

  "$r";
      
}


sub engine {
  my ($self, $tree) = @_;


  my $result = Gimble::Model::battle_t->search_recent_results;


  $tree->table(
    gi_table => 'ladder_results',
    gi_tr    => 'ladder_result',
    table_data => $result,
    tr_data  => sub { $result->next },
    td_data => sub {
      my ($tr_node, $tr_data) = @_;

      $tr_node->content_handler(battle_date   => $tr_data->battle_fmt);
      my $br = $tr_node->look_down(id => 'battle_result');
      $br->replace_content(
	$self->view_player_id($tr_data->winning_player_id), ' ',
	battle_result($tr_data->battle_result), ' ',
	$self->view_player_id($tr_data->losing_player_id),

       );
    });
  $tree
}


sub template { require html::home; html::home->new }

1;
