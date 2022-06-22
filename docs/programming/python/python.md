<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

  - [Pythonic](#pythonic)
    - [zip/unzip](#zipunzip)
    - [in](#in)
    - [dict & counter](#dict--counter)
    - [enumerate](#enumerate)
    - [import local module](#import-local-module)
    - [args & kwargs](#args--kwargs)
    - [itertools](#itertools)
    - [one-line python code](#one-line-python-code)
    - [slice](#slice)
    - [Chain Compare](#chain-compare)
    - [Boolean](#boolean)
    - [Reverse](#reverse)
    - [Join in list](#join-in-list)
    - [Sum & Max & Min & Time](#sum--max--min--time)
- [sum = 15 maxNum = 5 minNum = 1 prod = 120](#sum--15-maxnum--5-minnum--1-prod--120)
    - [Default Dict](#default-dict)
    - [if...else...](#ifelse)
    - [Ternary Operator](#ternary-operator)
    - [dict & zip](#dict--zip)
  - [hidden features](#hidden-features)
    - [numbers](#numbers)
    - [string](#string)
    - [args](#args)
    - [Conditional Assignment](#conditional-assignment)
    - [list & dics](#list--dics)
    - [generator & iteration](#generator--iteration)
    - [statement](#statement)
    - [funcs](#funcs)
    - [class & module](#class--module)
    - [Others](#others)
  - [PEP8 -- Style Guide for Python Code](#pep8----style-guide-for-python-code)
    - [Indentation](#indentation)
    - [Maximum Line Length](#maximum-line-length)
    - [Should a Line break before or after a binary operator?](#should-a-line-break-before-or-after-a-binary-operator)
    - [imports](#imports)
    - [module Level dunder names](#module-level-dunder-names)
    - [whitespace in expressions and statements](#whitespace-in-expressions-and-statements)
    - [other recommendations](#other-recommendations)
    - [documentation strings](#documentation-strings)
    - [Programming Recommendations](#programming-recommendations)
  - [PEP8 Error/Warning Code](#pep8-errorwarning-code)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Pythonic

{% hint style='tip' %}
> Inspired from [what are same example of beautiful 'Pythonic' code?](https://www.quora.com/What-are-some-examples-of-beautiful-Pythonic-code) and [如何让你的Python代码更加pythonic?](http://www.pythontab.com/html/2015/pythonhexinbiancheng_1029/970.html)
> [run python code online](https://reqbin.com/code/python)
{% endhint %}

### zip/unzip
```python
def unzip(tuples):
  if tuples:
    return [tuple(t[i] for t in tuples) for i, _ in enumerate(tuples[0])]
  else:
    return []
```
- result:
  ```python
  >>> unzip( ((1, 2), (3, 4), (5, 6)) )
  [(1, 3, 5), (2, 4, 6)]
  ```


### in
```python
long_string = "This is a very long string"
if "long" in long_string:
  print("Match found")
```

### dict & counter
```python
>>> from collections import Counter
>>> fruits = ['orange', 'banana', 'apple', 'orange', 'banana']
>>> Counter(fruits)
Counter({'orange': 2, 'banana': 2, 'apple': 1})
```

### enumerate
```python
x = ['a', 'b', 'c']

for index, item in enumerate(x):
  print(index, item)
```

- P:
  ```python
  array = [1, 2, 3, 4, 5]

  for i, e in enumerate(array,0):
    print i, e
  #0 1
  #1 2
  #2 3
  #3 4
  #4 5
  ```

- NP:
  ```python
  for i in xrange(len(array)):
    print i, array[i]
  #0 1
  #1 2
  #2 3
  #3 4
  #4 5
  ```

### import local module
```python
# A.py
def filter_items(items):
  for i in items:
    if i < 10:
      yield i


# B.py
from A import filter_items as A_filter_items

def filter_items(items):
  for i in items:
    if i <= 5:
      yield i

def do_something(items):
  x = A_filter_items(items)
  y = filter_items(items)
  return (x, y)
```

### args & kwargs
```python
def add(one, two):
  return one + two

my_list = [1, 2]
x = add(*my_list)  # x = 3

my_dict = {"one": 1, "two": 2}
y = add(**my_dict) #y = 3
```

### itertools
```python
>>> from itertools import zip_longest
>>> x = [1, 2, 3, 4]
>>> y = ['a', 'b', 'c']
>>> for i, j in zip_longest(x, y):
...     print(i, j)
...
1 a
2 b
3 c
4 None
```


### one-line python code
```python
>>> my_dict = {key: value for key, value in zip_longest(x,y)}
>>> my_dict
{1: 'a', 2: 'b', 3: 'c', 4: None}
```


### slice
```python
word = #some word
is_palindrome = word.find(word[-1::-1])
```


### Chain Compare
- P:

  ```python
  a = 3
  b = 1
  1 <= b <= a < 10  #True

  ```

- NP:

  ```python
  a = 3
  b = 1
  b >= 1 and b <= a and a < 10 #True
  ```


### Boolean
- P:
  ```python
  name = 'Tim'
  langs = ['AS3', 'Lua', 'C']
  info = {'name': 'Tim', 'sex': 'Male', 'age':23 }

  if name and langs and info:
    print('All True!')  #All True!
  ```

- NP:

  ```python
  if name != '' and len(langs) > 0 and info != {}:
    print('All True!') #All True!
  ```


### Reverse

- P:
  ```python
  def reverse_str( s ):
    return s[::-1]
  ```


- NP:
  ```python
  def reverse_str( s ):
    t = ''
    for x in xrange(len(s)-1,-1,-1):
      t += s[x]
    return t
  ```


### Join in list
- P:
  ```python
  strList = ["Python", "is", "good"]
  res =  ' '.join(strList) #Python is good
  ```

- NP:
  ```python
  res = ''
  for s in strList:
    res += s + ' '
  #Python is good
  #最后还有个多余空格
  ```



### Sum & Max & Min & Time
- P:

  ```python
  numList = [1,2,3,4,5]
  sum = sum(numList)    #sum = 15
  maxNum = max(numList) #maxNum = 5
  minNum = min(numList) #minNum = 1
  from operator import mul
  prod = reduce(mul, numList, 1) #prod = 120 默认值传1以防空列表报错
  ```

- NP:

  ```python
  sum = 0
  maxNum = -float('inf')
  minNum = float('inf')
  prod = 1
  for num in numList:
    if num > maxNum:
      maxNum = num
    if num < minNum:
      minNum = num
    sum += num
    prod *= num
# sum = 15 maxNum = 5 minNum = 1 prod = 120
  ```


### List Comprehensions
- P:
  ```python
  l = [x*x for x in range(10) if x % 3 == 0]
  # l = [0, 9, 36, 81]
  ```

- NP:
  ```python
  l = []
  for x in range(10):
    if x % 3 == 0:
      l.append(x*x)
  # l = [0, 9, 36, 81]
  ```


### Default Dict
- P:
  ```python
  dic = {'name':'Tim', 'age':23}

  dic['workage'] = dic.get('workage',0) + 1
  # dic = {'age': 23, 'workage': 1, 'name': 'Tim'}
  ```

- NP:
  ```python
  if 'workage' in dic:
    dic['workage'] += 1
  else:
    dic['workage'] = 1
  # dic = {'age': 23, 'workage': 1, 'name': 'Tim'}
  ```

### if...else...
- P:
  ```python
  for x in xrange(1,5):
    if x == 5:
      print 'find 5'
      break
  else:
    print 'can not find 5!'
  # can not find 5!
  ```

- NP:
  ```python
  find = False
  for x in xrange(1,5):
    if x == 5:
      find = True
      print 'find 5'
      break
  if not find:
    print 'can not find 5!'
  # can not find 5!
  ```


### Ternary Operator
- P:
  ```python
  a = 3

  b = 2 if a > 2 else 1
  # b = 2
  ```

- NP:
  ```python
  if a > 2:
    b = 2
  else:
    b = 1
  # b = 2
  ```

### dict & zip
- P:
  ```python
  keys = ['Name', 'Sex', 'Age']
  values = ['Tim', 'Male', 23]

  dic = dict(zip(keys, values))
  # {'Age': 23, 'Name': 'Tim', 'Sex': 'Male'}
  ```

- NP:
  ```python
  dic = {}
  for i,e in enumerate(keys):
    dic[e] = values[i]
  # {'Age': 23, 'Name': 'Tim', 'Sex': 'Male'}
  ```

## [hidden features](http://stackoverflow.com/questions/101268/hidden-features-of-python)

### numbers
#### round
```python
>>> str(round(1234.5678, -2))
'1200.0'
>>> str(round(1234.5678, 2))
'1234.57'
```

#### integer base
```python
>>> int('10', 0)
10
>>> int('0x10', 0)
16
>>> int('010', 0)  # does not work on Python 3.x
8
>>> int('0o10', 0)  # Python >=2.6 and Python 3.x
8
>>> int('0b10', 0)  # Python >=2.6 and Python 3.x
2
```

#### in-place value swapping
```python
>>> a = 10
>>> b = 5
>>> a, b
(10, 5)

>>> a, b = b, a
>>> a, b
(5, 10)
```

#### sum
```python
from operator import add
print reduce(add, [1,2,3,4,5,6])
```

### string
#### multi-line strings
```python
>>> sql = "select * from some_table \
where id > 10"
>>> print sql
select * from some_table where id > 10
```

- or
  ```python
  >>> sql = """select * from some_table
  where id > 10"""
  >>> print sql
  select * from some_table where id > 10
  ```

- or
  ```python
  >>> sql = ("select * from some_table " # <-- no comma, whitespace at end
             "where id > 10 "
             "order by name")
  >>> print sql
  select * from some_table where id > 10 order by name
  ```

#### in
```python
>>> 'str' in 'string'
True
>>> 'no' in 'yes'
False
>>>
```

#### Join
```python
''.join(list_of_strings)
```

#### set
```python
>>> a = set([1,2,3,4])
>>> b = set([3,4,5,6])
>>> a | b # Union
{1, 2, 3, 4, 5, 6}
>>> a & b # Intersection
{3, 4}
>>> a < b # Subset
False
>>> a - b # Difference
{1, 2}
>>> a ^ b # Symmetric Difference
{1, 2, 5, 6}
```

#### slice operators
```python
a = [1,2,3,4,5]
>>> a[::2]  # iterate over the whole list in 2-increments
[1,3,5]
```

- or
  ```python
  >>> a[::-1]
  [5,4,3,2,1]
  ```

- or
  ```python
  >>> a = range(10)
  >>> a
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  >>> a[:5] = [42]
  >>> a
  [42, 5, 6, 7, 8, 9]
  >>> a[:1] = range(5)
  >>> a
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  >>> del a[::2]
  >>> a
  [1, 3, 5, 7, 9]
  >>> a[::2] = a[::-2]
  >>> a
  [9, 3, 5, 7, 1]
  ```

#### reversed
```python
for i in reversed([1, 2, 3]):
  print(i)
```

#### backslashes
```python
>>> print repr(r"aaa\"bbb")
'aaa\\"bbb'
```

- or
  ```python
  >>> print repr(r"C:\")
  SyntaxError: EOL while scanning string literal
  >>> print repr(r"C:\"")
  'C:\\"'
  ```

### args

#### Use `_` instead of last printed item
```python
>>> range(10)
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

>>> _
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>>
```

#### `*args` & `**kwargs`
```python
>>> g = lambda *args, **kwargs: args[0], kwargs['thing']
>>> g(1, 2, 3, thing='stuff')
(1, 'stuff')
```

- or
  ```python
  def foo(a, b, c):
    print a, b, c

  bar = (3, 14, 15)
  foo(*bar)
  ```

#### function argument unpacking
```python
def draw_point(x, y):
  # do some magic

point_foo = (3, 4)
point_bar = {'y': 3, 'x': 2}

draw_point(*point_foo)
draw_point(**point_bar)
```

### Conditional Assignment
#### Ternary operator
```python
>>> 'ham' if True else 'spam'
'ham'
>>> 'ham' if False else 'spam'
'spam'
```

- or
  ```python
  >>> True and 'ham' or 'spam'
  'ham'
  >>> False and 'ham' or 'spam'
  'spam'
  ```

- or
  ```python
  >>> [] if True else 'spam'
  []
  >>> True and [] or 'spam'
  'spam'
  ```

- or
  ```python
  In [18]: a = True

  In [19]: a and 3 or 4
  Out[19]: 3

  In [20]: a = False

  In [21]: a and 3 or 4
  Out[21]: 4
  ```

- or
  ```python
  >>> (1 and [foo()] or [bar()])[0]
  foo
  0
  ```

- or
  ```python
  >>> foo() if True or bar()
  foo
  0
  ```

#### conditional
```python
x = 3 if (y == 1) else 2
```

- or
  ```python
  x = 3 if (y == 1) else 2 if (y == -1) else 1
  ```

- or
  ```python
  (func1 if y == 1 else func2)(arg1, arg2)
  ```

- or
  ```python
  x = (class1 if y == 1 else class2)(arg1, arg2)
  ```

- or
  ```python
  [(x, y) for x in range(4) if x % 2 == 1 for y in range(4)]
  [(1, 0), (1, 1), (1, 2), (1, 3), (3, 0), (3, 1), (3, 2), (3, 3)]
  ```

- or
  ```python
  x = 3 if (y == 1) else 2                is equvalent to                 x = y == 1 and 3 or 2
  x = 0 if True else 1                    is equvalent to                 x = True and 0 or 1
  ```

- or
  ```python
  foo = [x for x in xrange(10) if x % 2 == 0]
  ```

  - equal to
    ```python
    foo = []
    for x in xrange(10):
      if x % 2 == 0:
        foo.append(x)
    ```

#### [dict comprehensions](https://en.wikipedia.org/wiki/List_comprehension#Dictionary_comprehension), [manual](https://docs.python.org/dev/reference/expressions.html?highlight=comprehensions#dictionary-displays)
```python
>>> {i: i**2 for i in range(5)}
{0: 0, 1: 1, 2: 4, 3: 9, 4: 16}
```

#### set comprehensions
> [wiki](https://en.wikipedia.org/wiki/List_comprehension#Set_comprehension)
> [manual](https://docs.python.org/dev/reference/expressions.html?highlight=comprehensions#set-displays)

```python
>>> {i**2 for i in range(5)}
set([0, 1, 4, 16, 9])
```

### list & dics
#### zip
```python
a = [(1,2), (3,4), (5,6)]
zip(*a)
# [(1, 3, 5), (2, 4, 6)]
```

- or
  ```python
  >>> dict([ ('foo','bar'),('a',1),('b',2) ])
  {'a': 1, 'b': 2, 'foo': 'bar'}

  >>> names = ['Bob', 'Marie', 'Alice']
  >>> ages = [23, 27, 36]
  >>> dict(zip(names, ages))
  {'Alice': 36, 'Bob': 23, 'Marie': 27}
  ```

- or
  ```python
  >>> t1 = (0,1,2,3)
  >>> t2 = (7,6,5,4)
  >>> [t1,t2] == zip(*zip(t1,t2))
  True
  ```

- or
  ```python
  In [15]: t1 = (1, 2, 3)
  In [16]: t2 = (4, 5, 6)
  In [17]: dict (zip(t1,t2))
  Out[17]: {1: 4, 2: 5, 3: 6}
  ```

- or
  ```python
  >>> l=[(1,2),(3,4)]
  >>> [a+b for a,b in l ]
  [3,7]
  ```

#### list & sum
```python
>>> l = [[1, 2, 3], [4, 5], [6], [7, 8, 9]]
>>> sum(l, [])
[1, 2, 3, 4, 5, 6, 7, 8, 9]
```

#### nested list
```python
[(i,j) for i in range(3) for j in range(i) ]
```

- or
  ```python
  ((i,j) for i in range(4) for j in range(i) )
  ```

#### enumerate
```python
>>> a = ['a', 'b', 'c', 'd', 'e']
>>> for index, item in enumerate(a): print index, item
...
0 a
1 b
2 c
3 d
4 e
```

- or
  ```python
  >>> l = ["spam", "ham", "eggs"]
  >>> list(enumerate(l))
  >>> [(0, "spam"), (1, "ham"), (2, "eggs")]
  >>> list(enumerate(l, 1))
  >>> [(1, "spam"), (2, "ham"), (3, "eggs")]
  ```

#### Generate List
```python
>>> from functools import partial
>>> bound_func = partial(range, 0, 10)
>>> bound_func()
[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
>>> bound_func(2)
[0, 2, 4, 6, 8]
```

#### dict's constructor
```python
>>> dict(foo=1, bar=2)
{'foo': 1, 'bar': 2}
```

- or
  ```python
  >>> a = {}
  >>> b = a.setdefault('foo', 'bar')
  >>> a
  {'foo': 'bar'}
  >>> b
  'bar
  ```

#### dict's get
```python
t = {1: 'a'}
>>> test[2]

Traceback (most recent call last):
  File "<pyshell#158>", line 1, in <module>
    test[2]
KeyError: 2
>>> test.get(2)
>>> test.get(1)
'a'
>>> test.get(2) == None
True
>>> test.get(2, 'some') == 'some'
True
```

#### copy list
```python
>>> x = [1,2,3]
>>> y = x[:]
>>> y.pop()
3
>>> y
[1, 2]
>>> x
[1, 2, 3]
```

#### replace list
```python
>>> x = [1,2,3]
>>> y = x
>>> y[:] = [4,5,6]
>>> x
[4, 5, 6]
```

#### generators objects
```python
x = [n for n in foo if bar(n)]
```

- or
  ```python
  >>> n = ((a,b) for a in range(0,2) for b in range(4,6))
  >>> for i in n:
  ...   print i

  (0, 4)
  (0, 5)
  (1, 4)
  (1, 5)
  ```

### generator & iteration
#### [iteration](http://docs.python.org/library/itertools.html) & constructor (yield)
```python
>>> def g(n):
...     for i in range(n):
...             yield i **2
>>> t = g(5)
>>> t.next()
0
>>> t.next()
1
>>> t.next()
4
>>> t.next()
9
>>> t.next()
16
>>> t.next()
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
StopIteration
```

- or
  ```python
  def fab(max):
    a,b = 0,1
    while a < max:
      yield a
      a, b = b, a+b

  >>> for i in fab(20):
  ...     print i,",",
  ...
  0 , 1 , 1 , 2 , 3 , 5 , 8 , 13 ,
  ```

- or
  ```python
  >>> i = (1,2,3,4,5,6,7,8,9,10) # or any iterable object
  >>> iterators = [iter(i)] * 2
  >>> iterators[0].next()
  1
  >>> iterators[1].next()
  2
  >>> iterators[0].next()
  3
  ```

- or
  ```python
  def grouper(n, iterable, fillvalue=None):
    "grouper(3, 'ABCDEFG', 'x') --> ABC DEF Gxx"
    args = [iter(iterable)] * n
    return izip_longest(fillvalue=fillvalue, *args)
  ```

- or
  ```python
  >>> from itertools import *
  >>> l = [[1, 2], [3, 4]]
  >>> list(chain(*l))
  [1, 2, 3, 4]
  ```

- or
  ```python
  def create_printers(n):
    for i in xrange(n):
      def printer(i=i): # Doesn't work without the i=i
        print i
      yield printer
  ```

### statement
#### `for...else...`
```python
for i in foo:
  if i == 0:
    break
else:
  print("i was never 0")
```

- or
  ```python
  found = False
  for i in foo:
    if i == 0:
      found = True
      break
  if not found:
    print("i was never 0")
  ```

#### context managers and the "with" statement
```python
from __future__ import with_statement

with open('foo.txt', 'w') as f:
  f.write('hello!')
```

#### `try...except...elese...finally`
```python
try:
  put_4000000000_volts_through_it(parrot)
except Voom:
  print "'E's pining!"
else:
  print "This parrot is no more!"
finally:
  end_sketch()
```

### funcs
#### dir
```python
>>> dir("foo")
['__add__', '__class__', '__contains__', (snipped a bunch), 'title',
 'translate', 'upper', 'zfill']
```

#### help
```python
>>> help("foo".upper)
  Help on built-in function upper:

upper(...)
  S.upper() -> string

  Return a copy of the string S converted to uppercase.
```

#### convenient web-browser controller
```python
>>> import webbrowser
>>> webbrowser.open_new_tab('http://www.stackoverflow.com')
```

#### built-in http server
```python
python -m SimpleHTTPServer 8000
```

#### an interpreter within the interpreter
```python
$ python
Python 2.5.1 (r251:54863, Jan 17 2008, 19:35:17)
[GCC 4.0.1 (Apple Inc. build 5465)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> shared_var = "Set in main console"
>>> import code
>>> ic = code.InteractiveConsole({ 'shared_var': shared_var })
>>> try:
...     ic.interact("My custom console banner!")
... except SystemExit, e:
...     print "Got SystemExit!"
...
My custom console banner!
>>> shared_var
'Set in main console'
>>> shared_var = "Set in sub-console"
>>> import sys
>>> sys.exit()
Got SystemExit!
>>> shared_var
'Set in main console'
```

#### pretty print
```python
>>> import pprint
>>> stuff = sys.path[:]
>>> stuff.insert(0, stuff)
>>> pprint.pprint(stuff)
[<Recursion on list with id=869440>,
 '',
 '/usr/local/lib/python1.5',
 '/usr/local/lib/python1.5/test',
 '/usr/local/lib/python1.5/sunos5',
 '/usr/local/lib/python1.5/sharedmodules',
 '/usr/local/lib/python1.5/tkinter']
```

- or
  ```python
  from __future__ import print_function

  mylist = ['foo', 'bar', 'some other value', 1,2,3,4]
  print(*mylist)
  ```

### class & module

#### bash
```python
python -c"import os; print(os.getcwd());"
```

#### assertion
```python
>>> try:
...     assert []
... except AssertionError:
...     print "This list should not be empty"
This list should not be empty
```

#### `import`
```python
try:
  import json
except ImportError:
  import simplejson as json
```

#### create new types
```python
>>> NewType = type("NewType", (object,), {"x": "hello"})
>>> n = NewType()
>>> n.x
"hello"
```

- or
  ```python
  >>> class NewType(object):
  >>>     x = "hello"
  >>> n = NewType()
  >>> n.x
  "hello"
  ```

#### Manipulating sys.modules
```python
>>> import sys
>>> import ham
Traceback (most recent call last):
    File "<stdin>", line 1, in <module>
ImportError: No module named ham

# Make the 'ham' module available -- as a non-module object even!
>>> sys.modules['ham'] = 'ham, eggs, saussages and spam.'
>>> import ham
>>> ham
'ham, eggs, saussages and spam.'

# Now remove it again.
>>> sys.modules['ham'] = None
>>> import ham
Traceback (most recent call last):
```

- or
  ```python
  >>> import os
  # Stop future imports of 'os'.
  >>> sys.modules['os'] = None
  >>> import os
  Traceback (most recent call last):
      File "<stdin>", line 1, in <module>
  ImportError: No module named os
  # Our old imported module is still available.
  >>> os
  <module 'os' from '/usr/lib/python2.5/os.pyc'>
  ```

### Others
#### not hidden but still nice
```python
import os.path as op

root_dir = op.abspath(op.join(op.dirname(__file__), ".."))
```

#### be careful with mutable default arguments
```python
>>> def foo(x=[]):
...     x.append(1)
...     print x
...
>>> foo()
[1]
>>> foo()
[1, 1]
>>> foo()
[1, 1, 1]
```

- or
  ```python
  >>> def foo(x=None):
  ...     if x is None:
  ...         x = []
  ...     x.append(1)
  ...     print x
  >>> foo()
  [1]
  >>> foo()
  [1]
  ```

## [PEP8 -- Style Guide for Python Code](https://www.python.org/dev/peps/pep-0008/)
### Indentation
- yes:
  ```python
  # Aligned with opening delimiter.
  foo = long_function_name(var_one, var_two,
                           var_three, var_four)

  # More indentation included to distinguish this from the rest.
  def long_function_name(
      var_one, var_two, var_three,
      var_four):
    print(var_one)

  # Hanging indents should add a level.
  foo = long_function_name(
      var_one, var_two,
      var_three, var_four)

  ```
- no:
  ```python
  # Arguments on first line forbidden when not using vertical alignment.
  foo = long_function_name(var_one, var_two,
      var_three, var_four)

  # Further indentation required as indentation is not distinguishable.
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
# No extra indentation.
if (this_is_one_thing and
    that_is_another_thing):
  do_something()

# Add a comment, which will provide some distinction in editors
# supporting syntax highlighting.
if (this_is_one_thing and
    that_is_another_thing):
    # Since both conditions are true, we can frobnicate.
  do_something()

# Add some extra indentation on the conditional continuation line.
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
```

- or
  ```python
  my_list = [
          1, 2, 3,
          4, 5, 6,
  ]
  result = some_function_that_takes_arguments(
          'a', 'b', 'c',
          'd', 'e', 'f',
  )
  ```

### Maximum Line Length
- yes:
  ```python
  with open('/path/to/some/file/you/want/to/read') as file_1, \
           open('/path/to/some/file/being/written', 'w') as file_2:
    file_2.write(file_1.read())
  ```

### Should a Line break before or after a binary operator?
- no: operators sit far away from their operands
  ```python
  income = (gross_wages +
            taxable_interest +
            (dividends - qualified_dividends) -
            ira_deduction -
            student_loan_interest)
  ```

- yes: easy to match operators with operands
  ```python
  income = (gross_wages
            + taxable_interest
            + (dividends - qualified_dividends)
            - ira_deduction
            - student_loan_interest)

  ```

### imports
- no:
  ```python
  import sys, os
  ```

- yes:
  ```python
  import os
  import sys
  ```

- bad:
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

### module Level dunder names

{% hint style='tip' %}
> Module level "dunder" names with two leading and two trailing underscores, such as `__all__`, `__author__`, `__version__`, etc
{% endhint %}

- yes:
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

- no:
  ```python
  spam( ham[ 1 ], { eggs: 2 } )
  ```

- yes:
  ```python
  spam(ham[1], {eggs: 2})
  ```

--------

- no:
  ```python
  if x == 4 : print x , y ; x , y = y , x
  ```

- yes:
  ```python
  if x == 4; print x, y; x, y = y, x
  ```

--------

- no:
  ```python
  ham[lower + offset:upper + offset]
  ham[1: 9], ham[1 :9], ham[1:9 :3]
  ham[lower : : upper]
  ham[ : upper ]
  ```

- yes:
  ```python
  ham[1:9], ham[1:9:3], ham[:9:3], ham[1::3], ham[1:9:]
  ham[lower:upper], ham[lowser:pper:], ham[lower::step]
  ham[lower+offset : upper+offset]
  ham[: upper_fn(x) : setp_fn(x)], ham[:: setp_fn(x)]
  ham[lower + offset : upper + offset]
  ```

--------

- no:
  ```python
  spam (1)
  ```

- yes:
  ```python
  spam(1)
  ```

--------

- no:
  ```python
  dct ['key'] = lst [index]
  ```

- yes:
  ```python
  dct['key'] = lst[index]
  ```

--------

- no:
  ```python
  x             = 1
  y             = 2
  long_variable = 3
  ```

- yes:
  ```python
  x = 1
  y = 2
  long_variable = 3
  ```

### other recommendations

- no:
  ```python
  i=i+1
  submitted +=1
  x = x * 2 - 1
  hypot2 = x * x + y * y
  c = (a + b) * (a - b)
  ```

- yes:
  ```python
  i = i + 1
  submitted += 1
  x = x*2 - 1
  hypot2 = x*x + y*y
  c = (a+b) * (a-b)
  ```

--------

- no:
  ```python
  def complex(real, imag = 0.0):
    return magic(r = real, i = imag)
  ```

- yes:
  ```python
  def complex(real, imag=0.0):
    return magic(r=real, i=imag)
  ```

--------

- no:
  ```python
  def munge(input:AnyStr): ...
  def munge()->PosInt: ...
  ```

- yes:
  ```python
  def munge(input: AnyStr): ...
  def munge() -> AnyStr: ...
  ```

--------

- no:
  ```python
  def munge(input: AnyStr=None): ...
  def munge(input: AnyStr, limit = 1000): ...
  ```

- yes:
  ```python
  def munge(sep: AnyStr = None): ...
  def munge(input: AnyStr, sep: AnyStr = None, limit=1000): ...
  ```

##### rather NO
```python
if foo == 'blah': do_blah_thing()
do_one(); do_two(); do_three()
```

- yes:
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

- yes:
  ```python
  if foo == 'blah': do_blah_thing()
  for x in lst: total += x
  while t < 10: t = delay()
  ```

### documentation strings

- yes:
  ```python
  """Return a foobang

  Optional plotz says to frobnicate the bizbaz first.
  """
  ```

### Programming Recommendations

- no:
  ```python
  if not foo is None:
  ```

- yes:
  ```python
  if foo is not None:
  ```

--------

- no:
  ```python
  f = lambda x: 2*x
  ```

- yes:
  ```python
  def f(x): return 2*x
  ```

--------

- no:
  ```python
  try:
    # Too broad!
    return handle_value(collection[key])
  expect KeyError:
    # Will also catch KeyError raised by handle_value()
    return key_not_found(key)
  ```

- yes:
  ```python
  try:
    value = collection[key]
  except KeyError:
    return key_not_found(key)
  else:
    return handle_value(value)
  ```

--------

- no:
  ```python
  with conn:
    do_stuff_in_transaction(conn)
  ```

- yes:
  ```python
  with conn.begin_transaction():
    do_stuff_in_transaction(conn)
  ```

--------

- no:
  ```python
  def foo(x):
    fi x >= 0:
      return math.sqrt(x)

  def bar(x):
    if x < 0:
      return
    return math.sqrt(x)
  ```

- yes:
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

- no:
  ```python
  if foo[:3] == 'bar':
  ```

- yes:
  ```python
  if foo.startwith('bar'):
  ```

--------

- no:
  ```python
  if type(obj) is type(1):
  ```

- yes:
  ```python
  if isinstance(obj, int):
  ```

--------

- no:
  ```python
  if len(seq):
  if not len(seq):
  ```

- yes:
  ```python
  if not seq:
  if seq:
  ```

--------

- no:
  ```python
  if greeting == True:
  ```

- yes:
  ```python
  if greeting:
  ```

- worse:
  ```python
  if greeting is True:
  ```

--------

## [PEP8 Error/Warning Code](http://pep8.readthedocs.io/en/release-1.7.x/intro.html#error-codes)
#### E1 Indentation
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

#### E2 Whitespace
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

#### E3 Blank line
* E301    expected 1 blank line, found 0
* E302    expected 2 blank lines, found 0
* E303    too many blank lines (3)
* E304    blank lines found after function decorator

#### E4 Import
* E401    multiple imports on one line
* E402    module level import not at top of file

#### E5 Line length
* E501 (^)    line too long (82 > 79 characters)
* E502    the backslash is redundant between brackets

#### E7 Statement
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

#### E9 Runtime
* E901    SyntaxError or IndentationError
* E902    IOError

#### W1 Indentation warning
* W191    indentation contains tabs

#### W2 Whitespace warning
* W291    trailing whitespace
* W292    no newline at end of file
* W293    blank line contains whitespace

#### W3 Blank line warning
* W391    blank line at end of file

#### W5 Line break warning
* W503    line break occurred before a binary operator

#### W6 Deprecation warning
* W601    .has_key() is deprecated, use ‘in’
* W602    deprecated form of raising exception
* W603    ‘<>’ is deprecated, use ‘!=’
* W604    backticks are deprecated, use ‘repr()’
