import algorithm
import math
import strformat
import strutils

echo "Day 25: Nim"
var num = 0
var line: string
while stdin.readLine(line):
  for i, c in line.reversed:
    num += 5^i * ("=-012".find(c) - 2)
var p1: string
while num > 0:
  p1.add "012=-"[num mod 5]
  num = (num + 2) div 5
p1.reverse
echo fmt"Part 1: {p1:20}"
echo "Part 2: $1".format(align("n/a", 20))
