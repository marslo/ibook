<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [time & date](#time--date)
- [download and extract](#download-and-extract)
- [extract `jar`](#extract-jar)
- [compress](#compress)
- [get cookie from firefox](#get-cookie-from-firefox)
- [echo 256 colors](#echo-256-colors)
- [directory diff](#directory-diff)
- [commands](#commands)
- [bash](#bash)
- [ldapsearch](#ldapsearch)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### time & date
#### show cal

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

#### synchronize date and time with a server over ssh (Inspired from [commandlinefu.com](http://www.commandlinefu.com/commands/view/9153/synchronize-date-and-time-with-a-server-over-ssh))
```bash
$ date --set="$(ssh [username]@[sshserver] date)"
```

### download and extract
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
  ```bah
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

#### check file without extract
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

### compress
#### zip package with dot-file
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

#### remove dot-file without `skipping '..' '.'` issue
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

### get cookie from firefox
```bash
$ grep -oP '"url":"\K[^"]+' $(ls -t ~/.mozilla/firefox/*/sessionstore.js | sed q)
```

### echo 256 colors
```bash
$ for i in {0..255}; do echo -e "\e[38;05;${i}m${i}"; done | column -c 80 -s ' '; echo -e "\e[m"
# or
$ yes "$(seq 1 255)" | while read i; do printf "\x1b[48;5;${i}m\n"; sleep .01; done
```

### directory diff
```bash
diff --suppress-common-lines -y <(cd path_to_dir1; find .|sort) <(cd path_to_dir2; find .|sort)
```

### commands
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

#### list the command beginning with
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

#### searching for commands without knowing their exact names
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

#### show some command periodically
```bash
$ whatch --interval 1 ls -alt
```

#### rename
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

#### clear
```bash
$ printf "\ec"
```

#### use less as tail -f
```bash
$ less +F <filename>
```

#### batch move
> ` -I replace-str`

```bash
$ mkdir backup-folder && ls | grep -Ze ".*rar" | xargs -d '\n' -I {} mv {} backup-folder
```

#### batch copy
> reference:
> - [Hack 22. Xargs Command Examples](https://linux.101hacks.com/linux-commands/xargs-command-examples/)

```bash
$ ls -1 a/b/* 11 12 | xargs cp -t copy-target-folder/
```

### bash

#### [bash alias](https://askubuntu.com/a/871435)
```bash
$ echo ${BASH_ALIASES[ls]}
ls --color=always
```

#### [`bash -<parameter>`](https://unix.stackexchange.com/a/38363/29178)
- get bash login log
  ```bash
  $ bash -l -v
  ```

- run with only one startup file
  ```bash
  $ bash -i --rcfile="$HOME/.marslo/.imarslo"
  ```

### ldapsearch
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

#### search specific user
> Info :
> - ldap url         : `ldaps://ldap.mydomain.com:636`
> - base search base : `dc=mydomain,dc=com`
> - login user       : `user1` / `user1password`
> - search           : `user2`

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

#### search `DN` field of particular user (`user2`)
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
#### filter all `SAMAccountName`, `uid` and `uidNumber` under base DN (`OU=Person,DC=mydomain,DC=com`)
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

#### filter particular group
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

- search particular group (`cn=DL-mydomaindis-group`)
  ```bash
  $ ldapsearch \
      -x \
      -H 'ldaps://ldap.mydomain.com:636' \
      -b 'OU=DL,OU=Groups,OU=GLOBAL,OU=Sites,dc=mydomain,dc=com' \
      -D 'user1' \
      -w 'user1password' \
      -E 'pr=1000/noprompt' \
      CN='DL-mydomaindis-group'
  ```
