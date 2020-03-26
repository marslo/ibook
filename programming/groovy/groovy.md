<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [`Map`](#map)
  - [find a `string` in a nested `Map` by using recursive function](#find-a-string-in-a-nested-map-by-using-recursive-function)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## `Map`
### find a `string` in a nested `Map` by using recursive function
```groovy
def hasValue( Map m, String value ) {
  m.containsValue(value) || m.values().find { v -> v instanceof Map && hasValue(v, value) }
}
```

- another version

```groovy
def hasValue( Map m, String value ) {
  if ( m.containsValue(value) ) return m.containsValue(value)
  m.findResult { k, v -> v instanceof Map ? hasValue(v, value) : null }
}
```
