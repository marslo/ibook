<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [reference](#reference)
  - [integration with pipeline](#integration-with-pipeline)
  - [aql](#aql)
- [configuration](#configuration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference:
> - [How to enable verbose log on JVM Garbage Collection](https://jfrog.com/knowledge-base/how-to-enable-verbose-log-on-jvm-garbage-collection/)
>   - JAVA_OPTIONS:
>     `-verbose:gc -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -Xloggc:/path/to/file/gc.log`
{% endhint %}

## reference
### integration with pipeline
> - [Scripted Pipeline Syntax](https://www.jfrog.com/confluence/display/JFROG/Scripted+Pipeline+Syntax#ScriptedPipelineSyntax-PromotingBuildsinArtifactory)
> - [Jenkins Pipeline Examples](https://github.com/jfrog/project-examples/tree/master/jenkins-examples/pipeline-examples)

### aql
#### [Jenkins Artifactory Plugin AQL download latest artifact matching pattern](https://stackoverflow.com/a/40351260/2940319)

<!--sec data-title="example" data-id="section2" data-show=true data-collapse=true ces-->
  ```powershell
  $pair = "$($art_user):$($art_pass)"
  Write-Verbose "Attempting to convert Artifactory credentials to a base64 string for automation"
  $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
  $basicAuthValue = "Basic $encodedCreds"
  $headers = @{
      Authorization = $basicAuthValue
  }

  Write-Host "Attempting to perform a AQL search."
  $aql_search = $art_base_url + "/api/search/aql"
  Write-Host "Building aql query with the following parameters, groupID: $group_id, artifactID: $artifact_id, version: $version, classifier: $classifier and repos: $art_generic_repokey."
  $aql_query = 'items.find({"repo":"' + $art_generic_repokey + '","$or":[{"$and":[{"path":{"$match":"' + $group_id + '/' + $artifact_id + '/' + $version + '"},"name":{"$match":"' + $artifact_id + '*' + $classifier + '*.' + $extension + '"}}]}]}).sort({"$desc":["modified"]}).limit(1)'
  Write-Host "Built the following aql query: '$aql_query' ."
  $aql_content = Invoke-RestMethod -Uri $aql_search -Headers $headers -Method Post -Body $aql_query -ContentType 'text/plain'
  Write-Host "Attempting to submit the aql query to the following artifactory server: $art_base_url."
  $aql_results = ($aql_content).results
  Write-Host "Attempting to parse query results and build the artifact download uri."
  $aql_repo,$aql_path,$aql_name = ($aql_results).repo,($aql_results).path,($aql_results).name
  $artifactDownloadUri = $art_base_url + '/' + $aql_repo + '/' + $aql_path + '/' + $aql_name
  Write-Host "Found the following uri: $artifactDownloadUri !!"

  if ($artifactMimeType  -eq 'application/zip' -or $extension -eq 'zip') {
      Write-Verbose "Attempting to save the artifact to $download_dir/$art_dist_name.zip"
      Invoke-RestMethod -Uri $artifactDownloadUri -Headers $headers -OutFile "$download_dir/$art_dist_name.zip"
  }
  ```
<!--endsec-->

## configuration
#### allow partial folder in particular repo
![allow temp && demo, and disallow sprint && weekly](../screenshot/artifactory/repo-permission.png)
