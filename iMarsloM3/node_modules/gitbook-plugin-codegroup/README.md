GitBook CodeGroup Plugin
==============

[![npm version](https://badge.fury.io/js/gitbook-plugin-codegroup.svg)](https://badge.fury.io/js/gitbook-plugin-codegroup)
[![Build Status](https://travis-ci.org/lwhiteley/gitbook-plugin-codegroup.svg?branch=master)](https://travis-ci.org/lwhiteley/gitbook-plugin-codegroup)

## Add Plugin

book.json
```js
{
    "plugins": ["codegroup"]
}
```

then run
```bash
$ gitbook install
```

### Configure (Optional Step)

book.json
```js
"pluginsConfig": {
    "codegroup":{
        "defaultTabName": "Code",
        "tabNameSeperator": "::",
        "rememberTabs": true
    }
}
```

### Config Options:
| Option | Description |
| ------------- | ------------- |
| defaultTabName {string} <br> **default**: `Code` | a fallback tab name if no language is specied for a fenced code block  |
| tabNameSeperator {string}  <br> **default**: `::` | a string delimeter that differentiates the language name from the tab name  |
| rememberTabs {boolean}  <br> **default**: `false` |determines if the plugin will remember the selected tab, given the info in the codegroup has not changed  |

## Template

<pre>
<code>
{% codegroup %}
```js::sdk
    var s = console.log;
```
```js
    var s = console.warn;
```
{% endcodegroup %}
</code>
</pre>

##### Args

`codegroup` takes optional named arguments: 

- `rememberTabs` (`boolean`): Overrides value in `pluginsConfig.codegroup.rememberTabs`.
- `defaultTabName` (`string`): A default tab name to use for the specific code group. Overrides value in `pluginsConfig.codegroup.defaultTabName`

**example**:
<pre>
<code>
{% codegroup rememberTabs=true, defaultTabName="Snippet" %}
```js::nodejs
    var s = "sample";
```
```swift
    let s: String = "sample";
```
{% endcodegroup %}
</code>
</pre>


#### Notes:
- ebook/PDF compatible
- The goal of this project is to write codegroups/codetabs as close to markdown as possible

### Custom Named Tabs

As seen in the example above, tabs can have custom names for situations where it is required to group the same language and there is need to differentiate them.

The example above shows a code block `js::sdk`, where `js` is the language syntax to be used and `sdk` denotes the name to be seen in the tab; `::` (configurable) is used to separate both terms.

### Custom Print Titles

It is also possible to supply a `Print Title` using a second `tabNameSeperator`

**Examples**:

| Example | Description |
| ------------- | ------------- |
| **Explicit** <br/><br/> `js::sdk::Javascript SDK`| When converted to pdf, `Javascript SDK` will be placed above the code block |
| **Syntax+Print Only** <br/><br/>`js::::Javascript SDK`| It is possible to omit the `custom tab name` by using a double `tabNameSeperator` |
| **TabName+Print Only** <br/><br/>`::sdk::Javascript SDK`| It is possible to omit the `syntax name` to only define the `custom tab name` and `print title` |
| **Print Only** <br/><br/>`::::Javascript SDK` |It is possible to omit the `syntax name` and `custom tab name` by using a double `tabNameSeperator` |

### CodeGroup Use Case:
- This is ideal for displaying similar usages of the same code in multiple languages
    - for example an sdk that can be used in several languages

### Output Sample:
![js-tab](https://i.imgur.com/UhTS6j9.png)
![swift-tab](https://i.imgur.com/E08d0oV.png)

### Similar Projects
- [remarkable-codegroup](https://github.com/lwhiteley/remarkable-codegroup)
- [GitbookIO/plugin-codetabs](https://github.com/GitbookIO/plugin-codetabs)

### TODOs:
- consider using a select list in mobile

Pull requests are welcome



