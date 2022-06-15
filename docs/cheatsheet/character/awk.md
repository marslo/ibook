<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [split](#split)
- [print chars and length](#print-chars-and-length)
- [summary all user used memory (`ps aux`)](#summary-all-user-used-memory-ps-aux)
- [calculate word count in a file](#calculate-word-count-in-a-file)
- [remove non-duplicated lines](#remove-non-duplicated-lines)
- [show matched values](#show-matched-values)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [awk printf](http://kb.ictbanking.net/article.php?id=688)
{% endhint %}

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
  $ awk '{for(w=1;w<=NF;w++) print $w}' sample.txt |
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
