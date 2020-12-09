<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment variables](#environment-variables)
  - [get current customized environment](#get-current-customized-environment)
  - [get downstream build environment](#get-downstream-build-environment)
  - [get previous build environment](#get-previous-build-environment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## environment variables
### get current customized environment
```groovy
println currentBuild.getBuildVariables()?.MY_ENV
```

### get downstream build environment
```groovy
def res = build job: 'downstream-job', propagate: false
println res.getBuildVariables()?.MY_ENV
```

### get previous build environment
```groovy
println currentBuild.getPreviousBuild().getBuildVariables()?.MY_ENV
```
