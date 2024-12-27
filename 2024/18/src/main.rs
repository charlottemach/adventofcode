use std::fs::File;
use std::io::{self, BufRead};
use std::path::Path;
use std::collections::VecDeque;
use std::collections::HashMap;

fn read_lines<P>(filename: P) -> io::Result<io::Lines<io::BufReader<File>>> where P: AsRef<Path>, {
    let file = File::open(filename)?;
    Ok(io::BufReader::new(file).lines())
}

fn neighbours(map: &Vec<Vec<i32>>, n: &(i32,i32)) -> Vec<(i32,i32)> {
    let mut nb = Vec::new();
    let ln = map.len() as i32;
    let (x,y) = n;
    for i in [(0,1),(1,0),(0,-1),(-1,0)] {
        let (dx,dy) = i;
        let nx = x+dx; let ny = y+dy;
        if nx >= 0 && ny >= 0 && nx < ln && ny < ln {
            let v = map[ny as usize][nx as usize];
            if v == 0 {
              nb.push((nx,ny));
            }
        }
    }
    return nb;
}

fn path(p: &HashMap<(i32,i32),(i32,i32)>, n:i32) -> i32 {
    let mut s = 1;
    let mut init:&(i32,i32) = p.get(&(n,n)).unwrap();
    while init != &(0,0) {
        init = p.get(init).unwrap();
        s = s+1;
    }
    return s;
}

fn bfs(map: &Vec<Vec<i32>>) -> i32 {
    let n = (map.len() as i32)- 1;
    let mut visited = vec![(0,0)];
    let mut q:VecDeque<(i32,i32)> = VecDeque::from([(0,0)]);
    let mut parents = HashMap::new();
    while q.len() > 0 {
        let v = q.pop_front().unwrap();
        if v == (n,n) {
            return path(&parents,n);
        }
        for nb in neighbours(&map,&v) {
            if !visited.contains(&nb) {
                visited.push(nb);
                q.push_back(nb);
                parents.insert(nb,v);
            }
        }
    }
    return -1;
}

fn main() {
    if let Ok(lines) = read_lines("./input.txt") {
        let mut limit = 0;
        let n = 71; let max = 1024;
        let mut map = vec![vec![0; n]; n];
        let mut todo = VecDeque::new();

        for line in lines {
            if let Ok(val) = line {
                let mut coord = val.split(',');
                let x = coord.next().unwrap().parse::<usize>().unwrap();
                let y = coord.next().unwrap().parse::<usize>().unwrap();
                if limit == max {
                    todo.push_back((x,y));
                } else {
                    map[y][x] = 1;
                    limit = limit + 1;
                }
            }
        }
        let mut steps = bfs(&map);
        println!("A: {}", steps);

        let mut bx = 0; let mut by = 0;
        while steps != -1 {
            let (x,y) = todo.pop_front().unwrap();
            map[y][x] = 1;
            steps = bfs(&map);
            bx = x; by = y;
        }
        println!("B: {},{}",bx,by);
    }
}
