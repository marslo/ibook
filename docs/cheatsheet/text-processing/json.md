<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic](#basic)
  - [syntax for jq](#syntax-for-jq)
  - [Dealing with json objects](#dealing-with-json-objects)
  - [Slicing and Filtering](#slicing-and-filtering)
- [join](#join)
- [split](#split)
- [replacing](#replacing)
- [builtin operators](#builtin-operators)
  - [debug](#debug)
  - [select](#select)
  - [contains](#contains)
  - [`inside`](#inside)
  - [toUpperCase : `ascii_upcase`](#touppercase--ascii_upcase)
  - [to_entries[]](#to_entries)
  - [from_entries](#from_entries)
  - [with_entries](#with_entries)
  - [as](#as)
- [tricky](#tricky)
  - [space in the key](#space-in-the-key)
  - [get urlencode](#get-urlencode)

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
### syntax for jq

|  Syntax  | Description                                                            |
|:--------:|------------------------------------------------------------------------|
|    `,`   | Filters separated by a comma will produce multiple independent outputs |
|    `?`   | Will ignores error if the type is unexpected                           |
|   `[]`   | Array construction                                                     |
|   `{}`   | Object construction                                                    |
|    `+`   | Concatenate or Add                                                     |
|    `-`   | Difference of sets or Substract                                        |
| `length` | Size of selected element                                               |
|    `⎮`   | Pipes are used to chain commands in a similar fashion than bash        |



### Dealing with json objects

| Description                |               Command              |
|:---------------------------|:----------------------------------:|
| Display all keys           |             `jq 'keys'`            |
| Adds + 1 to all items      |       `jq 'map_values(.+1)'`       |
| Delete a key               |          `jq 'del(.foo)'`          |
| Convert an object to array | `to_entries ⎮ map([.key, .value])` |

### Slicing and Filtering

| Description                        | Command                                                                                                                                               |
| :--------------------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------: |
| All                                | `jq .[]`                                                                                                                                              |
| First                              | `jq '.[0]'`                                                                                                                                           |
| Range                              | `jq '.[2:4]'`                                                                                                                                         |
| First 3                            | `jq '.[:3]'`                                                                                                                                          |
| Last 2                             | `jq '.[-2:]'`                                                                                                                                         |
| Before Last                        | `jq '.[-2]'`                                                                                                                                          |
| split                              | `jq '.[] ⎮ split("/")[1]'`                                                                                                                            |
| Select array of int by value       | `jq 'map(select(. >= 2))'`                                                                                                                            |
| Select array of objects by value   | `jq '.[] ⎮ select(.id == "second")'`                                                                                                                  |
| Select by type                     | `jq '.[] ⎮ numbers'`<br> **with type been arrays, objects, iterables, booleans, numbers, normals, finites, strings, nulls, values, scalars **         |

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

or
```bash
$ echo '{ "some": "thing", "json": "like" }' |
       jq -r '[.some, .json] | "\(.[0]) \(.[1])"'
thing like
```

or
```bash
$ echo '{ "some": "thing", "json": "like" }' |
       jq -r '[.some, .json] | "\(.[0]): \(.[1])"'
thing: like
```

or with `reduce`
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
$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq -r '.[].uri'
/1
/2
/3

$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq -r '.[].uri | split("/")[1]'
1
2
3
```

- <kbd>[try online](https://jqplay.org/s/qwK5LX4ptX8)</kbd>
  ```bash
  $ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq '.[].uri | split("/")[]'
  ""
  "1"
  ""
  "2"
  ""
  "3"
  $ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq -r '.[].uri | split("/")'
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

> [!TIP]
> references:
> - [Replacing substrings in a string](https://developer.zendesk.com/documentation/integration-services/developer-guide/jq-cheat-sheet/#replacing-substrings-in-a-string)
> - [`sub(regex; tostring)`, `sub(regex; string; flags)`](https://stedolan.github.io/jq/manual/#sub(regex;tostring)sub(regex;string;flags))
>   - Emit the string obtained by replacing the first match of regex in the input string with `tostring`, after interpolation. `tostring` should be a jq string, and may contain references to named captures. The named captures are, in effect, presented as a JSON object (as constructed by capture) to `tostring`, so a reference to a captured variable named "x" would take the form: "(.x)".

```bash
$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq -r '.[].uri'
/1
/2
/3

$ echo '[{"uri" : "/1" }, {"uri" : "/2"}, {"uri" : "/3"}]' | jq -r '.[].uri | sub("/"; "")'
1
2
3
```

## builtin operators

> [!NOTE]
> reference:
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

or
```bash
$ echo '''[{"id": "first", "val": 1}, {"id": "second", "val": 2}]''' |
       jq '.[] | select(.id == "second")'
{
  "id": "second",
  "val": 2
}
```

### contains
> reference:
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

### [to_entries[]](https://github.com/stedolan/jq/issues/785#issuecomment-604557510)

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
```bash
$ echo '{"a": 1, "b": 2}' |
       jq 'with_entries(.key |= "KEY_" + .)'
{
  "KEY_a": 1,
  "KEY_b": 2
}
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
