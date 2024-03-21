for %%f in (*.mp4) do (
  ffmpeg -i "%%f" -c copy "%%~nf.mkv"
  rem delete the original mp4 file
  @REM del "%%f"
)
