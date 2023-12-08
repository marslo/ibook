<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [rpm & dpkg & brew](#rpm--dpkg--brew)
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
    - [yum group](#yum-group)
    - [tools installation](#tools-installation)
    - [resolve conflict](#resolve-conflict)
    - [`File "/usr/libexec/urlgrabber-ext-down", line 28`](#file-usrlibexecurlgrabber-ext-down-line-28)
- [tricky](#tricky)
  - [unicode](#unicode)
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

# rpm & dpkg & brew
| RPM                                                           | DPKG                                                                   | BREW                                           |
|---------------------------------------------------------------|------------------------------------------------------------------------|------------------------------------------------|
| `rpm -qa`                                                     | `dpkg -l`                                                              | `brew list`                                    |
| `rpm -ql sofrwareanme`                                        | `dpkg -L name` <br> `dpkg --listfiles name` <br> `dpkg-qurery -L name` | `brew list name` <br> `brew ls --verbose name` |
| `rpm -qf /path/to/file` <br> `yum whatprovides /path/to/file` | `dpkg -S /path/to/file`                                                | `brew which-formula name`                      |
| `rpm -qip pkgfile.rpm` <br> `rpm -qlp pkgfile.rpm`            | `dpkg -l pkgfile.deb` <br> `dpkg -c pkgfile.deb`                       |                                                |
| `rpm -q name` <br> `rpm -qi name`                             | `dpkg -l name` <br> `dpkg -s name` <br> `dpkg -p name`                 | `brew info name`                               |
| `rpm -e name`                                                 | `dpkg -r name` <br> `dpkg -P name`                                     | `brew uninstall name`                          |



# prompt

{% hint style='tip' %}
> reference:
> - [* imarslo: color](../cheatsheet/colors.html)
> - [Bash/Prompt customization](https://wiki.archlinux.org/index.php/Bash/Prompt_customization)
> - [Colors using tput](https://wiki.bash-hackers.org/scripting/terminalcodes#colors_using_tput)
> - [What color codes can I use in my PS1 prompt?](https://unix.stackexchange.com/a/124409/29178)
> - [joseluisq/terminal-git-branch-name.md](https://gist.github.com/joseluisq/1e96c54fa4e1e5647940)
> - [How to show git branch in terminal and change terminal colours](https://www.stijit.com/engineering/show-git-branch-colours-terminal-mac.html)
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

{% hint style='tip' %}
> references:
> - [Yum install error file "/usr/bin/yum", line 30](http://www.programmersought.com/article/3242669414/)
> - [failed at yum update and how to fix it](http://wenhan.blog/2018/02/18/failed-at-yum-update-and-how-to-fix-it/)
> - [Upgraded Python, and now I can't run “yum upgrade”](https://unix.stackexchange.com/questions/524552/upgraded-python-and-now-i-cant-run-yum-upgrade)
> - [How to Find Out Top Directories and Files (Disk Space) in Linux](https://www.tecmint.com/find-top-large-directories-and-files-sizes-in-linux/)
> - [8.4. Configuring Yum and Yum Repositories](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-configuring_yum_and_yum_repositories)
>   - [8.4.2. Setting [repository] Options](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-setting_repository_options)
> - [repo vars](https://unix.stackexchange.com/q/624738/29178)
>   ```bash
>   $ cd /etc/dnf/vars; grep -H --color=none . *
>   contentdir:centos
>   infra:stock
>
>   # or
>   $ tail -f /var/log/dnf.log
>   ```
> - [moving from CentOS 8 to CentOS Stream 8](https://unix.stackexchange.com/a/704363/29178)
>   ```bash
>   $ sudo sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
>   $ sudo sed -i 's/mirrorlist/#mirrorlist/g'  /etc/yum.repos.d/CentOS-*
>   $ sudo dnf install centos-release-stream -y --allowerasing
>   $ sudo dnf swap centos-{linux,stream}-repos
>   $ sudo dnf distro-sync --best --allowerasing
>   $ sudo reboot
>   ```
> - [DNF Command Reference](https://dnf.readthedocs.io/en/latest/command_ref.html)
{% endhint %}

### enable or disable repo
```bash
# enable
$ sudo yum config-manager --set-enabled PowerTools

# disable
$ sudo yum config-manager --set-disabled PowerTools
```

### yum group

{% hint style='tip' %}
> references:
> - [2.5 Yum Groups](https://docs.oracle.com/cd/E37670_01/E37355/html/ol_about_yum_groups.html)
> - [How to install a group of packages with yum on Red Hat Enterprise Linux?](https://access.redhat.com/solutions/15815)
{% endhint %}

```bash
$ yum grouplist
$ yum group hidden
$ yum groupinfo <groupName>
$ yum groupinstall <groupName>
$ yum groupupdate <groupName>
$ yum groupremove <groupName>
```

### tools installation

> [!TIP|label:convert CentOS repo file in RHEL]
> ```bash
> $ sudo sed -i 's/\$contentdir/centos/' /etc/yum.repo.d/*.repo
> ```
> - [CentOS through a VM - no URLs in mirrorlist [closed]](https://stackoverflow.com/a/70930049/2940319)
>   ```bash
>   $ sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-Linux-*
>   $ sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-Linux-*
>   $
>   $ sudo dnf install centos-release-stream -y
>   $ sudo dnf swap centos-{linux,stream}-repos -y
>   $ sudo dnf distro-sync -y
>   ```

- epel

  > [!TIP|label:references:]
  > - [How To enable the EPEL Repository on RHEL 8 / CentOS 8 Linux](https://linuxconfig.org/redhat-8-epel-install-guide)
  > - [Extra Packages for Enterprise Linux (EPEL)](https://docs.fedoraproject.org/en-US/epel/)
  > - [404 error trying to install EPEL](https://access.redhat.com/discussions/5473561)
  > - [Index of /epel/8/Everything](https://mirrors.iu13.net/epel/8/Everything/)

  ```bash
  # install from url
  # centos 7
  $ sudo dnf [re]install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  # centos 8
  $ sudo dnf [re]install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

  # install via cmd
  $ sudo yum [re]install -y epel-release yum-utils
  ```

  - info
    ```bash
    $ cat /etc/yum.repos.d/epel.repo
    [epel]
    name=Extra Packages for Enterprise Linux 8 - $basearch
    # It is much more secure to use the metalink, but if you wish to use a local mirror
    # place its address here.
    #baseurl=https://download.example/pub/epel/8/Everything/$basearch
    metalink=https://mirrors.fedoraproject.org/metalink?repo=epel-8&arch=$basearch&infra=$infra&content=centos
    enabled=1
    gpgcheck=1
    countme=1
    gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-8

    $ dnf repoinfo epel
    Repo-id            : epel
    Repo-name          : Extra Packages for Enterprise Linux 8 - x86_64
    Repo-status        : enabled
    Repo-revision      : 1697078836
    Repo-updated       : Wed 11 Oct 2023 07:48:01 PM PDT
    Repo-pkgs          : 9,872
    Repo-available-pkgs: 9,870
    Repo-size          : 17 G
    Repo-metalink      : https://mirrors.fedoraproject.org/metalink?repo=epel-8&arch=x86_64&infra=$infra&content=centos
      Updated          : Thu 12 Oct 2023 05:16:56 PM PDT
    Repo-baseurl       : https://mirrors.iu13.net/epel/8/Everything/x86_64/ (153 more)
    Repo-expire        : 172,800 second(s) (last: Thu 12 Oct 2023 05:16:56 PM PDT)
    Repo-filename      : /etc/yum.repos.d/epel.repo
    Total packages: 9,872
    ```

  - [We can workaround this by replacing the $releasever variable with 8](https://access.redhat.com/discussions/5473561#comment-2119161)
    ```bash
    $ sudo sed -i 's/$releasever/8/g' /etc/yum.repos.d/epel*.repo

    # Same problem, RHEL 8.2 on Azure.
    $ sed -i.bak 's/\$releasever/8/g' /etc/yum.repos.d/epel*.repo
    ```

  - list only epel supported
    ```bash
    $ dnf --disablerepo="*" --enablerepo="epel" list available
    ```

- moreutils

  > [!NOTE|label:references:]
  > - [1820925 - moreutils from epel8 not installable](https://bugzilla.redhat.com/show_bug.cgi?id=1820925)
  > - [Has anyone figured out how to install `moreutils` on Centos8?](https://stackoverflow.com/a/68834383/2940319)
  > - [RPM resource perl-IPC-Run](https://rpmfind.net/linux/rpm2html/search.php?query=perl-IPC-Run)
  > - [or](https://unix.stackexchange.com/a/447936/29178)
  >   ```bash
  >   $ dnf config-manager --enable powertools
  >   ```

  ```bash
  $ dnf install epel-release -y
  $ dnf --enablerepo=powertools install moreutils -y
  ```

- check what's package repo can provide
  ```
  $ dnf repository-packages epel list
  ```


### resolve conflict

> [!NOTE|label:references:]
> - [How do I resolve a conflict reported by dnf?](https://forums.fedoraforum.org/showthread.php?311928-How-do-I-resolve-a-conflict-reported-by-dnf&s=8c3c741c88076f09c1a5187ea8c66849&p=1773908#post1773908)

- issue
  ```bash
  $ sudo dnf update --refresh
  CentOS Linux 8 - BaseOS                                                                 15 kB/s | 3.9 kB     00:00
  CentOS Linux 8 - Extras                                                                 14 kB/s | 1.5 kB     00:00
  Extra Packages for Enterprise Linux 8 - x86_64                                          50 kB/s |  22 kB     00:00
  jfrog-cli                                                                              3.9 kB/s | 1.4 kB     00:00
  mono-centos8-stable                                                                     20 kB/s | 2.9 kB     00:00
  Error:
   Problem 1: cannot install both authselect-1.2.2-3.el8.x86_64 and authselect-1.1-2.el8.x86_64
    - package authselect-compat-1.1-2.el8.x86_64 requires authselect(x86-64) = 1.1-2.el8, but none of the providers can be installed
    - cannot install the best update candidate for package authselect-1.1-2.el8.x86_64
    - problem with installed package authselect-compat-1.1-2.el8.x86_64
   Problem 2: cannot install both cups-libs-1:2.2.6-40.el8.x86_64 and cups-libs-1:2.2.6-28.el8.x86_64
    - package cups-client-1:2.2.6-28.el8.x86_64 requires cups-libs(x86-64) = 1:2.2.6-28.el8, but none of the providers can be installed
    - cannot install the best update candidate for package cups-libs-1:2.2.6-28.el8.x86_64
    - problem with installed package cups-client-1:2.2.6-28.el8.x86_64
   Problem 3: cannot install both dbus-daemon-1:1.12.8-14.el8.x86_64 and dbus-daemon-1:1.12.8-9.el8.x86_64
    - package dbus-x11-1:1.12.8-9.el8.x86_64 requires dbus-daemon = 1:1.12.8-9.el8, but none of the providers can be installed
    - cannot install the best update candidate for package dbus-daemon-1:1.12.8-9.el8.x86_64
    - problem with installed package dbus-x11-1:1.12.8-9.el8.x86_64
   Problem 4: cannot install both libgomp-8.5.0-4.el8_5.x86_64 and libgomp-8.3.1-4.5.el8.x86_64
    - package gcc-8.3.1-4.5.el8.x86_64 requires libgomp = 8.3.1-4.5.el8, but none of the providers can be installed
    - cannot install the best update candidate for package libgomp-8.3.1-4.5.el8.x86_64
    - problem with installed package gcc-8.3.1-4.5.el8.x86_64
   Problem 5: package libsolv-0.7.19-1.el8.x86_64 conflicts with rpm(x86-64) < 4.14.3 provided by rpm-4.14.2-26.el8_1.x86_64
    - package rpm-build-4.14.2-26.el8_1.x86_64 requires rpm = 4.14.2-26.el8_1, but none of the providers can be installed
    - cannot install the best update candidate for package libsolv-0.7.4-3.el8.x86_64
    - problem with installed package rpm-build-4.14.2-26.el8_1.x86_64
   Problem 6: cannot install both libstdc++-8.5.0-4.el8_5.x86_64 and libstdc++-8.3.1-4.5.el8.x86_64
    - package gcc-c++-8.3.1-4.5.el8.x86_64 requires libstdc++ = 8.3.1-4.5.el8, but none of the providers can be installed
    - cannot install the best update candidate for package libstdc++-8.3.1-4.5.el8.x86_64
    - problem with installed package gcc-c++-8.3.1-4.5.el8.x86_64
   Problem 7: cannot install both lua-libs-5.3.4-12.el8.x86_64 and lua-libs-5.3.4-11.el8.x86_64
    - package lua-5.3.4-11.el8.x86_64 requires lua-libs = 5.3.4-11.el8, but none of the providers can be installed
    - cannot install the best update candidate for package lua-libs-5.3.4-11.el8.x86_64
    - problem with installed package lua-5.3.4-11.el8.x86_64
   Problem 8: cannot install both newt-0.52.20-11.el8.x86_64 and newt-0.52.20-9.el8.x86_64
    - package python3-newt-0.52.20-9.el8.x86_64 requires newt(x86-64) = 0.52.20-9.el8, but none of the providers can be installed
    - cannot install the best update candidate for package newt-0.52.20-9.el8.x86_64
    - problem with installed package python3-newt-0.52.20-9.el8.x86_64
   Problem 9: cannot install both perl-libs-4:5.26.3-420.el8.x86_64 and perl-libs-4:5.26.3-416.el8.x86_64
    - package perl-devel-4:5.26.3-416.el8.x86_64 requires perl-libs(x86-64) = 4:5.26.3-416.el8, but none of the providers can be installed
    - cannot install the best update candidate for package perl-libs-4:5.26.3-416.el8.x86_64
    - problem with installed package perl-devel-4:5.26.3-416.el8.x86_64
   Problem 10: cannot install both platform-python-3.6.8-41.el8.x86_64 and platform-python-3.6.8-15.1.el8.x86_64
    - package platform-python-devel-3.6.8-15.1.el8.x86_64 requires platform-python = 3.6.8-15.1.el8, but none of the providers can be installed
    - cannot install the best update candidate for package platform-python-3.6.8-15.1.el8.x86_64
    - problem with installed package platform-python-devel-3.6.8-15.1.el8.x86_64
   Problem 11: cannot install both platform-python-pip-9.0.3-20.el8.noarch and platform-python-pip-9.0.3-15.el8.noarch
    - package python3-pip-9.0.3-15.el8.noarch requires platform-python-pip = 9.0.3-15.el8, but none of the providers can be installed
    - cannot install the best update candidate for package platform-python-pip-9.0.3-15.el8.noarch
    - problem with installed package python3-pip-9.0.3-15.el8.noarch
   Problem 12: cannot install both python3-gobject-base-3.28.3-2.el8.x86_64 and python3-gobject-base-3.28.3-1.el8.x86_64
    - package python3-gobject-3.28.3-1.el8.x86_64 requires python3-gobject-base(x86-64) = 3.28.3-1.el8, but none of the providers can be installed
    - cannot install the best update candidate for package python3-gobject-base-3.28.3-1.el8.x86_64
    - problem with installed package python3-gobject-3.28.3-1.el8.x86_64
   Problem 13: package platform-python-devel-3.6.8-15.1.el8.x86_64 requires python3-libs(x86-64) = 3.6.8-15.1.el8, but none of the providers can be installed
    - cannot install both python3-libs-3.6.8-41.el8.x86_64 and python3-libs-3.6.8-15.1.el8.x86_64
    - package python36-devel-3.6.8-2.module+el8.1.0+3334+5cb623d7.x86_64 requires platform-python-devel, but none of the providers can be installed
    - cannot install the best update candidate for package python3-libs-3.6.8-15.1.el8.x86_64
    - problem with installed package python36-devel-3.6.8-2.module+el8.1.0+3334+5cb623d7.x86_64
   Problem 14: cannot install both dbus-daemon-1:1.12.8-14.el8.x86_64 and dbus-daemon-1:1.12.8-9.el8.x86_64
    - package dbus-x11-1:1.12.8-9.el8.x86_64 requires dbus-daemon = 1:1.12.8-9.el8, but none of the providers can be installed
    - package dbus-1:1.12.8-14.el8.x86_64 requires dbus-daemon = 1:1.12.8-14.el8, but none of the providers can be installed
    - package ibus-1.5.19-4.el8.x86_64 requires dbus-x11, but none of the providers can be installed
    - cannot install the best update candidate for package dbus-1:1.12.8-9.el8.x86_64
    - problem with installed package ibus-1.5.19-4.el8.x86_64
   Problem 15: cannot install both perl-libs-4:5.26.3-420.el8.x86_64 and perl-libs-4:5.26.3-416.el8.x86_64
    - package perl-devel-4:5.26.3-416.el8.x86_64 requires perl-libs(x86-64) = 4:5.26.3-416.el8, but none of the providers can be installed
    - package perl-Errno-1.28-420.el8.x86_64 requires perl-libs(x86-64) = 4:5.26.3-420.el8, but none of the providers can be installed
    - package perl-ExtUtils-CBuilder-1:0.280230-2.el8.noarch requires perl-devel, but none of the providers can be installed
    - cannot install the best update candidate for package perl-Errno-1.28-416.el8.x86_64
    - problem with installed package perl-ExtUtils-CBuilder-1:0.280230-2.el8.noarch
   Problem 16: cannot install both perl-libs-4:5.26.3-420.el8.x86_64 and perl-libs-4:5.26.3-416.el8.x86_64
    - package perl-devel-4:5.26.3-416.el8.x86_64 requires perl-libs(x86-64) = 4:5.26.3-416.el8, but none of the providers can be installed
    - package perl-interpreter-4:5.26.3-420.el8.x86_64 requires perl-libs(x86-64) = 4:5.26.3-420.el8, but none of the providers can be installed
    - package perl-ExtUtils-MakeMaker-1:7.34-1.el8.noarch requires perl-devel, but none of the providers can be installed
    - cannot install the best update candidate for package perl-interpreter-4:5.26.3-416.el8.x86_64
    - problem with installed package perl-ExtUtils-MakeMaker-1:7.34-1.el8.noarch
   Problem 17: package dbus-x11-1:1.12.8-9.el8.x86_64 requires dbus-daemon = 1:1.12.8-9.el8, but none of the providers can be installed
    - package dbus-daemon-1:1.12.8-9.el8.x86_64 requires dbus-common = 1:1.12.8-9.el8, but none of the providers can be installed
    - package ibus-1.5.19-4.el8.x86_64 requires dbus-x11, but none of the providers can be installed
    - cannot install both dbus-common-1:1.12.8-14.el8.noarch and dbus-common-1:1.12.8-9.el8.noarch
    - package ibus-libpinyin-1.10.0-1.el8.x86_64 requires ibus >= 1.5.11, but none of the providers can be installed
    - cannot install the best update candidate for package dbus-common-1:1.12.8-9.el8.noarch
    - problem with installed package ibus-libpinyin-1.10.0-1.el8.x86_64
   Problem 18: package dbus-x11-1:1.12.8-9.el8.x86_64 requires dbus-daemon = 1:1.12.8-9.el8, but none of the providers can be installed
    - package dbus-daemon-1:1.12.8-9.el8.x86_64 requires dbus-libs(x86-64) = 1:1.12.8-9.el8, but none of the providers can be installed
    - package ibus-1.5.19-4.el8.x86_64 requires dbus-x11, but none of the providers can be installed
    - cannot install both dbus-libs-1:1.12.8-14.el8.x86_64 and dbus-libs-1:1.12.8-9.el8.x86_64
    - package ibus-setup-1.5.19-4.el8.noarch requires ibus = 1.5.19-4.el8, but none of the providers can be installed
    - cannot install the best update candidate for package dbus-libs-1:1.12.8-9.el8.x86_64
    - problem with installed package ibus-setup-1.5.19-4.el8.noarch
  (try to add '--allowerasing' to command line to replace conflicting packages or '--skip-broken' to skip uninstallable packages or '--nobest' to use not only best candidate packages)
  ```

- solution
  ```bash
  $ sudo dnf repolist
  repo id                                       repo name
  baseos                                        CentOS Linux 8 - BaseOS
  epel                                          Extra Packages for Enterprise Linux 8 - x86_64
  extras                                        CentOS Linux 8 - Extras
  jfrog-cli                                     jfrog-cli
  mono-centos8-stable                           mono-centos8-stable
  $ sudo dnf update --refresh --allowerasing
  $ sudo dnf distro-sync -y

  # or
  $ sudo dnf remove $(dnf repoquery --duplicated --latest-limit -1 -q)

  # show duplicate packages
  $ dnf repoquery --duplicated
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


## search manual page
- `whatis -r <string>`
- `apropos -r <string>`
