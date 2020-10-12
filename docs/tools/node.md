<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [npm](#npm)
  - [upgrade](#upgrade)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## npm
### upgrade
```bash
$ npm install -g npm-check-updates
$ ncu -u
```
- [or](https://docs.npmjs.com/updating-packages-downloaded-from-the-registry)
  ```bash
  $ npm outdated -g --depth=0
  Package       Current  Wanted  Latest  Location
  react-sticky    5.0.8   5.0.8   6.0.3  global

  $ npm update -g react-sticky
  ```
