<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [redirect](#redirect)
  - [show stdout but redirect all to file](#show-stdout-but-redirect-all-to-file)
- [time & date](#time--date)
  - [show date with timezone](#show-date-with-timezone)
  - [show cal](#show-cal)
  - [synchronize date and time with another server over ssh](#synchronize-date-and-time-with-another-server-over-ssh)
- [download and extract](#download-and-extract)
  - [check file without extract](#check-file-without-extract)
  - [extract `jar`](#extract-jar)
  - [recursive download](#recursive-download)
- [compress](#compress)
  - [zip package with dot-file](#zip-package-with-dot-file)
  - [remove dot-file without `skipping '..' '.'` issue](#remove-dot-file-without-skipping---issue)
- [echo 256 colors](#echo-256-colors)
- [commands](#commands)
  - [`ls`](#ls)
  - [PWD's secrets](#pwds-secrets)
  - [list the command startsWith](#list-the-command-startswith)
  - [fuzzy find for commands](#fuzzy-find-for-commands)
- [batch commands](#batch-commands)
  - [batch rename](#batch-rename)
  - [xargs rename](#xargs-rename)
  - [batch move](#batch-move)
  - [batch copy](#batch-copy)
  - [copy single file to multipule folders](#copy-single-file-to-multipule-folders)
- [ldapsearch](#ldapsearch)
  - [search specific user](#search-specific-user)
  - [filter `DN` field only](#filter-dn-field-only)
  - [filter `SAMAccountName`, `uid` and `uidNumber` only](#filter-samaccountname-uid-and-uidnumber-only)
  - [filter particular group](#filter-particular-group)
- [others](#others)
  - [directory diff](#directory-diff)
  - [show some command periodically](#show-some-command-periodically)
  - [clear](#clear)
  - [use less as tail -f](#use-less-as-tail--f)
  - [netcat & nmap-ncat](#netcat--nmap-ncat)
  - [alternatives & update-alternatives](#alternatives--update-alternatives)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## redirect

### show stdout but redirect all to file

> [!NOTE]
> references:
> - [redirect overview](https://askubuntu.com/a/731237)
>   ```bash
>             || visible in terminal ||   visible in file   || existing
>     Syntax  ||  StdOut  |  StdErr  ||  StdOut  |  StdErr  ||   file
>   ==========++==========+==========++==========+==========++===========
>       >     ||    no    |   yes    ||   yes    |    no    || overwrite
>       >>    ||    no    |   yes    ||   yes    |    no    ||  append
>             ||          |          ||          |          ||
>      2>     ||   yes    |    no    ||    no    |   yes    || overwrite
>      2>>    ||   yes    |    no    ||    no    |   yes    ||  append
>             ||          |          ||          |          ||
>      &>     ||    no    |    no    ||   yes    |   yes    || overwrite
>      &>>    ||    no    |    no    ||   yes    |   yes    ||  append
>             ||          |          ||          |          ||
>    | tee    ||   yes    |   yes    ||   yes    |    no    || overwrite
>    | tee -a ||   yes    |   yes    ||   yes    |    no    ||  append
>             ||          |          ||          |          ||
>    n.e. (*) ||   yes    |   yes    ||    no    |   yes    || overwrite
>    n.e. (*) ||   yes    |   yes    ||    no    |   yes    ||  append
>             ||          |          ||          |          ||
>   |& tee    ||   yes    |   yes    ||   yes    |   yes    || overwrite
>   |& tee -a ||   yes    |   yes    ||   yes    |   yes    ||  append
>   ```
> - [Redirect terminal output to file](https://askubuntu.com/a/1046032/92979)
> - [Bash: Redirect stdout and stderr](https://csatlas.com/bash-redirect-stdout-stderr/)
> - [show Command Output Redirection.pdf](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/fundamentals/configuration/xe-3se/cat3650/fundamentals-xe-3se-3650-book/cf-shw-cmd-out-redirect.pdf)
> - [3.6 Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html)

```bash
$ bash -c "echo a;bahs;echo b;bhas" >>file 2> >( tee -a file >&2 )
bash: line 1: bahs: command not found
bash: line 1: bhas: command not found

$ cat file
a
bash: line 1: bahs: command not found
b
bash: line 1: bhas: command not found
```

- or
  ```bash
  $ bash -c "set -e; echo a;bahs;echo b;bhas" >>cmd.out 2> >( tee -a cmd.out >&2 )
  bash: line 1: bahs: command not found

  $ cat cmd.out
  a
  bash: line 1: bahs: command not found
  ```

## time & date
### [show date with timezone](https://unix.stackexchange.com/a/48104/29178)
```bash
# with quotes
$ TZ=':Asia/Shanghai' date

# or without quotes
$ TZ=America/Los_Angeles date
```

### show cal
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

### synchronize date and time with another server over ssh

> [!NOTE]
> inspired from
> - [commandlinefu.com](http://www.commandlinefu.com/commands/view/9153/synchronize-date-and-time-with-a-server-over-ssh))

```bash
$ date --set="$(ssh [username]@[sshserver] date)"
```

## download and extract
- `*.gz`
  ```bash
  $ wget -O - http://example.com/a.gz | tar xz
  ```

- `*.zip`
  ```bash
  $ curl -fsSL https://services.gradle.org/distributions/gradle-4.7-all.zip | bsdtar xzf - -C <EXTRACT_PATH>
  ```
  - with zip password
    ```bash
    $ curl -fsSL \
           -u<user>:<passwd> \
           https://path/to/file.zip \
           | bsdtar -xzf- --passphrase <PASSWD_OF_ZIP> - -C <EXTRACT_PATH>
    ```

- `*.tar.gz`
  ```bash
  $ curl -fsSL https://path/to/file.tar.gz | tar xzf - -C <EXTRACT_PATH>
  ```
  - example
    ```bash
    $ curl -fsSL \
           -j \
           -k \
           -L \
           -H "Cookie: oraclelicense=accept-securebackup-cookie" \
           http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.tar.gz \
           | tar xzf - -C '/opt/java'
    ```

### check file without extract
```bash
$ tar -Oxvf myfile.tgz path/to/my.sh | less
```

### extract `jar`
```bash
$ unzip <jar-name>.jar -d <target-folder>
```

- Delete files from JAR without unzip
  ```bash
  $ zip -d <jar-name>.jar <path/to/file.txt>
  ```

### [recursive download](https://www.gnu.org/software/wget/manual/html_node/Recursive-Download.html#Recursive-Download)

> [!TIP]
> references:
> - [download a directory and subdirectories using wget](https://www.baeldung.com/linux/wget-download-directory-subdirectories)
> - [wget(1) - Linux man page](https://linux.die.net/man/1/wget)
>
> params shortcuts :
>
> | SHORT PARAMS | LONG PARAMS             |
> |:------------:|-------------------------|
> |     `-r`     | `--recursive`           |
> |     `-m`     | `--mirror`              |
> |     `-l`     | `--level`               |
> |     `-k`     | `--convert-links`       |
> |     `-K`     | `--backup-converted`    |
> |     `-P`     | `--directory-prefix`    |
> |     `-nv`    | `--no-verbose`          |
> |     `-nc`    | `--no-clobber`          |
> |     `-nd`    | `--no-directories`      |
> |     `-nH`    | `--no-host-directories` |
> |     `-np`    | `--no-parent`           |
> |     `-x`     | `--force-directories`   |
> |     `-b`     | `--background`          |
> |     `-v`     | `--verbose`             |
> |     `-p`     | `--page-requisites`     |

```bash
$ wget --recursive                       \     # -r
       --user=admin                      \
       --password=admin                  \     # --ask-password
       --auth-no-challenge               \     # optional
       --no-host-directories             \     # -nH
       --no-parent                       \     # -np
       --reject '*.html*'                \
       --directory-prefix=./             \     # -P
       --include-directories=local-dir   \     # -I
  http://example.com/remote-dir

# or
$ wget --recursive                                   \    # -r
       --no-parent                                   \    # -np : will not crawl links in folders above the base of the URL
       --convert-links                               \    # -k  : convert links with the domain name to relative and uncrawled to absolute
       --random-wait --wait 3 --no-http-keep-alive   \    #       do not get banned
       --no-host-directories                         \    # -nH : do not create folders with the domain name
       --execute robots=off --user-agent=Mozilla/5.0 \    #       I AM A HUMAN!!!
       --level=inf --accept '*'                      \    # -l  : do not limit to 5 levels or common file formats
       --reject="index.html*"                        \    #       use this option if you need an exact mirror
       --cut-dirs=0                                  \    #       replace 0 with the number of folders in the path, 0 for the whole domain
  $URL
```

- mirror whole website
  ```bash
  $ wget -m https://www.baeldung.com/
  ```

#### download directly
```bash
$ wget -r -np -nH --cut-dirs=1 https://www.baeldung.com/linux
# or
$ wget -r --no-parent --no-host-directories --cut-dirs=1 https://www.baeldung.com/linux
```

- with level
  ```bash
  $ wget -r -np -l 2 https://www.baeldung.com/linux/
  # or
  $ wget -r --no-parent --level=2 https://www.baeldung.com/linux/
  ```

- with credentials
  - `.wgetrc`
    ```bash
    $ cat ~/.wgetrc
    user=admin
    password=admin
    ```
  - from cmd
    ```bash
    $ wget --user=admin --password=admin

    # or
    $ wget --user=admin --ask-password
    Password for user 'admin': admin
    ```
  - ignore credentials
    ```bash
    $ wget --no-check-certificate
    ```

- converting links for local viewing
  ```bash
  $ wget -r --no-parent --convert-links https://www.baeldung.com/linux/category/web
  ```

- switching off robot exclusion
  ```bash
  $ wget -r --level=1 --no-parent --convert-links -e robots=off -U="Mozilla"
  ```

## compress
### zip package with dot-file
- `.[^.]*`
  ```bash
  $ zip name.zip * .[^.]*'
  ```

- `shopt -s dotglob`
  ```bash
  $ shopt -s dotglob
  $ zip name.zip *
  ```

- `.`
  ```bash
  $ zip -r name.zip .
  ```

### remove dot-file without `skipping '..' '.'` issue
- [`shopt -s dotglob`](https://unix.stackexchange.com/a/289393/29179)
    ```bash
    $ shopt -s dotglob
    $ rm [-rf] *
    ```
  - using `shopt -u dotglob` to turn `dotglob` off

- `.[^.]*`
    ```bash
    $ rm [-rf] .[^.]*
    ```

- [`.[!.]*`](https://unix.stackexchange.com/a/310951/29178)
    ```bash
    $ rm [-rf] .[!.]*
    ```

- [`.??*`](https://unix.stackexchange.com/a/310763/29178)
    ```bash
    $ rm [-rf] .??*
    ```

## echo 256 colors

> [!TIP]
> see also:
> - [imarslo : cheatsheet/colors](colors.html)
> - [imarslo : cheatsheet/tricky.html#highlight-output](tricky.html#highlight-output)

```bash
$ for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"
# or
$ yes "$(seq 1 255)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .01; done
```

## commands

### `ls`
- list numeric names

  > [!NOTE|label:references:]
  > - [How can I get files with numeric names using ls command?](https://superuser.com/q/716001/112396)

  ```bash
  $ ls git-[[:digit:]]*.png
  git-0.png  git-1.png  git-2.png  git-3.png  git-4.png  git-5.png

  $ ls git-+([0-9])*.png
  git-0.png  git-1.png  git-2.png  git-3.png  git-4.png  git-5.png
  ```

### PWD's secrets
```bash
$ l | grep bc
lrwxrwxrwx 1 marslo marslo   37 Mar  4 00:25 bc -> /home/marslo/Tools/Git/BrowserConfig//
$ cd bc/
$ pwd -L
/home/marslo/bc
$ pwd -P
/home/marslo/Tools/Git/BrowserConfig
```

### list the command startsWith
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

### fuzzy find for commands
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

## batch commands
### batch rename
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

### xargs rename
```bash
$ shopt -s extglob
$ ls git-+([0-9])*.png
git-0.png  git-1.png  git-2.png  git-3.png  git-4.png  git-5.png

$ ls --color=none git-+([0-9])*.png | xargs rename -v 's/git-/git-for-windows-/'
'git-0.png' renamed to 'git-for-windows-0.png'
'git-1.png' renamed to 'git-for-windows-1.png'
'git-2.png' renamed to 'git-for-windows-2.png'
'git-3.png' renamed to 'git-for-windows-3.png'
'git-4.png' renamed to 'git-for-windows-4.png'
'git-5.png' renamed to 'git-for-windows-5.png'
```

### batch move

{% hint style='tip' %}
> `-I replace-str`
{% endhint %}

```bash
$ mkdir backup-folder && ls | grep -Ze ".*rar" | xargs -d '\n' -I {} mv {} backup-folder
```

### batch copy
> reference:
> - [Hack 22. Xargs Command Examples](https://linux.101hacks.com/linux-commands/xargs-command-examples/)

```bash
$ ls -1 a/b/* 11 12 | xargs cp -t copy-target-folder/
```

### copy single file to multipule folders
```bash
$ echo dir1 dir2 dir3 | xargs -n 1 cp file1

# or
$ echo dir{1..10} | xargs -n 1 cp file1
```

## ldapsearch

> [!NOTE]
> enhaanced script
> - [marslo/mytools](https://github.com/marslo/mytools/blob/master/itool/ldapsearch)
> reference:
> - [ldapsearch Examples](https://docs.oracle.com/cd/E19693-01/819-0997/auto45/index.html)
> - [The ldapsearch Tool](https://docs.oracle.com/cd/E19850-01/816-6400-10/lsearch.html)
> - [Querying AD with ldapsearch](http://www.cs.rug.nl/~jurjen/ApprenticesNotes/ldapsearch_ad_query.html)
> ```bash
> -LLL                                          # just a particular way to display the results
> -H ldap://wspace.mydomain.com                 # the URL where the LDAP server listens
> -x                                            # use simple authentication, not SASL
> -D 'user1'                                    # the account to use to authenticate to LDAP
> -w 'user1password'                            # the password that goes with the account on the previous line
> -E pr=1000/noprompt                           # ask the server for all pages, don't stop after one
> -b 'ou=mydomain,dc=wspace,dc=mydomain,dc=com' # the base of the search. We don't want results from e.g. 'ou=blah,dc=wspace,dc=mydomain,dc=com'
> '(&(objectClass=person)(uidNumber=*))'        # Ask for any entry that has attributes objectClass=person and uidNumber has a value
> SAMAccountName uid uidNumber                  # Show only these attributes
> ```

### search specific user

> [!NOTE]
> info :
> - ldap url         : `ldaps://ldap.mydomain.com:636`
> - base search base : `dc=mydomain,dc=com`
> - login user       : `user1` / `user1password`
> - search           : `user2`
>
> [remove `#refldaps://..`](character/sed.html#remove-both--and-empty-lines)
> - remove `#.*`
>   ```bash
>   $ ldapsearch ... | sed -r '/^(#.*)$/d'
>   ```
> - remove empty lines
>   ```bash
>   $ ldapsearch ... | sed -r '/^\s*$/d'
>   ```
> - remove all
>   ```bash
>   $ ldapsearch ... | sed -r '/^(#.*)$/d;/^\s*$/d'
>
>   # or
>   $ ldapsearch ... | sed -r '/(^#.*)|(^\s*)$/d'
>   ```

```bash
$ ldapsearch \
    -LLL \
    -x \
    -H 'ldaps://ldap.mydomain.com:636' \
    -b 'dc=mydomain,dc=com' \
    -D 'user1' \
    -w 'user1password' \
    CN='user2'
```
- or insert password via interactive mode ( `-W` )
  ```bash
  $ ldapsearch \
      -LLL \
      -x \
      -H 'ldaps://ldap.mydomain.com:636' \
      -b 'dc=mydomain,dc=com' \
      -W \
      -D 'user1' \
      CN='user2'
  ```

### filter `DN` field only
```bash
$ ldapsearch \
    [-LLL \]
    -H 'ldaps://ldap.mydomain.com:636' \
    -b 'dc=mydomain,dc=com' \
    -x \
    -D 'user1' \
    -w 'user1password' \
    CN='user2' \
    DN
```

### filter `SAMAccountName`, `uid` and `uidNumber` only

> [!TIP]
> filter base on base DN (`OU=Person,DC=mydomain,DC=com`)

```bash
$ ldapsearch \
    -LLL \
    -x \
    -H 'ldaps://ldap.mydomain.com:636' \
    -b 'ou=Workers,dc=mydomain,dc=com' \
    -D 'user1' \
    -w 'user1password' \
    -E 'pr=1000/noprompt' \
    '(&(objectClass=user)(sAMAccountName=*))' \
    SAMAccountName uid uidNumber DN
```

### filter particular group
```bash
$ ldapsearch \
    -x \
    -H 'ldaps://ldap.mydomain.com:636' \
    -b 'OU=DL,OU=Groups,OU=GLOBAL,OU=Sites,dc=mydomain,dc=com' \
    -D 'user1' \
    -w 'user1password' \
    -E 'pr=1000/noprompt' \
    '(&(objectClass=group)(CN=*))'
```

- search particular group (`cn=DL-name-group`)
  ```bash
  $ ldapsearch \
      -x \
      -H 'ldaps://ldap.mydomain.com:636' \
      -b 'OU=DL,OU=Groups,OU=GLOBAL,OU=Sites,dc=mydomain,dc=com' \
      -D 'user1' \
      -w 'user1password' \
      -E 'pr=1000/noprompt' \
      CN='DL-name-group'
  ```

## others
### directory diff
```bash
$ diff --suppress-common-lines -y <(cd path_to_dir1; find .|sort) <(cd path_to_dir2; find .|sort)
```

### show some command periodically
```bash
$ watch --interval 1 ls -alt
```
- watch with pipe
  ```bash
  $ watch -n 1 'ls -Altrh | grep <keywords>'
  ```

### clear
```bash
$ printf "\ec"
```

### use less as tail -f
```bash
$ less +F <filename>
```

### netcat & nmap-ncat

> [!NOTE]
> references:
> - [* imarslo : epel](../linux/basic.html#tools-installation)
> - [* imarslo : adminTools - nc](../devops/adminTools.html#netcat)

- install
  ```bash
  $ sudo yum -y install epel-release [yum-utils]
  # or via url
  $ sudo dnf [re]install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  $ sudo dnf [re]install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm

  $ sudo yum update -y
  $ yum list | grep netcat
  netcat.x86_64      1.219-2.el8       @epel
  $ sudo yum install -y netcat.x86_64

  # check
  $ sudo yum repolist
  ```

- switch with nmap & netcat
  ```bash
  $ ls -altrh /usr/local/bin/nc
  lrwxrwxrwx 1 root root 22 Mar 14 03:14 /usr/local/bin/nc -> /etc/alternatives/nmap

  $ sudo update-alternatives --config nmap

  There are 2 programs which provide 'nmap'.

    Selection    Command
  -----------------------------------------------
  *+ 1           /usr/bin/ncat
     2           /usr/bin/netcat

  Enter to keep the current selection[+], or type selection number: 2
  ```

- check
  ```bash
  # by using netcat
  $ nc -zv google.com 443
  Connection to google.com (142.251.214.142) 443 port [tcp/https] succeeded!

  # by using nact
  $ ncat -zv google.com 443
  Ncat: Version 7.70 ( https://nmap.org/ncat )
  Ncat: Connected to 142.251.214.142:443.
  Ncat: 0 bytes sent, 0 bytes received in 0.07 seconds.
  ```

- check package
  ```bash
  $ rpm -ql netcat.x86_64
  /usr/bin/nc
  /usr/bin/netcat
  /usr/lib/.build-id
  /usr/lib/.build-id/f3
  /usr/lib/.build-id/f3/3de6290429f99a8d8f5fe646a93bcc952dafdd
  /usr/share/man/man1/nc.1.gz
  /usr/share/man/man1/netcat.1.gz

  $ rpm -ql nmap-ncat.x86_64
  /usr/bin/nc
  /usr/bin/ncat
  ...
  ```

### alternatives & update-alternatives
- install
  ```bash
  $ sudo update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_121/bin/java 999
  $ sudo update-alternatives --auto java
  $ sudo update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_121/bin/javac 999
  $ sudo update-alternatives --auto javac
  ```

- modify
  ```bash
  $ ls -altrh $(which -a nc)
  lrwxrwxrwx 1 root root 22 Jun  1 04:02 /usr/bin/nc -> /etc/alternatives/nmap

  $ sudo alternatives --config nmap
  There are 2 programs which provide 'nmap'.

    Selection    Command
  -----------------------------------------------
  *+ 1           /usr/bin/netcat
     2           /usr/bin/ncat

  Enter to keep the current selection[+], or type selection number: 1
  ```
