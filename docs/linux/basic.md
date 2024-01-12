<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [prompts](#prompts)
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
    - [crontab](#crontab)
- [tricky](#tricky)
  - [unicode](#unicode)
  - [useful functions](#useful-functions)
  - [search manual page](#search-manual-page)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference
> - [The Bash Shell Startup Files](http://www.linuxfromscratch.org/blfs/view/svn/postlfs/profile.html)
> - [Advanced Bash-Scripting Guide](https://tldp.org/LDP/abs/html/index.html)
> - download pdf from [here](https://tldp.org/LDP/abs/abs-guide.pdf) or [here](http://www.linux-france.org/lug/ploug/doc/abs-guide.pdf)
> - [Perform tab-completion for aliases in Bash](https://brbsix.github.io/2015/11/23/perform-tab-completion-for-aliases-in-bash/)
> - [dot_file: .bash_aliases](https://github.com/agilesteel/.dotfiles/blob/master/stow/bash/.bash_aliases)
> - [killbutmakeitlooklikeanaccident.sh](https://gist.github.com/moyix/95ca9a7a26a639b2322c36c7411dc3be)
{% endhint %}

# prompts

{% hint style='tip' %}
> reference:
> - [* imarslo: color](../cheatsheet/colors.html)
> - [Bash/Prompt customization](https://wiki.archlinux.org/index.php/Bash/Prompt_customization)
> - [Colors using tput](https://wiki.bash-hackers.org/scripting/terminalcodes#colors_using_tput)
> - [What color codes can I use in my PS1 prompt?](https://unix.stackexchange.com/a/124409/29178)
> - [joseluisq/terminal-git-branch-name.md](https://gist.github.com/joseluisq/1e96c54fa4e1e5647940)
> - [How to show git branch in terminal and change terminal colours](https://www.stijit.com/engineering/show-git-branch-colours-terminal-mac.html)
> - [8 Useful and Interesting Bash Prompts](https://www.maketecheasier.com/8-useful-and-interesting-bash-prompts/)
> - [* 2.5. Bash Prompt Escape Sequences](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html)
> - [* My Ultimate PowerShell prompt with Oh My Posh and the Windows Terminal](https://www.hanselman.com/blog/my-ultimate-powershell-prompt-with-oh-my-posh-and-the-windows-terminal)
{% endhint %}

```bash
PS1="\[$(tput setaf 0) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 1) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 2) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 3) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 4) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 5) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 6) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 7) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 8) \]my prompt\[$(tput sgr0)\]> "
PS1="\[$(tput setaf 9) \]my prompt\[$(tput sgr0)\]> "
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

|     Character    | Where                | Meaning                                       |
|:----------------:|----------------------|-----------------------------------------------|
|    `<RETURN>`    | csh, sh              | Execute command                               |
|        `#`       | csh, sh, ASCII files | Start a comment                               |
|     `<SPACE>`    | csh, sh              | Argument separator                            |
|  <code>`</code>  | csh, sh              | Command substitution                          |
|        `"`       | csh, sh              | Weak Quotes                                   |
|        `'`       | csh, sh              | Strong Quotes                                 |
|        `\`       | csh, sh              | Single Character Quote                        |
|    `variable`    | sh, csh              | Variable                                      |
|    `variable`    | csh, sh              | Same as variable                              |
|        `\`       | csh, sh              | Pipe character                                |
|        `^`       | sh                   | Pipe Character                                |
|        `&`       | csh, sh              | Run program in background                     |
|        `?`       | csh, sh              | Match one character                           |
|        `*`       | csh, sh              | Match any number of characters                |
|        `;`       | csh, sh              | Command separator                             |
|       `;;`       | sh                   | End of Case statement                         |
|        `~`       | csh                  | Home Directory                                |
|      `~user`     | csh                  | User's Home Directory                         |
|        `!`       | csh                  | History of Commands                           |
|        `-`       | Programs             | Start of optional argument                    |
|       `$#`       | csh, sh              | Number of arguments to script                 |
|       `$*`       | csh, sh              | Arguments to script                           |
|       `$@`       | sh                   | Original arguments to script                  |
|       `$-`       | sh                   | Flags passed to shell                         |
|       `$?`       | sh                   | Status of previous command                    |
|       `$$`       | sh                   | Process identification number                 |
|       `$!`       | sh                   | PID of last background job                    |
|       `&&`       | sh                   | Short-circuit AND                             |
|         `        |                      | `                                             | sh | Short-circuit OR |
|        `.`       | csh, sh              | Typ. filename extension                       |
|        `.`       | sh                   | Source a file and execute as command          |
|        `:`       | sh                   | Nothing command                               |
|        `:`       | sh                   | Separates Values in environment variables     |
|        `:`       | csh                  | Variable modifier                             |
|    `Character`   | Where                | Meaning                                       |
|       `[ ]`      | csh, sh              | Match range of characters                     |
|       `[ ]`      | sh                   | Test                                          |
|      `%job`      | csh                  | Identifies job Number                         |
|    `(cmd;cmd)`   | csh. sh              | Runs cmd;cmd as a sub-shell                   |
|       `{ }`      | csh                  | In-line expansions                            |
|   `{cmd;cmd }`   | sh                   | Like (cmd;cmd ) without a subshell            |
|     `>ofile`     | csh, sh              | Standard output                               |
|     `>>ofile`    | csh, sh              | Append to standard output                     |
|     `<ifile`     | csh, sh              | Standard Input                                |
|     `<<word`     | csh, sh              | Read until word, substitute variables         |
|     `<<\word`    | csh, sh              | Read until word, no substitution              |
|     `<<-word`    | sh                   | Read until word, ignoring TABS                |
|     `>>!file`    | csh                  | Append to file, ignore error if not there     |
|     `>!file`     | csh                  | Output to new file, ignore error if not there |
|     `>&file`     | csh                  | Send standard & error output to file          |
|     `<&digit`    | sh                   | Switch Standard Input to file                 |
|       `<&-`      | sh                   | Close Standard Input                          |
|     `>&digit`    | sh                   | Switch Standard Output to file                |
|       `>&-`      | sh                   | Close Standard Output                         |
| `digit1<&digit2` | sh                   | Connect digit2 to digit1                      |
|    `digit<&-`    | sh                   | Close file digit                              |
| `digit2>&digit1` | sh                   | Connect digit2 to digit1                      |
|    `digit>&-`    | sh                   | Close file digit                              |


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
t1  11
t2  22
t3  33
t4  44
```

- additional usage
  ```bash
  $ cat a | paste -d'\t' - - - -
  a b c d
  e f
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
> [!NOTE|label:reference]
> - [What's the difference between <<, <<< and < < in bash?](https://askubuntu.com/a/678919)

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

  - or
    ```bash
    $ mail -N
    ? d *
    ? quit
    ```

### crontab

> [!NOTE|label:references:]
> - [Linux / UNIX Crontab File Location](https://www.cyberciti.biz/faq/where-is-the-crontab-file/)
> - [* cron.help](https://cron.help/)
>   - [Cron Examples](https://crontab.guru/examples.html)
> - [Cron Jobs: The Complete Guide for 2023](https://cronitor.io/guides/cron-jobs?utm_source=crontabguru&utm_campaign=cron_reference)

- format
  ```bash
  *    *    *    *    *   /home/user/bin/somecommand.sh
  |    |    |    |    |            |
  |    |    |    |    |    Command or Script to execute
  |    |    |    |    |
  |    |    |    | Day of week(0-6 | Sun-Sat)
  |    |    |    |
  |    |    |  Month(1-12)
  |    |    |
  |    |  Day of Month(1-31)
  |    |
  |   Hour(0-23)
  |
  Min(0-59)
  ```

- tips
  - every odd hours
    ```bash
    0 1-23/2 * * *
    ```
  - every even hours
    ```bash
    0 */2 * * *
    ```

- sample
  - delete *.DS_*
    ```bash
    15 */2 * * 1-5 /usr/local/bin/fd --type f --hidden --follow --unrestricted --color=never --exclude .Trash --glob '*\.DS_*' $HOME | xargs -r rm
    # or
    30 */2 * * 1-5 /usr/local/bin/fd -Iu --glob '*\.DS_*' $HOME | xargs -r rm
    # or
    30 */2 * * 1-5 /usr/local/bin/rg --hidden --smart-case --color=never --files "$HOME" -g '*\.DS_*' | xargs -r rm
    ```

  - flush disk cache
    ```bash
    0 * * * * /usr/sbin/purge
    ```

  - flush DNS
    ```bash
    0 1-23/6 * * * /usr/bin/killall -HUP mDNSResponder
    ```

- localtion
  - macos
    ```bash
    $ sudo ls -Altrh /usr/lib/cron/tabs/<USERNAME>
    ```

  - freebsd/openbsd/netbsd
    ```bash
    $ sudo ls -Altrh /var/cron/tabs/<USERNAME>
    ```

  - centos/rhel/fedora/scientific/rocky/alma linux
    ```bash
    $ sudo ls -Altrh /var/spool/cron/<USERNAME>
    ```

  - debian/ubuntu/mint linux
    ```bash
    $ sudo ls -Altrh /var/spool/cron/crontabs/<USERNAME>
    ```

  - p-ux unix
    ```bash
    $ sudo ls -Altrh /var/spool/cron/crontabs/<USERNAME>
    ```

  - ibm aix unix
    ```bash
    $ sudo ls -Altrh /var/spool/cron/<USERNAME>
    ```


# tricky

{% hint style='tip' %}
> references:
> - [Searching the manual pages](https://help.ubuntu.com/community/UsingTheTerminal#Searching_the_manual_pages)
> - [How To Readline](https://help.ubuntu.com/community/HowToReadline)
> - [Commandline Howto](https://help.ubuntu.com/community/CommandlineHowto)
> - [Advanced Commandline Howto](https://help.ubuntu.com/community/AdvancedCommandlineHowto)
{% endhint %}

## unicode

{% hint style='tip' %}
> references:
> - [How do you echo a 4-digit Unicode character in Bash?](https://stackoverflow.com/q/602912/2940319)
> - [centos locale utf-8](https://unix.stackexchange.com/a/25237/29178)
> - [How can I make iconv replace the input file with the converted output?](https://unix.stackexchange.com/q/10241/29178)
>
>
> Your description is vague. Either your terminal does not support Unicode, or you're editing a file that's in latin1 (= iso-8859-1).
> On a bash or zsh shell, with `LC_CTYPE=en_US.UTF-8`, run `echo $'\xc3a9'`. If you see `é`, your terminal supports UTF-8. If you see `Ã©`, your terminal is showing latin1.
{% endhint %}

> ```bash
> $ echo $'\xc3a9'
> a9
> ```

```bash
$ echo $'\xe2\x98\xa0'
☠
$ echo $'(U+2620) \U02620' | xxd
00000000: 2855 2b32 3632 3029 20e2 98a0 0a         (U+2620) ....

# test
for (( i=0x2500; i<0x2600; i++ )); do
    UnicodePointToUtf8 $i
    [ "$(( i+1 & 0x1f ))" != 0 ] || echo ""
done
─━│┃┄┅┆┇┈┉┊┋┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟
┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿
╀╁╂╃╄╅╆╇╈╉╊╋╌╍╎╏═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟
╠╡╢╣╤╥╦╧╨╩╪╫╬╭╮╯╰╱╲╳╴╵╶╷╸╹╺╻╼╽╾╿
▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟
■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿
◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟
◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿

## test harness
for (( i=0x2500; i<0x2600; i++ )); do
    unichr $i
done
─━│┃┄┅┆┇┈┉┊┋┌┍┎┏┐┑┒┓└┕┖┗┘┙┚┛├┝┞┟┠┡┢┣┤┥┦┧┨┩┪┫┬┭┮┯┰┱┲┳┴┵┶┷┸┹┺┻┼┽┾┿╀╁╂╃╄╅╆╇╈╉╊╋╌╍╎╏═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬╭╮╯╰╱╲╳╴╵╶╷╸╹╺╻╼╽╾╿▀▁▂▃▄▅▆▇█▉▊▋▌▍▎▏▐░▒▓▔▕▖▗▘▙▚▛▜▝▞▟■□▢▣▤▥▦▧▨▩▪▫▬▭▮▯▰▱▲△▴▵▶▷▸▹►▻▼▽▾▿◀◁◂◃◄◅◆◇◈◉◊○◌◍◎●◐◑◒◓◔◕◖◗◘◙◚◛◜◝◞◟◠◡◢◣◤◥◦◧◨◩◪◫◬◭◮◯◰◱◲◳◴◵◶◷◸◹◺◻◼◽◾◿

# https://stackoverflow.com/a/55639328/2940319
$ echo -e "\U1F304"
�
$ echo -e "�" | hexdump -C
00000000  f0 9f 8c 84 0a                                    |.....|
00000005
```

- [unicode to utf8](https://stackoverflow.com/a/59040037/2940319)
  ```bash
  UnicodePointToUtf8()
  {
      local x="$1"               # ok if '0x2620'
      x=${x/\\u/0x}              # '\u2620' -> '0x2620'
      x=${x/U+/0x}; x=${x/u+/0x} # 'U-2620' -> '0x2620'
      x=$((x)) # from hex to decimal
      local y=$x n=0
      [ $x -ge 0 ] || return 1
      while [ $y -gt 0 ]; do y=$((y>>1)); n=$((n+1)); done
      if [ $n -le 7 ]; then       # 7
          y=$x
      elif [ $n -le 11 ]; then    # 5+6
          y=" $(( ((x>> 6)&0x1F)+0xC0 )) \
              $(( (x&0x3F)+0x80 ))"
      elif [ $n -le 16 ]; then    # 4+6+6
          y=" $(( ((x>>12)&0x0F)+0xE0 )) \
              $(( ((x>> 6)&0x3F)+0x80 )) \
              $(( (x&0x3F)+0x80 ))"
      else                        # 3+6+6+6
          y=" $(( ((x>>18)&0x07)+0xF0 )) \
              $(( ((x>>12)&0x3F)+0x80 )) \
              $(( ((x>> 6)&0x3F)+0x80 )) \
              $(( (x&0x3F)+0x80 ))"
      fi
      printf -v y '\\x%x' $y
      echo -n -e $y
  }
  ```

- [unichr](https://stackoverflow.com/a/16509364/2940319)
  ```bash
  fast_chr() {
      local __octal
      local __char
      printf -v __octal '%03o' $1
      printf -v __char \\$__octal
      REPLY=$__char
  }

  function unichr {
      local c=$1  # Ordinal of char
      local l=0   # Byte ctr
      local o=63  # Ceiling
      local p=128 # Accum. bits
      local s=''  # Output string

      (( c < 0x80 )) && { fast_chr "$c"; echo -n "$REPLY"; return; }

      while (( c > o )); do
          fast_chr $(( t = 0x80 | c & 0x3f ))
          s="$REPLY$s"
          (( c >>= 6, l++, p += o+1, o>>=1 ))
      done

      fast_chr $(( t = p | c ))
      echo -n "$REPLY$s"
  }
  ```

## useful functions
- [universal extract](https://github.com/nemausus/dotfiles/blob/master/bashrc#L113)
  ```bash
  function extract () {
    case $1 in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz) tar xzf "$1" ;;
      *.tar.xz) tar Jxvf "$1" ;;
      *.tar.Z) tar xzf "$1" ;;
      *.tar) tar xf "$1" ;;
      *.taz) tar xzf "$1" ;;
      *.tb2) tar xjf "$1" ;;
      *.tbz) tar xjf "$1" ;;
      *.tbz2) tar xjf "$1" ;;
      *.tgz) tar xzf "$1" ;;
      *.txz) tar Jxvf "$1" ;;
      *.zip) unzip "$1" ;;
      *.gz) gunzip "$1" ;;
      *) echo "'$1' cannot be extracted" ;;
    esac
  }
  ```
## search manual page
- `whatis -r <string>`
- `apropos -r <string>`
