<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [init](#init)
- [sublists](#sublists)
  - [a list contains a sublist or not](#a-list-contains-a-sublist-or-not)
  - [grep](#grep)
  - [intersect & disjoint](#intersect--disjoint)
  - [split and keep the delimiters](#split-and-keep-the-delimiters)
- [filter](#filter)
  - [`findAll`](#findall)
  - [filter in list via additional conditions](#filter-in-list-via-additional-conditions)
  - [return result instead of original list via `findResults`](#return-result-instead-of-original-list-via-findresults)
  - [pickup item in list random](#pickup-item-in-list-random)
- [multilist](#multilist)
  - [multiply in list](#multiply-in-list)
  - [multiply in 2 lists](#multiply-in-2-lists)
  - [multiply in multiple lists](#multiply-in-multiple-lists)
- [orders](#orders)
  - [`sort`](#sort)
  - [sort with descending order](#sort-with-descending-order)
  - [`swap`](#swap)
- [conversion or restruction](#conversion-or-restruction)
  - [`toSpreadMap` to Map](#tospreadmap-to-map)
  - [`collate` to nested List](#collate-to-nested-list)
  - [zip 2 lists](#zip-2-lists)
  - [sum the content of 2 list in groovy](#sum-the-content-of-2-list-in-groovy)
  - [remove empty item in a list](#remove-empty-item-in-a-list)
  - [replace item in list according reference Map](#replace-item-in-list-according-reference-map)
  - [2D matrix conversions](#2d-matrix-conversions)
- [show](#show)
  - [print 2D matrix](#print-2d-matrix)
  - [`indexed`](#indexed)
  - [show 2D list in alignment](#show-2d-list-in-alignment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> references:
> - [Groovy List Processing Cheat Sheet](https://blogs.apache.org/groovy/entry/groovy-list-processing-cheat-sheet)
{% endhint %}

## init
```groovy
println( (1..10).collect() )
// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

println( ('a'..'z').collect() )
// [a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z]
```

## sublists

> [!NOTE]
> references:
> - [java.util.List](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/util/List.html#transpose%28%29)
> - [Groovy Goodness: the Grep Method](https://blog.mrhaki.com/2009/08/groovy-goodness-grep-method.html)

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

### grep
```groovy
assert [ true        ] == [ 'test', 12, 20, true ].grep( Boolean )            // Class isInstance
assert [ 'Groovy'    ] == [ 'test', 'Groovy', 'Java' ].grep( ~/^G.*/ )        // Pattern match
assert [ 'b', 'c'    ] == [ 'a', 'b', 'c', 'd' ].grep([ 'b', 'c' ])           // List contains
assert [ 15, 16, 12  ] == [ 1, 15, 16, 30, 12 ].grep( 12..18 )                // Range contains
assert [ 42.031      ] == [ 12.300, 109.20, 42.031, 42.032 ].grep( 42.031 )   // Object equals
assert [ 100, 200    ] == [ 10, 20, 30, 50, 100, 200 ].grep({ it > 50 })      // Closure boolean
assert [ 1, 'a', 'd' ] == [ [], 1, '', 'a', [:], 'b' ].grep()                 // No Null
```

### intersect & disjoint

> [!NOTE]
> references:
> - [Groovy Goodness: intersect collections](https://blog.mrhaki.com/2010/03/groovy-goodness-intersect-collections.html)

```groovy
List l1 = [ 'a', 'b', 'c' ]
List l2 = [ 'b', 'c', 'd' ]
List l3 = [ '1', '2', 'd' ]

assert [ 'b', 'c' ] == l1.intersect(l2)
assert ! l1.disjoint(l2)
assert l1.disjoint(l3)
```

### [split and keep the delimiters](https://stackoverflow.com/a/2206432/2940319)
```groovy
assert 'x.y.z'.split( "(?<=\\.)" )           == [ 'x.', 'y.', 'z' ]
assert 'x.y.z'.split( "(?=\\.)" )            == [ 'x', '.y', '.z' ]
assert 'x.y.z'.split( "((?<=\\.)|(?=\\.))" ) == [ 'x', '.', 'y', '.', 'z' ]
```

## filter
### `findAll`
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

### [return result instead of original list](https://stackoverflow.com/a/20973116/2940319) via `findResults`
```groovy
[1, 2, 3, 4].findResults { ( it % 2 == 0 ) ? it / 2 : null }
===> [1, 2] ~> [2/2, 4/2]

// and
[1, 2, 3, 4].findAll { ( it % 2 == 0 ) ? it / 2 : null }
===> [2, 4]
```

### [pickup item in list random](https://www.baeldung.com/java-random-list-element)
#### `Collections.shuffle`
```groovy
List list = [ '1', '2', '3', 'a', 'b' ]
Collections.shuffle( list )
println list
println parent.first()

// result
// [2, b, 3, 1, a]
// 2
```

#### `Random().nextInt`
```groovy
List list = [ '1', '2', '3', 'a', 'b' ]
Random random = new Random()
println list.get( random.nextInt(list.size()) )
println list.get( random.nextInt(list.size()) )

// result
// 1
// b
```

## multilist
### multiply in list

{% hint style='tip' %}
> references:
> - [Cartesian product](https://en.wikipedia.org/wiki/Cartesian_product)
> - [Cartesian product of two or more lists](https://rosettacode.org/wiki/Cartesian_product_of_two_or_more_lists#Groovy)
> - [multiply lists](http://www.groovyconsole.appspot.com/script/209001)
{% endhint %}

### [multiply in 2 lists](https://rosettacode.org/wiki/Cartesian_product_of_two_or_more_lists#Groovy)
```groovy
def multiply( List a, List b ) {
  assert [a,b].every { it != null }
  def ( m,n ) = [ a.size(),b.size() ]
  ( 0..<(m*n) ).inject([]) { prod, i -> prod << [ a[i.intdiv(n)], b[i%n] ].flatten() }
}
```

- or [list.combinations()](https://stackoverflow.com/a/71528095/2940319)
  ```groovy
  [ [ 'a', 'b' ], [ '1', '2' ] ].combinations()
  // [['a', '1'], ['b', '1'], ['a', '2'], ['b', '2']]
  ```

### multiply in multiple lists
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
      e.each { list.add( aa + it ) }
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

## orders
### `sort`
```groovy
[ '3', '1', '2' ].sort()
// [ '1', '2', '3' ]
```

### sort with descending order

> [!NOTE]
> references:
> - [sorting map values in descending order with groovy](https://stackoverflow.com/a/25676601/2940319)

```groovy
[ 'a', 'b', 'c' ].reverse().indexed(1).sort{ - it.key }.collect{ "${it.key} : ${it.value}" }.join('\n')
// 3 : a
// 2 : b
// 1 : c

# or via comapreTo ( <=> )
[ 'a', 'b', 'c' ].reverse().indexed(1).sort{ a, b -> b.key.compareTo(a.key) }.collect{ "${it.key} : ${it.value}" }.join('\n')
// 3 : a
// 2 : b
// 1 : c

# or via getAt( -1..0 )
[ 'a', 'b', 'c' ].reverse().indexed(1).collect{ "${it.key} : ${it.value}" }.getAt( -1..0 ).join('\n')
// 3 : a
// 2 : b
// 1 : c

# or via reverseEach
[ 'a', 'b', 'c' ].reverseEach{ println it }
```

### `swap`
```groovy
List l = [ '1', '2', '3' ]
assert [ '3', '1', '2' ] == l.swap(2, 1).swap(1, 0)
```

## conversion or restruction

> [!NOTE|label:references:]
> - [Class groovy.util.GroovyCollections](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html)
>   - [combinations()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#combinations%28.java.lang.Iterable%29)
>   - [transpose()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#transpose%28.java.util.List%29)
>   - [sum()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#sum%28.java.lang.Iterable%29)
>   - [max()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#max%28.java.lang.Iterable%29)
>   - [min()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#min%28.java.lang.Iterable%29)
>   - [union()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#union(groovy.lang.Closure,java.lang.Iterable...%29)
>   - [subsequences()](https://docs.groovy-lang.org/latest/html/api/groovy/util/GroovyCollections.html#subsequences%28.java.util.List%29)

### `toSpreadMap` to Map
```groovy
[ 'a', 'b', 'c', 'd' ].toSpreadMap()
// ['a':'b', 'c':'d']
```

### `collate` to nested List
```groovy
[ 'a', 'b', 'c', 'd' ].collate(2)
// [['a', 'b'], ['c', 'd']]
```

### zip 2 lists

> [!NOTE]
> references:
> - [list.transpose()](http://docs.groovy-lang.org/latest/html/groovy-jdk/java/util/List.html#transpose%28%29)
> - [List.transpose() works like zip](https://stackoverflow.com/a/4586700/2940319)

```groovy
// expectation :
// [ 'a', 'b' ] ╮  [ 'a', '1' ]
//              ├
// [ '1', '2' ] ╯  [ 'b', '2' ]

assert [ ['a', '1'], ['b', '2'] ] == [ [ 'a', 'b' ], [ '1', '2' ] ].transpose()
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

#### `findAll()`
```bash
groovy:000> [ null, 'a', 'b' ].findAll()
===> [a, b]
groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].findAll()
===> [[a, b], [1]]
```

#### `findResults{}`
```bash
groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].findResults{it}
===> [[], [a, b], [1]]
groovy:000> [ null, 'a', 'b' ].findResults{it}
===> [a, b]
```

#### [`grep()`](https://stackoverflow.com/a/27998063/2940319)
```bash
groovy:000> [ [], [ 'a', 'b' ], [ '1' ] ].grep()
===> [[a, b], [1]]
groovy:000> [ null, 'a', 'b' ].grep()
===> [a, b]
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
          reference.get(c) ? it.replace( c, reference.get(c) ) : it
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

### 2D matrix conversions

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
>
> ** inspired from [sboardwell/matrix-based-auth.groovy](https://gist.github.com/sboardwell/f1e85536fc13b8e4c0d108726239c027#file-matrix-based-auth-groovy-L96)**
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

## show
### print 2D matrix
```groovy
(1..255).collect { color -> " █${String.format("%03d", color)}█ " }
        .eachWithIndex{ c, idx ->
          print c
          if ( 4 == (idx+1)%6 ) { println '' }
        }
```

### `indexed`

> [!NOTE]
> references:
> - [Groovy Goodness: Combine Elements Iterable with Index](https://blog.mrhaki.com/2015/03/groovy-goodness-combine-elements.html)
>
> summarize:
> - `list.withIndex()` : `List<List<Object, int>>`
> - `list.indexed()` : `Map<int, Object>`

```groovy
[ 'a', 'b', 'c', 'd' ].indexed()
// [0:'a', 1:'b', 2:'c', 3:'d']

[ 'a', 'b', 'c', 'd' ].indexed(1)
// [1:'a', 2:'b', 3:'c', 4:'d']

[3, 20, 10, 2, 1].withIndex()
// [[3, 0], [20, 1], [10, 2], [2, 3], [1, 4]]

('a'..'d').withIndex(1)
// [['a', 1], ['b', 2], ['c', 3], ['d', 4]]
```

### show 2D list in alignment

```groovy
List<List<String>> list = [
  [ 'aaaaaaaaaaa', 'bbbbbbbbbbbbbbbbb', 'cccccccccccccccccccccc' ],
  [ '1111', '2222222222', '3333333333' ]
]

list.add( 0, list.transpose().collect { column -> column.collect{ it.size() }.max() } )
println list.withIndex().collect { raw, idx ->
  if ( idx ) {
    raw.withIndex().collect { x, y -> "${x.padRight(list[0][y])}" }.join(' | ')
  }
}.findAll().join('\n')

// -- result --
// aaaaaaaaaaa | bbbbbbbbbbbbbbbbb | cccccccccccccccccccccc
// 1111        | 2222222222        | 3333333333
```

- or with table format
  ```groovy
  List<String> title      = [ 'AGENT NAME', 'NODE CREDENTIAL', 'COMPUTER CREDENTIIAL' ]
  List<List<String>> list = [
    [ 'aaaaaaaaaaa', 'bbbbbbbbbbbbbbbbb', 'cccccccccccccccccccccc' ],
    [ '1111', '2222222222', '3333333333' ]
  ]

  list.add( 0, title )
  list.add( 0, list.transpose().collect { column -> column.collect{ it.size() }.max() } )

  println list.withIndex().collect { raw, idx ->
    if ( idx ) {
      '| ' + raw.withIndex().collect { x, y -> x.toString().padRight(list[0][y]) }.join(' | ') + ' |'
    }
  }.findAll().join( '\n' )

  // -- result --
  // | AGENT NAME  | NODE CREDENTIAL   | COMPUTER CREDENTIIAL   |
  // | aaaaaaaaaaa | bbbbbbbbbbbbbbbbb | cccccccccccccccccccccc |
  // | 1111        | 2222222222        | 3333333333             |
  ```

- or
  ```groovy
  List<String> title      = [ 'AGENT NAME', 'NODE CREDENTIAL', 'COMPUTER CREDENTIIAL' ]
  List<List<String>> list = [
    [ 'aaaaaaaaaaa', 'bbbbbbbbbbbbbbbbb', 'cccccccccccccccccccccc' ],
    [ '1111', '2222222222', '3333333333' ]
  ]

  list.add( 0, title )
  list.add( 0, list.transpose().collect { column -> column.collect{ it.size() }.max() } )
  list = list.withIndex().collect { raw, idx ->
    if ( idx ) raw.withIndex().collect { x, y -> x.toString().padRight(list[0][y]) }
  }.findAll()

  String showTable ( List l ) {
    l.collect{ '| ' +  it.join(' | ' ) + ' |' }.join('\n')
  }

  println showTable( [ list.head(), list.head().collect { '-'*it.size() } ] )
  println showTable( list.tail() )

  // -- result --
  // | AGENT NAME  | NODE CREDENTIAL   | COMPUTER CREDENTIIAL   |
  // | ----------- | ----------------- | ---------------------- |
  // | aaaaaaaaaaa | bbbbbbbbbbbbbbbbb | cccccccccccccccccccccc |
  // | 1111        | 2222222222        | 3333333333             |
  ```
