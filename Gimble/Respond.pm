package Gimble::Respond;

use strict;

use base qw(CGI::Prototype);
use Class::Autouse;

our %task = (

  'Gimble::Page::Signup' => sub {
    my $data_ok = shift;
    $data_ok 
	? 'Gimble::Page::Signup::ConfirmOrEdit'
	: 'Gimble::Page::Signup::Redo'
  },

  'Gimble::Page::ConfirmOrEdit' => sub {
    my $data_ok = shift;
    $data_ok 
	? 'Gimble::Page::Signup::Commit'
	: 'Gimble::Page::Signup::Redo'
  }

);

sub respond {
  my $page  = shift;
  my $data_ok = shift;

  my $new_page = $task{$page}->($data_ok);

  warn "newpage: $new_page";

  Class::Autouse->autouse($new_page);
  return $new_page;

}


1;
