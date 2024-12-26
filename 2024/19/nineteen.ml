module StringMap= Map.Make(String)

let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (Bytes.unsafe_to_string s)

let print_list l = List.iter (fun e -> Printf.printf "%s\n" e) l
let print_hash h =  Hashtbl.iter (fun x y -> Printf.printf "%s -> %d\n" x y) h

let poss_memo towel patterns =
    let h = Hashtbl.create 20 in
    let pts = patterns in
    let rec tp t patterns =
         try Hashtbl.find h t
         with Not_found -> let res =
                if (String.length t) == 0 then 1
                else if patterns == [] then 0
                else if (String.starts_with ~prefix:(List.hd patterns) t) then
                    tp (Str.string_after t (String.length (List.hd patterns))) pts
                    + tp t (List.tl patterns)
                else tp t (List.tl patterns)
                in
                Hashtbl.add h t res;
                res
        in
        tp towel patterns


let rec poss_h = fun towel patterns ps ->
    match towel, patterns, ps with
    | "", _, _ -> 1
    | _, [], _ -> 0
    | towel, (p::ps), pts -> if (String.starts_with ~prefix:p towel) then
                   let poss = (poss_h (Str.string_after towel (String.length p)) pts pts) in
                       if (poss > 0) then 1 else poss_h towel ps pts
                    else (poss_h towel ps pts)

let rec possible = fun towels patterns ->
    match towels, patterns with
    | [], _ -> 0
    | (t::ts), patterns -> if (poss_h t patterns patterns) > 0 then 1 + (possible ts patterns)
                           else possible ts patterns

let rec all_possible = fun towels patterns ->
    match towels, patterns with
    | [], _ -> 0
    | (t::ts), patterns -> (poss_memo t patterns) + (all_possible ts patterns)

let parse file =
    let s = load_file file in
    let inp = Str.split (Str.regexp "\n\n") s in
    let patterns = List.map String.trim (String.split_on_char ',' (List.hd inp)) in
    let towels = String.split_on_char '\n' (String.trim (List.nth inp 1)) in
    (patterns,towels)

let () =
    let (patterns,towels) = parse "input.txt" in
    Printf.printf "A: %d\n" (possible towels patterns);
    Printf.printf "B: %d\n" (all_possible towels patterns);
;;
