fun readFile path =
  (fn strm =>
    TextIO.inputAll strm before TextIO.closeIn strm) (TextIO.openIn path)

val fileList = String.explode(readFile "six.txt");
val inp = List.map (fn x => valOf (Int.fromString (str x))) (List.filter (fn x => Char.isDigit x) fileList);

fun getFish _ 0 = 1
    | getFish 0 days = getFish 6 (days - 1) + getFish 8 (days - 1)
    | getFish timer days = getFish (timer-1) (days-1);

fun sumList [] = 0
    | sumList (x::xs) = x + (sumList xs)

fun count (c : int, s : int list) = List.length (List.filter (fn x => x = c) s)
fun multList l1 l2 = ListPair.map op* (l1, l2)

val nums = map (fn x => count (x, inp)) [1,2,3,4,5]
(* A *)
(*val fish = map (fn x => getFish x 80) [1,2,3,4,5]*)
(* B *)
val fish = map (fn x => getFish x 256) [1,2,3,4,5]
val res = multList fish nums
val s = sumList res
