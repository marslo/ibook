<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Trigger](#trigger)
  - [Poll SCM](#poll-scm)
  - [Triggered by](#triggered-by)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Trigger

### Poll SCM
```groovy
properties([
    // every 6 hours
    pipelineTriggers([
        pollSCM( ignorePostCommitHooks: true, scmpoll_spec: 'H H/6 * * *' )
    ])
])
```

```groovy
properties([
    pipelineTriggers([
        [ $class: "SCMTrigger", scmpoll_spec: 'H/5 * * * *' ],
    ])
])
```

- declarative:

    ```groovy
    triggers {
        pollSCM ignorePostCommitHooks: true, scmpoll_spec: 'H H * * *'
    }
    ```

### Triggered by

- [gitlab](https://stackoverflow.com/a/55366682/2940319)
```groovy
currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData()
// or
commit = currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData().getLastCommit()
```
