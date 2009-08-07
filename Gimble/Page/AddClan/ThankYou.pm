package Gimble::Page::AddClan::ThankYou;

use base qw(Gimble::Page::AddClan);


use Gimble::Model::clan_t;

warn __PACKAGE__;

sub template {
  my $self = shift;

  my $tree = $self->SUPER::template;

  $tree->look_down(id => 'task_title')->replace_content('Clan Added');
  $tree->look_down('_tag' => 'form')->detach;

  $self->snip_validate($tree);

  $tree


}
1;
