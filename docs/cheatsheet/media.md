<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [highly recommanded](#highly-recommanded)
- [video](#video)
  - [get audio from video](#get-audio-from-video)
  - [download video](#download-video)
  - [convert flv to mp4](#convert-flv-to-mp4)
  - [convert png to mp4](#convert-png-to-mp4)
  - [scale the media](#scale-the-media)
  - [combine video and audio](#combine-video-and-audio)
  - [compression mov](#compression-mov)
  - [convert mov to mp4](#convert-mov-to-mp4)
  - [slice video to images](#slice-video-to-images)
  - [convert video to gif](#convert-video-to-gif)
  - [convert pngs into gif](#convert-pngs-into-gif)
  - [record a screencast and convert to mpeg](#record-a-screencast-and-convert-to-mpeg)
  - [tips](#tips)
- [image](#image)
  - [convert webp to png](#convert-webp-to-png)
  - [identity an image](#identity-an-image)
  - [convert svg to png](#convert-svg-to-png)
  - [convert HEIC/HEIF to PNG](#convert-heicheif-to-png)
  - [sed command to batch change fill and stroke of an SVG](#sed-command-to-batch-change-fill-and-stroke-of-an-svg)
- [animation flow chart](#animation-flow-chart)
  - [create animation flow](#create-animation-flow)
  - [convert svg to gif](#convert-svg-to-gif)
- [others](#others)
  - [create manpage pdf](#create-manpage-pdf)
  - [save command output to image](#save-command-output-to-image)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## highly recommanded
[cmd.to](https://cmd.to/fm)

## video
### get audio from video

> [!NOTE|label:references:]
> - `ffmpeg` params:
>   - `-acodec copy -vn`
>   - `-ab 12800 -ar 44100`

```bash
$ ffmpeg -i source.mpg -f s16le -acodec pcm_s16le audio.raw

# https://www.commandlinefu.com/commands/view/52/rip-audio-from-a-video-file.
$ mplayer -ao pcm -vo null -vc dummy -dumpaudio -dumpfile <output.file> <input.file>

# or
$ ffmpeg -i file.video file.audio
```

### download video
- [download video and extract with sepcific time](https://www.commandlinefu.com/commands/view/32814/download-video-extract-only-a-specific-time-of-it)
  ```bash
  $ yt-dlp --external-downloader ffmpeg --external-downloader-args "-ss 00:05:00 -t 00:01:00" "https://www.youtube.com/watch?v=Y6DGABIcB3w"
  ```

- [convert youtube video to mp3](https://www.commandlinefu.com/commands/view/9701/convert-youtube-videos-to-mp3)
  ```bash
  $ youtube-dl -t --extract-audio --audio-format mp3 YOUTUBE_URL_HERE
  ```

### convert flv to mp4
```bash
$ ffmpeg -i name.flv -qscale 0 name.mp4
```

### [convert png to mp4](https://www.everythingcli.org/convert-pdf-to-mp4/)

{% hint style='tip' %}
> options:
> - `pic-%02d.png`: Read all images from the current folder with the prefix pic-, a following number of 2 digits (%02d) and an ending of .png
> - `-r 1/5` : Displays each image for 5 seconds
> - `r 30` : Output framerate of 30 fps.
> - `-c:v libx264` : Output video codec: h264
> - `pix_fmt yuv420p` : YUV pixel format
{% endhint %}

```bash
$ ffmpeg -r 1/5 -i pic-%02d.png -c:v libx264 -r 30 -pix_fmt yuv420p out.mp4
```

### [scale the media](https://www.everythingcli.org/convert-pdf-to-mp4/)
```bash
$ ffmpeg -i out.mp4 -vf scale=-1:720 out_720p.mp4
```

#### convert to 5 mins (300 sec)
```bash
$ ffmpeg -i name.mp4 -ss 0 -t 300 name-5m.mp4
```

#### sequence convert (every 5 mins ~> 300 secs)
- first 5 mins (0 ~> 300)
  ```bash
  $ ffmpeg -i name.mp4 -ss 0 -t 300 name-5m-1.mp4
  ```
- second 5 mins (300*1 ~> 300)
  ```bash
  $ ffmpeg -i name.mp4 -ss 300 -t 300 name-5m-2.mp4
  ```
- third 5 mins (300*2 ~> 300)
  ```bash
  $ ffmpeg -i name.mp4 -ss 600 -t 300 name-5m-3.mp4
  ```

#### [convert pdf to png](https://www.everythingcli.org/convert-pdf-to-mp4/)
{% hint style='tip' %}
- `-density 400` : Set the horizontal resolution of the image
{% endhint %}

```bash
$ convert -density 400 input.pdf pic.png
```

### combine video and audio
```bash
$ ffmpeg -i <origin-video> -i <origin-audio> -c copy -map 0:0 -map 1:0 -shortest <new-video>
```

![combine](../screenshot/osx/ffmpeg-combine.jpg)

### compression mov

> [!NOTE|label:references:]
> - [Reduce MOV file size](https://superuser.com/a/525284/112396)

```bash
$ ffmpeg -i coc-groovy-lsp.org.mov -c:v libx264 -c:a copy -crf 20 coc-groovy-lsp.mov
$ ls -altrh | grep coc-groovy-lsp
-rw-r--r--   1 marslo staff  37M Jan 15 18:39 coc-groovy-lsp.org.mov
-rw-r--r--   1 marslo staff  10M Jan 15 19:02 coc-groovy-lsp.mov

$ ffmpeg -i coc-groovy-lsp-minirc.org.mov -c:v libx264 -c:a copy -crf 20 coc-groovy-lsp-minirc.mov
$ ls -altrh | grep coc-groovy-lsp-minirc
-rw-r--r--   1 marslo staff  14M Jan 15 19:16 coc-groovy-lsp-minirc.org.mov
-rw-r--r--   1 marslo staff 4.1M Jan 15 19:20 coc-groovy-lsp-minirc.mov
```

### convert mov to mp4

> [!NOTE|label:reference:]
> - [convert .mov video to .mp4 with ffmpeg](https://superuser.com/a/1155189/112396)

```bash
# handbrakecli
$ handbrakecli -i {in-video}.mov -e x264 -E facc -o {out-video}.mp4

# ffmpeg
$ ffmpeg -i {in-video}.mov -vcodec h264 -acodec aac {out-video}.mp4
# or
$ ffmpeg -i input.mov -c copy -movflags +faststart output.mp4
```

### slice video to images
```bash
$ ffmpeg -i video.mp4 -vf "fps=24" css_%04d.png
```

### convert video to gif

> [!NOTE|label:references:]
> - [How do I convert a video to GIF using ffmpeg, with reasonable quality?](https://superuser.com/a/556031/112396)
>   - options:
>     - `-ss 30`: skip first 30 seconds
>     - `-t 3`: create a 3 second output
>     - `fps=10`: [fps](https://ffmpeg.org/ffmpeg-filters.html#fps) filter sets the frame rate
>     - `scale=320:-1`: resize the output to 320 pixels wide and automatically determine the height, the [lanczos scaling algorithm](https://ffmpeg.org/ffmpeg-scaler.html) is used in this example.
>       - `scale=0:-1`: do not resize
>     - `split[s0][s1]`: [split](https://ffmpeg.org/ffmpeg-filters.html#split) filter will allow everything to be done in one command and avoids having to create a temporary PNG file of the palette
>     - `[s0]palettegen[p];[s1][p]paletteuse`: [palettegen](https://ffmpeg.org/ffmpeg-filters.html#palettegen) and [paletteuse](https://ffmpeg.org/ffmpeg-filters.html#paletteuse) filters will generate and use a custom palette generated from your input
>   - ffmpeg options:
>     - `-vf "fps=10,scale=320:-1:flags=lanczos"` a [filtergraph](https://ffmpeg.org/ffmpeg-filters.html#Filtergraph-description) using the [fps](https://ffmpeg.org/ffmpeg-filters.html#fps) and [scale](https://ffmpeg.org/ffmpeg-filters.html#scale) filters.
>     - `-c:v pam`: chooses the pam image encoder
>     - `-f image2pipe`: chooses the image2pipe muxer
>   - convert options:
>     - `-delay`: set frame rate with a combination of the [fps](https://ffmpeg.org/ffmpeg-filters.html#fps) filter in ffmpeg
>     - `-loop 0`: makes infinite loop
>     - `-layers optimize`: enable the general purpose GIF optimizer
>   - to set rgb
>     `-vf scale=320:-1,format=rgb8,format=rgb24`
> - [ImageMagick Examples -- Animation Optimization](https://www.imagemagick.org/Usage/anim_opt/)
> - [thevangelist/FFMPEG-gif-script-for-bash](https://github.com/thevangelist/FFMPEG-gif-script-for-bash)

```bash
# with specific size
$ ffmpeg -ss 30 -t 3 -i input.mp4 \
         -vf "fps=10,scale=320:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
         -loop 0 output.gif

# or
$ ffmpeg -i input.mp4 -vf "fps=10,scale=320:-1:flags=lanczos" -c:v pam \
         -f image2pipe - | \
         convert -delay 10 - -loop 0 -layers optimize output.gif

# with original size
$ ffmpeg -ss 30 -t 3 -i coc-groovy-minirc.org.mov \
         -vf "fps=35" \
         -loop 0 output.gif

# using ImageMagick
$ convert in.mp4 out.gif
```

- [function](https://superuser.com/a/1154859/112396)
  ```bash
  #### video2gif.sh
  # Convert video to gif file.
  # Usage: video2gif video_file (scale) (fps)
  video2gif() {
    ffmpeg -y -i "${1}" -vf fps=${3:-10},scale=${2:-320}:-1:flags=lanczos,palettegen "${1}.png"
    ffmpeg -i "${1}" -i "${1}.png" -filter_complex "fps=${3:-10},scale=${2:-320}:-1:flags=lanczos[x];[x][1:v]paletteuse" "${1}".gif
    rm "${1}.png"
  }

  REM video2gif.bat
  @echo off
  set arg1=%1
  set arg2=%arg1:~0,-4%
  ffmpeg -y -i %arg1% -vf fps=10,scale=-1:-1:flags=lanczos,palettegen %TEMP%\palette.png
  ffmpeg -i %arg1% -i %TEMP%\palette.png -filter_complex "fps=10,scale=-1:-1:flags=lanczos[x];[x][1:v]paletteuse" %arg2%.gif
  del /f %TEMP%\palette.png

  # usage
  $ video2gif input.flv
  $ video2gif input.flv 320 10
  ```

- [another simple solution](https://superuser.com/a/1268429/112396)
  ```bash
  src="input.flv"
  dest="output.gif"
  palette="/tmp/palette.png"

  ffmpeg -i $src -vf palettegen -y $palette
  ffmpeg -i $src -i $palette -lavfi paletteuse -y $dest
  ```

- [create an animated gif from a youtube video](https://www.commandlinefu.com/commands/view/6110/create-an-animated-gif-from-a-youtube-video)
  ```bash
  $ url=http://www.youtube.com/watch?v=V5bYDhZBFLA;
  youtube-dl -b $url; mplayer $(ls ${url##*=}*| tail -n1) -ss 00:57 -endpos 10 -vo gif89a:fps=5:output=output.gif -vf scale=400:300 -nosound
  ```

### convert pngs into gif
```bash
$ convert -delay 5 -loop 0 -dither None -colors 80 "frames/ffout*.png" -fuzz "40%" -layers OptimizeFrame  "output.gif"

# simple version
$ convert -delay 10 *.png sample.gif
```

### [record a screencast and convert to mpeg](https://www.commandlinefu.com/commands/view/2365/record-a-screencast-and-convert-it-to-an-mpeg)
```bash
$ ffmpeg -f x11grab -r 25 -s 800x600 -i :0.0 /tmp/outputFile.mpg

# or: https://www.commandlinefu.com/commands/view/7109/capture-video-of-a-linux-desktop
$ ffmpeg -y -f alsa -ac 2 -i pulse -f x11grab -r 30 -s `xdpyinfo | grep 'dimensions:'|awk '{print $2}'` -i :0.0 -acodec pcm_s16le output.wav -an -vcodec libx264 -vpre lossless_ultrafast -threads 0 output.mp4

# or: https://www.commandlinefu.com/commands/view/5189/capture-video-of-a-linux-desktop
$ ffmpeg -f x11grab -s `xdpyinfo | grep 'dimensions:'|awk '{print $2}'` -r 25 -i :0.0 -sameq /tmp/out.mpg > /root/howto/capture_screen_video_ffmpeg

# or: https://www.commandlinefu.com/commands/view/24389/capture-video-of-a-linux-desktop
$ ffmpeg -video_size 1024x768 -framerate 25 -f x11grab -i :0.0+100,200 output.mp4

# or: https://www.commandlinefu.com/commands/view/12572/capture-video-of-a-linux-desktop
ffmpeg -f x11grab -s wxga -r 25 -i :0.0+1366,0 -qscale 0 /tmp/out.mpg
```


### tips

- [get the total length of time](https://www.commandlinefu.com/commands/view/3612/get-the-total-length-of-time-in-hoursminutesseconds-hhmmss-of-all-video-or-audio-in-the-current-dir-and-below)
  ```bash
  $ find -type f -name "*.avi" -print0 | xargs -0 mplayer -vo dummy -ao dummy -identify 2>/dev/null | perl -nle '/ID_LENGTH=([0-9\.]+)/ && ($t +=$1) && printf "%02d:%02d:%02d\n",$t/3600,$t/60%60,$t%60' | tail -n 1
  ```

- [edit video by cutting the part you like without transcoding](https://www.commandlinefu.com/commands/view/4546/edit-video-by-cutting-the-part-you-like-without-transcoding.)
  ```bash
  $ mencoder -ss <start point> -endpos <time from start point> -oac copy -ovc copy <invid> -o <outvid>

  # i.e.: take frames starting at 15.2 seconds for a total of 45.9 seconds
  $ mencoder -ss 15.2 -endpos 30.7 -oac copy -ovc copy origin.avi -o new.avi

  # i.e.: total 3m3s length
  $ mencoder -ss 1 minute -endpos 2 minutes 3 seconds -oac copy -ovc copy origin.avi -o new.avi
  ```

- [stream and copy a video from lan](https://www.commandlinefu.com/commands/view/12954/stream-and-copy-a-video-from-lan)
  ```bash
  $ nc HOST PORT | tee movie.mp4 | mplayer -

  # via ssh: https://www.commandlinefu.com/commands/view/12955/securely-stream-and-save-a-file-from-a-remote-server
  $ ssh USER@HOST cat REMOTE_FILE.mp4 | tee LOCAL_FILE.mp4 | mplayer -
  ```

## image
### [convert webp to png](http://tutorialshares.com/converting-webp-images-with-the-command-line/)
```bash
$ ffmpeg -i file.webp out.png
```
- for multiple images
  ```bash
  $ for x in ls *.webp; do
      ffmpeg -i "$x" "${x%.webp}.jpg"
    done
  ```


### identity an image
```bash
$ identify arms009.jpg | grep -o "[[:digit:]]*x[[:digit:]]*" | tail -1
1024x768
```

### convert svg to png

{% hint style='tip' %}
> references:
> - [Command-line application for converting SVG to PNG on Mac OS X](https://superuser.com/a/142082/112396)
> - ["Bake" an SVG image into a PNG at a given resolution? [closed]](https://superuser.com/a/516112/112396)
> - [Converting large SVG to PNG file](https://superuser.com/a/569235/112396)
> - [tomkwok/svgasm](https://github.com/tomkwok/svgasm)
{% endhint %}

- qlmanage
  ```bash
  $ qlmanage -t -s 1000 -o . k-1.svg
  ```

- convert
  ```bash
  $ convert -resize 128x128 input.svg output.png

  # or
  $ convert -density 500 -resize 128x128 input.svg output.png
  $ convert -density 1200 -resize 10000x10000 your.svg your.png
  $ convert -background none -size 1024x1024 infile.svg outfile.png
  ```

### convert HEIC/HEIF to PNG

![magick](../screenshot/osx/heic-1.gif)

```bash
$ brew install imagemagick --with-libheif

# for single convert
$ magick convert [-monitor] <name>.HEIC <new-name>.png

# for batch convert
$ magick mogrify [-monitor] -format png *.HEIC.
```

### [sed command to batch change fill and stroke of an SVG](https://stackoverflow.com/a/60123629/2940319)
```bash
#!/usr/bin/env sh

COLOR=yellow
sed -i -E 's/fill\="[^"]+"//g; s/stroke\="[^"]+"//g' *.svg
sed -i "s/<path/<path fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
```
- or
  ```bash
  #!/usr/bin/env sh
  COLOR=yellow
  sed -i -E 's/fill\="[^"]+"//g; s/stroke\="[^"]+"//g' *.svg
  sed -i "s/<path/<path fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i "s/<rect/<rect fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i "s/<polygon/<polygon fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i "s/<circle/<circle fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i "s/<ellipse/<ellipse fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i "s/<polyline/<polyline fill=\"$COLOR\" stroke=\"$COLOR\"/g" *.svg
  sed -i -E "s/stroke\:[^\;]+/stroke\:$COLOR/g" *.svg
  sed -i -E "s/fill\:\#[0-9]+/fill\:$COLOR/g" *.svg
  ```

## animation flow chart

### create animation flow

> [!NOTE|label:references:]
> - [#3739 - Export as a GIF](https://github.com/jgraph/drawio/issues/3739)
> - [如何用drawio让自己的流程图线条产生动起来的效果](https://blog.csdn.net/Iammiky/article/details/113636410)
> - [processflow.sharehoo.cn](https://processflow.sharehoo.cn/)

- [draw.io](https://www.draw.io/)

  ![flow animation](../screenshot/osx/svg/draw.io.flow.animation.gif)

- export to svg

  ![export to svg](../screenshot/osx/svg/draw.io.export.to.svg.png)

### convert svg to gif

- online tools

  > [!NOTE|label:references:]
  > - [Convert animated SVG to GIF free](https://medium.com/@somendraitgroup/convert-animated-svg-to-gif-free-3bf25f037f66)

  - convert svg to gif with watermark in [html5animationtogif.com](https://html5animationtogif.com/svg-to-gif)
    - increase the SVG image height to make the watermark shows below of original image

    ![without increase height](../screenshot/osx/svg/html5animationtogif.com.without.increase.height.gif)

    ![increase height](../screenshot/osx/svg/html5animationtogif.com.increase.height.gif)


  - crop the watermark in [animated GIF editor and Gif maker](https://ezgif.com/crop)

    ![crop gif](../screenshot/osx/svg/crop-gif.gif)

- local tools

  - chrome extension: [Chrome Capture - screenshot & GIF](https://chromewebstore.google.com/detail/ggaabchcecdbomdcnbahdfddfikjmphe)
  - desktop application: [GIF Brewery](https://www.tumblr.com/gifbrewery): `.045s`, `0.50s` or `0.52s`
    - [GIF Brewery for Mac v3.9.5 英文破解 GIF制作工具](https://www.xxmac.com/gif-brewery.html)
      - [提取码: `iasr`](https://pan.baidu.com/s/1aPJCP4cRn0JbYLgU83rTRg)
    - [Gifox](https://gifox.app/)

## others
### [create manpage pdf](https://www.commandlinefu.com/commands/view/7355/create-a-pdf-version-of-a-manpage)
```bash
$ man -t manpage | ps2pdf - filename.pdf

# https://www.commandlinefu.com/commands/view/9751/save-man-page-as-pdf
$ man -t awk | ps2pdf - awk.pdf
```

### [save command output to image](https://www.commandlinefu.com/commands/view/9104/save-command-output-to-image)
```bash
$ ifconfig | convert label:@- ip.png
# or: https://www.commandlinefu.com/commands/view/18168/save-command-output-to-image
$ convert label:"$(ifconfig)" output.png

# and more
$ ifconfig | convert -background none label:@- miff:- | composite -tile pattern:checkerboard - -compose Dst_Over ip.png

# and more with fonts: `convert -list font | grep Font:`
$ /usr/bin/lynx -dump -nolist http://www.commandlinefu.com/ | /usr/bin/convert -font "FreeMono-Medium" label:@- output.png
```
