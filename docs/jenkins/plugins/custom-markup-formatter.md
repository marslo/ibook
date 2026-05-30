<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [setup](#setup)
- [usage](#usage)
  - [collapse](#collapse)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Customizable HTML Formatter](https://plugins.jenkins.io/custom-markup-formatter/)

## setup

1. go to **Manage Jenkins** → **Security** → **Markup Formatter**, and select **Customizable HTML Formatter**
2. go to **Manage Jenkins** → **Configure System** → **Custom Markup Formatter**, and add the following content:

   ```json
   [
     {
       "type": "inbuilt",
       "name": "blocks, formatting, styles, links, tables, images"
     },
     {
       "type": "new",
       "allow": {
         "dl, dt, dd, hr": "",
         "details, summary": "",
         "pre, code": "",
         "div, span": "style",
         "font": "size, color"
       }
     }
   ]
   ```

## usage

### collapse

```groovy
addSummary(
  icon: 'symbol-terminal-outline plugin-ionicons-api',
  text: '<h4>collapse test</h4>' +
        '<details>' +
          '<summary>click to expand details ...</summary>' +
          '<pre><code>' +
            'abc123  file1.tar.bz2<br>' +
            'def456  file2.tar.bz2<br>' +
            '789ghi  file3.tar.bz2<br>' +
          '</code></pre>' +
        '</details>'
)

// or fancy version
Map<String, String> styles = [
  pre      : 'display:block;background-color:#FAFBFC;color:#24292E;padding:8px 16px;border-radius:12px;border:1px solid #E1E4E8;font-size:13px;overflow-x:auto;box-shadow:0 4px 12px rgba(0,0,0,0.1),0 1px 3px rgba(0,0,0,0.06)',
  monofont : 'font-family: var(--font-family-mono, ui-monospace, SFMono-Regular, "Cascadia Code", Consolas, Menlo, Monaco, monospace)',
  summary  : 'cursor:pointer;color:#0366D6;font-weight:bold;padding:6px 12px;background-color:#F1F8FF;border-radius:6px'
]

String body = '''
              abc123  file1.tar.bz2
              def456  file2.tar.bz2
              789ghi  file3.tar.bz2
              '''.stripIndent().trim()
String html = "<pre style=\"${styles.pre};${styles.monofont}\"><code style=\"font-family:inherit;\">${body}</code></pre>"
html        = "<details style=\"margin-bottom:16px;\"><summary style=\"${styles.summary}\">click to expand details ...</summary>${html}</details>"
html        = "<h4>collapse test</h4>${html}"

addSummary icon: 'symbol-terminal-outline plugin-ionicons-api', text: html
```

![fancy collapse code box](../../screenshot/jenkins/jenkins-fancy-codeb-box.png)
