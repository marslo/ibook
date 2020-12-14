<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [jq](#jq)
  - [format](#format)
  - [join](#join)
  - [space in the key](#space-in-the-key)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> reference:
> - [jq manual (development version)](https://stedolan.github.io/jq/manual/)
> - [Parsing JSON with jq](http://www.compciv.org/recipes/cli/jq-for-parsing-json/)
> - [Use jq to filter objects list with regex](https://til.hashrocket.com/posts/uv0bjiokwk-use-jq-to-filter-objects-list-with-regex)
> - [jq: Cannot iterate over number / string and number cannot be added](https://markhneedham.com/blog/2015/11/24/jq-cannot-iterate-over-number-string-and-number-cannot-be-added/)

## [jq](https://github.com/stedolan/jq/issues/785#issuecomment-604557510)
### format
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r 'to_entries[] | "\(.key)\t\(.value)"'
some    thing
json    like
```

or
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | @csv'
"thing","like"
```
or
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | @tsv'
thing	like
```

### join
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | join(":")'
thing:like
```

or
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | "\(.[0]) \(.[1])"'
thing like
```

or
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | "\(.[0]): \(.[1])"'
thing: like
```

or
```bash
$ echo '{ "some": "thing", "json": "like" }' \
       | jq -r '[.some, .json] | reduce .[1:][] as $i ("\(.[0])"; . + ",\($i)")'
thing,like
```

- [or](https://github.com/stedolan/jq/issues/785#issuecomment-101842421)
  ```bash
  $ echo '{ "k1": "v1", "k2": "v2", "k3": "v3", "k4": "v4" }' \
         | jq -r '[.k1, .k2, .k3] | reduce .[1:][] as $i ("\(.[0])"; . + ",\($i)")'
  v1,v2,v3
  ```

[or](https://stackoverflow.com/a/31791436/2940319)
```bash
$ echo '{ "users": [ { "first": "Stevie", "last": "Wonder" }, { "first": "Michael", "last": "Jackson" } ] }' \
       | jq -r '.users[] | .first + " " + .last'
Stevie Wonder
Michael Jackson
```
- or
  ```bash
  $ echo '{ "users": [ { "first": "Stevie", "last": "Wonder" }, { "first": "Michael", "last": "Jackson" } ] }' \
         | jq -r '.users[] | .first + " " + (.last|tostring)'
  ```
- or
  ```bash
  $ echo '{ "users": [ { "first": "Stevie", "last": "Wonder", "number": 1 }, { "first": "Michael", "last": "Jackson", "number": 2 } ] }' \
         | jq -r '.users[] | .first + " " + (.number|tostring)'
  Stevie 1
  Michael 2
  ```

### space in the key
```bash
$ echo '{ "k1 name": "v1", "k2 name": "v2", "k3": "v3", "k4": "v4" }' | jq -r '."k1 name"'
v1
```
