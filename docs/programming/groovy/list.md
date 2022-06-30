<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [filter a list](#filter-a-list)
- [filter in list via additional conditions](#filter-in-list-via-additional-conditions)
- [return result instead of original list](#return-result-instead-of-original-list)
- [a list contains a sublist or not](#a-list-contains-a-sublist-or-not)
- [pickup item in list random](#pickup-item-in-list-random)
- [replace item in list according reference Map](#replace-item-in-list-according-reference-map)
- [2D matrix conversion](#2d-matrix-conversion)
- [print 2D matrix](#print-2d-matrix)
- [multiply in list](#multiply-in-list)
- [sum the content of 2 list in groovy](#sum-the-content-of-2-list-in-groovy)
- [remove empty item in a list](#remove-empty-item-in-a-list)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


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

### a list contains a sublist or not
```groovy
List parent = [ '1', '2', '3', 'a', 'b' ]
List sub    = [ 'a', '3' ]
sub.every{ parent.contains(it) }
```

- or `containsAll`
  ```groovy
  List parent = [ '1', '2', '3', 'a', 'b' ]
  List sub    = [ 'a', '3' ]
  parent.containsAll(sub)
  ```

- ignore case
  ```groovy
  sub.every{ parent.collect{ it.toLowerCase() }.contains( it.toLowerCase() ) }
  ```

### [pickup item in list random](https://www.baeldung.com/java-random-list-element)
- `Collections.shuffle`
  ```groovy
  List list = [ '1', '2', '3', 'a', 'b' ]
  Collections.shuffle( list )
  println list
  println parent.first()

  // result
  // [2, b, 3, 1, a]
  // 2
  ```

- `Random().nextInt`
  ```groovy
  List list = [ '1', '2', '3', 'a', 'b' ]
  Random random = new Random()
  println list.get(random.nextInt(list.size()))
  println list.get(random.nextInt(list.size()))

  // result
  // 1
  // b
  ```

### [replace item in list according reference Map](https://stackoverflow.com/a/67818619/2940319)
```groovy
Map<String, String> reference = [
  '1' : 'apple'  ,
  '2' : 'banana' ,
  '3' : 'pears'  ,
  '4' : 'peach'
]

'I want 1 she wants 4'.tokenize(' ')
                      .collect { references.get(it) ?: it }
                      .join(' ')

// result: I want apple she wants peach
```

- or keeping the `String` format
  > reference for [`replaceAll("<regex>", "$0")`](https://stackoverflow.com/a/24397672/2940319)

  ```groovy
  'I like    1, she    likes    3.'
      .replaceAll("[^\\w]", "_\$0")
      .split('_')
      .collect {
          String c = it.trim()
          reference.get(c) ? it.replace(c, reference.get(c)) : it
       }
      .join()

  // result: I like    apple, she    likes    pears.
  ```

{% hint style='tip' %}
**remove all punctuation from a String** :
```groovy
'I like 1,_,--__,,___ she        liks 2,,...'
  .replaceAll("[^\\w\\s]|_", '')
  // .replaceAll("\\s+", ' ')         // structure space if necessary
===> I like 1 she        liks 2
// ===> I like 1 she liks 2
```
- or keep only comma (and merge more if mutiple comma)
  ```groovy
  'I like 1,----,,|\\/, she        liks 2,,...'
    .replaceAll("[^\\w\\s,]|_", '')
    .replaceAll(',+', ',')
  ===> I like 1, she        liks 2,
  ```
{% endhint %}

### 2D matrix conversion

{% hint style='tip' %}
**Objective** :
> rows and columns conversion in 2D matrix `Map<String, List<String>>`
>
> - original matrix:
> ```groovy
> [
>   'foo' : [ 'a', 'b', 'c', 'd' ] ,
>   'bar' : [ 'b', 'c', 'x', 'y' ] ,
>   'baz' : [ 'd', 'x', 'y', 'z' ]
> ]
> ```
>
> - after conversion:
> ```groovy
> [
>   'a' : [ 'foo' ]         ,
>   'b' : [ 'bar' , 'foo' ] ,
>   'c' : [ 'bar' , 'foo' ] ,
>   'd' : [ 'baz' , 'foo' ] ,
>   'x' : [ 'bar' , 'baz' ] ,
>   'y' : [ 'bar' , 'baz' ] ,
>   'z' : [ 'baz' ]
> ]
> ```

**Inspired from [sboardwell/matrix-based-auth.groovy](https://gist.github.com/sboardwell/f1e85536fc13b8e4c0d108726239c027#file-matrix-based-auth-groovy-L96)**
{% endhint %}

```groovy
Map<String, List<String>> after  = [:].withDefault { [].toSet() }
Map<String, List<String>> matrix = [
  'foo' : [ 'a', 'b', 'c', 'd' ] ,
  'bar' : [ 'b', 'c', 'x', 'y' ] ,
  'baz' : [ 'd', 'x', 'y', 'z' ]
]

Closure converter = { Map result, Map original ->
  original.each { k, v -> result[k] += v }
}

matrix.collect{ k, v -> v.collect{ [ (it) : k ] } }
      .flatten()
      .each converter.curry(after)
after
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



### multiply in list

{% hint style='tip' %}
> references:
> - [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product)
> - [Cartesian product of two or more lists](https://rosettacode.org/wiki/Cartesian_product_of_two_or_more_lists#Groovy)
> - [multiply lists](http://www.groovyconsole.appspot.com/script/209001)
{% endhint %}

#### [multiply in 2 lists](https://rosettacode.org/wiki/Cartesian_product_of_two_or_more_lists#Groovy)
```groovy
def multiply( List a, List b ) {
  assert [a,b].every { it != null }
  def ( m,n ) = [ a.size(),b.size() ]
  ( 0..<(m*n) ).inject([]) { prod, i -> prod << [ a[i.intdiv(n)], b[i%n] ].flatten() }
}
```

#### multiply in multiple lists
```groovy
def listsMultiply( List... lists ) {
  lists = lists.findAll()
  List result = lists[0]
  ( 1..lists.size()-1 ).collect {
    List y = lists[it]
    def ( m, n ) = [ result.size(), y.size() ]
    result = ( 0..<(m*n) ).inject([]) { prod, i -> prod << [ result[i.intdiv(n)], y[i%n] ].flatten() }
  }
  result
}
```

- output
  ```
  List a = [ 'a', 'b', 'c', 'd' ]
  List b = [ '1', '2' ]
  List c = [ 'x', 'y' ]
  List d = [ '9', '8' ]

  listsMultiply( a, b, c, d ).each { println "\t>> ${it}," }
  >> [a, 1, x, 9]
  >> [a, 1, x, 8]
  >> [a, 1, y, 9]
  >> [a, 1, y, 8]
  >> [a, 2, x, 9]
  >> [a, 2, x, 8]
  >> [a, 2, y, 9]
  >> [a, 2, y, 8]
  >> [b, 1, x, 9]
  >> [b, 1, x, 8]
  >> [b, 1, y, 9]
  >> [b, 1, y, 8]
  >> [b, 2, x, 9]
  >> [b, 2, x, 8]
  >> [b, 2, y, 9]
  >> [b, 2, y, 8]
  >> [c, 1, x, 9]
  >> [c, 1, x, 8]
  >> [c, 1, y, 9]
  >> [c, 1, y, 8]
  >> [c, 2, x, 9]
  >> [c, 2, x, 8]
  >> [c, 2, y, 9]
  >> [c, 2, y, 8]
  >> [d, 1, x, 9]
  >> [d, 1, x, 8]
  >> [d, 1, y, 9]
  >> [d, 1, y, 8]
  >> [d, 2, x, 9]
  >> [d, 2, x, 8]
  >> [d, 2, y, 9]
  >> [d, 2, y, 8]
  ```

- [or](http://www.groovyconsole.appspot.com/script/209001)
  ```groovy
  java.util.ArrayList.metaClass.multiply = { e ->
    def list = new ArrayList()
    delegate.each { aa ->
      e.each {
        list.add( aa + it )
      }
    }
    list
  }
  ```

  - result
    ```
    x = ["k1", "k2", "k3"]
    y = ["v1", "v2", "v3"]

    x * y
    [k1v1, k1v2, k1v3, k2v1, k2v2, k2v3, k3v1, k3v2, k3v3]
    ```

- or
  ```groovy
  java.util.ArrayList.metaClass.multiply = { e ->
    def list = new ArrayList()
    delegate.collect { aa ->
      e.each {
        list << [ aa, it ].flatten()
      }
    }
    list
  }
  ```
  - result
    ```
    ( d * b * c ).join('\n')
    [9, 1, x]
    [9, 1, y]
    [9, 2, x]
    [9, 2, y]
    [8, 1, x]
    [8, 1, y]
    [8, 2, x]
    [8, 2, y]
    ```

### sum the content of 2 list in groovy

{% hint style='tip' %}
> references:
> - [Sum the content of 2 list in Groovy](https://stackoverflow.com/questions/4584393/sum-the-content-of-2-list-in-groovy)
{% endhint %}

```groovy
List a = [ 'a', 'b', 'c', 'd' ]
List b = [ '1', '2' ]
[ a, b ].transpose()

// Result: [[a, 1], [b, 2]]
```


### remove empty item in a list

{% hint style='tip' %}
> public Collection findAll() finds the items matching the IDENTITY Closure (i.e. matching Groovy truth)

references:
- [Remove null items from a list in Groovy](https://stackoverflow.com/a/14663680/2940319)
{% endhint %}

```bash
groovy:000> [ null, 'a', 'b' ].findAll()
===> [a, b]
groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].findAll()
===> [[a, b], [1]]
```

- via `findResults{}`
  ```bash
  groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].findResults{it}
  ===> [[], [a, b], [1]]
  groovy:000> [ null, 'a', 'b' ].findResults{it}
  ===> [a, b]
  ```

- via [`grep()`](https://stackoverflow.com/a/27998063/2940319)
  ```bash
  groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].grep()
  ===> [[a, b], [1]]
  groovy:000> [ null, 'a', 'b' ].grep()
  ===> [a, b]
  ```
