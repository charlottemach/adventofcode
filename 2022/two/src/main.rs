use std::collections::HashMap;
use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>>
where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

macro_rules! hashmap {
    ($( $key: expr => $val: expr ),*) => {{
         let mut map = HashMap::new();
         $( map.insert($key, $val); )*
         map
    }}
}

fn get_score_a(p1_val: &i32, p2_val: &i32) -> i32 {
    let mut score_a = 0;
    let s = p1_val - p2_val;
    if s == -1 || s == 2{
        score_a += 6;
    }
    else if p1_val == p2_val{
        score_a += 3;
    }
    score_a += p2_val;
    return score_a;
}

fn get_score_b(p1: &str, p2: &str, p1_val: &i32) -> i32 {
    let mut score_b = 0;
    if p2 == "Y" { // draw
        score_b += 3 + p1_val;
    }
    else if p2 == "X" {   // lose
        if p1 == "A" {
            score_b += 3;
        }
        else {
            score_b += p1_val - 1;
        }
    }
    else { // win
        if p1 == "C" {
            score_b += 1;
        }
        else {
            score_b += p1_val + 1;
        }
        score_b += 6;
    }
    return score_b;
}

fn main() {
    if let Ok(lines) = read_lines("./two.txt") {
        let mut score_a = 0;
        let mut score_b = 0;
        for line in lines {
            if let Ok(val) = line {
                let mut moves = val.split(|x| x == ' ');
                let p1 = moves.next().unwrap();
                let p2 = moves.next().unwrap();
                let values = hashmap!['A' => 1, 'X' => 1, 'B' => 2, 'Y' => 2, 'C' => 3, 'Z' => 3];
                let p1_val = values.get(&p1.chars().next().unwrap()).unwrap();
                let p2_val = values.get(&p2.chars().next().unwrap()).unwrap();

                score_a += get_score_a(&p1_val,&p2_val);
                score_b += get_score_b(p1,p2,&p1_val);
            }
        }
        println!("A: {}",score_a);
        println!("B: {}",score_b);
    }
}
