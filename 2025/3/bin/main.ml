let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (Bytes.unsafe_to_string s)

(*
let print_list l = List.iter (fun e -> Printf.printf "%s\n" e) l
let print_nested_list l = List.iter print_list l
*)

let rec first_n n ls = match ls with
  | [] -> failwith "fail"
  | l::ls -> if n=1 then [l] else l::first_n (n-1) ls;;

let explode s = Str.split (Str.regexp "") s

let parse file =
    let s = load_file file in
    let inp = Str.split (Str.regexp "\n") s in
    let lines = List.map explode inp in
    lines

(* part 1*)
let rec get_jolts = fun jolts mx1 mx2 ->
    match jolts, mx1, mx2 with
    | [], mx1, mx2 -> (string_of_int mx1) ^ (string_of_int mx2)
    | (h::rs), mx1, mx2 -> let h = int_of_string(h) in
                            if (h > mx1 && List.length(rs) > 0) then get_jolts rs h 0
                            else if h > mx2 then get_jolts rs mx1 h
                            else get_jolts rs mx1 mx2

(* part 2*)
let rec j_helper = fun num mx ln ->
    match num,mx,ln with
    | num, [], _ -> [num]
    | num, (mh::mrs), ln -> if ln > 10 && num > mh then [num]
                        else (mh::(j_helper num mrs (ln + 1)))

let rec get_more_jolts = fun jolts mx ->
    match jolts, mx with
    | [], mx -> first_n 12 mx
    | (h::rs), [] -> get_more_jolts rs [h]
    | (h::rs), (mh::mrs) -> get_more_jolts rs (j_helper h (mh::mrs) (List.length rs))


let () =
    let lines = parse "input.txt" in
    let res = List.map (fun line -> get_jolts line 0 0) lines in
    Printf.printf "A: %d\n" (List.fold_left (+) 0 (List.map int_of_string res));

    let resB = List.map (fun line -> String.concat "" (List.map string_of_int (get_more_jolts (List.map int_of_string line) []))) lines in
    Printf.printf "B: %s\n" (Z.to_string (List.fold_left Z.add (Z.of_int 0) (List.map Z.of_string resB)));
;;
