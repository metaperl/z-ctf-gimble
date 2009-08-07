#!/usr/bin/perl

use strict;



BEGIN {

  my %base = (
    'www.gimbler.us' => 
      '/home/schemelab/domains/us/gimbler/www',
    'dev.gimbler.us' => 
      '/home/schemelab/domains/us/gimbler/dev',
   );

  my $http_host = $ENV{HTTP_HOST} || 'www.gimbler.us' ;
  warn "<http_host>$http_host</http_host>";
  my $base = $base{ $http_host } ;

  warn "<base>$base</base>";
  #use local::lib $base ;
  unshift @INC, $base;
  warn "<inc>@INC</inc>";
}



BEGIN { ++$| }



use Gimble::Page::Base;
Gimble::Page::Base->activate;


