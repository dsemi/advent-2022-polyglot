#!/bin/bash

DAYS=(1)

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
    ./sol.l
    ;;
  3)
    make && ./sol
    ;;
esac
cd ..
