<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [trigger](#trigger)
  - [poll SCM](#poll-scm)
  - [`parameterizedCron`](#parameterizedcron)
- [triggered by](#triggered-by)
  - [libs](#libs)
  - [GerritCause](#gerritcause)

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

## triggered by

{% hint style='tip' %}
> references:
> - [gitlab](https://stackoverflow.com/a/55366682/2940319)
> - [CauseAction.class](https://javadoc.jenkins.io/hudson/model/CauseAction.html)
>   - [Cause.UpstreamCause](https://javadoc.jenkins-ci.org/hudson/model/Cause.UpstreamCause.html)
>   - [Cause.UserIdCause](https://javadoc.jenkins.io/hudson/model/Cause.UserIdCause.html)
>   - [RebuildCause](https://javadoc.jenkins.io/plugin/rebuild/com/sonyericsson/rebuild/RebuildCause.html)
>   - [ReplayCause](https://javadoc.jenkins.io/plugin/workflow-cps/org/jenkinsci/plugins/workflow/cps/replay/ReplayCause.html)
>   - [TimerTrigger.TimerTriggerCause](https://javadoc.jenkins.io/hudson/triggers/TimerTrigger.TimerTriggerCause.html)
>   - [ParameterizedTimerTriggerCause](https://javadoc.jenkins.io/plugin/parameterized-scheduler/org/jenkinsci/plugins/parameterizedscheduler/ParameterizedTimerTriggerCause.html)
> - [source code : yet-another-build-visualizer-plugin](https://www.programcreek.com/java-api-examples/?code=jenkinsci%2Fyet-another-build-visualizer-plugin%2Fyet-another-build-visualizer-plugin-master%2Fsrc%2Fmain%2Fjava%2Fcom%2Faxis%2Fsystem%2Fjenkins%2Fplugins%2Fdownstream%2Fyabv%2FBuildFlowAction.java)
{% endhint %}

- get build cause
  ```groovy
  import hudson.model.Cause.UserIdCause
  import org.jenkinsci.plugins.workflow.job.WorkflowRun

  workflowRun build = currentBuild.rawBuild

  println build.getCauses().collect { it.getClass().getCanonicalName() }
  println build.getCauses().collect { it.getClass().getCanonicalName() }.collect { it.tokenize('.').last() }

  println """
    cause                               : ${build.getCauses().toString()}
    cause.getClass()                    : ${build.getCauses().getClass()} : ${build.getCauses().getClass().getCanonicalName()}
    build.getCause( UserIdCause.class ) : ${build.getCause( UserIdCause.class )}
  """
  ```
  - console output
    ```
    [Pipeline] echo
    [hudson.model.Cause.UserIdCause]
    [Pipeline] echo
    [UserIdCause]
    [Pipeline] echo

        cause                               : [hudson.model.Cause$UserIdCause@bf8cb337]
        cause.getClass()                    : class java.util.Collections$UnmodifiableRandomAccessList : java.util.Collections.UnmodifiableRandomAccessList
        build.getCause( UserIdCause.class ) : hudson.model.Cause$UserIdCause@bf8cb337
    ```

- get user id if triggered by manually
  ```groovy
  import hudson.model.Cause.UserIdCause
  import org.jenkinsci.plugins.workflow.job.WorkflowRun

  workflowRun build = currentBuild.rawBuild
  if ( build.getCause(UserIdCause.class) ) {
    println """
      username : ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserName()}
      id       : ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}
      mail     : ${build.getCause(hudson.model.Cause.UserIdCause.class).getUserId()}@domain.com
    """
  }
  ```

  - or
    ```groovy
    import hudson.model.Cause.UserIdCause

    if ( build.getCause(UserIdCause.class) ) {
      println """
        username : ${build.getCause(UserIdCause.class).getUserName()}
        id       : ${build.getCause(UserIdCause.class).getUserId()}
        mail     : ${build.getCause(UserIdCause.class).getUserId()}@domain.com
      """
    }
    ```

- get causedby
  ```groovy
  import org.jenkinsci.plugins.workflow.job.WorkflowRun
  import hudson.model.Cause.*
  import hudson.triggers.TimerTrigger.TimerTriggerCause
  import org.jenkinsci.plugins.workflow.cps.replay.ReplayCause
  import org.jenkinsci.plugins.parameterizedscheduler.ParameterizedTimerTriggerCause
  import org.jenkinsci.plugins.workflow.cps.replay.ReplayCause
  import com.sonyericsson.rebuild.RebuildCause

  def getCasuedBy( workflowRun build = currentBuild.rawBuild ) {
      CauseAction causeAction = currentBuild.rawBuild.getAction(CauseAction.class)
      causeAction.getCauses().each { Cause cause ->
        if ( cause instanceof Cause.UpstreamCause            ) println ( 'by upstream'                  )
        if ( cause instanceof Cause.UserIdCause              ) println ( 'by user'                      )
        if ( cause instanceof ReplayCause                    ) println ( 'by reply'                     )
        if ( cause instanceof RebuildCause                   ) println ( 'by rebuild'                   )
        if ( cause instanceof TimerTriggerCause              ) println ( 'by timer'                     )
        if ( cause instanceof ParameterizedTimerTriggerCause ) println ( 'by ParameterizedTimerTrigger' )
      }
  }
  ```
- gitlab

  <!--sec data-title="gitlab cause" data-id="section0" data-show=true data-collapse=true ces-->
  ```groovy
  currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData()
  // or
  commit = currentBuild.rawBuild.getCause(com.dabsquared.gitlabjenkins.cause.GitLabWebHookCause).getData().getLastCommit()
  ```
  <!--endsec-->


### libs
```groovy
import hudson.model.Cause.*
import hudson.triggers.TimerTrigger.TimerTriggerCause
import org.jenkinsci.plugins.parameterizedscheduler.ParameterizedTimerTriggerCause
import org.jenkinsci.plugins.workflow.cps.replay.ReplayCause
import com.sonyericsson.rebuild.RebuildCause

Boolean byCron( WorkflowRun build = currentBuild.rawBuild ) {
  build.getCause( TimerTriggerCause.class ) && true
}
Boolean byParameterizedCron( WorkflowRun build = currentBuild.rawBuild ) {
  build.getCause( ParameterizedTimerTriggerCause.class ) && true
}
Boolean byTimer( WorkflowRun build = currentBuild.rawBuild ) {
  byCron( build ) || byParameterizedCron( build )
}
Boolean byUpstream( WorkflowRun build = currentBuild.rawBuild ) {
  build.getCause( Cause.UpstreamCause.class ) && true
}
Boolean byUserId( WorkflowRun build = currentBuild.rawBuild ) {
  build.getCause( Cause.UserIdCause.class ) && true
}
Boolean byReplay( WorkflowRun build = currentBuild.rawBuild ) {
  byUserId( build ) && build.getCause( ReplayCause.class )
}
Boolean byRebuild( WorkflowRun build = currentBuild.rawBuild ) {
  byUserId( build ) && build.getCause( RebuildCause.class )
}
```

### GerritCause
{% hint style='tip' %}
> check [imarslo : GerritCause](../script/build.html#gerritcause)
{% endhint %}
