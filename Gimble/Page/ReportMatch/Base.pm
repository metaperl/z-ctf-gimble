package Gimble::Page::ReportMatch::Base;

use base qw(Gimble::Page::Base);

use Gimble::Model::player_t;
use Gimble::Model::map_t;

sub template { require html::report_match;  html::report_match->new; }

sub engine {
  my ($self, $tree) = @_;

  # kill validation output
  $self->snip_validate($tree);

  # "Ok, screen_name, who did you play?"
  $tree->content_handler(screen_name => $self->logged_in->screen_name);

  # create pulldown consisting of all players but the logged in one
  my $all_but = Gimble::Model::player_t->search_all_but($self->logged_in->player_id);

  $tree->unroll_select(
      select_label    => 'opponent_id',
      option_value    => sub { $_[0]->player_id }, 
      option_content  => sub { $_[0]->screen_name },
      option_selected => sub { 0 } ,
      data            => $data,
      data_iter       => sub { $all_but->next }
     );


  # pull the map names out of the database and create the pulldwons
  # to indicate the results
  my $map = Gimble::Model::map_t->retrieve_all;

  warn $map;

  my @results = (
    [ 1  => "I won"   ],
    [ 0  => "We drew" ],
    [-1  => "I lost"  ]
   );

  my $select_count;

  use Storable;

  $tree->table(
    gi_table => 'results',
    gi_tr    => 'resiter',
    table_data => $map,
    tr_data => sub { $map->next },
    td_data => sub { 
      my ($tr_node, $tr_data) = @_;
      warn "@_";
      $tr_node->content_handler(map_name => $tr_data->map_name);
      $tr_node->unroll_select(
	select_label   => 'result_type_select',
	option_value   => sub { $_[0]->[0] },
	option_content => sub { $_[0]->[1] },
	option_selected=> sub { 0 },
	data           => Storable::dclone \@results,
	data_iter      => sub { my $data = shift; shift @$data }
       );
      my $node = $tr_node->look_down(name => 'result_type_select');
      $node->attr('name', $node->attr('name') . ++$select_count);
    }
   );




  $tree
}

sub respond {
  my $self = shift;

  my($response_page);

  if ($self->logged_in) {
    $response_page = $self;
  } else {
    $response_page = 'Gimble::Page::NoAuthz::Base';
    warn $response_page; 
    eval "require $response_page";
    $response_page;
  }

}

1;
