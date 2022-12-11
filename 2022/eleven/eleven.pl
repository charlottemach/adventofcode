#!usr/bin/perl

sub get_items
{
    	my $i = $_[0]; $i =~ tr/:,//d;
	my @items = split(' ',$i);
	return @items[2..$#items];
}

sub get_nxt
{
    	my $div = $_[1]; $div =~ s/\D//g;
	my $tr = $_[0] % $div == 0 ? $_[2] : $_[3];
        $tr =~ s/\D//g;
        return $tr;
}

sub do_op
{
        my $old = $_[0];
        my $do = (split('=',$_[1]))[1];
        $do =~ s/old/\$old/g;
        return eval $do;
}


sub get_top_two
{
	my $ins = shift;
	my $one = 0; my $two = 0;
	for $v (values %{$ins}){
		if ($v > $one and $v > $two){
			$two = $one;
			$one = $v;
		} elsif ($v < $one and $v > $two){
			$two = $v;
		} 
	}
	return $one * $two;
}

sub get_state
{
	%init_state = ();
	$modulo = 1;
	for my $i (0..$#monkeys){
		my @mm = split /\n/, @monkeys[$i];
	        my @items = get_items(@mm[1]);
		$init_state{$i} = join(" ",@items);

		$tmp = @mm[3]; $tmp =~ s/\D//g;
	    	$modulo = $modulo * $tmp;
	}
	return %init_state,$modulo;
}

@monkeys = split /\n\n/, do { local( @ARGV, $/ ) = ( "eleven.txt" ); <> };
%init_state,$modulo = get_state();

%inspect = ();
%state = %init_state;
for $r (1..20){
	for $m (0..scalar @monkeys){
		my @mm = split /\n/, @monkeys[$m];
                my @items = split(" ",$state{$m});
		$inspect{$m} = $inspect{$m} + (scalar @items);
                for $i (@items){
                	my $i = int(do_op($i,@mm[2]) / 3);
                        my $nxt = get_nxt($i,@mm[3..5]);
			$state{$nxt} = $state{$nxt} . " $i";
                }
		$state{$m} = "";
        }
}
print "A: ",get_top_two(\%inspect),"\n";

%inspect = ();
%state = %init_state;
for $r (1..10000){
	for $m (0..scalar @monkeys){
		my @mm = split /\n/, @monkeys[$m];
                my @items = split(" ",$state{$m});
		$inspect{$m} = $inspect{$m} + (scalar @items);
                for $i (@items){
                	my $i = do_op($i,@mm[2]) % $modulo;
                        my $nxt = get_nxt($i,@mm[3..5]);
			$state{$nxt} = $state{$nxt} . " $i";
                }
		$state{$m} = "";
        }
}
print "B: ",get_top_two(\%inspect),"\n";
