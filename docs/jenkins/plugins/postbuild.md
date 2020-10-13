<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Groovy Postbuild Plugin](#groovy-postbuild-plugin)
  - [setup badge](#setup-badge)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## [Groovy Postbuild Plugin](https://github.com/jenkinsci/groovy-postbuild-plugin)
> [badge-plugin](https://github.com/jenkinsci/badge-plugin/blob/master/README.md)

### setup badge
#### setup badge from another plugins
```groovy
manager.addBadge("/plugin/artifactory/images/artifactory-promote.png", "promoted")
```
- how to find it

![using icon from another plugin](../../screenshot/jenkins/badge.png)
