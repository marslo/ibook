<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [allow interactive promotion](#allow-interactive-promotion)
- [promotion](#promotion)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

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

### promotion
> [Delete jenkins builds during Promote / promotion step](https://stackoverflow.com/a/18992627/2940319)

<!--sec data-title="promot" data-id="section0" data-show=true data-collapse=true ces-->
```groovy
/*** BEGIN META {
  "name" : "Bulk Delete Builds except the given build number",
  "comment" : "For a given job and a given build numnber, delete all builds of a given release version (M.m.interim) only and except the user provided one. Sometimes a Jenkins job use Build Name setter plugin and same job generates 2.75.0.1 and 2.76.0.43",
  "parameters" : [ 'jobName', 'releaseVersion', 'buildNumber' ],
  "core": "1.409",
  "authors" : [
     { name : "Arun Sangal - Maddys Version" }
  ]
} END META **/

import groovy.json.*
import jenkins.model.*;
import hudson.model.Fingerprint.RangeSet;
import hudson.model.Job;
import hudson.model.Fingerprint;

//these should be passed in as arguments to the script
if(!artifactoryURL) throw new Exception("artifactoryURL not provided")
if(!artifactoryUser) throw new Exception("artifactoryUser not provided")
if(!artifactoryPassword) throw new Exception("artifactoryPassword not provided")
def authString = "${artifactoryUser}:${artifactoryPassword}".getBytes().encodeBase64().toString()
def artifactorySettings = [artifactoryURL: artifactoryURL, authString: authString]

if(!jobName) throw new Exception("jobName not provided")
if(!buildNumber) throw new Exception("buildNumber not provided")

def lastBuildNumber = buildNumber.toInteger() - 1;
def nextBuildNumber = buildNumber.toInteger() + 1;

def jij = jenkins.model.Jenkins.instance.getItem(jobName);

def promotedBuildRange = new Fingerprint.RangeSet()
promotedBuildRange.add(buildNumber.toInteger())
def promoteBuildsList = jij.getBuilds(promotedBuildRange)
assert promoteBuildsList.size() == 1
def promotedBuild = promoteBuildsList[0]
// The release / version of a Jenkins job - i.e. in case you use "Build name" setter plugin in Jenkins for getting builds like 2.75.0.1, 2.75.0.2, .. , 2.75.0.15 etc.
// and over the time, change the release/version value (2.75.0) to a newer value i.e. 2.75.1 or 2.76.0 and start builds of this new release/version from #1 onwards.
def releaseVersion = promotedBuild.getDisplayName().split("\\.")[0..2].join(".")

println ""
println("- Jenkins Job_Name: ${jobName} -- Version: ${releaseVersion} -- Keep Build Number: ${buildNumber}");
println ""

/** delete the indicated build and its artifacts from artifactory */
def deleteBuildFromArtifactory(String jobName, int deleteBuildNumber, Map<String, String> artifactorySettings){
    println "     ## Deleting >>>>>>>>>: - ${jobName}:${deleteBuildNumber} from artifactory"
                                def artifactSearchUri = "api/build/${jobName}?buildNumbers=${deleteBuildNumber}&artifacts=1"
                                def conn = "${artifactorySettings['artifactoryURL']}/${artifactSearchUri}".toURL().openConnection()
                                conn.setRequestProperty("Authorization", "Basic " + artifactorySettings['authString']);
                                conn.setRequestMethod("DELETE")
    if( conn.responseCode != 200 ) {
        println "Failed to delete the build artifacts from artifactory for ${jobName}/${deleteBuildNumber}: ${conn.responseCode} - ${conn.responseMessage}"
    }
}

/** delete all builds in the indicated range that match the releaseVersion */
def deleteBuildsInRange(String buildRange, String releaseVersion, Job theJob, Map<String, String> artifactorySettings){
    def range = RangeSet.fromString(buildRange, true);
    theJob.getBuilds(range).each {
        if ( it.getDisplayName().find(/${releaseVersion}.*/)) {
            println "     ## Deleting >>>>>>>>>: " + it.getDisplayName();
            deleteBuildFromArtifactory(theJob.name, it.number, artifactorySettings)
            it.delete();
        }
    }
}

//delete all the matching builds before the promoted build number
deleteBuildsInRange("1-${lastBuildNumber}", releaseVersion, jij, artifactorySettings)

//delete all the matching builds after the promoted build number
deleteBuildsInRange("${nextBuildNumber}-${jij.nextBuildNumber}", releaseVersion, jij, artifactorySettings)

println ""
println("- Builds have been successfully deleted for the above mentioned release: ${releaseVersion}")
println ""
```
<!--endsec-->