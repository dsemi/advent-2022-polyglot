#!/bin/bash

DAYS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)

if [[ "$#" -ne 1 ]]; then
  echo "Incorrect number of arguments" >>/dev/stderr
  exit 1
fi

day="$1"
if [[ ! "${DAYS[*]}" =~ "$day" ]]; then
  echo "Invalid day" >>/dev/stderr
  exit 1
fi

dir=day$(printf %02d "$day")
cd $dir
case "$day" in
  1)
    pil sol.l < input.txt
    ;;
  2)
    luajit sol.lua < input.txt
    ;;
  3)
    raku sol.raku < input.txt
    ;;
esac
cd ..
