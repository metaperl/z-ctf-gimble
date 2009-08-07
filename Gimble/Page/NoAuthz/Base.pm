package Gimble::Page::NoAuthz::Base;

use base qw(Gimble::Page::Base);

sub template {  require html::login_required;  html::login_required->new }

1;
