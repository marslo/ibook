<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [map withDefault](#map-withdefault)
- [get key or value from nested Map](#get-key-or-value-from-nested-map)
- [findResult & findResults](#findresult--findresults)
- [collect & collectMany](#collect--collectmany)
- [collectEntries](#collectentries)

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

  // Result: [1:[a], 2:[b, c]]
  ```

- alternatives
  ```groovy
  [a:1,b:2,c:2].groupBy{ it.value }.collectEntries{ k, v -> [(k): v.collect{ it.key }] }

  // Result: [1:[a], 2:[b, c]]
  ```

### get key or value from nested Map
> insprired from :
> - [How to find a map key by value of nested map in Groovy](https://stackoverflow.com/a/44829625/2940319)

{% hint style='tip' %}
Objective:
```bash
Map<String, Map<String, String>> m = [
  k1 : [k11 : 'v11'] ,
  k2 : [k21 : 'v21'] ,
  k3 : [k31 : 'v31']
]

   ⇣⇣

find'k11'
findKey( 'k11') » 'k1'
findValue( 'v31' ) » 'k3'
```
{% endhint %}

findKey:

```groovy
def findKey( Map map, String keyword ) {
  map.find { keyword in it.value.keySet() }?.key
}
```
findValue:
```groovy
def findValue( Map map, String keyword ) {
  map.find { keyword in it.value.values() }?.key
}
```

### findResult & findResults
> reference:
> - [FindResults and FindResult Methods of Groovy](https://www.tothenew.com/blog/findresults-and-findresult-methods-of-groovy/)
> - [find deep in nested map](https://stackoverflow.com/a/39749720/2940319)

- collect: return all result (with null)
  ```groovy
  groovy:000> [a: 1, b: 2, c: 3, d: 4].collect{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> [null, null, c->3, d->4]
  ```
- findResult: return the first eligible value (first non-null element)
  ```groovy
  groovy:000> [a: 1, b: 2, c: 3, d: 4].findResult{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> c->3
  ```

- findResults: find all eligible values (all non-null elements)
  ```groovy
  groovy:000> [a: 1, b: 2, c: 3, d: 4].findResults{ k, v -> v>2 ? (k + '->' + v) : null }
  ===> [c->3, d->4]
  ```

#### [find deep in nested map](https://stackoverflow.com/a/39749720/2940319)
{% hint style='tip' %}
Example Map structure:
```bash
Map m = [
  k1 : [
    k11 : [
      k111 : 'v111',
      k112 : 'v112'
    ]
  ] ,
  k2 : [
    k12 : [
      k121 : 'v121',
      k122 : 'v122'
    ]
  ] ,
  k3 : [k31 : 'v31']
]
```
{% endhint %}

```groovy
def hasValues(Map m, String key) {
  if (m.containsKey(key)) return m[key]
  m.findResult { k, v -> v instanceof Map ? hasValues(v, key) : null }
}
```
- result
  ```bash
  println """
    hasValues(m, 'k11')  : ${hasValues(m, 'k11')}
    hasValues(m, 'k112') : ${hasValues(m, 'k112')}
  """

  /**
   * output
   * hasValues(m, 'k11')  : [k111 : v111, k112 : v112]
   * hasValues(m, 'k112') : v112
   *
  **/
  ```

alternatives
```groovy
def hasValues(Map m, String key) {
  m.containsKey(key) || m.find { k, v -> v instanceof Map && hasValues(v, key) }
}
```

- result
  ```bash
  println """
    hasValues(m, 'k11')  : ${hasValues(m, 'k11')}
    hasValues(m, 'k112') : ${hasValues(m, 'k112')}
    hasValues(m, 'k115') : ${hasValues(m, 'k115')}
  """

  /**
   * output
   * hasValues(m, 'k11')  : true
   * hasValues(m, 'k112') : true
   * hasValues(m, 'k115') : false
   *
  **/
  ```

### collect & collectMany


### collectEntries
