<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [sum](#sum)
  - [awk](#awk)
  - [datamash](#datamash)
  - [bc](#bc)
  - [jq](#jq)
  - [`$(())`](#)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## sum

> [!INFO]
> references:
> - [Shell command to sum integers, one per line?](https://stackoverflow.com/a/25245025/2940319)
> - [Summing a List of Numbers](https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch07s13.html)

### awk
```bash
$ seq 10 | awk '{s+=$1} END {print s}'
55

# or
$ awk 'BEGIN{print '"1+2+3"'}'
6
```

#### file sizes
```bash
$ ls -l
total 12
-rw-r--r--  1 marslo staff 3480 Dec 21 21:21 README.md
-rw-r--r--  1 marslo staff 7516 Dec 21 21:21 SUMMARY.md
drwxr-xr-x  7 marslo staff  224 Sep 19 19:52 artifactory
drwxr-xr-x 15 marslo staff  480 Dec 21 21:19 cheatsheet
drwxr-xr-x 12 marslo staff  384 Aug 17 21:11 devops
drwxr-xr-x  9 marslo staff  288 Sep 29 17:31 jenkins
drwxr-xr-x 10 marslo staff  320 Sep 19 19:52 linux
drwxr-xr-x  9 marslo staff  288 Sep 19 19:52 osx
drwxr-xr-x  6 marslo staff  192 Aug 17 21:11 programming
drwxr-xr-x 27 marslo staff  864 Aug 17 22:10 screenshot
drwxr-xr-x  7 marslo staff  224 Oct 11 19:41 tools
drwxr-xr-x  8 marslo staff  256 Aug 30 16:39 vim
drwxr-xr-x  5 marslo staff  160 Aug 17 21:11 virtualization

$ ls -l | awk '{sum += $5} END {print sum}'
14676
```

### datamash

> [!TIP]
> reference:
> - [Shell command to sum integers, one per line?](https://stackoverflow.com/a/55392673/2940319)

```bash
$ seq 10 | datamash sum 1
55
```

### bc
```bash
$ seq 10 | paste -sd+ -
1+2+3+4+5+6+7+8+9+10

$ seq 10 | paste -sd+ - | bc
55
```

- [or](https://stackoverflow.com/a/23835376/2940319)
  ```bash
  $ seq 10 | xargs printf "- - %s" | xargs  | bc
  55
  ```

- [or](https://stackoverflow.com/a/453325/2940319)
  ```bash
  $ seq 10 | sed 's/^/.+/' | bc
  1
  3
  6
  10
  15
  21
  28
  36
  45
  55
  ```

### jq
```bash
$ seq 10 | jq -s 'add'
55
```

### [`$(())`](https://stackoverflow.com/a/13969439/2940319)
```bash
$ f=$(seq 10)
$ echo $(( ${f//$'\n'/+} ))
55

# or
$ echo $(( $(seq 10 | tr "\n" "+") 0 ))
55
# or from file
$ echo $(( $( tr "\n" "+"  < /tmp/test) 0 ))
```
