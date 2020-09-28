<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [execute Groovy script with an API call](#execute-groovy-script-with-an-api-call)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## [execute Groovy script with an API call](https://support.cloudbees.com/hc/en-us/articles/217509228-Execute-Groovy-script-in-Jenkins-with-an-API-call)
```bash
$ curl -d "script=$(cat /tmp/script.groovy)" -v --user username:ApiToken http://JENKINS_URL/scriptText

# or
$ curl -d "script=println 'this script works'" -v --user username:ApiToken http://JENKINS_URL/scriptText
```
