<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [dsl in jenkinsfile](#dsl-in-jenkinsfile)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->





{% hint style='tip' %}
> references:
> - [* Jenkins Tutorial: Implementing a Seed Job](https://www.happycoders.eu/devops/jenkins-tutorial-implementing-seed-job/)
> - [* User Power Moves](https://github.com/jenkinsci/job-dsl-plugin/wiki/User-Power-Moves#use-job-dsl-in-pipeline-scripts)
>   - [Use Job DSL in Pipeline scripts](https://github.com/jenkinsci/job-dsl-plugin/wiki/User-Power-Moves#use-job-dsl-in-pipeline-scripts)
> - [Jenkins Tutorial: Creating Jobs with the Jenkins Job DSL](https://www.happycoders.eu/devops/jenkins-tutorial-create-jobs-with-job-dsl/)
> - [* Jenkins DSL seed job](https://technotes.adelerhof.eu/jenkins/jenkins-dsl-seed-job/)
> - [Jenkins: 使用groovy + job-dsl 创建并触发job](http://t.zoukankan.com/learnbydoing-p-6734525.html)
> - [Jenkins Job DSL API](https://jenkinsci.github.io/job-dsl-plugin/)
> - [Groovy DSL is not working](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/why-are-my-dsl-groovy-scripts-not-working)
{% endhint %}

## dsl in jenkinsfile
```groovy
timestamps { ansiColor('xterm') {
  node('built-in') {

    jobDsl (
      sandbox: true,
      scriptText: '''
        pipelineJob(\'github-demo\') {
          definition {
            cpsScm {
              scm {
                git {
                  remote { github(\'jenkinsci/pipeline-examples\') }
                }
              }
              scriptPath(\'declarative-examples/simple-examples/environmentInStage.groovy\')
            }
          }
        }
      '''
    ) // jobDsl

  } // node
}} // ansiColor | timestamps
```
