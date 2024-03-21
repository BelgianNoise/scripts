const { execSync } = require('child_process');
const fs = require('fs');

const files = fs.readdirSync('.').filter(file => file.endsWith('.mkv'));

files.forEach(filename => {
  const subtitle = filename.replace('.mkv', '.srt');
  const subbed = filename.replace('.mkv', '_subbed.mkv');

  if (filename.toLowerCase().startsWith('old_')) {
    // skip files that have already been processed
    // Was needed in earlier revisions of the bat script
    console.log(`Skipping old file: ${filename}`);
  } else {
    try {
      // extract the subtitle stream into an SRT file
      execSync(`ffmpeg -n -i "${filename}" "${subtitle}"`);

      // replace all occurences of " size="[0-9]+"" from the SRT file
      let srtContent = fs.readFileSync(subtitle, 'utf8');
      srtContent = srtContent.replace(/\ssize="[0-9]+"/g, '');
      fs.writeFileSync(subtitle, srtContent);

      // merge the subtitle stream back into the video file
      execSync(`ffmpeg -hide_banner -loglevel error -i "${filename}" -i "${subtitle}" -map 0:v -map 0:a -map 1:s -c copy "${subbed}"`);
      
      // replace the original file with the new one
      fs.renameSync(filename, `old_${filename}`);
      fs.renameSync(subbed, filename);
      fs.unlinkSync(subtitle);
      console.log(`Subtitles of ${filename} converted to SRT.`);
    } catch (error) {
      console.error(`Error processing ${filename}: ${error}`);
    }
  }
});
