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
> - [iMarslo: comm](../../cheatsheet/character/character.html#comm)

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
> - [iMarslo: column](../../cheatsheet/character/character.html#column)

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
> - [iMarslo: single line to multiple lines](../../cheatsheet/character/character.html#single-line-to-multiple-lines)
> - [iMarlso: combine every 2 lines](../../cheatsheet/character/character.html#combine-every-2-lines)

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
