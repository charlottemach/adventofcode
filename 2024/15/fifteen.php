<?php

function parse_file($fl){
    $sx = 0; $sy = 0; $map = [];
    $lines = explode("\n\n",trim(file_get_contents($fl)));
    foreach (explode("\n",$lines[0]) as $yi=>$line){
        foreach (str_split($line) as $xi=>$v) {
            if ($v == "@") {
                $sx = $xi; $sy = $yi;
            }
            $map[$yi][$xi] = $v;
        }
    }
    $instrs = str_split(str_replace("\n", '', $lines[1]));
    return [$sx,$sy,$map,$instrs];
}

function pprint($m) {
    foreach($m as $line) {
        echo join("",$line) . "\n";
    }
    echo "\n";
}

function follow_instr($instrs,$sx,$sy,$map) {
    foreach ($instrs as $instr) {
        if ($instr == ">") {
            $dirx = 1; $diry = 0;
        } else if ($instr == "v") {
            $dirx = 0; $diry = 1;
        } else if ($instr == "<") {
            $dirx = -1; $diry = 0;
        } else { // "^":
            $dirx = 0; $diry = -1;
        }
        [$sx,$sy,$map] = move($sx,$sy,$dirx,$diry,$map);
    }
    return $map;
}

function resize($map) {
    $rmap = [];
    foreach ($map as $y => $row) {
        $rrow = [];
        foreach ($row as $x => $val) {
            if ($val == "#" || $val == ".") {
                array_push($rrow,$val,$val);
            } else if ($val == "O") {
                array_push($rrow,"[","]");
            } else if ($val == ".") {
                array_push($rrow,".",".");
            } else { // @
                array_push($rrow, "@",".");
            }
        }
        $rmap[$y]= $rrow;
    }
    return $rmap;
}

function can_move($sx,$sy,$dirx,$diry,$map) {
    $nx = $sx + $dirx; $ny = $sy + $diry;
    $next = $map[$ny][$nx];
    if ($next == "#") {
        return false;
    } else if ($next == ".") {
        return true;
    } else if ($dirx == 0) { // moving up/down - move multiple
        if ($next == "[") {
            return can_move($nx,$ny,$dirx,$diry,$map) && can_move($nx+1,$ny,$dirx,$diry,$map);
        }
        else if ($next == "]") {
            return can_move($nx,$ny,$dirx,$diry,$map) && can_move($nx-1,$ny,$dirx,$diry,$map);
        }
    }
    return can_move($nx,$ny,$dirx,$diry,$map);
}

function moveB($x,$y,$prev,$dirx,$diry,$map) {
    $val = $map[$y][$x];
    $nx = $x + $dirx; $ny = $y + $diry;
    $next = $map[$ny][$nx];

    $map[$y][$x] = $prev;
    if ($next == ".") {
        $map[$ny][$nx] = $val;
    } else {
        if ($next == "[") {
            $map = moveB($nx,$ny,$val,$dirx,$diry,$map);
            $map = moveB($nx+1,$ny,".",$dirx,$diry,$map);
        } else if ($next == "]") {
            $map = moveB($nx,$ny,$val,$dirx,$diry,$map);
            $map = moveB($nx-1,$ny,".",$dirx,$diry,$map);
        }
    }
    return $map;
}

function move($sx,$sy,$dirx,$diry,$map) {
    $prev = $map[$sy][$sx];
    $nx = $sx + $dirx;
    $ny = $sy + $diry;
    $next = $map[$ny][$nx];
    $can = can_move($sx,$sy,$dirx,$diry,$map);

    if ($can) {
        if ($map[$ny][$nx] == ".") {
            $map[$sy][$sx] = ".";
            $map[$ny][$nx] = $prev;
            return [$nx,$ny,$map];
        } else if ($next == "[" || $next == "]" || $next == "O") {
            if ($dirx == 0 && $next != "O") {
                $map = moveB($sx,$sy,".",$dirx,$diry,$map);
                $sx = $nx; $sy = $ny;
            } else {
                $map[$sy][$sx] = ".";
                while (true) {
                    $tmp = $map[$ny][$nx];
                    $map[$ny][$nx] = $prev;
                    $prev = $tmp;
                    $nx += $dirx; $ny += $diry;
                    if ($map[$ny][$nx] == ".") {
                        $map[$ny][$nx] = $prev;
                        return [$sx+$dirx,$sy+$diry,$map];
                    }
                }
            }
        }
    }
    return [$sx,$sy,$map];
}

function gps($map) {
    $s = 0;
    foreach ($map as $y=>$row) {
        foreach ($row as $x=>$val) {
            if ($val == "O" || $val == "[") {
                $s += 100 * $y + $x;
            }
        }
    }
    return $s;
}

[$sx,$sy,$map,$instrs] = parse_file("input.txt");
$rmap = resize($map);

$map = follow_instr($instrs,$sx,$sy,$map);
// pprint($map);
$cntA = gps($map);
echo "A: $cntA\n";

$rmap = follow_instr($instrs,$sx*2,$sy,$rmap);
// pprint($rmap);
$cntB = gps($rmap);
echo "B: $cntB\n";
?>
