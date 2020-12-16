<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Utils](#utils)
  - [shell paramters](#shell-paramters)
    - [pass self parameters to another script](#pass-self-parameters-to-another-script)
    - [getopts with long option](#getopts-with-long-option)
  - [Network](#network)
    - [Get Interface by command](#get-interface-by-command)
    - [get ipv4 address](#get-ipv4-address)
  - [system command](#system-command)
    - [use parameter in `xargs`](#use-parameter-in-xargs)
    - [find out commands belongs to and come from](#find-out-commands-belongs-to-and-come-from)
    - [Get all google website](#get-all-google-website)
- [readline & bind](#readline--bind)
  - [get info](#get-info)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Utils
## shell paramters
### pass self parameters to another script
> objective:
> `$ ./b.sh a b c d` -> `$ ./a.sh a b c d`

- b.sh
  ```bash
  #!/bin/bash
  echo """
  b.sh:
    \$1: "$1"
    \$#: "$#"
    \$@: "$@"
    \${@: -1}: ${@: -1}
    \${@: -2}: ${@: -2}
    \${@: -3}: ${@: -2}
    \${@: -\$(( \$#-1 ))}: ${@: -$(( $#-1 ))}
    \$(echo '\${@: -\$(( \$#-1 ))}' | cut -d' ' -f1-) : $(echo "${@: -$(( $#-1 ))}" | cut -d' ' -f1-)
  """
  echo -e "\n'~~> ./a.sh \"\${@: -1}\"': ~~~> ./a.sh ${@: -1}:"
  ./a.sh "${@: -1}"

  echo -e "\n'~~> ./a.sh \$(echo '\${@: -1}' | cut -d' ' -f1-)': ~~~> ./a.sh $(echo "${@: -1}" | cut -d' ' -f1-):"
  ./a.sh $(echo "${@: -1}" | cut -d' ' -f1-)

  echo -e "\n'~~> ./a.sh \"\${@: -4}\"': ~~~> ./a.sh ${@: -4}:"
  ./a.sh "${@: -4}"

  echo -e "\n'~~> ./a.sh \$(echo '\${@: -\$(( \$#-1 ))}' | cut -d' ' -f1-)': ~~~> ./a.sh $(echo "${@: -$(( $#-1 ))}" | cut -d' ' -f1-)"
  ./a.sh $(echo "${@: -$(( $#-1 ))}" | cut -d' ' -f1-)
  ```

- a.sh
  ```bash
  echo """
  a.sh:
    \$1: "$1"
    \$#: "$#"
    \$@: "$@"
    \${@: -$(( $#-2 ))}: ${@: -$(( $#-2 ))}
  """
  ```

- result
  ```bash
  $ ./b.sh a b c d e

  b.sh:
    $1: a
    $#: 5
    $@: a b c d e
    ${@: -1}: e
    ${@: -2}: d e
    ${@: -3}: d e
    ${@: -$(( $#-1 ))}: b c d e
    $(echo '${@: -$(( $#-1 ))}' | cut -d' ' -f1-) : b c d e

  '~~> ./a.sh "${@: -1}"': ~~~> ./a.sh e:
  a.sh:
    $1: e
    $#: 1
    $@: e
    ${@: --1}: e

  '~~> ./a.sh $(echo '${@: -1}' | cut -d' ' -f1-)': ~~~> ./a.sh e:
  a.sh:
    $1: e
    $#: 1
    $@: e
    ${@: --1}: e

  '~~> ./a.sh "${@: -4}"': ~~~> ./a.sh b c d e:
  a.sh:
    $1: b
    $#: 4
    $@: b c d e
    ${@: -2}: d e

  '~~> ./a.sh $(echo '${@: -$(( $#-1 ))}' | cut -d' ' -f1-)': ~~~> ./a.sh b c d e
  a.sh:
    $1: b
    $#: 4
    $@: b c d e
    ${@: -2}: d e
  ```

### getopts with long option
```bash
#!/bin/bash
# shellcheck disable=SC1079,SC1078

usage="""USAGE
\t$0\t[-h|--help] [-c|--clean] [-t|--tag <tag>] [-i|--image <image>]
\t\t\t[-v|--ver <new-version>] [-n|--name <name>]
\t\t\t[-p|--prop <key=value>]
"""

while test -n "$1"; do
    case "$1" in
      -c | --clean ) clean=true ; shift   ;;
      -t | --tag   ) tag=$2     ; shift 2 ;;
      -i | --image ) image=$2   ; shift 2 ;;
      -v | --ver   ) ver=$2     ; shift 2 ;;
      -n | --name  ) name=$2    ; shift 2 ;;
      -p | --prop  ) prop=$2    ; shift 2 ;;
      -h | --help | * ) echo -e "${usage}"; exit 0 ;;
    esac
done

echo """
  clean : ${clean}
    tag : ${tag}
  image : ${image}
    ver : ${ver}
   name : ${name}
   prop : ${prop}
"""
```
- result
  ```bash
  $ ./longopts.sh -h
  USAGE
    ./longopts.sh [-h|--help] [-c|--clean] [-t|--tag <tag>] [-i|--image <image>]
                  [-v|--ver <new-version>] [-n|--name <name>]
                  [-p|--prop <key=value>]

  $ ./longopts.sh -c
    clean : true
      tag :
    image :
      ver :
     name :
     prop :

  $ ./longopts.sh -c -t 'ttt' -i 'iii' --ver '1.1.1' --name 'name'
    clean : true
      tag : ttt
    image : iii
      ver : 1.1.1
     name : name
     prop :
  ```

## Network
### Get Interface by command
```bash
interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')
# or get the route to github
interface=$(ip route get $(nslookup github.com | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
```

### get ipv4 address
```bash
ipAddr=$(ip a s "${interface}" | sed -rn 's|.*inet ([0-9\.]{7,15})/[0-9]{2} brd.*$|\1|p')
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

### find out commands belongs to and come from
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

### Get all google website
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

# readline & bind
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
