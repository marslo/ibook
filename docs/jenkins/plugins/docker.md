<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [jenkinsfile](#jenkinsfile)

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
