@ECHO OFF

for %%f in (*.mkv) do CALL :list_resolution "%%f"
for %%f in (*.avi) do CALL :list_resolution "%%f"
for %%f in (*.mp4) do CALL :list_resolution "%%f"
for %%f in (*.m4v) do CALL :list_resolution "%%f"
EXIT /B %ERRORLEVEL% 

:list_resolution
  ECHO|SET /p="%~1: "
  ffprobe -loglevel quiet -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "%~1"
EXIT /B 0
