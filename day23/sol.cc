#include <algorithm>
#include <array>
#include <iomanip>
#include <iostream>
#include <limits>
#include <string>
#include <set>
#include <vector>

using namespace std;

constexpr int MIN_INT = numeric_limits<int>::min();
constexpr int MAX_INT = numeric_limits<int>::max();

constexpr int SZ = 2500;

constexpr array<int, 8> DIRS{ {-SZ - 1, -SZ, -SZ + 1, -1, 1, SZ - 1, SZ, SZ + 1}};

constexpr array<array<int, 3>, 4> PROP_DIRS{ {
  {-SZ - 1, -SZ, -SZ + 1},
  {SZ - 1,   SZ,  SZ + 1},
  {-SZ - 1, -1,  SZ - 1},
  {-SZ + 1, 1,  SZ + 1},
} };

struct Elf {
  int pos;
  int prop;
};

vector<Elf*> parse() {
  vector<Elf*> elves{};
  int y = 0;
  for (string line; getline(cin, line); y++) {
    for (int x = 0; x < line.length(); x++) {
      if (line[x] == '#') {
        elves.push_back(new Elf {.pos = (y + SZ / 2)*SZ + x + SZ/2, .prop = MIN_INT });
      }
    }
  }
  return elves;
}

bool step(vector<Elf*>& elves, vector<Elf*>& grid, vector<int>& props, int dir) {
  for (Elf* elf : elves) {
    if (any_of(DIRS.cbegin(), DIRS.cend(), [&elf, &grid](int d){ return grid[elf->pos+d] != NULL; })) {
      for (int i = 0; i < 4; i++) {
        array<int, 3> prop = PROP_DIRS[(dir+i) % 4];
        if (grid[elf->pos + prop[0]] == NULL
            && grid[elf->pos + prop[1]] == NULL
            && grid[elf->pos + prop[2]] == NULL) {
          elf->prop = elf->pos + prop[1];
          props[elf->prop] += 1;
          break;
        }
      }
    }
  }
  bool moved = false;
  for (Elf* elf : elves) {
    if (elf->prop != MIN_INT) {
      if (props[elf->prop] == 1) {
        moved = true;
        grid[elf->pos] = NULL;
        grid[elf->prop] = elf;
        elf->pos = elf->prop;
      }
      props[elf->prop] = 0;
      elf->prop = MIN_INT;
    }
  }
  return moved;
}

int main() {
  cout << "Day 23: C++" << endl;
  vector<Elf*> elves = parse();
  vector<Elf*> grid(SZ*SZ);
  for (Elf* elf : elves) {
    grid[elf->pos] = elf;
  }
  vector<int> props(SZ*SZ);
  int i = 0;
  for (; i < 10; i++) {
    step(elves, grid, props, i % 4);
  }
  int min_x = MAX_INT;
  int min_y = MAX_INT;
  int max_x = MIN_INT;
  int max_y = MIN_INT;
  for (Elf* elf : elves) {
    int x = elf->pos % SZ;
    int y = elf->pos / SZ;
    min_x = min(min_x, x);
    min_y = min(min_y, y);
    max_x = max(max_x, x + 1);
    max_y = max(max_y, y + 1);
  }
  cout << "Part 1: " << setw(20) << (max_x - min_x)*(max_y - min_y) - elves.size() << endl;
  for (;; i++) {
    if (!step(elves, grid, props, i % 4)) break;
  }
  cout << "Part 2: " << setw(20) << i + 1 << endl;
  return 0;
}
