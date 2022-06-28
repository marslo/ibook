<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [multiply in list](#multiply-in-list)
- [sum the content of 2 list in groovy](#sum-the-content-of-2-list-in-groovy)
- [remove empty item in a list](#remove-empty-item-in-a-list)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



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
