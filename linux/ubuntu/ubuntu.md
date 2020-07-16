<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Get Package name by command](#get-package-name-by-command)
- [Search package name for apt-get](#search-package-name-for-apt-get)
- [Install Ubuntu Theme](#install-ubuntu-theme)
- [Open Font Viewer and install font](#open-font-viewer-and-install-font)
- [Show launcher icon](#show-launcher-icon)
- [Show the softer renderer](#show-the-softer-renderer)
- [Specified Context Menu](#specified-context-menu)
- [Disable Ubuntu Desktop notification](#disable-ubuntu-desktop-notification)
- [Recode activity as a GIF file (Inspired from here and here)](#recode-activity-as-a-gif-file-inspired-from-here-and-here)
- [Goldendict Installation](#goldendict-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Get Package name by command
```bash
$ apt-cache search mkpasswd
whois - intelligent WHOIS client
libstring-mkpasswd-perl - Perl module implementing a random password generator
```

### Search package name for apt-get
```bash
$ sudo apt-cache search chrome browser
chromium-browser - Chromium browser
chromium-chromedriver - WebDriver driver for the Chromium Browser
cloudprint - Server for Google Cloud Print
collabtive - Web-based project management software
epiphany-browser - Intuitive GNOME web browser
jsxgraph - Interactive Geometry with JavaScript
kpartsplugin - Netscape-compatible plugin to embed KDE file-viewers into browser
libjs-excanvas - HTML5 Canvas for Internet Explorer
libjs-jquery-jplayer - HTML5 Audio & Video for jQuery with a Flash fallback
libjs-jquery-jush - jQuery Syntax Highlighter
google-chrome-beta - The web browser from Google
google-chrome-stable - The web browser from Google
google-chrome-unstable - The web browser from Google
```

### Install Ubuntu Theme
```bash
$ sudo add-apt-repository ppa:noobslab/themes
$ sudo apt-get update
$ sudo apt-get install nokto-theme
```

### Open Font Viewer and install font
```bash
$ sudo gnome-font-viewer ~/Tools/Monaco/Monaco_Linux.TTF
```

### Show launcher icon
```bash
$ gsettings get com.canonical.Unity.Launcher favorites
['application://nautilus.desktop', 'application://gnome-terminal.desktop', 'application://firefox.desktop', 'unity://running-apps', 'application://gvim.desktop', 'unity://desktop-icon', 'unity://expo-icon', 'unity://devices']
```

### Show the softer renderer
```bash
$ /usr/lib/nux/unity_support_test -p
OpenGL vendor string:   VMware, Inc.
OpenGL renderer string: Gallium 0.4 on SVGA3D; build: RELEASE;
OpenGL version string:  2.1 Mesa 10.1.0

Not software rendered:    yes
Not blacklisted:          yes
GLX fbconfig:             yes
GLX texture from pixmap:  yes
GL npot or rect textures: yes
GL vertex program:        yes
GL fragment program:      yes
GL vertex buffer object:  yes
GL framebuffer object:    yes
GL version is 1.4+:       yes

Unity 3D supported:       yes
```

### Specified Context Menu
```bash
$ sudo apt-get install nautilus-actions
$ nautilus -q
$ utilus-actions-config-tool
```

### Disable Ubuntu Desktop notification
```bash
$ sudo chmod -x /usr/lib/notify-osd/notify-osd
```

### Recode activity as a GIF file (Inspired from [here](http://askubuntu.com/a/13462/92979) and [here](http://askubuntu.com/a/107735/92979))
```bash
$ sudo add-apt-repository ppa:fossfreedom/byzanz
$ sudo apt-get update && sudo apt-get install byzanz
```

### Goldendict Installation
```bash
$ git clone git@github.com:goldendict/goldendict.git
$ sudo apt-get install liblzma-dev qt4-qmake hunspell-dev hunspell build-essential libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev libqt4-dev libqtwebkit-dev libxtst-dev liblzo2-dev libbz2-dev libao-dev libavutil-dev libavformat-dev libtiff5-dev
$ cd goldendict/
$ qmake-qt4
$ qmake "CONFIG+=no_epwing_support"
$ make && sudo make install
```
