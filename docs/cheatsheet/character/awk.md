<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [convert row to column](#convert-row-to-column)
- [split](#split)
- [print chars and length](#print-chars-and-length)
- [summary all user used memory (`ps aux`)](#summary-all-user-used-memory-ps-aux)
- [calculate word count in a file](#calculate-word-count-in-a-file)
- [remove non-duplicated lines](#remove-non-duplicated-lines)
- [show matched values](#show-matched-values)
- [field separator variable](#field-separator-variable)
- [align](#align)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [awk printf](http://kb.ictbanking.net/article.php?id=688)
> - [4.5 Specifying How Fields Are Separated](https://www.gnu.org/software/gawk/manual/html_node/Field-Separators.html)
> - [awk裡好用的變數：FS, OFS, RS, ORS, NR, NF, FILENAME, FNR](https://weitinglin.com/2016/10/17/awk%E8%A3%A1%E5%A5%BD%E7%94%A8%E7%9A%84%E8%AE%8A%E6%95%B8%EF%BC%9Afs-ofs-rs-ors-nr-nf-filename-fnr/comment-page-1/)
{% endhint %}

### [convert row to column](https://unix.stackexchange.com/a/169997/29178)

> [!TIP|label:original content]
> ```bash
> $ cat sample.txt
> job salary
> c++ 13
> java 14
> php 12
> ```

```bash
awk '{
       for ( i=1; i<=NF; i++ ) arr[i]= (arr[i]? arr[i] FS $i: $i)
     } END {
       for ( i in arr ) print arr[i]
     }' sample.txt
```

- result
  ```bash
  job c++ java php
  salary 13 14 12
  ```

### split
```bash
$ echo "12:34:56" |
        awk '{
          len = split( $0, a, ":" ) ;
          for( i=1; i <=len; i++ ) {
            print "a["i"] = "a[i] ;
          }
          print "length = "len
        }'
a[1] = 12
a[2] = 34
a[3] = 56
length = 3
```

- split with result

  > [!NOTE|label:real situation]
  > - original string
  >
  >   ```batch
  >   > git config --list --show-origin --name-only | head -3
  >   file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   diff.astextplain.textconv
  >   file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.clean
  >   file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.smudge
  >       +-------------------------------------------------------+
  >                         wanted string
  >   ```
  >
  > - filter via `:`
  >   ```batch
  >   REM file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.smudge
  >   REM +---+-+-------------------------------------------------------------------------+
  >   REM   |  |                                        |
  >   REM   v  v                                        v
  >   REM   $1 $2                                       $3
  >
  >   > git config --list --show-origin --name-only | head -3 | awk -F: '{print $2}'
  >   C
  >   C
  >   C
  >   > git config --list --show-origin --name-only | head -3 | awk -F: '{print $3}'
  >   /Users/marslo/AppData/Local/Programs/Git/etc/gitconfig  diff.astextplain.textconv
  >   /Users/marslo/AppData/Local/Programs/Git/etc/gitconfig  filter.lfs.clean
  >   /Users/marslo/AppData/Local/Programs/Git/etc/gitconfig  filter.lfs.smudge
  >   ```

  ```batch
  REM via split

  REM  "FS"                                  $2
  REM   |                                    |
  REM   v                                    v
  REM  ___ ___________________________________________________________________________
  REM |   |                                                                           |
  REM file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.smudge
  REM     +                                                       +   +               +
  REM     .........................................................   .................
  REM                              v                                          v
  REM                           arr[1]                                     arr[2]

  > git config --list --show-origin --name-only | head -3 | awk 'BEGIN { FS="file:" }; { print $2 }'
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig        diff.astextplain.textconv
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig        filter.lfs.clean
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig        filter.lfs.smudge

  > git config --list --show-origin --name-only | head -3 | awk 'BEGIN { FS="file:" }; { n=split($2, arr, " "); print arr[1] }'
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  ```

### print chars and length
```bash
$ awk '{ for(i=1; i<=NF; i++) { print $i, length($i) } }' sample.txt
```
- or using `while`
  ```bash
  $ while IFS= read -r line; do
    echo "${line}: ${#line}"
  done < <(cat sample.txt | xargs -n1 echo)
  ```

### summary all user used memory (`ps aux`)
```bash
$ awk '{sum += $1} END {print sum}' < <(ps -u marslo -o pmem)
```
- or
  ```bash
  $ ps -u marslo -o pcpu,pmem,pid,command |
       awk '{sum += $2} END {print sum}'
  ```

### calculate word count in a file
```bash
$ < sample.txt \
    tr -s ' ' '\n' |
    sort |
    uniq -c |
    awk '{print $2,$1}' |
    sort -gk2
```
- or
  ```bash
  $ cat sample.txt |
        xargs -n1 echo |
        sort |
        uniq -c |
        awk '{print $2,$1}' |
        sort -gk2
  ```
- or
  ```bash
  $ awk '{ for(w=1;w<=NF;w++) print $w }' sample.txt |
        sort |
        uniq -c |
        awk '{print $2,$1}' |
        sort -gk2
  ```

### remove non-duplicated lines
{% hint style='tip' %}
> pre-condition
> ```bash
> $ cat sample.txt | xargs
> a a b c d e e e f
> ```
{% endhint %}

```bash
$ awk '{ print $1 }' sample.txt | sort | uniq -cd | sort -g
```

- or
  ```bash
  $ awk '{ arr[$1]++ } END {
           for (key in arr) {
             if ( arr[key] > 1 ){ print arr[key], key }
           }
         }' \
    sample.txt
  ```

- [show only duplicated lines](https://superuser.com/a/1107659/112396)
  ```bash
  $ awk 'seen[$1]++' sample.txt
  ```
  - show only non-duplicated lines
    ```bash
    $ awk '!seen[$1]++' sample.txt
    ```

### show matched values
> - [Comparison Operators](https://www.gnu.org/software/gawk/manual/html_node/Comparison-Operators.html)
> - [Regular Expressions](http://www.math.utah.edu/docs/info/gawk_5.html)
> - [How to check the checksum through commandline?](https://stackoverflow.com/a/21956985/2940319)

- find distrib name from `/etc/lsb-release`
  ```bash
  $ awk -F= '$1 == "DISTRIB_ID" {print $2;}' /etc/lsb-release
  Ubuntu

  # or
  $ awk -F= '$1=="ID" {print $2;}' /etc/os-release
  ubuntu
  ```

- [find multiple matches](https://unix.stackexchange.com/q/6345/29178)
  ```bash
  $ awk -F= '$1 ~ /DISTRIB_ID|DISTRIB_RELEASE/ {print $2;}' /etc/lsb-release
  Ubuntu
  18.04
  ```

- return `true` or `false` according to matches result
  ```bash
  $ standard='2cf1b1652a5b268ec80717ef33fef111'
  $ md5sum ~/.bashrc | awk '$1 != "${standard}" {exit 1}'

  # or
  $ md5sum ~/.bashrc | awk '$1 == "${standard}" {print "true"}'
  ```


### field separator variable
- multiple separators

  > [!NOTE|label:multiple separators]
  > - references:
  >   - [Two field separators (colon and space) in awk](https://unix.stackexchange.com/a/515679/29178)
  >   - [How to match space or \s via regex in awk](https://stackoverflow.com/a/71136187/2940319)
  >   - [8 Powerful Awk Built-in Variables – FS, OFS, RS, ORS, NR, NF, FILENAME, FNR](https://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/?ref=binfind.com/web)
  >   - [How to split a delimited string into an array in awk?](https://stackoverflow.com/a/36211699/2940319)
  >   - [Retrieve information Text/Word from HTML code using awk/sed](https://www.unix.com/302897228-post6.html)
  >
  > - example target : set both `:` (colon) and ` `(space/blank) as separators

  ```bash
  # orignal contents
  > git config --list --show-origin --name-only | head -3
  file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   diff.astextplain.textconv
  file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.clean
  file:C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig   filter.lfs.smudge
  #    +......................................................+
  #                             v
  #                       wanted string

  # via `-F <regex>`
  > git config --list --show-origin --name-only | head -3 | awk -F"[: ]" '{print $2":"$3}'
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig

  # or via `FS=`
  > git config --list --show-origin --name-only | head -3 | awk -v FS='[:[:space:]]+' '{print $2":"$3}'   F
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig

  # `[[:blank:]]` or `[[:space:]]`
  > git config --list --show-origin --name-only | head -3 | awk -v FS='[:[:blank:]]+' '{print $2":"$3}'
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig

  > git config --list --show-origin --name-only | head -3 | awk 'BEGIN { FS="[:[:blank:]]+" }; { print $2":"$3 }'
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  C:/Users/marslo/AppData/Local/Programs/Git/etc/gitconfig
  ```

### align

> [!NOTE|label:references:]
> - [bash: how to add header to its corresponding lines](https://stackoverflow.com/a/46703062/2940319)

```bash'
$ cat a.txt
CGRT,630,SC063P1
10001,X,6849
10003,X,6913
10005,X,6977
CGRT,631,SC063P2
10049,X,8481
10051,X,8545
10081,X,1185
CGRT,632,SC063P3
10110,X,1601
10111,X,1633

$ awk '!/^[0-9]/{h=$0;next}{print h,$0}' a.txt
CGRT,630,SC063P1 10001,X,6849
CGRT,630,SC063P1 10003,X,6913
CGRT,630,SC063P1 10005,X,6977
CGRT,631,SC063P2 10049,X,8481
CGRT,631,SC063P2 10051,X,8545
CGRT,631,SC063P2 10081,X,1185
CGRT,632,SC063P3 10110,X,1601
CGRT,632,SC063P3 10111,X,1633

# or
$ awk '/^[a-zA-Z]/{val=$0;next} {print val "\t" $0}' a.txt

# or via sed
$ sed '/^[^0-9]/h;//d;G;s/\(.*\)\n\(.*\)/\2 \1/'
```
