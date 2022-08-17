<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [prompt](#prompt)
- [character](#character)
  - [metacharacter](#metacharacter)
- [process substitution](#process-substitution)
  - [example: run script without download](#example-run-script-without-download)
  - [example: merge lines of file](#example-merge-lines-of-file)
    - [nstalling tools via running random scripts from unknown sites](#nstalling-tools-via-running-random-scripts-from-unknown-sites)
  - [`strace`](#strace)
- [basic commands](#basic-commands)
  - [`du`](#du)
  - [sort](#sort)
    - [sort result via human-readable format](#sort-result-via-human-readable-format)
  - [others](#others)
    - [`you have new mail`](#you-have-new-mail)
- [centos](#centos)
  - [yum](#yum)
    - [enable or disable repo](#enable-or-disable-repo)
    - [`File "/usr/libexec/urlgrabber-ext-down", line 28`](#file-usrlibexecurlgrabber-ext-down-line-28)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference
> - [The Bash Shell Startup Files](http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html)
> - [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/index.html)
> - download pdf from [here](https://tldp.org/LDP/abs/abs-guide.pdf) or [here](http://www.linux-france.org/lug/ploug/doc/abs-guide.pdf)
> - [Perform tab-completion for aliases in Bash](https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/)
{% endhint %}

# prompt

{% hint style='tip' %}
> reference:
> - [* imarslo: color](../cheatsheet/colors.html)
> - [Bash/Prompt customization](https://wiki.archlinux.org/index.php/Bash/Prompt_customization)
> - [Colors using tput](https://wiki.bash-hackers.org/scripting/terminalcodes#colors_using_tput)
> - [What color codes can I use in my PS1 prompt?](https://unix.stackexchange.com/a/124409/29178)
{% endhint %}

```bash
PS1="\[$(tput setaf 0)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 1)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 2)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 3)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 4)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 5)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 6)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 7)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 8)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 9)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 10)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 11)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 12)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 13)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 14)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 15)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 16)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 17)\]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 18)\]my prompt\[$(tput sgr0)\]> "
```
![bash ps1](../../screenshot/ansi/bash-ps1.png)

- or
  ```bash
  $ DEFAULT="\[$(tput setaf 3)\]"         # or '\[\033[1;38;5;3m\]'     or '\[\e[1;33m\]'
  $ ifDEFAULT='\[\e[1\;33m\]'             # or '\[\033[1\;38\;5\;3m\]'
  $ ifRED='\[\e[1\;31m\]'                 # or '\[\033[1\;38\;5\;1m\]'
  $ PS1="${DEFAULT}my prompt${RESET} \$( if [ \$? != 0 ]; then echo -e ${ifRED}\\$; else echo -e ${ifDEFAULT}\\$; fi) ${RESET}"
  ```
  ![bash ps1 in conditional](../../screenshot/ansi/bash-ps1-conditions.png)

- right prompt
  ```
  rightprompt()
  {
    printf "%*s" $COLUMNS "right prompt"
  }
  PS1='\[$(tput sc; rightprompt; tput rc)\]left prompt > '
  ```
  ![bash ps1 right-prompt](../../screenshot/ansi/bash-ps1-right-prompt.png)


# character
## [metacharacter](https://www.grymoire.com/Unix/Quote.html)

| Character        | Where                | Meaning                                       |
|:----------------:|----------------------|-----------------------------------------------|
| `<RETURN>`       | csh, sh              | Execute command                               |
| `#`              | csh, sh, ASCII files | Start a comment                               |
| `<SPACE>`        | csh, sh              | Argument separator                            |
| ```              | csh, sh              | Command substitution                          |
| `"`              | csh, sh              | Weak Quotes                                   |
| `'`              | csh, sh              | Strong Quotes                                 |
| `\`              | csh, sh              | Single Character Quote                        |
| `variable`       | sh, csh              | Variable                                      |
| `variable`       | csh, sh              | Same as variable                              |
| `\`              | csh, sh              | Pipe character                                |
| `^`              | sh                   | Pipe Character                                |
| `&`              | csh, sh              | Run program in background                     |
| `?`              | csh, sh              | Match one character                           |
| `*`              | csh, sh              | Match any number of characters                |
| `;`              | csh, sh              | Command separator                             |
| `;;`             | sh                   | End of Case statement                         |
| `~`              | csh                  | Home Directory                                |
| `~user`          | csh                  | User's Home Directory                         |
| `!`              | csh                  | History of Commands                           |
| `-`              | Programs             | Start of optional argument                    |
| `$#`             | csh, sh              | Number of arguments to script                 |
| `$*`             | csh, sh              | Arguments to script                           |
| `$@`             | sh                   | Original arguments to script                  |
| `$-`             | sh                   | Flags passed to shell                         |
| `$?`             | sh                   | Status of previous command                    |
| `$$`             | sh                   | Process identification number                 |
| `$!`             | sh                   | PID of last background job                    |
| `&&`             | sh                   | Short-circuit AND                             |
| `||`             | sh                   | Short-circuit OR                              |
| `.`              | csh, sh              | Typ. filename extension                       |
| `.`              | sh                   | Source a file and execute as command          |
| `:`              | sh                   | Nothing command                               |
| `:`              | sh                   | Separates Values in environment variables     |
| `:`              | csh                  | Variable modifier                             |
| `Character`      | Where                | Meaning                                       |
| `[ ]`            | csh, sh              | Match range of characters                     |
| `[ ]`            | sh                   | Test                                          |
| `%job`           | csh                  | Identifies job Number                         |
| `(cmd;cmd)`      | csh. sh              | Runs cmd;cmd as a sub-shell                   |
| `{ }`            | csh                  | In-line expansions                            |
| `{cmd;cmd }`     | sh                   | Like (cmd;cmd ) without a subshell            |
| `>ofile`         | csh, sh              | Standard output                               |
| `>>ofile`        | csh, sh              | Append to standard output                     |
| `<ifile`         | csh, sh              | Standard Input                                |
| `<<word`         | csh, sh              | Read until word, substitute variables         |
| `<<\word`        | csh, sh              | Read until word, no substitution              |
| `<<-word`        | sh                   | Read until word, ignoring TABS                |
| `>>!file`        | csh                  | Append to file, ignore error if not there     |
| `>!file`         | csh                  | Output to new file, ignore error if not there |
| `>&file`         | csh                  | Send standard & error output to file          |
| `<&digit`        | sh                   | Switch Standard Input to file                 |
| `<&-`            | sh                   | Close Standard Input                          |
| `>&digit`        | sh                   | Switch Standard Output to file                |
| `>&-`            | sh                   | Close Standard Output                         |
| `digit1<&digit2` | sh                   | Connect digit2 to digit1                      |
| `digit<&-`       | sh                   | Close file digit                              |
| `digit2>&digit1` | sh                   | Connect digit2 to digit1                      |
| `digit>&-`       | sh                   | Close file digit                              |


# [process substitution](http://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html#Process-Substitution)

> [!TIP]
> Process substitution is a form of redirection where the input or output of a process (some sequence of commands) appear as a temporary file.
> reference:
> - [chapter 23. process substitution](https://tldp.org/LDP/abs/html/process-sub.html)
> Command list enclosed within parentheses
> ```bash
> >(command_list)
> <(command_list)
> ```
> Process substitution uses `/dev/fd/<n>` files to send the results of the process(es) within parentheses to another process. [1]

```bash
$ while read branch; do
    git fetch --all --force;
  done < <(git rev-parse --abbrev-ref HEAD)
```

```bash
$ echo >(true)
/dev/fd/63
$ echo <(true)
/dev/fd/63

$ echo >(true) <(true)
/dev/fd/63 /dev/fd/62

$ echo <(date)
/dev/fd/63
$ cat <(date)
Tue Dec 15 22:32:08 CST 2020
```

[named pipe](https://tldp.org/LDP/abs/html/extmisc.html#NAMEDPIPEREF) similar
```bash
$ wc <(cat /usr/share/dict/words)
 235886  235886 2493109 /dev/fd/63
$ cat /usr/share/dict/words | wc
 235886  235886 249310

$ wc <(grep script /usr/share/dict/words)
    176     176    5414 /dev/fd/63
$ grep script /usr/share/dict/words | wc
    176     176    5414

# https://superuser.com/a/1059790/112396
$ cat file | while read line; do ((count++)); done
$ while read line; do ((count++)); done < <(cat file)
```

get diff in two folders
```bash
$ diff <(ls ibook) <(ls mbook)
1c1,2
< book.json
---
> _book
> book.json
3a5
> node_modules

$ diff <(sleep 4; date) <(sleep 5; date)
1c1
< Tue Dec 15 22:48:31 CST 2020
---
> Tue Dec 15 22:48:32 CST 2020
```

## [example: run script without download](https://askubuntu.com/a/1086668)
```bash
$ bash < <(wget -qO - https://raw.githubusercontent.com/ubports/unity8-desktop-install-tools/master/install.sh)
```
- via curl
  ```bash
  $ python < <(curl -s https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/meminfo.py)
  ```
  - or
    ```bash
    $ curl -so - https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/meminfo.py | python
      ```

- [via wget](http://alvinalexander.com/linux/unix-linux-crontab-every-minute-hour-day-syntax/)
  ```bash
  $ python < <(wget -O - -q -t 1 https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/meminfo.py)
  ```
  - or
    ```bash
    $ wget -qO - https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/meminfo.py | python
    ```

- [or](https://github.com/giampaolo/psutil/blob/master/scripts/meminfo.py)
  ```bash
  $ python < <(curl -s https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/meminfo.py)
  MEMORY
  ------
  Total      :   16.0G
  Available  :    5.8G
  Percent    :    63.8
  Used       :    8.8G
  Free       :  204.5M
  Active     :    5.4G
  Inactive   :    5.6G
  Wired      :    3.4G

  SWAP
  ----
  Total      :    1.0G
  Used       :  269.2M
  Free       :  754.8M
  Percent    :    26.3
  Sin        :   38.3G
  Sout       :   63.9M
  ```

- or
  ```bash
  $ python < <(curl -s https://raw.githubusercontent.com/giampaolo/psutil/master/scripts/disk_usage.py)
  Device               Total     Used     Free  Use %      Type  Mount
  /dev/disk1s5        233.5G    10.6G    70.6G    13%      apfs  /
  /dev/disk1s1        233.5G   149.6G    70.6G    67%      apfs  /System/Volumes/Data
  /dev/disk1s4        233.5G     2.0G    70.6G     2%      apfs  /private/var/vm
  /Library/Input Methods/SogouInput.app   233.5G   149.1G    71.1G    67%    nullfs  /private/var/folders/s3/mg_f3cv54nn7y758j_t46zt40000gn/T/AppTranslocation/E29031DE-FE63-4ABC-BA3D-E99C743E57D2
  ```

## example: merge lines of file
> inspired by [here](https://apple.stackexchange.com/a/216657/254265) and [here](https://stackoverflow.com/q/31371672/2940319)

```bash
$ cat a
t1
t2
t3
t4
$ cat b
11
22
33
44

$ paste <(cat a) <(cat b)
t1	11
t2	22
t3	33
t4	44
```

- additional usage
  ```bash
  $ cat a | paste -d'\t' - - - -
  a	b	c	d
  e	f
  ```

  or
  ```bash
  $ cat a | paste -d, - -
  a,b
  c,d
  e,f
  ```

- `/dev/fd/63` is not a regular file
  ```bash
  $ more <( ls -l )
  /dev/fd/63 is not a regular file (use -f to see it)

  $ more -f <( ls -l )
  total 12
  -rw-r--r--  1 marslo staff 3457 Nov  2 15:53 README.md
  -rw-r--r--  1 marslo staff 4314 Nov  2 15:53 SUMMARY.md
  drwxr-xr-x  6 marslo staff  192 Oct 12 22:10 artifactory
  drwxr-xr-x  8 marslo staff  256 Sep 29 17:40 cheatsheet
  drwxr-xr-x 12 marslo staff  384 Oct 15 15:27 devops
  drwxr-xr-x  7 marslo staff  224 Sep 28 22:17 jenkins
  drwxr-xr-x 11 marslo staff  352 Sep 28 22:17 kubernetes
  drwxr-xr-x  8 marslo staff  256 Oct  9 19:15 linux
  drwxr-xr-x  8 marslo staff  256 Nov  2 15:51 osx
  drwxr-xr-x  6 marslo staff  192 Sep 28 22:17 programming
  drwxr-xr-x 45 marslo staff 1440 Nov  2 13:56 screenshot
  drwxr-xr-x 11 marslo staff  352 Oct 14 21:22 tools
  ```

### [nstalling tools via running random scripts from unknown sites](https://stackoverflow.com/a/12748630/2940319)
```bash
$ ( wget -O - pi.dk/3 || lynx -source pi.dk/3 || curl pi.dk/3/ || \
    fetch -o - http://pi.dk/3 ) > install.sh
```

## `strace`
> reference [What's the difference between <<, <<< and < < in bash?](https://askubuntu.com/a/678919)

# basic commands
## `du`
- top biggest directories under _[path]_
  ```bash
  $ du -a [path] | sort -n -r | head -n 5
  ```
- display the largest files according to human-readable format
  ```bash
  $ du -hs * | sort -rh | head -5
  ```
- display the largest folders/files including the sub-directories
  ```bash
  $ du -Sh | sort -rh | head -5
  ```
- biggest file sizes
  ```bash
  $ find -type f -exec du -Sh {} + | sort -rh | head -n 5

  # or
  $ find [PATH] -type f -printf "%s %p\n" | sort -rn | head -n 5
  ```

## sort
### [sort result via human-readable format](https://www.redhat.com/sysadmin/sort-du-output)
```bash
$ sudo du -ahx --max-depth=1 <path> | sort -k1 -rh
```

- [or](https://unix.stackexchange.com/a/197821/29178)
  ```bash
  $ du -sk * | sort -g | awk '{

      numBytes = $1 * 1024;
      numUnits = split("B K M G T P", unit);
      num = numBytes;
      iUnit = 0;

      while(num >= 1024 && iUnit + 1 < numUnits) {
          num = num / 1024;
          iUnit++;
      }

      $1 = sprintf( ((num == 0) ? "%6d%s " : "%6.1f%s "), num, unit[iUnit + 1]);
      print $0;

  }'

  # or in one-line
  $ du -sk * | sort -g | awk '{ numBytes = $1 * 1024; numUnits = split("B K M G T P", unit); num = numBytes; iUnit = 0; while(num >= 1024 && iUnit + 1 < numUnits) { num = num / 1024; iUnit++; } $1 = sprintf( ((num == 0) ? "%6d%s " : "%6.1f%s "), num, unit[iUnit + 1]); print $0; }'
  ```

- [or](https://unix.stackexchange.com/a/4701/29178)
  ```bash
  #! /usr/bin/env bash
  ducks () {
      du -cks -x | sort -n | while read size fname; do
          for unit in k M G T P E Z Y; do
              if [ $size -lt 1024 ]; then
                  echo -e "${size}${unit}\t${fname}"
                  break
              fi
              size=$((size/1024))
          done
      done
  }
  ducks > .ducks && tail .ducks
  ```

- [or](https://unix.stackexchange.com/a/27102/29178)
  ```bash
  $ du -k ./* |
       sort -nr |
       awk '{ split("KB,MB,GB",size,","); }
            { x = 1;while ($1 >= 1024) {$1 = $1 / 1024;x = x + 1} $1 = sprintf("%-4.2f%s", $1, size[x]); print $0; }'
  ```

## others
### `you have new mail`
- [remove](https://apple.stackexchange.com/a/28747/254265)
  ```bash
  $ mail
  ? delete *
  No applicable messages.
  ? q
  ```

# centos
## yum
### enable or disable repo
```bash
# enable
$ sudo yum config-manager --set-enabled PowerTools

# disable
$ sudo yum config-manager --set-disabled PowerTools
```

### `File "/usr/libexec/urlgrabber-ext-down", line 28`
- error
  ```bash
  File "/usr/libexec/urlgrabber-ext-down", line 28
  except OSError, e:
                ^
  ```

- solution
  ```bash
  $ sudo update-alternatives --remove python /usr/bin/python3
  $ realpath /usr/bin/python
  /usr/bin/python2.7
  ```

 - or
  ```bash
  $ sudo update-alternatives --config python

  There are 3 programs which provide 'python'.

    Selection    Command
  -----------------------------------------------
  *+ 1           /usr/bin/python3
     2           /usr/bin/python2.7
     3           /usr/bin/python2

  Enter to keep the current selection[+], or type selection number: 3
  ```

- [reason](https://www.linuxquestions.org/questions/linux-newbie-8/yum-upgrading-error-4175632414/)
  ```bash
  $ ls -l /usr/bin/python*
  lrwxrwxrwx 1 root root    24 Jul 10 02:29 /usr/bin/python -> /etc/alternatives/python
  lrwxrwxrwx 1 root root     9 Dec  6  2018 /usr/bin/python2 -> python2.7
  -rwxr-xr-x 1 root root  7216 Oct 30  2018 /usr/bin/python2.7
  lrwxrwxrwx 1 root root     9 Mar  7  2019 /usr/bin/python3 -> python3.4
  -rwxr-xr-x 2 root root 11392 Feb  5  2019 /usr/bin/python3.4
  -rwxr-xr-x 2 root root 11392 Feb  5  2019 /usr/bin/python3.4m

  $ ls -altrh /etc/alternatives/python
  lrwxrwxrwx 1 root root 16 Jul 10 02:29 /etc/alternatives/python -> /usr/bin/python3
  ```

- reference
  - [Yum install error file "/usr/bin/yum", line 30](http://www.programmersought.com/article/3242669414/)
  - [failed at yum update and how to fix it](http://wenhan.blog/2018/02/18/failed-at-yum-update-and-how-to-fix-it/)
  - [Upgraded Python, and now I can't run “yum upgrade”](https://unix.stackexchange.com/questions/524552/upgraded-python-and-now-i-cant-run-yum-upgrade)
  - [How to Find Out Top Directories and Files (Disk Space) in Linux](https://www.tecmint.com/find-top-large-directories-and-files-sizes-in-linux/)
