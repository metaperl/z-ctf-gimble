package Gimble::Page::Login::Redo;

use base qw(Gimble::Page::Login::Base);

use Class::Autouse;
use Data::Dumper;

warn __PACKAGE__;

sub engine {
 my ($self,$tree) = @_;


 my @msgs;
 my %msgs = %{$self->results->msgs} ;

  while (my ($field, $status) = each %msgs) {

    $field =~ s/_/ /g;
    push @msgs, sprintf "%s is %s", $field, lc $status;

  }

  my $li = $tree->look_down(id => 'error');


  $tree->iter($li, @msgs);

  $tree

}


1;
