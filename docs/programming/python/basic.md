<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment](#environment)
  - [list included modules](#list-included-modules)
  - [list lib paths](#list-lib-paths)
- [Positional notation](#positional-notation)
  - [to Binary](#to-binary)
  - [to Octal](#to-octal)
  - [to Decimal](#to-decimal)
  - [to Hexadecimal](#to-hexadecimal)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## environment
### list included modules
```python
$ python -c 'help("modules")'

Please wait a moment while I gather a list of all available modules...

__future__          _warnings           graphlib            runpy
_abc                _weakref            grp                 sched
_aix_support        _weakrefset         gzip                secrets
...
```

### list lib paths
```python
$ python -c 'import sys; print (sys.path)'
['', '/usr/lib/python39.zip', '/usr/lib/python3.8', '/usr/lib/python3.8/lib-dynload', '/usr/local/lib/python3.8/dist-packages', '/usr/lib/python3/dist-packages']
```

## [Positional notation](https://en.wikipedia.org/wiki/Positional_notation)
### to Binary
- Octal to Binary
  ```python
  >>> bin( int('0o10', 8) )
  '0b1000'
  >>> bin( int('0o17', 8) )
  '0b1111'
  ```
- Decimal to Binary
  ```python
  >>> bin(2)
  '0b10'
  >>> bin(10)
  '0b1010'
  ```
  - or
    ```python
    >>> format( 3, 'b' )
    '11'
    >>> format( 15, 'b' )
    '1111'
    ```
-  Hexadecimal to Binary
  ```python
  >>> bin( int('a', 16) )
  '0b1010'
  >>> bin( int('f', 16) )
  '0b1111'
  ```

### to Octal
- Binary to Octal
  ```python
  >>> oct( int(str(111), 2) )
  '0o7'
  >>> oct( int(str(1000), 2) )
  '0o10'
  ```
- Decimal to Octal
  ```python
  >>> oct(8)
  '0o10'
  ```
  - or
    ```python
    >>> format( 15, 'o' )
    '17'
    >>> format( 8, 'o' )
    '10'
    ```
-  Hexadecimal to Octal
  ```python
  >>> oct( 0xf )
  '0o17'
  ```

### to Decimal
- Binary to Decimal
  ```python
  >>> int( str(11), 2 )
  3
  >>> int( str(1010), 2 )
  10
  ```
- Octal to Decimal
  ```python
  >>> 0o10
  8
  >>> int( 0o10 )
  8
  >>> int ( str(10), 8 )
  8
  ```
-  Hexadecimal to Decimal
  ```python
  >>> int( 0xf )
  15
  ```

### to Hexadecimal
- Binary to Hexadecimal
  ```python
  >>> hex( int(str(1010), 2) )
  '0xa'
  >>> hex( int(str(1111), 2) )
  '0xf'
  ```
- Octal to Hexadecimal
  ```python
  >>> hex(0o10)
  '0x8'
  >>> hex( int('0o17', 8 ))
  '0xf'
  ```
- Decimal to Hexadecimal
  ```python
  >>> hex(15)
  '0xf'
  >>> hex(66)
  '0x42'
  ```
  - [or](https://stackoverflow.com/a/16414603/2940319)
    ```python
    >>> format( 15, 'x' )
    'f'
    ```
  - [or](https://stackoverflow.com/a/10218221/2940319)
    ```python
    >>> '%x' % 15
    'f'
    ```
