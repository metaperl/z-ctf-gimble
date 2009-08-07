%loves = (
  
  "Tammy" => "Bob",
  "Susan" => "Bill",
  "Patricia" => "Marko"

 );

%girls_house = (
  "Tammy" => 'Schenectady, NY',
  'Susan' => 'Yonkers, NY',
  'Patricia' => 'Kinderhook, NY'
 );

while (my ($girl, $boy) = each %loves) {
  print "$girl loves $boy \n";
}

my %girlfriend = reverse %loves;

use Data::Dumper;
print Dumper \%girlfriend;

for my $boy (keys %girlfriend) {
  print "$boy loves $girlfriend{$boy} \n";
}


%vehicle = (

  "Marko" => 'Station Wagon',
  'Bill'  => 'motorcycle',
  'Bob'   => 'Volvo'

);

for my $boy (keys %vehicle) {
  print 
      "It is Valentine's day and $boy drove his
$vehicle{$boy} and went to visit $girlfriend{$boy}
in $girls_house{$girlfriend{$boy}} \n";
}


