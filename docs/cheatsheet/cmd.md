<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [network](#network)
  - [ip address](#ip-address)
  - [check port](#check-port)
- [file](#file)
  - [check file text or binary](#check-file-text-or-binary)
- [system](#system)
- [clock/time/date](#clocktimedate)
- [download](#download)
- [backup](#backup)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## network
### ip address
- get subnet IP address
  ```bash
  $ ip addr show eno1 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
  192.168.1.105
  fe80::e5ca:1027:b572:9998
  ```

- get public IP address
  ```bash
  $ curl -4 icanhazip.com
  182.150.46.248
  ```

### check port
```bash
$ sudo lsof -i:1111
COMMAND   PID   USER   FD   TYPE DEVICE SIZE/OFF NODE NAME
ss-server 903 nobody    8u  IPv4  20522      0t0  UDP *:1111
obfs-serv 909   root    7u  IPv4  20649      0t0  TCP *:1111 (LISTEN)

$ sudo netstatus -tunpla | grep 1111
tcp        0      0 0.0.0.0:1111            0.0.0.0:*               LISTEN      909/obfs-server
udp        0      0 0.0.0.0:1111            0.0.0.0:*                           903/ss-server
```

- [list all ports](https://www.commandlinefu.com/commands/view/1994/watch-network-service-activity-in-real-time)
  ```bash
  $ lsof -i
  # or stop by ctrl-c
  $ lsof -i -r

  # or: https://www.commandlinefu.com/commands/view/2545/list-programs-with-open-ports-and-connections
  $ netstat -ntauple
  ```

- [show apps that use internet connection](https://www.commandlinefu.com/commands/view/3542/show-apps-that-use-internet-connection-at-the-moment.-multi-language)
  ```bash
  $ lsof -P -i -n
  $ lsof -P -i -n | cut -f 1 -d " " | uniq | tail -n +2

  # or : https://www.commandlinefu.com/commands/view/3546/show-apps-that-use-internet-connection-at-the-moment.-multi-language
  $ ss -p
  $ ss -p | cut -f2 -sd\"
  ```

## file

- [create a bunch of dummy text files](https://www.commandlinefu.com/commands/view/12906/create-a-bunch-of-dummy-text-files)
  ```bash
  $ base64 /dev/urandom | head -c 33554432 | split -b 8192 -da 4 - dummy.
  ```

- [modify timestamp interactively](https://www.commandlinefu.com/commands/view/9717/changemodify-timestamp-interactively)
  ```bash
  $ touch -d $(zenity --calendar --date-format=%F) filename
  ```

- [change/modify timestamp](https://www.commandlinefu.com/commands/view/9707/changemodify-timestamp)
  ```bash
  $ touch --date "2010-01-05" /tmp/filename
  ```

- [run a command whenever a file is touched](https://www.commandlinefu.com/commands/view/6876/run-a-command-whenever-a-file-is-touched)
  ```bash
  $ ontouchdo(){ while :; do a=$(stat -c%Y "$1"); [ "$b" != "$a" ] && b="$a" && sh -c "$2"; sleep 1; done }
  ```

- [efficiently print a line deep in a huge log file](https://www.commandlinefu.com/commands/browse/14200)
  ```bash
  $ sed '1000000!d;q' huge.log
  # or
  $ sed '999995,1000005!d' < my_massive_file
  ```

- [transmit a file like a http server](https://www.commandlinefu.com/commands/view/9978/daemonize-nc-transmit-a-file-like-a-http-server)
  ```bash
  $ while ( nc -l 80 < /file.htm > : ) ; do : ; done &
  ```

- [create date-based tgz of current dir, runs in the background, very very cool](https://www.commandlinefu.com/commands/view/7083/create-date-based-tgz-of-current-dir-runs-in-the-background-very-very-cool)
  ```bash
  $ alias tarred='( ( D=`builtin pwd`; F=$(date +$HOME/`sed "s,[/ ],#,g" <<< ${D/${HOME}/}`#-%F.tgz); tar --ignore-failed-read --transform "s,^${D%/*},`date +${D%/*}.%F`,S" -czPf "$F" "$D" &>/dev/null ) & )'

  # or
  $ alias tarred='( ( D=`builtin pwd`; F=$(date +$HOME/`sed "s,[/ ],#,g" <<< ${D/${HOME}/}`#-%F.tgz); S=$SECONDS; tar --ignore-failed-read --transform "s,^${D%/*},`date +${D%/*}.%F`,S" -czPf "$"F "$D" && logger -s "Tarred $D to $F in $(($SECONDS-$S)) seconds" ) & )'
  ```

- [backup and remove files with access time older than 5 days](https://www.commandlinefu.com/commands/view/2291/backup-and-remove-files-with-access-time-older-than-5-days.)
  ```bash
  $ tar -zcvpf backup_`date +"%Y%m%d_%H%M%S"`.tar.gz `find <target> -atime +5` 2> /dev/null | xargs rm -fr ;
  ```

- [chmod with reference file](https://www.commandlinefu.com/commands/view/5233/makes-the-permissions-of-file2-the-same-as-file1)
  ```bash
  $ chmod --reference file1 file2

  # or: https://www.commandlinefu.com/commands/view/5234/makes-the-permissions-of-file2-the-same-as-file1
  # tips: man setfacl
  $ getfacl file1 | setfacl --set-file=- file2
  ```

- [share file via http 80](https://www.commandlinefu.com/commands/view/870/sharing-file-through-http-80-port)
  ```bash
  $ nc -v -l 80 < file.ext
  ```

### check file text or binary

> [!NOTE|label:references:]
> - [How to check if a file is binary?](https://stackoverflow.com/q/16760378/2940319)
>   - [`file`](https://stackoverflow.com/a/16760396/2940319)
>   - [`grep`](https://stackoverflow.com/a/43586072/2940319)
>   - [`perl`](https://stackoverflow.com/a/14603497/2940319)
> - [grep: (standard input): binary file matches](https://unix.stackexchange.com/a/379755/29178)

```bash
$ find . -type f -print0 | perl -0nE 'say if -f and -s _ and -T _'

# verify
$ find . -type f -print0 | perl -0nE 'say if -f and -s _ and -T _' | grep -a -E '\.db$'
```

## system

- [execute commnd at a specific time](https://www.commandlinefu.com/commands/view/7/execute-a-command-at-a-given-time)
  ```bash
  $ echo "ls -l" | at midnight
  # or
  $ at midnight <<< "ls -l"
  # or
  $ echo "ls -l" | at 10:00

  # set alarm to wake up: https://www.commandlinefu.com/commands/view/2502/set-an-alarm-to-wake-up-2
  $ echo "aplay path/to/song" | at [time]

  # timer with sound alarm: https://www.commandlinefu.com/commands/view/8341/timer-with-sound-alarm
  $ say(){ mplayer -user-agent Mozilla "http://translate.google.com/translate_tts?tl=en&q=$(echo $* | sed 's#\ #\+#g')" > /dev/null 2>&1 ; };
  $ sleep 3s && say "wake up, you bastard"

  # alarm with fade-in, for graceful awakening: https://www.commandlinefu.com/commands/view/9794/set-up-alarm-with-fade-in-for-graceful-awakening
  $ at 8:30 <<<'mpc volume 20; mpc play; for i in `seq 1 16`; do sleep 2; mpc volume +5; done'
  ```

- [sort disk usage](https://www.commandlinefu.com/commands/view/10/outputs-a-sorted-list-of-disk-usage-to-a-text-file)
  ```bash
  $ du | sort -gr
  ```

- [32bit or 64bit](https://www.commandlinefu.com/commands/view/2940/32-bits-or-64-bits)
  ```bash
  $ getconf LONG_BIT
  64
  ```

- [list most offen used command](https://www.commandlinefu.com/commands/view/604/list-of-commands-you-use-most-often)
  ```bash
  $ history | awk '{a[$2]++}END{for(i in a){print a[i] " " i}}' | sort -rn | head
  ```

- [eavesdrop on your system](https://www.commandlinefu.com/commands/view/5068/eavesdrop-on-your-system)
  ```bash
  $ diff <(lsof -p 1234) <(sleep 10; lsof -p 1234)
  # or
  $ tcpdump -i eth0 -s 0 -v -w /tmp/traffic.pcap
  ```

- [synchronize date and time with a server over ssh](https://www.commandlinefu.com/commands/view/9153/synchronize-date-and-time-with-a-server-over-ssh)
  ```bash
  $ date --set="$(ssh user@server date)"
  # or
  $ ssh -t user@host 'sudo date --set "$(ssh user@host date)"'
  ```

- [last reboot time](https://www.commandlinefu.com/commands/view/2220/find-last-reboot-time)
  ```bash
  $ who -b
  ```

- [current runlevel](https://www.commandlinefu.com/commands/view/5564/print-current-runlevel)
  ```bash
  $ who -r
  ```

- [backup files incremental with rsync to a ntfs-partition](https://www.commandlinefu.com/commands/view/2563/backup-files-incremental-with-rsync-to-a-ntfs-partition)
  ```bash
  $ rsync -rtvu --modify-window=1 --progress /media/SOURCE/ /media/TARGET/
  ```

- [make sudo forget password instantly](https://www.commandlinefu.com/commands/view/6726/make-sudo-forget-password-instantly)
  ```bash
  $ sudo -K
  ```

- [faster rsync](https://www.commandlinefu.com/commands/view/11690/the-fastest-remote-directory-rsync-over-ssh-archival-i-can-muster-40mbs-over-1gb-nics)
  ```bash
  $ rsync -aHAXxv --numeric-ids --delete --progress -e "ssh -T -c arcfour -o Compression=no -x" user@<source>:<source_dir> <dest_dir>
  ```

- [when was your OS installed?](https://www.commandlinefu.com/commands/view/3299/when-was-your-os-installed)
  ```bash
  $ ls -lct /etc | tail -1 | awk '{print $6, $7}'
  ```

- [check for login failures and summarize](https://www.commandlinefu.com/commands/view/1329/check-for-login-failures-and-summarize)

  > [!NOTE|label:references:]
  > - [* iMarslo: displays the attempted via SSH](../../devops/ssh.md#displays-the-attempted-login-via-ssh)
  ```bash
  $ zgrep "Failed password" /var/log/auth.log* | awk '{print $9}' | sort | uniq -c | sort -nr | less
  ```

- [find a count of how many times invalid users have attempted to access your system](https://www.commandlinefu.com/commands/view/1328/quickly-find-a-count-of-how-many-times-invalid-users-have-attempted-to-access-your-system)
  ```bash
  $ gunzip -c /var/log/auth.log.*.gz | cat - /var/log/auth.log /var/log/auth.log.0 | grep "Invalid user" | awk '{print $8;}' | sort | uniq -c | less
  ```

## clock/time/date

> [!TIP|lavel:see also:]
> - [* iMarslo: date](../linux/util/date.md)

- get how many days left this years
  ```bash
  $ echo "There are $(($(date +%j -d"Dec 31, $(date +%Y)")-$(date +%j))) left in year $(date +%Y)."
  There are 323 left in year 2014.
  ```

- get week number
  ```bash
  $ date +"%V"
  08
  ```

- [display a cool clock on your terminal](https://www.commandlinefu.com/commands/view/2473/display-a-cool-clock-on-your-terminal)
  ```bash
  $ watch -t -n1 "date +%T|figlet"
  ```

- [put a console clock in top right corner](https://www.commandlinefu.com/commands/view/7916/put-a-console-clock-in-top-right-corner)
  ```bash
  $ while sleep 1;do tput sc;tput cup 0 $(($(tput cols)-29));date;tput rc;done &
  ```

- [remind yourself to leave in 15 minutes](https://www.commandlinefu.com/commands/view/1476/remind-yourself-to-leave-in-15-minutes)
  ```bash
  $ leave +15
  ```

- [binary clock](https://www.commandlinefu.com/commands/view/3969/binary-clock)
  ```bash
  $ watch -n 1 'echo "obase=2;`date +%s`" | bc'
  ```

- [countdown clock](https://www.commandlinefu.com/commands/view/5886/countdown-clock)
  ```bash
  $ MIN=1 && for i in $(seq $(($MIN*60)) -1 1); do echo -n "$i, "; sleep 1; done; echo -e "\n\nBOOOM! Time to start."
  ```

- [countdown clock for new year](https://www.commandlinefu.com/commands/view/4455/climagics-new-years-countdown-clock)
  ```bash
  $ while V=$((`date +%s -d"2025-01-01"`-`date +%s`));do if [ $V == 0 ];then figlet 'Happy New Year!';break;else figlet $V;sleep 1;clear;fi;done
  ```

## download

- [parallel file downloading with wget](https://www.commandlinefu.com/commands/view/3269/parallel-file-downloading-with-wget)
  ```bash
  $ wget -nv http://en.wikipedia.org/wiki/Linux -O- | egrep -o "http://[^[:space:]]*.jpg" | xargs -P 10 -r -n 1 wget -nv
  ```

- [log download speed](https://www.commandlinefu.com/commands/view/3544/log-your-internet-download-speed)
  ```bash
  $ echo $(date +%s) > start-time; URL=http://www.google.com; while true; do echo $(curl -L --w %{speed_download} -o/dev/null -s $URL) >> bps; sleep 10; done &

  # show as graph view
  $ gnuplot -persist <(echo "plot 'bps' with lines")
  ```

- [download every font from dafont.com to current folder](https://www.commandlinefu.com/commands/view/5637/fetch-every-font-from-dafont.com-to-current-folder)
  ```bash
  $ d="www.dafont.com/alpha.php?"; for c in {a..z}; do l=`curl -s "${d}lettre=${c}"|sed -n 's/.*ge=\([0-9]\{2\}\).*/\1/p'`; for((p=1;p<=l;p++));do for u in `curl -s "${d}page=${p}&lettre=${c}"|egrep -o "http\S*.com/dl/\?f=\w*"`; do aria2c "${u}"; done; done; done
  ```

- [download free e-books](https://www.commandlinefu.com/commands/view/4993/download-free-e-books)
  ```bash
  $ wget -erobots=off --user-agent="Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.0.3) Gecko/2008092416 Firefox/3.0.3" -H -r -l2 --max-redirect=1 -w 5 --random-wait -PmyBooksFolder -nd --no-parent -A.pdf http://URL
  ```

## backup

- [database backup](https://www.commandlinefu.com/commands/view/4036/create-date-based-backups)
  ```bash
  $ backup() { for i in "$@"; do cp -va $i $i.$(date +%Y%m%d-%H%M%S); done }
  ```

- [backup mysql](https://www.commandlinefu.com/commands/view/2916/backup-all-mysql-databases-to-individual-files)
  ```bash
  $ for I in $(mysql -e 'show databases' -s --skip-column-names); do mysqldump $I | gzip > "$I.sql.gz"; done
  ```

- [backup multiple files](https://www.commandlinefu.com/commands/view/2527/quickly-backup-or-copy-a-file-with-bash)
  ```bash
  $ cp -bfS.bak filename filename
  ```

## others

- [advanced ls](https://www.commandlinefu.com/commands/view/5815/advanced-ls-output-using-find-for-formattedsortable-file-stat-info)
  ```bash
  $ find $PWD -maxdepth 1 -printf '%.5m %10M %#9u:%-9g %#5U:%-5G [%AD | %TD | %CD] [%Y] %p\n'

  # or
  $ find $PWD -maxdepth 1 -printf '%.5m %10M %#9u:%-9g %#5U:%-5G [%AD | %TD | %CD] [%Y] %p\n' | sort -rgbS 50%
  ```

- DOS tree
  ```bash
  $ find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g':wa
  .
  |____a_b
  |____b_a
  ```

- [the most frequent used words of a text file](https://www.commandlinefu.com/commands/view/5994/computes-the-most-frequent-used-words-of-a-text-file)
  ```bash
  $ cat WAR_AND_PEACE_By_LeoTolstoi.txt | tr -cs "[:alnum:]" "\n"| tr "[:lower:]" "[:upper:]" | awk '{h[$1]++}END{for (i in h){print h[i]" "i}}'|sort -nr | cat -n | head -n 30
  ```

- [count how many times a string appears in a (source code) tree](https://www.commandlinefu.com/commands/view/2676/count-how-many-times-a-string-appears-in-a-source-code-tree)
  ```bash
  $ grep -or string path/ | wc -l
  ```

- [matrix](https://www.commandlinefu.com/commands/view/3673/matrix-style)
  ```bash
  $ echo -e "\e[32m"; while :; do for i in {1..16}; do r=`echo -e "\x$(echo $(($(($RANDOM % 26)) + $(echo $([[ $(($RANDOM % 3)) == 1 ]] && echo -n 48 || echo -n $([[ $(($RANDOM % 3)) == 2 ]] && echo -n 97 || echo -n 65))))) 16 o p | dc)"`; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r   "; else v+="\e[2m $r   "; fi; else v+="     "; fi; done; echo -e "$v"; v=""; done

  # https://www.commandlinefu.com/commands/view/2531/matrix-style
  $ tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"

  # https://www.commandlinefu.com/commands/view/3652/matrix-style
  $ echo -e "\e[32m"; while :; do for i in {1..16}; do r="$(($RANDOM % 2))"; if [[ $(($RANDOM % 5)) == 1 ]]; then if [[ $(($RANDOM % 4)) == 1 ]]; then v+="\e[1m $r "; else v+="\e[2m $r "; fi; else v+=" "; fi; done; echo -e "$v"; v=""; done

  # https://www.commandlinefu.com/commands/view/4352/another-matrix-style-implementation
  $ COL=$(( $(tput cols) / 2 )); clear; tput setaf 2; while :; do tput cup $((RANDOM%COL)) $((RANDOM%COL)); printf "%$((RANDOM%COL))s" $((RANDOM%2)); done

  # https://www.commandlinefu.com/commands/view/2542/matrix-style
  $ LC_ALL=C tr -c "[:digit:]" " " < /dev/urandom | dd cbs=$COLUMNS conv=unblock | GREP_COLOR="1;32" grep --color "[^ ]"

  # https://www.commandlinefu.com/commands/view/4384/another-matrix-style-implementation
  $ echo -ne "\e[32m" ; while true ; do echo -ne "\e[$(($RANDOM % 2 + 1))m" ; tr -c "[:print:]" " " < /dev/urandom | dd count=1 bs=50 2> /dev/null ; done

  # https://www.commandlinefu.com/commands/view/2615/matrix-style
  $ echo -e "\e[31m"; while $t; do for i in `seq 1 30`;do r="$[($RANDOM % 2)]";h="$[($RANDOM % 4)]";if [ $h -eq 1 ]; then v="\e[1m $r";else v="\e[2m $r";fi;v2="$v2 $v";done;echo -e $v2;v2="";done;
  ```

- [notify send in Gnome](https://www.commandlinefu.com/commands/view/2041/send-pop-up-notifications-on-gnome)
  ```bash
  $ notify-send ["<title>"] "<body>"
  ```

- [notify via inotifywait](https://www.commandlinefu.com/commands/view/6869/trigger-a-command-each-time-a-file-is-created-in-a-directory-inotify)
  ```bash
  $ inotifywait -mrq -e CREATE --format %w%f /path/to/dir | while read FILE; do chmod g=u "$FILE"; done
  ```

- [change xterm window title](https://www.commandlinefu.com/commands/view/897/change-the-window-title-of-your-xterm)
  ```bash
  $ echo "^[]0;My_Title_Goes _Here^G"
  ```

- [retry previous cmd until succeed](https://www.commandlinefu.com/commands/view/12327/retry-the-previous-command-until-it-exits-successfully)
  ```bash
  $ until !!; do :; done

  # or: https://www.commandlinefu.com/commands/view/12238/retry-the-previous-command-until-it-exits-successfully
  $ until !!; do done

  # or: https://www.commandlinefu.com/commands/view/12236/retry-the-previous-command-until-it-exits-successfully
  $ !!; while [ $? -ne 0 ]; do !!; done
  ```

- [retry until succeed](https://www.commandlinefu.com/commands/view/14300/keep-trying-a-command-until-it-is-successful)
  ```bash
  $ util <command>; do echo "retyring"; sleep 1; done
  ```

- [check unread Gmail from the command line](https://www.commandlinefu.com/commands/view/3380/check-your-unread-gmail-from-the-command-line)
  ```bash
  $ curl -u username:password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | sed -n "s/<title>\(.*\)<\/title.*name>\(.*\)<\/name>.*/\2 - \1/p"

  # from mac:
  $ curl -u username:password --silent "https://mail.google.com/mail/feed/atom" | tr -d '\n' | awk -F '<entry>' '{for (i=2; i<=NF; i++) {print $i}}' | perl -pe 's/^<title>(.*)<\/title>.*<name>(.*)<\/name>.*$/$2 - $1/'

  # or: https://www.commandlinefu.com/commands/view/9490/check-your-unread-gmail-from-the-command-line
  $ curl -u username --silent "https://mail.google.com/mail/feed/atom" | awk 'BEGIN{FS="\n";RS="(</entry>\n)?<entry>"}NR!=1{print "\033[1;31m"$9"\033[0;32m ("$10")\033[0m:\t\033[1;33m"$2"\033[0m"}' | sed -e 's,<[^>]*>,,g' | column -t -s $'\t'
  ```

- [search cmdful via curl](https://www.commandlinefu.com/commands/view/3086/search-commandlinefu.com-from-the-command-line-using-the-api)
  ```bash
  $ cmdfu(){ curl "http://www.commandlinefu.com/commands/matching/$@/$(echo -n $@ | openssl base64)/plaintext"; }

  # or: https://www.commandlinefu.com/commands/view/10233/search-commandlinefu.com-from-the-command-line-using-the-api
  # usage: cmdfu search 'command'
  $ cmdfu(){ curl "http://www.commandlinefu.com/commands/matching/$(echo "$@" | sed 's/ /-/g')/$(echo -n $@ | base64)/plaintext" --silent | vim -R - }

  # or: https://www.commandlinefu.com/commands/view/9654/search-commandlinefu.com-from-the-command-line-using-the-api
  $ cmdfu(){ curl "http://www.commandlinefu.com/commands/matching/$@/$(echo -n $@ | openssl base64)/plaintext" --silent | sed "s/\(^#.*\)/\x1b[32m\1\x1b[0m/g" | less -R }
  ```

- [backup cmdfu commands](https://www.commandlinefu.com/commands/view/3681/backup-all-your-commandlinefu.com-favourites-to-a-plaintext-file)
  ```bash
  # usage: clfavs username password num_favourite_commands /path/to/file
  $ clfavs(){ URL="http://www.commandlinefu.com"; wget -O - --save-cookies c --post-data "username=$1&password=$2&submit=Let+me+in" $URL/users/signin; for i in `seq 0 25 $3`; do wget -O - --load-cookies c $URL/commands/favourites/plaintext/$i >>$4; done; rm -f c; }
  # or
  $ clfavs(){ URL="http://www.commandlinefu.com"; wget -O - --save-cookies c --post-data "openid=$1&submit=Let+me+in" $URL/users/openid; for i in `seq 0 25 $3`; do wget -O - --load-cookies c $URL/commands/favourites/plaintext/$i >>$4; done; rm -f c; }
  ```
