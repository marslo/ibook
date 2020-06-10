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
