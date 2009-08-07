package Gimble::Page::Login::Base;

use base qw(Gimble::Page::Base);


sub engine {
  my ($self,$tree) = @_;

  $self->snip_validate($tree);

  $tree
}

sub template { require html::login; html::login->new }

1;
