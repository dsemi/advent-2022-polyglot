#include <algorithm>
#include <iomanip>
#include <iostream>
#include <limits>
#include <string>
#include <set>
#include <vector>

using namespace std;

typedef pair<int, int> coord;
#define x first
#define y second

coord DIRS[8] = {{-1, 1}, {0, 1}, {1, 1}, {-1, 0}, {1, 0}, {-1, -1}, {0, -1}, {1, -1}};

coord mv(const set<coord>& elves, coord elf, int dir) {
  vector<bool> adjs{};
  for (coord d : DIRS) {
    coord pt = make_pair(elf.x + d.x, elf.y + d.y);
    adjs.push_back(!elves.contains(pt));
  }
  if (!all_of(adjs.cbegin(), adjs.cend(), [](bool b){ return b; })) {
    pair<bool, coord> poss[4] = {{adjs[0] && adjs[1] && adjs[2], {elf.x, elf.y+1}},
                                 {adjs[5] && adjs[6] && adjs[7], {elf.x, elf.y-1}},
                                 {adjs[0] && adjs[3] && adjs[5], {elf.x-1, elf.y}},
                                 {adjs[2] && adjs[4] && adjs[7], {elf.x+1, elf.y}}};
    for (int i = 0; i < 4; i++) {
      pair<bool, coord> p = poss[(dir + i) % 4];
      if (p.first) {
        return p.second;
      }
    }
  }
  return elf;
}

set<coord> parse() {
  set<coord> s{};
  int r = 0;
  for (string line; getline(cin, line); r++) {
    for (int c = 0; c < line.length(); c++) {
      if (line[c] == '#') {
        s.emplace(c, -r);
      }
    }
  }
  return s;
}

bool step(set<coord>& elves, int dir) {
  set<coord> elves2 = elves;
  elves.clear();
  int c = 0;
  for (coord elf : elves2) {
    coord elf2 = mv(elves2, elf, dir);
    c += elf != elf2;
    if (!elves.insert(elf2).second) {
      c--;
      elves.erase(elf2);
      elves.insert(elf);
      elves.emplace(elf2.x*2-elf.x, elf2.y*2-elf.y);
    }
  }
  return c > 0;
}

int main() {
  cout << "Day 23: C++" << endl;
  set<coord> elves = parse();
  int i = 0;
  for (; i < 10; i++) {
    step(elves, i % 4);
  }
  int min_x = numeric_limits<int>::max();
  int min_y = numeric_limits<int>::max();
  int max_x = numeric_limits<int>::min();
  int max_y = numeric_limits<int>::min();
  for (coord elf : elves) {
    min_x = min(min_x, elf.x);
    min_y = min(min_y, elf.y);
    max_x = max(max_x, elf.x + 1);
    max_y = max(max_y, elf.y + 1);
  }
  cout << "Part 1: " << setw(20) << (max_x - min_x)*(max_y - min_y) - elves.size() << endl;
  for (;; i++) {
    if (!step(elves, i % 4)) break;
  }
  cout << "Part 2: " << setw(20) << i + 1 << endl;
  return 0;
}
