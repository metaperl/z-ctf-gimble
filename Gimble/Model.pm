package Gimble::Model;
use strict;

use base qw(Class::DBI);


my %dsn = (
  'dev.gimbler.us' => 
    'DBI:mysql:database=gimblerus_dev',
  'www.gimbler.us' => 
    'DBI:mysql:database=gimblerus',
 );

my $http_host = $ENV{HTTP_HOST} ;


unless ($http_host) {

  use File::Spec;
  my $path = File::Spec->rel2abs($0);
  warn $path;

  ($http_host) = grep { $path =~ /$_/ } keys %dsn ;

}

warn $http_host;

my $dsn = $dsn{$http_host} ;

warn $dsn;

__PACKAGE__->connection($dsn, 'root', 'm0ney123');

#use CGI; use Data::Dumper;
#warn Dumper \%ENV;

1;
