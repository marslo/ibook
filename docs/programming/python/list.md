<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [list copy](#list-copy)
- [reverse list](#reverse-list)
- [cast format (str -> int)](#cast-format-str---int)
- [zip two lists](#zip-two-lists)
- [list mathematical](#list-mathematical)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### list copy
> inspired by [How to clone or copy a list?](https://stackoverflow.com/a/2612815/2940319) in stackoverflow

```python
clone_list = sample_list.copy()
```

- or
  ```python
  clone_list = sample_list[:]
  ```
- or
  ```python
  clone_list = list(sample_list)
  ```
- or
  ```python
  import copy
  clone_list = copy.copy(sample_list)
  ```
- or
  ```python
  import copy
  clone_list = copy.deepcopy(sample_list)
  ```

- example:
  ```python
  >>> id(x)
  4505979072
  >>> k = x
  >>> id(k)
  4505979072

  >>> k = x.copy()
  >>> id(k)
  4445208000
  >>> k = x[:]
  >>> id(k)
  4505977632
  >>> import copy
  >>> k = copy.copy(x)
  >>> id(k)
  4505754352
  >>> k = copy.deepcopy(x)
  >>> id(k)
  4505978352
  >>> k = x[:]
  >>> id(k)
  4506260896
  >>> k = copy.deepcopy(x)
  >>> id(k)
  4506261136
  ```

### reverse list
```python
sample_list[::-1]
```
- example:
  ```python
  >>> ['1', '2', '3', '4', '5'][::-1]
  ['5', '4', '3', '2', '1']
  ```

### cast format (str -> int)
```python
list( map(int, sample_list) )
```

- example:
  ```python
  >>> print( list( map(int, ['2', '8', '4', '127', 'HKD'][:3][::-1] ) ) )
  [4, 8, 2]
  ```

### zip two lists
```python
>> from itertools import zip_longest
>>> x = ['1', '2', '3', '4']
>>> y = ['one', 'two', 'three', 'four']
>>> for i, j in zip_longest( x, y ):
  print(i, j)

1 one
2 two
3 three
4 four
```

- or zip to a map
  ```python
  >>> x = ['1', '2', '3', '4']
  >>> y = ['one', 'two', 'three', 'four']
  >>> print( {key: value for key, value in zip_longest(x, y)} )
  {'1': 'one', '2': 'two', '3': 'three', '4': 'four'}
  ```

### list mathematical
- sum
  ```python
  >>> n = ['1', '2', '3', '4']
  >>> print( sum( list( map(int, n) ) ) )
  10
  ```

- multiplication
  ```python
  ```
