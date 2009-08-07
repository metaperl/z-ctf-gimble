package Gimble::Page::Login::LoginFailed;


use base qw(Gimble::Page::Base);

sub template { require html::login_failed; html::login_failed->new }

1;
