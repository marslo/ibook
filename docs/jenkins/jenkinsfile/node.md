<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [yaml](#yaml)
  - [with resources](#with-resources)
  - [with `POD_LABEL`](#with-pod_label)
  - [default yaml](#default-yaml)
- [container](#container)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [kubernetes](https://plugins.jenkins.io/kubernetes/)
> - [Kubernetes plugin](https://www.jenkins.io/doc/pipeline/steps/kubernetes/)

## yaml
```groovy
#!/usr/bin/env groovy

import groovy.transform.Field

@Field final String CLUSTER = 'DevOps Kubernetes'
@Field final String NAMESPACE = 'devops'
String label = env.BUILD_TAG

ansiColor('xterm') { timestamps {
  podTemplate(
    label: label ,
    cloud: CLUSTER ,
    namespace: NAMESPACE ,
    showRawYaml: true,
    yaml: """
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          jenkins: jnlp-inbound-agent
      spec:
        hostNetwork: true
        nodeSelector:
          <label_name>: "<value>"
        containers:
        - name: jnlp
          image: jenkins/inbound-agent:latest
          workingDir: /home/jenkins
          tty: true
    """
  ) { node (label) { container(name:'jnlp', shell:'/bin/bash') {
      stage('prepare') {
        sh """
          whoami
          pwd
          realpath ${WORKSPACE}
        """
      } // stage
  }}} // container | node | podTemplate
}} // timestamp | ansiColor

// vim: ft=Jenkinsfile ts=2 sts=2 sw=2 et
```

### with resources
```groovy
#!/usr/bin/env groovy

import groovy.transform.Field

@Field final String CLUSTER = 'Jenkins Kubernetes'
@Field final String NAMESPACE = 'jenkins'
String label = env.BUILD_TAG

ansiColor('xterm') { timestamps {
  podTemplate(
    label: label ,
    cloud: CLUSTER ,
    namespace: NAMESPACE ,
    showRawYaml: true,
    yaml: """
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          jenkins: jnlp-inbound-agent
      spec:
        hostNetwork: true
        nodeSelector:
          <label_name>: "<value>"
        containers:
        - name: jnlp
          image: jenkins/inbound-agent:latest
          workingDir: /home/jenkins
          tty: true
          resources:
            limits:
              memory: 1Gi
              cpu: 1
            requests:
              memory: 500Mi
              cpu: 0.5
    """
  ) { node (label) { container(name:'jnlp', shell:'/bin/bash') {
      stage('prepare') {
        sh """
          whoami
          pwd
        """
      } // stage
  }}} // container | node | podTemplate
}} // timestamp | ansiColor

// vim: ft=Jenkinsfile ts=2 sts=2 sw=2 et
```

### with `POD_LABEL`
```groovy
#!/usr/bin/env groovy

import groovy.transform.Field

@Field final String CLUSTER = 'Jenkins Kubernetes'
@Field final String NAMESPACE = 'jenkins'

ansiColor('xterm') { timestamps {
  podTemplate(
    cloud: CLUSTER ,
    namespace: NAMESPACE ,
    showRawYaml: true,
    yaml: """
      apiVersion: v1
      kind: Pod
      metadata:
        labels:
          jenkins: jnlp-inbound-agent
      spec:
        hostNetwork: true
        nodeSelector:
          <label_name>: "<value>"
        containers:
        - name: jnlp
          image: jenkins/inbound-agent:latest
          workingDir: /home/jenkins
          tty: true
          resources:
            limits:
              memory: 1Gi
              cpu: 1
            requests:
              memory: 500Mi
              cpu: 0.5
    """
  ) { node (POD_LABEL) { container(name:'jnlp', shell:'/bin/bash') {
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
  }}} // container | node | podTemplate
}} // timestamp | ansiColor

// vim: ft=Jenkinsfile ts=2 sts=2 sw=2 et
```

### default yaml
```groovy
podTemplate(cloud: 'DevOps Kubernetes') {
  node(POD_LABEL) {
    stage('Run shell') {
      sh 'echo hello world'
    }
  }
}
```
- windows (kubernetes)
  ```groovy
  /*
   * Runs a build on a Windows pod.
   * Tested in EKS: https://docs.aws.amazon.com/eks/latest/userguide/windows-support.html
   */
  podTemplate(yaml: '''
  apiVersion: v1
  kind: Pod
  spec:
    containers:
    - name: jnlp
      image: jenkins/inbound-agent:windowsservercore-1809
    - name: shell
      image: mcr.microsoft.com/powershell:preview-windowsservercore-1809
      command:
      - powershell
      args:
      - Start-Sleep
      - 999999
    nodeSelector:
      kubernetes.io/os: windows
  ''') {
      node(POD_LABEL) {
          container('shell') {
              powershell 'Get-ChildItem Env: | Sort Name'
          }
      }
  }
  ```

- maven (kubernetes)
  ```bash
  // Build a Maven project using the standard image and Scripted syntax.
  // Rather than inline YAML, you could use: yaml: readTrusted('jenkins-pod.yaml')
  // Or, to avoid YAML: containers: [containerTemplate(name: 'maven', image: 'maven:3.6.3-jdk-8', command: 'sleep', args: 'infinity')]
  podTemplate(yaml: '''
  apiVersion: v1
  kind: Pod
  spec:
    containers:
    - name: maven
      image: maven:3.6.3-jdk-8
      command:
      - sleep
      args:
      - infinity
  ''') {
      node(POD_LABEL) {
          // or, for example: git 'https://github.com/jglick/simple-maven-project-with-tests'
          writeFile file: 'pom.xml', text: '''
  <project xmlns="http://maven.apache.org/POM/4.0.0">
      <modelVersion>4.0.0</modelVersion>
      <groupId>sample</groupId>
      <artifactId>sample</artifactId>
      <version>1.0-SNAPSHOT</version>
      <build>
          <plugins>
              <plugin>
                  <groupId>org.apache.maven.plugins</groupId>
                  <artifactId>maven-surefire-plugin</artifactId>
                  <version>2.18.1</version>
              </plugin>
          </plugins>
      </build>
      <dependencies>
          <dependency>
              <groupId>junit</groupId>
              <artifactId>junit</artifactId>
              <version>4.12</version>
              <scope>test</scope>
          </dependency>
      </dependencies>
      <properties>
          <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
          <maven.compiler.source>1.8</maven.compiler.source>
          <maven.compiler.target>1.8</maven.compiler.target>
      </properties>
  </project>
          '''
          writeFile file: 'src/test/java/sample/SomeTest.java', text: '''
  package sample;
  public class SomeTest {
      @org.junit.Test
      public void checks() {}
  }
          '''
          container('maven') {
              sh 'mvn -B -ntp -Dmaven.test.failure.ignore verify'
          }
          junit '**/target/surefire-reports/TEST-*.xml'
          archiveArtifacts '**/target/*.jar'
      }
  }
  ```

## container
```groovy
podTemplate(cloud: 'DevOps Kubernetes', containers: [
  containerTemplate(
    name: 'jnlp',
    image: 'jenkins/inbound-agent:latest',
    ttyEnabled: true,
    privileged: false,
    alwaysPullImage: false,
    workingDir: '/home/jenkins'
  )
]) { node(POD_LABEL) {
    stage ('run') {
      echo 'yes!'
      sh """
        id
        whoami
        echo ${WORKSPACE}
        realpath ${WORKSPACE}
      """
    }
}}
```
