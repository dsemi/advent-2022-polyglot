#include <stdio.h>
#include <stdlib.h>

int main() {
  FILE *fp = fopen("input.txt", "r");

  char *line = NULL;
  size_t bufsize = 0;
  ssize_t len = 0;
  int elves[3] = {0};
  int elf = 0;
  while ((len = getline(&line, &bufsize, fp)) != -1) {
    if (len > 1) {
      elf += atoi(line);
      continue;
    }
    for (int i = 0; i < 3; i++) {
      if (elf > elves[i]) {
        int tmp = elves[i];
        elves[i] = elf;
        elf = tmp;
      }
    }
    elf = 0;
  }
  free(line);
  fclose(fp);
  printf("Part 1: %15d\n", elves[0]);
  printf("Part 2: %15d\n", elves[0] + elves[1] + elves[2]);
}
