<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [build stage](#build-stage)
  - [show build stages details](#show-build-stages-details)
  - [get parent stage ID](#get-parent-stage-id)
  - [get stage build status via parent stage name](#get-stage-build-status-via-parent-stage-name)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



# build stage

> [!NOTE|label:references:]
> - [Access Stage results in Workflow/ Pipeline plugin](https://stackoverflow.com/a/59854515/2940319)
> - [pipeline中任务分段日志获取](https://gingkoleaf.github.io/2019/10/22/jenkins/jenkins-pipeline-stage-log/)
> - [GuillaumeSmaha/build-stages-status.groovy](https://gist.github.com/GuillaumeSmaha/fdef2088f7415c60adf95d44073c3c88)
> - [Access Stage name during the build in Jenkins pipeline](https://stackoverflow.com/a/45224119/2940319)
> - [jenkinsci/plugins/workflow/cps/FlowDurabilityTest.java](https://github.com/jenkinsci/workflow-cps-plugin/blob/master/src/test/java/org/jenkinsci/plugins/workflow/cps/FlowDurabilityTest.java#L273)

## show build stages details
```groovy
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.flow.*
import io.jenkins.blueocean.rest.impl.pipeline.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.workflow.graph.FlowNode;

final String JOB_NAME  = '/marslo/sandbox'
final int BUILD_NUMBER = 17

WorkflowRun run = Jenkins.instance
                   .getItemByFullName( JOB_NAME )
                   .getBuildByNumber( BUILD_NUMBER )
PipelineNodeGraphVisitor visitor = new PipelineNodeGraphVisitor(run)
List<FlowNodeWrapper> flowNodes = visitor.getPipelineNodes()


flowNodes.each {
  println """
    ${it.getDisplayName()} :
                          getRun() : ${it.getRun()}
                         getResult : ${it.status.getResult()}
                          getState : ${it.status.getState()}
                           getType : ${it.getType()}
                             getId : ${it.getId()}
                          isActive : ${it.node.active}
                         searchUrl : ${it.node.getSearchUrl()}
                            getUrl : ${Jenkins.instance.getRootUrl() + it.node.getUrl()}
                         iconColor : ${it.node.getIconColor()}
  """
// println """
//                         getError : ${it.node.getError()}
//                        getAction : ${it.node.getActions()}
//           getDisplayFunctionName : ${it.node.getDisplayFunctionName()}
//               getTypeDisplayName : ${it.node.getTypeDisplayName()}
//              getTypeFunctionName : ${it.node.getTypeFunctionName()}
//   it.node.metaClass.methods.name : ${it.node.metaClass.methods*.name.sort().unique()}
//                    it.getClass() : ${it.getClass()}
// """
  println "                       parents : " + it.getParents().collect { p ->
    [
        'name' : p.displayName,
      'status' : p.status.getResult(),
          'id' : p.id,
      'active' : p.node.active
    ]
  }.flatten()
  println '--------------'
}
```

- result
  ![build-stage-details](../../screenshot/jenkins/build-stage-details.png)

## get parent stage ID
```groovy
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.flow.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.workflow.graph.FlowNode;
import io.jenkins.blueocean.rest.impl.pipeline.*
import io.jenkins.blueocean.rest.model.*
import io.jenkins.blueocean.rest.model.BlueRun.*

def withFlowNodes( String name, int buildNumber, Closure body ) {
  WorkflowRun run = Jenkins.instance
                           .getItemByFullName( name )
                           .getBuildByNumber( buildNumber )
  PipelineNodeGraphVisitor visitor = new PipelineNodeGraphVisitor( run )
  List<FlowNodeWrapper> flowNodes  = visitor.getPipelineNodes()

  body( flowNodes )
}

def isStageFinished( String keyword, String job, int buildNumber, String type = 'parallel' ) {
  withFlowNodes ( job, buildNumber ) { flowNodes ->

    List<String> parentIds = flowNodes.findAll {
                               it.displayName.startsWith(keyword) && it.getType() == FlowNodeWrapper.NodeType.valueOf( type.toUpperCase() )
                             }.collectMany { it.parents.collect{ p -> p.id } }.unique()
    flowNodes.findAll { parentIds.contains( it.id ) }.every { it.status.getState() == BlueRun.BlueRunState.FINISHED }

  } // withFlowNodes
}
```

## get stage build status via parent stage name

```groovy
import org.jenkinsci.plugins.workflow.job.*
import org.jenkinsci.plugins.workflow.flow.*
import org.jenkinsci.plugins.workflow.cps.*
import org.jenkinsci.plugins.workflow.graph.FlowNode;
import io.jenkins.blueocean.rest.impl.pipeline.*
import io.jenkins.blueocean.rest.model.*
import io.jenkins.blueocean.rest.model.BlueRun.*

@NonCPS
def on( String job, int buildNumber ) {
  [
    isBuilding : { ->
      isBuilding( job, buildNumber )
    }
    stageStatus : { String keyword, String type = 'parallel', String parentStage = 'Parallel' ->
      stageStatus ( keyword, job, buildNumber, type, parentStage )
    }
  ]
}

Boolean isBuilding( String job, int buildNumber ) {
  Jenkins.instance
         .getItemByFullName( job )
         .getBuildByNumber( buildNumber )
         .isInProgress()
}

def withFlowNodes( String name, int buildNumber, Closure body ) {
  WorkflowRun run = Jenkins.instance
                           .getItemByFullName( name )
                           .getBuildByNumber( buildNumber )
  PipelineNodeGraphVisitor visitor = new PipelineNodeGraphVisitor( run )
  List<FlowNodeWrapper> flowNodes  = visitor.getPipelineNodes()

  body( flowNodes )
}

def stageStatus( String keyword ,
                 String job ,
                 int buildNumber ,
                 String type = 'parallel' ,
                 String parentStage = 'Parallel'
) {

  if ( ! isBuilding(job, buildNumber) ) {
    println( "pipeline ${job} #${buildNumber} haven't started yet" )
    return false
  }

  withFlowNodes ( job, buildNumber ) { flowNodes ->
    List<String> parentIds = flowNodes.findAll {
                               it.displayName.startsWith(keyword) && it.getType() == FlowNodeWrapper.NodeType.valueOf( type.toUpperCase() )
                             }.collectMany { it.parents.findAll { p -> p.displayName == parentStage }
                                                       .collect { p -> p.id }
                             }.unique()

    return parentIds
        ? flowNodes.findAll { parentIds.contains( it.id ) }.collect { it.status.getState() }
        : false
  } // withFlowNodes

}

// call
on( BUILD_NAME, BUILD_NUMBER ).stageStatus( stageName )
```
