#!/bin/bash/

echo "usage: sh word_slicer.sh video customlist.txt"

#echo "$1 und $2"
while read p; do
  echo "$p"
  videogrep --input $1 --output "$p".mkv --max-clips 1 --search "\b$p\b"
done <$2

