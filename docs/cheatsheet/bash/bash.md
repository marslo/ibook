<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [alias](#alias)
  - [`bash -<parameter>`](#bash--parameter)
- [shell expansions](#shell-expansions)
  - [word splitting](#word-splitting)
  - [Filename Expansion](#filename-expansion)
- [quoting](#quoting)
- [brace expansion](#brace-expansion)
  - [segmented continuous](#segmented-continuous)
  - [scp multipule folder/file to target server](#scp-multipule-folderfile-to-target-server)
  - [all about {curly braces} in bash](#all-about-curly-braces-in-bash)
  - [fast copy or moving or something (detials -> brace expansion)](#fast-copy-or-moving-or-something-detials---brace-expansion)
  - [multiple directories creation](#multiple-directories-creation)
  - [copy single file to multipule folders](#copy-single-file-to-multipule-folders)
- [eval builtin](#eval-builtin)
- [set builtin](#set-builtin)
  - [show current status](#show-current-status)
  - [option name](#option-name)
- [shopt builtin](#shopt-builtin)
  - [options](#options)
  - [examples](#examples)
- [event designators](#event-designators)
  - [word designators](#word-designators)
- [special parameters](#special-parameters)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [alias](https://askubuntu.com/a/871435)
```bash
$ echo ${BASH_ALIASES[ls]}
ls --color=always
```

### [`bash -<parameter>`](https://unix.stackexchange.com/a/38363/29178)
- get bash login log ( for rc script debug )
  ```bash
  $ bash -l -v
  ```

- run with only one startup file ( for sharing accounts )
  ```bash
  $ bash -i --rcfile="$HOME/.marslo/.imarslo"
  ```

## [shell expansions](https://www.gnu.org/software/bash/manual/html_node/shell-expansions.html#shell-expansions)

> [!TIP]
> check the shopt on/off
> - off
>   ```bash
>   $ shopt -u extglob
>   $ shopt extglob
>   extglob         off
>   $ echo $?
>   1
>   ```
> - on
>   ```bash
>   $ shopt -s extglob
>   $ shopt extglob
>   extglob         on
>   $ echo $?
>   0
>   ```

{% hint style='tip' %}
references:
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/html_node/index.html#SEC_Contents)
- [Bash Reference Manual ZH](https://yiyibooks.cn/Phiix/bash_reference_manual/bash%E5%8F%82%E8%80%83%E6%96%87%E6%A1%A3.html)
  - [Brace Expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html)
  - [Tilde Expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html)
  - [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html)
  - [Command Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html)
  - [Arithmetic Expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html)
  - [Process Substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html)
  - [Word Splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html)
  - [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html)
    - [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html)
  - [Quote Removal](https://www.gnu.org/software/bash/manual/html_node/Quote-Removal.html)

- And:
  - [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
  - [The Shopt Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html)

- And
  - [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html)
    - [Chapter 3. The Bash environment](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_02.html)
{% endhint %}

|            NAME           | EXAMPLE                                     |
|:-------------------------:|---------------------------------------------|
|      Brace Expansion      | `echo a{d,c,b}e`                            |
|      Tilde Expansion      | `~`                                         |
| Shell Parameter Expansion | `string=01234567890abc; echo ${string:7:2}` |
|    Command Substitution   | `$(command)` or <code>`command`</code>      |
|    Arithmetic Expansion   | `$(( expression ))`                         |
|    Process Substitution   | `<(list)` or `>(list)`                      |
|       Word Splitting      | `$IFS`                                      |
|     Filename Expansion    | `*`, `?` , `[..]`,...                       |

### [word splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html)
> due to 7 fields are spitted via `:` in /etc/passwd

```bash
IFS=':'
read f1 f2 f3 f4 f5 f6 f7 < /etc/passwd
```

### [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html)
> Bash scans each word for the characters `'*'`, `'?'`, and `'['`, unless the `-f` (`set -f`) option has been set

| CONDITION                             | RESULT                                                                                            |
|---------------------------------------|---------------------------------------------------------------------------------------------------|
| match found && `nullglob` disabled    | the word is regarded as a pattern                                                                 |
| no match found && `nullglob` disabled | the word is left unchanged                                                                        |
| no match found && `nullglob` set      | the word is removed                                                                               |
| no match found && `failglob` set      | show error msg and cmd won't be exectued                                                          |
| `nocaseglob` enabled                  | patten match case insensitive                                                                     |
| `set -o noglob` or `set -f`           | `*` will not be expanded                                                                          |
| `shopt -s dotglob`                    | `*` will including all `.*`. see [zip package with dot-file](good.html#zip-package-with-dot-file) |


## [quoting](https://www.gnu.org/software/bash/manual/html_node/quoting.html#quoting)
> - [Difference between single and double quotes in Bash](https://stackoverflow.com/a/42082956/2940319)
> - [ANSI-C quoting with $'' - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html)
> - [Locale translation with $"" - GNU Bash Manual](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation)
> - [A three-point formula for quotes](https://stackoverflow.com/a/42104627/6862601)

{% hint style='tip' %}
sample:
```bash
a=apple      # a simple variable
arr=(apple)  # an indexed array with a single element
```
{% endhint %}

| #    | Expression                 | Result                  | Comments                                                                                           |
| :--: | :------------------------: | ----------------------- | ---------------------------------------------------------------------------------                  |
| 1    | `"$a"`                     | `apple`                 | variables are expanded inside `""`                                                                 |
| 2    | `'$a'`                     | `$a`                    | variables are not expanded inside `''`                                                             |
| 3    | `"'$a'"`                   | `'apple'`               | `''` has no special meaning inside `""`                                                            |
| 4    | `'"$a"'`                   | `"$a"`                  | `""` is treated literally inside `''`                                                              |
| 5    | `'\''`                     | invalid                 | can not escape a `'` within `''`; use `"'"` or `$'\''` (ANSI-C quoting)                            |
| 6    | `"red$arocks"`             | `red`                   | `$arocks` does not expand `$a`; use `${a}rocks` to preserve `$a`                                   |
| 7    | `"redapple$"`              | `redapple$`             | `$` followed by no variable name evaluates to `$`                                                  |
| 8    | `'\"'`                     | `\"`                    | `\` has no special meaning inside `''`                                                             |
| 9    | `"\'"`                     | `\'`                    | `\'` is interpreted inside `""` but has no significance for '                                      |
| 10   | `"\""`                     | `"`                     | `\"` is interpreted inside `""`                                                                    |
| 11   | `"*"`                      | `*`                     | glob does not work inside `""` or `''`                                                             |
| 12   | `"\t\n"`                   | `\t\n`                  | `\t` and `\n` have no special meaning inside `""` or `''`; use ANSI-C quoting                      |
| 13   | <code>"`echo hi`"</code>   | `hi`                    | <code>``</code> and `$()` are evaluated inside `""` (backquotes are retained in actual output)     |
| 14   | <code>'`echo hi`'</code>   | <code>echo` hi</code>   | <code>``</code> and `$()` are not evaluated inside `''` (backquotes are retained in actual output) |
| 15   | `'${arr[0]}'`              | `${arr[0]}`             | array access not possible inside `''`                                                              |
| 16   | `"${arr[0]}"`              | `apple`                 | array access works inside `""`                                                                     |
| 17   | `$'$a\''`                  | `$a'`                   | single quotes can be escaped inside ANSI-C quoting                                                 |
| 18   | `"$'\t'"`                  | `$'\t'`                 | ANSI-C quoting is not interpreted inside `""`                                                      |
| 19   | `'!cmd'`                   | `!cmd`                  | history expansion character `'!'` is ignored inside `''`                                           |
| 20   | `"!cmd"`                   | `cmd` args              | expands to the most recent command matching `"cmd"`                                                |
| 21   | `$'!cmd'`                  | `!cmd`                  | history expansion character `'!'` is ignored inside ANSI-C quotes                                  |


## [brace expansion](https://www.gnu.org/software/bash/manual/html_node/brace-expansion.html)
### [segmented continuous](https://stackoverflow.com/a/44429171/2940319)
```bash
# exclude 7 from 1-10
$ echo test-{{1..6},{8..10}}
test-1 test-2 test-3 test-4 test-5 test-6 test-8 test-9 test-10
```

### scp multipule folder/file to target server
```bash
$ scp -r $(echo dir{1..10}) user@target.server:/target/server/path/
```

### [all about {curly braces} in bash](https://www.linux.com/tutorials/all-about-curly-braces-bash/)
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

### fast copy or moving or something ([detials](http://www.manpager.com/linux/man1/bash.1.html) -> brace expansion)
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

### multiple directories creation
```bash
$ mkdir sa{1..50}
$ mkdir -p sa{1..50}/sax{1..50}
$ mkdir {a-z}12345
$ mkdir {1,2,3}
$ mkdir test{01..10}
$ mkdir -p `date '+%y%m%d'`/{1,2,3}
$ mkdir -p $USER/{1,2,3}
```

### copy single file to multipule folders
```bash
$ echo dir1 dir2 dir3 | xargs -n 1 cp file1

# or
$ echo dir{1..10} | xargs -n 1 cp file1
```

## eval builtin

{% hint style='tip' %}
**eval** — **construct command by concatenating arguments**

**reference**:
> - [Bash eval command](https://linuxhint.com/bash_eval_command/)
> - [functions / eval (source, CPAN)](https://perldoc.perl.org/functions/eval)
> - [What is the “eval” command in bash?](https://unix.stackexchange.com/a/23117/29178)
{% endhint %}

- example
  - without `eval`:
    ```bash
    $ foo='ls | less'
    $ $foo
    ls: cannot access '|': No such file or directory
    ls: cannot access 'less': No such file or directory
    ```
  - with `eval`:
    ```bash
    $ foo='ls | less'
    $ eval $foo
    Applications
    Library
    System
    Users
    ...
    ```

- example
  ```bash
  $ x=10
  $ y=x
  $ foo='$'$x
  $ echo $foo
  $x

  # with eval
  $ eval foo='$'$x         # with eval
  $ echo $foo
  10

  # or
  $ foo=\$$x
  $ eval echo $foo          # with eval
  10
  $ echo $foo
  $x
  ```

## [set builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

> [!NOTE]
> **reference**:
> - [Writing Robust Bash Shell Scripts](https://www.davidpashley.com/articles/writing-robust-shell-scripts/)
> - [用内置的set和shopt命令来设置bash的选项](https://blog.csdn.net/tonyyong90/article/details/105606638)
>
> **set**
>   ```
>   set [--abefhkmnptuvxBCEHPT] [-o option-name] [argument …]
>   set [+abefhkmnptuvxBCEHPT] [+o option-name] [argument …]
>   ```
>
> - example
>   ```bash
>   $ set | grep -e SHELLOPTS -e BASHOPTS
>   BASHOPTS=cdspell:checkwinsize:cmdhist:complete_fullquote:expand_aliases:extglob:extquote:force_fignore:globasciiranges:histappend:interactive_comments:login_shell:progcomp:promptvars:sourcepath
>   SHELLOPTS=braceexpand:emacs:hashall:histexpand:history:interactive-comments:monitor
>   ```


|      OPTION      | EXPLANATION                                                                                                  |
|:----------------:|--------------------------------------------------------------------------------------------------------------|
|       `-a`       | `-o allexport`                                                                                               |
|       `-b`       | cause the status of terminated background jobs to be reported immediately                                    |
|       `-e`       | `-o errexit`<br>Exit immediately if a pipeline returns a non-zero status                                     |
|       `-f`       | Disable filename expansion (globbing)                                                                        |
|       `-h`       | `-o hashall`                                                                                                 |
|       `-k`       | `-o keyword`                                                                                                 |
|       `-m`       | `-o monitor`                                                                                                 |
|       `-n`       | `-o noexec`                                                                                                  |
| `-o option-name` | see [option name ](#option-name)                                                                             |
|       `-p`       | `-o privileged`<br> the `$BASH_ENV` and `$ENV` files are not processed                                       |
|       `-t`       | `-o onecmd`                                                                                                  |
|       `-u`       | `-o unset`<br>treat unset variables and parameters other than the special parameters '@' or '*' as an error  |
|       `-v`       | verbose. <br> print shell input lines as they are read                                                       |
|       `-x`       | `-o xtrace`<br>[debug] print commands and their arguments as they are executed                               |
|       `-B`       | `-o braceexpand`<br> shell will perform brace expansion                                                      |
|       `-c`       | `-o noclobber`<br>prevent output redirection using '>', '>&', and '<>' from overwriting existing files.      |
|       `-E`       | `-o errtrace`                                                                                                |
|       `-H`       | `-o histexpand`                                                                                              |
|       `-P`       | do not resolve symbolic links                                                                                |
|       `-T`       | `-o functrace`<br>any trap on `DEBUG` and `RETURN` are inherited by shell functions                          |
|       `--`       | if no arguments follow this option, then the positional parameters are unset                                 |
|        `-`       | signal the end of options, cause all remaining arguments to be assigned to the positional parameters         |


### show current status
- `set -o`
  ```bash
  $ set -o
  allexport       off
  braceexpand     on
  emacs           on
  errexit         off
  errtrace        off
  functrace       off
  hashall         on
  histexpand      on
  history         on
  ignoreeof       off
  interactive-comments  on
  keyword         off
  monitor         on
  noclobber       off
  noexec          off
  noglob          off
  nolog           off
  notify          off
  nounset         off
  onecmd          off
  physical        off
  pipefail        off
  posix           off
  privileged      off
  verbose         off
  vi              off
  xtrace          off
  ```

- `set +o`
  ```bash
  $ set +o
  set +o allexport
  set -o braceexpand
  set -o emacs
  set +o errexit
  set +o errtrace
  set +o functrace
  set -o hashall
  set -o histexpand
  set -o history
  set +o ignoreeof
  set -o interactive-comments
  set +o keyword
  set -o monitor
  set +o noclobber
  set +o noexec
  set +o noglob
  set +o nolog
  set +o notify
  set +o nounset
  set +o onecmd
  set +o physical
  set +o pipefail
  set +o posix
  set +o privileged
  set +o verbose
  set +o vi
  set +o xtrace
  ```

### option name

|     option    | expression                                                                                                                                                                                                         |
|:-------------:|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|  `allexport`  | Same as `-a`.                                                                                                                                                                                                      |
| `braceexpand` | Same as `-B`.                                                                                                                                                                                                      |
|    `emacs`    | Use an emacs-style line editing interface.<br> This also affects the editing interface used for read `-e`.                                                                                                         |
|   `errexit`   | Same as `-e`.                                                                                                                                                                                                      |
|   `errtrace`  | Same as `-E`.                                                                                                                                                                                                      |
|  `functrace`  | Same as `-T`.                                                                                                                                                                                                      |
|   `hashall`   | Same as `-h`.                                                                                                                                                                                                      |
|  `histexpand` | Same as `-H`.                                                                                                                                                                                                      |
|   `history`   | Enable command history, as described in Bash History Facilities. This option is on by default in interactive shells.                                                                                               |
|  `ignoreeof`  | An interactive shell will not exit upon reading EOF.                                                                                                                                                               |
|   `keyword`   | Same as `-k`.                                                                                                                                                                                                      |
|   `monitor`   | Same as `-m`.                                                                                                                                                                                                      |
|  `noclobber`  | Same as `-C`.                                                                                                                                                                                                      |
|    `noexec`   | Same as `-n`.                                                                                                                                                                                                      |
|    `noglob`   | Same as `-f`.                                                                                                                                                                                                      |
|    `nolog`    | Currently ignored.                                                                                                                                                                                                 |
|    `notify`   | Same as `-b`.                                                                                                                                                                                                      |
|   `nounset`   | Same as `-u`.                                                                                                                                                                                                      |
|    `onecmd`   | Same as `-t`.                                                                                                                                                                                                      |
|   `physical`  | Same as `-P`.                                                                                                                                                                                                      |
|   `pipefail`  | If set, the return value of a pipeline is the value of the last (rightmost) command to exit with a non-zero status, or zero if all commands in the pipeline exit successfully. This option is disabled by default. |
|    `posix`    | Change the behavior of Bash where the default operation differs from the POSIX standard to match the standard (see Bash POSIX Mode). This is intended to make Bash behave as a strict superset of that standard.   |
|  `privileged` | Same as `-p`.                                                                                                                                                                                                      |
|   `verbose`   | Same as `-v`.                                                                                                                                                                                                      |
|      `vi`     | Use a vi-style line editing interface. This also affects the editing interface used for read `-e`.                                                                                                                 |
|    `xtrace`   | Same as `-x`.                                                                                                                                                                                                      |

## [shopt builtin](https://www.gnu.org/software/bash/manual/html_node/the-shopt-builtin.html)

{% hint style='tip' %}
shopt
```bash
shopt [-pqsu] [-o] [optname …]
```
{% endhint %}

| option | expression               |
|:------:|--------------------------|
|  `-s`  | enable                   |
|  `-u`  | disable                  |
|  `-q`  | suppresses normal output |
|  `-o`  | `set -o`                 |

### options

|          options          |
|:-------------------------:|
|    `assoc_expand_once`    |
|          `autocd`         |
|       `cdable_vars`       |
|         `cdspell`         |
|        `checkhash`        |
|        `checkjobs`        |
|       `checkwinsize`      |
|         `cmdhist`         |
|         `compat31`        |
|         `compat32`        |
|         `compat40`        |
|         `compat41`        |
|         `compat42`        |
|         `compat43`        |
|         `compat44`        |
|    `complete_fullquote`   |
|        `direxpand`        |
|         `dirspell`        |
|         `dotglob`         |
|         `execfail`        |
|      `expand_aliases`     |
|         `extdebug`        |
|         `extglob`         |
|         `extquote`        |
|         `failglob`        |
|      `force_fignore`      |
|     `globasciiranges`     |
|         `globstar`        |
|        `gnu_errfmt`       |
|        `histappend`       |
|        `histreedit`       |
|        `histverify`       |
|       `hostcomplete`      |
|        `huponexit`        |
|     `inherit_errexit`     |
|   `interactive_comments`  |
|         `lastpipe`        |
|         `lithist`         |
|     `localvar_inherit`    |
|      `localvar_unset`     |
|       `login_shell`       |
|         `mailwarn`        |
| `no_empty_cmd_completion` |
|        `nocaseglob`       |
|       `nocasematch`       |
|         `nullglob`        |
|         `progcomp`        |
|      `progcomp_alias`     |
|        `promptvars`       |
|     `restricted_shell`    |
|      `shift_verbose`      |
|        `sourcepath`       |
|         `xpg_echo`        |

### examples
- show all status
  ```bash
  $ shopt -p
  shopt -u autocd
  shopt -u assoc_expand_once
  shopt -u cdable_vars
  shopt -s cdspell
  shopt -u checkhash
  shopt -u checkjobs
  shopt -s checkwinsize
  shopt -s cmdhist
  shopt -u compat31
  shopt -u compat32
  shopt -u compat40
  shopt -u compat41
  shopt -u compat42
  shopt -u compat43
  shopt -u compat44
  shopt -s complete_fullquote
  shopt -u direxpand
  shopt -u dirspell
  shopt -u dotglob
  shopt -u execfail
  shopt -s expand_aliases
  shopt -u extdebug
  shopt -s extglob
  shopt -s extquote
  shopt -u failglob
  shopt -s force_fignore
  shopt -s globasciiranges
  shopt -u globstar
  shopt -u gnu_errfmt
  shopt -s histappend
  shopt -u histreedit
  shopt -u histverify
  shopt -u hostcomplete
  shopt -u huponexit
  shopt -u inherit_errexit
  shopt -s interactive_comments
  shopt -u lastpipe
  shopt -u lithist
  shopt -u localvar_inherit
  shopt -u localvar_unset
  shopt -s login_shell
  shopt -u mailwarn
  shopt -u no_empty_cmd_completion
  shopt -u nocaseglob
  shopt -u nocasematch
  shopt -u nullglob
  shopt -s progcomp
  shopt -u progcomp_alias
  shopt -s promptvars
  shopt -u restricted_shell
  shopt -u shift_verbose
  shopt -s sourcepath
  shopt -u xpg_echo
  ```

- show single option
  ```bash
  # shopt -s sourcepath
  $ shopt -q sourcepath; echo $?
  0

  # shopt -u xpg_echo
  $ shopt -q xpg_echo; echo $?
  1
  ```

{% hint style='tip' %}
**[set VS. shopt](https://unix.stackexchange.com/a/490474/29178)**
```bash
$ set | grep -e SHELLOPTS -e BASHOPTS
BASHOPTS=cdspell:checkwinsize:cmdhist:complete_fullquote:expand_aliases:extglob:extquote:force_fignore:globasciiranges:histappend:interactive_comments:login_shell:progcomp:promptvars:sourcepath
SHELLOPTS=braceexpand:emacs:hashall:histexpand:history:interactive-comments:monitor

$ set -o |  column -t | grep -v off
braceexpand           on
emacs                 on
hashall               on
histexpand            on
history               on
interactive-comments  on
monitor               on

$ shopt | column -t | grep -v off
cdspell                  on
checkwinsize             on
cmdhist                  on
complete_fullquote       on
expand_aliases           on
extglob                  on
extquote                 on
force_fignore            on
globasciiranges          on
histappend               on
interactive_comments     on
login_shell              on
progcomp                 on
promptvars               on
sourcepath               on
```
{% endhint %}

## [event designators](https://www.gnu.org/software/bash/manual/html_node/event-designators.html)

|        option       | expression                                                                                               |
|:-------------------:|----------------------------------------------------------------------------------------------------------|
|         `!`         | start a history substitution                                                                             |
|         `!n`        | refer to command line n                                                                                  |
|        `!-n`        | refer to the command n lines back                                                                        |
|         `!!`        | refer to the previous command                                                                            |
|      `!string`      | refer to the most recent command preceding the current position in the history list starting with string |
|    `!?string[?]`    | refer to the most recent command preceding the current position in the history list containing string.   |
| `^string1^string2^` | `!!:s^string1^string2^` <br> quick substitution. repeat the last command, replacing string1 with string2 |
|         `!#`        | the entire command line typed so far                                                                     |

### [word designators](https://www.gnu.org/software/bash/manual/html_node/word-designators.html)

|     option     | expression                                                                             |
|:--------------:|----------------------------------------------------------------------------------------|
|      `!!`      | designates the preceding command                                                       |
| `!!:$` or `!$` | designates the last argument of the preceding command                                  |
|     `!fi:2`    | designates the second argument of the most recent command starting with the letters fi |


{% hint style='tip' %}
**`$_` VS. `!$`**

> reference:
> - [Understand the meaning of `$_`](https://unix.stackexchange.com/a/280557/29178)

-`$_`
  - [bash variables](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html)
  - if the invoking application doesn't pass a _ environment variable, the invoked bash shell will initialise $_ to the argv[0] it receives itself which could be bash
  - i.e.
    ```bash
    $ env | grep '^_='
    _=/usr/local/opt/coreutils/libexec/gnubin/env

    # or
    $ env bash -c 'echo "$_"'
    /usr/local/opt/coreutils/libexec/gnubin/env
    ```
- `!$`
  - [Word Designators](https://www.gnu.org/software/bash/manual/html_node/Word-Designators.html)
  - equal to `!!:$`
{% endhint %}

## [special parameters](https://tldp.org/LDP/Bash-Beginners-Guide/html/sect_03_02.html)

| character | definition                                                                                                                                                                                                                                                                                                                                                                                                                                     |
|:---------:|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|    `$*`   | expands to the positional parameters, starting from one. when the expansion occurs within double quotes, it expands to a single word with the value of each parameter separated by the first character of the ifs special variable.                                                                                                                                                                                                            |
|    `$@`   | expands to the positional parameters, starting from one. when the expansion occurs within double quotes, each parameter expands to a separate word.                                                                                                                                                                                                                                                                                            |
|    `$#`   | expands to the number of positional parameters in decimal.                                                                                                                                                                                                                                                                                                                                                                                     |
|    `$?`   | expands to the exit status of the most recently executed foreground pipeline.                                                                                                                                                                                                                                                                                                                                                                  |
|    `$-`   | a hyphen expands to the current option flags as specified upon invocation, by the set built-in command, or those set by the shell itself (such as the -i).                                                                                                                                                                                                                                                                                     |
|    `$$`   | expands to the process id of the shell.                                                                                                                                                                                                                                                                                                                                                                                                        |
|    `$!`   | expands to the process id of the most recently executed background (asynchronous) command.                                                                                                                                                                                                                                                                                                                                                     |
|    `$0`   | expands to the name of the shell or shell script.                                                                                                                                                                                                                                                                                                                                                                                              |
|    `$_`   | the underscore variable is set at shell startup and contains the absolute file name of the shell or script being executed as passed in the argument list. <br>subsequently, it expands to the last argument to the previous command, after expansion. it is also set to the full pathname of each command executed and placed in the environment exported to that command. when checking mail, this parameter holds the name of the mail file. |

{% hint style='tip' %}
**`$*` vs. `$@`**:
- The implementation of `"$*"` has always been a problem and realistically should have been replaced with the behavior of `"$@"`.
- In almost every case where coders use `"$*"`, they mean `"$@"`.
- `"$*"` Can cause bugs and even security holes in your software.
{% endhint %}
