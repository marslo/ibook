<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [network tools](#network-tools)
  - [`vnstat`](#vnstat)
  - [`ipcalc`](#ipcalc)
  - [`iostat`](#iostat)
  - [`tcpdump`](#tcpdump)
  - [`dstat`](#dstat)
  - [strace](#strace)
  - [sar](#sar)
  - [netcat](#netcat)
  - [`ip`](#ip)
- [oneline commands](#oneline-commands)
  - [cat and EOF](#cat-and-eof)
  - [ssh](#ssh)
  - [find and tar](#find-and-tar)
  - [find and rename](#find-and-rename)
  - [find and sort](#find-and-sort)
- [download and extract](#download-and-extract)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='top' %}
> references:
> - [20 Command Line Tools to Monitor Linux Performance](http://www.tecmint.com/command-line-tools-to-monitor-linux-performance/)
> - [20 Linux System Monitoring Tools Every SysAdmin Should Know](http://www.cyberciti.biz/tips/top-linux-monitoring-tools.html)
> - [Top 25 Best Linux Performance Monitoring and Debugging Tools](http://thegeekstuff.com/2011/12/linux-performance-monitoring-tools/)
> - [http://www.thegeekstuff.com/2010/12/50-unix-linux-sysadmin-tutorials](http://www.thegeekstuff.com/2010/12/50-unix-linux-sysadmin-tutorials/)
> - [16 commands to check hardware information on Linux](http://www.binarytides.com/linux-commands-hardware-info/)
> - [Best UNIX shell-based tools](https://gist.github.com/mbbx6spp/1429161)
> - [* alebcay/awesome-shell](https://github.com/alebcay/awesome-shell/tree/master)
>   - [* zh-cn](https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md)
>   - [nosarthur/awesome-shell](https://github.com/nosarthur/awesome-shell)
> - [* rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
> - [jlevy/the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)
> - [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial/basics)
> - [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
> - [Use Bash Strict Mode (Unless You Love Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
> - others
>   - [bayandin/awesome-awesomeness](https://github.com/bayandin/awesome-awesomeness)
>   - [emijrp/awesome-awesome](https://github.com/emijrp/awesome-awesome)
>   - [kahun/awesome-sysadmin](https://github.com/kahun/awesome-sysadmin)
> - [My Minimalist Over-powered Linux Setup Guide](https://medium.com/@jonyeezs/my-minimal-over-powered-linux-setup-guide-710931efb75b)
> - [* devynspencer/cute_commands.sh](https://gist.github.com/devynspencer/cfdce35b3230e72214ef)
{% endhint %}

## network tools

### `vnstat`

![vnstat](../screenshot/linux/vnstat.png)

```bash
$ vnstat -l 1 -i en7
Monitoring en7...    (press CTRL-C to stop)

   rx:     4.10 kbit/s   21.00 KiB          tx:         0 bit/s   6.00 KiB^C

 en7  /  traffic statistics
                           rx         |       tx
--------------------------------------+------------------
  bytes                    21.00 KiB  |        6.00 KiB
--------------------------------------+------------------
          max           53.25 kbit/s  |    12.29 kbit/s
      average           17.20 kbit/s  |     4.92 kbit/s
          min                0 bit/s  |         0 bit/s
--------------------------------------+------------------
  packets                         60  |              52
--------------------------------------+------------------
          max                 15 p/s  |          16 p/s
      average                  6 p/s  |           5 p/s
          min                  2 p/s  |           0 p/s
--------------------------------------+------------------
  time                    10 seconds
```

### `ipcalc`

![ipcalc](../screenshot/linux/ipcalc.png)

```bash
$ ipcalc 10.25.130.2/23
Address:   10.25.130.2          00001010.00011001.1000001 0.00000010
Netmask:   255.255.254.0 = 23   11111111.11111111.1111111 0.00000000
Wildcard:  0.0.1.255            00000000.00000000.0000000 1.11111111
=>
Network:   10.25.130.0/23       00001010.00011001.1000001 0.00000000
HostMin:   10.25.130.1          00001010.00011001.1000001 0.00000001
HostMax:   10.25.131.254        00001010.00011001.1000001 1.11111110
Broadcast: 10.25.131.255        00001010.00011001.1000001 1.11111111
Hosts/Net: 510                   Class A, Private Internet

$ ipcalc 10.25.131.1/23
Address:   10.25.131.1          00001010.00011001.1000001 1.00000001
Netmask:   255.255.254.0 = 23   11111111.11111111.1111111 0.00000000
Wildcard:  0.0.1.255            00000000.00000000.0000000 1.11111111
=>
Network:   10.25.130.0/23       00001010.00011001.1000001 0.00000000
HostMin:   10.25.130.1          00001010.00011001.1000001 0.00000001
HostMax:   10.25.131.254        00001010.00011001.1000001 1.11111110
Broadcast: 10.25.131.255        00001010.00011001.1000001 1.11111111
Hosts/Net: 510                   Class A, Private Internet
```

### `iostat`
```bash
$ iostat
              disk0       cpu    load average
    KB/t  tps  MB/s  us sy id   1m   5m   15m
   19.85   37  0.72   3  1 96  1.78 1.90 1.69
```

### `tcpdump`
```bash
$ sudo tcpdump -A -i en7
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on en7, link-type EN10MB (Ethernet), capture size 262144 bytes
00:33:02.787671 IP 10.25.130.117.53629 > a23-43-240-92.deploy.static.akamaitechnologies.com.https: Flags [.], ack 697481089, win 2048, length 0
E..(....@...
..u.+.\.}..r...)...P...:...
00:33:02.790119 IP 10.25.130.117.51541 > sh-vdc01.mycompany.com.domain: 53089+ PTR? 92.240.43.23.in-addr.arpa. (43)
E..GP....._.
..u
&t..U.5.3...a...........92.240.43.23.in-addr.arpa.....
00:33:02.812866 ARP, Request who-has gw-voice-idf.cdu-cn.mycompany.com tell gw-vg224-idf.cdu-cn.mycompany.com, length 46
....
....
13 packets captured
25 packets received by filter
0 packets dropped by kernel
```

- [or](https://superuser.com/a/1567926/112396)
  ```bash
  $ sudo tcpdump -n -i any src or dst target.ip.address [ -v ]

  # i.e.
  $ sudo tcpdump -n -i any src or dst git.domain.com -v
  tcpdump: data link type PKTAP
  tcpdump: listening on any, link-type PKTAP (Apple DLT_PKTAP), snapshot length 524288 bytes
  00:02:55.698822 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 52)
      10.25.130.104.63447 > 10.69.78.140.29418: Flags [F.], cksum 0x8fe0 (correct), seq 2566890566, ack 4019765769, win 2058, options [nop,nop,TS val 1955309758 ecr 154499413], length 0
  ```

### `dstat`

![dstat](../screenshot/linux/dstat.png)

### strace

> [!NOTE|label:references:]
> - [I have a tab completion that hangs, is it possible to use strace to find out what is going on?](https://unix.stackexchange.com/a/525582/29178)
> - [Resolve nested aliases to their source commands](https://unix.stackexchange.com/a/441389/29178)

```bash
$ ... run cmd ...

# or
$ pid=$(echo ??)
$ sudo strace -fp ${pid} -o log

# or
$ sudo -v
$ sudo strace -fp $$ -o log &
```

- more
  ```bash
  $ set -o functrace xtrace
  $ PS4=' ${BASH_SOURCE}:$FUNCNAME:$LINENO: '
  ```

- [debug script](https://askubuntu.com/a/678919/92979)

  <!--sec data-title="debug script" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ strace -e clone,execve,pipe,dup2 \
           -f bash -c 'cat <(/bin/true) <(/bin/false) <(/bin/echo)'
  execve("/usr/bin/bash", ["bash", "-c", "cat <(/bin/true) <(/bin/false) <"...], 0x7fff9b9c6f98 /* 75 vars */) = 0
  pipe([3, 4])                            = 0
  dup2(3, 63)                             = 63
  clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7cf6a8ca10) = 289963
  strace: Process 289963 attached
  [pid 289962] pipe([3, 4])               = 0
  [pid 289962] dup2(3, 62)                = 62
  [pid 289962] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289963] dup2(4, 1)                 = 1
  [pid 289962] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289964
  strace: Process 289964 attached
  [pid 289963] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289962] pipe([3, 4])               = 0
  strace: Process 289965 attached
  [pid 289963] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289965
  [pid 289962] dup2(3, 61)                = 61
  [pid 289962] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289964] dup2(4, 1)                 = 1
  [pid 289965] execve("/bin/true", ["/bin/true"], 0x55ec7c007680 /* 73 vars */strace: Process 289966 attached
   <unfinished ...>
  [pid 289962] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289966
  [pid 289964] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289965] <... execve resumed>)      = 0
  strace: Process 289967 attached
  [pid 289964] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289967
  [pid 289966] dup2(4, 1)                 = 1
  [pid 289967] execve("/bin/false", ["/bin/false"], 0x55ec7c007af0 /* 73 vars */ <unfinished ...>
  [pid 289966] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7cf6a8ca10) = 289968
  [pid 289967] <... execve resumed>)      = 0
  strace: Process 289968 attached
  [pid 289962] execve("/usr/bin/cat", ["cat", "/dev/fd/63", "/dev/fd/62", "/dev/fd/61"], 0x55ec7c007bc0 /* 73 vars */ <unfinished ...>
  [pid 289968] execve("/bin/echo", ["/bin/echo"], 0x55ec7c007e20 /* 73 vars */ <unfinished ...>
  [pid 289962] <... execve resumed>)      = 0
  [pid 289968] <... execve resumed>)      = 0
  [pid 289965] +++ exited with 0 +++
  [pid 289963] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289965, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289963] +++ exited with 0 +++
  [pid 289962] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289963, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289967] +++ exited with 1 +++
  [pid 289964] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289967, si_uid=10564, si_status=1, si_utime=0, si_stime=0} ---
  [pid 289964] +++ exited with 1 +++
  [pid 289962] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289964, si_uid=10564, si_status=1, si_utime=0, si_stime=0} ---

  [pid 289968] +++ exited with 0 +++
  [pid 289966] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289968, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289966] +++ exited with 0 +++
  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289966, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  +++ exited with 0 +++
  ```
  <!--endsec-->

- [xtrace](https://unix.stackexchange.com/a/441389/29178)
  ```bash
  xtrace() {
      local eval_cmd
      printf -v eval_cmd '%q' "${@}"
      { set -x
        eval "${eval_cmd}"
      } 2>&1 | grep '^++'
      return "${PIPESTATUS[0]}"
  }
  ```

### sar

### netcat

> [!NOTE]
> references:
> - [the netcat command in linux](https://www.baeldung.com/linux/netcat-command)

- check particular port
  ```bash
  $ nc -zv 127.0.0.1 22
  Connection to 127.0.0.1 port 22 [tcp/ssh] succeeded!
  ```

- check ports in range
  ```bash
  $ nc -znv -w 1 127.0.0.1 20-30
  nc: connectx to 127.0.0.1 port 20 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 21 (tcp) failed: Connection refused
  Connection to 127.0.0.1 port 22 [tcp/*] succeeded!
  nc: connectx to 127.0.0.1 port 23 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 24 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 25 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 26 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 27 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 28 (tcp) failed: Connection refused
  ```

- running simple web server
  ```bash
  $ cat > index.html <<<EOF
  <!DOCTYPE html>
  <html>
      <head>
          <title>Simple Netcat Server</title>
      </head>
      <body>
          <h1>Welcome to simple netcat server!<h1>
      </body>
      </body>
  <html>
  EOF

  $ echo -e "HTTP/1.1 200 OK\n\n$(cat index.html)" | nc -l 1234
  ```

- or getting more
  ```bash
  $ while true; do echo -e "HTTP/1.1 200 OK\n\n$(cat index.html)" | nc -l -w 1 1234; done
  GET / HTTP/1.1
  Host: localhost:1234
  Connection: keep-alive
  sec-ch-ua: "Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"
  sec-ch-ua-mobile: ?0
  sec-ch-ua-platform: "macOS"
  Upgrade-Insecure-Requests: 1
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
  Sec-Fetch-Site: none
  Sec-Fetch-Mode: navigate
  Sec-Fetch-User: ?1
  Sec-Fetch-Dest: document
  Accept-Encoding: gzip, deflate, br
  Accept-Language: en,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7

  GET /favicon.ico HTTP/1.1
  Host: localhost:1234
  Connection: keep-alive
  sec-ch-ua: "Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"
  sec-ch-ua-mobile: ?0
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36
  sec-ch-ua-platform: "macOS"
  Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8
  Sec-Fetch-Site: same-origin
  Sec-Fetch-Mode: no-cors
  Sec-Fetch-Dest: image
  Referer: http://localhost:1234/
  Accept-Encoding: gzip, deflate, br
  Accept-Language: en,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7

  ...
  ```

  ![netcat web service](../screenshot/linux/netcat-1234-html.png)

- [reverse proxy with netcat](https://www.baeldung.com/linux/netcat-command#reverse-proxy-with-netcat)


### `ip`
```bash
$ ip addr show | sed -nE "s/inet\s(.*)\/[0-9]+.*\s(\w+)/\2 \1/p"
  lo0 127.0.0.1
  en0 192.168.1.71

# for linux
$ ip addr show | sed -nE "s/inet\s(.*)\/[0-9]+.*\s(\w+)/\2 \1/p" | column -to ' => '
lo0 => 127.0.0.1
en0 => 192.168.1.71
```

## oneline commands

### cat and EOF

> [!NOTE|label:references:]
> - [Chapter 19. Here Documents](https://tldp.org/LDP/abs/html/here-docs.html)
> - [bash Heredoc](https://linuxize.com/post/bash-heredoc/)
>   - using heredoc with ssh
>     ```bash
>     ssh -T user@host.com << EOF
>     echo "The current local working directory is: $PWD"
>     echo "The current remote working directory is: \$PWD"
>     EOF
>     ```
> - [* POSIX.1 states](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap01.html#tag_17_04)
>   ```
>   ...an operand naming a file can be specified as '-', which means to use the standard input instead of a named file ....
>   ```

- kubectl apply from stdin

  > [!NOTE|label:references:]
  > - [Need some explaination of kubectl stdin and pipe](https://stackoverflow.com/a/72168173/2940319)

  ```bash
  $ cat << 'EOF' | kubectl apply -f -
  ...
  ...
  EOF

  # or
  $ kubectl apply -f - << EOF
  ...
  ...
  EOF
  ```

- git apply from stdin

  ```bash
  $ cat >> 'EOF' | git apply --inaccurate-eof --ignore-whitespace
  ...
  ...
  EOF

  # or
  $ git apply --inaccurate-eof --ignore-whitespace --stat << 'EOF'
  ...
  ...
  EOF
   install |    6 ++----
   1 file changed, 2 insertions(+), 4 deletions(-)
  ```

- git apply from clipboard

  > [!NOTE|label:references:]
  > - [Pipe (a patch in my clipboard) to `git apply`?](https://superuser.com/q/1493215/112396)

  ```bash
  $ pbpaste | git apply

  $ xsel --clipboard --input | git apply
  # or
  $ xclip -selection clipboard -o | git apply
  ```

- patch from stdin

  > [!NOTE|label:references:]
  > - [How can I run patch through a heredoc in bash?](https://unix.stackexchange.com/a/409327/29178)

  ```bash
  $ patch --dry-run --ignore-whitespace << 'EOF'
  ...
  ...
  EOF
  ```

### ssh
- compress and ssh and extract
  ```bash
  $ tar cf - . | ssh elsewhere tar xf - -C /other/dir
  ```

- tips

  > [!NOTE|label:references:]
  > - [How can I copy multiple files over scp in one command?](https://superuser.com/a/116001/112396)

  ```bash
  # tips
  $ tar cfz - . | ssh otherhost "cd /mydir; tar xvzf -"
  # the z-flag to tar does compression. Or you can use -C to ssh:
  $ tar cf - . | ssh -C otherhost "cd /mydir; tar xvf -"
  ```

### find and tar
```bash
$ find . -name builds -prune -o -type f -print | tar czf ~/m.tar.gz --files-from -

# or find with maxdepth
$ find . -type f -name "config.xml" -maxdepth 2 -prune -print | tar czf ~/config.xml.130.tar.gz --files-from -

# find with special name
$ find . -name config\.xml -type f -print | tar czf ~/m.tar.gz --files-from -

# and ssh and extract
$ tar cf - . | ssh -C otherhost "cd /mydir; tar xvf -"
```

### find and rename
```bash
$ find -iname "*.sh" -exec rename "s/.sh$/.shell/" {} \; -print
```

### find and sort

- via timestamp
  > [!NOTE]
  > - [How to Find and Sort Files Based on Modification Date and Time in Linux](https://www.tecmint.com/find-and-sort-files-modification-date-and-time-in-linux/)
  >   ```bash
  >   $ find . -type f -printf "\n%AD %AT %p" | head -n 11 | sort -k1.8n -k1.1nr -k1
  >   # or
  >   $ find . -type f -printf "\n%Tm/%Td/%TY %TT %p" | sort -k1.8n -k1.1nr -k1
  >   ```
  > - [* iMarslo : find printf](../cheatsheet/character/character.html#printf)
  > - [* `printf` time formats](https://www.codedodle.com/find-printf.html#time-formats)
  >   ```bash
  >   $ find . -printf "%T<format>\n"
  >   ```
  > - [sort by datetime format in bash](https://stackoverflow.com/a/67608960/2940319)
  > - [how to sort file by DD-MM-YYYY dates](https://unix.stackexchange.com/a/485708/29178)
  > - [Sort logs by date field in bash](https://stackoverflow.com/a/5243126/2940319)

  ```bash
  # via %T+
  $ find ~/.marslo -type f -printf "%10T+ | %p\n" | sort -r | head -10

  # via %Td-%Tm-%TY
  $ find ~/.marslo -type f -printf "\n%Td-%Tm-%TY %TT %p" |
    sort -b -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -r
  ```

  - via [awk+sort](https://stackoverflow.com/a/73881909/2940319)
    ```bash
    $ cat a.txt
    ABC,1/02/2022,05:50
    OPQ,18/10/2023,07:50
    HIJ,31/09/2023,08:50
    DEF,1/02/2021,06:00

    $ awk -F'[,/]' '{printf "%04d-%02d-%02d\t%s\n", $4,$3,$2, $0}' a | sort -r | cut -f2-
    OPQ,18/10/2023,07:50
    HIJ,31/09/2023,08:50
    ABC,1/02/2022,05:50
    DEF,1/02/2021,06:00
    ```

## download and extract
- tar.gz
  ```bash
  $ curl -fsSL https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz | tar xzf - -C /path/to/target
  ```

- zip
  ```bash
  $ curl -fsSL https://downloads.gradle.org/distributions/gradle-8.4-bin.zip | bsdtar xzf - -C /path/to/target
  ```
