
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
