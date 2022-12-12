import 'dart:collection';
import 'dart:convert';
import 'dart:io';

class Coord {
  final int x;
  final int y;

  Coord(this.x, this.y);

  bool operator==(final Object o) {
    return o is Coord && this.x == o.x && this.y == o.y;
  }

  int get hashCode => this.x * 31 + this.y;
}

class Pair<A, B> {
  final A a;
  final B b;

  Pair(this.a, this.b);
}

int bfs(List<List<int>> grid, List<Coord> starts, Coord end) {
  HashSet<Coord> visited = HashSet.from(starts);
  Queue<Pair<int, Coord>> frontier = Queue();
  starts.forEach((start) => frontier.add(Pair<int, Coord>(0, start)));
  while (frontier.isNotEmpty) {
    Pair<int, Coord> dst = frontier.removeFirst();
    if (dst.b == end) {
      return dst.a;
    }
    int lim = grid[dst.b.x][dst.b.y] + 1;
    List<Coord> ns = [Coord(-1, 0), Coord(1, 0), Coord(0, -1), Coord(0, 1)];
    for (int i = 0; i < ns.length; i++) {
      Coord st = Coord(dst.b.x + ns[i].x, dst.b.y + ns[i].y);
      if (st.x >= 0 && st.x < grid.length && st.y >= 0 && st.y < grid[0].length && grid[st.x][st.y] <= lim) {
        if (visited.add(st)) {
          frontier.addLast(Pair<int, Coord>(dst.a + 1, st));
        }
      }
    }
  }
  return -1;
}

void main() async {
  print('Day 12: Dart');
  Coord start = Coord(0, 0);
  List<Coord> starts = List.empty(growable: true);
  Coord end = Coord(0, 0);
  List<List<int>> grid = List.empty(growable: true);
  int r = 0;
  await for (final line in stdin.transform(utf8.decoder).transform(const LineSplitter())) {
    grid.add(List<int>.empty(growable: true));
    for (int c = 0; c < line.length; c++) {
      var l = line[c];
      if (line[c] == 'S') {
        start = Coord(r, c);
        starts.add(Coord(r, c));
        l = 'a';
      } else if (line[c] == 'E') {
        end = Coord(r, c);
        l = 'z';
      } else if (line[c] == 'a') {
        starts.add(Coord(r, c));
      }
      grid.last.add(l.codeUnits.first - 'a'.codeUnits.first);
    }
    r++;
  }
  print('Part 1:                  ' + bfs(grid, [start], end).toString());
  print('Part 2:                  ' + bfs(grid, starts, end).toString());
}
