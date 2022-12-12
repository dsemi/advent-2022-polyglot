import std.algorithm;
import std.array;
import std.conv;
import std.numeric;
import std.stdio;
import std.string;

struct Monkey {
  ulong[] items;
  ulong delegate(ulong) op;
  ulong divisor;
  ulong trueIdx;
  ulong falseIdx;
}

Monkey parseMonkey(string input) {
  auto lines = input.splitLines;
  Monkey m = {
    items: lines[1].split(": ")[1].split(", ").map!(x => parse!ulong(x)).array,
    divisor: lines[3].split(" ")[$-1].parse!ulong,
    trueIdx: lines[4].split(" ")[$-1].parse!ulong,
    falseIdx: lines[5].split(" ")[$-1].parse!ulong,
  };
  auto pts = lines[2].split(" ")[$-2 .. $];
  if (pts[1] == "old") {
    m.op = (b => b * b);
  } else {
    ulong n = pts[1].parse!ulong;
    if (pts[0] == "+") {
      m.op = (b => n + b);
    } else {
      m.op = (b => n * b);
    }
  }
  return m;
}

ulong solve(string input, bool p2) {
  auto mks = input.split("\n\n").map!parseMonkey.array;
  ulong m = mks.map!(mk => mk.divisor).fold!lcm;
  ulong[] inspections = new ulong[mks.length];
  ulong iters = p2 ? 10000 : 20;
  foreach (_; 0..iters) {
    foreach (i; 0..mks.length) {
      inspections[i] += mks[i].items.length;
      foreach (it; mks[i].items) {
        ulong worryLevel = mks[i].op(it);
        if (p2) {
          worryLevel %= m;
        } else {
          worryLevel /= 3;
        }
        if (worryLevel % mks[i].divisor == 0) {
          mks[mks[i].trueIdx].items ~= worryLevel;
        } else {
          mks[mks[i].falseIdx].items ~= worryLevel;
        }
      }
      mks[i].items.length = 0;
    }
  }
  inspections.sort!"a > b";
  return inspections[0] * inspections[1];
}

void main() {
  writeln("Day 11: D");
  string input = stdin.byLine().join("\n").dup;
  printf("Part 1: %20lu\n", solve(input, false));
  printf("Part 2: %20lu\n", solve(input, true));
}
