<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Groovy to list all jobs](#groovy-to-list-all-jobs)
  - [list all Abstract Project](#list-all-abstract-project)
  - [list all jobs and folders](#list-all-jobs-and-folders)
  - [get name and classes](#get-name-and-classes)
  - [find all disabled projects/jobs](#find-all-disabled-projectsjobs)
- [shelve jobs](#shelve-jobs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## [Groovy to list all jobs](https://support.cloudbees.com/hc/en-us/articles/226941767-Groovy-to-list-all-jobs)
### list all Abstract Project
>> Abstract Project: freestyle, maven, etc...

```groovy
Jenkins.instance.getAllItems(AbstractProject.class).each {
  println it.fullName;
}
```

### list all jobs and folders
```groovy
Jenkins.instance.getAllItems(AbstractItem.class).each {
  println(it.fullName)
};
```

### get name and classes
```groovy
Jenkins.instance.getAllItems(Job.class).each {
  println it.name + " - " + it.class
}
```

### find all disabled projects/jobs
```groovy
jenkins.model.Jenkins.instance.getAllItems(jenkins.model.ParameterizedJobMixIn.ParameterizedJob.class).findAll{ it -> it.disabled }.each {
  println it.fullName;
}
```

## [shelve jobs](https://support.cloudbees.com/hc/en-us/articles/236353928-Groovy-Scripts-To-Shelve-Jobs)
```groovy
//You have to install the Shelve Project Plugin on your Jenkins Master
//The maximum value for daysBack is 365, going beyond 365 will break the script.

import org.jvnet.hudson.plugins.shelveproject.ShelveProjectTask

def daysBack=365;
Jenkins.instance.getAllItems(AbstractProject.class).each{ it->
  def lastBuild=it.getLastBuild()
  if(lastBuild != null){
    def back = Calendar.getInstance()
    back.set(Calendar.DAY_OF_YEAR,back.get(Calendar.DAY_OF_YEAR)-daysBack)
    if (lastBuild.getTime().compareTo(back.getTime()) < 0) {
      println it.name + " was built over " + daysBack + " days ago: " + lastBuild.getTime()
      if (it instanceof AbstractProject){
      def spt=  new ShelveProjectTask(it)
        Hudson.getInstance().getQueue().schedule(spt , 0 );
      }else{
        println it.name + " was not shelved----------- "
      }
    }
  }
}
```

## [run shell scripts in a cluster-operation](https://support.cloudbees.com/hc/en-us/articles/360020737392-How-to-run-shell-scripts-in-a-cluster-operation)
```groovy
def exec(cmd) {
  println cmd
  def process = new ProcessBuilder([ "sh", "-c", cmd])
                                    .directory(new File("/tmp"))
                                    .redirectErrorStream(true)
                                    .start()
  process.outputStream.close()
  process.inputStream.eachLine {println it}
  process.waitFor();
  return process.exitValue()
}

[
  "echo hello world",
  "ls -al"
].each {
  exec(it)
}
```
