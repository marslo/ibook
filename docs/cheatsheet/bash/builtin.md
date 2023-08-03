<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [eval](#eval)
- [set](#set)
  - [show current status](#show-current-status)
  - [option name](#option-name)
- [shopt](#shopt)
  - [options](#options)
  - [examples](#examples)
- [readline && bind](#readline--bind)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## eval

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

## [set](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)

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

## [shopt](https://www.gnu.org/software/bash/manual/html_node/the-shopt-builtin.html)

> [!TIP|label:tips:]
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
>
> check without output
> - on
>   ```bash
>   $ shopt -q extglob; echo $?
>   0
>   ```
> - off
>   ```bash
>   $ shopt -q failglob; echo $?
>   1
>   ```

{% hint style='tip' %}
shopt
```bash
shopt [-pqsu] [-o] [optname …]
```
{% endhint %}

| option | expression               |
|:------:|--------------------------|
|  `-s`  | enable  ( [s]et )        |
|  `-u`  | disable ( [u]nset )      |
|  `-q`  | suppresses normal output |
|  `-o`  | `set -o`                 |

### options

- `assoc_expand_once`
- `autocd`
- `cdable_vars`
- `cdspell`
- `checkhash`
- `checkjobs`
- `checkwinsize`
- `cmdhist`
- `compat31`
- `compat32`
- `compat40`
- `compat41`
- `compat42`
- `compat43`
- `compat44`
- `complete_fullquote`
- `direxpand`
- `dirspell`
- `dotglob`
- `execfail`
- `expand_aliases`
- `extdebug`
- `extglob`
- `extquote`
- `failglob`
- `force_fignore`
- `globasciiranges`
- `globstar`
- `gnu_errfmt`
- `histappend`
- `histreedit`
- `histverify`
- `hostcomplete`
- `huponexit`
- `inherit_errexit`
- `interactive_comments`
- `lastpipe`
- `lithist`
- `localvar_inherit`
- `localvar_unset`
- `login_shell`
- `mailwarn`
- `no_empty_cmd_completion`
- `nocaseglob`
- `nocasematch`
- `nullglob`
- `progcomp`
- `progcomp_alias`
- `promptvars`
- `restricted_shell`
- `shift_verbose`
- `sourcepath`
- `xpg_echo`

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
> **[set VS. shopt](https://unix.stackexchange.com/a/490474/29178)**
> - `set` originates from the bourne shell (sh) and is part of the POSIX standard;
> - `shopt` is bourne-again shell (bash) specific
>   ```bash
>   $ set | grep -e SHELLOPTS -e BASHOPTS
>   # for shopt
>   BASHOPTS=cdspell:checkwinsize:cmdhist:complete_fullquote:expand_aliases:extglob:extquote:force_fignore:globasciiranges:histappend:interactive_comments:login_shell:progcomp:promptvars:sourcepath
>   # for set
>   SHELLOPTS=braceexpand:emacs:hashall:histexpand:history:interactive-comments:monitor
>
>   $ set -o |  column -t | grep -v off
>   braceexpand           on
>   emacs                 on
>   hashall               on
>   histexpand            on
>   history               on
>   interactive-comments  on
>   monitor               on
>
>   $ shopt | column -t | grep -v off
>   cdspell                  on
>   checkwinsize             on
>   cmdhist                  on
>   complete_fullquote       on
>   expand_aliases           on
>   extglob                  on
>   extquote                 on
>   force_fignore            on
>   globasciiranges          on
>   histappend               on
>   interactive_comments     on
>   login_shell              on
>   progcomp                 on
>   promptvars               on
>   sourcepath               on
>   ```
{% endhint %}


## [readline](https://www.gnu.org/software/bash/manual/html_node/Command-Line-Editing.html) && [bind](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#index-bind)
