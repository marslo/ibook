<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [formatting](#formatting)
  - [padding](#padding)
    - [solution](#solution)
    - [padRight](#padright)
  - [`.join()` alike in shell](#join-alike-in-shell)
  - [show all line numbers in a file](#show-all-line-numbers-in-a-file)
  - [get the common part](#get-the-common-part)
  - [revert a string](#revert-a-string)
  - [format a file to a table](#format-a-file-to-a-table)
  - [convert multiple line into one](#convert-multiple-line-into-one)
- [others](#others)
  - [file ending crlf or lf](#file-ending-crlf-or-lf)
    - [convert dos to unix](#convert-dos-to-unix)
  - [insert into the first line](#insert-into-the-first-line)
  - [find and replace](#find-and-replace)
  - [find and copy](#find-and-copy)
  - [get the count of a word in a file](#get-the-count-of-a-word-in-a-file)
  - [print 50th char](#print-50th-char)
  - [show last n lines in a file](#show-last-n-lines-in-a-file)
- [shell parameter expansion](#shell-parameter-expansion)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# formatting
## padding

> [!NOTE|label:references:]
> - [Padding characters in printf](https://stackoverflow.com/questions/4409399/padding-characters-in-printf)

### solution
- `printf`
  ```bash
  $ printf "%-50s%s\n" '123456'  '[STATUS]'
  123456                                            [STATUS]
  $ printf "%-50s%s\n" '1234567890'  '[STATUS]'
  1234567890                                        [STATUS]

  $ printf "%-50s%s\n" '123456~'  '~[STATUS]' | tr ' ~' '. '
  123456 ........................................... [STATUS]
  $ printf "%-50s%s\n" '1234567980~'  '~[STATUS]' | tr ' ~' '. '
  1234567980 ....................................... [STATUS]
  ```

- [`${var:length}`](https://stackoverflow.com/a/4411098/2940319)
  ```bash
  $ str1='123456'
  $ str2='1234567890'
  $ line=$(printf '%0.1s' "."{1..40})
  # or
  $ line='----------------------------------------'

  # check length via ${#<var>}
  $ echo ${#str1}           # 6  ( length )
  $ echo ${#str2}           # 10 ( length )
  $ echo ${#line}           # 40 ( length )

  # echo line with line-length - string-length via ${var:length}
  $ echo ${line}            # ----------------------------------------
  $ echo ${line:6}          # ----------------------------------

  $ echo -e "${str1} [up] \n${str2} [down]" |
    while read str status; do
      printf "%s %s %s\n" "${str}" "${line:${#str}}" "${status}";
    done
  123456 ---------------------------------- [up]
  1234567890 ------------------------------ [down]
  ```

### padRight

> [!NOTE]
> references:
> - [ascii](http://defindit.com/ascii.html)
>
> |  ASCII | CHARACTER |
> |:------:|:---------:|
> | `\x2b` |    `+`    |
> | `\x2c` |    `,`    |
> | `\x2d` |    `-`    |
> | `\x2e` |    `.`    |
> | `\x3d` |    `=`    |
> | `\x5e` |    `^`    |
> | `\x5f` |    `_`    |


```bash
function padRight() {
  IFS=':' read -r param value length
  padlength=${length:-40}
  pad=$(printf '\x2e%.0s' $(seq "${padlength}"))
  printf "%s %s %s\n" "${param}" "${pad:${#param}}" "${value}"
}

echo '1234 : abc'              | padRight
echo '1234567890 : efg'        | padRight
echo '1234567890 : [bar] : 30' | padRight
echo '123 : [foo] : 30'        | padRight

# result :
# 1234  ...................................  abc
# 1234567890  .............................  efg
# 1234567890  ...................  [bar]
# 123  ..........................  [foo]
```

- or
  ```bash
  pad=$(printf '%0.1s' "-"{1..60})
  padlength=40
  string2='bbbbbbb'
  for string1 in a aa aaaa aaaaaaaa; do
    printf '%s' "$string1"
    printf '%*.*s' 0 $((padlength - ${#string1} - ${#string2} )) "$pad"
    printf '%s\n' "$string2"
    string2=${string2:1}
  done

  # result
  # a--------------------------------bbbbbbb
  # aa--------------------------------bbbbbb
  # aaaa-------------------------------bbbbb
  # aaaaaaaa----------------------------bbbb
  ```

- or
  ```bash
  while read PROC_NAME STATUS; do
    printf "%-50s%s\n" "$PROC_NAME~" "~[$STATUS]" | tr ' ~' '- '
  done << EOT
  JBoss DOWN
  GlassFish UP
  VeryLongProcessName UP
  EOT

  # result
  # JBoss -------------------------------------------- [DOWN]
  # GlassFish ---------------------------------------- [UP]
  # VeryLongProcessName ------------------------------ [UP]
  ```

## `.join()` alike in shell
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

## show all line numbers in a file
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

## get the common part

> [!NOTE|label:see also:]
> - [iMarslo: comm](../../cheatsheet/text-processing/text-processing.html#comm)

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

## revert a string
```bash
$ echo linux | rev
xunil
```

## format a file to a table

> [!NOTE|label:see also:]
> - [iMarslo: column](../../cheatsheet/text-processing/text-processing.html#column)

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

## convert multiple line into one


> [!NOTE|label:see also:]
> - [iMarslo: single line to multiple lines](../../cheatsheet/text-processing/text-processing.html#single-line-to-multiple-lines)
> - [iMarlso: combine every 2 lines](../../cheatsheet/text-processing/text-processing.html#combine-every-2-lines)

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

# others
## file ending crlf or lf

> [!NOTE]
> - [How to test whether a file uses CRLF or LF without modifying it?](https://unix.stackexchange.com/a/79713/29178)

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

- [`less -u`](https://stackoverflow.com/a/31656611/2940319)
  ```bash
  $ less -u unix.txt
  abc
  $ less -u dos.txt
  abc^M
  ```

- `file`
  ```bash
  $ file windows.txt
  windows.txt: ASCII text, with CRLF line terminators

  $ dos2unix windows.txt
  $ file windows.txt
  windows.txt: ASCII text
  ```

  - [with `--keep-going`](https://stackoverflow.com/a/47435767/2940319)
    ```bash
    $ file jfrog_public_gpg.key
    jfrog_public_gpg.key: PGP public key block

    $ file --keep-going jfrog_public_gpg.key
    jfrog_public_gpg.key: PGP public key block\012- , ASCII text, with CRLF line terminators
    # or
    $ file -k jfrog_public_gpg.key
    jfrog_public_gpg.key: PGP public key block\012- , ASCII text, with CRLF line terminators

    $ [[ $(file -k dos.txt) =~ CRLF  ]] && echo dos || echo unix
    dos
    $ [[ $(file -k unix.txt) =~ CRLF ]] && echo dos || echo unix
    unix

    # or
    $ [[ $(file -b -k - < dos.txt) =~ CRLF  ]] && echo dos || echo unix
    dos
    $ [[ $(file -b -k - < unix.txt) =~ CRLF ]] && echo dos || echo unix
    unix
    ```

- `dos2unix`
  ```bash
  $ dos2unix --info=h -- *
       DOS    UNIX     MAC  BOM       TXTBIN  FILE
         1       0       0  no_bom    text    dos.txt
        28       0       0  no_bom    text    jfrog_public_gpg.key
         0       1       0  no_bom    text    unix.txt

  # or `-ih` for short
  $ dos2unix -ih jfrog_public_gpg.key
       DOS    UNIX     MAC  BOM       TXTBIN  FILE
        28       0       0  no_bom    text    jfrog_public_gpg.key
  ```

- `grep`

  > [!TIP]
  > - `grep -lU $'\x0D' * | xargs ...`

  ```bash
  $ cat a.txt | hexdump -cC
  0000000   a  b  c  \r \n
  00000000  61 62 63 0d 0a                                    |abc..|
  00000005
  #                  ^

  # via hex
  $ grep -qU $'\x0D' a.txt; echo $?
  0
  # via octal
  $ grep -qU $'\015' a.txt; echo $?
  0
  # via `-c`
  $ grep -c $'\r' a.txt
  1

  # verify
  $ dos2unix a.txt
  dos2unix: converting file a.txt to Unix format...
  $ grep -qU $'\015' a.txt; echo $?
  1
  $ grep -qU $'\x0D' a.txt; echo $?
  1
  $ grep -c $'\r' a.txt
  0
  ```

- can be
  ```bash
  $ grep -qU $'\015' a.txt && echo dos || echo unix
  $ grep -qU $'\x0D' a.txt && echo dos || echo unix
  $ [[ $(grep -c $'\r$' a.txt) -gt 0 ]] && echo dos || echo unix
  ```

- [awk](https://stackoverflow.com/a/18107490/2940319)
  ```bash
  $ awk '/\r$/ { exit(1) }'         a.txt && echo unix || echo dos
  $ awk '/\r$/{exit 0;} 1{exit 1;}' a.txt && echo dos  || echo unix
  ```

- `od -c`
  ```bash
  $ od -c dos.txt
  0000000   a   b   c  \r  \n
  0000005
  $ od -c -t a dos.txt
  0000000   a   b   c  \r  \n
            a   b   c  cr  nl
  0000005

  $ od -c unix.txt
  0000000   a   b   c  \n
  0000004
  $ od -c -t a unix.txt
  0000000   a   b   c  \n
            a   b   c  nl
  0000004
  ```

- `hexdump -c`
  ```bash
  $ od -c dos.txt
  0000000   a   b   c  \r  \n
  0000005
  $ od -c -t a dos.txt
  0000000   a   b   c  \r  \n
            a   b   c  cr  nl
  0000005
  $ hexdump -cC dos.txt | column -t
  0000000   a   b   c   \r  \n
  00000000  61  62  63  0d  0a  |abc..|
  00000005

  $ od -c unix.txt
  0000000   a   b   c  \n
  0000004
  $ hexdump -cC unix.txt | column -t
  0000000   a   b   c   \n
  00000000  61  62  63  0a  |abc.|
  00000004
  ```

### convert dos to unix
```bash
$ dos2unix
$ cat a.txt | tr -d '\015'

# verify
$ cat dos.txt | grep -qU $'\015' && echo dos || echo unix
dos
$ cat dos.txt | tr -d '\015' | grep -qU $'\015' && echo dos || echo unix
unix
```

## insert into the first line
```bash
$ cat demo.file
abc
efg

$ echo "first line" | cat - demo.file
first line
abc
efg
```

## [find and replace](https://unix.stackexchange.com/a/36805/29178)
```bash
$ find . -type f -name '*.md' -exec sed -i 's/<string1>/<string2>/g' {} +
```

## find and copy
```bash
source="/Users/marslo/test/logs"
target="/Users/marslo/test/logs/targetet"

while IFS= read -r -d '' logFile; do
  cp "${logFile}" "${target}"
done < <(find "${source}" -maxdepth 1 -name '*.log' -print0)
```

## get the count of a word in a file
```bash
$ cat /etc/passwd | grep marslo -o | wc -l
3
# or
$ find . -name file.txt | xargs -e grep "token" -o | wc -l
```

## print 50th char
```bash
$ awk 'BEGIN{while (a++<50) s=s "-"; print s}'
--------------------------------------------------
```

## show last n lines in a file
```bash
$ tail /etc/passwd -n 3
saned:x:115:123::/home/saned:/bin/false
marslo:x:1000:1000:Marslo,,,:/home/marslo:/bin/bash
mysql:x:1001:1001::/home/mysql:/bin/sh
$ tail /etc/passwd -n 2
marslo:x:1000:1000:Marslo,,,:/home/marslo:/bin/bash
mysql:x:1001:1001::/home/mysql:/bin/sh
```

# [shell parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
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

- [shell parameter expansion for string `replace`](https://stackoverflow.com/a/13210909/2940319)

  {% hint style='tip' %}
  > ** for bash only **
  > usage:
  > `${parameter/pattern/string}` replace the first occurrence of a pattern with a given string
  > `${parameter//pattern/string}` replace all occurrences
  >
  > reference:
  > - [the Bash Reference Manual, §3.5.3 "Shell Parameter Expansion"](https://www.gnu.org/software/bash/manual/bash.html#Shell-Parameter-Expansion)
  > - not supported in all Unix Shells: [the Shell & Utilities volume, §2.6.2 "Parameter Expansion"](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_02)
  {% endhint %}

  ```bash
  $ message='The secret code is 12345'

  # first occurrence replacement
  $ echo "${message/[0-9]/X}"
  The secret code is X2345

  # all occurrences replacement
  $ echo "${message//[0-9]/X}"
  The secret code is XXXXX
  ```
