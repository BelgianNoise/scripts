for %%f in (*.mkv) do (
  ffmpeg -n -i "%%f" "%%~nf.srt"
)
