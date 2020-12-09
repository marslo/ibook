<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [container](#container)
- [yaml](#yaml)
  - [default yaml](#default-yaml)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [kubernetes](https://plugins.jenkins.io/kubernetes/)

## container
```groovy
podTemplate(cloud: 'devops kubernetes', containers: [
  containerTemplate(
    name: 'jnlp',
    image: 'jenkins/jnlp-slave:latest',
    ttyEnabled: true,
    privileged: false,
    alwaysPullImage: false,
    workingDir: '/home/jenkins'
  )
]) {
  node(POD_LABEL) {
    stage ('info') {
      echo 'yes!'
      sh """
        id
        whoami
        echo ${WORKSPACE}
        realpath ${WORKSPACE}
      """
    }
  }
}
```

## yaml

```groovy
ansiColor('xterm') { timestamps {
  podTemplate(
      label: env.BUILD_TAG,
      cloud: 'devops kubernetes',
      namespace: 'devops',
      showRawYaml: true,
      yaml: """
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            jenkins: jnlp-slave
        spec:
          containers:
          - name: jnlp
            image: jenkins/jnlp-slave:latest
            customWorkspace: /home/jenkins
            tty: true
      """
  ) { node(label) {
    container(name:'jnlp', shell:'/bin/bash') {
      cleanWs()
      stage('prepare') {
        sh """
          whoami
          pwd
          ls -Altrh /home/
          ls -Altrh /home/jenkins/
          touch a.txt
          realpath ${WORKSPACE}
          realpath a.txt
        """
       } // stage
    } // containers
  }} // node | podTemplate
}} // timestamps | ansiColor

// vim: ft=Jenkinsfile ts=2 sts=2 sw=2 et
```

### default yaml
```groovy
podTemplate(cloud: 'devops kubernetes') {
  node(POD_LABEL) {
    stage('Run shell') {
      sh 'echo hello world'
    }
  }
}
```
