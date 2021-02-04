<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [string](#string)
  - [substring](#substring)
- [`list`](#list)
  - [filter a list](#filter-a-list)
  - [filter in list via additional conditions](#filter-in-list-via-additional-conditions)
  - [return result instead of original list](#return-result-instead-of-original-list)
  - [print 2D matrix](#print-2d-matrix)
- [`Map`](#map)
  - [change Map in condition](#change-map-in-condition)
  - [filter via condition](#filter-via-condition)
  - [find a `string` in a nested `Map` by using recursive function](#find-a-string-in-a-nested-map-by-using-recursive-function)
  - [find a `string` exists in a `list` of `Map`](#find-a-string-exists-in-a-list-of-map)
- [elvis operator](#elvis-operator)
  - [if/elseif{if}/else](#ifelseififelse)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Groovy Cheatsheet](https://onecompiler.com/cheatsheets/groovy)
> - <kbd>[online compiler](https://onecompiler.com/groovy)</kbd>

## string
### [substring](http://grails.asia/groovy-substring)
- remove the last x chars
  ```groovy
  def removeSuffix( String str ) {
    removeSuffix( str, 1 )
  }

  /**
   * remove the last char of {@code str}
   * @param str       the string will be removal the last char
   * @param c         remove last {@code c} numbers chars
  **/
  def removeSuffix( String str, int c ) {
    str.reverse().drop(c).reverse()
  }
  ```

- [add char(s) in the end of string](https://dzone.com/articles/concatenate-strings-in-groovy)
  ```groovy
  str.concat('substr')
  ```

## `list`
### filter a list
```groovy
[ 'baz1', 'baz2', 'baz3', 'abz1', 'zba2', 'bza3' ].findAll { it.contains 'baz' }
===> [baz1, baz2, baz3]
```

- [or](https://stackoverflow.com/a/27058389/2940319)
  ```groovy
  [['r':3],['r':5],['r':6],['r':11],['r':10]].findAll { (1..10).contains(it.r) }
  ===> [[r:3], [r:5], [r:6], [r:10]]
  ```

### [filter in list via additional conditions](https://stackoverflow.com/a/19791838/2940319)
```groovy
[
  [ id : 1 , age : 1 , weight : 25 ] ,
  [ id : 2 , age : 2 , weight : 20 ] ,
  [ id : 3 , age : 3 , weight : 25 ]
].findAll {
   it.age in [ 2, 3 ] || it.weight in [ 20, 25 ]
}.id
===> [1,2,3]
```

### [return result instead of original list](https://stackoverflow.com/a/20973116/2940319)
```groovy
[1, 2, 3, 4].findResults { ( it % 2 == 0 ) ? it / 2 : null }
===> [1, 2] ~> [2/2, 4/2]
```
```groovy
[1, 2, 3, 4].findAll { ( it % 2 == 0 ) ? it / 2 : null }
===> [2, 4]
```

### print 2D matrix
```groovy
(1..255).collect { color ->
  " █${color}█ "
}.eachWithIndex{ c, idx ->
  print c
  if ( 4 == (idx+1)%6 ) { println '' }
}
```

## `Map`
### [change Map in condition](https://stackoverflow.com/a/20534222/2940319)
```groovy
[ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ "${it.key}" : 4 ] : it }
===> [a:1, b:4, c:4]
```
- or `[ it.key, 4 ]`
  ```groovy
  [ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ it.key, 4 ] : it }
  ```
- or `[ (it.key) : 4 ]`
  ```groovy
  [ 'a': 1, 'b': 2, 'c': 3 ].collectEntries { ( it.value > 1 ) ? [ (it.key) : 4 ] : it }
  ```

### filter via condition
```groovy
[ 'a': 1, 'b': 2, 'c': 3 ].findAll{ it.value > 1 }.collectEntries { [ it.key, 4 ] }
===> [b:4, c:4]
```

### find a `string` in a nested `Map` by using recursive function
```groovy
def hasValue( Map m, String value ) {
  m.containsValue(value) || m.values().find { v -> v instanceof Map && hasValue(v, value) }
}
```

- another version
  > inspired by [stackoverflow: How to search value by key from Map as well as Nested Map](https://stackoverflow.com/a/39749720/2940319)

```groovy
def hasValue( Map m, String value ) {
  if ( m.containsValue(value) ) return m.containsValue(value)
  m.findResult { k, v -> v instanceof Map ? hasValue(v, value) : null }
}
```

### find a `string` exists in a `list` of `Map`
```groovy
def isTargetExists( Map m, String subKey, String value ) {
  def map = m.findAll { it.value instanceof Map }.collect { it.key }
  return m.subMap(map).any { k, v -> v.get(subKey, []).contains(value) }
}

Map<String, Map<String, String>> matrix = [
  dev : [
    user: ['dev1', 'dev2', 'dev3'] ,
    passwd: '123456',
    customer: ['yahoo', 'bing']
  ] ,
  staging : [
    user: ['stg1', 'stg2', 'stg3'] ,
    passwd: 'abcdefg' ,
    customer: ['google', 'huawei']
  ] ,
  prod : [
    user: ['prod1', 'prod2', 'prod3'] ,
    passwd: 'a1b2c3d4'
  ]
]

assert isTargetExists( matrix, 'user', 'dev4' ) == false
assert isTargetExists( matrix, 'release', 'huawei' ) == true
```

## elvis operator
### if/elseif{if}/else
```groovy
// by using if/elseif{if}/else
Map option = [:]
if ( [ 'apple', 'orange' ].contains(fruits) ) {
  option = [ "${fruits}" : '5' ]
} else if ( [ 'watermelon' ].contains(fruits) ) {
  if (mode) {
    option = [ "${fruits}" : mode ]
  }
} else {
  println( 'basket CANNOT be empty while fruits is watermelon' )
}

// by using elvis operator
Map option = ( [ 'apple', 'orange' ].contains(fruits) ) ? [ "${fruits}" : '5' ]
           : ( [ 'watermelon' ].contains(fruits) ) ? ( mode )
              ? [ "${fruits}" : mode ]
              : println( 'basket CANNOT be empty while fruits is watermelon' )
           : null
```
