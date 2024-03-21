for %%f in (*.m4v) do (
  ffmpeg -i "%%f" -c copy "%%~nf.mkv"
  rem delete the original m4v file
  @REM del "%%f"
)
