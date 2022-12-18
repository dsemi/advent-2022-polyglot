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
      make -s && ./sol < input.txt
      ;;
    5)
      ruby sol.rb < input.txt
      ;;
    6)
      make -s && ./sol < input.txt
      ;;
    7)
      make -s && ./sol < input.txt
      ;;
    8)
      make -s && ./sol < input.txt
      ;;
    9)
      python sol.py < input.txt
      ;;
    10)
      make -s && ./sol < input.txt
      ;;
    11)
      make -s && ./sol < input.txt
      ;;
    12)
      dart sol.dart < input.txt
      ;;
    13)
      node sol.js < input.txt
      ;;
    14)
      make -s && ./sol < input.txt
      ;;
    15)
      make -s && scala main < input.txt
      ;;
    16)
      racket sol.rkt < input.txt
      ;;
    17)
      clj -M sol.clj < input.txt
      ;;
    18)
      make -s && kotlin SolKt < input.txt
      ;;
  esac
  cd ..
  if [[ "$i" -ne "$last" ]]; then
    echo
  fi
done
