<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [trigger](#trigger)
  - [poll SCM](#poll-scm)
  - [`parameterizedCron`](#parameterizedcron)
  - [triggered by](#triggered-by)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## trigger
### poll SCM
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

### [`parameterizedCron`](https://github.com/jenkinsci/parameterized-scheduler-plugin)
```groovy
properties([
  parameters([
    choice(choices: ['', 'a', 'b', 'c'], description: '', name: 'var1')
    choice(choices: ['', 'a', 'b', 'c'], description: '', name: 'var2')
  ]),
  pipelineTriggers([
    parameterizedCron( '''
      H/3 * * * * % var1=a; var2=b
      H/6 * * * * % var1=b; var2=a
    ''' )
  ])
])
```

### triggered by
> - [gitlab](https://stackoverflow.com/a/55366682/2940319)

- gitlab
  ```groovy
  currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData()
  // or
  commit = currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData().getLastCommit()
  ```

- get build cause
  ```groovy
  def build = currentBuild.rawBuild
  println build.getCauses().collect { it.getClass().getCanonicalName().tokenize('.').last() }

  println """
    cause: ${build.getCauses().toString()}
    cause.getClass(): ${build.getCauses().getClass()} : ${build.getCauses().getClass().getCanonicalName()}
    build.getCause(hudson.model.Cause.UserIdCause.class): ${build.getCause(hudson.model.Cause.UserIdCause.class)}
  """
  ```
- get user id if triggered by manually
  ```groovy
  def build = currentBuild.rawBuild
  if ( build.getCause(hudson.model.Cause.UserIdCause.class) ) {
    println """
      username: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserName()}
      id: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}
      mail: ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}@domain.com
    """
  }
  ```

  - or
    ```groovy
    import hudson.model.Cause.UserIdCause

    if ( build.getCause(UserIdCause.class) ) {
      println """
        username: ${build.getCause(UserIdCause.class).getUserName()}
        id: ${build.getCause(UserIdCause.class).getUserId()}
        mail: ${build.getCause(UserIdCause.class).getUserId()}@domain.com
      """
    }
    ```

