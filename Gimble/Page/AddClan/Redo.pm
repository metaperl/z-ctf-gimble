package Gimble::Page::AddClan::Redo;

use base qw(Gimble::Page::AddClan::Validate);

use HTML::FillInForm;
use HTML::TreeBuilder;
use Data::Dumper;



sub template {
  my $self = shift;

  require html::addclan;
  my $tree = html::addclan->new;

  my $html = $tree->as_HTML;


  my $fif = new HTML::FillInForm;
  my $output = $fif->fill(scalarref => \$html,
                          fobject => $self->CGI);


  my $tree = HTML::Seamstress->new_from_content($output);

  use Data::Dumper;
  warn Dumper $self->results->msgs;

  $tree->look_down(id => 'load_data')->detach;
  
  my @msgs;
  my %msgs = %{$self->results->msgs} ;
  while (my ($field, $status) = each %msgs) {

    $field =~ s/_/ /g;
    push @msgs, sprintf "$field is %s", lc $status;

  }

  warn "T: $tree";
  my $li = $tree->look_down(id => 'error_item');
  warn $li;
  $tree->iter($li, @msgs);



  $tree

}
1;
