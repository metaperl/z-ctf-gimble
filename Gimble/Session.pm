package Gimble::Session;

use CGI::Session;

sub magick {

  my ($cgi) = @_;

  my $session = new CGI::Session("driver:File", $cgi, {Directory=>'/tmp'});

}



1;
