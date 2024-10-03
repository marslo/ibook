<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic](#basic)
  - [syntax for jq](#syntax-for-jq)
  - [dealing with json objects](#dealing-with-json-objects)
  - [slicing and filtering](#slicing-and-filtering)
  - [mapping and transforming](#mapping-and-transforming)
- [join](#join)
- [split](#split)
- [replacing](#replacing)
- [builtin operators](#builtin-operators)
  - [debug](#debug)
  - [select](#select)
  - [contains](#contains)
  - [`inside`](#inside)
  - [toUpperCase : `ascii_upcase`](#touppercase--ascii_upcase)
  - [to_entries](#to_entries)
  - [try to_entries](#try-to_entries)
  - [from_entries](#from_entries)
  - [with_entries](#with_entries)
  - [as](#as)
- [tricky](#tricky)
  - [space in the key](#space-in-the-key)
  - [get urlencode](#get-urlencode)
  - [string to json](#string-to-json)
  - [map](#map)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style="tip" %}
> json online player:
> - [Online JSON Formatter & Validator](https://reqbin.com/json-formatter)
>
> jq online player:
> - [https://jqplay.org](https://jqplay.org/)
>
> reference:
> - [jq manual (development version)](https://stedolan.github.io/jq/manual/)
> - [Parsing JSON with jq](http://www.compciv.org/recipes/cli/jq-for-parsing-json/)
> - [olih/jq-cheetsheet.md](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4)
> - [Use jq to filter objects list with regex](https://til.hashrocket.com/posts/uv0bjiokwk-use-jq-to-filter-objects-list-with-regex)
> - [jq: Cannot iterate over number / string and number cannot be added](https://markhneedham.com/blog/2015/11/24/jq-cannot-iterate-over-number-string-and-number-cannot-be-added/)
> - [Guide to Linux jq Command for JSON Processing](https://www.baeldung.com/linux/jq-command-json)
> - [Reshaping JSON with jq](https://programminghistorian.org/en/lessons/json-and-jq)
> - [* jq cheat sheet](https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/)
>   - [Replacing a missing or null property](https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/#replacing-a-missing-or-null-property)
>   - [Replacing substrings in a string](https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/#replacing-substrings-in-a-string)
{% endhint %}

## basic
### [syntax for jq](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4#basic-concepts)

|  SYNTAX  | DESCRIPTION                                                            |
|:--------:|------------------------------------------------------------------------|
|    `,`   | Filters separated by a comma will produce multiple independent outputs |
|    `?`   | Will ignores error if the type is unexpected                           |
|   `[]`   | Array construction                                                     |
|   `{}`   | Object construction                                                    |
|    `+`   | Concatenate or Add                                                     |
|    `-`   | Difference of sets or Substract                                        |
| `length` | Size of selected element                                               |
|    `⎮`   | Pipes are used to chain commands in a similar fashion than bash        |

### [dealing with json objects](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4#dealing-with-json-objects)

| DESCRIPTION                | COMMAND                            |
|:---------------------------|:-----------------------------------|
| Display all keys           | `jq 'keys'`                        |
| Adds + 1 to all items      | `jq 'map_values(.+1)'`             |
| Delete a key               | `jq 'del(.foo)'`                   |
| Convert an object to array | `to_entries ⎮ map([.key, .value])` |

### [slicing and filtering](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4#slicing-and-filtering)

> [!NOTE|label:references:]
> - `select by type`: **with type been arrays, objects, iterables, booleans, numbers, normals, finites, strings, nulls, values, scalars**

| DESCRIPTION                      | COMMAND                              |
|:---------------------------------|:-------------------------------------|
| All                              | `jq .[]`                             |
| First                            | `jq '.[0]'`                          |
| Range                            | `jq '.[2:4]'`                        |
| First 3                          | `jq '.[:3]'`                         |
| Last 2                           | `jq '.[-2:]'`                        |
| Before Last                      | `jq '.[-2]'`                         |
| split                            | `jq '.[] ⎮ split("/")[1]'`           |
| Select array of int by value     | `jq 'map(select(. >= 2))'`           |
| Select array of objects by value | `jq '.[] ⎮ select(.id == "second")'` |
| Select by type                   | `jq '.[] ⎮ numbers'`                 |

### [mapping and transforming](https://gist.github.com/olih/f7437fb6962fb3ee9fe95bda8d2c8fa4#mapping-and-transforming)

| DESCRIPTION                          | COMMAND                                                                     |
|:-------------------------------------|:----------------------------------------------------------------------------|
| Add + 1 to all items                 | `jq 'map(.+1)'`                                                             |
| Delete 2 items                       | `jq 'del(.[1, 2])'`                                                         |
| Concatenate arrays                   | `jq 'add'`                                                                  |
| Flatten an array                     | `jq 'flatten'`                                                              |
| Create a range of numbers            | `jq '[range(2;4)]'`                                                         |
| Display the type of each item        | `jq 'map(type)'`                                                            |
| Sort an array of basic type          | `jq 'sort'`                                                                 |
| Sort an array of objects             | `jq 'sort_by(.foo)'`                                                        |
| Group by a key - opposite to flatten | `jq 'group_by(.foo)'`                                                       |
| Minimun value of an array            | `jq 'min'`<br>See also  min, max, min_by(path_exp), max_by(path_exp)        |
| Remove duplicates                    | `jq 'unique'` <br>or `jq 'unique_by(.foo)'` <br>or `jq 'unique_by(length)'` |
| Reverse an array                     | `jq 'reverse'`                                                              |

## join

> [!TIP]
> references:
> - [to output multiple values on a single line](https://github.com/stedolan/jq/issues/785)
> - [join multiple values](https://github.com/stedolan/jq/issues/785#issuecomment-101842421https://github.com/stedolan/jq/issues/785#issuecomment-101842421)

```bash
$ echo '{ "some": "thing", "json": "like" }' |
       jq -r '[.some, .json] | join(":")'
thing:like
```

- or
  ```bash
  $ echo '{ "some": "thing", "json": "like" }' |
         jq -r '[.some, .json] | "\(.[0]) \(.[1])"'
  thing like
  ```

- or
  ```bash
  $ echo '{ "some": "thing", "json": "like" }' |
         jq -r '[.some, .json] | "\(.[0]): \(.[1])"'
  thing: like
  ```

- or with `reduce`
  ```bash
  $ echo '{ "some": "thing", "json": "like" }' |
         jq -r '[.some, .json] | reduce .[1:][] as $i ("\(.[0])"; . + ",\($i)")'
  thing,like
  ```

- [or](https://github.com/stedolan/jq/issues/785#issuecomment-101842421)
  ```bash
  $ echo '{ "k1": "v1", "k2": "v2", "k3": "v3", "k4": "v4" }' |
         jq -r '[.k1, .k2, .k3] | reduce .[1:][] as $i ("\(.[0])"; . + ",\($i)")'
  v1,v2,v3
  ```

- [or](https://stackoverflow.com/a/31791436/2940319) with `.first` and `.last`
  ```bash
  $ echo '{ "users": [ { "first": "Stevie", "last": "Wonder" }, { "first": "Michael", "last": "Jackson" } ] }' |
         jq -r '.users[] | .first + " " + .last'
  Stevie Wonder
  Michael Jackson
  ```

- or
  ```bash
  $ echo '{ "users": [ { "first": "Stevie", "last": "Wonder" }, { "first": "Michael", "last": "Jackson" } ] }' |
         jq -r '.users[] | .first + " " + (.last|tostring)'
  ```

- or
  ```bash
  $ echo '{ "users": [ { "first": "Stevie", "last": "Wonder", "number": 1 }, { "first": "Michael", "last": "Jackson", "number": 2 } ] }' |
         jq -r '.users[] | .first + " " + (.number|tostring)'
  Stevie 1
  Michael 2
  ```

## split

> [!TIP]
> references:
> - [remove a substring from a string](https://stackoverflow.com/a/72064504/2940319)
> - [`split(str)`](https://stedolan.github.io/jq/manual/#split(str))
>   - Splits an input string on the separator argument.
>   - [example](https://jqplay.org/jq?q=split(%22%2C%20%22)&j=%22a%2C%20b%2Cc%2Cd%2C%20e%2C%20%22)
>     ```
>     jq 'split(", ")'
>     Input "a, b,c,d, e, "
>     Output  ["a","b,c,d","e",""]
>     ```

```bash
$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
        jq -r '.[].uri'
/1
/2
/3

$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
        jq -r '.[].uri | split("/")[1]'
1
2
3
```

- <kbd>[try online](https://jqplay.org/s/qwK5LX4ptX8)</kbd>
  ```bash
  $ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
          jq '.[].uri | split("/")[]'
  ""
  "1"
  ""
  "2"
  ""
  "3"
  $ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
          jq -r '.[].uri | split("/")'
  [
    "",
    "1"
  ]
  [
    "",
    "2"
  ]
  [
    "",
    "3"
  ]
  ```

## replacing

> [!TIP|label:references:]
> - [Replacing substrings in a string](https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/#replacing-substrings-in-a-string)
> - [`sub(regex; tostring)`, `sub(regex; string; flags)`](https://jqlang.github.io/jq/manual/#sub%28regex%3Btostring%29sub%28regex%3Bstring%3Bflags%29%29%0A)
>   - Emit the string obtained by replacing the first match of regex in the input string with `tostring`, after interpolation. `tostring` should be a jq string, and may contain references to named captures. The named captures are, in effect, presented as a JSON object (as constructed by capture) to `tostring`, so a reference to a captured variable named "x" would take the form: "(.x)".

```bash
$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
        jq -r '.[].uri'
/1
/2
/3

$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' |
        jq -r '.[].uri | sub("/"; "")'
1
2
3
```

## builtin operators

> [!NOTE|label:references:]
> - [jq manual - Builtin operators and functions](https://stedolan.github.io/jq/manual/#Builtinoperatorsandfunctions)

### debug
- without `debug`
  ```bash
  $ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "SECOND", "val": 3}]'''  |
         jq '.[] | select( .val == (2, 3) )'
  ```

- with `debug`:
  ```bash
  $ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "SECOND", "val": 3}]'''  |
         jq '.[] | select( .val == (2, 3) | debug )'
  ["DEBUG:",false]
  ["DEBUG:",false]
  ["DEBUG:",true]
  {
    "id": "second",
    "val": 2
  }
  ["DEBUG:",false]
  ["DEBUG:",false]
  ["DEBUG:",true]
  {
    "id": "SECOND",
    "val": 3
  }
  ```

### select

> [!NOTE|label:refrences:]
> - [imarslo: example on jenkins api analysis](../../jenkins/script/api.html#get-all-parameters-via-json-format)
> - [imarslo: example on gerrit api analysis](../../devops/git/gerrit.html#get-all-vote-cr-2)
> - [jq tips : remove emtpy line](https://stackoverflow.com/a/44289083/2940319)
> - [Filter empty and/or null values with jq](https://stackoverflow.com/a/56694468/2940319)
>   ```bash
>   to_entries[]
>   | select(.value | . == null or . == "")
>   | if .value == "" then .value |= "\"\(.)\"" else . end
>   | "\(.key): \(.value)"
>   ```

```bash
$ echo "[1,5,3,0,7]" |
       jq 'map(select(. >= 2))'
[
  5,
  3,
  7
]
```

- or
  ```bash
  $ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2}]''' |
         jq '.[] | select(.id == "second")'
  {
    "id": "second",
    "val": 2
  }
  ```

- [select with any](https://stackoverflow.com/a/70302131/2940319)

  > [!NOTE|label:references:]
  > - [`any(.attributes; .enabled == true)` == `any(.attributes; .enabled)` == `.attributes.enabled == true` == `.attributes.enabled`](https://stackoverflow.com/a/70302139/2940319)
  > - [<kbd>try online</kbd>](https://jqplay.org/s/61S_UA_ZEVM3Ykh)

  ```bash
  $ cat sample.json
  [
    {
      "attributes": {
        "created": "2021-10-18T12:02:39+00:00",
        "enabled": true,
        "expires": null,
        "notBefore": null
      },
      "contentType": null,
      "id": "https://kjkljk./secrets/-/1",
      "managed": null,
      "name": "pw",
      "tags": {}
    },
    {
      "attributes": {
        "created": "2021-10-18T12:06:16+00:00",
        "enabled": false,
        "expires": null,
        "notBefore": null
      },
      "contentType": "",
      "id": "https://kjklj./secrets/-/2",
      "managed": null,
      "name": "pw",
      "tags": {}
    }
  ]

  # get [{.id}] format
  $ cat sample.json |
        jq -r 'map(select(any(.attributes; .enabled)) | {id})'
  [
    {
      "id": "https://kjkljk./secrets/-/1"
    }
  ]

  # get [.id] format
  $ cat sample.json | jq -r 'map(select(any(.attributes; .enabled)) | .id)'
  [
    "https://kjkljk./secrets/-/1"
  ]

  # get .id format ( without `map()` )
  $ cat sample.json | jq -r '.[] | select(any(.attributes; .enabled)) | .id'
  https://kjkljk./secrets/-/1

  # re-format
  $ cat sample.json | jq -r '{"ids": .[] | select(any(.attributes; .enabled)) | .id}'
  {
    "ids": "https://kjkljk./secrets/-/1"
  }
  ```

### contains

> [!NOTE|label:reference:]
> - [imarslo: example on artifactory api analysis](../../artifactory/api.html#filter-buildinfoenvjobname-in-all-builds)
> - [imarslo: example on list Error pods in kuberetnes](../../virtualization/kubernetes/pod.html#list-all-error-status-pods)

```bash
$ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "second-one", "val": 3}]''' |
       jq '.[] | select( .id | contains("second") )'
{
  "id": "second",
  "val": 2
}
{
  "id": "second-one",
  "val": 3
}
```
- by using [test](https://stackoverflow.com/a/53849486/2940319)
  ```bash
  $ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "second.one", "val": 3}]'''  |
         jq '.[] | select( .id | test("sec*") )'
  {
    "id": "second",
    "val": 2
  }
  {
    "id": "second.one",
    "val": 3
  }
  ```

### [`inside`](https://stackoverflow.com/q/46530167/2940319)
```bash
$ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "second-one", "val": 3}]'''  |
       jq '.[] | select( [.val] | inside([2,3]) )'
{
  "id": "second",
  "val": 2
}
{
  "id": "second-one",
  "val": 3
}
```

- [or](https://stackoverflow.com/a/46530324/2940319)
  ```bash
  $ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "SECOND", "val": 3}]'''  |
         jq '.[] | select( .val == (2, 3) )'
  {
    "id": "second",
    "val": 2
  }
  {
    "id": "SECOND",
    "val": 3
  }
  ```

### [toUpperCase : `ascii_upcase`](https://stackoverflow.com/a/53451410/2940319)
```bash
$ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2},  {"id": "SECOND", "val": 3}]'''  |
       jq '.[] | select(.id | ascii_upcase == "SECOND")'
{
  "id": "second",
  "val": 2
}
{
  "id": "SECOND",
  "val": 3
}
```

### [to_entries](https://github.com/stedolan/jq/issues/785#issuecomment-604557510)

> [!NOTE]
> references:
> - [jq: filter input based on if key ends with specified string](https://stackoverflow.com/a/48906860/2940319)

```bash
# original
$ echo '{ "name" : "marslo" }' | jq -r
{
  "name": "marslo"
}

# `to_entries[]`
$ echo '{ "name" : "marslo" }' | jq -r 'to_entries[]'
{
  "key": "name",
  "value": "marslo"
}

# or `to_entries`
$ echo '{"a": 1, "b": 2}' | jq -r to_entries
[
  {
    "key": "a",
    "value": 1
  },
  {
    "key": "b",
    "value": 2
  }
]
```

- example to get `key` and `value`
  ```bash
  $ echo '{ "some": "thing", "json": "like" }' \
         | jq -r 'to_entries[] | "\(.key)\t\(.value)"'
  some    thing
  json    like
  ```

  - or output format to `@csv`
    ```bash
    $ echo '{ "some": "thing", "json": "like" }' |
           jq -r '[.some, .json] | @csv'
    "thing","like"
    ```

  - or output format to `@tsv`
    ```bash
    $ echo '{ "some": "thing", "json": "like" }' |
           jq -r '[.some, .json] | @tsv'
    thing like
    ```

- to_entries and select
  ```bash
  # orignal
  $ echo '{ "name/" : "marslo", "age/" : "18", "citizenship" : "china" }' | jq -r
  {
    "name/": "marslo",                 # wants value if key ends with '/'
    "age/": "18",                      # wants value if key ends with '/'
    "citizenship": "china"
  }

  # select
  $ echo '{ "name/" : "marslo", "age/" : "18", "citizenship" : "china" }' |
         jq -r 'to_entries[] | select(.key|endswith("/")) '
  {
    "key": "name/",
    "value": "marslo"
  }
  {
    "key": "age/",
    "value": "18"
  }

  # get `.value` after selected
  $ echo '{ "name/" : "marslo", "age/" : "18", "citizenship" : "china" }' |
         jq -r 'to_entries[] | select(.key|endswith("/")) | .value'
  marslo
  18
  ```

### [try to_entries](https://stackoverflow.com/a/71358256/2940319)

```bash
$ cat sample.json
[
  {
    "name": "x",
    "hobby": [                     // < has hobby
      "baseball",
      "baseketball"
     ]
  },
  {
    "name": "y"                    // < no hobby
  }
]

# to_entries[] directly will cause issue
$ cat sample.json |
      jq '.[] | .name as $n | .hobby | to_entries[] | [$n, .value]'
[
  "x",
  "baseball"
]
[
  "x",
  "baseketball"
]
jq: error (at <stdin>:12): null (null) has no keys

# try to_entries[]
#                                      try
#                                       v
$ cat sample.json |
      jq '.[] | .name as $n | .hobby | try to_entries[] | [$n, .value]'
[
  "x",
  "baseball"
]
[
  "x",
  "baseketball"
]
```

### from_entries
```bash
$ echo '[{"key":"a", "value":1}, {"key":"b", "value":2}]' |
       jq -r from_entries
{
  "a": 1,
  "b": 2
}
```

### with_entries

> [!NOTE|label:references:]
> - [JQ: Filtering for keys](https://stackoverflow.com/a/40924154/2940319)

```bash
$ echo '{"a": 1, "b": 2}' |
       jq 'with_entries(.key |= "KEY_" + .)'
{
  "KEY_a": 1,
  "KEY_b": 2
}
```

- to get particular branch permissions from Gerrit
  ```bash
  # with_entries
  $ curl -fsSL https://gerrit.domain.com/a/projects/$(printf %s "path/to/sandbox" | jq -sRr @uri)/access |
         tail -n+2 |
         jq -r '.local | with_entries( if(.key | test("^.+sandbox/marslo.+$")) then ( {key: .key, value: .value } ) else empty end )'

  # try to_entries[]
  $ curl -fsSL https://gerrit.domain.com/a/projects/$(printf %s "path/to/sandbox" | jq -sRr @uri)/access |
         tail -n+2 |
         jq -r '.local | try to_entries[] | select(.key | test("^.+sandbox/marslo.+$")) | .value'
  ```

### as

> [!NOTE|label:references]
> - [jq: filter input based on if key ends with specified string](https://stackoverflow.com/a/48904944/2940319)

```bash
$ echo '{ "name/" : "marslo", "age/" : "18", "citizenship" : "china" }' |
       jq -r '. as $o | keys_unsorted[] | select(endswith("/")) | $o[.]'
marslo
18
```

## tricky
### space in the key
```bash
$ echo '{ "k1 name": "v1", "k2 name": "v2", "k3": "v3", "k4": "v4" }' |
       jq -r '."k1 name"'
v1
```

### [get urlencode](https://stackoverflow.com/a/34407620/2940319)
```bash
$ printf %s 'input text' | jq -sRr @uri
input%20text

$ printf %s 'input=(text)' | jq -sRr @uri
input%3D%28text%29

$ printf %s '(=)&' | jq -sRr @uri
%28%3D%29%26
```

### [string to json](https://stackoverflow.com/a/67406617/2940319)
```bash
$ echo [
  "foo1:         xxxxxx",
  "foo2:    xxxxxx",
  "foo3:     xxxxxx",
  "foo4:         xxxxxx",
  "foo5:   xxxxxx",
  "foo6:       xxxxxx"
] | jq -r 'map(capture("^(?<key>.*):\\s*(?<value>.*)$")) | from_entries'
{
  "foo1": "xxxxxx",
  "foo2": "xxxxxx",
  "foo3": "xxxxxx",
  "foo4": "xxxxxx",
  "foo5": "xxxxxx",
  "foo6": "xxxxxx"
}
```

### [map](https://stackoverflow.com/a/71075491/2940319)

> [!NOTE|label:references:]
> - [semantics of map on a sequence of objects in jq](https://stackoverflow.com/a/71075491/2940319)
>   - `map( ... )`  ≡ `[ .[] | ... ]`, which `map( . ) ≡ [ .[] | . ]  ≡  [ .[] ]`
>   - for array: `map( . )  ≡  [ .[0], .[1], ... ]  ≡  .`
>   - for object: `map( . )  ≡  [ .["key1"], .["key2"], ... ]`
