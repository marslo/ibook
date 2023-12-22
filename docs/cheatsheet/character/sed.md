<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [execute multiple sed commands](#execute-multiple-sed-commands)
  - [example : show only root and nobody in `/etc/passwd`](#example--show-only-root-and-nobody-in-etcpasswd)
- [range](#range)
  - [specific line](#specific-line)
  - [until empty line](#until-empty-line)
  - [n~m range](#nm-range)
  - [pattern matches range](#pattern-matches-range)
- [print](#print)
  - [print all lines](#print-all-lines)
  - [range print](#range-print)
  - [print matched pattern](#print-matched-pattern)
- [delete](#delete)
  - [delete all](#delete-all)
  - [range delete](#range-delete)
  - [conditional delete](#conditional-delete)
- [substitute](#substitute)
  - [substitute-flags](#substitute-flags)
  - [multiple replaces](#multiple-replaces)
- [get matched pattern](#get-matched-pattern)
  - [`&`](#)
  - [substitution grouping](#substitution-grouping)
- [cheatsheet](#cheatsheet)
  - [get first matching patten ( for `CERTIFICATE` )](#get-first-matching-patten--for-certificate-)
  - [remove both '#' and empty lines](#remove-both--and-empty-lines)
  - [show `top` summary](#show-top-summary)
  - [escape](#escape)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE]
> references:
> - [character classes](https://unix.stackexchange.com/a/102021/29178)
>
>
> |   CHARACTER    | REGULAR EXPRESSION | EXPLANATION                        |
> |:--------------:|:-------------------|------------------------------------|
> | `[[:alnum:]]`  | `[A-Za-z0-9]`      | Alphanumeric characters            |
> | `[[:alpha:]]`  | `[A-Za-z]`         | Alphabetic characters              |
> | `[[:blank:]]`  | `[ \t]`            | Space or tab characters only       |
> | `[[:cntrl:]]`  | `[\x00-\x1F\x7F]`  | Control characters                 |
> | `[[:digit:]]`  | `[0-9]`            | Numeric characters                 |
> | `[[:graph:]]`  | `[!-~]`            | Printable and visible characters   |
> | `[[:lower:]]`  | `[a-z]`            | Lower-case alphabetic characters   |
> | `[[:print:]]`  | `[ -~]`            | Printable (non-Control) characters |
> | `[[:punct:]]`  | `[!-/:-@[-`{-~]`   | Punctuation characters             |
> | `[[:space:]]`  | `[ \t\v\f\n\r]`    | All whitespace chars               |
> | `[[:upper:]]`  | `[A-Z]`            | Upper-case alphabetic characters   |
> | `[[:xdigit:]]` | `[0-9a-fA-F]`      | Hexadecimal digit characters       |


## execute multiple sed commands

> [!TIP]
> ```bash
> -e command
>        Append the editing commands specified by the command argument to the list of commands.
> ```
> references:
> - [50 `sed` Command Examples](https://linuxhint.com/50_sed_command_examples/)

### example : show only root and nobody in `/etc/passwd`
- `-e` :
  ```bash
  $ sed -n -e '/^root/p' -e '/^nobody/p' /etc/passwd
  nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false
  root:*:0:0:System Administrator:/var/root:/bin/sh
  ```

- `;` :
  ```bash
  $ sed -n -e '/^root/p;/^nobody/p' /etc/passwd
  nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false
  root:*:0:0:System Administrator:/var/root:/bin/sh
  ```

- `'{}'` :
  ```bash
  $ sed -n '{
      /^root/p
      /^nobody/p
    }' /etc/passwd
  nobody:*:-2:-2:Unprivileged User:/var/empty:/usr/bin/false
  root:*:0:0:System Administrator:/var/root:/bin/sh
  ```

## range
### specific line
- 2nd line : `N <opt>`

### until empty line

{% hint style='tip' %}
> references:
> - [Remove everything before a blank line using sed](https://stackoverflow.com/a/30632744/2940319)
> - [Remove empty line before a pattern using sed](https://stackoverflow.com/questions/65039344/remove-empty-line-before-a-pattern-using-sed)
> - [Grep starting from a fixed text, until the first blank line](https://unix.stackexchange.com/a/318596/29178)
> - [Delete unknown number of lines from * until blank line](https://unix.stackexchange.com/a/303839/29178)
> - [remove only the first blank line sed](https://unix.stackexchange.com/a/75432/29178)
> - [Use sed to insert text before two blank lines](https://unix.stackexchange.com/questions/647991/use-sed-to-insert-text-before-two-blank-lines)
> - [htop output to human readable file](https://stackoverflow.com/questions/17534591/htop-output-to-human-readable-file)
> - [$HOME/.toprc](https://unix.stackexchange.com/a/86591/29178)
{% endhint %}

```bash
$ top -bn1 | sed -n '0,/^\s*$/p'
top - 03:41:45 up 258 days, 19:05,  1 user,  load average: 2.33, 0.92, 0.95
Tasks: 856 total,   2 running, 447 sleeping,   0 stopped,  36 zombie
%Cpu(s):  0.3 us,  0.4 sy,  0.0 ni, 99.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 52802012+total, 11152644+free, 24536944 used, 39195673+buff/cache
KiB Swap:        0 total,        0 free,        0 used. 49137280+avail Mem

```
- or
  ```bash
  $ top -bn1 | sed -e '/^$/Q'
  top - 03:45:55 up 258 days, 19:09,  1 user,  load average: 0.17, 0.51, 0.77
  Tasks: 857 total,   2 running, 448 sleeping,   0 stopped,  36 zombie
  %Cpu(s):  0.1 us,  0.4 sy,  0.0 ni, 99.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem : 52802012+total, 11151089+free, 24546520 used, 39196272+buff/cache
  KiB Swap:        0 total,        0 free,        0 used. 49136291+avail Mem
  ```

### n~m range
- n~m lines : `n,m <opt>`
- n to end lines : `n,$ <opt>`
- m lines starting with n : `n, +m <opt>`
- start n skip m via `~` :


  | pattern | matches        | comments                              |
  |:-------:|:--------------:|---------------------------------------|
  |  `1~2`  | `1,3,5,7,...`  | start frmo `1`, print every `2` lines |
  |  `2~2`  | `2,4,6,8,...`  | start from `2`, print every `2` lines |
  |  `1~3`  | `1,4,7,10,...` | start from `1`, print every `3` lines |
  |  `2~3`  | `2,5,8,11,...` | start from `2`, print every `3` lines |


### pattern matches range
- between `pattern_1` to `pattern_2` : `/pattern_1/,/pattern_2/ <opt>`
- first line to `pattern_2` : `0,/pattern_2/ <opt>`

#### from pattern to first empty line
```bash
$ top -bn1 | sed -n '/^top.*/,/^\s*$/p'
top - 03:49:02 up 258 days, 19:13,  1 user,  load average: 0.43, 0.41, 0.68
Tasks: 853 total,   1 running, 448 sleeping,   0 stopped,  36 zombie
%Cpu(s):  0.3 us,  0.4 sy,  0.0 ni, 99.3 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
KiB Mem : 52802012+total, 11150942+free, 24543500 used, 39196720+buff/cache
KiB Swap:        0 total,        0 free,        0 used. 49136582+avail Mem

```

## print
### print all lines
- print every line twice
  ```bash
  $ sed 'p' employee.txt
  101,John Doe,CEO
  101,John Doe,CEO
  102,Jason Smith,IT Manager
  102,Jason Smith,IT Manager
  103,Raj Reddy,Sysadmin
  103,Raj Reddy,Sysadmin
  104,Anand Ram,Developer
  104,Anand Ram,Developer
  105,Jane Miller,Sales Manager
  105,Jane Miller,Sales Manager
  ```
- print all lines : `$ sed -n 'p' employee.txt`

### range print
- print the 2nd line  : `$ sed -n '2 p' employee.txt`
- `n,m` range
  - print 1~4 lines : `$ sed -n '1,4 p' employee.txt`
  - print all lines since the 2nd line: `$ sed -n '2,$ p' employee.txt`

- `~` to skip lines
  - print only odd numbered lines : `sed -n '1~2 p' employee.txt`

- `+` ( `n, +m` ) : `sed -n 'n,+m p' employee.txt`

### print matched pattern
- find pattern to the end :
  ```bash
  $ sed -n '/Raj/,$ p' employee.txt
  103,Raj Reddy,Sysadmin
  104,Anand Ram,Developer
  105,Jane Miller,Sales Manager
  ```
- find pattern and line after the matches line :
  ```bash
  $ sed -n '/Raj/, +1 p' employee.txt
  103,Raj Reddy,Sysadmin
  104,Anand Ram,Developer
  ```

- find pattern to 4th line :
  ```bash
  $ sed -n '/Raj/,4 p' employee.txt
  103,Raj Reddy,Sysadmin
  104,Anand Ram,Developer
  ```

- find pattern until find another pattern ( `Jason` to `Anand` ) :
  ```bash
  $ sed -n '/Jason/,/Anand/p' employee.txt
  102,Jason Smith,IT Manager
  103,Raj Reddy,Sysadmin
  104,Anand Ram,Developer
  ```

## delete
### delete all
```bash
$ sed 'd' employee.txt
```

### range delete
- delete the 2nd line : `$ sed '2 d' /path/to/file`
- delete between `1` and `4` lines : `$ sed '1,4 d' /path/to/file`

### conditional delete
- delete all empty lines: `$ sed '/^$/ d' /path/to/file`
- delete all comment lines :  `$ sed '/^#/ d' /path/to/file`

## substitute

### substitute-flags

|    flag   | comments         |
|:---------:|------------------|
|    `i`    | ignore case flag |
|    `g`    | global flag      |
| `1,2,...` | number flag      |
|    `p`    | print flag       |
|    `w`    | write flag       |
|    `e`    | execute flag     |

### multiple replaces
```bash
$ sed '{
    s/Developer/IT Manager/
    s/Manager/Director/
  }' employee.txt
101,John Doe,CEO
102,Jason Smith,IT Director
103,Raj Reddy,Sysadmin
104,Anand Ram,IT Director
105,Jane Miller,Sales Director
```

## get matched pattern

### `&`
{% hint style='tip' %}
When & is used in the replacement-string, it replaces it with whatever text matched the original-string or the regular-expression.
{% endhint %}

```bash
$ sed 's/^[0-9][0-9][0-9]/<&>/g' employee.txt
<101>,John Doe,CEO
<102>,Jason Smith,IT Manager
<103>,Raj Reddy,Sysadmin
<104>,Anand Ram,Developer
<105>,Jane Miller,Sales Manager
```

### substitution grouping
```bash
$ sed 's/^\([0-9][0-9][0-9]\).*/<\1>/g' employee.txt
<101>
<102>
<103>
<104>
<105>
```

or via `-r`
```bash
$ sed -r 's/^([0-9][0-9][0-9]).*/<\1>/g' employee.txt
<101>
<102>
<103>
<104>
<105>

# or
$ sed -nr 's/^([0-9][0-9][0-9])(.*)/<\1>\2/gp' employee.txt
<101>,John Doe,CEO
<102>,Jason Smith,IT Manager
<103>,Raj Reddy,Sysadmin
<104>,Anand Ram,Developer
<105>,Jane Miller,Sales Manager
```

## cheatsheet

{% hint style='tip' %}
> reference:
> - [Sed cheatsheet](https://quickref.me/sed)
> - [ssstonebraker/sed cheatsheet](https://gist.github.com/ssstonebraker/6140154)
> - [sed Cheat Sheet](https://lzone.de/cheat-sheet/sed)
> - [Erik's Cheat Sheet : sed](http://eriklievaart.com/cheat/linux/shell/sed.html)
> - [cheatsheet_sed.pdf](https://au-bio-bootcamp.github.io/cheatsheet_sed.pdf)
>
> more samples:
> - [* imarslo : get lines between 2 matched patterns](./character.html#get-lines-between-2-matched-patterns)
{% endhint %}

### get first matching patten ( for `CERTIFICATE` )

> [!TIP]
> - sample.crt
>   ```bash
>   $ cat sample.crt
>   -----BEGIN CERTIFICATE-----
>   first paragraph
>   -----END CERTIFICATE-----
>   -----BEGIN CERTIFICATE-----
>   second paragraph
>   -----END CERTIFICATE-----
>   ```

- regular pattern
  ```bash
  $ cat sample.crt | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----
  -----BEGIN CERTIFICATE-----
  second paragraph
  -----END CERTIFICATE-----

  # or for short
  $ cat sample.crt | sed -ne '/-BEGIN/,/-END/p'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----
  -----BEGIN CERTIFICATE-----
  second paragraph
  -----END CERTIFICATE-----
  ```

- get first

  > [!TIP]
  > - [How to print the text between the first occurence of a pair of strings? [duplicate]](https://unix.stackexchange.com/a/362068/29178)
  > - [How to select first occurrence between two patterns including them](https://unix.stackexchange.com/a/180729/29178)
  >
  > more :
  > - [* imarslo : get second matching pattern](./character.html#get-second-matching-pattern)

  ```bash
  # or `-n /../p`
  #                     `-n`                                         `p`
  #                       |                                           |
  #                       v                                           v
  $ cat sample.crt | sed -n '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p; /-END CERTIFICATE-/q'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----

  # or `/../!d`
  #                   no `-n`                                     `!d`
  #                     |                                           |
  #                     v                                           v
  $ cat sample.crt | sed '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/!d; /-END CERTIFICATE-/q'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----

  # or for short
  $ cat sample.crt | sed '/-END CERTIFICATE-/q'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----

  # or
  $ cat sample.crt | sed '/-END/q'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----
  ```

### remove both '#' and empty lines
```bash
$ .. | sed -r '/^(#.*)$/d' | sed -r '/^\s*$/d'

# or
$ .. | sed -r '/^(#.*)$/d;/^\s*$/d'

# or
$ .. | sed -r '/(^#.*)|(^\s*)$/d'
```

- example
  ```bash
  $ ldapsearch CN=marslo DN | sed -r '/^(#.*)$/d;/^\s*$/d'
  dn: CN=marslo,OU=Workers,DC=company,DC=com
  ```

### show `top` summary

> [!NOTE]
> see [sed until empty line](#until-empty-line)

- contains empty line
  ```bash
  $ top -bn1 | sed -n '0,/^\s*$/p'
  top - 03:41:45 up 258 days, 19:05,  1 user,  load average: 2.33, 0.92, 0.95
  Tasks: 856 total,   2 running, 447 sleeping,   0 stopped,  36 zombie
  %Cpu(s):  0.3 us,  0.4 sy,  0.0 ni, 99.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem : 52802012+total, 11152644+free, 24536944 used, 39195673+buff/cache
  KiB Swap:        0 total,        0 free,        0 used. 49137280+avail Mem

  ```

- without empty line

  > [!TIP]
  > references:
  > - [Exiting with "q" and "d" - SED Tutorial](https://www.linkedin.com/learning/sed-essential-training/exiting-with-q-and-d)
  >
  > manual:
  > - The "q" command prints the current line again in less the -n flag was used on the command line and exits the script completely
  >
  > ```bash
  > q[exit-code]
  >   (quit) Exit sed without processing any more commands or input.
  >
  > Q[exit-code]
  >   (quit) This command is the same as q, but will not print the contents of pattern space. Like q, it provides the ability to return an exit code to the caller.
  > ```

  ```bash
  $ top -bn1 | sed -e '/^$/Q'
  top - 03:45:55 up 258 days, 19:09,  1 user,  load average: 0.17, 0.51, 0.77
  Tasks: 857 total,   2 running, 448 sleeping,   0 stopped,  36 zombie
  %Cpu(s):  0.1 us,  0.4 sy,  0.0 ni, 99.4 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
  KiB Mem : 52802012+total, 11151089+free, 24546520 used, 39196272+buff/cache
  KiB Swap:        0 total,        0 free,        0 used. 49136291+avail Mem
  ```

### escape

> [!NOTE|label:references:]
> - [* How to escape single quotes within single quoted strings](https://stackoverflow.com/a/1250279/2940319)

- [\ to \\\](https://stackoverflow.com/a/67170003/2940319)
  ```bash
  $ echo "\(\)" | sed 's/\\/\\\\\\/g'
  \\\(\\\)
  ```

  - [more](https://stackoverflow.com/a/28624256/2940319)
    ```bash
    alias rxvt='urxvt -fg'\''#111111'\'' -bg '\''#111111'\''
               │         │┊┊|       │┊┊│     │┊┊│       │┊┊│
               └─STRING──┘┊┊└─STRIN─┘┊┊└─STR─┘┊┊└─STRIN─┘┊┊│
                          ┊┊         ┊┊       ┊┊         ┊┊│
                          ┊┊         ┊┊       ┊┊         ┊┊│
                          └┴─────────┴┴───┰───┴┴─────────┴┘│
                              All escaped single quotes    │
                                                           │
                                                           ?
    alias rc='sed '"'"':a;N;$!ba;s/\n/, /g'"'"
    alias rc='sed '\'':a;N;$!ba;s/\n/, /g'\'
    ```
