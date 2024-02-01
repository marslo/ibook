<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [output](#output)
  - [convert row to column](#convert-row-to-column)
    - [`rs -T`](#rs--t)
    - [datamash](#datamash)
  - [reverse words](#reverse-words)
  - [align](#align)
    - [add header](#add-header)
    - [right/left alignment](#rightleft-alignment)
    - [alignment with fixed column](#alignment-with-fixed-column)
    - [append space](#append-space)
    - [convert csv format](#convert-csv-format)
  - [split](#split)
  - [last n columns](#last-n-columns)
    - [last 2 columns](#last-2-columns)
    - [second-to-last column ( `--NF` )](#second-to-last-column----nf-)
    - [last N columns](#last-n-columns)
    - [get major domain](#get-major-domain)
    - [trim](#trim)
- [calculate](#calculate)
  - [length](#length)
    - [longest line](#longest-line)
    - [longest filename](#longest-filename)
    - [print chars and length](#print-chars-and-length)
  - [sum](#sum)
    - [base on other column](#base-on-other-column)
    - [sum lines by extension](#sum-lines-by-extension)
    - [summary mem for all users (`ps aux`)](#summary-mem-for-all-users-ps-aux)
    - [summary all in `nth` column](#summary-all-in-nth-column)
    - [sum since nth line](#sum-since-nth-line)
    - [sum for each column](#sum-for-each-column)
  - [calculate word count in a file](#calculate-word-count-in-a-file)
  - [maximize & minimize](#maximize--minimize)
- [removal](#removal)
  - [remove non-duplicated lines](#remove-non-duplicated-lines)
  - [show matched values](#show-matched-values)
- [field](#field)
  - [multiple delimiters](#multiple-delimiters)
  - [field separator variable](#field-separator-variable)
  - [FS/OFS](#fsofs)
- [parser](#parser)
  - [csv](#csv)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [awk printf](http://kb.ictbanking.net/article.php?id=688)
> - [Gawk: Effective AWK Programming](https://www.gnu.org/software/gawk/manual/) | [pdf](https://www.gnu.org/software/gawk/manual/gawk.pdf)
>   -[gnu.org/manual](https://www.gnu.org/manual/)
> - [4.5 Specifying How Fields Are Separated](https://www.gnu.org/software/gawk/manual/html_node/Field-Separators.html)
> - [awk裡好用的變數：FS, OFS, RS, ORS, NR, NF, FILENAME, FNR](https://weitinglin.com/2016/10/17/awk%E8%A3%A1%E5%A5%BD%E7%94%A8%E7%9A%84%E8%AE%8A%E6%95%B8%EF%BC%9Afs-ofs-rs-ors-nr-nf-filename-fnr/comment-page-1/)
{% endhint %}

# output

> [!NOTE]
> - [AWK: Formatted printing](https://faculty.cs.niu.edu/~berezin/330/N/awk-printing.html)
> - [AWK Notebook: Index of /~berezin/330/N](https://faculty.cs.niu.edu/~berezin/330/N/)

## [convert row to column](https://unix.stackexchange.com/a/169997/29178)

> [!TIP|label:original content]
> ```bash
> $ cat sample.txt
> job salary
> c++ 13
> java 14
> php 12
> ```
> - [* An efficient way to transpose a file in Bash](https://stackoverflow.com/a/1729980/2940319)

```bash
$ awk '{
          for ( i=1; i<=NF; i++ ) arr[i] = (arr[i]? arr[i] FS $i: $i)
        } END {
          for ( i in arr ) print arr[i]
        }
      ' sample.txt

job c++ java php
salary 13 14 12
```

- or
  ```bash
  $ echo -e "job c++ java php\nsalary 13 14 12" |
    awk '{ for(i=1;i<=NF;i++) a[i][NR]=$i }
         END { for(i in a) for(j in a[i]) printf "%s"(j==NR?RS:FS), a[i][j] }
        ' "${1+FS=$1}" |
    column -t
  job   salary
  c++   13
  java  14
  php   12

  # or
  $ echo -e "job c++ java php\nsalary 13 14 12" |
    awk '{ for (i=1; i<=NF; i++) a[i,NR]=$i; max=(max<NF?NF:max) }
           END { for (i=1; i<=max; i++)
                 { for (j=1; j<=NR; j++) printf "%s%s", a[i,j], ( j==NR?RS:FS ) }
               }
        '
  job salary
  c++ 13
  java 14
  php 12
  ```

- or
  ```bash
  $ awk ' { for (i=1; i<=NF; i++)  {a[NR,i] = $i} }
            NF > p { p = NF }
            END { for(j=1; j<=p; j++) {
                    str=a[1,j]
                    for(i=2; i<=NR; i++){
                        str=str" "a[i,j];
                    }
                    print str
                  }
                }
        ' <<INPUT
  X column1 column2 column3
  row1 0 1 2
  row2 3 4 5
  row3 6 7 8
  row4 9 10 11
  INPUT

  X row1 row2 row3 row4
  column1 0 3 6 9
  column2 1 4 7 10
  column3 2 5 8 11
  ```

### [`rs -T`](https://stackoverflow.com/a/30173987/2940319)
```bash
$ rs -T -c, -C, <<INPUT
  a,b,c
  ,x,y
  11,22,33
  INPUT
a,,11,
b,x,22,
c,y,33,

# with default `-C`
$ rs -T -c, <<INPUT
a,b,c
,x,y
11,22,33
INPUT
a                                                       11
b                           x                           22
c                           y                           33
```

### [datamash](https://stackoverflow.com/a/34651095/2940319)

> [!NOTE|label:references:]
> - [GNU datamash](https://www.gnu.org/software/datamash/)
> - [GNU datamash - Examples](https://www.gnu.org/software/datamash/examples/)

```bash
$ echo -e "job c++ java php\nsalary 13 14 12" |
  datamash transpose -t ' ' |
  column -t
job   salary
c++   13
java  14
php   12
```

## reverse words

> [!NOTE]
> - [How to reverse a list of words in a shell string?](https://stackoverflow.com/questions/27703776/how-to-reverse-a-list-of-words-in-a-shell-string)
> - NOTE:
>   - `rev` not working since number will be reversed to different values
>     ```bash
>     $ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' | rev | column -t
>     02  226  0  0  5  5
>     8   934  0  2  3  6
>     21  054  0  3  2  5
>     ```
> - [How to reverse all the words in a file with bash in Ubuntu?](https://stackoverflow.com/a/40468021/2940319)
> - [Reversing the List of Words in a Bash String](https://www.baeldung.com/linux/bash-reverse-string-word-order)

```bash
$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' | column -t
  5  5  0  0  622  20
  6  3  2  0  439  8
  5  2  3  0  450  12

$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' |
  awk '{ for(i=NF;i>0;--i) printf "%s%s",$i,(i>1?OFS:ORS) }' |
  column -t
20  622  0  0  5  5
8   439  0  2  3  6
12  450  0  3  2  5

# or
$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' |
  awk '{ do printf "%s" (NF>1?FS:RS),$NF; while(--NF) }' |
  column -t
20  622  0  0  5  5
8   439  0  2  3  6
12  450  0  3  2  5

# or
$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' |
  awk '{ i=NF; while(i) printf "%s",$i (i-->1?FS:RS) }' |
  column -t
20  622  0  0  5  5
8   439  0  2  3  6
12  450  0  3  2  5

# or
$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' |
  awk '{ for (i=NF; i>1; i--) printf("%s ",$i); print $1; }' |
  column -t
20  622  0  0  5  5
8   439  0  2  3  6
12  450  0  3  2  5

# or
$ echo -e '5 5 0 0 622 20\n6 3 2 0 439 8\n5 2 3 0 450 12' |
  awk '{ for (i=NF; i>0; i--) printf("%s ",$i); printf("\n") }' |
  column -t
20  622  0  0  5  5
8   439  0  2  3  6
12  450  0  3  2  5
```

## align

> [!NOTE]
> - [format the shell script output as a table](https://unix.stackexchange.com/a/568130/29178)

### add header

> [!NOTE|label:references:]
> - [bash: how to add header to its corresponding lines](https://stackoverflow.com/a/46703062/2940319)
> - [How to add blank space in the middle of the line if the line is less than fixed length?](https://stackoverflow.com/a/65523122/2940319)
> - [Bash shell script output alignment](https://unix.stackexchange.com/a/396226/29178)

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

### right/left alignment
```bash
$ printf '|%-5s|\n' a ab abc abcd abcde
|a    |
|ab   |
|abc  |
|abcd |
|abcde|

$ printf '|%5s|\n' a ab abc abcd abcde
|    a|
|   ab|
|  abc|
| abcd|
|abcde|

$ printf '|%.5s|\n' a ab abc abcd abcde
|a|
|ab|
|abc|
|abcd|
|abcde|
```

### alignment with fixed column
```bash
$ cat -pp a.txt
ABCEFGH  K
ABCDE  FGH
ABCD  EFG
ABCDE FGH
ABCDE

$ awk -v tgt=10 'length($0)<tgt{gsub(/ /,""); $0=substr($0,1,4) sprintf("%*s",tgt-length($0),"") substr($0,5)} 1' a.txt
ABCEFGH  K
ABCDE  FGH
ABCD   EFG
ABCD  EFGH
ABCD     E

# or
$ awk -v l=10 -v i=4 'length($0)>=l{print; next}
                      {
                      gsub(/ /,"")
                      s1=substr($0,1,i)
                      s2=substr($0,i+1,length($0))
                      printf "%s%*s%s\n",s1,l-length($0)," ",s2
                      }' a.txt
```

### append space

> [!NOTE]
> - [How to add 100 spaces at end of each line of a file in Unix](https://stackoverflow.com/a/41000523/2940319)
> - [Find Longest Line in a .txt File and fill all Lines to that Length with 'blank Spaces'?]()

```bash
# 2 extra empty space, 22 chars per line in linux
$ cal | wc -L
22
$ cal | command cat -e
    January 2024      $
Su Mo Tu We Th Fr Sa  $
    1  2  3  4  5  6  $
 7  8  9 10 11 12 13  $
14 15 16 17 18 19 20  $
21 22 23 24 25 26 27  $
28 29 30 31           $

# remove trailing space and empty lines
$ cal | sed 's/[ \t]*$//' | sed '/^[[:space:]]*$/d' | command cat -e
    January 2024$
Su Mo Tu We Th Fr Sa$
    1  2  3  4  5  6$
 7  8  9 10 11 12 13$
14 15 16 17 18 19 20$
21 22 23 24 25 26 27$
28 29 30 31$

# append spaces to the length of longest line ( 20 )
$ cal | sed 's/[ \t]*$//' | sed '/^[[:space:]]*$/d' | awk '{printf "%-20s\n", $0}' | command cat -e
    January 2024    $
Su Mo Tu We Th Fr Sa$
    1  2  3  4  5  6$
 7  8  9 10 11 12 13$
14 15 16 17 18 19 20$
21 22 23 24 25 26 27$
28 29 30 31         $

# tput cub 20 works for every single lines
```

- and more
  ```bash
  $ command cat file
  jlsf
  slf
  asdfasfs
  sd

  $ awk 'FNR==NR{ t=(length>=t)?length:t;next }length<t{ for(o=1;o<=t-length;o++)s=s "|";$0=$0s;s="" }1' file file
  jlsf||||
  slf|||||
  asdfasfs
  sd||||||
  ```

### convert csv format
```bash
$ awk 'BEGIN {FS = ","; OFS = "\t"} {$1 = $1} 1' <<DATA
a,b,c
,x,y
dd,ee,ff
DATA
a   b   c
    x   y
dd  ee  ff
```


## split
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

## last n columns
### last 2 columns
```bash
$ echo {a..z} | xargs -n4
a b c d
e f g h
i j k l
m n o p
q r s t
u v w x
y z

$ echo {a..z} | xargs -n4 | awk '{ print $(NF-1), $NF }'
c d
g h
k l
o p
s t
w x
y z

# better solution
$ echo {a..z} | xargs -n5
a b c d e
f g h i j
k l m n o
p q r s t
u v w x y
z
$ echo {a..z} | xargs -n5 |
  awk 'NF == 1 { printf ("%3s", $NF) };
       NF >= 2 { print $(NF-1), $NF }
      '
d e
i j
n o
s t
x y
  z

# or `NF && NF-1`
$ echo {a..z} | xargs -n5 |
  awk 'NF == 1    { printf ("%3s", $NF) };
       NF && NF-1 { print $(NF-1), $NF }
      '
```

### second-to-last column ( `--NF` )
```bash
$ seq 12 | xargs -n5 | awk '{ NF--; print $NF }'
4
9
11
```

### [last N columns](https://askubuntu.com/a/863573/92979)
```bash
$ awk '{ print substr($0,index($0,$6)) }' <<INPUT
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
  c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
  INPUT
f6 f7 f8 f9 f10
c6 c7 c8 c9 c10

# or
$ awk '{for (i=6; i<=NF; i++) printf("%s%s", $i,(i==NF)? "\n" : OFS) }' <<INPUT
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
  c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
  INPUT
f6 f7 f8 f9 f10
c6 c7 c8 c9 c10

# or
$ awk '{ for(i=6;i<=NF;i++) printf $i" "; print "" }' <<INPUT
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
  c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
  INPUT
f6 f7 f8 f9 f10
c6 c7 c8 c9 c10

# or
$ awk '{ for(i=1;i<=5;i++) $i="";print }' <<INPUT
  f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
  c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
  INPUT
     f6 f7 f8 f9 f10
     c6 c7 c8 c9 c10
```

- via [`cut -f<n>-`](https://stackoverflow.com/a/32814062/2940319)
  ```bash
  $ cut -d" " -f6- <<INPUT
    f1 f2 f3 f4 f5 f6 f7 f8 f9 f10
    c1 c2 c3 c4 c5 c6 c7 c8 c9 c10
    INPUT
  f6 f7 f8 f9 f10
  c6 c7 c8 c9 c10
  ```

### [get major domain](https://unix.stackexchange.com/a/711622/29178)
```bash
$ echo -e 'a.domain.com\nb.domain.com\nc.domain.com' |
  awk -F. -v OFS='.' '{ print $(NF-1), $NF }'
domain.com
domain.com
domain.com
```

### trim

> [!NOTE|label:references:]
> - [How can I trim white space from a variable in awk?](https://stackoverflow.com/a/27158086/2940319)
>   - [andrewrcollins/trim.awk](https://gist.github.com/andrewrcollins/1592991)
> - [How can I keep the leading white spaces while removing last field in awk?](https://stackoverflow.com/q/59855038/2940319)

```bash
# original string
$ echo "man(1), apropos(1), whatis(1) - display online manual documentation pages" |
  awk -F"(\\\([0-9]\\\),?)" \
        '{ printf "|%s|", $NF }'
| - display online manual documentation pages|
#^ space here

# remove leading & trailing space
$ echo "man(1), apropos(1), whatis(1) - display online manual documentation pages" |
  awk -F"(\\\([0-9]\\\),?)" \
        '{ gsub(/^[ \t]+|[ \t]+$/, "", $NF); printf "|%s|", $NF}'
|- display online manual documentation pages|
#^ remove `-` and space after it

$ echo "man(1), apropos(1), whatis(1) - display online manual documentation pages" |
  awk -F"(\\\([0-9]\\\),?)" \
        '{ gsub(/^[ \t-?]+|[-? \t]+$/, "", $NF); printf "|%s|", $NF}'
|display online manual documentation pages|
```

# calculate
## length
### longest line

> [!NOTE]
> [Longest line in a file](https://stackoverflow.com/a/1655488/2940319)

```bash
$ cat -pp /tmp/terminal-1
    January 2024
Su Mo Tu We Th Fr Sa
    1  2  3  4  5  6
 7  8  9 10 11 12 13
14 15 16 17 18 19 20
21 22 23 24 25 26 27
28 29 30 31

$ wc -L /tmp/terminal-1
20 /tmp/terminal-1

$ awk '{ if (length($0) > max) {max = length($0); maxline = $0} } END { print maxline }' /tmp/terminal-1
Su Mo Tu We Th Fr Sa

$ awk '{print length, $0}' /tmp/terminal-1  | sort -nr
20 Su Mo Tu We Th Fr Sa
20  7  8  9 10 11 12 13
20 21 22 23 24 25 26 27
20 14 15 16 17 18 19 20
20     1  2  3  4  5  6
16     January 2024
11 28 29 30 31
```

### longest filename
```bash
# in repo
$ fd | awk '{ print length " | " $0 }' | sort -rn | head -3
98 | programming/archive/maven/hello-world/src/main/java/com/juvenxu/mvnbook/helloworld/HelloWorld.java
83 | programming/archive/maven/hello-world/src/main/java/com/juvenxu/mvnbook/helloworld/
72 | programming/archive/maven/hello-world/src/main/java/com/juvenxu/mvnbook/

$ fd | awk '{ if (length($0) > max){ max = length($0); line = $0} } END { print max " | " line }'
98 | programming/archive/maven/hello-world/src/main/java/com/juvenxu/mvnbook/helloworld/HelloWorld.java
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


## sum

> [!NOTE|label:references:]
> - [Summing values of a column using awk command](https://stackoverflow.com/a/28445186/2940319)

### base on other column

> [!NOTE]
> - [Sum First Column on basis of Second Column](https://unix.stackexchange.com/a/419996/29178)

```bash
#  `substr` to get 4-last chars of string `n--xxxx`
#                     v
$ awk 'NR > 1 { k = substr($2, 4); cnt[k] += $1 } { print }
       END
       { print "\nTOTAL:"; for (k in cnt) print cnt[k], k }
      ' <<INPUT
  No.ofRecord    FileName                   delimiter
  563394         1--UnixfileName.txt        28
  364794         2--UnixfileName.txt        28
  785895         3--UnixfileName.txt        28
  99778453       1--NextUnixFileName.txt    18
  95645453       2--NextUnixFileName.txt    18
  99745313       3--NextUnixFileName.txt    18
  INPUT

No.ofRecord    FileName                   delimiter
563394         1--UnixfileName.txt        28
364794         2--UnixfileName.txt        28
785895         3--UnixfileName.txt        28
99778453       1--NextUnixFileName.txt    18
95645453       2--NextUnixFileName.txt    18
99745313       3--NextUnixFileName.txt    18

TOTAL:
295169219 NextUnixFileName.txt
1714083 UnixfileName.txt
```

#### [sum $3 base on $1,$2](https://stackoverflow.com/a/6970077/2940319)
```bash
$ awk -F, '{array[$1","$2]+=$3} END { for (i in array) {print i"," array[i]}}' <<INPUT
  P1,gram,10
  P1,tree,12
  P1,gram,34
  P2,gram,23
  INPUT

P1,gram,44
P1,tree,12
P2,gram,23
```

#### sum $2 base on $1
```bash
$ awk '{array[$1]+=$2} END { for (i in array) {print i, "\t", array[i]} }' <<INPUT
 .sh 23
 .py 100
 .sh 10
 .py 5
 .c 43
 INPUT

.c   43
.sh  33
.py  105

# central alignment
$ awk '{array[$1]+=$2} END { for (i in array) {printf ("%10s | %s\n", i, array[i])} }' <<INPUT
 .sh 23
 .py 100
 .sh 10
 .py 5
 .c 43
 INPUT
        .c | 43
       .sh | 33
       .py | 105
```

### sum lines by extension
```bash
$ fd --type f | xargs wc -l
  375 chars.md
  544 date.md
   25 date.sh
  255 params.md
   58 progressBar.sh
   15 progressBar2.sh
  205 tricky.md
  476 util.md
 1953 total

$ fd --type f |
  xargs wc -l |
  tac |
  sed -re 's/\s*([0-9]+)\s*[^\.]+(\.\w+)$/\1 \2/g' |
  awk 'NR == 1 { print }
       NR > 1  { array[$2]+=$1 } END { for (i in array) {printf ("%10s | %s\n", i, array[i])} }
      '
 1953 total
       .sh | 98
       .md | 1855

# another
$ fd --type f |
  xargs wc -l |
  tac |
  sed -re 's/\s*([0-9]+)\s*[^\.]+(\.\w+)$/\1 \2/g' |
  awk 'NR == 1 { print }
       NR > 1  { a[$NF]+=$1 } END { for(i in a){print i,a[i]} }
      '
```

### summary mem for all users (`ps aux`)
```bash
$ awk '{sum += $1} END {print sum}' < <(ps -u marslo -o pmem)
```
- or
  ```bash
  $ ps -u marslo -o pcpu,pmem,pid,command |
       awk '{sum += $2} END {print sum}'
  ```

### summary all in `nth` column
```bash
$ echo 'chr19   10 11
        chr19   12 15
        chr19   11 29
        chr19   a0 20
       ' |
  awk '{SUM+=$3}END{print SUM}'
75

# alternative
$ echo 'chr19   10 11
        chr19   12 15
        chr19   11 29
        chr19   a0 20
       ' |
  awk '{count=count+$NF}END{print count}'           # the last column
# or
$ echo 'chr19   10 11
        chr19   12 15
        chr19   11 29
        chr19   a0 20
       ' |
  awk '{count=count+$3}END{print count}'            # the 3rd column
```

### sum since nth line
```bash
$ echo 'chr19   10 11
        chr19   12 15
        chr19   11 29
        chr19   a0 20
       ' |
  awk 'NR>1 {SUM+=$3}END{print SUM}
64
```

### sum for each column

> [!NOTE|label:references:]
> - [Calculate the sum](https://stackoverflow.com/a/68855072/2940319)
>   ```bash
>   $ cat budget.txt
>   Budget Jan Feb Mar Apr May Jun Sun
>   Mike   10  20  31  52  7   11
>   Eggs   1   5   1   16  4   58
>   Bread  22  36  17  8   21  16
>   Butter 4   5   8   11  36  2
>   Total
>   ```

```bash
$ cat budget.txt |
  awk 'NR==1{print} NR>1 && $0!="Total" { rsum=0;for(i=2;i<=NF;i++){ a[i]+=$i;rsum+=$i }; printf "%s\t%3d\n",$0,rsum; fc=NF; a[NF+1]+=rsum } $1=="Total" { printf "Total\t";for(i=2;i<=fc;i++){ printf "%3d\t",a[i] }; printf "%3d\n",a[fc+1] }' |
  column -t
Budget  Jan  Feb  Mar  Apr  May  Jun  Sun
Mike    10   20   31   52   7    11   131
Eggs    1    5    1    16   4    58   85
Bread   22   36   17   8    21   16   120
Butter  4    5    8    11   36   2    66
Total   37   66   57   87   68   87   402

# better format
$ cat budget.txt |
  awk 'NR==1 { print }
       NR>1 && $0!="Total" { rsum=0; for(i=2;i<=NF;i++){ a[i]+=$i;rsum+=$i }; printf ( "%s\t%3d\n",$0,rsum ); fc=NF; a[NF+1]+=rsum }
       $1=="Total" { printf "Total\t"; for(i=2;i<=fc;i++){ printf "%3d\t",a[i] }; printf ( "%3d\n",a[fc+1] ) }
      ' |
  column -t
```

## calculate word count in a file
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

## maximize & minimize

- [maximize and second maximize](https://unix.stackexchange.com/a/333312/29178)
  ```bash
  $ awk '{ for(i=1;i<=NF;i++) if($i>maxval) maxval=$i; }
           NR%4==0 { print maxval ; maxval= -1}' <<INPUT
      1 2 3
    4 5 6 7 7
    9 7 7 6 5
      4 3 2
      1 2 3
    4 6 7 7 7
    7 7 7 6 5
      4 3 2
  INPUT

  9
  7

  # alternative using array
  $ awk '{ x=split($0,a);asort(a);if(a[x]>maxval)maxval=a[x] }
           NR%4==0 { print maxval ; maxval= -1}'
  ```

# removal
## remove non-duplicated lines
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

## show matched values
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

# field

## multiple delimiters

> [!NOTE]
> - [multiple Field Separators in awk](https://stackoverflow.com/a/15665156/2940319)
> - [Using Multiple Delimiters in Awk](https://www.baeldung.com/linux/awk-several-delimiters)

- `-F"[..]"`
  ```bash
  $ echo "  man(1), apropos(1), whatis(1) - display online manual documentation pages" |
    awk -F"[,-]" '{print $1, "\n", $2, "\n", $3, "\n", $4}'
    man(1)
    apropos(1)
    whatis(1)
    display online manual documentation pages
  ```

- `-F"(..)"`

  > [!TIP]
  > the `\` should be `\\\` in "(..)"

  ```bash
  $ echo "man(1), apropos(1), whatis(1) - display online manual documentation pages" |
    awk -F"(\\\([0-9]\\\),?)" \
        '{ for(i=1;i<NF;i++) {
             sub(/ +/, "", $i);
             sub(/ +-? +/, "", $NF);
             if (length($i) != 0) printf ("%s - %s\n", $i, $NF)
         } }'
  man - display online manual documentation pages
  apropos - display online manual documentation pages
  whatis - display online manual documentation pages
  ```

  - simprude solution
    ```bash
    # remove everything between/include first `(` to last `)`
    $ echo "man(1), apropos(1), whatis(1) - display online manual documentation pages" |
      sed -r 's/(\(.+\))//g'
    man - display online manual documentation pages
    ```

- `-F'..'`
  ```bash
  $ echo '-foo {{0.000 0.000} {648.0 0.000} {648.0 1980.0} {0.000 1980.0} {0.000 0.000}}' |
    awk -F'}+|{+| ' '{for (i=1; i<=NF; i++) if ($i ~ "[0-9]") print $i}'
  0.000
  0.000
  648.0
  0.000
  648.0
  1980.0
  0.000
  1980.0
  0.000
  0.000
  ```

- `BEGIN{ FS=".." }`
  ```bash
  $ echo '-foo {{0.000 0.000} {648.0 0.000} {648.0 1980.0} {0.000 1980.0} {0.000 0.000}}' |
    awk 'BEGIN{FS="}+|{+| "} {for(i=1;i<=NF;i++) if($i ~ "[0-9]")print $i}'
  ```

## field separator variable
- multiple separators

  > [!NOTE|label:multiple separators]
  > - [Two field separators (colon and space) in awk](https://unix.stackexchange.com/a/515679/29178)
  > - [How to match space or \s via regex in awk](https://stackoverflow.com/a/71136187/2940319)
  > - [8 Powerful Awk Built-in Variables – FS, OFS, RS, ORS, NR, NF, FILENAME, FNR](https://www.thegeekstuff.com/2010/01/8-powerful-awk-built-in-variables-fs-ofs-rs-ors-nr-nf-filename-fnr/?ref=binfind.com/web)
  > - [How to split a delimited string into an array in awk?](https://stackoverflow.com/a/36211699/2940319)
  > - [Retrieve information Text/Word from HTML code using awk/sed](https://www.unix.com/302897228-post6.html)
  > - [How to use a shell command to only show the first column and last column in a text file?](https://unix.stackexchange.com/a/136886/291780)
  >   - `FS`: Input field separator variable
  >   - `OFS`: Output Field Separator Variable
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

## FS/OFS
```bash
$ echo 'foo|dog|cat|mouse|lion|ox|tiger|bar' | awk -v 'FS=|' -v 'OFS=,' '{print $1, $NF}'
foo,bar
# or
$ echo 'foo|dog|cat|mouse|lion|ox|tiger|bar' | awk 'BEGIN {FS="|"; OFS="\t"} {print $1, $NF}'
foo   bar

# FS same with OFS
$ echo 'foo|dog|cat|mouse|lion|ox|tiger|bar' | awk 'BEGIN {FS = OFS = "|"} {print $1, $NF}'
foo|bar
```

# parser

## csv

> [!NOTE|label:references:]
> - [geoffroy-aubry/awk-csv-parser](https://github.com/geoffroy-aubry/awk-csv-parser)
> - [AWK CSV Parser](http://lorance.freeshell.org/csv/)
> - [Parse a csv using awk and ignoring commas inside a field](https://stackoverflow.com/questions/4205431/parse-a-csv-using-awk-and-ignoring-commas-inside-a-field)
> - [Output in CSV format using AWK command](https://unix.stackexchange.com/questions/710558/output-in-csv-format-using-awk-command)
