<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [map withDefault](#map-withdefault)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### map withDefault
> requirement:
>
> `[a:1,b:2,c:2]`
>
>   ⇣
>
> `[1:['a'], 2:['b','c']]`

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
  ```

- alternatives
  ```groovy
  [a:1,b:2,c:2].groupBy{ it.value }.collectEntries{ k, v -> [(k): v.collect{ it.key }] }
  ```
