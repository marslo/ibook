<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [pass self parameters to another script](#pass-self-parameters-to-another-script)
- [getopts with long option](#getopts-with-long-option)
  - [additional params on `--`](#additional-params-on---)
- [shift](#shift)
  - [shift with uncertain params](#shift-with-uncertain-params)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:see also:]
> - [* iMarslo: parameter substitution](../../cheatsheet/bash/sugar.html#parameter-substitution)

## pass self parameters to another script

> [!NOTE]
> - objective:
>   ````
>   $ ./b.sh 1 2 3 4 5` -> $ ./a.sh 2 3 4 5
>   ```

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
  $ ./b.sh 1 2 3 4 5

  b.sh:
    $1: 1
    $#: 5
    $@: 1 2 3 4 5
    ${@: -1}: 5
    ${@: -2}: 4 5
    ${@: -3}: 4 5
    ${@: -$(( $#-1 ))}: 2 3 4 5
    $(echo '${@: -$(( $#-1 ))}' | cut -d' ' -f1-) : 2 3 4 5

  '~~> ./a.sh "${@: -1}"': ~~~> ./a.sh e:
  a.sh:
    $1: 5
    $#: 1
    $@: 5
    ${@: --1}: 5

  '~~> ./a.sh $(echo '${@: -1}' | cut -d' ' -f1-)': ~~~> ./a.sh 5:
  a.sh:
    $1: 5
    $#: 1
    $@: 5
    ${@: --1}: 5

  '~~> ./a.sh "${@: -4}"': ~~~> ./a.sh 2 3 4 5:
  a.sh:
    $1: b
    $#: 4
    $@: 2 3 4 5
    ${@: -2}: 4 5

  '~~> ./a.sh $(echo '${@: -$(( $#-1 ))}' | cut -d' ' -f1-)': ~~~> ./a.sh 2 3 4 5
  a.sh:
    $1: 2
    $#: 4
    $@: 2 3 4 5
    ${@: -2}: 4 5
  ```

## getopts with long option
```bash
#!/usr/bin/env bash
# shellcheck disable=SC1079,SC1078

usage="""USAGE
\t$0\t[-h|--help] [-c|--clean] [-t|--tag <tag>] [-i|--image <image>]
\t\t\t[-v|--ver <new-version>] [-n|--name <name>]
\t\t\t[-p|--prop <key=value>]
"""

while test -n "$1"; do
    case "$1" in
      -c | --clean    ) clean=true        ; shift   ;;
      -t | --tag      ) tag=$2            ; shift 2 ;;
      -i | --image    ) image=$2          ; shift 2 ;;
      -v | --ver      ) ver=$2            ; shift 2 ;;
      -n | --name     ) name=$2           ; shift 2 ;;
      -p | --prop     ) prop=$2           ; shift 2 ;;
      -h | --help | * ) echo -e "${usage}"; exit 0  ;;
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

### additional params on `--`
```bash
#!/usr/bin/env bash
# shellcheck disable=SC2051,SC2086

VERBOSE=false
DEBUG=false
MEMORY=
AOPT=
while true; do
  case "$1" in
    -v | --verbose ) VERBOSE=true ; shift   ;;
    -d | --debug   ) DEBUG=true   ; shift   ;;
    -m | --memory  ) MEMORY="$2"  ; shift 2 ;;
    --             ) shift        ; AOPT=$@  ;  break ;;
    *              ) break                  ;;
  esac
done

echo """
  VERBOSE       : ${VERBOSE}
  DEBUG         : ${DEBUG}
  MEMORY        : ${MEMORY}
  AOPT          : ${AOPT}
"""

# example
$ ./param.sh -v -m '256Gi' -- --author 'marslo'
  VERBOSE       : true
  DEBUG         : false
  MEMORY        : 256Gi
  AOPT          : --author marslo

$ ./param.sh -v -- -m '256Gi' --author 'marslo'
  VERBOSE       : true
  DEBUG         : false
  MEMORY        :
  AOPT          : -m 256Gi --author marslo
```

## shift
```bash
until [ -z "$1" ]; do # Until all parameters used up
  echo "\$@  : $@ "; shift ;
done

# result
$ ./shift.sh 1 2 3 4 5
$@  : 1 2 3 4 5
$@  : 2 3 4 5
$@  : 3 4 5
$@  : 4 5
$@  : 5
```

### shift with uncertain params
```bash
echo '---------------- before shift -------------------'
echo ".. \$# : $#"
echo ".. \$@ : $@"
echo ".. \$* : $*"

echo '---------------- after shift -------------------'
opt=''

while [[ $# -gt 0 ]]; do
  case "$1" in
    -*) opt+="$1 "; shift;;
     *) break            ;;
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
  params=${*: 1:$#-1}
fi

echo '---------------- result -------------------'
echo ">> opt    : ${opt}"
echo ">> params : ${params}"
echo ">> path   : ${path}"
```
