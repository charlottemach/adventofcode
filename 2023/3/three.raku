my @digits = (0,1,2,3,4,5,6,7,8,9);

sub parts($grid, $n) {
    my @parts = ();
    loop (my $x = 0; $x < $n+2; $x++) {

        my $num = "";
        my $has-symbol = False;
        loop (my $y = 0; $y < $n+2; $y++) {

            my $cur = $grid[$x][$y];
            if ($cur ~~ -1) { #symbol
               if ($num.chars > 0) {
                   @parts = @parts.append: $num;
                   $num = ""; 
               } 
            } elsif ($cur ~~ '.') {
               if ($num.chars > 0) {
                   if ($has-symbol) { 
                       @parts= @parts.append: $num;
                   }
               }
               $num = ""; 
               $has-symbol = False;
            } else {
               $num = $num ~ $cur;
               $has-symbol = $has-symbol || check($grid, $x, $y);
            }
        }
    }
    return @parts.sum;
}

sub check($grid, $x, $y) {
    if (($grid[$x-1][$y-1] ~~ -1)
       || ($grid[$x][$y-1] ~~ -1)
       || ($grid[$x+1][$y-1] ~~ -1)
       || ($grid[$x-1][$y] ~~ -1)
       || ($grid[$x+1][$y] ~~ -1) 
       || ($grid[$x-1][$y+1] ~~ -1) 
       || ($grid[$x][$y+1] ~~ -1) 
       || ($grid[$x+1][$y+1] ~~ -1)) {
         return True
    }
    return False;
}

sub get-num($grid, $x, $y) {
    my @num = $grid[$x][$y];
    if ($grid[$x][$y-1] ~~ any @digits) {
       @num = @num.prepend: $grid[$x][$y-1];
       if ($grid[$x][$y-2] ~~ any @digits) {
           @num = @num.prepend: $grid[$x][$y-2];
       }
    }
    if ($grid[$x][$y+1] ~~ any @digits) {
       @num = @num.append: $grid[$x][$y+1];
       if ($grid[$x][$y+2] ~~ any @digits) {
           @num = @num.append: $grid[$x][$y+2];
       }
    }
    return @num.join('');
}

sub unique-gears($grid, $x, $y) {
    my @gn = ();
    loop (my $i = -1; $i <= 1; $i++) {
        loop (my $j = -1; $j <= 1; $j++) {
            my $xx = $x + $i;
            my $yy = $y + $j;
            if ($grid[$xx][$yy] ~~ any @digits) {
                @gn = @gn.append: get-num($grid, $xx, $yy);
            }    
        }
    }
    return @gn.unique;
}

sub gears($grid, $n) {
    my @gears = ();
    loop (my $x = 0; $x < $n+2; $x++) {
        loop (my $y = 0; $y < $n+2; $y++) {
            my $cur = $grid[$x][$y];
            if ($cur ~~ "*") {
                my @gn = unique-gears($grid,$x,$y);
                if (@gn.elems ~~ 2) {
                    my $pow = @gn[0] * @gn[1];
                    @gears = @gears.append: $pow;
                }
            }
        }
    }
    return @gears.sum;
}

sub padding($grid, $n) {
    loop (my $r = 0; $r < $n; $r++) {
        $grid[$r] = ($grid[$r].prepend: '.').append: '.';
    }
    my $empty = ['.' xx $n+2];
    return ($grid.prepend: $empty).append: $empty;
}


sub MAIN() {
    my $contents = "input.txt".IO.slurp;
    my $rows = $contents.split("\n");

    my $n = $rows[0].chars+1;
    my $grid = [$n;$n] = ['.' xx $n] xx $n;
    my $grid-b = [$n;$n] = ['.' xx $n] xx $n;

    loop (my $x = 0; $x < $n; $x++) {
        my $row = $rows[$x].split("");
        loop (my $y = 0; $y < $n; $y++) {
            my $cur = $row[$y];
            if !($cur ~~ '.') {
                if ($cur ~~ any @digits) {
                    $grid[$x][$y] = $cur;
                    $grid-b[$x][$y] = $cur;
                }
                else { #symbol
                    $grid[$x][$y] = -1;
                    if ($cur ~~ '*') {
                        $grid-b[$x][$y] = '*';
                    } else {
                        $grid-b[$x][$y] = '.';
                    }
                }
            }
        }
    }
    say 'A: ', parts(padding($grid,$n),$n);
    say 'B: ', gears(padding($grid-b,$n),$n);
}
