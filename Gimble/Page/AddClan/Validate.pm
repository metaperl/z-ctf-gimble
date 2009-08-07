package Gimble::Page::AddClan::Validate;

use base qw(Gimble::Page::Base);

use Class::Autouse;
use Data::Dumper;
use Data::FormValidator;



our $dfv_profile =  {

  required    => [ qw(clan_name clan_abbrev) ],
  optional    => [ qw(clan_url) ],
  msgs        => { format => '%s' },

};


sub respond {
  my $self = shift;

  warn "self: $self";

  my $results = Data::FormValidator->check( $self->CGI, $dfv_profile );

  warn Dumper($results);

  my $response_page;

  if ( $results->has_missing() || $results->has_invalid() ) {
    # There was something wrong w/ the data...
    $self->reflect->addSlots( results => $results );
    $response_page = 'Gimble::Page::AddClan::Redo';
  } else {
    $response_page = 'Gimble::Page::AddClan::Confirm';
  }

  warn $response_page;
  Class::Autouse->autouse($response_page);
  return $response_page;
}

sub template {
  require html::signup;
  my $tree = html::signup->new;


  $tree


}
1;
