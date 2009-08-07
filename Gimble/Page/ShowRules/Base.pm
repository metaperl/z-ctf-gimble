package Gimble::Page::ShowRules::Base;

use base qw(Gimble::Page::Base);

use Gimble::Model::player_t;

sub template {  require html::rules;  html::rules->new }

sub engine {

  my ($self, $tree) = @_;

  $tree->content_handler(
    inactive_days => $Gimble::Model::player_t::inactive_days
   );

  $tree->content_handler(
    provisional_days => $Gimble::Model::player_t::provisional_shelf
   );

}

1;
