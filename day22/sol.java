import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class sol {
  record Coord(int x, int y) {}
  record CC(Coord a, Coord b) {}

  static int walk(List<String> grid, String instrs, Map<CC, CC> portals) {
    Coord pos = new Coord(0, grid.get(0).indexOf('.'));
    Coord dir = new Coord(0, 1);
    Matcher m = Pattern.compile("\\d+|.").matcher(instrs);
    while (m.find()) {
      String instr = m.group();
      if (instr.equals("L")) {
        dir = new Coord(-dir.y, dir.x);
      } else if (instr.equals("R")) {
        dir = new Coord(dir.y, -dir.x);
      } else {
        int n = Integer.parseInt(instr);
        for (int i = 0; i < n; i++) {
          Coord pos2 = new Coord(pos.x + dir.x, pos.y + dir.y);
          Coord dir2 = dir;
          CC val = portals.get(new CC(pos, dir));
          if (val != null) {
            pos2 = val.a;
            dir2 = val.b;
          }
          if (grid.get(pos2.x).charAt(pos2.y) == '#') {
            break;
          }
          pos = pos2;
          dir = dir2;
        }
      }
    }
    int row = pos.x + 1;
    int col = pos.y + 1;
    int facing = 0;
    if (dir.equals(new Coord(0, 1))) {
      facing = 0;
    } else if (dir.equals(new Coord(1, 0))) {
      facing = 1;
    } else if (dir.equals(new Coord(0, -1))) {
      facing = 2;
    } else if (dir.equals(new Coord(-1, 0))) {
      facing = 3;
    }
    return 1000*row + 4*col + facing;
  }

  public static void main(String[] args) {
    System.out.println("Day 22: Java");
    Scanner sc = new Scanner(System.in);
    List<String> grid = new ArrayList<>();
    String instrs = null;
    while (sc.hasNextLine()) {
      String line = sc.nextLine();
      if (line.equals("")) {
        instrs = sc.nextLine();
        continue;
      }
      grid.add(line);
    }
    Map<CC, CC> portals = new HashMap<>();
    for (int i = 0; i < 50; i++) {
      portals.put(new CC(new Coord(0, 50 + i), new Coord(-1, 0)),
                  new CC(new Coord(149, 50 + i), new Coord(-1, 0)));
      portals.put(new CC(new Coord(149, 50 + i), new Coord(1, 0)),
                  new CC(new Coord(0, 50 + i), new Coord(1, 0)));
      portals.put(new CC(new Coord(0, 100 + i), new Coord(-1, 0)),
                  new CC(new Coord(49, 100 + i), new Coord(-1, 0)));
      portals.put(new CC(new Coord(49, 100 + i), new Coord(1, 0)),
                  new CC(new Coord(0, 100 + i), new Coord(1, 0)));
      portals.put(new CC(new Coord(0 + i, 50), new Coord(0, -1)),
                  new CC(new Coord(0 + i, 149), new Coord(0, -1)));
      portals.put(new CC(new Coord(0 + i, 149), new Coord(0, 1)),
                  new CC(new Coord(0 + i, 50), new Coord(0, 1)));
      portals.put(new CC(new Coord(50 + i, 50), new Coord(0, -1)),
                  new CC(new Coord(50 + i, 99), new Coord(0, -1)));
      portals.put(new CC(new Coord(50 + i, 99), new Coord(0, 1)),
                  new CC(new Coord(50 + i, 50), new Coord(0, 1)));
      portals.put(new CC(new Coord(100, 0 + i), new Coord(-1, 0)),
                  new CC(new Coord(199, 0 + i), new Coord(-1, 0)));
      portals.put(new CC(new Coord(199, 0 + i), new Coord(1, 0)),
                  new CC(new Coord(100, 0 + i), new Coord(1, 0)));
      portals.put(new CC(new Coord(100 + i, 0), new Coord(0, -1)),
                  new CC(new Coord(100 + i, 99), new Coord(0, -1)));
      portals.put(new CC(new Coord(100 + i, 99), new Coord(0, 1)),
                  new CC(new Coord(100 + i, 0), new Coord(0, 1)));
      portals.put(new CC(new Coord(150 + i, 0), new Coord(0, -1)),
                  new CC(new Coord(150 + i, 49), new Coord(0, -1)));
      portals.put(new CC(new Coord(150 + i, 49), new Coord(0, 1)),
                  new CC(new Coord(150 + i, 0), new Coord(0, 1)));
    }
    int p1 = walk(grid, instrs, portals);
    System.out.printf("Part 1: %20d\n", p1);
    Map<CC, CC> portals2 = new HashMap<>();
    for (int i = 0; i < 50; i++) {
      portals2.put(new CC(new Coord(0, 50 + i), new Coord(-1, 0)),
                   new CC(new Coord(150 + i, 0), new Coord(0, 1)));
      portals2.put(new CC(new Coord(150 + i, 0), new Coord(0, -1)),
                   new CC(new Coord(0, 50 + i), new Coord(1, 0)));
      portals2.put(new CC(new Coord(0, 100 + i), new Coord(-1, 0)),
                   new CC(new Coord(199, 0 + i), new Coord(-1, 0)));
      portals2.put(new CC(new Coord(199, 0 + i), new Coord(1, 0)),
                   new CC(new Coord(0, 100 + i), new Coord(1, 0)));
      portals2.put(new CC(new Coord(0 + i, 50), new Coord(0, -1)),
                   new CC(new Coord(149 - i, 0), new Coord(0, 1)));
      portals2.put(new CC(new Coord(149 - i, 0), new Coord(0, -1)),
                   new CC(new Coord(0 + i, 50), new Coord(0, 1)));
      portals2.put(new CC(new Coord(0 + i, 149), new Coord(0, 1)),
                   new CC(new Coord(149 - i, 99), new Coord(0, -1)));
      portals2.put(new CC(new Coord(149 - i, 99), new Coord(0, 1)),
                   new CC(new Coord(0 + i, 149), new Coord(0, -1)));
      portals2.put(new CC(new Coord(49, 100 + i), new Coord(1, 0)),
                   new CC(new Coord(50 + i, 99), new Coord(0, -1)));
      portals2.put(new CC(new Coord(50 + i, 99), new Coord(0, 1)),
                   new CC(new Coord(49, 100 + i), new Coord(-1, 0)));
      portals2.put(new CC(new Coord(50 + i, 50), new Coord(0, -1)),
                   new CC(new Coord(100, 0 + i), new Coord(1, 0)));
      portals2.put(new CC(new Coord(100, 0 + i), new Coord(-1, 0)),
                   new CC(new Coord(50 + i, 50), new Coord(0, 1)));
      portals2.put(new CC(new Coord(149, 50 + i), new Coord(1, 0)),
                   new CC(new Coord(150 + i, 49), new Coord(0, -1)));
      portals2.put(new CC(new Coord(150 + i, 49), new Coord(0, 1)),
                   new CC(new Coord(149, 50 + i), new Coord(-1, 0)));
    }
    int p2 = walk(grid, instrs, portals2);
    System.out.printf("Part 2: %20d\n", p2);
  }
}
