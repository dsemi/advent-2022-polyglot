use std::collections::HashSet;
use std::ops::Add;

#[derive(Clone, Copy, Debug, Eq, Hash, Ord, PartialEq, PartialOrd)]
struct Coord {
    x: i32,
    y: i32,
}

impl Coord {
    const fn new(x: i32, y: i32) -> Self {
        Self { x, y }
    }
}

impl Add for Coord {
    type Output = Self;

    fn add(self, other: Self) -> Self {
        Self {
            x: self.x + other.x,
            y: self.y + other.y,
        }
    }
}

struct Valley {
    w: i32,
    h: i32,
    blizz: Vec<(Coord, Coord)>,
    walls: HashSet<Coord>,
}

impl Valley {
    fn new<I: Iterator<Item = std::io::Result<String>>>(inp: I) -> (Coord, Coord, Self) {
        let grid: Vec<Vec<char>> = inp.map(|l| l.unwrap().chars().collect()).collect();
        let h = grid.len() as i32 - 2;
        let w = grid[0].len() as i32 - 2;
        let start = Coord::new(0, 1);
        let goal = Coord::new(grid.len() as i32 - 1, grid[0].len() as i32 - 2);
        let mut blizz = Vec::new();
        let mut walls = HashSet::new();
        walls.insert(start + Coord::new(-1, 0));
        walls.insert(goal + Coord::new(1, 0));
        for (r, row) in grid.into_iter().enumerate() {
            for (c, v) in row.into_iter().enumerate() {
                match v {
                    '^' => blizz.push((Coord::new(r as i32, c as i32), Coord::new(-1, 0))),
                    'v' => blizz.push((Coord::new(r as i32, c as i32), Coord::new(1, 0))),
                    '<' => blizz.push((Coord::new(r as i32, c as i32), Coord::new(0, -1))),
                    '>' => blizz.push((Coord::new(r as i32, c as i32), Coord::new(0, 1))),
                    '#' => {
                        walls.insert(Coord::new(r as i32, c as i32));
                    }
                    _ => (),
                }
            }
        }
        (start, goal, Valley { w, h, blizz, walls })
    }

    fn shortest_path(&mut self, start: Coord, goal: Coord) -> usize {
        let mut t = 0;
        let mut edges: HashSet<Coord> = vec![start].into_iter().collect();
        while !edges.contains(&goal) {
            t += 1;
            let mut next_blizz = Vec::new();
            let mut blizz_set = HashSet::new();
            for (pos, d) in self.blizz.iter() {
                let pos2 = Coord::new(
                    (pos.x + d.x - 1).rem_euclid(self.h) + 1,
                    (pos.y + d.y - 1).rem_euclid(self.w) + 1,
                );
                next_blizz.push((pos2, *d));
                blizz_set.insert(pos2);
            }
            self.blizz = next_blizz;
            let mut next_edges = HashSet::new();
            for p in edges {
                if !self.walls.contains(&p) && !blizz_set.contains(&p) {
                    next_edges.insert(p);
                }
                for d in [
                    Coord::new(0, -1),
                    Coord::new(0, 1),
                    Coord::new(1, 0),
                    Coord::new(-1, 0),
                ] {
                    let p2 = p + d;
                    if !self.walls.contains(&p2) && !blizz_set.contains(&p2) {
                        next_edges.insert(p2);
                    }
                }
            }
            edges = next_edges;
        }
        t
    }
}

fn main() {
    println!("Day 24: Rust");
    let (start, goal, mut valley) = Valley::new(std::io::stdin().lines());
    let p1 = valley.shortest_path(start, goal);
    println!("Part 1: {:20}", p1);
    let p2 = p1 + valley.shortest_path(goal, start) + valley.shortest_path(start, goal);
    println!("Part 2: {:20}", p2);
}
