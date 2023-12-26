<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [using string as variable name](#using-string-as-variable-name)
- [`<<<`, `< <(..)`](#--)
  - [`< <(..)` && `> >(..)`](#----)
- [parameter substitution](#parameter-substitution)
  - [arguments substitution](#arguments-substitution)
- [string manipulations](#string-manipulations)
- [compound comparison](#compound-comparison)
  - [SC2155](#sc2155)
  - [SC2155](#sc2155-1)
  - [escape code](#escape-code)
- [alias for sudo](#alias-for-sudo)
- [echo](#echo)
  - [echo var name from variable](#echo-var-name-from-variable)
  - [echo var name](#echo-var-name)
- [bash completion](#bash-completion)
  - [osx](#osx)
  - [linux](#linux)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> reference:
> - [ppo/gist/bash.md](https://github.com/ppo/gist/blob/master/bash.md)
> - [Unix / Linux - Shell Substitution](https://www.tutorialspoint.com/unix/unix-shell-substitutions.htm)
> - [ShellCheck Wiki Sitemap](https://www.shellcheck.net/wiki/)
{% endhint %}


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


## alias for sudo

> [!TIP|label:references:]
> - [Aliases not available when using sudo](https://askubuntu.com/a/22043/92979)
> - [6.6 Aliases](https://www.gnu.org/savannah-checkouts/gnu/bash/manual/bash.html#Aliases)

```bash
alias sudo='sudo '
```

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

## bash completion

> [!NOTE|label:references]
> - [* Creating a bash completion script](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial)
> - [8.7 Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html)
> - [8.6 Programmable Completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
> - [8.8 A Programmable Completion Example](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html#A-Programmable-Completion-Example)
> - [cykerway/complete-alias](https://github.com/cykerway/complete-alias)
> - [Multi Level Bash Completion](https://stackoverflow.com/a/5303225/2940319)
> - [List all commands that a shell knows](https://unix.stackexchange.com/a/94825/29178)
> - [* iMarslo : `_vim()`](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/.marslo/.completion/vim.sh)
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

- list all completions
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
