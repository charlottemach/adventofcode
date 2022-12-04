<?php
$lines = explode("\n",trim(file_get_contents("four.txt")));
$cntA = 0;
$cntB = 0;
foreach ($lines as $line){
    $l = explode(",",$line);
    list($l1,$l2) = explode("-",$l[0],2);
    list($r1,$r2) = explode("-",$l[1],2);
    if (($l1 <= $r1 && $r2 <= $l2) || ($l1 >= $r1 && $r2 >= $l2)) {
        $cntA += 1;
    }
    if (!($l1 > $r2 || $r1 > $l2)) {
        $cntB += 1;
    }
}
echo "A: $cntA\n";
echo "B: $cntB\n";
?>
