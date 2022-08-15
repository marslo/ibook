<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute multiple sed commands](#execute-multiple-sed-commands)
- [range](#range)
- [print](#print)
- [delete](#delete)
- [substitute](#substitute)
- [get matched pattern](#get-matched-pattern)
- [get first matching patten](#get-first-matching-patten)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### execute multiple sed commands

> [!TIP]
> ```bash
> -e command
>        Append the editing commands specified by the command argument to the list of commands.
> ```
> references:
> - [50 `sed` Command Examples](https://linuxhint.com/50_sed_command_examples/)

#### example : show only root and nobody in `/etc/passwd`
- `-e` :
  ```bash
  $ sed -n -e '/^root/p' -e '/^nobody/p' /etc/passwd
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

### range
#### specific line
- 2nd line : `N <opt>`

#### range
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


#### pattern matches range
- between `pattern_1` to `pattern_2` : `/pattern_1/,/pattern_2/ <opt>`

### print
#### print all lines
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

#### range print
- print the 2nd line  : `$ sed -n '2 p' employee.txt`
- `n,m` range
  - print 1~4 lines : `$ sed -n '1,4 p' employee.txt`
  - print all lines since the 2nd line: `$ sed -n '2,$ p' employee.txt`

- `~` to skip lines
  - print only odd numbered lines : `sed -n '1~2 p' employee.txt`

- `+` ( `n, +m` ) : `sed -n 'n,+m p' employee.txt`

#### print matched pattern
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

### delete
#### delete all
```bash
$ sed 'd' employee.txt
```

#### range delete
- delete the 2nd line : `$ sed '2 d' /path/to/file`
- delete between `1` and `4` lines : `$ sed '1,4 d' /path/to/file`

#### conditional delete
- delete all empty lines: `$ sed '/^$/ d' /path/to/file`
- delete all comment lines :  `$ sed '/^#/ d' /path/to/file`

### substitute

#### substitute-flags

|    flag   | comments         |
|:---------:|------------------|
|    `i`    | ignore case flag |
|    `g`    | global flag      |
| `1,2,...` | number flag      |
|    `p`    | print flag       |
|    `w`    | write flag       |
|    `e`    | execute flag     |

#### multiple replaces
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

### get matched pattern

#### `&`
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

#### substitution grouping
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

### get first matching patten

> [!TIP]
> sample.crt
> ```bash
> $ cat sample.crt
> -----BEGIN CERTIFICATE-----
> first paragraph
> -----END CERTIFICATE-----
> -----BEGIN CERTIFICATE-----
> second paragraph
> -----END CERTIFICATE-----
> ```

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

  ```bash
  $ cat sample.crt | sed -n '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p; /-END CERTIFICATE-/q'
  -----BEGIN CERTIFICATE-----
  first paragraph
  -----END CERTIFICATE-----

  # or `-d`
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
