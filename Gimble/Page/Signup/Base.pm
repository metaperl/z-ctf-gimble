package Gimble::Page::Signup::Base;

use base qw(Gimble::Page::Base);

sub engine {
  my ($self, $tree) = @_;

  $self->snip_validate($tree);
  $self->make_clan_pulldown($tree);

  $tree
}


sub template { require html::signup; html::signup->new; }


1;
