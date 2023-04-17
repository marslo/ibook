<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Closure VS. Method](#closure-vs-method)
- [break from closure](#break-from-closure)
- [curry](#curry)
- [Memoization](#memoization)
- [composition](#composition)
- [Methods](#methods)
- [delegate](#delegate)
- [tricky](#tricky)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




> [!NOTE]
> references:
> - [Closures](https://groovy-lang.org/closures.html)
> - [Closures in Groovy](https://www.baeldung.com/groovy-closures)
> - [Groovy Goodness: Passing Closures to Methods](https://blog.mrhaki.com/2009/11/groovy-goodness-passing-closures-to.html)
> - [Groovy Goodness: Closure Arguments](https://blog.mrhaki.com/2009/11/groovy-goodness-closure-arguments.html)
> - [Groovy Goodness: Identity Closure](https://blog.mrhaki.com/2016/10/groovy-goodness-identity-closure.html)
> - [实战 Groovy: 用 curry 过的闭包进行函数式编程](https://wizardforcel.gitbooks.io/ibm-j-pg/content/10.html)

{% hint style='tip' %}
> A closure definition follows this syntax:
> ```
>  { [closureParameters -> ] statements }
> ```
>
> [closure.call()](https://wizardforcel.gitbooks.io/ibm-j-pg/content/9.html)
> ```groovy
> Closure clos = { println "Hello World" }
> assert clos.call() == clos()
>            |           + implicit call
>            + explicit call
> ```
{% endhint %}

### [Closure VS. Method](https://www.baeldung.com/groovy-closures)
> closures have benefits over regular methods and are a powerful feature of Groovy:
> - We can pass a Closure as an argument to a method
> - Unary closures can use the implicit it parameter
> - We can assign a Closure to a variable and execute it later, either as a method or with call
> - Groovy determines the return type of the closures at runtime
> - We can declare and invoke closures inside a closure
> - Closures always return a value

- method
  ```groovy
  def formatToLowerCase( String name ) {
    name.toLowerCase()
  }
  ```

- closure
  ```groovy
  def formatToLowerCaseClosure = { name ->
    name.toLowerCase()
  }
  ```

### [break from closure](https://stackoverflow.com/a/19414187/2940319)
{% hint style='tip' %}
> tips:
> - `return` means continue
> - `return true` means break the loop
{% endhint %}

```groovy
def list = [1, 2, 3, 4, 5]
list.any { element ->
  if (element == 2)
    return // continue

  println element

  if (element == 3)
    return true // break
}
```

### curry
- left curry
  ```groovy
  def multiply = { x, y -> return x * y }
  def triple = multiply.curry(3)           // triple = { y -> return 3 * y }
  ```

- example
  ```groovy
  def nCopies = { int n, String... str -> str.join('')*n }
  def twice = nCopies.curry(2)
  println twice('|', '\\', '|', '/' )
  assert twice('|', '\\', '|', '/' ) == nCopies( 2, '|', '\\', '|', '/' )
  ```
  - result
    ```
    |\|/|\|/
    ```

- others left curry
  ```groovy
  def multiConcat = { int n, String... args ->
    args.join('')*n
  }
  multiConcat( 3, '*', '-', '=' )
  ```
  - result
    ```
    *-=*-=*-=
    ```

- right curry
  ```groovy
  def nCopies = { int n, String str -> str*n }
  def twice = nCopies.rcurry( '*-=*=-*' )
  println twice(2)
  assert twice(2) == nCopies( 2, '*-=*=-*' )
  ```
  - result
    ```
    *-=*=-**-=*=-*
    ```

  > [!TIP]
  > ```groovy
  > def nCopies = { int n, String str -> str*n }
  >
  > def twice   = nCopies.rcurry( '*-=*=-*' )
  > def divider = nCopies.curry( 2 )
  >
  > assert nCopies( 2, '*-=*=-*' ) == twice( 2 )                // right curry
  > assert nCopies( 2, '-.-.-.-' ) == divider( '-.-.-.-' )      // left  curry
  > ```

- index with curry
  ```groovy
  def volume = { int l, int w, int h -> "l: ${l}\nw: ${w}\nh: ${h}" }
  def fixedWidthVolume = volume.ncurry(1, 2)
  println fixedWidthVolume( 3, 4 )
  ```
  - result
    ```groovy
    l: 3
    w: 2
    h: 4
    ```

### Memoization

{% hint style='tip' %}
**Fibonacci suite** :
> - `fib(15)` == `fib(14)` + `fib(13)`
> - `fib(14)` == `fib(13)` + `fib(12)`
{% endhint %}

- slow
  ```groovy
  def fib
  fib = { long n -> n<2 ? n : fib(n-1) + fib(n-2) }
  println fib(10)

  // result
  55
  ```

- fast
  > tips: `Closures.memoize()`

  ```groovy
  def fib
  fib = { long n -> n<2 ? n : fib(n-1) + fib(n-2) }.memoize()
  fib(50)

  // result
  12586269025
  ```

### composition
#### double composition
```groovy
def plus2  = { it + 2 }
def times3 = { it * 3 }
def times3plus2 = plus2 << times3
//                  |        + execute first
//                  + execute second
// result
assert times3plus2(3) == 3*3+2
assert times3plus2(3) == plus2(times3(3))

def plus2times3 = plus2 >> times3
//                  |        + execute last
//                  + execute first
// result
assert plus2times3(3) == (3+2)*3
assert plus2times3(3) == times3(plus2(3))
```

{% hint style='tip' %}
> ```groovy
> assert ( plus2 << times3 )(3)   ==   ( times3 >> plus2 )(3)
>            |        + execute first      |       + execute last
>            + execute last                + execute first
```
{% endhint %}

- [example for recursive in List](https://stackoverflow.com/a/62804996/2940319)
  ```groovy
  def map1 = [a: 10, b:2, c:3]
  def map2 = [b:3, c:2, d:5]
  def maps = [map1, map2]

  def process(def maps, Closure myLambda) {
    maps.sum { it.keySet() }.collectEntries { key ->
      [ key,
        { x ->
          x.subList(1, x.size()).inject(x[0], myLambda)
        }(maps.findResults { it[key] })
      ]
    }
  }

  def sumResult  = process(maps) { a, b -> a + b }
  def prodResult = process(maps) { a, b -> a * b }
  def minResult  = process(maps) { a, b -> a < b ? a : b }

  assert sumResult  == [a:10, b:5, c:5, d:5]
  assert prodResult == [a:10, b:6, c:6, d:5]
  assert minResult  == [a:10, b:2, c:2, d:5]
  ```
  - Resolution
    ```groovy
    assert [2,4,5].inject(1){ a, b -> a + b  }   == 12
    assert [2,4,5].inject(1, { a, b -> a + b  }) == 12
    ```

#### triple composition
```groovy
def multiply = { x, y -> return x * y }
def triple = multiply.curry(3)
def quadruple = multiply.curry(4)
def composition = { f, g, x -> return f(g(x)) }
def twelveTimes = composition.curry(triple, quadruple)      //  twelveTimes = { y -> composition { y -> 3*(4*y) } }
def threeDozen = twelveTimes(3)
```

### Methods
- various method to call closure
  ```groovy
  def work( String input, Closure cl ) {
    cl(input)
  }

  Closure assertJava = {
    it == 'Java'
  }

  println work( "Java", assertJava )
  println work("Java", { it == 'Java' }) // ==> work 'Java', { it == 'Java' }
  println work( 'Java' ){
    it == 'Java'
  }
  ```

- frequent usage
  ```groovy
  def on( String name, String dString = 'is' ) {
    [
      skip: { -> println "no params. skip" },

      foo: { String f, Map fmap ->
        foo( name, dString, f, fmap )
        [
          bar: { Map map -> bar( '', map ) }
        ]
      } ,

      bar: { Map map -> bar( name, map ) }
    ]
  }

  def reset( Map m ) {
    m.collect{ k, v -> "${k} : ${v}" }.join('\n')
  }

  def foo( String n, String ds, String f, Map m ) {
    println "${n} ${ds} ${f} !\ndetails :\n\t\t${reset(m)}"
  }

  def bar( String n = '', Map m ) {
    println "${n ? "${n}\n": ''}\t\t${reset(m)}"
  }
  ```
  - result
    ```groovy
    on('marslo')
      .foo( 'awesome', [ 'age' : 34 ] )
      .bar( ['gender' : 'female' ] )

    // result
    marslo is awesome !
    details :
        age : 34
        gender : female
    ```

  or
  ```groovy
  on('marslo')
    .skip()

  // result
  no params. skip
  ```

### delegate

> [!NOTE]
> references:
> - [Convert list to enumerated list in Groovy](https://stackoverflow.com/a/53867093/2940319)

```groovy
List.metaClass.collectWithIndex = { yield ->
  def collected = []
  delegate.eachWithIndex { listItem, index ->
    collected << yield(listItem, index)
  }

  return collected
}

result = list.collectWithIndex { it, index -> "${index + 1}. ${it}" }
```

- [.collect with an index](https://stackoverflow.com/a/13056982/2940319)
  ```groovy
  List.metaClass.collectWithIndex = { body->
    def i=0
    delegate.collect { body(it, i++) }
  }

  // or even
  List.metaClass.collectWithIndex = { body->
    [ delegate, 0..<delegate.size() ].transpose().collect(body)
  }
  ```


### tricky
#### `this`
```groovy
class Enclosing {
  void run() {
    def whatIsThisObject = { getThisObject() }
    assert whatIsThisObject() == this

    def whatIsThis = { this }
    assert whatIsThis() == this
  }
}

Enclosing e = new Enclosing()
e.run()
```