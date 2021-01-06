<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`.join()` alike in shell](#join-alike-in-shell)
- [find out the file is ending by crlf or lf](#find-out-the-file-is-ending-by-crlf-or-lf)
- [Show all line numbers in a file](#show-all-line-numbers-in-a-file)
- [Insert into the first line](#insert-into-the-first-line)
- [backup and restore filer & folder permission](#backup-and-restore-filer--folder-permission)
- [Encrypt bash file](#encrypt-bash-file)
- [Get the count of a word in a file](#get-the-count-of-a-word-in-a-file)
- [Print 50th char](#print-50th-char)
- [Get the common part](#get-the-common-part)
- [Revert a word](#revert-a-word)
- [Format a file to a table](#format-a-file-to-a-table)
- [Show last n lines in a file](#show-last-n-lines-in-a-file)
- [Print a file into one line](#print-a-file-into-one-line)
- [Get the file inode](#get-the-file-inode)
- [All About {Curly Braces} In Bash](#all-about-curly-braces-in-bash)
- [find and replace](#find-and-replace)
- [Shell Parameter Expansion](#shell-parameter-expansion)
- [find and copy](#find-and-copy)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### `.join()` alike in shell
- [`paste`](https://stackoverflow.com/a/6539865/2940319)
  ```bash
  $ seq 1 100 | paste -sd ':' -
  1:2:3:4:5:6:7:8:9:10:11:12:13:14:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89:90:91:92:93:94:95:96:97:98:99:100

  # others
  $ seq 1 100 | paste -sd "\0"
  123456789101112131415161718192021222324252627282930313233343536373839404142434445464748495051525354555657585960616263646566676869707172737475767778798081828384858687888990919293949596979899100
  ```

- [`sed`](https://stackoverflow.com/a/48486375/2940319)
  ```bash
  $ seq 1 100 | sed ':a; N; $!ba; s/\n/:/g'
  1:2:3:4:5:6:7:8:9:10:11:12:13:14:15:16:17:18:19:20:21:22:23:24:25:26:27:28:29:30:31:32:33:34:35:36:37:38:39:40:41:42:43:44:45:46:47:48:49:50:51:52:53:54:55:56:57:58:59:60:61:62:63:64:65:66:67:68:69:70:71:72:73:74:75:76:77:78:79:80:81:82:83:84:85:86:87:88:89:90:91:92:93:94:95:96:97:98:99:100
  ```

- [`awk` (`ORS`)](https://stackoverflow.com/a/13868559/2940319)
  ```bash
  $ seq 1 100 | awk 'ORS=","'
  1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,
  ```

- `ls -m`
  ```bash
  $ ls -m
  Applications, Desktop, Documents, Downloads, Library, Movies, Music, Pictures, Public,
  ```

### find out the file is ending by crlf or lf
- `cat -e`
  ```bash
  $ cat -e <file>

  # e.g.
  $ cat -e windows.txt
  test^M$
  windows^M$
  format

  $ cat -e linux.txt
  test$
  windows$
  format
  ```
- `file`
  ```bash
  $ file windows.txt
  windows.txt: ASCII text, with CRLF line terminators

  $ file windows.txt
  windows.txt: ASCII text
  ```

### Show all line numbers in a file
- `cat`
  ```bash
  $ sudo cat /etc/passwd | wc -l
  36
  ```

- `awk`
  ```bash
  $ awk 'END {print NR}' /etc/passwd
  36
  ```

### Insert into the first line
```bash
$ cat demo.file
abc
efg

$ echo "first line" | cat - demo.file
first line
abc
efg
```

### [backup and restore filer & folder permission](https://unix.stackexchange.com/a/128499/29178)
- backup
  ```bash
  $ find . -printf '%m\t%u\t%g\t%p\0' > file.perm
  ```

- restore
  ```bash
  while read -rd $'\0' perms user group file; do
    if [ -e "$file" ]; then
      chown "$user:$group" "$file"
      chmod "$perms" "$file"
    else
      echo "warning: $file not found"
    fi
  done < file.perm
  ```

#### check perm
- `find` & `printf`
  ```bash
  $ find $PWD -printf '%m\t%u\t%g\t%p\n' | head
  755	marslo	staff	/Users/marslo
  755	marslo	staff	/Users/marslo/.eclipse
  755	marslo	staff	/Users/marslo/.eclipse/org.eclipse.oomph.jreinfo
  644	marslo	staff	/Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/defaults.properties
  644	marslo	staff	/Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/infos.txt

  $ find $PWD -printf '%M %u %g %p\n' | head
  drwxr-xr-x marslo staff /Users/marslo
  drwxr-xr-x marslo staff /Users/marslo/.eclipse
  drwxr-xr-x marslo staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo
  -rw-r--r-- marslo staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/defaults.properties
  ```
- `stat`
  ```bash
  $ stat -c '%A %a %n' *
  drwx------ 700 Applications
  drwx------ 700 Desktop
  drwx------ 700 Documents
  drwx------ 700 Downloads
  drwx------ 700 Library
  drwx------ 700 Movies
  drwx------ 700 Music
  drwx------ 700 Pictures
  drwxr-xr-x 755 Public
  drwxr-xr-x 755 mywork
  drwxr-xr-x 755 test
  ```

- `namei`
    ```bash
    $ namei -l $PWD
    /Users/marslo
      / = drwxr-xr-x l=22 u=root/0 g=admin/80 s=704 m=07-16-2020@13:40:21
      Users = drwxr-xr-x l=6 u=root/0 g=admin/80 s=192 m=09-30-2019@04:22:36
      marslo = drwxr-xr-x l=72 u=marslo/501 g=staff/20 s=2304 m=07-16-2020@17:37:27
    ```

### Encrypt bash file
```bash
$ echo "ls" > script.bash; gpg -c script.bash; cat script.bash.gpg | gpg -d --no-mdc-warning | bash
```

### Get the count of a word in a file
```bash
$ cat /etc/passwd | grep marslo -o | wc -l
3
# or
$ find . -name file.txt | xargs -e grep "token" -o | wc -l
```

### Print 50th char
```bash
$ awk 'BEGIN{while (a++<50) s=s "-"; print s}'
--------------------------------------------------
```

### Get the common part
```bash
$ cat a.txt
1
2
3
$ cat b.txt
3
4
5
9

$ comm -12 a.txt b.txt > common
$ cat common
3
```

### Revert a word
```bash
$ echo linux | rev
xunil
```

### Format a file to a table
```bash
$ cat a_b
1:1
2:2
3:3
$ column -tns: a_b
1  1
2  2
3  3
```

### Show last n lines in a file
```bash
$ tail /etc/passwd -n 3
saned:x:115:123::/home/saned:/bin/false
marslo:x:1000:1000:Marslo,,,:/home/marslo:/bin/bash
mysql:x:1001:1001::/home/mysql:/bin/sh
$ tail /etc/passwd -n 2
marslo:x:1000:1000:Marslo,,,:/home/marslo:/bin/bash
mysql:x:1001:1001::/home/mysql:/bin/sh
```

### Print a file into one line
```bash
$ cat a
1
2
3
4
5
$ echo $(cat a)
1 2 3 4 5
$ cat a | xargs
1 2 3 4 5
```

### inode

#### get inode of a file
```bash
$ l -i a_b
10224132 -rw-r--r-- 1 marslo marslo 10 Feb 21 00:43 a_b
```

#### get inodes in a folder
- [`stat`](https://unix.stackexchange.com/a/121836/29178)
  ```bash
  $ stat -c '%i' ~
  686476
  ```
  equivalent to
  ```bash
  $ ls -id ~
  686476 /Users/marslo
  ```
  - example
    ```bash
    $ ls -id  /local_storage/docker
    2818591238 /local_storage/docker
    ```

- `ls`()
  ```bash
  $ ls /local_storage/docker -AiR1U |
       sed -rn '/^[./]/{h;n;};G;
           s|^ *([0-9][0-9]*)[^0-9][^/]*([~./].*):|\1:\2|p' |
       sort -t : -uk1.1,1n |
       cut -d: -f2 | sort -V |
       uniq -c | sort -rn | head -n10
       46 /Users/marslo/test/keepalived-2.0.18/lib
       29 /Users/marslo/test
       28 /Users/marslo/test/keepalived-2.0.18/doc/samples
       27 /Users/marslo/test/jenkins/vars
       23 /Users/marslo/test/keepalived-2.0.18
       22 /Users/marslo/test/keepalived-2.0.18/doc/source
       17 /Users/marslo/test/jenkins/jenkinsfile
       16 /Users/marslo/test/autosquash/.git/objects
       14 /Users/marslo/test/keepalived-2.0.18/keepalived/vrrp
       14 /Users/marslo/test/jenkins/configs/etc/yum.repos.d
  ```

- `df`
  ```bash
   $ df -i
  Filesystem                            Type   Inodes IUsed IFree IUse% Mounted on
  /dev/disk1s5s1                        apfs     2.3G  555K  2.3G    1% /
  /dev/disk1s4                          apfs     2.3G     2  2.3G    1% /System/Volumes/VM
  /dev/disk1s2                          apfs     2.3G  1.2K  2.3G    1% /System/Volumes/Preboot
  /dev/disk1s6                          apfs     2.3G    16  2.3G    1% /System/Volumes/Update
  /Library/Input Methods/SogouInput.app nullfs   2.3G  1.8M  2.3G    1% /private/var/folders/s3/mg_f3cv54nn7y758j_t46zt40000gn/T/AppTranslocation/1E49F6C4-251F-443B-8D8A-86DA8F531F09
  ```
- [`du`](https://unix.stackexchange.com/a/117098/29178)
  ```bash
  $ sudo du --inodes -S ~ \
         | sort -rh \
         | sed -n '1,50{/^.\{71\}/s/^\(.\{30\}\).*\(.\{37\}\)$/\1...\2/;p}' \
         | head -10
  14994	/Users/marslo/Library/Co...icrosoft User Data/OneNote/15.0/cache
  13453	/Users/marslo/Library/Gr...s/Main Profile/Files/S0/1/Attachments
  4667	/Users/marslo/Library/Caches/Google/Chrome Canary/Default/Cache
  4086	/Users/marslo/Library/Gro...ofiles/Marvell/Files/S0/1/Attachments
  3912	/Users/marslo/Library/Con...476b0cb6d7b78ea9f492c743c1bdfa/Avatar
  3359	/Users/marslo/Library/Con...6d7b78ea9f492c743c1bdfa/Stickers/File
  3174	/Users/marslo/Library/App...versions/3.8.6/openssl/share/man/man3
  3174	/Users/marslo/Library/App...6/openssl/share/doc/openssl/html/man3
  3174	/Users/marslo/Library/App...versions/3.7.9/openssl/share/man/man3
  3174	/Users/marslo/Library/App...9/openssl/share/doc/openssl/html/man3
  ```

#### check inode status
```bash
$ sudo tune2fs -l /dev/sdb1 | grep inode
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Free inodes:              234152632
First inode:              11
Journal inode:            8
First orphan inode:       44171696
Journal backup:           inode blocks
```

#### extend inode
> reference:
> - [Modifying the inode count for an ext2/ext3/ext4 file system](http://kb.ictbanking.net/article.php?id=693)
> - [RHEL: Extending the maximum inode count on a ext2/ext3/ext4 filesystem](https://sites.google.com/site/syscookbook/rhel/rhel-fs-ext2_3_4-inode-count)


### [All About {Curly Braces} In Bash](https://www.linux.com/tutorials/all-about-curly-braces-bash/)

```bash
$ echo 00{1..9} 0{10..99} 100
001 002 003 004 005 006 007 008 009 010 011 012 013 014 015 016 017 018 019 020 021 022 023 024 025 026 027 028 029 030 031 032 033 034 035 036 037 038 039 040 041 042 043 044 045 046 047 048 049 050 051 052 053 054 055 056 057 058 059 060 061 062 063 064 065 066 067 068 069 070 071 072 073 074 075 076 077 078 079 080 081 082 083 084 085 086 087 088 089 090 091 092 093 094 095 096 097 098 099 100

$ dec2bin=({0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1}{0..1})
$ echo ${dec2bin[1]}
00000001
$ echo ${dec2bin[0]}
00000000
$ echo ${dec2bin[255]}
11111111

$ month=("Jan" "Feb" "Mar" "Apr" "May" "Jun" "Jul" "Aug" "Sep" "Oct" "Nov" "Dec")
$ echo ${month[5]}
Jun

$ echo {10..0..2}
10 8 6 4 2 0
$ echo {1..100..3}
1 4 7 10 13 16 19 22 25 28 31 34 37 40 43 46 49 52 55 58 61 64 67 70 73 76 79 82 85 88 91 94 97 100
```

#### Fast copy or moving or someting ([Detials](http://www.manpager.com/linux/man1/bash.1.html) -> Brace Expansion)

- Example 1:
  ```bash
  $ ls | grep foo
  $ touch foo{1,2,3}
  $ ls | grep foo
  foo1
  foo2
  foo3
  ```
- Example 2
  ```bash
  $ ls | grep foo
  $ touch foo-{a..d}
  $ ls | grep foo
  foo-a
  foo-b
  foo-c
  foo-d
  ```

- Example 3
  ```bash
  $ ls foo-*
  foo-a  foo-b  foo-c  foo-d
  $ mv foo-{a,}
  $ ls foo-*
  foo-  foo-b  foo-c  foo-d
  ```

- Example 4
  ```bash
  $ mkdir -p test/{a,b,c,d}
  $ tree test/
  test/
  ├── a
  ├── b
  ├── c
  └── d

  4 directories, 0 files
  ```

#### Multiple Directories Creation
```bash
$ mkdir sa{1..50}
$ mkdir -p sa{1..50}/sax{1..50}
$ mkdir {a-z}12345
$ mkdir {1,2,3}
$ mkdir test{01..10}
$ mkdir -p `date '+%y%m%d'`/{1,2,3}
$ mkdir -p $USER/{1,2,3}
```

#### Copy a File to Multipule Folder
```bash
$ echo dir1 dir2 dir3 | xargs -n 1 cp file1
# OR
$ echo dir{1..10} | xargs -n 1 cp file1
```

### [find and replace](https://unix.stackexchange.com/a/36805/29178)
```bash
$ find . -type f -name '*.md' -exec sed -i 's/<string1>/<string2>/g' {} +
```

### [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
```bash
$ x='aabbcc'

$ echo ${x#a*b}
bcc
$ echo ${x#a}
abbcc
$ echo ${x##a}
abbcc

$ echo ${x%b*c}
aab
$ echo ${x%%b*c}
aa

$ echo ${x%c}
aabbc
$ echo ${x%%c}
aabbc
```

### find and copy
```bash
source="/Users/marslo/test/logs"
target="/Users/marslo/test/logs/targetet"

while IFS= read -r -d '' logFile; do
  cp "${logFile}" "${target}"
done < <(find "${source}" -maxdepth 1 -name '*.log' -print0)
```
