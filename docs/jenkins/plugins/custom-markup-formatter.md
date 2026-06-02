<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [setup](#setup)
- [usage](#usage)
  - [collapse](#collapse)
  - [table](#table)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Customizable HTML Formatter](https://plugins.jenkins.io/custom-markup-formatter/)

## setup

1. go to **Manage Jenkins** → **Security** → **Markup Formatter**, and select **Customizable HTML Formatter**
2. go to **Manage Jenkins** → **Configure System** → **Customizable HTML Formatter Plugin**, and add the following content into the **Policy**

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

### table

> [!NOTE|label:references:]
> - [customizable-header plugin/Design Library/Table](https://weekly.ci.jenkins.io/design-library/table/)
>   - `class="jenkins-table sortable"`: make the table sortable by clicking the header

```jsonc
// policy
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
      "div, span": "style, class",
      "font": "size, color",
      "table": "class",
      "thead, tbody, tr": "",
      "th": "class",
      "td": "class",
      "a": "href, class, rel",
      "svg": "xmlns, viewBox, aria-hidden, style",
      "ellipse": "cx, cy, rx, ry, fill, stroke, stroke-linecap, stroke-miterlimit, stroke-width",
      "path": "d, fill, stroke, stroke-linecap, stroke-linejoin, stroke-width"
    }
  }
]
```

```groovy
// jenkinsfile
Closure svgs = { String color ->
  [
    blue   : '''<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" viewBox="0 0 512 512" style="width:20px; height:20px;"><ellipse cx="256" cy="256" fill="none" rx="210" ry="210" stroke="var(--success-color)" stroke-linecap="round" stroke-miterlimit="10" stroke-width="36"></ellipse><path d="M336 189L224 323L176 269.4" fill="transparent" stroke="var(--success-color)" stroke-linecap="round" stroke-linejoin="round" stroke-width="36"></path></svg>''',
    red    : '''<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" viewBox="0 0 512 512" style="width:20px; height:20px;"><ellipse cx="256" cy="256" fill="none" rx="210" ry="210" stroke="var(--red)" stroke-linecap="round" stroke-miterlimit="10" stroke-width="36"></ellipse><path d="M320 320L192 192M192 320l128-128" fill="none" stroke="var(--red)" stroke-linecap="round" stroke-linejoin="round" stroke-width="36"></path></svg>''',
    yellow : '''<svg xmlns="http://www.w3.org/2000/svg" aria-hidden="true" viewBox="0 0 512 512" style="width:20px; height:20px;"><ellipse cx="256" cy="256" fill="none" rx="210" ry="210" stroke="var(--orange)" stroke-linecap="round" stroke-miterlimit="10" stroke-width="36"></ellipse><path d="M250.26 166.05L256 288l5.73-121.95a5.74 5.74 0 00-5.79-6h0a5.74 5.74 0 00-5.68 6z" fill="none" stroke="var(--orange)" stroke-linecap="round" stroke-linejoin="round" stroke-width="36"></path><ellipse cx="256" cy="350" fill="var(--orange)" rx="26" ry="26"></ellipse></svg>'''
  ].get( color, '' )
}

addSummary icon: 'symbol-terminal',
           text: """
                 <table class="jenkins-table sortable">
                   <thead>
                     <tr><th>Name</th><th>S</th><th>Status</th><th>Reason</th></tr>
                   </thead>
                   <tbody>
                     <tr>
                       <td><a href="#" class="jenkins-table__link">Link 1</a></td>
                       <td class="jenkins-table__cell">${svgs('blue')}</td>
                       <td>Success <a href="#">#7</a></td>
                       <td>No Errors</td>
                     </tr>
                     <tr>
                       <td><a href="#" class="jenkins-table__link">Link 2</a></td>
                       <td class="jenkins-table__cell">${svgs('red')}</td>
                       <td>Failure</td>
                       <td>Can't compile</td>
                     </tr>
                     <tr>
                       <td><a href="#" class="jenkins-table__link">Link 3</a></td>
                       <td class="jenkins-table__cell">${svgs('yellow')}</td>
                       <td>Unstable</td>
                       <td>Test Failed</td>
                     </tr>
                   </tbody>
                 </table>
                 """.stripIndent()
```
