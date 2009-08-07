#!/usr/bin/perl

use strict;

use Gimble::Model::player_t;
use Gimble::Model::battle_t;

my $sth = Gimble::Model::player_t->sql_reset_elo;

my $battle = Gimble::Model::battle_t->retrieve_from_sql(qq{
                WHERE 1
                ORDER BY creation_datetime
        });

while (my $b = $battle->next) {

  Gimble::Model::player_t::elo_update($b);

}




