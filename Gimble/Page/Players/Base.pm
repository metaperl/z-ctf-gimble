package Gimble::Page::Players::Base;

use strict;
use base qw(Gimble::Page::Base);

use Data::Dumper;
use Gimble::Model::player_t;
use Gimble::Dispatch;
#use Tie::Cycle;
use List::Cycle;
use List::Rotation;

sub template { require html::players ; html::players->new }




sub total_battles {
  my $p = shift;
  
  my ($t) = $p->search_total_battles($p->player_id, $p->player_id);
  $t->total_battles ;
}

sub provisional_link {

  my $matches_needed = shift;

  [
    'span', " (provisional - $matches_needed more matches needed) ",
    [
      'a', 
      { href => '/x.cgi?task=show_rules#prov' }, 
      ' click here for explanation' 
     ],
   ]

}

sub inactive_link {

  my $days = shift;

  [
    'span', " (inactive for $days days) ",
    [
      'a', 
      { href => '/x.cgi?task=show_rules#inactive' }, 
      ' click here for explanation' 
     ],
   ]

}

sub engine {

  my ($self, $tree) = @_;

#  my $player = Gimble::Model::player_t->retrieve_all;
  my $player = Gimble::Model::player_t->search_where(
    { password => { '!=', 'barred' } },
    { order_by => 'elo_rating DESC' }
   );

  my (@standard, @provisional, @never_played, @inactive);

  while (my $p = $player->next) {

    warn $p->screen_name;

    my $total_battles = total_battles($p) ;

    if ($total_battles == 0) {
      warn 'never played';
      $p->set(text_elo => $p->elo_rating . " (never played)" )  ;

      push @never_played, $p ;

    }
    elsif ($total_battles < $Gimble::Model::player_t::provisional_shelf) {
      warn 'provisional';
      
      $p->set(
	text_elo => 
	    [
	      'span', 
	      $p->elo_rating , 
	      provisional_link(
		$Gimble::Model::player_t::provisional_shelf
		    - $total_battles
		   )
	     ]
	   )  ;

#      warn $p->text_elo;

      push @provisional, $p ;

    } elsif ((my $inactive_days = $p->inactive) > 0) {
      
      $p->set(
	text_elo => 
	    ['span', $p->elo_rating , inactive_link($inactive_days) ]
	   ) ;
      push @inactive, $p;

    } else {

      #    warn 'standard';

      warn "inactive: ", $p->inactive;

      $p->set(
	text_elo => 
	    $p->elo_rating 
	   ) ;

      push @standard, $p;

    }

  }

  my @player_list = (@standard, @inactive, @provisional, @never_played);

#  warn Dumper \@player_list;



  $tree->table (
    gi_table => 'load_data',
    gi_tr    => [qw(iterate1 iterate2)],
    tr_data  => sub { shift @player_list },
    td_data  => sub { 
      my ($tr_node, $tr_data) = @_;
      $tr_node->content_handler(elo_rating => $tr_data->text_elo) ;
      my $a = $self->view_player_id($tr_data->player_id);

      my $td = $tr_node->look_down(id => 'screen_name');

      $td->replace_content($a);
      $tr_node->content_handler(clan_name =>   $tr_data->clan_id->clan_name);
    }
   );



  $tree

}

1;
