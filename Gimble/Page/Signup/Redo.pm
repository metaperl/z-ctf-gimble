package Gimble::Page::Signup::Redo;

use base qw(Gimble::Page::Signup::Base);

use HTML::FillInForm;
use HTML::TreeBuilder;
use Data::Dumper;

sub engine {
  my ($self, $tree) = @_;

  warn Dumper $self->results->msgs;
  
  my @msgs;
  my %msgs = %{$self->results->msgs} ;
  while (my ($field, $status) = each %msgs) {

    $field =~ s/_/ /g;
    push @msgs, sprintf "%s is %s", $field, lc $status;
  }

  my $li = $tree->look_down(id => 'error_item');
  $tree->iter($li, @msgs);

  $tree
}


sub template {
  my $self = shift;

  require html::signup;
  my $tree = html::signup->new;
  $self->make_clan_pulldown($tree);

  $self->fillinform($tree);
}
1;
