<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

  - [get the first item if exists or null if empty](#get-the-first-item-if-exists-or-null-if-empty)
  - [split and trim in string](#split-and-trim-in-string)
  - [elegant way to merge Map&#60;String, List&#60;String&#62;&#62; structure by using groovy](#elegant-way-to-merge-map60string-list60string6262-structure-by-using-groovy)
  - [fuzzy search and merge `Map<String, Map<String, Map<String, String>>>`](#fuzzy-search-and-merge-mapstring-mapstring-mapstring-string)
  - [groupBy `List<List<String>>` to `Map<String, List>`](#groupby-listliststring-to-mapstring-list)
  - [get object id (`python -c 'id('abc')`)](#get-object-id-python--c-idabc)
  - [getField()](#getfield)
- [enum](#enum)
  - [check whether if enum contains a given string](#check-whether-if-enum-contains-a-given-string)
  - [list all values in Enum](#list-all-values-in-enum)
  - [Convert String type to Enum](#convert-string-type-to-enum)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### get the first item if exists or null if empty
```groovy
assert [:]?.find{true} == null
assert []?.find{true} == null
assert ['a']?.find{true} == 'a'
['a': '1'].find{ true }.each { println it.key + ' ~> ' + it.value }
println (['a': '1'].find{ true }.getClass())

// result
// a ~> 1
// class java.util.LinkedHashMap$Entry
```

### split and trim in string
- [spread operator](https://groovy-lang.org/operators.html#_spread_operator): `*.`
  ```groovy
  groovy:000> 'a  , b, ccc  ,d'.split(',')*.trim()
  ===> [a, b, ccc, d]
  ```

- [regular expression `\s*<opt>\s*`](https://stackoverflow.com/a/41953571/2940319)
  ```groovy
  groovy:000> 'a  , b, ccc  ,d'.trim().split("\\s*,\\s*")
  ===> [a, b, ccc, d]
  ```




### [elegant way to merge Map&#60;String, List&#60;String&#62;&#62; structure by using groovy](https://stackoverflow.com/q/62466451/2940319)

<table>
<tr> <td> original Map structure </td> <td> wanted result</td> </tr>
<tr> <td>
<pre lang="groovy"><code lang="groovy">
Map&#60;String, List&#60;String&#62;&#62; case_pool = [
  dev : [
    funcA : ['devA'] ,
    funcB : ['devB'] ,
    funcC : ['devC']
  ],
  'dev/funcA' : [
    funcA : ['performanceA']
  ],
  'dev/funcA/feature' : [
    funcA : ['performanceA', 'feature']
  ],
  staging : [
   funcB : ['stgB'] ,
   funcC : ['stgC']
  ]
]
</code></pre>
</td> <td>
<pre lang="groovy"><code>
String branch = 'dev/funcA/feature-1.0'

result:
[
  funcA: [ "devA", "performanceA", "feature" ],
  funcB: [ "devB" ],
  funcC: [ "devC" ]
]
</code></pre>
</td>
</tr>
</table>


|  <div style="width:50%"> original map structure</div>                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           | wanted result                                                                                                                                                                                  |
| : --                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            | : --                                                                                                                                                                                           |
| Map&#60;String, List&#60;String&#62;&#62; case_pool = [<br> &nbsp;&nbsp;dev : [<br> &nbsp;&nbsp;&nbsp;&nbsp;funcA : ['devA'] ,<br> &nbsp;&nbsp;&nbsp;&nbsp;funcB : ['devB'] ,<br> &nbsp;&nbsp;&nbsp;&nbsp;funcC : ['devC']<br> &nbsp;&nbsp;],<br> &nbsp;&nbsp;'dev/funcA' : [<br> &nbsp;&nbsp;&nbsp;&nbsp;funcA : ['performanceA']<br> &nbsp;&nbsp;],<br> &nbsp;&nbsp;'dev/funcA/feature' : [<br> &nbsp;&nbsp;&nbsp;&nbsp;funcA : ['performanceA', 'feature']<br> &nbsp;&nbsp;],<br> &nbsp;&nbsp;staging : [<br> &nbsp;&nbsp;&nbsp;&nbsp;funcB : ['stgB'] ,<br> &nbsp;&nbsp;&nbsp;&nbsp;funcC : ['stgC']<br> &nbsp;&nbsp;]<br> ] | String branch = 'dev/funcA/feature-1.0'<br> <br> // will final get result of: <br> // " 'dev' + 'dev/funcA' + 'dev/funcA/feature' ":<br> [<br> &nbsp;&nbsp;funcA: [ "devA", "performanceA", "feature" ],<br> &nbsp;&nbsp;funcB: [ "devB" ],<br> &nbsp;&nbsp;funcC: [ "devC" ]<br> ] |



- original map structure:

```groovy
Map<String, List<String>> case_pool = [
  dev : [
    funcA : ['devA'] ,
    funcB : ['devB'] ,
    funcC : ['devC']
  ],
  'dev/funcA' : [
    funcA : ['performanceA']
  ],
  'dev/funcA/feature' : [
    funcA : ['performanceA', 'feature']
  ],
  staging : [
   funcB : ['stgB'] ,
   funcC : ['stgC']
  ]
]
```

- method 1st: by using loop

```groovy
String branch = 'dev/funcA/feature-1.0'
def result = [:].withDefault { [] as Set }
case_pool.keySet().each {
  if ( branch.contains(it) ) {
    case_pool.get(it).each { k, v ->
      result[k].addAll(v)
    }
  }
}
println 'result: ' + result
```

- method 2nd: by using closure

```groovy
String branch = 'dev/funcA/feature-1.0'
def result = [:].withDefault { [] as Set }
case_pool.findAll{ k, v -> branch.contains(k) }.collectMany{ k, v -> v.collect{ c, l ->
    result[c].addAll(l)
}}
println 'result: ' + result
```

- method 3rd: by using closure elegantly

```groovy
def result = case_pool.inject([:].withDefault { [] as Set }) { result, key, value ->
  if (branch.contains(key)) {
    value.each { k, v -> result[k] += v }
  }; result
}
println 'result: ' + result
```


### fuzzy search and merge `Map<String, Map<String, Map<String, String>>>`
```groovy
/**
 * "fuzzy" search and merge the {@code Map<String, Map<String, String>>} according to keywords.
 * To replace the hardcode 'keyword' search {@code case_pool.get(stg).get(keyword).values()}. example:
 * <pre><code>
 * keyword = 'dev/funcA/feature1'
 * fuzzyFindAll( case_pool, keyword )
 *  => Result: [funcA:[devA, performanceA, feature], funcB:[devB], funcC:[devC]]
 * </pre></code>
 *
 * @param map       the map structure for {@code Map<String, Map<String, String>>}
 * @param keyword   use branch as keyword normally
**/
def fuzzyFindAll( Map map, String keyword ) {
  Map result = [:]
  map.findAll{ k, v -> keyword.toLowerCase().contains(k.toLowerCase()) }.collect { k, v ->
    v.each { key, value ->
      result[key] = [ result.getOrDefault(key,[]) + value ].flatten().unique()
    }
  }
  return result
}
```

### [groupBy `List<List<String>>` to `Map<String, List>`](https://stackoverflow.com/questions/40981393/group-by-in-groovy)
> requirements:
>
> `[ ["GX 470","Model"], ["Lexus","Make"], ["Jeep","Make"], ["Red","Color"], ["blue","Color"] ]`
>
>   ⇣⇣
>
> `["Model":["GX 470"],"Make":["Lexus","Jeep"],"Color":["Red", "blue"]]`

- solution
  ```groovy
  def list = [
      ["GX-470","Model"],
      ["Lexus","Make"],
      ["Jeep","Make"],
      ["Red","Color"],
      ["blue","Color"]
  ]

  list.groupBy{ it[1] }.collectEntries{ k, v -> [(k): v.collect{it.get(0)}] }
  ```

[alternatives](https://stackoverflow.com/a/40982023/2940319)
  ```groovy
  list.inject([:].withDefault{[]}) { map, elem ->
    map[elem[1]] << elem[0]
    map
  }
  ```

### get object id (`python -c 'id('abc')`)
```groovy
java.lang.System.identityHashCode( obj )
```
example
  ```bash
  String s = 'abc'
  String x = s
  println java.lang.System.identityHashCode(s)
  println java.lang.System.identityHashCode(x)
  x = s + 'aa'
  println java.lang.System.identityHashCode(x)

  ==>
  51571311
  51571311
  733591550
  ```

example for `identityHashCode() and hashCode()`
  ```groovy
  String a = new String("hhh")
  String b = new String("hhh")

  println(System.identityHashCode(a))
  println(System.identityHashCode(b))

  println(a.hashCode())
  println(b.hashCode())
  ```

### getField()
```groovy
groovy:000 > 'aaa'.getClass().getFields()
===> [public static final java.util.Comparator java.lang.String.CASE_INSENSITIVE_ORDER]
```

## enum
> precondition:
> ```groovy
> enum Choices {a1, a2, b1, b2}
> ```

### [check whether if enum contains a given string](https://stackoverflow.com/a/51068456/2940319)
```groovy
assert Arrays.asList(Choices.values()).toString().contains("a9") == false
assert Arrays.asList(Choices.values()).toString().contains("a1") == true
```
- [or](https://stackoverflow.com/a/37611080/2940319)
  ```groovy
  assert Arrays.stream(Choices.values()).anyMatch((t) -> t.name().equals("a1")) == true
  ```
- or
  ```bash
  assert Choices.values()*.name().contains('a1') == true
  assert Choices.values()*.name().contains('a9') == false
  ```
- [or](https://stackoverflow.com/a/10171194/2940319)
  ```bash
  public enum Choices {
    a1, a2, b1, b2;

    public static boolean contains(String s) {
      try {
        Choices.valueOf(s);
        return true;
      } catch (Exception e) {
        return false;
      }
    }
  }

  Choices.contains('a1')
  ```

- or
  ```groovy
  public enum Choices {
    a1, a2, b1, b2;

    public static boolean contains(String str) {
      return Arrays.asList(Choices.values()).toString().contains(str)
    }
  }
  assert Choices.contains('a1') == true
  ```

### [list all values in Enum](https://stackoverflow.com/a/15436799/2940319)
```bash
groovy:000> enum Choices {a1, a2, b1, b2}
===> true
groovy:000> println Choices.values()
[a1, a2, b1, b2]
===> null
```
- or
  ```groovy
  List<String> enumValues = Arrays.asList( Choices.values() )
  ```

### Convert String type to Enum
```bash
groovy:000> enum Choices {a1, a2, b1, b2}
===> true
groovy:000> Choices.valueOf("a1").getClass()
===> class Choices
```
