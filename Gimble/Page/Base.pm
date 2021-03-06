package Gimble::Page::Base;
use strict;

use base qw(CGI::Prototype);

use Carp qw(confess);

use CGI::Session;
use Class::Autouse;
use Data::Dumper;
use Data::FormValidator;
use Gimble::Dispatch;
use Gimble::Model::player_t;
use HTML::FillInForm;


sub engine { my ($self, $tree) = @_; $tree }


sub dispatch { 
  my $self = shift; Gimble::Dispatch::dispatch($self)
}

sub fint { my($self,$number) = @_; sprintf "%d", $number }

sub view_player_id {
  my ($self, $player_id, $screen_name) = @_;
  
  my $url = Gimble::Dispatch::view_player_url($player_id);
  my $a = HTML::Element->new('a', href => $url);
  unless ($screen_name) {
    my ($p) = Gimble::Model::player_t->screen_name_from_player_id($player_id);
    $screen_name = $p->screen_name;
  }
  $a->push_content($screen_name);

  $a

}



sub render_enter {
  my $self = shift;

  warn $self;

#  warn Dumper \%INC;

  my $tree = $self->template;
#  warn $tree;
  $self->engine($tree);
#  warn Dumper $tree;

#  warn Dumper \@INC;

  $self->set_next_task($tree);
  $self->reflect->addSlot(render_out => $tree);
}

sub viewsrc_url {
  my $self = shift;

  sprintf "/cgi-bin/x?task=viewsrc&otask=%s", $self->param('task') ;

}

sub logged_in {
  my($self) = @_;
  warn 'logged_in...';
  if (my $player_id = $self->session->param('player_id')) {
    warn "\tyes";
    return Gimble::Model::player_t->retrieve($player_id);
  } else {
    warn "\tno";
    return undef;
  }

}

sub claf {
  my ($self, $skeleton) = @_;

  require html::header_head;
  require html::header_body;
  require html::footer;
 
  require html::skeleton;
    

  my $skeleton = html::skeleton->new;
  # warn $skeleton->as_HTML;

  $self->reflect->addSlot(skeleton => $skeleton);

  for my $piece qw(header_head header_body footer) {
    my $ld = $skeleton->look_down(id => $piece);
    my $pn = "html::$piece"->new;
    $ld->replace_content($pn);
  }

  my $surv = $skeleton->highlander(
    login_dialog => [
      logged_in     => sub { $self->logged_in },
      not_logged_in => sub { not $self->logged_in },
    ]);

  if (my $player = $self->logged_in) {
    warn "player logged in", $player;
#    warn $skeleton->as_HTML;
    $surv->content_handler(screen_name => $player->screen_name);
    my $href= sprintf "/x.cgi?task=player_stats&player_id=%d", $player->id;
    $surv->look_down('_tag' => 'a')->attr(
      href => $href
     );
  } else {
    warn "player not logged in";
  }

  { last;
  my $a = $skeleton->look_down(id => 'a_viewsrc') ;
  $a->attr(href => $self->viewsrc_url);
}

  my $ld = $skeleton->look_down(id => "local_body");
  $ld->replace_content($self->render_out);

}

sub render {
  my $self = shift;

  $self->claf;
} 

sub app_enter {
  my($self) = @_;

  my $sid = $self->CGI->cookie('CGISESSID') || undef ;
  
  warn "sid: $sid";
  my($session,$player);

  $session    = new CGI::Session(undef, $sid, {Directory=>'/tmp'});


  $self->reflect->addSlots(
    session   => $session,
   );

}



sub set_cookie {
  my $self = shift;

  my $sess = $self->session;
  my $cgi = $self->CGI;

  my $cookie = $self->CGI->cookie(CGISESSID => $sess->id); 
  $self->display($cgi->header('-cookie' => $cookie));

  $cookie;
}

sub render_leave {
  my $self = shift;
  my $cookie = $self->set_cookie;
  warn "cookie: $cookie";
  $self->display($self->CGI->header) unless $cookie;
  $self->display($self->skeleton->as_HTML);
}

sub snip_validate {
  my ($self,$tree) = @_;

  $tree or confess 'no tree supplied';

  my @validate = $tree->look_down(class => 'validate');
  #  warn "@validate";
  $_->detach for (@validate) ;
}

sub fillinform {
  my ($self, $tree) = @_;

    my $html = $tree->as_HTML;


  my $fif = new HTML::FillInForm;
  my $output = $fif->fill(scalarref => \$html,
                          fobject => $self->CGI);


  my $tree = HTML::Seamstress->new_from_content($output);


}

sub next_task {
  my $in = shift;
  my $class = ref($in) || $in ;

  if (my $task = $Gimble::Dispatch::next{$class}) {
    return $task;
  } else {
      my $dump = Data::Dumper->Dump->(%Gimble::Dispatch::next);
      confess "no next_task found for $class in <dump>$dump</dump>";
  }

}
sub set_next_task {
  my ($self,$tree) = @_;

  $tree and UNIVERSAL::isa($tree,'HTML::Element') or confess 'no tree';
  my $elem = $tree->look_down(name => 'task');
  $elem and $elem->attr(value => $self->next_task);
}

sub make_clan_pulldown {
  use Gimble::Model::clan_t;

  my ($self,$tree) = @_;

#  warn $tree;

  my $clan = Gimble::Model::clan_t->retrieve_all;

  $tree->unroll_select(
    select_label     => 'clan_id', 
    option_value     => sub { my $row = shift; $row->clan_id },
    option_content   => sub { my $row = shift; $row->clan_name },
    option_selected  => sub { 0 } ,
    data             => $clan,
    data_iter        => sub { my $data = shift; $data->next }
   );
  
}

1;
