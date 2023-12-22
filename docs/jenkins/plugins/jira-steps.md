<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get field](#get-field)
- [get issue](#get-issue)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



### [get field](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_get_fields/)
```groovy
import static groovy.json.JsonOutput.*

def fields = jiraGetFields idOrKey: 'MYJIRA-1', site: 'jira'
println prettyPrint( toJson( fields.data ))
```

### [get issue](https://jenkinsci.github.io/jira-steps-plugin/steps/issue/jira_get_issue/)
```groovy
def issue = jiraGetIssue idOrKey: 'MYJIRA-1', site: 'jira'
println issue.data
```
