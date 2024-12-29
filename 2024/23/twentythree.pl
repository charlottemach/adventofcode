#!usr/bin/perl
use warnings;
use strict;

sub connections 
{
    my %connections;
    foreach my $p ( @{$_[0]} ) {
        my @p = split /-/, $p;
        my $from = $p[0]; my $to = $p[1];

        if (exists($connections{$from})) {
            push(@{ $connections{$from} }, $to);
        } else {
            my @to = ($to);
            $connections{$from} = \@to;
        }
        if (exists($connections{$to})) {
            push(@{ $connections{$to} }, $from);
        } else {
            my @from = ($from);
            $connections{$to} = \@from;
        }
    }
    return %connections;
}

sub triangles 
{
    my $connections = $_[0];
    my %triangles;
    for my $one (keys %{$connections}) {
        for my $two (@{ %{$connections}{$one} }) {
            if ($one ne $two) {
                for my $three (@{ %{$connections}{$two} }) {
                    if ($one ne $three) {
                        if ( grep( /^$one$/, @{ %{$connections}{$three} } )) {
                            $triangles{join("-",sort ($one,$two,$three))} = 1;
                        }
                    }
                }
            }
        }
    }
    my $cnt = 0;
    for my $k (keys %triangles){
        if ($k =~ m/t\w/i) {
            $cnt++;
        }
    }
    return ($cnt,%triangles);
}

sub scc
{
    my $connections = $_[0];
    my $triangles = $_[1];
    my %cnts;
    my $mx = 0;
    for my $comp (keys %{$connections}) {
        my $c = 0;
        for my $triangle (keys %{$triangles}) {
            if ($triangle =~ m/$comp/) {
                $c++;
            }
        }
        $cnts{$comp} = $c;
        $mx = $c > $mx ? $c : $mx;
    }
    my @mxc;
    for my $k (keys %cnts){
        if ($cnts{$k} == $mx) {
            push(@mxc,$k);
        }
    }
    my %scc;
    for my $comp (@mxc) {
        for my $t (keys %{$triangles}){
            if ($t =~ m/$comp/) {
                my @t = split /-/, $t;
                if ($cnts{$t[0]} == $mx && $cnts{$t[1]} == $mx && $cnts{$t[2]} == $mx) {
                    $scc{$comp} = 1;
                }
            }
        }
    }
    return join(",",sort (keys %scc));
}

my @pairs = split /\n/, do { local( @ARGV, $/ ) = ( "input.txt" ); <> };
my %conn = connections(\@pairs);

my ($cnt,%triangles) = triangles(\%conn);
print "A: ",$cnt,"\n";
my $res = scc(\%conn,\%triangles);
print "B: ",$res,"\n";
