<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Highly Recommanded](#highly-recommanded)
- [Video](#video)
  - [Get Audio from video](#get-audio-from-video)
  - [Convert flv to mp4](#convert-flv-to-mp4)
  - [convert png to mp4](#convert-png-to-mp4)
  - [scale the media(https://www.everythingcli.org/convert-pdf-to-mp4/)](#scale-the-mediahttpswwweverythingcliorgconvert-pdf-to-mp4)
  - [Combine video and audio](#combine-video-and-audio)
- [Image](#image)
  - [convert webp to png](#convert-webp-to-png)
  - [identity an image](#identity-an-image)
  - [convert svg to png](#convert-svg-to-png)
  - [convert HEIC/HEIF to PNG](#convert-heicheif-to-png)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## highly recommanded
[cmd.to](https://cmd.to/fm)

## Video
### Get Audio from video
```bash
$ ffmpeg -i source.mpg -f s16le -acodec pcm_s16le audio.raw
```

### Convert flv to mp4
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

### scale the media(https://www.everythingcli.org/convert-pdf-to-mp4/)
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

### Combine video and audio
```bash
$ ffmpeg -i <origin-video> -i <origin-audio> -c copy -map 0:0 -map 1:0 -shortest <new-video>
```
![combine](../screenshot/osx/ffmpeg-combine.jpg)

## Image
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
