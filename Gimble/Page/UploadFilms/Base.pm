package Gimble::Page::UploadFilms::Base;

use base qw(Gimble::Page::Base);

use HTTP::File;
use File::Path;


our $path;

sub engine {
  my ($self, $tree) = @_;

  my $meta = $tree->look_down('_tag' => 'meta');
  warn "<META>$meta</META>";
  $meta->attr(URL => $path);

  $tree
}

sub respond {
  my $self = shift;


  warn $self->param('screen_name');
  warn $self->param('opponent');


  $path = 
      sprintf "films/ladder/%s-vs-%s/%s", (sort $self->param('screen_name'), 
      $self->param('opponent')), POSIX::strftime('%Y-%m-%d', localtime) ;

  $path =~ s/\s+/_/g;

  warn "<PATH>$path</PATH>";
  #system('mkdir', '-p', $path);
  mkpath([$path], 0, 0777);
  system("sync");
  sleep(1);

  my @param = $self->CGI->param;

#  warn "<cgiparms>@param</cgiparms>";

  my @file = grep /file_\d+/ ,  @param;

#  warn "<filecgiparms>@file</filecgiparms>";


#  warn "<UPLOAD_FILES>@file</UPLOAD_FILES>";

  my $debug = 1;
  for my $file (@file) {
      my $raw_file = $self->CGI->param($file);
      eval {
	  my $basename = HTTP::File::upload($raw_file,$path,$debug );
      } ;
      warn "upload issue: $@" if $@ ;
  }


  system("sync");
  sleep(1);

  $self;
}

sub template { require html::file_upload; html::file_upload->new; }


1;
