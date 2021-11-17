Notes:

Opetions for .srt generation with timestamps for every word:

https://github.com/googleapis/python-speech/blob/master/samples/snippets/transcribe_word_time_offsets.py
or
https://github.com/alphacep/vosk-api/blob/master/python/example/test_srt.py

autosub uses google api but dosent give timestamp for every word...maybe fixable
https://github.com/agermanidis/autosub

Recuting the video with:
https://github.com/antiboredom/videogrep

extracting plaintext from .srt:
https://gist.github.com/ndunn219/62263ce1fb59fda08656be7369ce329b#file-srt_to_txt-py

sort unique words for noun, verb, adjective, pronoun, adverb, article, preposition, numeral or conjunction:
https://github.com/moeC137/wiktionary-curl-wordtype-checker


python3 test_srt.py  myvideo.mp4 > myvideo.srt

(its important that the .mp4 and the .srt have THE SAME name or videogrep wont fint the .srt)

python3 srt_to_txt.py myvideo.srt

(this generates the myvideo.txt)

getting uniqe words from text with numbers:

cat myvideo.txt | grep -o -E '\w+' | tr '[A-Z]' '[a-z]' | sort | uniq -c | sort -nr  > unique_words.txt

("sort -n" for non reverse)

getting uniqe words from text WITHOUT numbers:

cat myvideo.txt | grep -o -E '\w+' | tr '[A-Z]' '[a-z]' | sort | uniq   > unique_words.txt

sorting words into categories:

while read -ra line; do for word in "${line[@]}"; do sh checker.sh -l German -w $word; done; done < unique_words.txt



videogreping for multiple exact words:

videogrep --input input.mp4 --output output.mp4 --search '\bword1\b|\bword2\b|\bword3\b' 

(use --padding for adding extra ms to the clips)
("\b" regex for exact string matching)
###########################################################
###########################################################
outdated
##########################################################
getting single words from the custom text file:
tr -cs 'A-Za-z_' '[\n*]' < custom_text_file.txt

alternativ:
while read -ra line; 
do
    for word in "${line[@]}";
    do
        echo "$word";
    done;
done < custom_text_file.txt

(replace "echo "$word";" with command to repeat)

full command:
while read -ra line; do for word in "${line[@]}"; do videogrep --input input.mp4 --output $word.mp4 --max-clips 1 --search "\b${word}\b"; done; done < text_test_file.txt
###########################################################################
###########################################################################

create custom_text.txt with ONLY words from unique_words.txt


full command with numeration of outputs:
COUNTER=0; while read -ra line; do for word in "${line[@]}";
do COUNTER=$[COUNTER + 1] COUNTER_PRINT="$(printf '%03d' ${COUNTER})"
videogrep --input myvideo.mp4 --output  ~/video-recutter/combiner/"${COUNTER_PRINT}${word}".mp4 --max-clips 1 --search "\b${word}\b";
 done;
 done < custom_text.txt

(with 00 front zero padding)

stitching everything in the folder together in ffmpeg:
cd combiner &&
for f in *.mp4 ; do echo file \'$f\' >> list.txt; done && ffmpeg -f concat -safe 0 -i list.txt -c copy stitched-video.mp4 && rm list.txt

(copy this from RAW file else some \\\\\ are missing!)


(it doses in in alphabetcal order....so i need to add a counter to the naming in the videograp loop)

Workflow:

1. Start script >> welcoming message "paste youtube link here"
2. Paste link >> video download with youtube-dl
3. ffmpeg >> extract and convert audio for vosk-api
4. generate .srt with timestamp for every word with vosk-api (use test_srt.py and change "words per line to 1")
5. Shows all usable words
6. Write text with usable words
7. Videogrep takes every word, cuts video part and places it in folder
8. ffmpeq combines all vdieo snippets from folder to final video.



command for extracting all keword timestamps for a word from multiple .srt :
grep -B 1 -H  "keyword" * > keywords.txt

combine this with https://github.com/moeC137/youtube-clip-taker to download the keyword from multiple videos.

remove gaps in keywords.txt :
awk 'NR % 3 != 0'  keywords.txt > keywordsV2.txt
awk 'NR % 2 != 0'  keywordsV2.txt > keywordsV3.txt


pharse timestamps lines from text document to downloader:
(thx to https://stackoverflow.com/questions/69982768/how-to-repeat-a-command-for-every-line-in-a-textfile-with-given-arguments-from-t?noredirect=1#comment123711347_69982768 )
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

