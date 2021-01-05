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

getting uniqe words from text:
cat myfile | grep -o -E '\w+' | tr '[A-Z]' '[a-z]' | sort | uniq -c | sort -nr

("sort -n" for non reverse)

videogreping for multiple exact words:
videogrep --input input.mp4 --output output.mp4 --search '\bword1\b|\bword2\b|\bword3\b' 

("\b" regex for exact string matching)

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
while read -ra line; do for word in "${line[@]}"; do videogrep --input input.mp4 --output $word.mp4 --max-clips 1 --search "$word"; done; done < text_test_file.txt

(command works but \b...\b regex isnt working anymore)


Workflow:

1. Start script >> welcoming message "paste youtube link here"
2. Paste link >> video download with youtube-dl
3. ffmpeg >> extract and convert audio for vosk-api
4. generate .srt with timestamp for every word with vosk-api (use test_srt.py and change "words per line to 1")
5. Shows all usable words
6. Write text with usable words
7. Videogrep takes every word, cuts video part and places it in folder
8. ffmpeq combines all vdieo snippets from folder to final video.
