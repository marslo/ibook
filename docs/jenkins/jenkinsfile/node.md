<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [yaml](#yaml)
  - [with resources](#with-resources)
  - [with `POD_LABEL`](#with-pod_label)
  - [default yaml](#default-yaml)
- [container](#container)
  - [multiple containerTemplate with resource limits](#multiple-containertemplate-with-resource-limits)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:reference:]
> - [kubernetes](https://plugins.jenkins.io/kubernetes/)
> - [Kubernetes plugin](https://www.jenkins.io/doc/pipeline/steps/kubernetes/)
> - [kubernetes sample code](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/test/resources/org/csanchez/jenkins/plugins/kubernetes)
>   - [pipeline](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/test/resources/org/csanchez/jenkins/plugins/kubernetes/pipeline)
>   - [casc](https://github.com/jenkinsci/kubernetes-plugin/tree/master/src/test/resources/org/csanchez/jenkins/plugins/kubernetes/casc)

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

### multiple containerTemplate with resource limits

> [!NOTE|label:add memory and cpu resources in containerTemplate:]
> - [Changing container memory and cpu limits](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/cloudbees-ci-on-modern-cloud-platforms/changing-conatiner-memory-and-cpu-limits)
> - [zh jenkins-kubernetes-plugin](https://github.com/jenkinsci/kubernetes-plugin/blob/db0e6b143898d11ca5ac10a2606f508a73311530/README_zh.md)
> - [Kubernetes plugin](https://www.jenkins.io/doc/pipeline/steps/kubernetes/#kubernetes-plugin)
> - TIPS
>   - the `jnlp` container template will be enabled by default, however it contains only `requests`:
>     ```yaml
>     ---
>     apiVersion: "v1"
>     kind: "Pod"
>     metadata:
>       annotations:
>         buildUrl: "https://jenkins.domain.com/job/devops/job/demo/job/container/7/"
>         runUrl: "job/devops/job/demo/job/container/7/"
>       labels:
>         jenkins: "slave"
>         jenkins/label-digest: "a170798a479a410811c24bd8c3bacac0dd709dff"
>         jenkins/label: "devops_demo_container_7-7gfwb"
>       name: "devops-demo-container-7-7gfwb-tjkzm-kfn2m"
>       namespace: "marslo-test"
>     spec:
>       containers:
>       - command:
>         - "cat"
>         image: "maven:3.3.9-jdk-8-alpine"
>         imagePullPolicy: "IfNotPresent"
>         name: "maven"
>         resources:
>           limits:
>             memory: "1024Mi"
>             cpu: "512m"
>           requests:
>             memory: "512Mi"
>             cpu: "256m"
>         tty: true
>         volumeMounts:
>         - mountPath: "/home/jenkins/agent"
>           name: "workspace-volume"
>           readOnly: false
>       - command:
>         - "cat"
>         image: "golang:1.8.0"
>         imagePullPolicy: "IfNotPresent"
>         name: "golang"
>         resources:
>           limits:
>             memory: "1024Mi"
>             cpu: "512m"
>           requests:
>             memory: "512Mi"
>             cpu: "256m"
>         tty: true
>         volumeMounts:
>         - mountPath: "/home/jenkins/agent"
>           name: "workspace-volume"
>           readOnly: false
>       - env:
>         - name: "JENKINS_SECRET"
>           value: "********"
>         - name: "JENKINS_AGENT_NAME"
>           value: "devops-demo-container-7-7gfwb-tjkzm-kfn2m"
>         - name: "JENKINS_WEB_SOCKET"
>           value: "true"
>         - name: "JENKINS_NAME"
>           value: "devops-demo-container-7-7gfwb-tjkzm-kfn2m"
>         - name: "JENKINS_AGENT_WORKDIR"
>           value: "/home/jenkins/agent"
>         - name: "JENKINS_URL"
>           value: "https://jenkins.domain.com/"
>         image: "jenkins/inbound-agent:3206.vb_15dcf73f6a_9-2"
>         name: "jnlp"
>         resources:
>           requests:
>             memory: "256Mi"
>             cpu: "100m"
>         volumeMounts:
>         - mountPath: "/home/jenkins/agent"
>           name: "workspace-volume"
>           readOnly: false
>       nodeSelector:
>         jenkins.builder/loc: "dc5"
>       restartPolicy: "Never"
>       volumes:
>       - emptyDir:
>           medium: ""
>         name: "workspace-volume"
>     ```

```bash
podTemplate( cloud: 'DevOps Kubernetes',
             namespace: 'devops',
             nodeSelector: 'jenkins.builder/loc=dc5',
             containers: [
               containerTemplate(
                 name: 'maven',
                 image: 'maven:3.3.9-jdk-8-alpine',
                 ttyEnabled: true,
                 command: 'cat',
                 resourceRequestCpu: '256m',
                 resourceLimitCpu: '512m',
                 resourceRequestMemory: '512Mi',
                 resourceLimitMemory: '1024Mi'
               ),
               containerTemplate(
                 name: 'golang',
                 image: 'golang:1.8.0',
                 ttyEnabled: true,
                 command: 'cat',
                 resourceRequestCpu: '256m',
                 resourceLimitCpu: '512m',
                 resourceRequestMemory: '512Mi',
                 resourceLimitMemory: '1024Mi'
               ),
               containerTemplate(
                 name: 'jnlp',
                 image: 'jenkins/inbound-agent',
                 ttyEnabled: true,
                 resourceRequestCpu: '256m',
                 resourceLimitCpu: '512m',
                 resourceRequestMemory: '512Mi',
                 resourceLimitMemory: '1024Mi'
               )
             ]
) {
    node(POD_LABEL) {
      stage('maven') {
        container('maven') {
          sh """ which -a mvn """
        }
      }
      stage('golang') {
        container('golang') {
          sh """ which -a go """
        }
      }
    }
}
```
