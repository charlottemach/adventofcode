<?php
$arr = explode("\n",trim(file_get_contents("fourteen.txt")));
$pol = $arr[0];
$polB = $pol;
$input = array_slice($arr,2);
static $dict = [];
foreach ($input as $line){
    $l = explode(" ",$line);
    $pair = $l[0];
    $dict[$pair] = $l[2];
}

function newPol($pol){
    global $dict;
    $np = "";
    $pols = str_split($pol);
    for ($i=0; $i<count($pols)-1; $i++){
        $pair = $pols[$i] . $pols[$i+1];
        $insert = array_key_exists($pair, $dict) ? $dict[$pair] : "";
        $np .= $pols[$i] . $insert;
    }
    return $np . $pols[count($pols)-1];
}

function getDiff($str){
    $totals = array_count_values(str_split($str));
    arsort($totals);
    return $totals[array_keys($totals)[0]] - $totals[array_keys($totals)[count($totals)-1]] . "\n";
}

// Part A:
// for ($i=0; $i<10; $i++){
//     $pol = newPol($pol);
// }
// print getDiff($pol);
// 
// Part B:
// function expand($pol, $n, &$mem=[]){
//     global $dict;
//     if (strlen($pol) == 2){
//         $spl = str_split($pol); # [$l, $r] = str_split($pol);
//         $insert = $spl[0] . $dict[$pol]; #$insert = $l . $dict[$pol];
//         if ($n == 1) { 
//             return $insert; 
//         } 
//         else {
//             return expand($insert . $spl[1],$n-1); #return expand($insert . $right,$n-1);
//         }
//     }
//     if (!array_key_exists($pol,$mem)) {
//         $pair = substr($pol,0,2);
//         $rest = substr($pol,1);
//         $mem[$pol] = expand($pair, $n, $mem) . expand($rest, $n, $mem);
//     }
//     return $mem[$pol];
// }
// echo getDiff(expand($polB,40) . "V");


// Part B:
function countPairs($pol, $n){
    global $dict;
    $pairs = [];
    for ($i=0;$i<strlen($pol);$i++){
        $k = substr($pol,$i,2);
        if (strlen($k) == 2) {
            $pairs[$k] = array_key_exists($k,$pairs) ? $pairs[$k] += 1 : 1;
        }
    }
    for ($i=0;$i<$n;$i++){
        foreach ($pairs as $p => $cnt){
            [$l,$r] = str_split($p);
            $l = $l . $dict[$p];
            $r = $dict[$p] . $r;
            $pairs[$l] = array_key_exists($l,$pairs) ? $pairs[$l] += $cnt : $cnt;
            $pairs[$r] = array_key_exists($r,$pairs) ? $pairs[$r] += $cnt : $cnt;
            $pairs[$p] -= $cnt;
        }
    }
    $singles = [];
    foreach ($pairs as $p => $cnt){
        $s = str_split($p)[0];
        $singles[$s] = array_key_exists($s,$singles) ? $singles[$s] += $cnt : $cnt;
    }
    $min = $singles["N"];
    $max = 0;
    foreach ($singles as $k => $v){
        if ($singles[$k] < $min) { $min = $singles[$k]; }
        elseif ($singles[$k] > $max) { $max = $singles[$k]; }
    }
    echo "Res: ",$max-$min,"\n";
}
countPairs($polB, 10);
countPairs($polB, 40);
?>
