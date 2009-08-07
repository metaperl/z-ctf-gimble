package Gimble::Page::AddClan::Commit;

use base qw(Gimble::Page::AddClan::Base);

use Gimble::Session;



sub engine {
  my ($self, $tree) = @_;

  my $tree = $self->SUPER::engine($tree);

  $tree->look_down(id => 'task_title')->replace_content('Clan Added');
  $tree->look_down('_tag' => 'form')->detach;

  $self->snip_validate($tree);

  $tree

}


sub respond_enter {

  my $self = shift;

  my $sess = $self->session;

  warn $sess->id;

  my $clan = Gimble::Model::clan_t->create ({

    map { 
      warn "$_ .. " . $sess->param($_); 
      $_ => $sess->param($_) 
    }
	qw(clan_abbrev clan_name clan_url)
   });

  warn $clan;

}


1;
