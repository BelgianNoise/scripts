setlocal enabledelayedexpansion

for %%f in (*.mkv) do (
  set "subtitle=%%~nf.srt"
  set "filename=%%f"
  set "subbed=%%~nf_subbed.mkv"
  if /i "!filename!:~0,4%"=="old_" (
    echo Skipping old file: !filename!
  ) else (
    ffmpeg -n -i "!filename!" "!subtitle!"
    ffmpeg -hide_banner -loglevel error -i "!filename!" -i "!subtitle!" -map 0:v -map 0:a -map 1:s -c copy "!subbed!"
    ren "!filename!" "old_!filename!"
    ren "!subbed!" "!filename!"
    del "!subtitle!"
    echo Subtitles of !filename! converted to SRT.
  )
)
