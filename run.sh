#!/bin/bash

DAYS=(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25)

if [[ "$#" -lt 1 ]]; then
  echo "Incorrect number of arguments" >&2
  exit 1
fi
args=( "$@" )
last=$(( ${#args[*]}-1 ))
for i in $(seq 0 $last); do
  day=${args[$i]}
  if [[ ! "${DAYS[*]}" =~ "$day" ]]; then
    echo "Invalid day" >&2
    continue
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
    4)
      make && ./sol < input.txt
      ;;
  esac
  cd ..
  if [[ "$i" -ne "$last" ]]; then
    echo
  fi
done
