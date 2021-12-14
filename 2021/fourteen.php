<?php
$arr = explode("\n",trim(file_get_contents("fourteen.txt")));
$pol = $arr[0];
$input = array_slice($arr,2);
$dict = [];
foreach ($input as $line){
    $l = explode(" ",$line);
    $dict[$l[0]] = $l[2];
}

function countPairs($pol, $n){
    global $dict;
    $pairs = [];
    for ($i=0;$i<strlen($pol)-1;$i++){
        $k = substr($pol,$i,2);
        $pairs[$k] = array_key_exists($k,$pairs) ? $pairs[$k] += 1 : 1;
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
        $singles[$p[0]] = array_key_exists($p[0],$singles) ? $singles[$p[0]] += $cnt : $cnt;
    }
    $singles[substr($pol, -1)] += 1;
    natsort($singles);
    echo "Res: ",end($singles)-array_values($singles)[0],"\n";
}
countPairs($pol, 10);
countPairs($pol, 40);
?>
