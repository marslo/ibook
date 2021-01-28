<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [parameters](#parameters)
- [active choice parameters](#active-choice-parameters)
- [mixed parameters](#mixed-parameters)
- [Jenkins 2.0 pipeline: Scripting active parameters for SCM](#jenkins-20-pipeline-scripting-active-parameters-for-scm)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
reference:
- [Class ParametersAction](https://javadoc.jenkins-ci.org/hudson/model/ParametersAction.html)
- [Class ParameterValue](https://javadoc.jenkins-ci.org/hudson/model/ParameterValue.html)
- [parameters](https://www.jenkins.io/doc/pipeline/steps/pipeline-input-step/#input-wait-for-interactive-input)
- [Parameterized System Groovy script](https://wiki.jenkins.io/display/JENKINS/Parameterized+System+Groovy+script)
- [How to retrieve Jenkins build parameters using the Groovy API?](https://stackoverflow.com/a/19564602/2940319)
{% endhint %}

### parameters
```groovy
properties([
  parameters([
    string( defaultValue: '', name: 'stringParams', description: '', trim: false ),
    string( defaultValue: 'default', name: 'stringDefaultParams', description: '', trim: false ),
    validatingString( defaultValue: '', name: 'validatingString', regex: '.+', description: 'format: <code>.+</code>', failedValidationMessage: 'cannot be empty' ),
    choice( choices: ['a', 'b', 'c', 'd'], name: 'choiceParams', description: '' ),
    booleanParam( defaultValue: false, name: 'booleanParams', description: '' )
  ])
])
```
![parameters](../../screenshot/jenkins/properties-parameters.gif)

### [active choice parameters](https://plugins.jenkins.io/uno-choice/)
```groovy
properties([
  parameters([
    [
      $class: 'ChoiceParameter',
      name: 'provinces',
      choiceType: 'PT_SINGLE_SELECT',
      description: '',
      script: [
        $class: 'GroovyScript',
        fallbackScript: [classpath: [], sandbox: false, script: '#!groovy return ["accept in ScriptApproval first"]'],
        script: [classpath: [],
                 sandbox: false,
                 script: '''return[
                  \'Gansu\',
                  \'Sichuan\',
                  \'Disabled:disabled\'
                ]'''
        ]
      ]
    ], // ChoiceParameter
    [
      $class: 'CascadeChoiceParameter',
      name: 'cities',
      referencedParameters: 'provinces',
      choiceType: 'PT_CHECKBOX',
      description: '',
      script: [
        $class: 'GroovyScript',
        fallbackScript: [classpath: [], sandbox: false, script: '#!groovy return ["accept in ScriptApproval first"]'],
        script: [classpath: [],
                 sandbox: false,
                 script: '''if (provinces.equals("Gansu")) {
                    return ["Lanzhou", "Dingxi"]
                  } else if (provinces.equals("Sichuan")) {
                    return ["Leshan", "Guangyuan:disabled", "Chengdu:selected"]
                  } else if (provinces.equals("Disabled")) {
                    return ["notshow:selected"]
                  } else {
                    return ["Unknown provinces"]
                  }'''
        ]
    ]], // CascadeChoiceParameter
    [
      $class: 'StringParameterDefinition' ,
      name: 'lastName'  ,
      defaultValue: 'Joe' ,
      description: ''
    ], // StringParameterDefinition
    [
      $class: 'BooleanParameterDefinition',
      name: 'notify',
      defaultValue: false,
      description: ''
    ] // BooleanParameterDefinition
  ])
])
```
![active choice with mixed options](../../screenshot/jenkins/active_choice_mixed.gif)

- or
  ```groovy
  import groovy.transform.Field
  import org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SecureGroovyScript

  @Field def props = []
  @Field def newParams = []
  @Field def fb = new SecureGroovyScript("""return ['Script Error!']""", false)
  @Field def ps = new SecureGroovyScript("""return[ 'Gansu', 'Sichuan', 'Disabled:disabled' ]""", false )
  @Field def cs = new SecureGroovyScript("""#!groovy
    Map citySets = [
          Gansu : ['Lanzhou', 'Dingxi'] ,
        Sichuan : ['Leshan', 'Guangyuan', 'Chengdu:selected'] ,
       Disabled : ['notshow:selected']
    ]
    return citySets[provinces]
  """, false)

  newParams += [$class: 'ChoiceParameter',
                name: 'provinces',
                choiceType: 'PT_SINGLE_SELECT',
                script: [ $class: 'GroovyScript',
                          script: ps,
                          fallbackScript: fb
                ],
                description: ''
               ]
  newParams += [$class: 'CascadeChoiceParameter',
                name: 'cities',
                referencedParameters: 'provinces',
                choiceType: 'PT_CHECKBOX',
                script: [ $class: 'GroovyScript',
                          script: cs,
                          fallbackScript: fb
                ],
                description: ''
               ]
  props += [$class: 'ParametersDefinitionProperty', parameterDefinitions: newParams]
  properties(
    properties: props
  )
  ```
![active choice](../../screenshot/jenkins/active_choice.gif)

### mixed parameters
```groovy
import groovy.transform.Field
import org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SecureGroovyScript

@Field def props = []
@Field def newParams = []
@Field def fb = new SecureGroovyScript("""return ['Script Error!']""", false)
@Field def ps = new SecureGroovyScript("""return[ 'Gansu', 'Sichuan', 'Disabled:disabled' ]""", false )
@Field def cs = new SecureGroovyScript("""#!groovy
  Map citySets = [
        Gansu : ['Lanzhou', 'Dingxi'] ,
      Sichuan : ['Leshan', 'Guangyuan', 'Chengdu:selected'] ,
     Disabled : ['notshow:selected']
  ]
  return citySets[provinces]
""", false)

newParams += [$class: 'StringParameterDefinition' , name: 'lastName'  , defaultValue: 'Joe' , description: '']
newParams += [$class: 'StringParameterDefinition' , name: 'firstName' , defaultValue: 'Dan' , description: '']
newParams += [
                   $class : 'ValidatingStringParameterDefinition',
             defaultValue : '' ,
              description : 'timestamps format: <code>YYMMDDHHMMSS</code>' ,
  failedValidationMessage : 'Cannot be empty or failed by Regex validation !' ,
                     name : 'timeStamps' ,
                    regex : '\\d{2,4}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])(2[0-3]|[01][0-9])[0-5][0-9]\\d{0,2}'
]
newParams += [
                $class : 'ChoiceParameter' ,
                  name : 'provinces' ,
            choiceType : 'PT_SINGLE_SELECT' ,
                script : [
                            $class : 'GroovyScript' ,
                            script : ps ,
                    fallbackScript : fb
              ] ,
           description : ''
]
newParams += [
                $class : 'CascadeChoiceParameter' ,
                  name : 'cities' ,
  referencedParameters : 'provinces' ,
            choiceType : 'PT_CHECKBOX' ,
                script : [
                            $class : 'GroovyScript' ,
                            script : cs ,
                    fallbackScript : fb
                ] ,
           description : ''
]
newParams += [$class: 'BooleanParameterDefinition' , name: 'notify' , defaultValue: false , description: '']

props += [$class: 'ParametersDefinitionProperty' , parameterDefinitions: newParams]
properties( properties: props )

podTemplate(cloud: 'DevOps Kubernetes') {
  node(POD_LABEL) {
    stage('run') {
      println """
          lastName : ${params.lastName}
         firstName : ${params.firstName}
         provinces : ${params.provinces}
            cities : ${params.cities}
            notify : ${params.notify}
        timeStamps : ${params.timeStamps}
      """
    } // stage
  } // node
} // podTemplate
```

### [Jenkins 2.0 pipeline: Scripting active parameters for SCM](https://technology.amis.nl/continuous-delivery/jenkins-2-0-pipeline-scripting-active-parameters-for-scm/)
```groovy
import groovy.transform.Field
import org.jenkinsci.plugins.scriptsecurity.sandbox.groovy.SecureGroovyScript

@Field def props = []
@Field def newParams = []

node('mster') {
  setNewProps()
} // node

void setNewProps() {
  //Parameters are unknown at first load
  try {
    regenerateJob = (params.RegenerateJob == null) ? true : params.RegenerateJob
  }
  catch (MissingPropertyException e) {
    regenerateJob = true
  }

  if (regenerateJob) {
    def fb = new SecureGroovyScript("""return ['Script Error!']""", false)
    def ps = new SecureGroovyScript("""return[ 'Gansu', 'Sichuan', 'Disabled:disabled' ]""", false )
    def cs = new SecureGroovyScript("""#!groovy
      Map citySets = [
            Gansu : ['Lanzhou', 'Dingxi'] ,
          Sichuan : ['Leshan', 'Guangyuan', 'Chengdu:selected'] ,
         Disabled : ['notshow:selected']
      ]
      return citySets[provinces]
    """, false)

    println "Jenkins job ${env.JOB_NAME} gets updated."
    currentBuild.displayName = "#" + Integer.toString(currentBuild.number) + ": Initialize job"

    newParams += [$class: 'StringParameterDefinition' , name: 'lastName'  , defaultValue: 'Joe' , description: '']
    newParams += [$class: 'StringParameterDefinition' , name: 'firstName' , defaultValue: 'Dan' , description: '']
    newParams += [
                       $class : 'ValidatingStringParameterDefinition',
                         name : 'timeStamps' ,
                  description : 'timestamps format: <code>YYMMDDHHMMSS</code>' ,
      failedValidationMessage : 'Cannot be empty or failed by Regex validation !' ,
                 defaultValue : '' ,
                        regex : '\\d{2,4}(0[1-9]|1[0-2])(0[1-9]|[1-2][0-9]|3[0-1])(2[0-3]|[01][0-9])[0-5][0-9]\\d{0,2}'
    ]
    newParams += [
                       $class : 'ChoiceParameter' ,
                         name : 'provinces' ,
                   choiceType : 'PT_SINGLE_SELECT' ,
                       script : [
                                   $class : 'GroovyScript' ,
                                   script : ps ,
                           fallbackScript : fb
                       ] ,
                  description : ''
    ]
    newParams += [
                       $class : 'CascadeChoiceParameter' ,
                         name : 'cities' ,
         referencedParameters : 'provinces' ,
                   choiceType : 'PT_CHECKBOX' ,
                       script : [
                                   $class : 'GroovyScript' ,
                                   script : cs ,
                           fallbackScript : fb
                       ] ,
                  description : ''
    ]
    newParams += [$class: 'BooleanParameterDefinition' , name: 'notify' , defaultValue: false , description: '']

    props += [
                $class : 'BuildDiscarderProperty',
              strategy : [$class: 'LogRotator', daysToKeepStr: '30', artifactDaysToKeepStr: '1', artifactNumToKeepStr: '']
    ]
    props += [$class: 'ParametersDefinitionProperty', parameterDefinitions: newParams]
    properties( properties: props )
  }
}
```
