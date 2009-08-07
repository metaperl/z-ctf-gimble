package Gimble::Page::Signup::Welcome;

use base qw(Gimble::Page::Base);

use Gimble::Session;

our $sess;



sub template {

  my $self = shift;

  require html::signup_welcome;
  my $tree = html::signup_welcome->new;

  $sess = Gimble::Session::magick($self->CGI);

  $tree->look_down(id => 'screen_name')
      ->replace_content($sess->param('screen_name'));

  $tree

}
1;
