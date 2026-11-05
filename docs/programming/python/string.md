
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

## references

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
