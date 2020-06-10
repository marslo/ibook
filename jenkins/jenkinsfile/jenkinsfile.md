<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Trigger](#trigger)
  - [Poll SCM](#poll-scm)
  - [Triggered by](#triggered-by)
- [Environment Variables](#environment-variables)
  - [Get current customized environment](#get-current-customized-environment)
  - [Get downstream build environment](#get-downstream-build-environment)
  - [Get previous build environment](#get-previous-build-environment)
- [Stop the current build](#stop-the-current-build)
  - [stop current](#stop-current)
  - [stop all](#stop-all)

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


## Environment Variables
### Get current customized environment
```groovy
  println currentBuild.getBuildVariables()?.MY_ENV
```
### Get downstream build environment
```groovy
  def res = build job: 'downstream-job', propagate: false
  println res.getBuildVariables()?.MY_ENV
```
### Get previous build environment
```groovy
  println currentBuild.getPreviousBuild().getBuildVariables()?.MY_ENV
```

## Stop the current build
### stop current
```groovy
  // stop and show status to UNSTABLE
  if ( 'UNSTABLE' == currentBuild.result ) {
    currentBuild.getRawBuild().getExecutor().interrupt(Result.UNSTABLE)
  }
```
### [stop all](https://stackoverflow.com/a/26306081/2940319)
```groovy
Thread.getAllStackTraces().keySet().each() {
  t -> if (t.getName()=="YOUR THREAD NAME" ) { t.interrupt(); }          // or t.stop();
}

// and

Jenkins.instance.getItemByFullName("JobName")
                .getBuildByNumber(JobNumber)
                .finish(
                        hudson.model.Result.ABORTED,
                        new java.io.IOException("Aborting build")
                );
```

