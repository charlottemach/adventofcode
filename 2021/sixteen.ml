#!/usr/bin/ocaml

let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (Bytes.unsafe_to_string s)

(* list of chars *)
let explode s =
  let rec exp i l =
    if i < 0 then l else exp (i - 1) (s.[i] :: l) in
  exp (String.length s - 1) []

(* list of strings *)
let exp s = String.to_seq s |> List.of_seq |> List.map (String.make 1);;

let print_list l = List.iter (fun e -> Printf.printf "%s\n" e) l
let print_clist l = List.iter (fun e -> Printf.printf "%c\n" e) l

let hex2int hex = int_of_string ("0x" ^ String.make 1 hex)

let bin2int bin = int_of_string ("0b" ^ bin)

let int2bin d =
  if d < 0 then invalid_arg "bin_of_int" else
  if d = 0 then "0" else
  let rec aux acc d =
    if d = 0 then acc else
    aux (string_of_int (d land 1) :: acc) (d lsr 1)
  in
  String.concat "" (aux [] d)

let pad s =
  let len = String.length s in
    let pad str ln = match ln with
        | 1 -> "000"^str
        | 2 -> "00"^str
        | 3 -> "0"^str
        | _ -> str
     in pad s len

let rec get_bin s = match s with
  | [] -> ""
  | x :: xs -> pad (int2bin (hex2int x)) ^ get_bin xs

let rec skip_n(bs,n,v) = match bs,n,v with
  | (bs,0,v) -> (bin2int(v),bs)
  | (b::bs,n,v) -> skip_n(bs,n-1,v^b)
  | (bs,_,_) -> (0,bs)

let rec parse (bs, i, op, vs) = match bs,i,op,vs with
  | ([], _, _, vs) -> vs
  | (bs, 0, op, vs) -> if ((List.length bs) >= 6) then parse (bs, -1, op, vs)
                        else parse ([], 0, op, vs)
  | (a::b::c::d::e::f::bs,-1,_,vs) -> let newvs = vs + bin2int(a^b^c) in
                           if (bin2int(d^e^f) == 4) then parse (bs, 6, false, newvs)
                           else parse (bs, 6, true, newvs)
  | (a::b::c::d::e::bs, 6, false, vs) -> if bin2int(a) == 1 then parse (bs, 6, false, vs)
                             else parse (bs, 0, false, vs)
  | (a::bs, 6, true, vs) -> if bin2int(a) == 0 then 
                            let (v, content) = skip_n(bs,15,"") in
                                parse (content, 0, true, vs)
                            else let (v, rest) = skip_n(bs,11,"") in
                                parse (rest, 0, true, vs)
  | (_,_,_,_) -> 999

let () =
    let s = explode (load_file "sixteen.txt") in
    let cs = List.filter (fun x -> x != '\n') s in
    let binlist = exp (get_bin cs) in
        print_int (parse(binlist, 0, false,0))
;;
