<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [sum](#sum)
  - [awk](#awk)
  - [datamash](#datamash)
  - [bc](#bc)
  - [jq](#jq)
  - [`$(())`](#)
- [sum from file](#sum-from-file)
- [number conversion](#number-conversion)
  - [Common Bases](#common-bases)
  - [binary <> decimal <> hexadecimal](#binary--decimal--hexadecimal)
  - [to decimal](#to-decimal)
  - [to hexadecimal](#to-hexadecimal)
  - [to octal](#to-octal)
  - [to binary](#to-binary)
  - [to unicode ( hexadecimal )](#to-unicode--hexadecimal-)
  - [number converting from file](#number-converting-from-file)
- [advanced computing](#advanced-computing)
  - [logarithm](#logarithm)
  - [power](#power)
  - [square](#square)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Bash 的算术运算](https://wangdoc.com/bash/arithmetic)
> - [Linux 中bc命令实现自然对数、指数运算、自然指数、平方根的运算](https://www.cnblogs.com/liujiaxin2018/p/17036256.html)
> - [bc to Perform Advanced Arithmetic Operations in BASH](https://linuxhint.com/bc-arithmetic-operations-bash/)
> - [Using vim as calculator](https://vim.fandom.com/wiki/Using_vim_as_calculator)

## sum

> [!INFO|label:references:]
> - [Shell command to sum integers, one per line?](https://stackoverflow.com/a/25245025/2940319)
> - [Summing a List of Numbers](https://www.oreilly.com/library/view/bash-cookbook/0596526784/ch07s13.html)

### awk
```bash
$ seq 10 | awk '{s+=$1} END {print s}'
55

# or
$ awk 'BEGIN{print '"1+2+3"'}'
6
```

#### file sizes
```bash
$ ls -l
total 12
-rw-r--r--  1 marslo staff 3480 Dec 21 21:21 README.md
-rw-r--r--  1 marslo staff 7516 Dec 21 21:21 SUMMARY.md
drwxr-xr-x  7 marslo staff  224 Sep 19 19:52 artifactory
drwxr-xr-x 15 marslo staff  480 Dec 21 21:19 cheatsheet
drwxr-xr-x 12 marslo staff  384 Aug 17 21:11 devops
drwxr-xr-x  9 marslo staff  288 Sep 29 17:31 jenkins
drwxr-xr-x 10 marslo staff  320 Sep 19 19:52 linux
drwxr-xr-x  9 marslo staff  288 Sep 19 19:52 osx
drwxr-xr-x  6 marslo staff  192 Aug 17 21:11 programming
drwxr-xr-x 27 marslo staff  864 Aug 17 22:10 screenshot
drwxr-xr-x  7 marslo staff  224 Oct 11 19:41 tools
drwxr-xr-x  8 marslo staff  256 Aug 30 16:39 vim
drwxr-xr-x  5 marslo staff  160 Aug 17 21:11 virtualization

$ ls -l | awk '{sum += $5} END {print sum}'
14676
```


### datamash

> [!TIP|label:reference:]
> - [Shell command to sum integers, one per line?](https://stackoverflow.com/a/55392673/2940319)

```bash
$ seq 10 | datamash sum 1
55
```

### bc

- [paste + bc](https://stackoverflow.com/a/20437994/2940319)
  ```bash
  $ seq 10 | paste -sd+ -
  1+2+3+4+5+6+7+8+9+10

  $ seq 10 | paste -sd+ - | bc
  55
  ```

- [xargs + bc](https://stackoverflow.com/a/23835376/2940319)
  ```bash
  $ seq 10 | xargs printf "- - %s" | xargs | bc
  55
  ```

- [sed + bc](https://stackoverflow.com/a/453325/2940319)
  ```bash
  $ seq 10 | sed 's/^/.+/' | bc
  1
  3
  6
  10
  15
  21
  28
  36
  45
  55
  ```

### [jq](https://stackoverflow.com/a/34118894/2940319)
```bash
$ seq 10 | jq -s 'add'
55
```

### [`$(())`](https://stackoverflow.com/a/13969439/2940319)
```bash
$ f=$(seq 10)
$ echo $(( ${f//$'\n'/+} ))
55

# or
$ echo $(( $(seq 10 | tr "\n" "+") 0 ))
55
# or from file
$ echo $(( $( tr "\n" "+"  < /tmp/test) 0 ))
```

## sum from file

> [!NOTE|label:sample file:]
> ```bash
> $ cat numbers.txt
> 73.27
> 218.38
> 14.15
> 9.18
> 16.60
> ```
> - [How can I quickly sum all numbers in a file?](https://stackoverflow.com/q/2702564/2940319)

- [awk](https://stackoverflow.com/a/2702577/2940319)
  ```bash

  $ awk '{ sum += $1 } END { print sum }' numbers.txt
  331.58
  ```

- [paste && bc](https://stackoverflow.com/a/20437994/2940319)
  ```bash
  $ paste -sd+ numbers.txt
  73.27+218.38+14.15+9.18+16.60

  $ paste -sd+ numbers.txt | bc
  331.58
  ```

  - Σn where 1<=n<=100000
    ```bash
    $ seq 100000 | paste -sd+ | bc -l
    5000050000
    ```

- [jq](https://stackoverflow.com/a/34118894/2940319)
  ```bash
  $ paste -sd' ' numbers.txt | jq -s add
  331.58
  ```

## number conversion

> [!NOTE|label:references:]
> - [Understand "ibase" and "obase" in case of conversions with bc?](https://unix.stackexchange.com/q/199615/29178)
> - [Linux / UNIX: bc Convert Octal To Hexadecimal or Vise Versa](https://www.cyberciti.biz/faq/bc-convert-octal-to-hexadecimal-number/)
> - tips
>>  `ibase` and `obase` params order matters, but not always. Hex values must be in **UPPERCASE**.
>
> - the decimal can be ignored in `ibase` or `obase`, or we can say, the default `ibase` and `obase` are all 10.
>
> | CONVERT           | IN BC                                              | OUTPUT |
> |-------------------|----------------------------------------------------|--------|
> | 八进制 → 二进制   | <code>echo "ibase=8; obase=2; 77" &#124; bc</code> | 111111 |
> | 十进制 → 十六进制 | <code>echo "obase=16; 255" &#124; bc</code>        | FF     |
> | 十六进制 → 十进制 | <code>echo "ibase=16; FF" &#124; bc</code>         | 255    |
> | 二进制 → 十进制   | <code>echo "ibase=2; 101010" &#124; bc</code>      | 42     |


<!--sec data-title="base-converter" data-id="section0" data-show=true data-collapse=true ces-->
```bash
#!/usr/bin/env bash

function convertBase() {
  local from_base=''
  local to_base=''
  local value=''
  local upper=false

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -f|--from  ) from_base="$2" ;  shift 2 ;;
      -t|--to    ) to_base="$2"   ;  shift 2 ;;
      -v|--value ) value="$2"     ;  shift 2 ;;
      -u|--upper ) upper=true     ;  shift   ;; # uppercase hex
      -h|--help  ) echo "Usage: convertBase -f <from_base> -t <to_base> -v <value> [-u]"
                   echo "Supported bases: bin, dec, oct, hex"
                   return 0
                   ;;
      *          ) echo "Unknown option: $1" >&2; return 1 ;;
    esac
  done

  # Map base names to numeric bases for bc
  declare -A base_map=(
    [bin]=2
    [oct]=8
    [dec]=10
    [hex]=16
  )

  local ibase="${base_map[$from_base]}"
  local obase="${base_map[$to_base]}"

  if [[ -z "$ibase" || -z "$obase" ]]; then
    echo "Error: Unsupported base. Use bin, dec, oct, hex." >&2
    return 1
  fi

  # For hex input, force uppercase since bc expects that
  if [[ "$from_base" == "hex" ]]; then
    value="${value^^}"
  fi

  # Use bc to convert
  result=$(echo "obase=$obase; ibase=$ibase; $value" | bc)

  # Format output (uppercase optional)
  if [[ "$upper" == true && "$to_base" == "hex" ]]; then
    result="${result^^}"
  fi

  echo "$result"
}
```

```bash
# usage
$ convertBase -f hex -t dec -v FF         # → 255
$ convertBase -f bin -t dec -v 1011       # → 11
$ convertBase -f dec -t hex -v 255        # → ff
$ convertBase -f dec -t hex -v 255 -u     # → FF
$ convertBase -f dec -t bin -v 42         # → 101010
$ convertBase -f oct -t hex -v 77         # → 3F
$ convertBase -f bin -t oct -v 110101     # → 65
```

- supported base keywords

| NAME | BASE | DESCRIPTION |
|------|------|-------------|
| bin  | 2    | Binary      |
| oct  | 8    | Octal       |
| dec  | 10   | Decimal     |
| hex  | 16   | Hexadecimal |
<!--endsec-->

### Common Bases

| CONVERSION TYPE  | TOOL / METHOD               | EXAMPLE                                 |
|------------------|-----------------------------|-----------------------------------------|
| Base → Decimal   | `$((base#value))`           | `echo $((2#1010))` → `10`               |
| Decimal → Hex    | `printf`                    | `printf "%X\n" 255` → `FF`              |
| Decimal → Binary | `bc`                        | `bc < <(echo "obase=2; 42")` → `101010` |
| Octal → Decimal  | `$((8#17))`<br>`$((017))`   | `echo $((8#17))` → `15`                 |
| Hex → Decimal    | `$((16#FF))`<br>`$((0xFF))` | `echo $((16#FF))` → `255`               |

-  base → decimal

| BASE | TO | SYNTAX         | INTERPRETED NUMBER | OUTPUT (DECIMAL) |    DESCRIPTION   |
|:----:|:--:|----------------|--------------------|------------------|:----------------:|
|   2  | 10 | `$((2#1011))`  | `1011`             | `11`             |      BINARY      |
|   8  | 10 | `$((8#17))`    | `17`               | `15`             |       OCTAL      |
|   8  | 10 | `$((017))`     | `17`               | `15`             |       OCTAL      |
|  10  | 10 | `$((10#42))`   | `42`               | `42`             |      DECIMAL     |
|  16  | 10 | `$((16#1A3F))` | `1A3F`             | `6719`           |    HEXADECIMAL   |
|  16  | 10 | `$((0x1A3F))`  | `1A3F`             | `6719`           |    HEXADECIMAL   |
|  36  | 10 | `$((36#Z))`    | `Z`                | `35`             | ALPHANUMERIC MAX |
|  64  | 10 | `$((64#_))`    | _                  | `63`             | MAX BASE IN BASH |

### binary <> decimal <> hexadecimal

> [!NOTE]
> - `obase` : `[o]utput base`
> - `ibase` : `[i]utput base`

```bash
# bin -> dec
$ bc <<< 'ibase=2;11111111;11111111;11000000;00000000' | paste -sd. -
255.255.192.0

# bin -> hex
$ bc <<< 'obase=16;ibase=2;11111111;11111111;11000000;00000000' | awk '{ printf "%04s\n", $1 }' | paste -sd. -
00FF.00FF.00C0.0000

# dec -> bin
$ bc <<< 'ibase=10;obase=2;255;255;240;0' | numfmt --format %08f | paste -sd' ' -
11111111 11111111 11110000 00000000

# dec -> hex
$ bc <<< 'ibase=10;obase=16;255;255;240;0' | awk '{ printf "%04s\n", $1 }' | paste -sd. -
00FF.00FF.00F0.0000

# hex -> bin
$ bc <<< 'ibase=16;obase=2;FF;FF;EE;0A' | numfmt --format %08f | paste -sd' ' -
11111111 11111111 11101110 00001010

# hex -> dec
$ bc <<< 'ibase=16;FF;FF;EE;0A' | paste -sd. -
255.255.238.10
```

### to decimal

| FROM   | TO      | COMMAND (BASH)     | EXAMPLE  | OUTPUT | COMMENT                  |
|--------|---------|--------------------|----------|--------|--------------------------|
| Binary | Decimal | `echo $((2#1010))` | `2#1010` | `10`   | -                        |
| Hex    | Decimal | `echo $((16#FF))`  | `16#FF`  | `255`  | -                        |
| Hex    | Decimal | `echo $((0xFF))`   | `16#FF`  | `255`  | `0x` - convert from hex  |
| Octal  | Decimal | `echo $((8#77))`   | `8#77`   | `63`   | -                        |
| Octal  | Decimal | `echo $((077))`    | `8#77`   | `63`   | `0` - convert from octal |

- from hexadecimal
  ```bash
  $ echo "ibase=16; F" | bc
  15

  # [o]utput base:       0xA -> 10
  #                       ^
  $ echo "ibase=16; obase=A; F" | bc
  15

  # or obase first
  $ echo "obase=10; ibase=16; F" | bc
  15

  # or
  $ echo $((0xF))
  15
  ```

- from octal
  ```bash
  # obase (decimal) first
  $ echo "obase=10; ibase=8; 17" | bc
  15

  # or
  #                     ╭─ 012 -> 10
  #                     --
  $ echo "ibase=8;obase=12; 17" | bc
  15

  # or
  $ echo $((017))
  15
  ```

### to hexadecimal

> [!TIP]
> - if convert from **decimal**, the `ibase` can be ignored, or we can say, the default `ibase` is 10.

| FROM    | TO  | COMMAND                                                 | EXAMPLE            | OUTPUT |
|---------|-----|---------------------------------------------------------|--------------------|--------|
| Binary  | Hex | <code>echo "obase=16; ibase=2; 101011" &#124; bc</code> | `101011` → hex     | `2B`   |
| Octal   | Hex | <code>echo "obase=16; ibase=8; 77" &#124; bc</code>     | `77` (octal) → hex | `3F`   |
| Decimal | Hex | <code>echo "obase=16; 255" &#124; bc</code>             | `255`              | `FF`   |
| Decimal | Hex | `printf "%X\n" 255`                                     | `255`              | `FF`   |

- from decimal
  ```bash
  $ echo "obase=16; 15" | bc
  F

  # or
  $ echo "ibase=10;obase=16; 15" | bc
  F
  ```

- from octal
  ```bash
  $ echo "obase=16; ibase=8; 17" | bc
  F

  # or
  $ printf "%x\n" 017
  f
  ```


### to octal

| FROM    | TO    | COMMAND                                              | EXAMPLE                | OUTPUT |
|---------|-------|------------------------------------------------------|------------------------|--------|
| Binary  | Octal | <code>echo "obase=8; ibase=2; 1010" &#124; bc</code> | 1010 → base 2 → base 8 | `12`   |
| Decimal | Octal | `printf "%o\n" 42`                                   | 42                     | `52`   |
| Hex     | Octal | <code>echo "obase=8; ibase=16; FF" &#124; bc</code>  | FF → hex to octal      | `377`  |

- from hexadecimal
  ```bash
  $ echo "ibase=16;obase=8; F" | bc
  17
  ```

- from decimal
  ```bash
  $ echo "obase=8; 15" | bc
  17

  # or
  $ echo "ibase=10;obase=8; 15" | bc
  17
  ```

### to binary

> [!NOTE|label:references:]
> - [Prevent bc from auto truncating leading zeros when converting from hex to binary](https://stackoverflow.com/a/12633973/2940319)
> - [How to make `bc` output a desired number of base-2 binary digits](https://stackoverflow.com/a/71570190/2940319)

| FROM    | TO     | COMMAND                                             | EXAMPLE                | OUTPUT     |
|---------|--------|-----------------------------------------------------|------------------------|------------|
| Octal   | Binary | <code>echo "obase=2; ibase=8; 77" &#124; bc</code>  | 8#77 → obase=2         | `111111`   |
| Decimal | Binary | <code>echo "obase=2; 42" &#124; bc`</code>          | 42                     | `101010`   |
| Hex     | Binary | <code>echo "obase=2; ibase=16; FF" &#124; bc</code> | ibase=16; FF → obase=2 | `11111111` |

- from decimal
  ```bash
  $ bc <<< 'obase=2;15'
  1111

  $ bc -l <<< 'obase=2;0;0;15;255' | xargs
  0 0 1111 11111111

  $ bc -l <<< 'obase=2;0;0;15;255' | awk '{ printf "%08d\n", $0 }' | xargs
  00000000 00000000 00001111 11111111

  $ printf "%08d\n" $(echo "obase=2; 0;0;15;255" | bc) | xargs
  00000000 00000000 00001111 11111111

  $ bc <<< 'obase=2; 0;0;15;255' | numfmt --format=%08f | xargs
  00000000 00000000 00001111 11111111
  ```

### to unicode ( hexadecimal )

> [!NOTE|label:references:]
> - [Convert a character from and to its decimal, binary, octal, or hexadecimal representations in BASH / Shell](https://stackoverflow.com/a/73889450/2940319)

```bash
# 0x41 -> `A`; 0x61 -> `a`

# decimal -> hexadecimal
$ printf "$(printf %04x 65)\n"
0041

# \u<4-digits-hex>
$ printf "\u$(printf %04x 65)\n"
A

# \U<8-digits-hex>
$ printf "\U$(printf %08x 67147)\n"
𐙋

$ single_unicode_char="😈"
$ printf %d "'$single_unicode_char"
128520
$ printf "$(printf %08x 128520)\n"
0001f608
$ printf "\U$(printf %08x 128520)\n"
😈
```

- more
  ```bash
  $ single_unicode_char="😈"
  ```

- to hexadecimal
  ```bash
  #         ╭─ hexadecimal
  $ printf %x "'$single_unicode_char'"
  1f608
  $ printf %08X "'$single_unicode_char'"
  0001F608
  #                                                               ╭─ hexadecimal
  $ echo -n $single_unicode_char | iconv -t UTF-32LE | od -A n -t x4
   0001f608
  $ printf "\U0001f608"
  😈

  # or
  $ printf %#x "'$single_unicode_char"
  0x1f608
  $ printf %#X "'$single_unicode_char"
  0X1F608
  $ printf "\U$(printf %08x 0X1F608)\n"
  😈

  # or
  #                                           ╭─ hexadecimal
  $ echo -n $single_unicode_char | od -A n -t x1
   f0 9f 98 88
  $ printf %b "\xf0\x9f\x98\x88"
  😈
  #       ╭─ works without `%b` as well
  $ printf "\xf0\x9f\x98\x88"
  😈
  ```

- to octal

  ```bash
  #         ╭─ octal
  $ printf %o "'$single_unicode_char'"
  373010
  #                                                               ╭─ octal
  $ echo -n $single_unicode_char | iconv -t UTF-32LE | od -A n -t o4
   00000373010
  $ printf "\U$(printf %08x "00000373010")"
  😈

  # or
  #       ╭─ without `\n`
  $ echo -n $single_unicode_char | od -A n -t o1
   360 237 230 210
  $ printf %b "\360\237\230\210"
  😈
  ```

### number converting from file
- octal
  ```bash
  $ cat -p octal-data-file.txt
  7
  10
  11
  12
  13
  14
  15
  16
  17
  20
  21

  # octal -> hexadecimal
  $ ( echo "obase=16; ibase=8" ; cat octal-data-file.txt ) | bc
  7
  8
  9
  A
  B
  C
  D
  E
  F
  10
  11

  # octal -> decimal
  $ ( echo "obase=10; ibase=8" ; cat octal-data-file.txt ) | bc
  7
  8
  9
  10
  11
  12
  13
  14
  15
  16
  17
  ```

- hexadecimal
  ```bash
  $ cat -pp hex-data-file.txt
  9
  A
  B
  C
  D
  E
  F
  10
  11
  12
  13
  14
  15
  16
  17
  18
  19
  1A
  1B
  1C
  1D
  1E
  1F
  20

  # hexadecimal -> octal
  $ ( echo "obase=8; ibase=16" ; cat hex-data-file.txt ) | bc
  11
  12
  13
  14
  15
  16
  17
  20
  21
  22
  23
  24
  25
  26
  27
  30
  31
  32
  33
  34
  35
  36
  37
  40

  # hexadecimal -> decimal
  $ ( echo "obase=10; ibase=16" ; cat hex-data-file.txt ) | bc
  9
  10
  11
  12
  13
  14
  15
  16
  17
  18
  19
  20
  21
  22
  23
  24
  25
  26
  27
  28
  29
  30
  31
  32
  ```

## advanced computing

> [!NOTE|label:references:]
> - [How to calculate the log of a number using bc?](https://stackoverflow.com/a/7962297/2940319)
> - [指数与对数](https://www.shuxuele.com/algebra/exponents-logarithms.html)
> - [n次方根](https://www.shuxuele.com/numbers/nth-root.html)

### logarithm

- bc
  ```bash
  $ bc -l <<< 'l(9)/l(3)'
  2.00000000000000000000
  ```
  - [🫠](https://stackoverflow.com/a/48911293/2940319)
    ```bash
    $ bc -l <<< 'l(512)/l(2)'
    9.00000000000000000008
    ```

- awk
  ```bash
  $ echo 512 | awk '{print log($1)/log(2)}'
  9
  ```

### power
- bc
  ```bash
  $ bc <<< '2^3'
  8
  ```

- `$(())`
  ```bash
  $ echo $(( 2**8 ))
  256
  ```

### square
```bash
$ bc -l <<< 'sqrt(2)'
1.41421356237309504880

$ bc <<< 'sqrt(2)'
1
```
