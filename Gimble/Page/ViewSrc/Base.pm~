package Gimble::Page::ViewSrc::Base;

use base qw(Gimble::Page::Base);
use Gimble::Dispatch ;

sub find_module {
  my $module_name = shift;

  warn $module_name;
  $module_name =~ s!::!/!g;
  $module_name = "$module_name.pm";

  warn $module_name;
  use Data::Dumper;
  $INC{$module_name};
}

sub template {

  my $self = shift;

  $self->param('task', $self->param('otask')) ;
  my $module = Gimble::Dispatch::dispatch($self);

  warn $module;

  my $file = find_module $module;

  warn $file;

  my $syscmd = "cat $file | perltidy -html -ntoc -nnn";

  warn $syscmd;

  my $html = `$syscmd`;

  warn $html;

  use HTML::TreeBuilder;

  HTML::TreeBuilder->new_from_content($html);

}

1;
