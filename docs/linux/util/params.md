<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [shell parameter parsers](#shell-parameter-parsers)
- [pass parameters to another script](#pass-parameters-to-another-script)
- [Manual Case-Loop Parser](#manual-case-loop-parser)
  - [with one or more values](#with-one-or-more-values)
  - [shift with uncertain params](#shift-with-uncertain-params)
- [POSIX `getopts` Parser](#posix-getopts-parser)
- [GNU getopt Parser](#gnu-getopt-parser)
  - [additional params on `--`](#additional-params-on---)
- [`bash-argparse` Library](#bash-argparse-library)
- [`docopts`](#docopts)
- [`argbash` Code Generator](#argbash-code-generator)
- [`shflags` (Google-style shell option lib)](#shflags-google-style-shell-option-lib)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:see also:]
> - [* iMarslo: parameter substitution](../../cheatsheet/bash/sugar.html#parameter-substitution)

## shell parameter parsers

| PARSER STYLE           | DESCRIPTION                                  | PROS                                           | CONS                                                      | PORTABILITY           |
|------------------------|----------------------------------------------|------------------------------------------------|-----------------------------------------------------------|-----------------------|
| 🔸 case + shift loop   | Manual parsing with a `while` + `case` combo | - Highly customizable<br>- Simple              | - Error-prone for complex flags<br>- No automatic help    | ✅ POSIX-compliant    |
| 🔸 getopts (built-in)  | Built-in short-option parser                 | - Easy for short options (-x)                  | - No long options<br>- No auto help                       | ✅ POSIX-compliant    |
| 🔹 getopt (external)   | External tool to parse long/short flags      | - Supports long & short<br>- Auto reordering   | - Not always installed<br>- Not portable across BSD/Linux | ⚠️ Not portable       |
| 🔸 bash-argparse (lib) | Bash-based helper library                    | - Structured, powerful<br>- Python-like syntax | - Adds dependency<br>- Not always installed               | ❌ Bash-only          |
| 🔹 docopts (doc-style) | Parses from usage doc string                 | - Clean UX<br>- Declarative                    | - Heavy<br>- Requires Python or external                  | ❌ External           |
| 🔸 argbash (codegen)   | Generates parsing boilerplate                | - Auto docs/help<br>- Safe/robust              | - Needs build step                                        | ❌ Not runtime native |
| 🔹 shflags (Google)    | Lightweight Bash lib                         | - Google-style<br>- Nice syntax                | - Needs sourcing a lib                                    | ⚠️ Bash-only          |


| PARSER          | SHORT OPTS   | LONG OPTS     | PORTABLE   | HELP GEN   | EXTERNAL?     |
| --------------- | ------------ | ------------- | ---------- | ---------- | ------------- |
| Manual Case     | ✅           | ✅ (manual)   | ✅ POSIX   | ❌         | ❌            |
| getopts         | ✅           | ❌            | ✅ POSIX   | ❌         | ❌            |
| getopt          | ✅           | ✅            | ❌         | ❌         | ✅ (GNU)      |
| bash-argparse   | ✅           | ✅            | ❌ Bash    | ✅         | ✅            |
| docopts         | ✅           | ✅            | ❌         | ✅         | ✅ (Python)   |
| argbash         | ✅           | ✅            | ❌         | ✅         | ✅ (tool)     |
| shflags         | ✅           | ✅            | ❌         | ✅         | ✅ (lib)      |

## pass parameters to another script

> [!NOTE]
> - objective:
>   ```bash
>   $ ./b.sh 1 2 3 4 5` -> $ ./a.sh 2 3 4 5
>   ```

- b.sh
  ```bash
  #!/bin/bash
  echo """
  b.sh:
    \$1                   : "$1"
    \$#                   : "$#"
    \$@                   : "$@"
    \${@: -1}             : ${@: -1}
    \${@: -2}             : ${@: -2}
    \${@: -3}             : ${@: -2}
    \${@: -\$(( \$#-1 ))} : ${@: -$(( $#-1 ))}
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
    $1                 : 1
    $#                 : 5
    $@                 : 1 2 3 4 5
    ${@: -1}           : 5
    ${@: -2}           : 4 5
    ${@: -3}           : 4 5
    ${@: -$(( $#-1 ))} : 2 3 4 5
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

## Manual Case-Loop Parser

> [!NOTE]
> - ✅ Pros: Simple, portable
> - ❌ Cons: No built-in validation or help

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

### with one or more values

> [!TIP]
> - `positional_args+=("$1")` to add the arguments to an array one by one

```bash
var1=""
flag_verbose=false

# POSIX format using `while [ $# -gt 0 ]`
while [[ $# -gt 0 ]]; do
  case "$1" in
    -v|--verbose ) flag_verbose=true             ;  shift   ;;
    -f|--file    ) var1="$2"                     ;  shift 2 ;;
    --dry-run    ) dryrun=true                   ;  shift   ;;
    -*           ) echo "Unknown option: $1" >&2 ;  exit 1  ;;
    *            ) positional_args+=("$1")       ;  shift   ;;
  esac
done
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

## POSIX `getopts` Parser

> [!NOTE]
> - ✅ Pros: POSIX, built-in
> - ❌ Cons: No long options, no multi-word values

```bash
while getopts "f:vd" opt; do
  case $opt in
    f  ) FILE="$OPTARG" ;;
    v  ) VERBOSE=true   ;;
    d  ) DRYRUN=true    ;;
    \? ) echo "Invalid option: -$OPTARG"; exit 1 ;;
  esac
done
shift $((OPTIND -1))
```


## GNU getopt Parser

> [!NOTE]
> - MacOS: `brew install gnu-getopt`
>
> - ✅ Pros: Short + long, nice user UX
> - ❌ Cons: Not portable across BSD/macOS by default (GNU-only)

```bash
#!/usr/bin/env bash

ARGS=$(getopt -o f:vd -l file:,verbose,dry-run -- "$@")
eval set -- "$ARGS"

while true; do
  case "$1" in
    -f|--file    ) FILE="$2"    ;  shift 2 ;;
    -v|--verbose ) VERBOSE=true ;  shift   ;;
    --dry-run    ) DRYRUN=true  ;  shift   ;;
    --           ) shift        ;  break   ;;
    *            ) break                   ;;
  esac
done
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

## `bash-argparse` Library

> [!NOTE]
> - [Anvil/bash-argsparse](https://github.com/Anvil/bash-argsparse)
>
> - ✅ Pros: Clean, descriptive, built-in help
> - ❌ Cons: Bash-only, external lib needed

```bash
# requires sourcing the library
source argparse.sh

argparse "$@" <<EOF
--file -f [arg]    Path to the file
--verbose -v       Enable verbose output
--dry-run          Enable dry-run mode
EOF
```

## `docopts`

> [!NOTE]
> - [docopt/docopt](https://github.com/docopt/docopt)
>
> - ✅ Pros: Elegant, self-documenting
> - ❌ Cons: Requires Python + docopts installed

```bash
# usage section (docopts parses this!)
read -r -d '' usage <<EOF
Usage:
  script.sh [-v|--verbose] [--dry-run] -f <file>
Options:
  -f --file=<file>     File to process
  -v --verbose         Verbose output
  --dry-run            Simulate actions
EOF

eval "$(docopts -A args -h "$usage" : "$@")"

# access like $args_file, $args_verbose, $args_dry_run
```

## `argbash` Code Generator

> [!NOTE]
> - [argbash.dev](https://argbash.dev/generate) | [matejak/argbash](https://github.com/matejak/argbash)
>
> - ✅ Pros: Auto-generates robust scripts
> - ❌ Cons: Requires preprocessing step

```bash
# ARG_POSITIONAL_SINGLE([file], [File to process])
# ARG_OPTIONAL_BOOLEAN([verbose], [v], [Enable verbose])
# ARG_OPTIONAL_BOOLEAN([dry-run], [], [Dry run mode])
# ARG_HELP([Script to demonstrate argbash])
# ARGBASH_GO()

# The above is preprocessed by `argbash` into full Bash script
```

## `shflags` (Google-style shell option lib)

> [!NOTE]
> - [shflags](https://code.google.com/archive/p/shflags/) | [lib/shflags/shflags](https://chromium.googlesource.com/chromiumos/platform/crosutils/+/master/lib/shflags/shflags) | [kward/shflags](https://github.com/kward/shflags)
>
> - ✅ Pros: Easy-to-read, Google-style
> - ❌ Cons: Needs external lib and sourcing

```bash
. ./shflags

DEFINE_string 'file' '' 'file to use' 'f'
DEFINE_boolean 'verbose' false 'verbose mode' 'v'
DEFINE_boolean 'dry-run' false 'simulate mode' ''

FLAGS "$@" || exit 1
eval set -- "${FLAGS_ARGV}"

echo "File: ${FLAGS_file}"
```
