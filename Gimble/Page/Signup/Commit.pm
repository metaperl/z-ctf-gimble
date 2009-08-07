package Gimble::Page::Signup::Commit;

use base qw(Gimble::Page::Signup::Base);

use Class::Autouse;

use Gimble::Model::player_t;
use Gimble::Session;



sub template { require html::signup_welcome; html::signup_welcome->new }

sub engine {
  my ($self, $tree) = @_;


  warn $self->session->id;
  warn $tree->as_HTML;

  my $sn = $tree->look_down(id => 'screen_name');
  warn $sn;
  $sn->replace_content($self->session->param('screen_name'));

  $tree
}

sub control_enter {

  my $self = shift;

  warn "session_id: " , $self->session->id;

  my $player = Gimble::Model::player_t->create ({
    map { warn "$_ .. " . $self->session->param($_); $_ => $self->session->param($_) }
	qw(clan_id screen_name login_name password email)
   });

}


1;
