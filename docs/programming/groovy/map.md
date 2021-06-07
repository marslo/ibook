<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [merge two maps](#merge-two-maps)
- [map withDefault](#map-withdefault)
- [get key or value from nested Map](#get-key-or-value-from-nested-map)
- [findResult & findResults](#findresult--findresults)
- [collect & collectMany](#collect--collectmany)
- [collectEntries](#collectentries)
- [grep](#grep)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> refenrece:
> - [Groovy Cookbook](https://e.printstacktrace.blog/groovy-cookbook/)
> - [Groovy Cookbook: How to merge two maps in Groovy?](https://e.printstacktrace.blog/how-to-merge-two-maps-in-groovy/)
{% endhint %}

### merge two maps
#### for `<String, List<String>>`
```groovy
Closure merger = { Map newMap, Map currentMap ->
  currentMap.inject(newMap.clone()) { merged, entry ->
    merged[entry.key] = merged.getOrDefault( entry.key, [] ) + entry.value
    merged
  }
}
```

#### [for `<String, Map<String, List<String>>>`](https://stackoverflow.com/a/38542819/2940319)
```groovy
def m1 = [ k1: [ l1: ['s1', 's2']]]
def m2 = [ k1: [ l1: ['s3', 's4']], k2: [ l2: ['x1', 'x2']] ]
def accumulator = [:].withDefault{ [:].withDefault{ [] } }
Closure merger

merger = { Map trg, Map m ->
  m.each{ k, v ->
    switch( v instanceof java.util.LinkedHashMap ){
      case true  : merger trg[ k ], v ; break ;
      case false : trg[ k ].addAll v  ; break ;
    }
  }
}
[ m1, m2 ].each merger.curry( accumulator )
assert accumulator == [k1:[l1:['s1', 's2', 's3', 's4']], k2:[l2:['x1', 'x2']]]
```

#### [merge and sum](https://stackoverflow.com/a/62804996/2940319)
{% hint style='tip' %}
> preconditions:
> ```groovy
> Map<String, Integer> m1 = [ a : 10, b : 2, c : 3 ]
> Map<String, Integer> m2 = [ b : 3,  c : 2, d : 5 ]
> List<Map<String, Integer>> maps = [ m1, m2 ]
> ```

{% endhint %}
- merge values into list
  ```groovy
  maps.sum { it.keySet() }.collectEntries { key ->
    [key, maps.findResults { it[key] } ]
  }

  // result
  // [a:[10], b:[2, 3], c:[3, 2], d:[5]]
  ```
- sum lists
  ```groovy
  def process( List maps ) {
    maps.sum { it.keySet() }.collectEntries { key ->
      [ key, maps.findResults { it[key] }.sum() ]
    }
  }
  ```

  or more elegant way via `Clousre`:
  {% hint style='tip' %}
  > ```groovy
  > Closure getSum = { x -> x.sum() }
  > getSum( [1,2,3,4] ) == 10
  > ```
  {% endhint %}

  ```groovy
  def process( List maps ) {
    Closure getSum = { x -> x.sum() }
    maps.sum { it.keySet() }.collectEntries { key ->
      [ key, getSum(maps.findResults { it[key] }) ]
    }
  }
  ```

  which can be extended to:
  ```groovy
  def process( List maps, Closure closure ) {
    maps.sum { it.keySet() }.collectEntries { key ->
      [ key, closure(maps.findResults { it[key] }) ]
    }
  }

  // merge maps and get sum
  process(maps){ x -> x.sum() }                           // [a:10, b:5, c:5, d:5]
  // merge maps and get product
  process(maps){ x -> x.inject(1) { sum, n -> sum * n }   // [a:10, b:6, c:6, d:5]
  // merge maps and get the biggest item
  process(maps){ x -> x.inject(x[0]) { biggest, n -> biggest > n ? biggest : n } } // [a:10, b:3, c:3, d:5]
  ```

### map withDefault
{% hint style='tip' %}
Objective:
```bash
[a:1,b:2,c:2]

    ⇣⇣

[1:['a'], 2:['b','c']]
```
{% endhint %}

```groovy
def newMap = [:].withDefault { [] }
[a:1,b:2,c:2].each { key, val ->
  newMap[val] << key
}
assert newMap == [1:['a'], 2:['b','c']]
```

- alternative
  ```groovy
  [a:1, b:2, c:2].inject([:].withDefault{[]}) { map, k, v ->
    map[v] << k
    map
  }

  /* Result: [1:[a], 2:[b, c]] */
  ```

- alternatives
  ```groovy
  [a:1,b:2,c:2].groupBy{ it.value }.collectEntries{ k, v -> [(k): v.collect{ it.key }] }

  /* Result: [1:[a], 2:[b, c]] */
  ```

#### [merge maps](https://www.reddit.com/r/groovy/comments/htx1d9/how_to_merge_two_maps_in_groovy/fyk4xdg?utm_source=share&utm_medium=web2x&context=3)
```groovy
Map map1 = [x: 1, y: 2]
Map map2 = [z: 3]
Map merged = map1.withDefault(map2.&get)
assert map1 == merged           // quit interesting
assert 3 == merged.get('z')
```

### get key or value from nested Map
> insprired from :
> - [How to find a map key by value of nested map in Groovy](https://stackoverflow.com/a/44829625/2940319)

{% hint style='tip' %}
Objective:
```bash
Map<String, Map<String, String>> map = [
  k1 : [k11 : 'v11'] ,
  k2 : [k11 : 'v21'] ,
  k3 : [k11 : 'v31']
]

   ⇣⇣

findKeyBelongsTo( 'k11' )    »  'k1'
findValueBelongsTo( 'v31' )  »  'k3'
```
{% endhint %}

find parent key via sub-key:
> <kbd>[try online](https://onecompiler.com/groovy/3wfvvc3p8)</kbd>

```groovy
def findKeyBelongsTo( Map map, String keyword ) {
  map.find { keyword in it.value.keySet() }?.key
}
```

- find in nested map recursively (according to key):
  ```groovy
  def findKeyBelongsTo( Map map, String keyword ) {
    map.findResult { k, v ->
      v instanceof Map
        ? v.containsKey(keyword) ? k : findKeyBelongsTo( v, keyword )
        : null
    }
  }
  ```

find parent key via sub-value:
> <kbd>[try online](https://onecompiler.com/groovy/3wfvvjcnc)</kbd>

```groovy
def findValueBelongsTo( Map map, String keyword ) {
  map.find { keyword in it.value.values() }?.key
}
```

- find in nested map recursively (according to value):
  ```groovy
  def findValueBelongsTo( Map map, String keyword ) {
    map.findResult { k, v ->
      v instanceof Map
        ? v.containsValue(keyword) ? k : findValueBelongsTo( v, keyword )
        : null
    }
  }
  ```

### findResult & findResults
> reference:
> - [FindResults and FindResult Methods of Groovy](https://www.tothenew.com/blog/findresults-and-findresult-methods-of-groovy/)
> - [find deep in nested map](https://stackoverflow.com/a/39749720/2940319)

- collect: return all result (with null)
  ```bash
  groovy:000> [a: 1, b: 2, c: 3, d: 4].collect{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> [null, null, c->3, d->4]
  ```
- findResult: return the first eligible value (first non-null element)
  ```bash
  groovy:000> [a: 1, b: 2, c: 3, d: 4].findResult{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> c->3
  ```

- findResults: find all eligible values (all non-null elements)
  ```bash
  groovy:000> [a: 1, b: 2, c: 3, d: 4].findResults{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> [c->3, d->4]
  ```

#### [find deep in nested map](https://stackoverflow.com/a/39749720/2940319)
{% hint style='tip' %}
Example Map structure:
```groovy
Map map = [
  'a': [
    'b': [
      'c': [
        'd' : '1',
        'e' : '2',
        'f' : '3'
      ], // c
      'g': '4',
      'h': [
        'i': '5',
        'j': '6',
        'k': '7'
      ] // h
    ], // b
    'l': [
      'm': '8',
      'n': '9'
    ], // l
    'o': '10'
  ] // a
]
```
{% endhint %}

find value via key name recursively
> <kbd>[try online](https://onecompiler.com/groovy/3wfvvnjbq)</kbd>

```groovy
def findValues( Map map, String keyword ) {
  map.findResult { k, v ->
    v instanceof Map
      ? v.containsKey(keyword) ? v.getOrDefault(keyword, null) : findValues( v, keyword )
      : null
  }
}
```

alternatives
```groovy
def findValues( Map map, String keyword ) {
  if( map.containsKey(keyword) ) return map.getOrDefault( keyword, null )
  map.findResult { k, v -> v instanceof Map ? findValues(v, keyword) : null }
}
```

- result
  ```groovy
  println "~~> findValues( map, 'f' )    : ${findValues( map, 'f' )} "
  println "~~> findValues( map, 'o' )    : ${findValues( map, 'o' )} "
  println "~~> findValues( map, 'aaaa' ) : ${findValues( map, 'aaaa' )} "

  /**
   * console output
   * ~~> findValues( m, 'f' )    : 3
   * ~~> findValues( m, 'o' )    : 10
   * ~~> findValues( m, 'aaaa' ) : null
  **/
  ```

- alternatives
  > <kbd>[try online](https://onecompiler.com/groovy/3wfvvv42h)</kbd>

  ```groovy
  def hasValues(Map m, String key) {
    m.containsKey(key) || m.find { k, v -> v instanceof Map && hasValues(v, key) }
  }
  ```

  - result
    ```groovy
    println "~~> hasValues( map, 'f' )    : ${hasValues( map, 'f' )} "
    println "~~> hasValues( map, 'o' )    : ${hasValues( map, 'o' )} "
    println "~~> hasValues( map, 'aaaa' ) : ${hasValues( map, 'aaaa' )} "

    /**
     * console output
     * ~~> hasValues( m, 'f' )    : true
     * ~~> hasValues( m, 'o' )    : true
     * ~~> hasValues( m, 'aaaa' ) : false
    **/
    ```

### collect & collectMany

### collectEntries

### grep
> references:
> - [Groovy Goodness: the Grep Method](https://blog.mrhaki.com/2009/08/groovy-goodness-grep-method.html)
> - [Is there any difference between Groovy's non-argument grep() and findAll() methods?](https://stackoverflow.com/a/10717598/2940319)

```groovy
['test', 12, 20, true].grep(String)
```

- alternatives
  ```groovy
  ['test', 12, 20, true].findAll { it.class.simpleName == 'String' }

  // or
  ['test', 12, 20, true].findAll { it instanceof String }
  ```
