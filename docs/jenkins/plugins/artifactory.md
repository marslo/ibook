
### [allow interactive promotion](https://www.jfrog.com/confluence/display/JFROG/Scripted+Pipeline+Syntax#ScriptedPipelineSyntax-AllowingInteractivePromotionforPublishedBuilds)
```groovy
/**
 * add interactive promotion options
 *
 * @param sourceRepo          the copy-from repo name
 * @param targetRepo          the copy-to repo name
 * @param server              Artifactory.server 'server-id'
 * @param buildInfo           the buildInfo of {@code server}
**/
def addInteractivePromotion( String sourceRepo, String targetRepo, def server, def buildInfo ) {
  def promotionSpec = [
      //Mandatory parameters
      'buildName'          : buildInfo.name,
      'buildNumber'        : buildInfo.number,
      'targetRepo'         : targetRepo,

      //Optional parameters
      'sourceRepo'         : sourceRepo,
      'comment'            : 'promotion with interactive mode',
      'status'             : 'Released',
      'includeDependencies': true,
      'failFast'           : true,
      'copy'               : true
  ]
  Artifactory.addInteractivePromotion server: server, promotionConfig: promotionSpec, displayName: 'promote me'
}
```

- [example](https://raw.githubusercontent.com/jfrog/project-examples/master/jenkins-examples/pipeline-examples/scripted-examples/promotion-example/Jenkinsfile)
  ```groovy
  def publish( String promoteRepo ) {
    server = Artifactory.server SERVER_ID
    uploadSpec = readFile 'jenkins-examples/pipeline-examples/resources/props-upload.json' 
    buildInfo = server.upload spec: uploadSpec
    server.publishBuildInfo buildInfo

    if( promoteRepo ) addInteractivePromotion( "${promoteRepo}-local", promoteRepo, server, buildInfo )
  }
  ```
  - or for download
    ```groovy
    def download( String promoteRepo ) {
      server = Artifactory.server SERVER_ID 
      downloadSpec = readFile 'jenkins-examples/pipeline-examples/resources/props-download.json'
      server.download spec: downloadSpec, buildInfo: buildInfo
      server.publishBuildInfo buildInfo
      if( promoteRepo ) addInteractivePromotion( "${promoteRepo}-local", promoteRepo, server, buildInfo )
    }
    ```
