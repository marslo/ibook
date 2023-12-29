<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [utils](#utils)
  - [padRight](#padright)
    - [theory](#theory)
    - [padRight](#padright-1)
    - [example](#example)
  - [system command](#system-command)
    - [use parameter in `xargs`](#use-parameter-in-xargs)
    - [find commands belongs to and come from](#find-commands-belongs-to-and-come-from)
    - [find alias come from](#find-alias-come-from)
    - [get command from PATH](#get-command-from-path)
    - [get all google website](#get-all-google-website)
  - [check linux window size](#check-linux-window-size)
- [readline & bind](#readline--bind)
  - [get info](#get-info)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Hidden features of Bash](https://stackoverflow.com/q/211378/2940319)

# utils
## padRight

> [!NOTE]
> references:
> - [Padding characters in printf](https://stackoverflow.com/questions/4409399/padding-characters-in-printf)

### theory
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

### example
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

## system command
### [use parameter in `xargs`](https://unix.stackexchange.com/a/100972/29178)
```bash
$ find . -type f | xargs -n 1 -I FILE bash -c 'echo $(file --mime-type -b FILE)'
text/plain
text/plain
text/plain
inode/x-empty
text/plain
text/plain
text/plain
text/plain
text/plain
text/plain
```

### find commands belongs to and come from
- belongs to
  ```bash
  $ type which
  which is aliased to `alias | which -a --tty-only --read-alias --show-dot --show-tilde'

  $ type bello
  bello is a function
  bello ()
  {
    source "${iRCHOME}/.imac"
  }
  ```

- [come from](https://unix.stackexchange.com/a/322887/29178)
  ```bash
  $ shopt -s extdebug

  $ declare -F _completion_loader
  _completion_loader 2219 /usr/local/Cellar/bash-completion@2/2.11/share/bash-completion/bash_completion

  $ declare -F _docker
  _docker 5463 /usr/local/etc/bash_completion.d/docker

  $ declare -F __git_ps1
  __git_ps1 340 /usr/local/etc/bash_completion.d/git-prompt.sh

  $ declare -F bello
  bello 79 /Users/marslo/.marslo/.marslorc
  ```

  - linux
    ```bash
    $ bash --debugger
    $ declare -F _docker
    _docker 5011 /usr/share/bash-completion/completions/docker
    ```

### find alias come from

> [!NOTE|label:references:]
> - [Is it possible to check where an alias was defined?](https://unix.stackexchange.com/a/322468/29178)

```bash
$ bash -ixlc : 2>&1 | grep ...
$ zsh -ixc : 2>&1 | grep ...
```

- i.e.:
  ```bash
  $ bash -ixlc : 2>&1 | grep 'clr='
      /Users/marslo/.marslo/.alias/docker::16: alias 'dclr=docker system prune -a -f'
      /Users/marslo/.marslo/.alias/utils::22: alias clr=clear
  ```

### get command from PATH

> [!NOTE|label:references:]
> - [How to use `which` on an aliased command?](https://unix.stackexchange.com/q/10525/29178)

```bash
$ type -a kubectl
kubectl is aliased to `kubecolor'
kubectl is /Users/marslo/.docker/bin/kubectl
```

- `type -P`
  ```bash
  $ type -P kubectl
  /Users/marslo/.docker/bin/kubectl
  ```

- `/usr/bin/which`
  ```bash
  $ /usr/bin/which kubectl
  /Users/marslo/.docker/bin/kubectl
  ```

- `which --skip-alias`
  ```bash
  $ which --skip-alias kubectl
  ~/.docker/bin/kubectl
  ```

- `shopt -u expand_aliases`
  ```bash
  $ type -a kubectl
  kubectl is aliased to `kubecolor'
  kubectl is /Users/marslo/.docker/bin/kubectl

  $ shopt -u expand_aliases
  $ type -a kubectl
  kubectl is /Users/marslo/.docker/bin/kubectl

  $ shopt -s expand_aliases
  ```

- check alias only
  ```bash
  $ echo ${BASH_ALIASES[kubectl]}
  kubecolor
  ```

### get all google website
```bash
$ whois www.google.com

Whois Server Version 2.0

Domain names in the .com and .net domains can now be registered
with many different competing registrars. Go to http://www.internic.net
for detailed information.

  Server Name: WWW.GOOGLE.COM.VN
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TW
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TR
  Registrar: TUCOWS DOMAINS INC.
  Whois Server: whois.tucows.com
  Referral URL: http://domainhelp.opensrs.net

  Server Name: WWW.GOOGLE.COM.SA
  Registrar: OMNIS NETWORK, LLC
  Whois Server: whois.omnis.com
  Referral URL: http://domains.omnis.com

  Server Name: WWW.GOOGLE.COM.PK
  Registrar: INTERNET.BS CORP.
  Whois Server: whois.internet.bs
  Referral URL: http://www.internet.bs

  Server Name: WWW.GOOGLE.COM.PE
  Registrar: HOSTOPIA.COM INC. D/B/A APLUS.NET
  Whois Server: whois.names4ever.com
  Referral URL: http://www.aplus.net

  Server Name: WWW.GOOGLE.COM.MX
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.HK
  Registrar: GKG.NET, INC.
  Whois Server: whois.gkg.net
  Referral URL: http://www.gkg.net

  Server Name: WWW.GOOGLE.COM.DO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.CO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.BR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.AU
  Registrar: MELBOURNE IT, LTD. D/B/A INTERNET NAMES WORLDWIDE
  Whois Server: whois.melbourneit.com
  Referral URL: http://www.melbourneit.com

  Server Name: WWW.GOOGLE.COM.AR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

>>> Last update of whois database: Mon, 24 Feb 2014 17:24:05 UTC <<<
```

## [check linux window size](https://askubuntu.com/a/1020938/92979)
- check
  ```bash
  $ shopt | grep checkwinsize
  checkwinsize    on
  ```
- enable
  ```bash
  $ shopt -s checkwinsize
  ```

# readline & bind

> [!NOTE]
> - [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Completion.html)

## get info
- get current keymap
  ```bash
  $ bind -v | awk '/keymap/ {print $NF}'
  vi-insert
  ```

  - [tricky for switch keymap](https://unix.stackexchange.com/a/409866/29178)
    ```bash
    set keymap emacs
    "\ee": vi-editing-mode

    set keymap vi-insert
    "\e": vi-movement-mode

    set keymap vi-command
    "\ee": emacs-editing-mode
    ```
