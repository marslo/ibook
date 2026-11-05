<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [pad](#pad)
  - [left](#left)
  - [right](#right)
  - [center](#center)
- [f-strings](#f-strings)
- [string module](#string-module)
- [cheatsheet](#cheatsheet)
  - [uppercase and lowercase](#uppercase-and-lowercase)
  - [pad and fill](#pad-and-fill)
  - [trim](#trim)
  - [find](#find)
  - [split and join](#split-and-join)
  - [replacement](#replacement)
  - [is-functions](#is-functions)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [String Methods](https://docs.python.org/3/builtins/stdtypes.html#string-methods)
> - [Formatted String Literals (f-strings)](https://docs.python.org/3/builtins/stdtypes.html#formatted-string-literals-f-strings)

## pad

> [!NOTE|label:sample variables]
> ```python
> days: list[str] = [ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday' ]
> pad: int = max([ len(i) for i in days ])
> ```

### left
```python
print( '\n' + ' left pad '.center(80, '-') )
for day in days: print( f"{day.title().ljust(pad, ' ')} -> {type(day)}" )
# ----------------------------------- left pad -----------------------------------
# Monday    -> <class 'str'>
# Tuesday   -> <class 'str'>
# Wednesday -> <class 'str'>
# Thursday  -> <class 'str'>
# Friday    -> <class 'str'>
# Saturday  -> <class 'str'>
# Sunday    -> <class 'str'>

print( ' pythonic '.center(50, '~') )
for day in days: print( f"{day.title():<{pad}} -> {type(day).__name__}" )
# ~~~~~~~~~~~~~~~~~~~~ pythonic ~~~~~~~~~~~~~~~~~~~~
# Monday    -> str
# Tuesday   -> str
# Wednesday -> str
# Thursday  -> str
# Friday    -> str
# Saturday  -> str
# Sunday    -> str
```

### right

```python
print( '\n' + ' right pad '.center(80, '-') )
for day in days: print( f"{day.upper().rjust(pad, ' ')} -> {type(day)}" )
# ---------------------------------- right pad -----------------------------------
#    MONDAY -> <class 'str'>
#   TUESDAY -> <class 'str'>
# WEDNESDAY -> <class 'str'>
#  THURSDAY -> <class 'str'>
#    FRIDAY -> <class 'str'>
#  SATURDAY -> <class 'str'>
#    SUNDAY -> <class 'str'>

print( ' pythonic '.center(50, '~') )
for day in days: print( f"{day.upper():>{pad}} -> {type(day).__name__}" )
# ~~~~~~~~~~~~~~~~~~~~ pythonic ~~~~~~~~~~~~~~~~~~~~
#    MONDAY -> str
#   TUESDAY -> str
# WEDNESDAY -> str
#  THURSDAY -> str
#    FRIDAY -> str
#  SATURDAY -> str
#    SUNDAY -> str
```

### center

```python
print( '\n' + ' center '.center(80, '-') )
for day in days: print( f" {day} ".center(20, '.') )
# ------------------------------------ center ------------------------------------
# ...... monday ......
# ..... tuesday ......
# .... wednesday .....
# ..... thursday .....
# ...... friday ......
# ..... saturday .....
# ...... sunday ......

print( ' pythonic '.center(50, '~') )
for day in days: print( f"{f' {day} ':.^20}" )
# ~~~~~~~~~~~~~~~~~~~~ pythonic ~~~~~~~~~~~~~~~~~~~~
# ...... monday ......
# ..... tuesday ......
# .... wednesday .....
# ..... thursday .....
# ...... friday ......
# ..... saturday .....
# ...... sunday ......
```

## f-strings

```python
# 3.8+
number = 14.3
print( f'{number=}' )
# 'number=14.3'

print( f'{ number  -  4  = }' )
# ' number  -  4  = 10.3'

from fractions import Fraction
one_third = Fraction(1, 3)
print( f'{one_third}' )
# '1/3'

print( f'{one_third = }' )
# 'one_third = Fraction(1, 3)'
```

## string module

```python
import string

string.ascii_lowercase
# 'abcdefghijklmnopqrstuvwxyz'

string.ascii_uppercase
# 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'

string.ascii_letters          # a-z + A-Z
# 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'

string.digits
# '0123456789'

string.hexdigits
# '0123456789abcdefABCDEF'

string.punctuation
# '!"#$%&\'()*+,-./:;<=>?@[\\]^_`{|}~'
```

## cheatsheet

### uppercase and lowercase

| METHOD         | EXAMPLE                      | RESULT                                                 |
| -------------- | ---------------------------- | ------------------------------------------------------ |
| `upper()`      | `'py'.upper()`               | `'PY'`                                                 |
| `lower()`      | `'PY'.lower()`               | `'py'`                                                 |
| `title()`      | `'hello world'.title()`      | `'Hello World'`                                        |
| `capitalize()` | `'hello world'.capitalize()` | `'Hello world'`                                        |
| `swapcase()`   | `'Py'.swapcase()`            | `'pY'`                                                 |
| `casefold()`   | `'Straße'.casefold()`        | `'strasse'`(比 `lower` 更彻底，适合做忽略大小写的比较) |

### pad and fill

> [!TIP]
> ```python
> >>> '-42'.zfill( 5 )
> '-0042'
> >>> f'{"-42":0>5}'
> '00-42'
> >>> f'{-42:05}'
> '-0042'
> ```
> references:
> - [Format specification mini-language](https://docs.python.org/3/library/string.html#format-specification-mini-language)

| METHOD            | EXAMPLE                | F-STRING       | RESULT                                               |
| ----------------- | ---------------------- | -------------- | ---------------------------------------------------- |
| `s.center(w, c)`  | `'py'.center(6, '*')`  | `f'{s:*^6}'`   | `'**py**'`                                           |
| `s.center(w)`     | `'py'.center(6, '-')`  | `f'{s:-^6}'`   | `'--py--'`                                           |
| `s.ljust(w, c)`   | `'py'.ljust(5, '.')`   | `f'{s:.<5}'`   | `'py...'`                                            |
| `s.ljust(w)`      | `'py'.ljust(5)`        | `f'{s:<5}'`    | `'py   '`                                            |
| `s.rjust(w, c)`   | `'py'.rjust(5, '.')`   | `f'{s:.>5}'`   | `'...py'`                                            |
| `s.rjust(w)`      | `'py'.rjust(5)`        | `f'{s:>5}'`    | `'   py'`                                            |
| `s.zfill(w)`      | `'42'.zfill(5)`        | `f'{n:05}'`    | `'00042'`                                            |
| `s.zfill(w)`      | `'-42'.zfill(5)`       | `f'{-42:05}'`  | `'-0042'`                                            |
| -                 | -                      | `f'{-42:0=6}'` | `'-00042'`(= 表示在符号和数字之间填充，只能用于数字) |
| `s.expandtabs(n)` | `'a\tb'.expandtabs(4)` | -              | `'a b'`                                              |

### trim

| METHOD                   | EXAMPLE                          | RESULT   |
| ------------------------ | -------------------------------- | -------- |
| `strip(chars)`           | `' py '.strip()`                 | `'py'`   |
| `rstrip()`               | `'xxpyxx'.rstrip('x')`           | `'xxpy'` |
| `lstrip()`               | `'xxpyxx'.lstrip('x')`           | `'pyxx'` |
| `removeprefix(p)` (3.9+) | `'test_a'.removeprefix('test_')` | `'a'`    |
| `removesuffix(s)` (3.9+) | `'a.py'.removesuffix('.py')`     | `'a'`    |

### find

| METHOD                   | EXAMPLE                         | RESULT                                    |
| ------------------------ | ------------------------------- | ----------------------------------------- |
| `find(s)` / `rfind(s)`   | `'hello'.find('l')`             | `2` and `-1` if not found                 |
| `index(s)` / `rindex(s)` | `'hello'.index('z')`            | `ValueError` if not found                 |
| `count(s)`               | `'hello'.count('l')`            | `2`                                       |
| `startswith(p)`          | `'a.py'.startswith(('a', 'b'))` | `True` (可以传一个元组，匹配其中任意一个) |
| `endswith(s)`            | `'a.py'.endswith('.py')`        | `True`                                    |
| `in`                     | `'ell' in 'hello'`              | `True`                                    |

### split and join

> [!NOTE]
> | REPRESENTATION | DESCRIPTION                 |
> | -------------- | --------------------------- |
> | `\n`           | Line Feed                   |
> | `\r`           | Carriage Return             |
> | `\r\n`         | Carriage Return + Line Feed |
> | `\v` or `\x0b` | Line Tabulation             |
> | `\f` or `\x0c` | Form Feed                   |
> | `\x1c`         | File Separator              |
> | `\x1d`         | Group Separator             |
> | `\x1e`         | Record Separator            |
> | `\x85`         | Next Line (C1 Control Code) |
> | `\u2028`       | Line Separator              |
> | `\u2029`       | Paragraph Separator         |

| METHOD            | EXAMPLE                   | RESULT                               |
| ----------------- | ------------------------- | ------------------------------------ |
| `split(sep, n)`   | `'a,b,c'.split(',')`      | `['a', 'b', 'c']`                    |
| `split()`         | `' a b '.split()`         | `['a', 'b']` ( split by whitespace ) |
| `rsplit(sep, n)`  | `'a.b.c'.rsplit('.', 1)`  | `['a.b', 'c']`                       |
| `splitlines()`    | `'a\nb'.splitlines()`     | `['a', 'b']`                         |
| `partition(sep)`  | `'k=v=x'.partition('=')`  | `('k', '=', 'v=x')`                  |
| `rpartition(sep)` | `'a/b/c'.rpartition('/')` | `('a/b', '/', 'c')`                  |
| `join(iter)`      | `'-'.join(['a', 'b'])`    | `'a-b'`                              |

### replacement

| METHOD                                 | EXAMPLE                                        | RESULT            |
| -------------------------------------- | ---------------------------------------------- | ----------------- |
| `replace(old, new, n)`                 | `'aaa'.replace('a', 'b', 2)`                   | `'bba'`           |
| `translate(table)` + `str.maketrans()` | `'abc'.translate( str.maketrans('ab', 'xy') )` | `'xyc'`           |
| `format(...)`                          | `'{}-{}'.format(1, 2)`                         | `'1-2'`           |
| `format_map(d)`                        | `'{a}'.format_map({'a': 1})`                   | `'1'`             |
| `encode(enc)`                          | `'中'.encode('utf-8')`                         | `b'\xe4\xb8\xad'` |

### is-functions

| METHOD                                      | RESULT                               |
| ------------------------------------------- | ------------------------------------ |
| `isdigit()` / `isdecimal()` / `isnumeric()` | 都是数字字符，三者的判定范围依次变宽 |
| `isalpha()`                                 | 都是字母                             |
| `isalnum()`                                 | 都是字母或数字                       |
| `isspace()`                                 | 都是空白字符                         |
| `isupper()` / `islower()`                   | 有字母，并且全是大写 / 全是小写      |
| `istitle()`                                 | 是 title 格式，即每个单词首字母大写  |
| `isidentifier()`                            | 是合法的 Python 标识符               |
| `isascii()` (3.7+)                          | 都是 ASCII 字符                      |
| `isprintable()`                             | 都是可打印字符                       |
