<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [show Jira icon in build page](#show-jira-icon-in-build-page)
- [sample](#sample)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [DevOps Use case: Jira Jenkins Integration](https://medium.com/@shrut_terminator/devops-usecase-jira-jenkins-integration-4051413446a9)
> - [gravito/jenkinstest](https://github.com/gravito/jenkinstest/tree/master/provisioning/aws)

## show Jira icon in build page
```groovy
manager.createSummary( 'https://cyclr.com/wp-content/uploads/2022/03/ext-522.png' )
       .appendText ( 'test' )
```

## sample

```groovy
#!/usr/bin/env groovy
def buildInfra
def reason
def flag
def messaging

pipeline {
    agent any
    stages {
             stage ('setting flag') {
        steps {
             script {
                 flag = "CF"
                }
              }
           }
        stage("Build1") {
            steps {
            script {
                try {
                build(
                    job: 'test', parameters: [string(name:'FLAG',value: flag),string(name: 'JIRA_ISSUE_KEY', value: JIRA_ISSUE_KEY), string(name:'GIT_BRANCH',value: GIT_BRANCH), string(name:'JENKINS_PARAMETER',value: JENKINS_PARAMETER), string(name:'BUILD',value: BUILD)]
                )
                } catch (err)
                {
                    echo err.getMessage()
                    echo "Error detected, but we will continue."
                    currentBuild.result = 'UNSTABLE'
                }
              }
            }
          }

stage ("Transition issue")
        {
            steps {
                script {
                    def transitionInput = [transition: [id: '81']]
                    jiraTransitionIssue idOrKey: JIRA_ISSUE_KEY, input: transitionInput, site: 'JIRA'
                }
              }
            }
        stage("Get Instructions") {
            steps {
                    git url: 'https://github.com/gravito/jenkinstest.git'
                    dir ("provisioning/aws/"){
                    script {
                    if (flag == "TF")
                    {
                        echo "Present Flag is for TERRAFORM"
                    }
                    else
                    {
                        echo "Present Flag is for CLOUDFORMATION"
                    }
                  }
                    sh "cat recipe.txt"
                }
              }
            }
        stage ("Update build status"){
            steps {
               script {
                 try {
                      buildInfra = input message: 'Is build successful', parameters: [[$class: 'ChoiceParameterDefinition', choices:'Yes\nNo', description: 'If build successful, click on Yes. Else, click on No', name: 'Build Successful?']]
                   }
                 catch (err) {
                      buildInfra = true
                 }
              }
            }
        }
        stage ("Send back build status"){
            steps {
                script {
            if (buildInfra == 'Yes')
                 {
                def fixedInBuild = [fields: [customfield_10011: 'Build is successful. Find additional comments in Comment Box']]
                def transitionInput = [transition: [id: '81']]
                jiraTransitionIssue idOrKey: JIRA_ISSUE_KEY, input: transitionInput, site: 'JIRA'
                jiraEditIssue idOrKey: JIRA_ISSUE_KEY, issue: fixedInBuild, site: 'JIRA'
                messaging = input message: 'Any additional comments?', parameters: [text(defaultValue: '', description: 'Enter any additional comments', name: 'COMMENT')]
                jiraAddComment comment: messaging, idOrKey: JIRA_ISSUE_KEY, site: 'JIRA'
                }
            else
            {
                def fixedInBuild = [fields: [customfield_10011: 'Build Failed. Find reasons in Comment Box']]
                def transitionInput = [transition: [id: '41']]
                jiraTransitionIssue idOrKey: JIRA_ISSUE_KEY, input: transitionInput, site: 'JIRA'
                jiraEditIssue idOrKey: JIRA_ISSUE_KEY, issue: fixedInBuild, site: 'JIRA'
                messaging = input message: 'Why did the build fail?', parameters: [text(defaultValue: '', description: 'Enter reasons for build failure', name: 'COMMENT')]
                jiraAddComment comment: messaging, idOrKey: JIRA_ISSUE_KEY, site: 'JIRA'
            }
           }
          }
        }
      }
    }
```

- for aws
  ```bash
  #!/bin/bash
  sudo su
  cd test
  rm -rf *
  FLAG="CF"
  if [ "$FLAG" == "TF" ]
  then
  wget $GIT_BRANCH
  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [[ $JENKINS_PARAMETER =~ $regex ]]
    then
      wget $JENKINS_PARAMETER
      string2="$(cut -d/ -f9 <<< $JENKINS_PARAMETER)"
      extension="$(cut -d. -f2 <<< $string2)"
      if [ "$extension" == "csv" ]
        then
                while IFS=, read -r col1 col2
          do
            echo "$col1=\"$col2\"" >> awsparam.properties
          done < $string2
              else
                mv $string2 awsparam.properties
      fi
          JENKINS_PARAMETER=$(cat awsparam.properties)
    else
      echo $JENKINS_PARAMETER > awsparam.properties
  fi

  if [ "$BUILD" == "AWS - EC2" ]
    then
      \cp -rf /var/lib/jenkins/workspace/test_param/provisioning/aws/keys/ec2key.txt .
          input="ec2key.txt"
    else
      \cp -rf /var/lib/jenkins/workspace/test_param/provisioning/aws/keys/rdskey.txt .
          input="rdskey.txt"
  fi

  while IFS= read -r var
  do
     if [[ $JENKINS_PARAMETER =~ $var ]] ; then
        echo "$var parameter is correct"
       else
           echo "$var parameter is missing/incorrect"
           exit 1
       fi
  done < "$input"

  rm -rf ../terra/*.tf
  rm -rf ../terra/.terraform
  rm -rf ../terra/*.tfstate
  rm -rf ../terra/*.tfstate.backup
  rm -rf ../terra/tfplan
  \cp -rf *.tf ../terra/

  else
  cd ../cloudformation/
  rm -rf *
  wget $GIT_BRANCH
  regex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
  if [[ $JENKINS_PARAMETER =~ $regex ]]
    then
      wget $JENKINS_PARAMETER
      string2="$(cut -d/ -f9 <<< $JENKINS_PARAMETER)"
      mv $string2 awsparam.json
          JENKINS_PARAMETER=$(cat awsparam.json)
    else
      echo $JENKINS_PARAMETER > data.txt
          tr -d $'\r' < data.txt > test.txt
          test=$(cat test.txt)
      for word in $test
      do
      echo $word >> correct.txt
      done
          jq -Rs '[ split("\n")[] | select(length > 0) | split("=") | {ParameterKey: .[0], ParameterValue: .[1]} ]' correct.txt > awsparam.json
  fi


  if [ "$BUILD" == "AWS - EC2" ]
    then
      \cp -rf /var/lib/jenkins/workspace/test_param/provisioning/aws/keys/ec2cfkey.txt .
          input="ec2cfkey.txt"
          body="ec2.json"
    else
      \cp -rf /var/lib/jenkins/workspace/test_param/provisioning/aws/keys/rdscfkey.txt .
          input="rdscfkey.txt"
          body="rds.yaml"
  fi

  while IFS= read -r var
  do
     if [[ $JENKINS_PARAMETER =~ $var ]] ; then
        echo "$var parameter is correct"
       else
           echo "$var parameter is missing/incorrect"
           exit 1
       fi
  done < "$input"

  stackname=$(head /dev/urandom | tr -dc A-Za-z | head -c 3 ; echo '')
  aws cloudformation create-stack --stack-name $stackname --template-body file://$body --parameters file://awsparam.json --region ap-south-1
  fi
  ```
