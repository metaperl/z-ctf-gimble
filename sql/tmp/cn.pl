open C, 'cn.out' or die $!;

use DBI;
use strict;

my $dbh = DBI->connect('dbi:mysql:db_terry', 'terry', 'stLcmp904c.85!!');
my $sth = $dbh->prepare('INSERT INTO player_t (clan_id, screen_name, login_name, password, email, elo_rating) VALUES(?,?,?,?,?,?)');

while (<C>) {
  my @data = split /\t/ ;
  $sth->execute(@data);
}
  
