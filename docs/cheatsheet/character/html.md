<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [useful html snippets](#useful-html-snippets)
  - [checkbox](#checkbox)
- [warnning box](#warnning-box)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## useful html snippets

### checkbox
- non-editable checked checkbox
  ```html
  <input type="checkbox" checked="true" onclick="return false">
  ```
  - example: <input type="checkbox" checked="true" onclick="return false">

- non-editable non-chekced checkbox
```html
<input type="checkbox" onclick="return false">
```
  - example: <input type="checkbox" onclick="return false">

## warnning box

> [!TIP]
> references:
> - [Extended Choice Parameter](https://plugins.jenkins.io/extended-choice-parameter/)

```html
<script src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons.js"></script>
<div style="color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; min-height: 4rem; padding-left: 3rem; position: relative; padding: 0.75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: 0.25rem;">
  <div>Warning : The current version of this plugin contains multiple vulnerabilities:
    <ul style="font-size: 1rem; font-weight: bolder; margin-bottom: 0;">
      <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-1350">CSRF vulnerability and missing permission checks allow SSRF</a></strong></li>
      <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-1351">Arbitrary JSON and property file read vulnerability</a></strong></li>
      <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-2232">Stored XSS vulnerability</a></strong></li>
      <li><strong><a href="https://www.jenkins.io/security/advisory/2022-04-12/#SECURITY-2617">Stored XSS vulnerability</a></strong></li>
    </ul>
  </div>
</div>
```

- example: <br>

  <script src="https://unpkg.com/ionicons@4.5.10-0/dist/ionicons.js"></script>
  <div style="color: #721c24; background-color: #f8d7da; border-color: #f5c6cb; min-height: 4rem; padding-left: 3rem; position: relative; padding: 0.75rem 1.25rem; margin-bottom: 1rem; border: 1px solid transparent; border-radius: 0.25rem;">
    <div>Warning : The current version of this plugin contains multiple vulnerabilities:
      <ul style="font-size: 1rem; font-weight: bolder; margin-bottom: 0;">
        <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-1350">CSRF vulnerability and missing permission checks allow SSRF</a></strong></li>
        <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-1351">Arbitrary JSON and property file read vulnerability</a></strong></li>
        <li><strong><a href="https://www.jenkins.io/security/advisory/2022-03-15/#SECURITY-2232">Stored XSS vulnerability</a></strong></li>
        <li><strong><a href="https://www.jenkins.io/security/advisory/2022-04-12/#SECURITY-2617">Stored XSS vulnerability</a></strong></li>
      </ul>
    </div>
  </div>
