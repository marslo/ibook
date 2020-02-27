<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Highly Recommanded](#highly-recommanded)
- [Video](#video)
  - [Get Audio from video](#get-audio-from-video)
  - [Convert flv to mp4](#convert-flv-to-mp4)
  - [Combine video and audio](#combine-video-and-audio)
- [Image](#image)
  - [Identity an image](#identity-an-image)
  - [Convert HEIC/HEIF to PNG](#convert-heicheif-to-png)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Highly Recommanded
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

### Combine video and audio
```bash
$ ffmpeg -i <origin-video> -i <origin-audio> -c copy -map 0:0 -map 1:0 -shortest <new-video>
```
![combine](../screenshot/ffmpeg-combine.jpg)

## Image
### Identity an image
```bash
$ identify arms009.jpg | grep -o "[[:digit:]]*x[[:digit:]]*" | tail -1
1024x768
```

### Convert HEIC/HEIF to PNG

![magick](../screenshot/heic-1.gif)

```bash
$ brew install imagemagick --with-libheif

# for single convert
$ magick convert [-monitor] <name>.HEIC <new-name>.png

# for batch convert
$ magick mogrify [-monitor] -format png *.HEIC.
```
