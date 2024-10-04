<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

  - [oneline commands](#oneline-commands)
    - [cat and EOF](#cat-and-eof)
    - [while read from input](#while-read-from-input)
    - [ssh](#ssh)
    - [find and tar](#find-and-tar)
    - [find and rename](#find-and-rename)
    - [find and sort](#find-and-sort)
    - [find and copy](#find-and-copy)
    - [download and extract](#download-and-extract)
    - [mirror website](#mirror-website)
    - [kubectl apply from stdin](#kubectl-apply-from-stdin)
  - [sync mirror](#sync-mirror)
  - [get all declare](#get-all-declare)
    - [print env](#print-env)
  - [using string as variable name](#using-string-as-variable-name)
  - [`<<<`, `< <(..)`](#--)
    - [`< <(..)` && `> >(..)`](#----)
  - [parameter substitution](#parameter-substitution)
    - [arguments substitution](#arguments-substitution)
    - [quotas](#quotas)
  - [string manipulations](#string-manipulations)
  - [compound comparison](#compound-comparison)
    - [SC2155](#sc2155)
    - [SC2155](#sc2155-1)
    - [escape code](#escape-code)
  - [echo](#echo)
    - [echo var name from variable](#echo-var-name-from-variable)
    - [echo var name](#echo-var-name)
  - [ls](#ls)
  - [bash completion](#bash-completion)
    - [osx](#osx)
    - [linux](#linux)
    - [troubleshooting](#troubleshooting)
- [tricky](#tricky)
  - [alias for sudo](#alias-for-sudo)
  - [check file text or binary](#check-file-text-or-binary)
  - [get md5sum](#get-md5sum)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> reference:
> - [ppo/gist/bash.md](https://github.com/ppo/gist/blob/master/bash.md)
> - [Unix / Linux - Shell Substitution](https://www.tutorialspoint.com/unix/unix-shell-substitutions.htm)
> - [ShellCheck Wiki Sitemap](https://www.shellcheck.net/wiki/)
> - [* cd is not a program](https://seb.jambor.dev/posts/cd-is-not-a-program/)
{% endhint %}

## oneline commands

> [!TIP]
> - [iMarslo : kubernetes - oneline cmd](../../virtualization/kubernetes/cheatsheet.html#oneline-command)
> - [johnnypea/useful-one-liners.sh](https://gist.github.com/johnnypea/b0cd77e5734d65691fa21d93274b305b)
> - [ITT: Post useful shell aliases/functions](https://4chanarchives.com/board/g/thread/51917516)
> - [Post your handy self made command line utilities](https://bbs.archlinux.org/viewtopic.php?id=56646&p=56)

### cat and EOF

> [!NOTE|label:references:]
> - [Chapter 19. Here Documents](https://tldp.org/LDP/abs/html/here-docs.html)
> - [bash Heredoc](https://linuxize.com/post/bash-heredoc/)
>   - using heredoc with ssh
>     ```bash
>     ssh -T user@host.com << EOF
>     echo "The current local working directory is: $PWD"
>     echo "The current remote working directory is: \$PWD"
>     EOF
>     ```
> - [* POSIX.1 states](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/V3_chap01.html#tag_17_04)
>   ```
>   ...an operand naming a file can be specified as '-', which means to use the standard input instead of a named file ....
>   ```

- kubectl apply from stdin

  > [!NOTE|label:references:]
  > - [Need some explaination of kubectl stdin and pipe](https://stackoverflow.com/a/72168173/2940319)

  ```bash
  $ cat << 'EOF' | kubectl apply -f -
  ...
  ...
  EOF

  # or
  $ kubectl apply -f - << EOF
  ...
  ...
  EOF
  ```

- git apply from stdin

  ```bash
  $ cat >> 'EOF' | git apply --inaccurate-eof --ignore-whitespace
  ...
  ...
  EOF

  # or
  $ git apply --inaccurate-eof --ignore-whitespace --stat << 'EOF'
  ...
  ...
  EOF
   install |    6 ++----
   1 file changed, 2 insertions(+), 4 deletions(-)
  ```

- git apply from clipboard

  > [!NOTE|label:references:]
  > - [Pipe (a patch in my clipboard) to `git apply`?](https://superuser.com/q/1493215/112396)

  ```bash
  $ pbpaste | git apply

  $ xsel --clipboard --input | git apply
  # or
  $ xclip -selection clipboard -o | git apply
  ```

- patch from stdin

  > [!NOTE|label:references:]
  > - [How can I run patch through a heredoc in bash?](https://unix.stackexchange.com/a/409327/29178)

  ```bash
  $ patch --dry-run --ignore-whitespace << 'EOF'
  ...
  ...
  EOF
  ```

### while read from input

> [!NOTE|label:references:]
> - [How to use a shell command to only show the first column and last column in a text file?](https://unix.stackexchange.com/a/148416/29178)

```bash
$ while IFS=\| read -r col1 col2; do echo ">> $col1 .. $col2 <<"; done <<\INPUT
  a|b
  INPUT
>> a .. b <<
```

### ssh
- compress and ssh and extract
  ```bash
  $ tar cf - . | ssh elsewhere tar xf - -C /other/dir
  ```

- tips

  > [!NOTE|label:references:]
  > - [How can I copy multiple files over scp in one command?](https://superuser.com/a/116001/112396)

  ```bash
  # tips
  $ tar cfz - . | ssh otherhost "cd /mydir; tar xvzf -"
  # the z-flag to tar does compression. Or you can use -C to ssh:
  $ tar cf - . | ssh -C otherhost "cd /mydir; tar xvf -"
  ```

### find and tar
```bash
$ find . -name builds -prune -o -type f -print | tar czf ~/m.tar.gz --files-from -

# or find with maxdepth
$ find . -type f -name "config.xml" -maxdepth 2 -prune -print | tar czf ~/config.xml.130.tar.gz --files-from -

# find with special name
$ find . -name config\.xml -type f -print | tar czf ~/m.tar.gz --files-from -

# and ssh and extract
$ tar cf - . | ssh -C otherhost "cd /mydir; tar xvf -"
```

### find and rename
```bash
$ find -iname "*.sh" -exec rename "s/.sh$/.shell/" {} \; -print
```

### find and sort

- via timestamp
  > [!NOTE]
  > - [How to Find and Sort Files Based on Modification Date and Time in Linux](https://www.tecmint.com/find-and-sort-files-modification-date-and-time-in-linux/)
  >   ```bash
  >   $ find . -type f -printf "\n%AD %AT %p" | head -n 11 | sort -k1.8n -k1.1nr -k1
  >   # or
  >   $ find . -type f -printf "\n%Tm/%Td/%TY %TT %p" | sort -k1.8n -k1.1nr -k1
  >   ```
  > - [* iMarslo : find printf](../cheatsheet/text-processing/text-processing.html#printf)
  > - [* `printf` time formats](https://www.codedodle.com/find-printf.html#time-formats)
  >   ```bash
  >   $ find . -printf "%T<format>\n"
  >   ```
  > - [sort by datetime format in bash](https://stackoverflow.com/a/67608960/2940319)
  > - [how to sort file by DD-MM-YYYY dates](https://unix.stackexchange.com/a/485708/29178)
  > - [Sort logs by date field in bash](https://stackoverflow.com/a/5243126/2940319)

  ```bash
  # via %T+
  $ find ~/.marslo -type f -printf "%10T+ | %p\n" | sort -r | head -10

  # via %Td-%Tm-%TY
  $ find ~/.marslo -type f -printf "\n%Td-%Tm-%TY %TT %p" |
    sort -b -k1.7,1.10 -k1.4,1.5 -k1.1,1.2 -r
  ```

  - via [awk+sort](https://stackoverflow.com/a/73881909/2940319)
    ```bash
    $ cat a.txt
    ABC,1/02/2022,05:50
    OPQ,18/10/2023,07:50
    HIJ,31/09/2023,08:50
    DEF,1/02/2021,06:00

    $ awk -F'[,/]' '{printf "%04d-%02d-%02d\t%s\n", $4,$3,$2, $0}' a | sort -r | cut -f2-
    OPQ,18/10/2023,07:50
    HIJ,31/09/2023,08:50
    ABC,1/02/2022,05:50
    DEF,1/02/2021,06:00
    ```

### find and copy

> [!TIP]
> - [* iMarslo: find by timestamp](../text-processing/text-processing.html#find-by-timestamp)

```bash
$ find . -type f -newermt '2023-10-16 00:00:00' -exec cp -a --parents -t /path/to/target "{}" \+

# or
$ diff=$(( ($(date --date "24-02-29" +%s) - $(date --date "231016" +%s) )/(60*60*24) ))
$ find . -type f -daystart -mtime -$((diff+1)) -exec cp -a --parents -t /path/to/target "{}" \+
```

### download and extract
- tar.gz
  ```bash
  $ curl -fsSL https://dlcdn.apache.org/maven/maven-3/3.9.5/binaries/apache-maven-3.9.5-bin.tar.gz | tar xzf - -C /path/to/target
  ```

- tar.xz
  ```bash
  $ curl -fsSL https://ftp.gnu.org/gnu/glibc/glibc-2.38.tar.xz | tar -xJf - -C /path/to/target
  ```

- zip
  ```bash
  $ curl -fsSL https://downloads.gradle.org/distributions/gradle-8.4-bin.zip | bsdtar xzf - -C /path/to/target
  ```

### [mirror website](https://explainshell.com/explain?cmd=wget+--mirror+--page-requisites+--html-extension+--convert-links++example.com)
```bash
$ wget --mirror --page-requisites --html-extension --convert-links $URL

# or https://www.linuxjournal.com/content/downloading-entire-web-site-wget
# wget --recursive --no-clobber --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains website.org --no-parent sample.com

# or https://superuser.com/a/1415765/112396
$ wget --recursive --level 5 --no-clobber --page-requisites --adjust-extension --span-hosts --convert-links --restrict-file-names=windows --domains sample.com --no-parent sample.com
```

### kubectl apply from stdin
```bash
$ cat << EOF | kubectl create -f -
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: $(echo -n 'admin' | base64)
  password: $(echo -n 'password' | base64)
EOF
```

## sync mirror

> [!NOTE]
> - [How to create public mirrors for CentOS](https://wiki.centos.org/HowTos(2f)CreatePublicMirrors.html)
> - [Configure DNF/Yum Mirror Server](https://www.server-world.info/en/note?os=CentOS_Stream_9&p=localrepo)

```bash
$ rsync -aqzH --delay-updates --delete-after  msync.centos.org::CentOS /path/to/local/mirror/root

# stream 9
$ rsync -aqzH --delay-updates --delete-after rsync.stream.centos.org::CentOS-Stream-All /path/to/local/mirror/root

# or src
$ rsync -aqzH --delay-updates --delete-after rsync.stream.centos.org::CentOS-Stream-nosrc /path/to/local/mirror/root

# exclude debuginfo
$ rsync -aqzH --delay-updates --delete-after rsync.stream.centos.org::CentOS-Stream-nodebug /path/to/local/mirror/root
```

## get all declare

> [!NOTE|label:references:]
> - [How to list all variables names and their current values?](https://askubuntu.com/a/1451692/92979)
> - [What is the difference between source and export?](https://stackoverflow.com/q/15474650/2940319)

```bash
$ declare
$ declare -p
$ declare -xp

# or
$ typeset
$ typeset -p

# or
$ compgen -v
$ compgen -v | while read line; do echo $line=${!line};done
$ compgen -v | while read line; do declare -p $line; done

# or
$ export
$ printenv
```

### print env

> [!NOTE|label:references:]
> - [List all shell variables](https://unix.stackexchange.com/a/176003/29178)

```bash
$ set -o posix ; set | awk -F '=' '{ print $1 }'

# or
$ env
$ env | awk -F '=' '{ print $1 }'
$ env | awk -F '=' '{ print $1 }' | tr '\n' ' '

# or
$ printenv
```

## using string as variable name

> [!NOTE|label:references:]
> - [3.5.3 Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
> - [How to get a variable value if variable name is stored as string?](https://stackoverflow.com/a/1921337/2940319)
> - [Dynamic variable names in Bash](https://stackoverflow.com/a/18124325/2940319)

- [`eval`](https://stackoverflow.com/a/1921376/2940319)
  ```bash
  $ aa='echo me'
  $ var='aa'
  $ eval echo \$$var
  echo me
  ```

- [`${!var}`](https://stackoverflow.com/a/1921337/2940319)
  ```bash
  $ var1="this is the real value"
  $ a="var1"
  $ echo "${!a}"
  this is the real value
  ```

- more usage
  ```bash
  $ sunny='''
  \033[38;5;226m    \\   /    \033[0m
  \033[38;5;226m     .-.     \033[0m
  \033[38;5;226m  ― (   ) ―  \033[0m
  \033[38;5;226m     `-’     \033[0m
  \033[38;5;226m    /   \\    \033[0m
  '''

  $ fewClouds='''
  \033[38;5;226m   \\  /\033[0m
  \033[38;5;226m _ /\"\"\033[38;5;250m.-.    \033[0m
  \033[38;5;226m   \\_\033[38;5;250m(   ).  \033[0m
  \033[38;5;226m   /\033[38;5;250m(___(__) \033[0m

  '''

  $ codeMap=(
               ["01"]="sunny"
               ["02"]="fewClouds"
             )
  $ icon="$(/usr/bin/curl -sg "https://api.openweathermap.org/data/3.0/onecall?lat=37.3541132&lon=-121.955174&units=metric&exclude=hourly,daily,minutely,alerts&appid=${OWM_API_TOKEN}" | jq -r .current.weather[].icon)"
  $ echo ${icon}
  02n

  $ echo -e "${!codeMap["${icon:0:-1}"]}"
  ```

  ![using string as var name](../../screenshot/tools/widget/bash-map-var-is-string.png)


## `<<<`, `< <(..)`

> [!TIP]
> - `< <(` is [Process Substitution](http://mywiki.wooledge.org/ProcessSubstitution)
>   - The difference between `<(...)` and `>(...)` is merely which way the redirections are done

### `< <(..)` && `> >(..)`

> [!NOTE]
> - [process substitution](http://mywiki.wooledge.org/ProcessSubstitution)
> - [syntax](https://askubuntu.com/a/678924/92979)
>   ```bash
>   $ command1 < <( command2 )
>   # equals to
>   $ command2 | command1
>
>   # if read from file, then using `< /path/to/file`
>   ```
> - [SubShell](http://mywiki.wooledge.org/BashFAQ/024)
>
> - example:
>   ```bash
>   $ while read line; do echo "-- ${line} --"; done < <(ls -1)
>
>   # equals to: http://mywiki.wooledge.org/BashFAQ/024
>   $ ls -1 | while read line; do echo "-- ${line} --"; done
>   # equals to
>   $ ls -1 | xargs -n1 -i bash -c "echo \"-- {} --\""
>
>   # equals to read from file via `< /path/to/file`
>   $ ls -1 > ls.txt
>   $ while read line; do echo "-- ${line} --"; done < ls.txt
>   ```

```bash
$ wc < <(date)
    1       6      29

# same as:
$ date | wc
    1       6      29
```

- `< <(..)`

  > [!TIP|label:referencs:]
  > - [subshell](http://mywiki.wooledge.org/BashFAQ/024)
  > - tips:
  >   ```bash
  >   # If commandA can read the data from stdin
  >   commandB | commandA                 # You can now get the exit code of commandB from PIPESTATUS.
  >   commandB > >(commandA)              # You can now get the exit code of commandB from $? (or by putting this in an if)
  >
  >   # If commandA cannot read it from stdin, but requires a file argument
  >   commandB > >(commandA <(cat))       # Again, commandB's exit code is available from $?
  >
  >   # You can also keep commandB's output in memory.  When you do this, you can get commandB's exit code from $? or put the assignment in an if
  >   b=$(commandB); commandA <<< "$b"    # Here, commandA reads commandB's output from stdin
  >   ```

  - common usage
    ```bash
    $ diff <(sort list1) <(sort list2)

    # or
    $ while read file; do
        echo -e "\n\033[1;33m${file}\n---\033[0m"
        sed -n "/<<<<<<< HEAD/,/>>>>>>> /!d;=;p" ${file}
        echo -e "\n\033[1;33m---\033[0m"
      done < <(git grep --no-color -l "<<<<<<< HEAD")
    ```

- `> >(..)`

  > [!TIP]
  > - [Process Substitution](http://mywiki.wooledge.org/ProcessSubstitution)
  >   - `>(...)` is used less frequently; the most common situation is in conjunction with `tee(1)`.
  >   - `>(...)` is handy when redirecting the output to multiple files, based on some criteria.

  ```bash
  # For example:
  $ some_command | tee >(grep A > A.out) >(grep B > B.out) >(grep C > C.out) > /dev/null
  ```

## parameter substitution

{% hint style='tip' %}
> reference:
> - [10.2. Parameter Substitution](https://tldp.org/LDP/abs/html/parameter-substitution.html)
> - [* iMarslo: params](../../linux/util/params.html)
> - [How can I keep quotes in Bash arguments?](https://stackoverflow.com/q/1668649/2940319)
> - [How can I preserve quotes in printing a Bash script's arguments?](https://stackoverflow.com/q/10835933/2940319)
{% endhint %}

|          EXPR          | DESCRIPTION                                               |
|:----------------------:|-----------------------------------------------------------|
|  `${variable-default}` | if variable is unset, use default                         |
|  `${variable=default}` | if variable is unset, set variable to default             |
|    `${variable+alt}`   | if variable is set, use alt, else use null string         |
| `${variable:-default}` | with `":[-=+]"`, condition takes also "declared but null" |


### arguments substitution

{% hint style='tip' %}
> reference:
> - [Process all arguments except the first one (in a bash script)](https://stackoverflow.com/a/62630975/2940319)
> - [Getting the last argument passed to a shell script](https://stackoverflow.com/a/5496054/2940319)
> - [Extract parameters before last parameter in "$@"](https://stackoverflow.com/a/1215592/2940319)
{% endhint %}

|           EXPR           | DESCRIPTION                                           |
|:------------------------:|-------------------------------------------------------|
|           `$@`           | <pre><code>           p1 p2 p3 p4 p5 p6 </code></pre> |
|         `${@: 0}`        | <pre><code> ./args.sh p1 p2 p3 p4 p5 p6 </code></pre> |
|         `${@: 1}`        | <pre><code>           p1 p2 p3 p4 p5 p6 </code></pre> |
|         `${@: 2}`        | <pre><code>              p2 p3 p4 p5 p6 </code></pre> |
|        `${@: 2:1}`       | <pre><code>              p2             </code></pre> |
|        `${@: 2:2}`       | <pre><code>              p2 p3          </code></pre> |
|        `${@: -2}`        | <pre><code>                       p5 p6 </code></pre> |
|       `${@: -2:1}`       | <pre><code>                       p5    </code></pre> |
| `${*: -1}` or `${@: $#}` | <pre><code>                          p6 </code></pre> |
|      `${@: 1:$#-1}`      | <pre><code>           p1 p2 p3 p4 p5    </code></pre> |

- sample with uncertain parameters

  ```bash
  local opt=''
  local loop=true
  local path params

  while ${loop} && [[ $# -gt 0 ]]; do
    case "$1" in
      -*) opt+="$1 "; shift;;
       *) loop=false       ;;
    esac
  done

  if [[ 1 = "$#" ]]; then
    path=''
    params="$1"
  else
    path=${*: -1}
    params=${*:1:$#-1}
  fi
  ```

  <!--sec data-title="sample script c.sh" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  echo '---------------- before shift -------------------'
  echo ".. \$# : $#"
  echo ".. \$@ : $@"
  echo ".. \$* : $*"

  echo '---------------- after shift -------------------'
  opt=''
  ss=''
  loop=true

  while $loop && [[ $# -gt 0 ]]; do
    case "$1" in
      -*) opt+="$1 "; shift;;
       *) loop=false       ;;
    esac
  done

  echo ".. \$#   : $#"
  echo ".. \$@   : $@"
  echo ".. \$*   : $*"
  echo ".. \$opt : $opt"

  if [[ 0 = "$#" ]]; then
    echo -e "\033[0;33mERROR: must provide at least one non-opt param\033[0m"
    exit 2
  elif [[ 1 = "$#" ]]; then
    path=''
    params="$1"
  else
    path=${*: -1}
    params=${*:1:$#-1}
  fi

  echo '---------------- result -------------------'
  echo ">> opt    : ${opt}"
  echo ">> params : ${params}"
  echo ">> path   : ${path}"
  ```
  <!--endsec-->

  <!--sec data-title="result" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  $ ./c.sh -1 -2 --3-4 a b c d e
  ---------------- before shift -------------------
  .. $# : 8
  .. $@ : -1 -2 --3-4 a b c d e
  .. $* : -1 -2 --3-4 a b c d e
  ---------------- after shift -------------------
  .. $#   : 5
  .. $@   : a b c d e
  .. $*   : a b c d e
  .. $opt : -1 -2 --3-4
  .. $ss  : a b c d e
  ---------------- result -------------------
  >> opt    : -1 -2 --3-4
  >> params : a b c d
  >> path   : e

  $ ./c.sh aa bb
  ---------------- before shift -------------------
  .. $# : 2
  .. $@ : aa bb
  .. $* : aa bb
  ---------------- after shift -------------------
  .. $#   : 2
  .. $@   : aa bb
  .. $*   : aa bb
  .. $opt :
  .. $ss  : aa bb
  ---------------- result -------------------
  >> opt    :
  >> params : aa
  >> path   : bb

  $ ./c.sh -1
  ---------------- before shift -------------------
  .. $# : 1
  .. $@ : -1
  .. $* : -1
  ---------------- after shift -------------------
  .. $#   : 0
  .. $@   :
  .. $*   :
  .. $opt : -1
  ERROR: must provide at least one non-opt param
  ```
  <!--endsec-->

### quotas
- `${@@Q}`
  ```bash
  # a.sh
  line="${@@Q}"
  echo $line

  $ bash a.sh -a -b --c='1 2 3'
  '-a' '-b' '--c=1 2 3'
  ```

  ```bash
  # https://stackoverflow.com/a/39463371/2940319
  $ expand-q() { for i; do echo ${i@Q}; done; }
  $ expand-q -a -b --c='1 2 3'
  '-a'
  '-b'
  '--c=1 2 3'
  ```

  ```bash
  # https://stackoverflow.com/a/72745869/2940319
  function quote() {
    local QUOTED_ARRAY=()
    for ARGUMENT; do
      case ${ARGUMENT} in
        --*=*)
          QUOTED_ARRAY+=( "${ARGUMENT%%=*}=$(printf "%q" "${ARGUMENT#*=}")" )
          shift
        ;;
        *)
          QUOTED_ARRAY+=( "$(printf " %q" "${ARGUMENT}")" )
        ;;
      esac
    done
    echo ${QUOTED_ARRAY[@]}
  }

  ARGUMENTS="$(quote "${@}")"
  echo "${ARGUMENTS}"
  ```

- `printf " %q" "${@}"`

  > [!NOTE]
  > - [git-effort](https://github.com/tj/git-extras/blob/main/bin/git-effort#L162)

  ```bash
  while test -n "$1"; do
    case "$1" in
      -- ) shift; GIT_OPT=$(printf " %q" "${@}"); break ;;
    esac
  done
  GIT_OPT="${GIT_OPT#\ \'\'}"
  ```

  ```bash
  # https://stackoverflow.com/a/39463371/2940319
  $ params-q() { printf "%q\n" "$@"; }
  $ params-q -a -b --c='1 2 3'
  -a
  -b
  --c=1\ 2\ 3
  ```

- String replacement

  > [!TIP]
  > - [* iMarslo: add `'` or `"` to strings](../text-processing/text-processing.html#tricky)

  ```bash
  # a.sh
  while test -n "$1"; do
    case "$1" in
      -- ) shift; GIT_OPT="$@";;
      *  ) shift;;
    esac
  done

  GIT_OPT=$(echo "${GIT_OPT}" |
               sed -r 's/\s+--/\n--/g' |
               sed -r "s/^([^=]+)=(.+)$/\1='\2'/g" |
               sed -e 'N;s/\n/ /'
            )
  echo $GIT_OPT

  $ bash a.sh -a -b -- --c='1 2 3'
  --c='1 2 3'
  ```

  ```bash
  # https://stackoverflow.com/a/8723305/2940319
  # a.sh
  C=''
  for i in "$@"; do
      i="${i//\\/\\\\}"
      C="$C \"${i//\"/\\\"}\""
  done
  echo $C

  $ bash ~/a.sh -a -b --c='1 2 3'
  "-a" "-b" "--c=1 2 3"
  ```

## string manipulations

{% hint style='tip' %}
> reference:
> - [10.1. Manipulating Strings](https://tldp.org/LDP/abs/html/string-manipulation.html)
{% endhint %}

| EXPR                               | DESCRIPTION                                                |
| - | - |
| `${#string}`                       | length                                                     |
| `${string:position}`               | substring, or positional parameter with `$*` and `$#`      |
| `${string:position:length}`        | substring                                                  |
| `${string#substring}`              | deletes shortest match of $substring from front of $string |
| `${string##substring}`             | same but longest match                                     |
| `${string%substring}`              | shortest from back                                         |
| `${string%%substring}`             | longest from back                                          |
| `${string/substring/replacement}`  | replace first match                                        |
| `${string//substring/replacement}` | replace all matches                                        |
| `${string/#substring/replacement}` | replace if matches front end of $string                    |
| `${string/%substring/replacement}` | replace if matches back end of $string                     |
| `${var^}`                          | uppercase first char                                       |
| `${var^^}`                         | uppercase all chars                                        |
| `${var,}`                          | lowercase first char                                       |
| `${var,,}`                         | lowercase all chars                                        |


## compound comparison
### [SC2155](https://www.shellcheck.net/wiki/SC2235)
- problematic code:
  ```bash
  ([ "$x" ] || [ "$y" ]) && [ "$z" ]
  ```
- correct code:
  ```bash
  { [ "$x" ] || [ "$y" ]; } && [ "$z" ]
  ```
- example
  - [git-retag](https://github.com/marslo/mylinux/blob/master/confs/home/.marslo/bin/git-retag#L33)


### [SC2155](https://www.shellcheck.net/wiki/SC2155)
- problematic code:
  ```bash
  export foo="$(mycmd)"
  ```
- correct code:
  ```bash
  foo="$(mycmd)"
  export foo
  ```

### escape code

> [!TIP]
> references:
> - [Color Codes, Escapes & Languages](https://gist.github.com/Prakasaka/219fe5695beeb4d6311583e79933a009?permalink_comment_id=4086771#gistcomment-4086771)
> - [Escape codes](https://smallbasic.github.io/pages/escape.html)
> - [Escape sequences](https://perldoc.perl.org/perlre#Escape-sequences)
> - [Quote and Quote-like Operators](https://perldoc.perl.org/perlop#Quote-and-Quote-like-Operators)

| ESCAPE CODE | LANGUAGE               | DESCRIPTION  |
|:-----------:|:-----------------------|--------------|
|    `\x1b`   | Node.js                | hex char     |
|   `\x1b `   | Node.js w/ TS          | hex char     |
|   `\u001b`  | Python                 | hex char     |
|    `\033`   | GNU Cpp                | octal char   |
|    `\033`   | ANSI C                 | octal char   |
|    `\033`   | POSIX-compliant shells | octal char   |
|     `\e`    | Bash                   | -            |
|    `\c[`    | -                      | control char |


## echo
### echo var name from variable

> [!NOTE]
> - [Chapter 28. Indirect References](https://tldp.org/LDP/abs/html/ivr.html)
> - [3.5.3 Shell Parameter Expansion: `{!parameter}`](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
> - [9.2. Typing variables: declare or typeset](https://tldp.org/LDP/abs/html/declareref.html)
> - sample:
>   ```bash
>   $ foo=bar             # `bar` is the var name
>   $ bar=baz             # `baz` is the var value
>   ```

- `typeset`
  ```bash
  $ typeset -p "${foo}"$
  declare -- bar="baz"
  ```

- `eval \$$`
  ```bash
  $ eval echo \$$foo
  baz
  ```
  - more:
    ```bash
    $ echo \$$foo
    $bar
    # or
    $ echo '$'$foo
    $bar
    ```

- `{!parameter}`
  ```bash
  $ echo "${!foo}"
  baz
  ```

### echo var name

> [!NOTE]
> - [Shell: print both variable name and value?](https://stackoverflow.com/a/71637863/2940319)
> - [* How to Echo the Variable Name Instead of Variable Value](https://www.baeldung.com/linux/echo-variable-name)
> - [`typeset -p`](https://unix.stackexchange.com/a/397595/29178)
> - sample
>   ```bash
>   $ a1='a'
>   $ a2='aa'
>   $ c1='c'
>   $ c2='cc'
>   ```

- `typeset`
  ```bash
  $ typeset -p c2
  declare -- c2="cc"
  ```

- `{!parameter@}`
  ```bash
  $ echo "${!c@}"
  c1 c2

  $ echo "${!a@}"
  a1 a2
  ```

- more
  ```bash
  superEcho() {
    echo "$1 = ${!1}"
  }

  $ superEcho foo
  foo = bar
  $ superEcho bar
  bar = baz
  ```

## ls

> [!NOTE|label:references]
> - [How can I make ls only display files?](https://askubuntu.com/a/1322137/92979)

```bash
# show file only
$ ls -p | command grep -v /

# show folder only
$ ls -p | command grep / | command grep "^."

# show all files ( including hidden )
$ ls -Ap | command grep -v / | command grep "^."

# show all folders ( including hidden )
$ ls -Ap | command grep / | command grep "^."

# show hidden folder only
$ ls -Ap | command grep / | command grep "^\." | command grep "\."

# show hidden file only
$ ls -Ap | command grep -v / | command grep "^\." | command grep "\."

# show all including hidden
$ ls -Ap

# show hidden file and folder
$ ls -Ap | command grep "^\."
```

## bash completion

> [!NOTE|label:references]
> - [* Creating a bash completion script](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial)
> - [* An introduction to bash completion: part 1](https://web.archive.org/web/20190722115536/https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1)
> - [* An introduction to bash completion: part 2](https://web.archive.org/web/20200327211933/https://debian-administration.org/article/317/An_introduction_to_bash_completion_part_2)
>   ```bash
>   $ complete -W "--help --verbose --version" foo
>   $ foo --<TAB>
>   --help
>   --verbose
>   --version
>   ```
> - [8.7 Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html)
> - [8.6 Programmable Completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
> - [8.8 A Programmable Completion Example](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html#A-Programmable-Completion-Example)
> - [cykerway/complete-alias](https://github.com/cykerway/complete-alias)
> - [Multi Level Bash Completion](https://stackoverflow.com/a/5303225/2940319)
> - [List all commands that a shell knows](https://unix.stackexchange.com/a/94825/29178)
> - [* iMarslo : `_vim()`](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/.marslo/.completion/vim.sh)
> - [Integralist/1. bash autocomplete for your custom programs.md](https://gist.github.com/Integralist/0500e6b5aabf95034cd83eff8c9e2ead)
> - [8.6 Programmable Completion : `_completion_loader()` ](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
> - [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Completion.html)
> - paths:
>   - osx: `/usr/local/etc/bash_completion.d`
>   - centos: `/usr/share/bash-completion/completions` or `/etc/bash_completion.d`
>   - ubuntu: `/usr/share/bash-completion/completions`

- print existing completion
  ```bash
  $ complete -p vim
  complete -o bashdefault -o default -F _fzf_opts_completion vim

  $ complete -p ffs
  complete -o bashdefault -o default -o nosort -F _fd ffs

  $ complete -p ff
  complete -o bashdefault -o default -o nosort -F _fd ff
  ```

- remove completion
  ```bash
  $ complete -p vim
  complete -o bashdefault -o default -F _fzf_opts_completion vim

  $ complete -r vim

  $ complete -p vim
  -bash: complete: vim: no completion specification
  ```

- [list all completions](https://unix.stackexchange.com/a/94784/29178)
  ```bash
  $ complete

  # show all commands
  $ compgen -c
  ```

  - more
    ```bash
    # aliases
    $ compgen -a

    # built-ins
    $ compgen -b

    # keywords
    $ compgen -k

    # functions
    $ compgen -A function

    # list all the above
    $ compgen -A function -abck
    ```

  <!--sec data-title="details..." data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  $ complete
  complete -o default -F _quotaon quotaon
  complete -o default -F _fzf_path_completion mv
  complete -F _postcat postcat
  complete -o default -o nospace -v -F _fzf_var_completion printenv
  complete -o default -F __start_kubectl kcn
  complete -F _filedir_xspec mpg321
  complete -F _filedir_xspec tex
  complete -F _make gmake
  complete -o bashdefault -o default -F _fzf_path_completion diff3
  complete -o default -F _ansible ansible
  complete -o default -F _fzf_path_completion head
  complete -o default -F __start_kubectl kt1
  complete -o default -F __start_kubectl kt2
  complete -o default -F _fzf_path_completion uniq
  complete -F _command else
  complete -o default -F __start_kubectl kt3
  complete -F _ldapdelete ldapdelete
  complete -F _configure configure
  complete -F _filedir_xspec freeamp
  complete -F _lzma lzma
  complete -o default -F __start_kubectl kcc
  complete -F _filedir_xspec gqmpeg
  complete -F _filedir_xspec texi2html
  complete -o default -F _complete_groovydoc groovydoc
  complete -F _filedir_xspec hbpp
  complete -F _xsltproc xsltproc
  complete -F _filedir_xspec jadetex
  complete -F _docker droot
  complete -o default -F _longopt mkfifo
  complete -o bashdefault -o default -F _fzf_path_completion svn
  complete -o default -F _fzf_path_completion tee
  complete -F _javaws javaws
  complete -F _mktemp mktemp
  complete -F _filedir_xspec rpm2cpio
  complete -F _docker dvi
  complete -F _make pmake
  complete -o default -F _repquota repquota
  complete -F _filedir_xspec hbrun
  complete -F _autoscan autoscan
  complete -o default -F __start_kubectl kubectl
  complete -o default -F _screen screen
  complete -F _filedir_xspec ps2pdf14
  complete -o default -F _fzf_path_completion grep
  complete -F _fzf_path_completion vi
  complete -F _autoreconf autoheader
  complete -F _composite composite
  complete -F _fzf_path_completion bat
  complete -F _filedir_xspec ps2pdf13
  complete -o default -F _longopt objdump
  complete -F _filedir_xspec ps2pdf12
  complete -o default -F _longopt sha1sum
  complete -o default -F _longopt cut
  complete -F _filedir_xspec lyx
  complete -o bashdefault -o default -F _fzf_path_completion file
  complete -F _gcc gpc
  complete -F _filedir_xspec latex
  complete -o default -F _look look
  complete -F _gradle gradlew.bat
  complete -o bashdefault -o default -F _fzf_path_completion hx
  complete -F _filedir_xspec poedit
  complete -F _fzf_path_completion view
  complete -o bashdefault -o default -F _fzf_path_completion dirname
  complete -F _function typeset
  complete -o bashdefault -o default -F _fzf_path_completion hg
  complete -F _command nohup
  complete -a -F _fzf_alias_completion unalias
  complete -F _vipw vipw
  complete -g groupdel
  complete -F _make gnumake
  complete -u groups
  complete -F _filedir_xspec chromium-browser
  complete -F _filedir_xspec opera
  complete -F _filedir_xspec kbabel
  complete -F _fzf_host_completion telnet
  complete -F _gcc g77
  complete -F _filedir_xspec bzme
  complete -o bashdefault -o default -F _fzf_complete_ssh ssh
  complete -F _command vsound
  complete -c which
  complete -F _fzf_path_completion tar
  complete -o default -F _longopt m4
  complete -F _filedir_xspec madplay
  complete -o default -F _fzf_opts_completion fzf-tmux
  complete -F _docker drm
  complete -F _filedir_xspec dviselect
  complete -o default -F _fzf_path_completion cp
  complete -F _mas mas
  complete -F _animate animate
  complete -F _man whatis
  complete -o default -F _complete_groovysh groovysh.sh
  complete -F _filedir_xspec evince
  complete -o bashdefault -o default -F _brew brew
  complete -F _docker dcleanall
  complete -F _filedir_xspec realplay
  complete -o default -F _longopt strip
  complete -o bashdefault -o default -o nospace -F __git_wrap__gitk_main gitk
  complete -v readonly
  complete -o nospace -F _fzf_path_completion rsync
  complete -F _ctest ctest
  complete -o nospace -F _fzf_dir_completion cd
  complete -o default -F _complete_groovydoc groovydoc.bash
  complete -F _known_hosts showmount
  complete -F _filedir_xspec kdvi
  complete -o default -F _longopt tac
  complete -F _ldapaddmodify ldapmodify
  complete -F _filedir_xspec elinks
  complete -F _known_hosts fping
  complete -o default -F _longopt env
  complete -o default -F _quota quota
  complete -F _gradle ./gradlew
  complete -u chfn
  complete -F _docker drp
  complete -F _filedir_xspec compress
  complete -F _filedir_xspec pdfjadetex
  complete -F _filedir_xspec kghostview
  complete -F _man man
  complete -F _filedir_xspec pbunzip2
  complete -o default -F _brctl brctl
  complete -c type
  complete -F _ldapcompare ldapcompare
  complete -F _known_hosts ssh-installkeys
  complete -F _filedir_xspec iceweasel
  complete -F _filedir_xspec gtranslator
  complete -F _fzf_path_completion unzip
  complete -o default -F _longopt expand
  complete -o default -F _complete_groovyConsole groovyConsole.bash
  complete -o bashdefault -o default -o nospace -F _fzf_path_completion git
  complete -F _filedir_xspec lrunzip
  complete -o default -F _fzf_path_completion ln
  complete -F _command aoss
  complete -F _docker drps
  complete -F _filedir_xspec ggv
  complete -F _filedir_xspec oomath
  complete -F _filedir_xspec dvipdfmx
  complete -o default -F _fzf_path_completion ld
  complete -F _fzf_path_completion gunzip
  complete -F _filedir_xspec makeinfo
  complete -F _filedir_xspec okular
  complete -o default -F _complete_groovysh groovysh
  complete -F _ldapsearch ldapsearch
  complete -F _command xargs
  complete -j -P '"%' -S '"' jobs
  complete -o default -F _complete_groovy groovy.sh
  complete -F _filedir_xspec oowriter
  complete -o bashdefault -o default -F _fzf_path_completion emacsclient
  complete -F _cpack cpack
  complete -o default -F _fzf_path_completion tail
  complete -o default -F _longopt unexpand
  complete -o default -F _longopt netstat
  complete -F _docker dexe
  complete -o default -F _fzf_path_completion ls
  complete -F _filedir_xspec epiphany
  complete -o nospace -F __gio gio
  complete -o bashdefault -o default -F _fzf_path_completion nvim
  complete -o dirnames -o nospace -F _fzf_dir_completion pushd
  complete -F _filedir_xspec acroread
  complete -o default -o nospace -v -F _fzf_var_completion unset
  complete -F _postmap postalias
  complete -F _nmap nmap
  complete -o default -F _longopt csplit
  complete -F _known_hosts rsh
  complete -F _filedir_xspec sxemacs
  complete -F _command exec
  complete -F _filedir_xspec aviplay
  complete -F _ldapmodrdn ldapmodrdn
  complete -F _filedir_xspec rgvim
  complete -F _chsh chsh
  complete -F _autoconf autoconf
  complete -o default -F _longopt nm
  complete -o default -F _longopt nl
  complete -o default -F _complete_grape grape.bash
  complete -o nospace -F _user_at_host ytalk
  complete -F _fzf_proc_completion kill
  complete -F _fzf_path_completion java
  complete -F _cmake cmake
  complete -u sux
  complete -F _cancel cancel
  complete -F _filedir_xspec znew
  complete -o default -F _complete_groovydoc groovydoc.sh
  complete -F _id id
  complete -o default -F _longopt paste
  complete -F _ldapaddmodify ldapadd
  complete -F _docker dip
  complete -o bashdefault -F _perldoc perldoc
  complete -F _filedir_xspec kwrite
  complete -F _root_command really
  complete -o default -F _complete_groovyc groovyc.bash
  complete -o bashdefault -o default -o nospace -F __git_wrap__tig_main tig
  complete -F _filedir_xspec firefox
  complete -o bashdefault -o default -F _fzf_path_completion open
  complete -F _ip ip
  complete -o default -F __start_kubectl klc
  complete -F _docker drit
  complete -F _filedir_xspec dvipdfm
  complete -F _filedir_xspec ly2dvi
  complete -F _filedir_xspec oodraw
  complete -F _docker drun
  complete -F _import import
  complete -o default -F __start_kubectl kcswatch
  complete -F _gzip pigz
  complete -o default -F __start_kubectl kln
  complete -F _autoscan autoupdate
  complete -F _known_hosts dig
  complete -o nospace -F _user_at_host talk
  complete -F _filedir_xspec xemacs
  complete -F _docker dls
  complete -o nospace -F _dd dd
  complete -F _jarsigner jarsigner
  complete -F _filedir_xspec kpdf
  complete -F _man apropos
  complete -o default -F _longopt df
  complete -F _command eval
  complete -F _docker di
  complete -F _postsuper postsuper
  complete -F _postconf postconf
  complete -F _filedir_xspec bibtex
  complete -o default -F _pip_completion pip
  complete -F _docker dclr
  complete -F _postfix postfix
  complete -F _fzf_path_completion chown
  complete -F _filedir_xspec netscape
  complete -o default -F _longopt wget
  complete -F _command do
  complete -F _cargo cargo
  complete -F _gradle gradle
  complete -F _pgrep pgrep
  complete -F _filedir_xspec gview
  complete -F _filedir_xspec lzfgrep
  complete -o bashdefault -o default -o nosort -F _fd ffs
  complete -F _filedir_xspec lzless
  complete -o default -F _fzf_path_completion du
  complete -F _renice renice
  complete -F _lsof lsof
  complete -F _docker dv
  complete -F _known_hosts tracepath
  complete -o default -F __start_kubectl kit
  complete -o default -F _fzf_path_completion wc
  complete -F _fzf_path_completion gzip
  complete -F _newgrp newgrp
  complete -o default -F _ansible-galaxy ansible-galaxy
  complete -F _filedir_xspec cdiff
  complete -F _fzf_path_completion emacs
  complete -F _filedir_xspec zipinfo
  complete -F _docker dcleani
  complete -F _filedir_xspec google-chrome
  complete -F _gcc c++
  complete -F _crontab crontab
  complete -F _filedir_xspec rview
  complete -A shopt shopt
  complete -F _docker dcleanc
  complete -F _root_command sudo
  complete -F _killall pkill
  complete -F _fzf_path_completion javac
  complete -F _fzf_path_completion ftp
  complete -o default -F _longopt uname
  complete -o bashdefault -o default -F _rg rg
  complete -F _known_hosts ping
  complete -F _filedir_xspec wine
  complete -F _filedir_xspec galeon
  complete -F _filedir_xspec pdflatex
  complete -F _docker dex
  complete -F _known_hosts rlogin
  complete -o default -F _fzf_opts_completion fzf
  complete -F _filedir_xspec portecle
  complete -o default -F _longopt sha384sum
  complete -o default -F _fzf_path_completion rm
  complete -F _filedir_xspec modplugplay
  complete -F _ri ri
  complete -o default -F _quotaoff quotaoff
  complete -F _filedir_xspec dillo
  complete -F _filedir_xspec fbxine
  complete -F _filedir_xspec lokalize
  complete -F _root_command gksudo
  complete -F _command nice
  complete -o default -F _longopt tr
  complete -o default -F _npm_completion npm
  complete -F _filedir_xspec oocalc
  complete -o default -F _complete_groovyc groovyc.sh
  complete -F _gradle gradlew
  complete -o default -F _longopt sha256sum
  complete -F _root_command gksu
  complete -F _filedir_xspec qiv
  complete -F _chgrp chgrp
  complete -F _filedir_xspec ps2pdfwr
  complete -o default -F _edquota edquota
  complete -F _filedir_xspec harbour
  complete -o bashdefault -o default -F _fzf_path_completion basename
  complete -o default -F _longopt ptx
  complete -F _filedir_xspec dvitype
  complete -o nospace -F __gsettings gsettings
  complete -F _gradle ./gradlew.bat
  complete -F _known_hosts traceroute
  complete -F _fzf_path_completion bzip2
  complete -j -P '"%' -S '"' fg
  complete -o bashdefault -o default -o nosort -F _fd ff
  complete -F _convert convert
  complete -F _filedir_xspec unpigz
  complete -o default -F _complete_groovy groovy
  complete -o bashdefault -o default -o nosort -F _fd fd
  complete -F _filedir_xspec mozilla
  complete -F _filedir_xspec dvips
  complete -o default -F _longopt who
  complete -F _montage montage
  complete -F _complete compgen
  complete -F _filedir_xspec ps2pdf
  complete -F _filedir_xspec gpdf
  complete -F _complete complete
  complete -F _filedir_xspec texi2dvi
  complete -o dirnames -F _umount umount
  complete -F _function function
  complete -o bashdefault -o default -F _fzf_path_completion mvim
  complete -o default -F _fzf_path_completion less
  complete -o default -F _longopt mknod
  complete -F _command padsp
  complete -F _passwd passwd
  complete -F _filedir_xspec kate
  complete -F _pkg_config pkg-config
  complete -o default -F _longopt bison
  complete -F _filedir_xspec mozilla-firefox
  complete -F _filedir_xspec kid3-qt
  complete -o default -F _longopt od
  complete -F _fzf_path_completion bunzip2
  complete -o default -o dirnames -F _mount mount
  complete -F _function declare
  complete -F _filedir_xspec pdftex
  complete -F _ag ag
  complete -o default -o nospace -F _fzf_var_completion export
  complete -F _vipw vigr
  complete -o default -F _ansible-doc ansible-doc
  complete -F _nslookup nslookup
  complete -F _ssh slogin
  complete -o nospace -F _alias alias
  complete -F _fzf_path_completion gvim
  complete -F _filedir_xspec kaffeine
  complete -F _stream stream
  complete -F _docker drdp
  complete -o default -F _complete_grape grape.sh
  complete -F _filedir_xspec mpg123
  complete -F _fzf_path_completion find
  complete -F _filedir_xspec lzegrep
  complete -o default -F _ansible-pull ansible-pull
  complete -o default -F _longopt split
  complete -o bashdefault -o default -F _fzf_path_completion zip
  complete -F _ssh autossh
  complete -F _filedir_xspec xv
  complete -o default -F _longopt fold
  complete -F _known_hosts mtr
  complete -o bashdefault -o default -F _fzf_path_completion ruby
  complete -o nospace -F _fzf_path_completion scp
  complete -F _known_hosts ping6
  complete -F _filedir_xspec timidity
  complete -F _filedir_xspec xdvi
  complete -F _filedir_xspec xfig
  complete -F _filedir_xspec xpdf
  complete -o default -F _longopt indent
  complete -o bashdefault -o default -F _fzf_path_completion chmod
  complete -o nospace -F _user_at_host finger
  complete -o bashdefault -o default -o nospace -F _python_argcomplete pipx
  complete -F _ktutil ktutil
  complete -F _xz xz
  complete -F _filedir_xspec oobase
  complete -F _docker dpa
  complete -F _fzf_path_completion perl
  complete -F _root_command kdesudo
  complete -F _docker drmi
  complete -F _filedir_xspec ogg123
  complete -F _filedir_xspec lzgrep
  complete -u w
  complete -F _filedir_xspec ee
  complete -F _sh sh
  complete -o default -F __start_kubectl kubecolor
  complete -F _docker dps
  complete -F _filedir_xspec gharbour
  complete -u su
  complete -o default -F _complete_grape grape
  complete -o default -F _longopt irb
  complete -F _known_hosts host
  complete -o default -F __start_kubectl k
  complete -o bashdefault -o default -F _fzf_path_completion ex
  complete -o default -F _complete_groovyConsole groovyConsole
  complete -o nospace -F __gdbus gdbus
  complete -F _sysctl sysctl
  complete -F _sqlite3 sqlite3
  complete -o default -F _iconv iconv
  complete -F _command tsocks
  complete -F _docker d
  complete -F _xmllint xmllint
  complete -o default -F _fzf_path_completion diff
  complete -F _ldapwhoami ldapwhoami
  complete -F _bzip2 pbzip2
  complete -F _postmap postmap
  complete -o bashdefault -o filenames -F _pandoc pandoc
  complete -F _filedir_xspec bzcat
  complete -F _filedir_xspec unlzma
  complete -F _filedir_xspec dragon
  complete -F _xzdec xzdec
  complete -o default -F _longopt shar
  complete -F _filedir_xspec ooimpress
  complete -F _cpio cpio
  complete -F _filedir_xspec xanim
  complete -o default -F _complete_groovysh groovysh.bash
  complete -o default -F _ansible-vault ansible-vault
  complete -j -P '"%' -S '"' disown
  complete -F _filedir_xspec xine
  complete -o default -F _longopt bash
  complete -o default -F _longopt md5sum
  complete -o bashdefault -o default -F _fzf_path_completion source
  complete -F _filedir_xspec amaya
  complete -F _filedir_xspec gv
  complete -F _make make
  complete -o default -F _fzf_path_completion curl
  complete -A stopped -P '"%' -S '"' bg
  complete -o default -F __start_kubectl kubeproxy
  complete -F _filedir_xspec kid3
  complete -o nospace -F __gresource gresource
  complete -F _filedir_xspec lilypond
  complete -o default -F _longopt bc
  complete -F _identify identify
  complete -F _filedir_xspec modplug123
  complete -o default -F __start_kubectl k4
  complete -F _pack200 pack200
  complete -A binding bind
  complete -o default -F _setquota setquota
  complete -b builtin
  complete -F _unpack200 unpack200
  complete -o default -F _quotacheck quotacheck
  complete -F _filedir_xspec pbzcat
  complete -F _known_hosts tracepath6
  complete -o default -F _complete_groovyc groovyc
  complete -o default -F _longopt shasum
  complete -F _command ltrace
  complete -o default -F __start_kubectl k3
  complete -F _fzf_path_completion gcc
  complete -F __app gapplication
  complete -o bashdefault -o default -F _fzf_path_completion xdg-open
  complete -o default -F _ansible-playbook ansible-playbook
  complete -u write
  complete -F _known_hosts traceroute6
  complete -F _fzf_path_completion jar
  complete -o default -F _longopt date
  complete -F _gcc gcj
  complete -F _filedir_xspec rgview
  complete -o default -F _fzf_path_completion cat
  complete -o default -F _fzf_path_completion awk
  complete -o default -F _complete_groovyConsole groovyConsole.sh
  complete -o default -F _longopt sha512sum
  complete -F _filedir_xspec unxz
  complete -o default -F _longopt seq
  complete -o default -F _longopt mkdir
  complete -F _filedir_xspec rvim
  complete -o default -F __start_kubectl krn
  complete -o default -F _longopt sha224sum
  complete -A helptopic help
  complete -F _fzf_path_completion sftp
  complete -A setopt set
  complete -o default -F __start_kubectl krc
  complete -F _compare compare
  complete -F _tmux tmux
  complete -F _ssh_copy_id ssh-copy-id
  complete -o default -F _fzf_path_completion sort
  complete -o default -F _longopt pr
  complete -o default -F _longopt colordiff
  complete -o default -F _fzf_path_completion patch
  complete -F _fzf_path_completion g++
  complete -o bashdefault -o default -F _fzf_path_completion python
  complete -F _conjure conjure
  complete -F _ldappasswd ldappasswd
  complete -F _filedir_xspec playmidi
  complete -o default -F __start_kubectl kcEvicted
  complete -o default -F _openssl openssl
  complete -o default -F _longopt fmt
  complete -o default -F _fzf_path_completion sed
  complete -F _tcpdump tcpdump
  complete -F _javadoc javadoc
  complete -F _filedir_xspec lzcat
  complete -o default -F _longopt gperf
  complete -F _command time
  complete -F _filedir_xspec zcat
  complete -F _mogrify mogrify
  complete -F _display display
  complete -F _root_command fakeroot
  complete -o default -F _complete_groovy groovy.bash
  complete -F _filedir_xspec lynx
  complete -u slay
  complete -F _filedir_xspec uncompress
  complete -F _autoreconf autoreconf
  complete -F _filedir_xspec xzcat
  complete -o default -F _fzf_dir_completion rmdir
  complete -F _filedir_xspec slitex
  complete -o bashdefault -o default -F _fzf_opts_completion vim
  complete -F _filedir_xspec aaxine
  complete -F _filedir_xspec advi
  complete -o bashdefault -o default -F _fzf_path_completion more
  complete -o default -F _longopt units
  complete -F _docker dcleanfull
  complete -o default -F _longopt touch
  complete -F _filedir_xspec lzmore
  complete -F _command then
  complete -F _command command
  complete -F _docker dkill
  complete -o default -F __start_kubectl kd
  complete -F _known_hosts fping6
  complete -u runuser
  complete -F _filedir_xspec dvipdf
  complete -o default -F __start_kubectl kc
  complete -F _gradle gradle.bat
  ```
  <!--endsec-->

### osx

> [!NOTE]
> - [Bash Completion](https://sourabhbajaj.com/mac-setup/BashCompletion/)
> - [How to Enable Bash Completion on macOS](https://tecadmin.net/enable-bash-completion-on-macos/)

```bash
$ brew install bash-completion

$ echo "[ -f /usr/local/etc/bash_completion  ] && . /usr/local/etc/bash_completion" >> ~/.bash_profile
$ cat ~/.bash_profile
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
```

- to check link of bash-completion
  ```bash
  $ brew unlink bash-completion --dry-run
  Would remove:
  /usr/local/etc/bash_completion
  /usr/local/etc/bash_completion.d/abook
  /usr/local/etc/bash_completion.d/ant
  ...
  ```

- add more completion files
  ```bash
  $ fd --gen-completions | sudo tee /usr/local/etc/bash_completion.d/fd
  ```

- more
  ```bash
  $ brew search completion
  ==> Formulae
  apm-bash-completion       docker-completion         open-completion           stormssh-completion
  bash-completion ✔         fabric-completion         packer-completion         t-completion
  bash-completion@2         gem-completion            pip-completion            tmuxinator-completion
  boom-completion           gradle-completion ✔       rails-completion          vagrant-completion
  brew-cask-completion ✔    grunt-completion          rake-completion           wp-cli-completion
  bundler-completion        kitchen-completion        ruby-completion           yarn-completion
  cap-completion            launchctl-completion      rustc-completion          zsh-completions
  conda-zsh-completion      maven-completion          sonar-completion
  django-completion         mix-completion            spring-completion

  ==> Casks
  compositor
  ```

### linux

- enable
  ```bash
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
  ```

- add more completion files
  ```bash
  $ fd --gen-completions | sudo tee /usr/share/bash-completion/completions/fd
  ```

  - centos
    ```bash
    $ fd --gen-completions | sudo tee /etc/bash_completion.d/fd
    ```

### troubleshooting

- `$ ssh bash_completion: _comp_compgen_known_hosts__impl: -F: an empty filename is specified`

  > [!NOTE|label:references:]
  > - [Problem with ssh and bash-completion](https://bbs.archlinux.org/viewtopic.php?pid=858200#p858200)
  > - [Autocomplete server names for SSH and SCP](https://unix.stackexchange.com/a/181603/29178)
  > - [`compgen -A hostname`](https://github.com/scop/bash-completion/blob/main/bash_completion#L2470)

  - clear completion
    ```bash
    $ complete -r ssh
    ```

  - or add into `/usr/local/etc/bash_completion.d/ssh`

    ```bash
    # https://unix.stackexchange.com/a/181603/29178
    _ssh_hosts()
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts=$(command grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | command grep -v '[?*]' | cut -d ' ' -f 2-)

        COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
        return 0
    }

    _ssh()
    {
        local cur prev configfile
        local -a config
        # configfile="$HOME/.ssh/config"

        COMPREPLY=()
        _get_comp_words_by_ref -n : cur prev
        #cur=`_get_cword :`
        #prev=`_get_pword`

        _ssh_suboption_check && return 0

        case $prev in
            -F|-i|-S)
                _filedir
                return 0
                ;;
            -c)
                _ssh_ciphers
                return 0
                ;;
            -m)
                _ssh_macs
                return 0
                ;;
            -l)
                COMPREPLY=( $( compgen -u -- "$cur" ) )
                return 0
                ;;
            -o)
                _ssh_options
                return 0
                ;;
            -w)
                _available_interfaces
                return 0
                ;;
            -b)
                _ssh_bindaddress
                return 0
                ;;
        esac

        if [[ "$cur" == -F* ]]; then
            cur=${cur#-F}
            _filedir
            # Prefix completions with '-F'
            COMPREPLY=( "${COMPREPLY[@]/#/-F}" )
            cur=-F$cur  # Restore cur
        elif [[ "$cur" == -* ]]; then
            COMPREPLY=( $( compgen -W '-1 -2 -4 -6 -A -a -C -f -g -K -k -M \
                -N -n -q -s -T -t -V -v -X -v -Y -y -b -b -c -D -e -F \
                -i -L -l -m -O -o -p -R -S -w' -- "$cur" ) )
        else
            # Search COMP_WORDS for '-F configfile' or '-Fconfigfile' argument
            set -- "${COMP_WORDS[@]}"
            while [ $# -gt 0 ]; do
                if [ "${1:0:2}" = -F ]; then
                    if [ ${#1} -gt 2 ]; then
                        configfile="$(dequote "${1:2}")"
                    else
                        shift
                        [ "$1" ] && configfile="$(dequote "$1")"
                    fi
                    break
                fi
                shift
            done
            # marslo >> disable _known_hosts_real from $configfile
            # marslo >> using self-defined _ssh_hosts function
            # _known_hosts_real -a -F "$configfile" "$cur"
            _ssh_hosts
            if [ $COMP_CWORD -ne 1 ]; then
                _compopt_o_filenames
                COMPREPLY=( "${COMPREPLY[@]}" $( compgen -c -- "$cur" ) )
            fi
        fi

        return 0
    }
    shopt -u hostcomplete && complete -F _ssh ssh slogin autossh

    $ complete -F _ssh ssh
    ```

# tricky
## alias for sudo

> [!TIP|label:references:]
> - [Aliases not available when using sudo](https://askubuntu.com/a/22043/92979)
> - [6.6 Aliases](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Aliases)

```bash
alias sudo='sudo '
```

## check file text or binary

> [!NOTE]
> - [How to check if a file is binary?](https://stackoverflow.com/q/16760378/2940319)
>   - [`file`](https://stackoverflow.com/a/16760396/2940319)
>   - [`grep`](https://stackoverflow.com/a/43586072/2940319)
>   - [`perl`](https://stackoverflow.com/a/14603497/2940319)
> - [grep: (standard input): binary file matches](https://unix.stackexchange.com/a/379755/29178)

```bash
$ find . -type f -print0 | perl -0nE 'say if -f and -s _ and -T _'

# verify
$ find . -type f -print0 | perl -0nE 'say if -f and -s _ and -T _' | grep -a -E '\.db$'
```

## get md5sum

- [get file in tar without extacting](https://unix.stackexchange.com/a/208509/29178)
  ```bash
  $ tar -O -xf file.tar.gz file.txt | md5sum

  # or
  $ tar xfO file.tar.gz file.txt | md5sum
  ```

- [get file in zip without extracting](https://stackoverflow.com/a/68703145/2940319)
  ```bash
  $ unzip -p file.zip file.txt | md5sum
  ```
