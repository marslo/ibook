<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [time & date](#time--date)
- [Get URL](#get-url)
- [Download and unzip](#download-and-unzip)
- [Get cookie from firefox](#get-cookie-from-firefox)
- [Echo 256 colors](#echo-256-colors)
- [Directory diff](#directory-diff)
- [Commands](#commands)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### time & date
#### Show Cal

```bash
$ cal -y | tr '\n' '|' | sed "s/^/ /;s/$/ /;s/ $(date +%e) / $(date +%e | sed 's/./#/g') /$(date +%m | sed s/^0//)" | tr '|' '\n'
                             2014
      January               February               March
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
          1  2  3  4                     1                     1
 5  6  7  8  9 10 11   2  3  4  5  6  7  8   2  3  4  5  6  7  8
12 13 14 15 16 17 18   9 10 11 12 13 14 15   9 10 11 12 13 14 15
19 20 21 22 23 24 25  16 17 18 19 20 21 22  16 17 ## 19 20 21 22
26 27 28 29 30 31     23 24 25 26 27 28     23 24 25 26 27 28 29
                                            30 31

       April                  May                   June
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
       1  2  3  4  5               1  2  3   1  2  3  4  5  6  7
 6  7  8  9 10 11 12   4  5  6  7  8  9 10   8  9 10 11 12 13 14
13 14 15 16 17 18 19  11 12 13 14 15 16 17  15 16 17 18 19 20 21
20 21 22 23 24 25 26  18 19 20 21 22 23 24  22 23 24 25 26 27 28
27 28 29 30           25 26 27 28 29 30 31  29 30


        July                 August              September
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
       1  2  3  4  5                  1  2      1  2  3  4  5  6
 6  7  8  9 10 11 12   3  4  5  6  7  8  9   7  8  9 10 11 12 13
13 14 15 16 17 18 19  10 11 12 13 14 15 16  14 15 16 17 18 19 20
20 21 22 23 24 25 26  17 18 19 20 21 22 23  21 22 23 24 25 26 27
27 28 29 30 31        24 25 26 27 28 29 30  28 29 30
                      31

      October               November              December
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
          1  2  3  4                     1      1  2  3  4  5  6
 5  6  7  8  9 10 11   2  3  4  5  6  7  8   7  8  9 10 11 12 13
12 13 14 15 16 17 18   9 10 11 12 13 14 15  14 15 16 17 18 19 20
19 20 21 22 23 24 25  16 17 18 19 20 21 22  21 22 23 24 25 26 27
26 27 28 29 30 31     23 24 25 26 27 28 29  28 29 30 31
                      30
```

#### Synchronize date and time with a server over ssh (Inspired from [commandlinefu.com](http://www.commandlinefu.com/commands/view/9153/synchronize-date-and-time-with-a-server-over-ssh))
```bash
$ date --set="$(ssh [username]@[sshserver] date)"
```

### Get URL

```bash
$ echo http://www.baidu.com | awk '{for(i=1;i<=NF;i++){if($i~/^(http|ftp):\/\//)print $i}}'
http://www.baidu.com
```

### Download and unzip
```bash
$ wget -O - http://example.com/a.gz | tar xz
```

### Get cookie from firefox
```bash
$ grep -oP '"url":"\K[^"]+' $(ls -t ~/.mozilla/firefox/*/sessionstore.js | sed q)
```

### Echo 256 colors
```bash
$ for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"
# or
$ yes "$(seq 1 255)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .01; done
```

### Directory diff
```bash
diff --suppress-common-lines -y <(cd path_to_dir1; find .|sort) <(cd path_to_dir2; find .|sort)
```

### Commands
#### PWD's secrets
```bash
$ l | grep bc
lrwxrwxrwx 1 marslo marslo   37 Mar  4 00:25 bc -> /home/marslo/Tools/Git/BrowserConfig//
$ cd bc/
$ pwd -L
/home/marslo/bc
$ pwd -P
/home/marslo/Tools/Git/BrowserConfig
```

#### List the command beginning with
```bash
$ compgen -c "system-config-"
system-config-authentication
system-config-authentication
system-config-date
system-config-firewall
system-config-firewall-tui
system-config-kdump
system-config-keyboard
system-config-keyboard
system-config-network
system-config-network
system-config-network-cmd
system-config-network-cmd
system-config-network-tui
system-config-printer
system-config-printer-applet
system-config-services
system-config-services
system-config-users
```

#### Searching for commands without knowing their exact names
```bash
$ apropos editor | head
Git::SVN::Editor (3pm) - commit driver for "git svn set-tree" and dcommit
INIFILE (1)          - OpenLink Virtuoso Opensource ini File Editor
atobm (1)            - bitmap editor and converter utilities for the X Window System
bitmap (1)           - bitmap editor and converter utilities for the X Window System
bmtoa (1)            - bitmap editor and converter utilities for the X Window System
ed (1)               - line-oriented text editor
editor (1)           - Nano's ANOther editor, an enhanced free Pico clone
editres (1)          - a dynamic resource editor for X Toolkit applications
ex (1)               - Vi IMproved, a programmers text editor
gedit (1)            - text editor for the GNOME Desktop
```

#### Show some command periodically
```bash
$ whatch --interval 1 ls -alt
```

#### Rename
```bash
$ l
total 4.0K
-rw-r--r-- 1 marslo marslo 10 Feb 21 00:43 a.b
$ rename -v 's/\./_/g' *
a.b renamed as a_b
$ l
total 4.0K
-rw-r--r-- 1 marslo marslo 10 Feb 21 00:43 a_b
```

#### Clear
```bash
$ printf "\ec"
```

#### Use less as tail -f
```bash
$ less +F <filename>
```

#### Batch move
```bash
$ mkdir backup-folder && ls | grep -Ze ".*rar" | xargs -d '\n' -I {} mv {} backup-folder
```
