use v6;

my %after;
my %before;

sub parse-rules(@rs) {
    for @rs -> $r {
        my $order = substr($r,0,*-0).split("|");
        my $left = $order[0];
        my $right = $order[1];
        %after.push: ($left => $right);
        %before.push: ($right => $left);
    }
}

sub ordered($a, $b) {
    return (%after{$b}.first($a)==Nil) && (%before{$a}.first($b)==Nil);
}

sub correct(@update) {
    for 0..@update.elems-1 -> $i {
        if !ordered(@update[$i],@update[$i+1]) {
            return False;
        }
    }
    return True;
}

sub middle($arr) {
    return $arr[($arr.elems / 2)]; 
}

sub MAIN() {
    my $instr= "input.txt".IO.slurp.split("\n\n");

    my @rule-instr = $instr[0].split("\n");
    my @updates = $instr[1].split("\n");

    parse-rules(@rule-instr);

    my $sum = 0;
    my $unordered = 0;
    for @updates -> $u {
        my $up = $u.split(",");
        if correct($up) {
            $sum += middle($up);
        } else {
            my $sorted_up = $up.sort(&ordered);
            $unordered += middle($sorted_up);
        }
    }

    say 'A: ', $sum;
    say 'B: ', $unordered;
}
