<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [jenkinsfile](#jenkinsfile)
- [docker registry](#docker-registry)
  - [artifactory](#artifactory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




{% hint style='info' %}
> references:
> - [* org.jenkinsci.plugins.docker.workflow.Docker](https://github.com/jenkinsci/docker-workflow-plugin/blob/master/src/main/resources/org/jenkinsci/plugins/docker/workflow/Docker.groovy)
> - [Docker Pipeline plugin](https://docs.cloudbees.com/docs/admin-resources/latest/plugins/docker-workflow)
> - [CloudBees Docker Traceability](https://docs.cloudbees.com/docs/admin-resources/latest/plugins/docker-traceability)
> - [Docker plugin for Jenkins](https://plugins.jenkins.io/docker-plugin/)
> - [Building your first Docker image with Jenkins 2: Guide for developers](https://tutorials.releaseworksacademy.com/learn/building-your-first-docker-image-with-jenkins-2-guide-for-developers)
{% endhint %}

## jenkinsfile
```groovy
#!/usr/bin/env groovy
import org.jenkinsci.plugins.docker.workflow.Docker

Docker.Image image
String filename  = 'Dockerfile'
String filepath  = '.'
String imageName = 'sandbox:v1'
String buildArgs = ' --no-cache ' +
                   " -f ${filename}" +
                   " ${filepath}/"

docker.withTool( 'devops-docker' ) {
  image = docker.build( imageName, buildArgs )
} // docker.withTool

println image.imageName()
println image.id
```

## docker registry
### artifactory

#### [How to clean up old Docker images](https://jfrog.com/knowledge-base/how-to-clean-up-old-docker-images/)
```python
def clean_docker():

    import requests
    base_url = 'http://localhost:8081/artifactory/'
    headers = {
        'content-type': 'text/plain',
    }
    data = 'items.find({"name":{"$eq":"manifest.json"},"stat.downloaded":{"$before":"4w"}})'
    myResp = requests.post(base_url+'api/search/aql', auth=('admin', 'password'), headers=headers, data=data)
    for result in eval(myResp.text)["results"]:
        artifact_url = base_url+ result['repo'] + '/' + result['path']
        requests.delete(artifact_url, auth=('admin', 'password'))      <----- [[[[[THIS WILL DELETE FILES]]]]]]
if __name__ == '__main__':
    clean_docker()
```

#### [How to Delete Old Docker Images](https://jfrog.com/knowledge-base/how-can-i-delete-docker-images-older-than-a-certain-time-period/)

> [!TIP]
> - [Artifactory Clean Docker Images User Plugin](https://github.com/jfrog/artifactory-user-plugins/blob/master/cleanup/cleanDockerImages/README.md)
> - [Artifactory Artifact Cleanup User Plugin](https://github.com/jfrog/artifactory-user-plugins/tree/master/cleanup/artifactCleanup?_gl=1*c0vjwi*_ga*MTEwNDYyMjkzNS4xNjY4MDgwNjcz*_ga_SQ1NR9VTFJ*MTY2ODEwMTM0MS4yLjEuMTY2ODEwMTUzMy42MC4wLjA.)
> - [devopshq/artifactory-cleanup](https://github.com/devopshq/artifactory-cleanup)
> - [How can I completely remove artifacts from Artifactory?](https://jfrog.com/knowledge-base/how-can-i-completely-remove-artifacts-from-artifactory/)

```bash
$ items.find({“name”:{“$eq”:”manifest.json”},”stat.downloaded”:{“$before”:”4w”}})
```

