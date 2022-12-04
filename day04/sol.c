#include <stdio.h>

int main() {
  printf("Day 4: C\n");
  int p1 = 0, p2 = 0;
  int a0 = 0, a1 = 0, b0 = 0, b1 = 0;
  while (scanf("%d-%d,%d-%d", &a0, &a1, &b0, &b1) > 0) {
    if (a0 <= b0 && a1 >= b1 || b0 <= a0 && b1 >= a1) p1++;
    if (a0 <= b1 && b0 <= a1) p2++;
  }
  printf("Part 1: %20d\n", p1);
  printf("Part 2: %20d\n", p2);
}
