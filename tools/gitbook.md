<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [hints](#hints)
  - [success](#success)
  - [tip](#tip)
  - [danger](#danger)
  - [warning](#warning)
  - [quote](#quote)
- [tab](#tab)
  - [code](#code)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

---
search:
    keywords: ['gitbook']
---

## [hints](https://github.com/GitbookIO/plugin-hints)
> [Simran-B/gitbook-plugin-callouts](https://github.com/Simran-B/gitbook-plugin-callouts)

| styles  | code                                             |
| -       | -                                                |
| info    | `{% hint style='info' %}`<br> `{% endhint %}`    |
| tip     | `{% hint style='tip' %}`<br> `{% endhint %}`     |
| danger  | `{% hint style='danger' %}`<br> `{% endhint %}`  |
| warning | `{% hint style='warning' %}`<br> `{% endhint %}` |
| success | `{% hint style='success' %}`<br> `{% endhint %}` |


### success
{% hint style='success' %}
```javascript
{% hint style='success' %}
success
{% endhint %}
```
{% endhint %}


### tip
{% hint style='tip' %}
```javascript
{% hint style='tip' %}
info
{% endhint %}
```
{% endhint %}


### danger
{% hint style='danger' %}
```javascript
{% hint style='danger' %}
danger
{% endhint %}
```
{% endhint %}


### warning
{% hint style='warning' %}
```javascript
{% hint style='warning' %}
warning
{% endhint %}
```
{% endhint %}

### quote
{% hint 'info' %}
**Important info**: this *note* needs to be highlighted

```javascript
{% hint 'info' %}
**Important info**: this *note* needs to be highlighted
{% endhint %}
```
{% endhint %}

## tab

### code
```
{% tabs %}
{% tab title="bash" %}
{% code title="filename: bash.sh" %}
# bash
{% endcode %}
{% endtab %}

{% tab title="python" %}
python
{% endtab %}
{% endtabs %}
```
- example
{% tabs %}
{% tab title="bash" %}
{% code title="filename: bash.sh" %}
```bash
# bash
```
{% endcode %}
{% endtab %}

{% tab title="python" %}
```python
python
```
{% endtab %}
{% endtabs %}

## emoji
> **reference**:
> - [gist](https://gist.github.com/rxaviers/7360908)
> - [Emoji](https://github.com/StylishThemes/GitHub-Dark/wiki/Emoji)
> - [broken & new emojis](https://github.com/WebpageFX/emoji-cheat-sheet.com/issues/429)
> - [Emojis list from https://api.github.com/emojis](https://awes0mem4n.github.io/emojis-github.html)
> - [emoji-cheat-sheet.com](https://github.com/WebpageFX/emoji-cheat-sheet.com)

| **emoji**          | **code**             |
| :-:                | :-:                  |
| :joy:              | `:joy:`              |
| :u7981:            | `:u7981:`            |
| :u7121:            | `:u7121:`            |
| :white_check_mark: | `:white_check_mark:` |
| :four_leaf_clover: | `:four_leaf_clover:` |

## reference
- [gitbook 简明教程](http://www.chengweiyang.cn/gitbook/)
- [gitbook 入门教程](https://yuzeshan.gitbooks.io/gitbook-studying/content/)
- [book.json](http://www.chengweiyang.cn/gitbook/customize/book.json.html)
- [emoji](https://gist.github.com/rxaviers/7360908)
