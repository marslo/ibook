<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [dsl in jenkinsfile](#dsl-in-jenkinsfile)
  - [create folder](#create-folder)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [* jenkinsci/job-dsl-plugin](https://github.com/jenkinsci/job-dsl-plugin/tree/master/docs)
>   - [User Power Moves](https://github.com/jenkinsci/job-dsl-plugin/wiki/User-Power-Moves#use-job-dsl-in-pipeline-scripts)
>   - [Run a DSL Script locally](https://github.com/jenkinsci/job-dsl-plugin/blob/master/docs/User-Power-Moves.md#list-the-files-in-a-jenkins-jobs-workspace)
>   - [Job DSL Commands](https://github.com/jenkinsci/job-dsl-plugin/wiki/Job-DSL-Commands)
>   - [Talks and Blog Posts](https://github.com/jenkinsci/job-dsl-plugin/wiki/Talks-and-Blog-Posts)
>   - [Real World Examples](https://github.com/jenkinsci/job-dsl-plugin/wiki/Real-World-Examples)
>   - [Testing DSL Scripts](https://github.com/jenkinsci/job-dsl-plugin/wiki/Testing-DSL-Scripts)
> - [* Jenkins DSL seed job](https://technotes.adelerhof.eu/jenkins/jenkins-dsl-seed-job/)
> - [Jenkins Tutorial](https://www.happycoders.eu/?s=Jenkins+Tutorial)
>   - [* Jenkins Tutorial: Implementing a Seed Job](https://www.happycoders.eu/devops/jenkins-tutorial-implementing-seed-job/)
>   - [* Jenkins Tutorial: Creating Jobs with the Jenkins Job DSL](https://www.happycoders.eu/devops/jenkins-tutorial-create-jobs-with-job-dsl/)
> - [* User Power Moves](https://github.com/jenkinsci/job-dsl-plugin/wiki/User-Power-Moves#use-job-dsl-in-pipeline-scripts)
>   - [Use Job DSL in Pipeline scripts](https://github.com/jenkinsci/job-dsl-plugin/wiki/User-Power-Moves#use-job-dsl-in-pipeline-scripts)
> - [* Getting Started With Jenkins Job DSL Plugin for Standardising Your Pipelines](https://www.jvt.me/posts/2021/02/23/getting-started-jobdsl-standardised/)
>   - [jamietanna/job-dsl-example](https://gitlab.com/jamietanna/job-dsl-example)
>   - [Configuring a Jenkins Multibranch Pipeline to Specify the Trust Permissions with Job DSL](https://www.jvt.me/posts/2021/05/10/job-dsl-multibranch-github-trust/)
>   - [Building a Multibranch Pipeline on a Schedule](https://www.jvt.me/posts/2021/04/26/jenkins-schedule-multibranch/)
>   - [Ensuring Consistent Code Style with Job DSL Repos](https://www.jvt.me/posts/2021/03/12/jobdsl-spotless/)
>   - [Configuring a Jenkins Multibranch Pipeline to Use an External Script with Job DSL](https://www.jvt.me/posts/2019/12/06/jenkins-job-dsl-multibranch-external-script/)
> - [* Jenkins DSL seed job](https://technotes.adelerhof.eu/jenkins/jenkins-dsl-seed-job/)
> - [Jenkins: 使用groovy + job-dsl 创建并触发job](http://t.zoukankan.com/learnbydoing-p-6734525.html)
> - [Jenkins Job DSL API](https://jenkinsci.github.io/job-dsl-plugin/)
> - [Groovy DSL is not working](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/why-are-my-dsl-groovy-scripts-not-working)
> - [job-dsl-plugin/src/test/groovy/javaposse/jobdsl/plugin/ExecuteDslScriptsSpec.groovy](https://github.com/jenkinsci/job-dsl-plugin/blob/master/job-dsl-plugin/src/test/groovy/javaposse/jobdsl/plugin/ExecuteDslScriptsSpec.groovy)
> - [Using Jenkins Job DSL plugin to automatically create and configure projects with Perforce](https://portal.perforce.com/s/article/14981)
> - [Jenkins-as-code](https://marcesher.com/?s=jenkins-as-code)
>   - [Jenkins-as-code: job-dsl-plugin](https://marcesher.com/2016/06/09/jenkins-as-code-job-dsl/)
>   - [Jenkins-as-code: comparing job-dsl and Pipelines](https://marcesher.com/2016/08/04/jenkins-as-code-comparing-job-dsl-and-pipelines/)
>   - [Jenkins-as-code: registering jobs for automatic seed job creation](https://marcesher.com/2016/06/21/jenkins-as-code-registering-jobs-for-automatic-seed-job-creation/)
> - [How To Automate Jenkins Setup with Docker and Jenkins Configuration as Code](https://www.digitalocean.com/community/tutorials/how-to-automate-jenkins-setup-with-docker-and-jenkins-configuration-as-code)
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

- or via `ExecuteDslScripts`
  ```groovy
  step ([
    $class: 'ExecuteDslScripts' ,
      scriptText: """
        pipelineJob('dsl/guardian/demo') {
          definition {
            cpsScm {
              scm {
                git {
                  remote { github('jenkinsci/pipeline-examples') }
                }
              }
              scriptPath( 'declarative-examples/simple-examples/environmentInStage.groovy' )
            }
          }
        }
      """.stripIndent() ,
      sandbox: true
    ]) // steps
  ```

### create folder
```groovy
timestamps { ansiColor('xterm') {
  node('built-in') {

    jobDsl (
      ignoreExisting: true,
      sandbox: true,
      scriptText: '''folder(\'dsl\') {
        displayName(\'dsl\')
        description(\'for dsl demo\')
      }'''
    )

  } // node
}} // ansiColor | timestamps
```
- or via `ExecuteDslScripts`
  ```groovy
  step([
    $class: 'ExecuteDslScripts',
        scriptText: """
          folder('dsl/guardian') {
            displayName('guardian')
            description('for dsl guardian demo')
          }
        """ ,
        lookupStrategy: 'JENKINS_ROOT',
        removedJobAction: 'DELETE',
        removedViewAction: 'DELETE',
        sandbox: true
  ])
  ```
