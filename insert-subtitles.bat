@echo off
setlocal enabledelayedexpansion

rem Loop through all mkv files in the current directory
for %%f in (*.mkv) do (
  rem Extract the filename without extension
  set "filename=%%f"
  echo Processing !filename!

  rem Extract the season and episode information using string manipulation
  set "season_episode=-"
  set "filename_to_cut=!filename!"
  CALL :getSeasonEpisode "!filename_to_cut!"

  rem continue for loop if no season and episode information is found
  if "!season_episode!"=="-" (
    echo No season and episode information found for !filename!
  ) else (
    rem Set a flag to indicate if a matching subtitle is found
    set "subtitle_found="

    rem Look for corresponding srt file
    for %%s in (*.srt) do (
      rem Extract the subtitle filename without extension
      set "subtitle=%%s"

      echo !subtitle! | findstr /C:".done.srt" >nul
      if errorlevel 1 (
        rem check if season_episode is a substring of the subtitle filename
        rem use findstr command
        echo !subtitle! | findstr /C:"!season_episode!" >nul
        if not errorlevel 1 (
          echo Found matching subtitle for !filename!: !subtitle!
          rem Merge srt subtitle with mkv using ffmpeg
          echo mergin !filename! with !subtitle!
          ffmpeg -hide_banner -loglevel error -i "!filename!" -i "!subtitle!" -map 0:v -map 0:a -map 1:s -c copy "!filename!_subtitled.mkv"
          if %ERRORLEVEL% NEQ 0 (
            echo There was an error with ffmpeg.
          ) else (
            echo Subtitles added to !filename!.mkv
            rem Exit the subtitle loop once a matching subtitle is found
            set "subtitle_found=!subtitle!"
          )
        )
      )
    )

    rem If no matching subtitle found, print a message
    if "!subtitle_found!"=="" (
      echo No subtitles found for !filename!
    ) else (
      rem rename original mkv file to season_episode.old.mkv
      rem and rename the subtitled mkv file to the original filename
      ren "!filename!" "!season_episode!.old.mkv"
      ren "!subtitle_found!" "!season_episode!.done.srt"
      ren "!filename!_subtitled.mkv" "!filename!"
    )
  )
)
EXIT /B %ERRORLEVEL%

:getSeasonEpisode
set "f=%~1"
:loopy
for /F "tokens=1* delims=." %%a in ("!f!") do (
  set "segment=%%a"
  if "!segment:~0,1!"=="S" (
    if "!segment:~3,1!"=="E" (
      set "season_episode=!segment!"
    ) else if "!segment:~4,1!"=="E" (
      set "season_episode=!segment!"
    )
  )
  rem set filename_to_cut to the remaining part of the filename
  set "f=%%b"
)
if not "!f!"=="" goto loopy
EXIT /B 0

endlocal
