use Set::Array;

  my @results = (
    [ 1  => "%s won"   ],
    [ 0  => "draw"  ],
    [-1  => "%s lost"  ]
   );


my $a = Set::Array->new(qw(1 2 3 4));

warn $a->shift;

while (my $r = $a->shift) {
  warn $r;
}
