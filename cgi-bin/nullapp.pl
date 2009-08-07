#!/usr/bin/perl

use strict;


BEGIN {

  my $path='~/perl/lib:~/perl:~/perl/share/perl/5.8.4:~/perl/lib/perl/5.8.4:~/public_html/gimblerus.com';
  for my $p (split ':', $path) {
    $p =~ s!~!/home/terry!; 
 #   warn $p;
    unshift @INC, $p;
  }

#  warn "@INC";

}

use base qw(CGI::Prototype);


my $ref = __PACKAGE__->reflect;

$ref->addSlot(
  engine => undef,
  template => sub {
    require html::home;
    html::home->new;
  },
  control_enter => sub {
    my $self = shift;
    require html::skeleton;
    require html::header_head;
    require html::header_body;
    require html::footer;
    
    my $skeleton = html::skeleton->new;
    warn $skeleton->as_HTML;
    for my $piece qw(header_head header_body footer) {
      my $ld = $skeleton->look_down(id => $piece);
      my $pn = "html::$piece"->new;
      $ld->replace_content($pn);
    }
    $self->reflect->addSlot(skeleton => $skeleton);
  },
  render => sub {
    my $self = shift;
    my $ld = $self->skeleton->look_down(id => "local_body");
    $ld->replace_content($self->template);
  } ,
  render_leave => sub {
    my $self = shift;
    $self->display($self->CGI->header);
    $self->display($self->skeleton->as_HTML);
  }
 );
	
#warn $o->display('hi');

__PACKAGE__->activate;
