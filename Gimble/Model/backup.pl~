use Gimble::Model::battle_t;


DBI->trace(2);
my $s = Gimble::Model::battle_t->search_recent_resultz;
DBI->trace(0);

while (my $result = $s->next) {
  warn sprintf '%s %s %s', $result->battle_fmt,
      $result->winning_player, $result->losing_player;
}
