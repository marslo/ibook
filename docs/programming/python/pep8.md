<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [PEP8 -- style guide for python code](#pep8----style-guide-for-python-code)
  - [indentation](#indentation)
  - [maximum line length](#maximum-line-length)
  - [should a line break before or after a binary operator?](#should-a-line-break-before-or-after-a-binary-operator)
  - [imports](#imports)
  - [module level under names](#module-level-under-names)
  - [whitespace in expressions and statements](#whitespace-in-expressions-and-statements)
  - [other recommendations](#other-recommendations)
  - [documentation strings](#documentation-strings)
  - [programming recommendations](#programming-recommendations)
- [PEP8 Error/Warning Code](#pep8-errorwarning-code)
  - [E1 indentation](#e1-indentation)
  - [E2 whitespace](#e2-whitespace)
  - [E3 blank line](#e3-blank-line)
  - [E4 Import](#e4-import)
  - [E5 line length](#e5-line-length)
  - [E7 statement](#e7-statement)
  - [E9 runtime](#e9-runtime)
  - [W1 indentation warning](#w1-indentation-warning)
  - [W2 whitespace warning](#w2-whitespace-warning)
  - [W3 blank line warning](#w3-blank-line-warning)
  - [W5 line break warning](#w5-line-break-warning)
  - [W6 deprecation warning](#w6-deprecation-warning)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [PEP8 -- style guide for python code](https://www.python.org/dev/peps/pep-0008/)
### indentation
✅
```python
# aligned with opening delimiter
foo = long_function_name(var_one, var_two,
                         var_three, var_four)

# more indentation included to distinguish this from the rest
def long_function_name(
    var_one, var_two, var_three,
    var_four):
  print(var_one)

# hanging indents should add a level
foo = long_function_name(
    var_one, var_two,
    var_three, var_four)
```

❌
```python
# arguments on first line forbidden when not using vertical alignment
foo = long_function_name(var_one, var_two,
    var_three, var_four)

# further indentation required as indentation is not distinguishable
def long_function_name(
    var_one, var_two, var_three,
    var_four):
  print(var_one)
```

#### optional
```python
# Hanging indents *may* be indented to other than 4 spaces.
foo = long_function_name(
  var_one, var_two,
  var_three, var_four)
```

#### `if` statemant
```python
# no extra indentation
if (this_is_one_thing and
    that_is_another_thing):
  do_something()

# add a comment, which will provide some distinction in editors
# supporting syntax highlighting
if (this_is_one_thing and
    that_is_another_thing):
    # since both conditions are true, we can frobnicate
  do_something()

# add some extra indentation on the conditional continuation line
if (this_is_one_thing
    and that_is_another_thing):
  do_something()o

```

#### list
```python
my_list = [
        1, 2, 3,
        4, 5, 6,
        ]
result = some_function_that_takes_arguments(
        'a', 'b', 'c',
        'd', 'e', 'f',
        )

# or
my_list = [
        1, 2, 3,
        4, 5, 6,
]
result = some_function_that_takes_arguments(
        'a', 'b', 'c',
        'd', 'e', 'f',
)
```

### maximum line length

✅
```python
with open('/path/to/some/file/you/want/to/read') as file_1, \
         open('/path/to/some/file/being/written', 'w') as file_2:
  file_2.write(file_1.read())
```

### should a line break before or after a binary operator?

❌ operators sit far away from their operands
```python
income = (gross_wages +
          taxable_interest +
          (dividends - qualified_dividends) -
          ira_deduction -
          student_loan_interest)
```

✅ easy to match operators with operands
```python
income = (gross_wages
          + taxable_interest
          + (dividends - qualified_dividends)
          - ira_deduction
          - student_loan_interest)

```

### imports
❌
```python
import sys, os
```

✅
```python
import os
import sys
```

bad
```python
import <module> from *
```

#### absolute imports are *recommended*
```python
import mypkg.sibling
from mypkg import silbing
from mypkg.sibling import example
```

#### explicit relative imports are acceptable
```python
from . import sibling
from .sibling import example
```

#### import a class from a class-containing module
```python
from myclass import MyClass
from foo.bar.yourclass import YourClass
```

#### local name classes
```python
import myclass
import foo.bar.yourclass

# use "myclass.MyClass" or "foo.bar.yourclass.YourClass"
```

### module level under names

{% hint style='tip' %}
> Module level "dunder" names with two leading and two trailing underscores, such as `__all__`, `__author__`, `__version__`, etc
{% endhint %}

✅
```python
"""This is the example module.

This module does stuff.
"""

from __future__ import barry_as_FLUFL

__all__ = ['a', 'b', 'c']
__version__ = '0.1'
__author__ = 'Cardinal Biggles'

import os
import sys
```

### whitespace in expressions and statements

❌
```python
spam( ham[ 1 ], { eggs: 2 } )
```

✅
```python
spam(ham[1], {eggs: 2})
```

--------

❌
```python
if x == 4 : print x , y ; x , y = y , x
```

✅
```python
if x == 4; print x, y; x, y = y, x
```

--------

❌
```python
ham[lower + offset:upper + offset]
ham[1: 9], ham[1 :9], ham[1:9 :3]
ham[lower : : upper]
ham[ : upper ]
```

✅
```python
ham[1:9], ham[1:9:3], ham[:9:3], ham[1::3], ham[1:9:]
ham[lower:upper], ham[lowser:pper:], ham[lower::step]
ham[lower+offset : upper+offset]
ham[: upper_fn(x) : step_fn(x)], ham[:: step_fn(x)]
ham[lower + offset : upper + offset]
```

--------

❌
```python
spam (1)
```

✅
```python
spam(1)
```

--------

❌
```python
dct ['key'] = lst [index]
```

✅
```python
dct['key'] = lst[index]
```

--------

❌
```python
x             = 1
y             = 2
long_variable = 3
```

✅
```python
x = 1
y = 2
long_variable = 3
```

### other recommendations

❌
```python
i=i+1
submitted +=1
x = x * 2 - 1
hypot2 = x * x + y * y
c = (a + b) * (a - b)
```

✅
```python
i = i + 1
submitted += 1
x = x*2 - 1
hypot2 = x*x + y*y
c = (a+b) * (a-b)
```

--------

❌
```python
def complex(real, imag = 0.0):
  return magic(r = real, i = imag)
```

✅
```python
def complex(real, imag=0.0):
  return magic(r=real, i=imag)
```

--------

❌
```python
def munge(input:AnyStr): ...
def munge()->PosInt: ...
```

✅
```python
def munge(input: AnyStr): ...
def munge() -> AnyStr: ...
```

--------

❌
```python
def munge(input: AnyStr=None): ...
def munge(input: AnyStr, limit = 1000): ...
```

✅
```python
def munge(sep: AnyStr = None): ...
def munge(input: AnyStr, sep: AnyStr = None, limit=1000): ...
```

##### rather NO
```python
if foo == 'blah': do_blah_thing()
do_one(); do_two(); do_three()
```

✅
```python
if foo == 'blah':
  do_blah_thing()
do_one()
do_two()
do_three()
```

#### DEFINITELY NO
```python
if foo == 'blah': do_blah_thing()
else: do_non_blah_thing()

try: something()
finally: cleanup()

do_one(); do_two(); do_three(long, argument,
                             list, like, this)

if foo == 'blah': one(); two(); three()
```

✅
```python
if foo == 'blah': do_blah_thing()
for x in lst: total += x
while t < 10: t = delay()
```

### documentation strings

✅
```python
"""Return a foobang

Optional plotz says to frobnicate the bizbaz first.
"""
```

### programming recommendations

❌
```python
if not foo is None:
```

✅
```python
if foo is not None:
```

--------

❌
```python
f = lambda x: 2*x
```

✅
```python
def f(x): return 2*x
```

--------

❌
```python
try:
  # too broad!
  return handle_value(collection[key])
expect KeyError:
  # will also catch KeyError raised by handle_value()
  return key_not_found(key)
```

✅
```python
try:
  value = collection[key]
except KeyError:
  return key_not_found(key)
else:
  return handle_value(value)
```

--------

❌
```python
with conn:
  do_stuff_in_transaction(conn)
```

✅
```python
with conn.begin_transaction():
  do_stuff_in_transaction(conn)
```

--------

❌
```python
def foo(x):
  if x >= 0:
    return math.sqrt(x)

def bar(x):
  if x < 0:
    return
  return math.sqrt(x)
```

✅
```python
def foo(x):
  if x >= 0:
    return math.sqrt(x)
  else:
    return None

def bar(x):
  if x < 0:
    return None
  return math.sqrt(x)
```

--------

❌
```python
if foo[:3] == 'bar':
```

✅
```python
if foo.startwith('bar'):
```

--------

❌
```python
if type(obj) is type(1):
```

✅
```python
if isinstance(obj, int):
```

--------

❌
```python
if len(seq):
if not len(seq):
```

✅
```python
if not seq:
if seq:
```

--------

❌
```python
if greeting == True:
```

✅
```python
if greeting:
```

worse
```python
if greeting is True:
```

--------

## [PEP8 Error/Warning Code](http://pep8.readthedocs.io/en/release-1.7.x/intro.html#error-codes)
### E1 indentation
* E101    indentation contains mixed spaces and tabs
* E111    indentation is not a multiple of four
* E112    expected an indented block
* E113    unexpected indentation
* E114    indentation is not a multiple of four (comment)
* E115    expected an indented block (comment)
* E116    unexpected indentation (comment)
* E121 (*^)   continuation line under-indented for hanging indent
* E122 (^)    continuation line missing indentation or outdented
* E123 (*)    closing bracket does not match indentation of opening bracket’s line
* E124 (^)    closing bracket does not match visual indentation
* E125 (^)    continuation line with same indent as next logical line
* E126 (*^)   continuation line over-indented for hanging indent
* E127 (^)    continuation line over-indented for visual indent
* E128 (^)    continuation line under-indented for visual indent
* E129 (^)    visually indented line with same indent as next logical line
* E131 (^)    continuation line unaligned for hanging indent
* E133 (*)    closing bracket is missing indentation

### E2 whitespace
* E201    whitespace after ‘(‘
* E202    whitespace before ‘)’
* E203    whitespace before ‘:’
* E211    whitespace before ‘(‘
* E221    multiple spaces before operator
* E222    multiple spaces after operator
* E223    tab before operator
* E224    tab after operator
* E225    missing whitespace around operator
* E226 (*)    missing whitespace around arithmetic operator
* E227    missing whitespace around bitwise or shift operator
* E228    missing whitespace around modulo operator
* E231    missing whitespace after ‘,’, ‘;’, or ‘:’
* E241 (*)    multiple spaces after ‘,’
* E242 (*)    tab after ‘,’
* E251    unexpected spaces around keyword / parameter equals
* E261    at least two spaces before inline comment
* E262    inline comment should start with ‘# ‘
* E265    block comment should start with ‘# ‘
* E266    too many leading ‘#’ for block comment
* E271    multiple spaces after keyword
* E272    multiple spaces before keyword
* E273    tab after keyword
* E274    tab before keyword

### E3 blank line
* E301    expected 1 blank line, found 0
* E302    expected 2 blank lines, found 0
* E303    too many blank lines (3)
* E304    blank lines found after function decorator

### E4 Import
* E401    multiple imports on one line
* E402    module level import not at top of file

### E5 line length
* E501 (^)    line too long (82 > 79 characters)
* E502    the backslash is redundant between brackets

### E7 statement
* E701    multiple statements on one line (colon)
* E702    multiple statements on one line (semicolon)
* E703    statement ends with a semicolon
* E704 (*)    multiple statements on one line (def)
* E711 (^)    comparison to None should be ‘if cond is None:’
* E712 (^)    comparison to True should be ‘if cond is True:’ or ‘if cond:’
* E713    test for membership should be ‘not in’
* E714    test for object identity should be ‘is not’
* E721 (^)    do not compare types, use ‘isinstance()’
* E731    do not assign a lambda expression, use a def

### E9 runtime
* E901    SyntaxError or IndentationError
* E902    IOError

### W1 indentation warning
* W191    indentation contains tabs

### W2 whitespace warning
* W291    trailing whitespace
* W292    no newline at end of file
* W293    blank line contains whitespace

### W3 blank line warning
* W391    blank line at end of file

### W5 line break warning
* W503    line break occurred before a binary operator

### W6 deprecation warning
* W601    .has_key() is deprecated, use ‘in’
* W602    deprecated form of raising exception
* W603    ‘<>’ is deprecated, use ‘!=’
* W604    backticks are deprecated, use ‘repr()’
