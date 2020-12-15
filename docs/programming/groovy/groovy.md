<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`Map`](#map)
  - [find a `string` in a nested `Map` by using recursive function](#find-a-string-in-a-nested-map-by-using-recursive-function)
  - [find a `string` exists in a `list` of `Map`](#find-a-string-exists-in-a-list-of-map)
- [elvis operator](#elvis-operator)
  - [if/elseif{if}/else](#ifelseififelse)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [Groovy Cheatsheet](https://onecompiler.com/cheatsheets/groovy)
> - <kbd>[online compiler](https://onecompiler.com/groovy)</kbd>

## `Map`
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
     option = [  "${fruits}" : mode]
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
