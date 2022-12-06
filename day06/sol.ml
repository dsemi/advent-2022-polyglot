let solve nchars input =
  let rec go c xs =
    if List.length (List.sort_uniq compare (List.init nchars (String.get xs))) == nchars
    then c
    else go (c+1) (String.sub xs 1 (String.length xs - 1)) in
  go nchars input

let () =
  print_endline "Day 6: OCaml";
  let input = read_line () in
  Printf.printf "Part 1: %20d\n" (solve 4 input);
  Printf.printf "Part 2: %20d\n" (solve 14 input);
