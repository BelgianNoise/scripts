setlocal enabledelayedexpansion

for %%f in (*.mkv) do CALL :strip "%%~nf" ".mkv"
for %%f in (*.mp4) do CALL :strip "%%~nf" ".mp4"

:strip
  set "filename=%~1%~2"
  if "!filename!"=="" (
    echo No file found
  ) else (
    set "stripped=%~1_stripped%~2%"
    ffmpeg -i "!filename!" -c copy -sn "!stripped!"
    ren "!filename!" "old_!filename!"
    ren "!stripped!" "!filename!"
    echo Removed subs from !filename!
  )
EXIT /B 0
