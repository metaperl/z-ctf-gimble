package Gimble::Page::AddClan::Base;

use base qw(Gimble::Page::Base);


use Gimble::Model::clan_t;

sub template { require html::addclan; html::addclan->new; }

sub engine {
  my ($self, $tree) = @_;

  my $clan = Gimble::Model::clan_t->search_where(
    clan_id => { '>', 0 }
   ) ;

  $self->snip_validate($tree);

  $tree->table(
    gi_table     => 'load_data', 
    gi_tr        => [qw(iterate1 iterate2)],
    table_data      => $clan,
    tr_data      => sub {
      my ($self, $data) = @_;
#      warn $data;
      $data->next
    },
    td_data  => sub {
      my ($tr_node, $tr_data) = @_;
      $tr_node->content_handler($_ => $tr_data->$_) 
	  for qw(clan_name clan_abbrev clan_url) ;
    },
   );


  $tree

}

1;
