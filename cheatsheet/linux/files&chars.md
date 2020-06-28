<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

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

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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
```

### Get the file inode

```bash
$ l -i a_b
10224132 -rw-r--r-- 1 marslo marslo 10 Feb 21 00:43 a_b
```

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

#### Multiple Directories Createion

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
