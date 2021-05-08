<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [map withDefault](#map-withdefault)
- [get key or value from nested Map](#get-key-or-value-from-nested-map)
- [findResult & findResults](#findresult--findresults)
- [collect & collectMany](#collect--collectmany)
- [collectEntries](#collectentries)
- [grep](#grep)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


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

find top key via sub-key:
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

find top key via sub-value:
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

