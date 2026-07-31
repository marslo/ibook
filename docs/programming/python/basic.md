<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [operators](#operators)
  - [tips](#tips)
- [Positional notation](#positional-notation)
  - [to Binary](#to-binary)
  - [to Octal](#to-octal)
  - [to Decimal](#to-decimal)
  - [to Hexadecimal](#to-hexadecimal)
- [The Big Book of Small Python Projects](#the-big-book-of-small-python-projects)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## operators

> [!NOTE|label:references:]
> - [A Byte of Python - Operators and Expressions](https://python.swaroopch.com/op_exp.html)

| OPERATOR | DESCRIPTION                                  | EXAMPLE                                 |
|----------|----------------------------------------------|-----------------------------------------|
| `/`      | division (除法)                              | `2.5 == 5 / 2`                          |
| `//`     | floor division (整除/向下取整)               | `2 == 5 // 2`<br>`-3 == 5 // -2`        |
| `%`      | modulus (取余)                               | `1 == 5 % 2`                            |
| `<<`     | left shift (按位左移) `x << y == x * 2ʸ`     | `8 == 2 << 2`                           |
| `<<`     | right shift (按位右移) `x >> y == x // 2ʸ`   | `2 == 8 >> 2`                           |
| `&`      | bitwise AND (按位与 - 有0则0, 全1为1)        | `3 & 5 == 1`<br>`0011 & 0101 == 0001`   |
| `|`      | bitwise OR (按位或 - 有1则1, 全0则0)         | `3 | 5 == 7`<br>`0011 | 0101 == 0111`   |
| `^`      | bitwise XOR (按位异或 - 相同为0, 不同为1)    | `3 ^ 5 == 6`<br>`0011 ^ 0101 == 0110`   |
| `~`      | bitwise NOT (按位取反 - 0变1, 1变0)<br> `~x` | `~3 == -4`<br>`~0011 == 1100`           |
| `not`    | logical NOT (逻辑非)                         | `not True == False`                     |
| `and`    | logical AND (逻辑与)                         | `True and False == False`               |
| `or`     | logical OR (逻辑或)                          | `True or False == True`                 |

```python
# single number (XOR) - find the numbers that appear an odd number of times in the list
>>> result = 0
>>> list(result := result ^ num for num in [2, 3, 4, 3, 4])
>>> result
2

# encryption and decryption (XOR) - any two of the three numbers xor together to give the third
>>> 10 ^ 3
9
>> 9 ^ 3
10
>>> 10 ^ 9
3
```

### tips

```python
# `var = var operation expression` is equivalent to `var operation= expression`
a += 1      # == `a = a + 1`
a -= 1      # == `a = a - 1`
a *= 2      # == `a = a * 2`

# var operation var operation var == ( var operation var ) and ( var operation var ) and ( ... )
1 < x < 10         # == `(1 < x) and (x < 10)`
5 in [5] is True   # == `(5 in [5]) and ([5] is True)` - result is False
```

## [Positional notation](https://en.wikipedia.org/wiki/Positional_notation)
### to Binary
- octal to binary
  ```python
  >>> bin( int('0o10', 8) )
  '0b1000'
  >>> bin( int('0o17', 8) )
  '0b1111'
  ```

- decimal to binary
  ```python
  >>> bin(2)
  '0b10'
  >>> bin(10)
  '0b1010'

  # or
  >>> format( 3, 'b' )
  '11'
  >>> format( 15, 'b' )
  '1111'
  ```

-  hexadecimal to binary
  ```python
  >>> bin( int('a', 16) )
  '0b1010'
  >>> bin( int('f', 16) )
  '0b1111'
  ```

### to Octal
- binary to octal
  ```python
  >>> oct( int(str(111), 2) )
  '0o7'
  >>> oct( int(str(1000), 2) )
  '0o10'
  ```

- decimal to octal
  ```python
  >>> oct(8)
  '0o10'

  # or
  >>> format( 15, 'o' )
  '17'
  >>> format( 8, 'o' )
  '10'
  ```

- hexadecimal to octal
  ```python
  >>> oct( 0xf )
  '0o17'
  ```

### to Decimal
- binary to decimal
  ```python
  >>> int( str(11), 2 )
  3
  >>> int( str(1010), 2 )
  10
  ```

- octal to decimal
  ```python
  >>> 0o10
  8
  >>> int( 0o10 )
  8
  >>> int ( str(10), 8 )
  8
  ```

- hexadecimal to decimal
  ```python
  >>> int( 0xf )
  15
  ```

### to Hexadecimal
- binary to hexadecimal
  ```python
  >>> hex( int(str(1010), 2) )
  '0xa'
  >>> hex( int(str(1111), 2) )
  '0xf'
  ```

- octal to hexadecimal
  ```python
  >>> hex(0o10)
  '0x8'
  >>> hex( int('0o17', 8 ))
  '0xf'
  ```

- decimal to hexadecimal
  ```python
  >>> hex(15)
  '0xf'
  >>> hex(66)
  '0x42'

  # or
  >>> format( 15, 'x' )
  'f'

  # or - https://stackoverflow.com/a/10218221/2940319
  >>> '%x' % 15
  'f'
  ```

## [The Big Book of Small Python Projects](https://inventwithpython.com/bigbookpython/)

> [!NOTE|label:references:]
> - [The Big Book of Small Python Projects](https://inventwithpython.com/bigbookpython/)
> - [THE BIG BOOK OF SMALL PYTHON PROJECTS.pdf](https://edu.anarcho-copy.org/Programming%20Languages/Python/BigBookSmallPythonProjects.pdf)
> - [nihathalici/The-Big-Book-of-Small-Python-Projects](https://github.com/nihathalici/The-Big-Book-of-Small-Python-Projects/tree/main)
