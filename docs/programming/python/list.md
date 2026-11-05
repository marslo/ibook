<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [list](#list)
  - [list copy](#list-copy)
  - [reverse list](#reverse-list)
  - [cast format (str -> int)](#cast-format-str---int)
  - [zip two lists](#zip-two-lists)
  - [list mathematical](#list-mathematical)
- [list initialization](#list-initialization)
  - [range](#range)
  - [string](#string)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## list
### list copy
> inspired by [How to clone or copy a list?](https://stackoverflow.com/a/2612815/2940319) in stackoverflow

```python
clone_list = sample_list.copy()
# or
clone_list = sample_list[:]
# or
clone_list = list(sample_list)
# or
import copy
clone_list = copy.copy(sample_list)
# or
import copy
clone_list = copy.deepcopy(sample_list)

# ───── example ─────
print( id(x) )
# 4505979072
k = x; print( id(k) )
# 4505979072

k = x.copy(); print( id(k) )
# 4445208000

k = x[:]; print( id(k) )
# 4505977632

import copy
k = copy.copy(x); print( id(k) )
# 4505754352
k = copy.deepcopy(x); print( id(k) )
# 4505978352
```

### reverse list
```python
sample_list[::-1]

# example
['1', '2', '3', '4', '5'][::-1]
# ['5', '4', '3', '2', '1']
```

### cast format (str -> int)
```python
list( map(int, sample_list) )

# example
print( list( map(int, ['2', '8', '4', '127', 'HKD'][:3][::-1] ) ) )
# [4, 8, 2]
```

### zip two lists
```python
>> from itertools import zip_longest
x = ['1', '2', '3', '4']
y = ['one', 'two', 'three', 'four']
for i, j in zip_longest( x, y ):
  print( i, j )
# 1 one
# 2 two
# 3 three
# 4 four
```

```python
# or zip to a map
x = ['1', '2', '3', '4']
y = ['one', 'two', 'three', 'four']
print({ k: v for k, v in zip_longest(x, y) })
# {'1': 'one', '2': 'two', '3': 'three', '4': 'four'}
```

### list mathematical
```python
# sum
n = ['1', '2', '3', '4']
print( sum( list( map(int, n) ) ) )
# 10

# or
n = ['1', '2', '3', '4']
print( sum( int(i) for i in n ) )
# 10

# or even robust
sum([ int(i) for i in n if i.isdigit() ])
# 10
```

## list initialization

### range
```python
# a-z
[ chr(i) for i in range( ord('a'), ord('z') + 1 ) ]
# ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

# 0-9
list( range(0,9+1) )
# [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

### string

```python
# a-z
list( string.ascii_lowercase )
# ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z']

# A-Z
list( string.ascii_uppercase )
# ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

# a-zA-Z
list( string.ascii_letters )
# ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

# 0-9
list( string.digits )
# ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

# 0-9A-F (hex)
list( string.hexdigits )
# ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f', 'A', 'B', 'C', 'D', 'E', 'F']
```
