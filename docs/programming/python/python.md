<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

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
  - [chain compare](#chain-compare)
  - [boolean](#boolean)
  - [reverse](#reverse)
  - [join in list](#join-in-list)
  - [sum & max & min & time](#sum--max--min--time)
  - [list comprehensions](#list-comprehensions)
  - [default dict](#default-dict)
  - [if...else...](#ifelse)
  - [ternary operator](#ternary-operator)
  - [dict & zip](#dict--zip)
- [hidden features](#hidden-features)
  - [numbers](#numbers)
  - [string](#string)
  - [args](#args)
  - [conditional assignment](#conditional-assignment)
  - [list & dics](#list--dics)
  - [generator & iteration](#generator--iteration)
  - [statement](#statement)
  - [funcs](#funcs)
  - [class & module](#class--module)
  - [Others](#others)
- [basic](#basic)
  - [version capability](#version-capability)
- [environment](#environment)
  - [list included modules](#list-included-modules)
  - [list lib paths](#list-lib-paths)
  - [list script path](#list-script-path)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## Pythonic

{% hint style='tip' %}
> inspired from
> - [what are same example of beautiful 'Pythonic' code?](https://www.quora.com/What-are-some-examples-of-beautiful-Pythonic-code)
> - [如何让你的Python代码更加pythonic?](http://www.pythontab.com/html/2015/pythonhexinbiancheng_1029/970.html)
> - [run python code online](https://reqbin.com/code/python)
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
    print(i, e)
  #0 1
  #1 2
  #2 3
  #3 4
  #4 5
  ```

- NP:
  ```python
  for i in xrange(len(array)):
    print(i, array[i])
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


### chain compare
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


### boolean
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

### reverse
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

### join in list
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

### sum & max & min & time
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

### list comprehensions
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

### default dict
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
      print('find 5')
      break
  else:
    print('can not find 5!')
  # can not find 5!
  ```

- NP:
  ```python
  find = False
  for x in xrange(1,5):
    if x == 5:
      find = True
      print('find 5')
      break
  if not find:
    print('can not find 5!')
  # can not find 5!
  ```

### ternary operator
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

> [!NOTE|label:references:]
> - [Hidden features of Python [closed]](https://stackoverflow.com/q/101268/2940319)

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
print(reduce(add, [1,2,3,4,5,6]))
```

### string
#### multi-line strings
```python
>>> sql = "select * from some_table \
where id > 10"
>>> print(sql)
select * from some_table where id > 10

# or
>>> sql = """select * from some_table
where id > 10"""
>>> print(sql)
select * from some_table where id > 10

# or
>>> sql = ("select * from some_table " # <-- no comma, whitespace at end
           "where id > 10 "
           "order by name")
>>> print(sql)
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

#### join
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

# or
>>> a[::-1]
[5,4,3,2,1]

# or
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
>>> print( repr(r"aaa\"bbb") )
'aaa\\"bbb'

# or
>>> print( repr(r"C:\") )
SyntaxError: EOL while scanning string literal
>>> print( repr(r"C:\"") )
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

# or
def foo(a, b, c):
  print ( a, b, c )

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

### conditional assignment
#### ternary operator
```python
>>> 'ham' if True else 'spam'
'ham'
>>> 'ham' if False else 'spam'
'spam'

# or
>>> True and 'ham' or 'spam'
'ham'
>>> False and 'ham' or 'spam'
'spam'

# or
>>> [] if True else 'spam'
[]
>>> True and [] or 'spam'
'spam'

# or
In [18]: a = True

In [19]: a and 3 or 4
Out[19]: 3

In [20]: a = False

In [21]: a and 3 or 4
Out[21]: 4

# or
>>> (1 and [foo()] or [bar()])[0]
foo
0

# or
>>> foo() if True or bar()
foo
0
```

#### conditional
```python
x = 3 if (y == 1) else 2

# or
x = 3 if (y == 1) else 2 if (y == -1) else 1

# or
(func1 if y == 1 else func2)(arg1, arg2)

# or
x = (class1 if y == 1 else class2)(arg1, arg2)

# or
[(x, y) for x in range(4) if x % 2 == 1 for y in range(4)]
[(1, 0), (1, 1), (1, 2), (1, 3), (3, 0), (3, 1), (3, 2), (3, 3)]

# or
x = 3 if (y == 1) else 2                is equivalent to                 x = y == 1 and 3 or 2
x = 0 if True else 1                    is equivalent to                 x = True and 0 or 1

# or
foo = [x for x in xrange(10) if x % 2 == 0]

# equal to
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

{% hint style='tip' %}
> [wiki](https://en.wikipedia.org/wiki/List_comprehension#Set_comprehension)
> [manual](https://docs.python.org/dev/reference/expressions.html?highlight=comprehensions#set-displays)
{% endhint %}

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

# or
>>> dict([ ('foo','bar'),('a',1),('b',2) ])
{'a': 1, 'b': 2, 'foo': 'bar'}

>>> names = ['Bob', 'Marie', 'Alice']
>>> ages = [23, 27, 36]
>>> dict(zip(names, ages))
{'Alice': 36, 'Bob': 23, 'Marie': 27}

# or
>>> t1 = (0,1,2,3)
>>> t2 = (7,6,5,4)
>>> [t1,t2] == zip(*zip(t1,t2))
True

# or
In [15]: t1 = (1, 2, 3)
In [16]: t2 = (4, 5, 6)
In [17]: dict (zip(t1,t2))
Out[17]: {1: 4, 2: 5, 3: 6}

# or
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

# or
((i,j) for i in range(4) for j in range(i) )
```

#### enumerate
```python
>>> a = ['a', 'b', 'c', 'd', 'e']
>>> for index, item in enumerate(a): print ( index, item )
...
0 a
1 b
2 c
3 d
4 e

# or
>>> l = ["spam", "ham", "eggs"]
>>> list(enumerate(l))
>>> [(0, "spam"), (1, "ham"), (2, "eggs")]
>>> list(enumerate(l, 1))
>>> [(1, "spam"), (2, "ham"), (3, "eggs")]
```

#### generate list
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

# or
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

# or
>>> n = ((a,b) for a in range(0,2) for b in range(4,6))
>>> for i in n:
...   print(i)

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

# or
def fab(max):
  a,b = 0,1
  while a < max:
    yield a
    a, b = b, a+b

>>> for i in fab(20):
...     print( i,",", )
...
0 , 1 , 1 , 2 , 3 , 5 , 8 , 13 ,

# or
>>> i = (1,2,3,4,5,6,7,8,9,10) # or any iterable object
>>> iterators = [iter(i)] * 2
>>> iterators[0].next()
1
>>> iterators[1].next()
2
>>> iterators[0].next()
3

# or
def grouper(n, iterable, fillvalue=None):
  "grouper(3, 'ABCDEFG', 'x') --> ABC DEF Gxx"
  args = [iter(iterable)] * n
  return izip_longest(fillvalue=fillvalue, *args)

# or
>>> from itertools import *
>>> l = [[1, 2], [3, 4]]
>>> list(chain(*l))
[1, 2, 3, 4]

# or
def create_printers(n):
  for i in xrange(n):
    def printer(i=i): # Doesn't work without the i=i
      print (i)
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

# or
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

#### `try...except...else...finally`
```python
try:
  put_4000000000_volts_through_it(parrot)
except Voom:
  print( "'E's pining!" )
else:
  print( "This parrot is no more!" )
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
...     print( "Got SystemExit!" )
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
 '/usr/local/lib/python1.5/tkinter'
]

# or
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
...     print( "This list should not be empty" )
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

# or
>>> class NewType(object):
>>>     x = "hello"
>>> n = NewType()
>>> n.x
"hello"
```

#### manipulating sys.modules
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

# or
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
...     print(x)
...
>>> foo()
[1]
>>> foo()
[1, 1]
>>> foo()
[1, 1, 1]

# or
>>> def foo(x=None):
...     if x is None:
...         x = []
...     x.append(1)
...     print(x)
>>> foo()
[1]
>>> foo()
[1]
```

## basic
### version capability

> [!NOTE|label:references:]
> - [Ubuntu releases](https://ubuntu.com/about/release-cycle)
> - NOTE: Python2.7 (all), Python 3.6 (bionic), Python 3.8 (focal), Python 3.10 (jammy) are not provided by deadsnakes as upstream ubuntu provides those packages.

|      -      | UBUNTU 18.04 ( BIONIC ) | UBUNTU 20.04 ( FOCAL ) | UBUNTU 22.04 ( JAMMY ) |
|:-----------:|:-----------------------:|:----------------------:|:----------------------:|
|  python 2.3 |            ✔            |                        |                        |
|  python 2.4 |            ✔            |                        |                        |
|  python 2.5 |            ✔            |                        |                        |
|  python 2.6 |            ✔            |                        |                        |
|  python 2.7 |            ✔            |                        |                        |
|  python 3.1 |            ✔            |                        |                        |
|  python 3.2 |            ✔            |                        |                        |
|  python 3.3 |            ✔            |                        |                        |
|  python 3.4 |            ✔            |                        |                        |
|  python 3.5 |            ✔            |            ✔           |                        |
|  python 3.6 |            ✔            |            ✔           |                        |
|  python 3.7 |            ✔            |            ✔           |            ✔           |
|  python 3.8 |            ✔            |            ✔           |            ✔           |
|  python 3.9 |            ✔            |            ✔           |            ✔           |
| python 3.10 |            ✔            |            ✔           |            ✔           |
| python 3.11 |            ✔            |            ✔           |            ✔           |
| python 3.12 |            ✔            |            ✔           |            ✔           |


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
$ python -c 'import sys; print( sys.path )'
['', '/usr/lib/python39.zip', '/usr/lib/python3.8', '/usr/lib/python3.8/lib-dynload', '/usr/local/lib/python3.8/dist-packages', '/usr/lib/python3/dist-packages']
```

### list script path
```bash
$ python3 -c "import sysconfig; print(sysconfig.get_path('scripts'))"
/opt/homebrew/bin
```
