#!/bin/bash

infile=$1                                       # input filename
count=1                                         # filename serial number
while IFS= read -r line; do                     # read the input file assigning line
    vid=${line:11:11}                           # video id of youtube
    start=${line:32:12}                         # start time
    stop=${line:49:12}                          # stop time
    file=$(printf "clip%03d.mp4" "$count")      # output filename
    (( count++ ))                               # increment the number
     echo  < /dev/null sh download_youtube.sh "https://www.youtube.com/watch?v=$vid" "$start" "$stop" "$file"
done < "$infile"
