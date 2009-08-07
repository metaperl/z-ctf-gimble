package Gimble::Page::Login::Process;
use strict;

warn __PACKAGE__;


use base qw(Gimble::Page::Login::Base);

use Gimble::Session;
use Data::Dumper;

use Gimble::Model::player_t;

our $dfv_profile  = {
  msgs        => { format => '%s' },
  required    => [ qw(login_name password) ],
};


sub template {
  require html::login_welcome;
  html::login_welcome->new;
}

sub engine {
  my ($self, $tree) = @_;

  my ($player) = Gimble::Model::player_t->search(
    login_name => $self->param('login_name')
   );


  warn $player;

  $tree->content_handler(screen_name => $player->screen_name);
  $self->session->param(player_id => $player->player_id);

  $tree
}

sub engine_redo {
 my ($self, $tree) = @_;

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

sub engine_login_failed {
 my ($self, $tree) = @_;

 my $li = $tree->look_down(id => 'error');
 $li->replace_content('login credentials not accepted');

  $tree
}

sub make_redo {
  
  Class::Prototyped->new(
    'parent*' => 'Gimble::Page::Login::Base',
    engine => \&engine_redo,
    results => $_[0] ,
   );
}

sub make_login_failed {
  
  Class::Prototyped->new(
    'parent*' => 'Gimble::Page::Login::Base',
    engine => \&engine_login_failed,
    results => $_[0] ,
   );
}


sub respond {
  my $self = shift;

  warn 'checking results';
  warn Dumper $dfv_profile;

  my $results = Data::FormValidator->check( $self->CGI, $dfv_profile );

  #  warn Dumper $results;

  my $response_page;

  if ( $results->has_missing() || $results->has_invalid() ) {
    warn "# There was something wrong w/ the data...";
    $response_page = 'Gimble::Page::Login::Redo';
    eval "require $response_page";
    $response_page->reflect->addSlots(
      results => $results
     );
  } else {
    if (my $user = Gimble::Model::player_t->attempt_login(
      $self->param('login_name'), $self->param('password'))) {
      $self->reflect->addSlots(user => $user);
      warn 'login successful';
      $response_page = __PACKAGE__;
    } else {
      $response_page = 'Gimble::Page::Login::LoginFailed';
      eval "require $response_page";
    }
  }

  warn $response_page;
  return $response_page;
}



1;
