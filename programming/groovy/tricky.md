<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [get the first item if exists or null if empty](#get-the-first-item-if-exists-or-null-if-empty)
- [elegant way to merge Map<String, List<String>> structure by using groovy](#elegant-way-to-merge-mapstring-liststring-structure-by-using-groovy)

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


### [elegant way to merge Map<String, List<String>> structure by using groovy](https://stackoverflow.com/q/62466451/2940319)

<table>
<tr> <td> original Map structure </td> <td> wanted result</td> </tr>
<tr> <td>
<pre lang="groovy">
Map<String, List<String>> case_pool = [
  dev : [
    funcA : ['devCaseA'] ,
    funcB : ['devCaseB'] ,
    funcC : ['devCaseC']
  ],
  'dev/funcA' : [
    funcA : ['performanceCaseA']
  ],
  'dev/funcA/feature' : [
    funcA : ['performanceCaseA', 'featureCase']
  ],
  staging : [
   funcB : ['stgCaseB'] ,
   funcC : ['stgCaseC']
  ]
]
</pre>
</td> <td>
<pre lang="groovy">
String branch = 'dev/funcA/feature-1.0'

result:
[
  funcA: [ "devCaseA", "performanceCaseA", "featureCase" ],
  funcB: [ "devCaseB" ],
  funcC: [ "devCaseC" ]
]
</pre>
</td>
</tr>
</table>


| original map structure | wanted result |
| : -- | : -- |
| `Map<String, List<String>> case_pool = [				` <br> `	dev : [																				` <br> `		funcA : ['devCaseA'] ,											` <br> `		funcB : ['devCaseB'] ,											` <br> `		funcC : ['devCaseC']												` <br> `	],																						` <br> `	'dev/funcA' : [																` <br> `		funcA : ['performanceCaseA']								` <br> `	],																						` <br> `	'dev/funcA/feature' : [												` <br> `		funcA : ['performanceCaseA', 'featureCase']	` <br> `	],																						` <br> `	staging : [																		` <br> `	 funcB : ['stgCaseB'] ,												` <br> `	 funcC : ['stgCaseC']													` <br> `	]																							` <br> `]																							` | `String branch = 'dev/funcA/feature-1.0'										` <br> `																														` <br> `// result:																									` <br> `[																													` <br> `  funcA: [ "devCaseA", "performanceCaseA", "featureCase" ],` <br> `  funcB: [ "devCaseB" ],																		` <br> `  funcC: [ "devCaseC" ]																		` <br> `]																													`|




- method 1st

- method 2nd
- method 3rd




