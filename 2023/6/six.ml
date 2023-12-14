let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  really_input ic s 0 n;
  close_in ic;
  (Bytes.unsafe_to_string s)

let print_list l = List.iter (fun e -> Printf.printf "%s\n" e) l
let print_list_int l = List.iter (fun e -> Printf.printf "%d\n" e) l

let strip s = String.concat "" (String.split_on_char ' ' s)

let rec prod = function
  | [] -> 1
  | h::t -> h * (prod t)

let travel total cur = (total - cur) * cur

let number_of_ways (t,d)  = 
  let mn = 1 in
  let mx = t-1 in
  let rec aux t d mn mx =
      if mn == mx then if (travel t mn) > d then 1 else 0
      else 
        let mn_travel = travel t mn in
        let mx_travel = travel t mx in
          if (mn_travel <= d && mx_travel <= d) then aux t d (mn+1) (mx-1)
          else if (mn_travel <= d) then aux t d (mn+1) mx
          else if (mx_travel <= d) then aux t d mn (mx-1)
          else mx-mn+1
  in
  aux t d mn mx

let parse file =
    let s = load_file file in
    let ls = String.split_on_char '\n' s in
    let times = List.map int_of_string (List.tl (String.split_on_char ' ' (List.hd ls))) in
    let dists = List.map int_of_string (List.tl (String.split_on_char ' ' (List.nth ls 1))) in
    List.combine times dists
 

let () =
    let races = parse "input.txt" in
    print_int (prod (List.map number_of_ways races));
    print_string "\n";

    let races_b = parse "input_b.txt" in
    print_int (prod (List.map number_of_ways races_b));
;;
