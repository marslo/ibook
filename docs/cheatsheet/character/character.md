<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get line after the pattern](#get-line-after-the-pattern)
- [get certain Line between 2 matched patterns](#get-certain-line-between-2-matched-patterns)
  - [working with empty line](#working-with-empty-line)
- [`xargs`](#xargs)
  - [multiple move](#multiple-move)
  - [subset of arguments](#subset-of-arguments)
  - [sort all shell script by line number](#sort-all-shell-script-by-line-number)
  - [diff every git commit against its parent](#diff-every-git-commit-against-its-parent)
  - [Running multiple commands with xargs](#running-multiple-commands-with-xargs)
  - [convert row to column](#convert-row-to-column)
- [`find`](#find)
  - [cat config file in all `.git` folder](#cat-config-file-in-all-git-folder)
  - [`find` && `tar`](#find--tar)
  - [tar all and extra in remote](#tar-all-and-extra-in-remote)
  - [`exec` and `sed`](#exec-and-sed)
  - [find and rename](#find-and-rename)
  - [find and exclude](#find-and-exclude)
- [awk](#awk)
  - [print chars and length](#print-chars-and-length)
  - [summary all user used memory (`ps aux`)](#summary-all-user-used-memory-ps-aux)
  - [calculate word count in a file](#calculate-word-count-in-a-file)
  - [remove non-duplicated lines](#remove-non-duplicated-lines)
- [trim](#trim)
  - [trim tailing chars](#trim-tailing-chars)
  - [remove leading & trailing whitespace](#remove-leading--trailing-whitespace)
  - [search and replace](#search-and-replace)
  - [replace with position](#replace-with-position)
- [fold](#fold)
  - [check the params valid](#check-the-params-valid)
- [regex](#regex)
  - [get URL](#get-url)
- [insert new line](#insert-new-line)
- [write a file without indent space](#write-a-file-without-indent-space)
- [cat](#cat)
  - [`<< -` and `<<`](#---and-)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [10 Awk Tips, Tricks and Pitfalls](https://catonmat.net/ten-awk-tips-tricks-and-pitfalls)
> - [FIND -EXEC VS. FIND | XARGS](https://www.everythingcli.org/find-exec-vs-find-xargs/)

## get line after the pattern
```bash
$ cat a.txt
1a
2b
3c        * (2 lines after `^3c$`)
4d
5e
6f
7g
```
- awk
  ```bash
  $ cat a.txt | awk '$0=="3c"{getline; print; getline; print}'
  4d
  5e

  $ cat a.txt | awk '/3c/{getline; print; getline; print}'
  4d
  5e
  ```

  or
  ```bash
  $ cat a.txt | awk '/^3c$/ {s=NR;next} s && NR<=s+2'
  4d
  5e
  ```

  or
  ```bash
  $ cat a.txt | awk '{if(a-->0){print;next}} /3c/{a=2}'
  4d
  5e
  ```

  or get second column of next line of pattern
  ```bash
  $ awk '/my.company.com$/{getline; print}' ~/.marslo/.netrc
  login marslo

  $ awk '/my.company.com$/{getline; print $2}' ~/.marslo/.netrc
  marslo
  ```


- sed
  ```bash
  $ cat a.txt | sed -n '/3c/{n;p;n;p}'
  4d
  5e

  $ cat a.txt | sed -n '/3c/{N;p;n;p}'
  3c
  4d
  5e
  ```

## get certain Line between 2 matched patterns
> reference:
> - [How to print lines between two patterns, inclusive or exclusive (in sed, AWK or Perl)?](https://stackoverflow.com/a/58568587/2940319)
> - [Print lines between PAT1 and PAT2](https://stackoverflow.com/a/55773449/2940319)
> - [How to select lines between two marker patterns which may occur multiple times with awk/sed](https://stackoverflow.com/a/17988834/2940319)
> - [Print lines between (and excluding) two patterns](https://unix.stackexchange.com/a/430154/29178)

```bash
$ cat a.txt
1a
2b
3c        * (begining)
4d
5e
6f
7g
8h        * (end)
9i
10j
11k
```

- awk
  - include pattern
    ```bash
    $ cat a.txt | awk '/3c/,/8h/'
    3c
    4d
    5e
    6f
    7g
    8h
    ```
- sed
  - don't include pattern
    ```bash
    $ cat a.txt | sed '1,/3c/d;/8h/,$d'
    4d
    5e
    6f
    7g

    $ cat a.txt | sed '/3c/,/8h/!d;//d'
    4d
    5e
    6f
    7g
    ```
  - include the pattern
    ```bash
    $ cat a.txt | sed -n '/3c/,/8h/p'
    3c
    4d
    5e
    6f
    7g
    8h
    ```

### working with empty line
```bash
$ cat a.txt
1a
2b
3c      * (begining)
4d
5e
6f
        * (ending)
7g
8h
9i
10j
11k

$ cat a.txt | sed -n '/3c/,/^$/p'
3c
4d
5e
6f
```

## `xargs`
> references:
> - [xargs](https://en.wikipedia.org/wiki/Xargs)
> - [Running multiple commands with xargs](https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs)

### [multiple move](https://en.wikipedia.org/wiki/Xargs#Placement_of_arguments)
```bash
$ mkdir ~/backups
$ find /path -type f -name '*~' -print0 | xargs -0 -I % cp -a % ~/backups
```

```bash
# multiple cp
$ find /path -type f -name '*~' -print0 | xargs -0 sh -c 'if [ $# -gt 0 ]; then cp -a "$@" ~/backup; fi' sh
```

### [subset of arguments](https://en.wikipedia.org/wiki/Xargs#Operating_on_a_subset_of_arguments_at_a_time)
```bash
$ echo {0..9} | xargs -n 2
0 1
2 3
4 5
6 7
8 9
```

### sort all shell script by line number
> [Pipe `xargs` into `find`](http://xion.io/post/code/shell-xargs-into-find.html)

```bash
$ find . -name "*.sh" | xargs wc -l | sort -hr
```

### diff every git commit against its parent
```bash
$ git log --format="%H %P" | xargs -L 1 git diff
```

### [Running multiple commands with xargs](https://stackoverflow.com/questions/6958689/running-multiple-commands-with-xargs)
> precondition:
> ```bash
> $ cat a.txt
> a b c
> 123
> ###this is a comment
> ```

```bash
$ myCommandWithDifferentQuotes=$(cat <<'EOF'
  -> echo "command 1: $@"; echo 'will you do the fandango?'; echo "command 2: $@"; echo
  -> EOF
  -> )

$ < a.txt xargs -I @@ bash -c "$myCommandWithDifferentQuotes" -- @@
command 1: a b c
will you do the fandango?
command 2: a b c

command 1: 123
will you do the fandango?
command 2: 123

command 1: ###this is a comment
will you do the fandango?
command 2: ###this is a comment
```

- or
  ```bash
  $ cat a.txt | xargs -I @@ bash -c "$myCommandWithDifferentQuotes" -- @@
  ```
- [or](https://stackoverflow.com/a/6959074/2940319)
  ```bash
  $ while read stuff; do
    ->   echo "command 1: $stuff";
    ->   echo 'will you do the fandango?';
    ->   echo "command 2: $stuff";
    ->   echo
    -> done < a.txt
  ```

#### compress sub-folders
```bash
$ find . -maxdepth 1 ! -path . -type d -print0 \
       | xargs -0 -I @@ bash -c '{ \
           tar caf "@@.tar.lzop" "@@" \
           && echo Completed compressing directory "@@" ; \
         }'
```

#### execute commands from file
- [create files](https://linuxize.com/post/linux-xargs-command/)
  > ```bash
  > -t, --verbose
  >           Print the command line on the standard error output before executing it.
  > -p, --interactive
  >           Prompt  the  user  about  whether to run each command line and read a line from the terminal.
  >           Only run the command line if the response starts with `y' or `Y'.  Implies -t.
  > -I replace-str
  >           Replace occurrences of replace-str in the initial-arguments with names read from standard in-
  >           put.  Also, unquoted blanks do not terminate input items; instead the separator is  the  new-
  >           line character.  Implies -x and -L 1.
  > ```
  >

  > precondition
  > ```bash
  > $ cat a.txt
  > a b c
  > ```

  ```bash
  $ echo 'a b c'
  a b c
  $ echo 'a b c' | xargs -n1
  a
  b
  c

  $ echo 'a b c' | xargs -n1 -t touch
  touch a
  touch b
  touch c
  $ echo 'a b c' | xargs -n1 -p touch
  touch a ?...y
  ```
- [or `fmt`](https://unix.stackexchange.com/a/170008/29178)
  ```bash
  $ echo 'a b c' | fmt -1
  a
  b
  c
  ```

- [or `awk`](https://unix.stackexchange.com/a/169996/29178)
  ```bash
  $ echo 'a b c' | awk '{OFS=RS;$1=$1}1'
  a
  b
  c
  ```

- or `tr`
  ```bash
  $ echo 'a b c' | tr -s ' ' '\n'
  a
  b
  c
  ```

### [convert row to column](https://unix.stackexchange.com/a/169997/29178)
```bash
awk '{
  for (i=1; i<=NF; i++) arr[i]= (arr[i]? arr[i] FS $i: $i) }
  END{ for (i in arr) print arr[i]
}' sample.txt
```

- result
  ```bash
  $ cat sample.txt
  job salary
  c++ 13
  java 14
  php 12

  $ awk '{
    for (i=1; i<=NF; i++) arr[i]= (arr[i]? arr[i] FS $i: $i) }
    END{ for (i in arr) print arr[i]
  }' sample.txt
  job c++ java php
  salary 13 14 12
  ```

#### ping multiple ips
```bash
$ cat a.txt
8.8.8.8
1.1.1.1

$ xargs -L1 -a a.txt /sbin/ping -c 1
PING 8.8.8.8 (8.8.8.8): 56 data bytes
64 bytes from 8.8.8.8: icmp_seq=0 ttl=44 time=82.868 ms
--- 8.8.8.8 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 82.868/82.868/82.868/0.000 ms

PING 1.1.1.1 (1.1.1.1): 56 data bytes
64 bytes from 1.1.1.1: icmp_seq=0 ttl=63 time=1.016 ms
--- 1.1.1.1 ping statistics ---
1 packets transmitted, 1 packets received, 0.0% packet loss
round-trip min/avg/max/stddev = 1.016/1.016/1.016/0.000 ms
```

## `find`
### cat config file in all `.git` folder
- `xargs` && `cat`
  ```bash
  $ find . -type d -name '.git' -print0 | xargs -0 -I {} cat {}/config
  ```

- `find` && `-exec`
  ```bash
  $ find . -type d -name '.git' -exec cat {}/config \;
  ```

### `find` && `tar`
- backup all `config.xml` in JENKINS_HOME
  ```bash
  $ find ${JENKINS_HOME}/jobs -maxdepth 2 -name config\.xml -type f -print | tar czf ~/config.xml.tar.gz --files-from -
  ```

- back build history
  ```bash
  $ find ${JENKINS_HOME}/jobs -name builds -prune -o -type f -print | tar czf ~/m.tar.gz --files-from -
  ```

### tar all and extra in remote
```bash
# ssh -C
$ tar cf - . | ssh -C hostname "cd ~/.marslo/test/; tar xvf -"
Warning: Permanently added '10.69.78.40' (ECDSA) to the list of known hosts.
./
./temp/
./a/
./a/a.txt
./c/
./b/
```

or
```bash
# tar z-flag
$ tar cfz - . | ssh hostname "cd ~/.marslo/test/; tar xvzf -"
```
- [copy multiple files to remote server](https://superuser.com/a/116031/112396)
  ```bash
  $ tar cvzf - -T list_of_filenames | ssh hostname tar xzf -
  ```

### `exec` and `sed`
- change bunches ip address
  ```bash
  $ find ${JENKINS_HOME}/jobs \
         -type f \
         -name "config.xml" \
         -maxdepth 2 \
         -exec sed -i 's/1.2.3./4.5.6./g' {} \; -print
  ```

### find and rename
```bash
$ find -iname "*.sh" -exec rename "s/.sh$/.shell/" {} \; -print
```

### [find and exclude](https://stackoverflow.com/a/60439808/2940319)
```bash
$ find . -regextype posix-egrep -regex ".*\.(js|vue|s?css|php|html|json)$" -and -not -regex ".*/(node_modules|vendor)/.*" 
```
- [or](https://stackoverflow.com/a/25113492/2940319)
  ```bash
  $ find . -regex-type posix-extended -regex ".*def/incoming.*|.*456/incoming.*" -prune -o -print 
  ```

## awk
### print chars and length
```bash
$ awk '{ for(i=1; i<=NF; i++){print $i, length($i)} }' sample.txt
```
- or using while
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
$ awk '{print $1}' sample.txt | sort | uniq -cd | sort -g
```

- or
  ```bash
  $ awk '{arr[$1]++}END{for (key in arr){if (arr[key] > 1){print arr[key],key}}}' sample.txt
  ```

- [show only duplicated lines](https://superuser.com/a/1107659/112396)
  ```bash
  $ awk 'seen[$1]++' sample.txt
  ```
  - show only non-duplicated lines
    ```bash
    $ awk '!seen[$1]++' sample.txt
    ```

## trim
### trim tailing chars
> ```bash
> str='1234567890'
> ```

- `awk` + `rev`
  ```bash
  $ echo $str | rev | cut -c4- | rev
  1234567
  ```

- `${var:: -x})`
  ```bash
  $ echo ${str:: -3}
  1234567
  ```

### [remove leading & trailing whitespace](https://stackoverflow.com/a/11791508/2940319)
```bash
$ str="    aaaa    bbbb      "
$ echo "$str" | sed 's:^ *::; s: *$::'

# i.e.:
$ echo .$(echo "$str" | sed 's:^ *::; s: *$::').
.aaaa bbbb.
```

- remove all spaces
  ```bash
  $ echo .${str// }.
  .aaaabbbb.
  ```

- [remove leading space(s)](https://stackoverflow.com/a/7486606/2940319)
  ```bash
  $ echo .${str##+([[:space:]])}.
  .aaaa bbbb .
  ```

- [remove leading space(s)](https://stackoverflow.com/a/7486606/2940319)
  ```bash
  $ echo .${str%%+([[:space:]])}.
  . aaaa bbbb.
  ```

### [search and replace](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
> reference:
> [shellcheck SC2001](https://github.com/koalaman/shellcheck/wiki/SC2001)
>
> ```bash
> str='aa  bb      cc'
> ```

- `${variable//search/replace}`
  ```bash
  $ shopt -s extglob
  $ echo ${str//+( )/|}
  aa|bb|cc
  ```

  [or](https://stackoverflow.com/a/50259959/2940319)
  ```bash
  $ echo "${str//+([[:blank:]])/|}"
  aa|bb|cc
  ```

- sed
  ```bash
  # DO NOT USE "${str}"
  $ echo ${str} | sed 's: :|:g'
  aa|bb|cc
  ```

  [or](https://stackoverflow.com/a/50260434/2940319)
  ```bash
  $ echo "$str" | sed 's:[ ][ ]*:|:g'
  aa|bb|cc

  # or
  $ echo "$str" | sed 's:\s\s*:|:g'
  aa|bb|cc
echo "${string:0:$(( position - 1 ))}${replacement}${string:position}"
  # or
  $ sed 's:\s\s*:|:g' <<< "${str}"
  aa|bb|cc
  ```

- [tr](https://stackoverflow.com/a/50259880/2940319)
  ```bash
  $ echo "$str" | tr -s ' ' '|'
  aa|bb|cc
  ```

### [replace with position](https://stackoverflow.com/a/54680736/2940319)
```bash
$ string=aaaaa
$ replacement=b
$ position=3
$ echo "${string:0:$(( position - 1 ))}${replacement}${string:position}"
aabaa
```
or
```bash
$ echo "${string:0:position-1}${replacement}${string:position}"
aabaa
```

## fold
### check the params valid
{% hint style='tip' %}
available params should be contained by 'iwfabcem'
{% endhint %}

```bash
# case insensitive
param=$( tr '[:upper:]' '[:lower:]' <<< "$1" )

for _p in $(echo "${param}" | fold -w1); do
  [[ ! 'iwfabcem' =~ ${_p} ]] && exits='yes' && break
done
```

## regex

### get URL
```bash
$ echo http://www.baidu.com | awk '{for(i=1;i<=NF;i++){if($i~/^(http|ftp):\/\//)print $i}}'
http://www.baidu.com
```

## insert new line
- insert right after the second match string
{% codetabs name="original", type="bash" -%}
DCR
DCR
DCR
{%- language name="expected", type="bash" -%}
DCR
DCR
check
DCR
{%- endcodetabs %}

```bash
$ echo -e "DCR\nDCR\nDCR" |awk 'BEGIN {t=0}; { print }; /DCR/ { t++; if ( t==2) { print "check" } }'
```

## write a file without indent space
```bash
$ sed -e 's:^\s*::' > ~/file-without-indent-space.txt < <(echo "items.find ({
      \"repo\": \"my-repo\",
      \"type\" : \"folder\" ,
      \"depth\" : \"1\",
      \"created\" : { \"\$before\" : \"4mo\" }
    })
")

$ cat ~/file-without-indent-space.txt
items.find ({
"repo": "my-repo",
"type" : "folder" ,
"depth" : "1",
"created" : { "$before" : "4mo" }
})
```

- or
  ```bash
  $ sed -e 's:^\s*::' > find.aql <<-'EOF'
                      items.find ({
                        "repo": "${product}-${stg}-local",
                        "type" : "folder" ,
                        "depth" : "1",
                        "created" : { "${opt}": "4mo" }
                      })
  EOF
  ```
{% codetabs name="example", type="bash" -%}
$ sed -e 's:^\s*::' <<-'EOF'
                      items.find ({
                        "repo": "${product}-${stg}-local",
                        "type" : "folder" ,
                        "depth" : "1",
                        "created" : { "${opt}": "4mo" }
                      })
EOF
items.find ({
"repo": "${product}-${stg}-local",
"type" : "folder" ,
"depth" : "1",
"created" : { "${opt}": "4mo" }
})
{%- endcodetabs %}


## cat
### `<< -` and `<<`

<!--sec data-title="doc for <<[-]word" data-id="section0" data-show=true data-collapse=true ces-->
 [Here Documents](https://en.wikipedia.org/wiki/Here_document#Unix_shells):
> This type of redirection instructs the shell to read input from the current source until a line containing only delimiter (with no trailing blanks) is seen. All of the lines read up to that point are then used as the standard input for a command.
>
> The format of here-documents is:
> ```bash
>       <<[-]word
>               here-document
>       delimiter
>```
> No parameter expansion, command substitution, arithmetic expansion, or pathname expansion is performed on word. If any characters in word are quoted, the delimiter is the result of quote removal on word, and the lines in the here-document are not expanded. If word is unquoted, all lines of the here-document are subjected to parameter expansion, command substitution, and arithmetic expansion. In the latter case, the character sequence \ is ignored, and \ must be used to quote the characters \, $, and `.
<!--endsec-->

- cat with specific character
  > ```bash
  > $ man tab
  > ...
  >       -T, --show-tabs
                display TAB characters as ^I
  > ```

- other references:
  > - [Multi-line string with extra space (preserved indentation)](https://stackoverflow.com/questions/23929235/multi-line-string-with-extra-space-preserved-indentation)
  > - [Bash - Removing white space from indented multiline strings](https://stackoverflow.com/questions/46537619/bash-removing-white-space-from-indented-multiline-strings)
  > - [How to avoid heredoc expanding variables? [duplicate]](https://stackoverflow.com/questions/27920806/how-to-avoid-heredoc-expanding-variables)

{% codetabs name="<< -", type="bash" -%}
$ cat -A sample.sh
LANG=C tr a-z A-Z <<- END_TEXT$
Here doc with <<$
 A single space character (i.e. 0x20 )  is at the beginning of this line$
^IThis line begins with a single TAB character i.e 0x09 as does the next line$
^IEND_TEXT$
$
echo The intended end was before this line$

$ bash sample.sh
HERE DOC WITH <<-
 A SINGLE SPACE CHARACTER (I.E. 0X20 )  IS AT THE BEGINNING OF THIS LINE
THIS LINE BEGINS WITH A SINGLE TAB CHARACTER I.E 0X09  AS DOES THE NEXT LINE
The intended end was before this line

{%- language name="<<", type="bash" -%}
$ cat -A sample.sh
LANG=C tr a-z A-Z << END_TEXT$
Here doc with <<$
 A single space character (i.e. 0x20 )  is at the beginning of this line$
^IThis line begins with a single TAB character i.e 0x09 as does the next line$
^IEND_TEXT$
$
echo The intended end was before this line$

$ bash sample.sh
sample.sh: line 7: warning: here-document at line 1 delimited by end-of-file (wanted `END_TEXT')
HERE DOC WITH <<
 A SINGLE SPACE CHARACTER (I.E. 0X20 )  IS AT THE BEGINNING OF THIS LINE
	THIS LINE BEGINS WITH A SINGLE TAB CHARACTER I.E 0X09 AS DOES THE NEXT LINE
	END_TEXT

ECHO THE INTENDED END WAS BEFORE THIS LINE
{%- endcodetabs %}

