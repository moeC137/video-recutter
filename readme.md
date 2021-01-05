Notes:

Opetions for .srt generation with timestamps for every word:

https://github.com/googleapis/python-speech/blob/master/samples/snippets/transcribe_word_time_offsets.py
or
https://github.com/alphacep/vosk-api/blob/master/python/example/test_srt.py

autosub uses google api but dosent give timestamp for every word...maybe fixable
https://github.com/agermanidis/autosub

Recuting the video with:
https://github.com/antiboredom/videogrep

Workflow:

1. Start script >> welcoming message "paste youtube link here"
2. Paste link >> video download with youtube-dl
3. ffmpeg >> extract and convert audio for vosk-api
4. generate .srt with timestamp for every word with vosk-api (use test_srt.py and change "words per line to 1")
5. Shows all usable words
6. Write text with usable words
7. Videogrep takes every word, cuts video part and places it in folder
8. ffmpeq combines all vdieo snippets from folder to final video.
