say 'Day 3: Raku';

my $alpha = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
my $p1 = 0;
my $p2 = 0;

my $x = Nil;
my $y = Nil;
my $z = Nil;

for lines() -> $line {
    my $a = $line.substr(0, $line.chars / 2).split("", :skip-empty).Set;
    my $b = $line.substr($line.chars / 2).split("", :skip-empty).Set;
    $p1 += $alpha.index(($a (&) $b).pick) + 1;

    ($x, $y, $z) = ($y, $z, $line.split("", :skip-empty).Set);
    if $x.defined {
        $p2 += $alpha.index(($x (&) $y (&) $z).pick) + 1;
        $x = Nil;
        $y = Nil;
        $z = Nil;
    }
}

printf("Part 1: %20d\n", $p1);
printf("Part 2: %20d\n", $p2);
