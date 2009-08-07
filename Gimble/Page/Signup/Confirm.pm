package Gimble::Page::Signup::Confirm;

use base qw(Gimble::Page::Signup::Base);

use Data::Dumper;
use Data::FormValidator;
use Gimble::Model::clan_t;
use Gimble::Model::player_t;
use Gimble::Session;

my @field = qw(clan_id screen_name login_name password email);

sub respond_leave {
  my $self = shift;

  $self->session->save_param($self->CGI);
}

sub check_passwords {
  my ( $pw1, $pw2 ) = @_;
  $pw1 eq $pw2
}

our $dfv_profile =  {
  msgs        => { format => '%s' },
  required    => [ qw(screen_name login_name clan_id password email) ],
  constraints => {
    email     => 'email',
    password  => {
                'constraint' => \&check_passwords,
                'params'     => [ qw( password password_again ) ],
    },
  }
};











sub respond {
  my $self = shift;

  my $results = Data::FormValidator->check( $self->CGI, $dfv_profile );

  warn Dumper($results);

  my $response_page;

  if ( $results->has_missing() || $results->has_invalid() ) {
    # There was something wrong w/ the data...
    $response_page = 'Gimble::Page::Signup::Redo';
    eval "require $response_page";
    $response_page->reflect->addSlots( results => $results );
  } else {
    $response_page = $self;
  }

  return $response_page;
}

sub template { require html::signup; html::signup->new }

sub engine {
  my ($self, $tree) = @_;

  $self->snip_validate($tree);
  $tree->look_down(id => 'tr_password_again')->detach;

  my $clan = Gimble::Model::clan_t->retrieve($self->param('clan_id'));

  $self->param('clan_id', $clan->clan_name);

  warn $tree->as_HTML;
  for my $field (@field) {
    warn $field, $self->param($field);
    my $elem = $tree->look_down(name => $field);

    $elem->parent->replace_content($self->param($field));
  }

  $tree->look_down(id => task_title)->replace_content('Confirm Signup Info');
  $tree->look_down(type => 'submit')->attr(value => 'Confirm Info');

  $tree
}

1;
