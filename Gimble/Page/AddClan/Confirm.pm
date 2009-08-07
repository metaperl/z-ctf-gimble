package Gimble::Page::AddClan::Confirm;

use base qw(Gimble::Page::AddClan::Base);


use Data::Dumper;
use Gimble::Model::clan_t;
use Gimble::Model::player_t;
use Gimble::Session;

our $sess;

my @field = map { $_->{name} } Gimble::Model::clan_t->_essential;
warn "fields: @field";
shift @field; # remove clan_id



our $dfv_profile =  {

  required    => [ qw(clan_name clan_abbrev) ],
  optional    => [ qw(clan_url) ],
  msgs        => { format => '%s' },

};

sub respond_leave {
  my $self = shift;

  $self->session->save_param($self->CGI);

}


sub engine {

  my ($self,$tree) = @_;

  $self->snip_validate($tree);
  $tree->look_down(id => 'load_data')->detach;

  # warn $tree->as_HTML;
  for my $field (@field) {
    warn $field, $self->param($field);
    my $elem = $tree->look_down(name => $field);

    $elem->parent->replace_content($self->param($field));
  }

  $tree->look_down(id => task_title)->replace_content('Confirm Clan Info');
  $tree->look_down(type => 'submit')->attr(value => 'Confirm Info');

  $tree


}

sub respond {
  my $self = shift;

  warn "self: $self";

  my $results = Data::FormValidator->check( $self->CGI, $dfv_profile );

  warn Dumper($results);

  my $response_page;

  if ( $results->has_missing() || $results->has_invalid() ) {
    # There was something wrong w/ the data...
    $self->reflect->addSlots( results => $results );
    require Gimble::Page::Signup::Redo;
    $response_page = 'Gimble::Page::Signup::Redo';
  } else {
    $response_page = __PACKAGE__;
  }

  return $response_page;
}

1;
