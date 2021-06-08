<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [security](#security)
  - [get securityRealm](#get-securityrealm)
- [authorization strategy](#authorization-strategy)
  - [list all Jenkins supported authorization permissions](#list-all-jenkins-supported-authorization-permissions)
  - [get current authorization strategy class](#get-current-authorization-strategy-class)
  - [get raw authorization and permissions info](#get-raw-authorization-and-permissions-info)
  - [ProjectMatrixAuthorizationStrategy](#projectmatrixauthorizationstrategy)
  - [RoleBasedAuthorizationStrategy](#rolebasedauthorizationstrategy)
- [crumb issuer](#crumb-issuer)
  - [get crumb issuer](#get-crumb-issuer)
  - [set crumb issuer](#set-crumb-issuer)
  - [clean up all pending Async Resource Disposers items](#clean-up-all-pending-async-resource-disposers-items)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## security
### [get securityRealm](https://stackoverflow.com/a/66606027/2940319)
```groovy
import hudson.security.*
import jenkins.security.*
import jenkins.model.Jenkins

def jenkins = jenkins.model.Jenkins.getInstance()
println jenkins.securityRealm
println jenkins.authorizationStrategy


// result
// hudson.security.LDAPSecurityRealm@7d090e41
// hudson.security.ProjectMatrixAuthorizationStrategy@6d51bb9d
```

## authorization strategy

> reference:
> - [hudson.security.Permission](https://javadoc.jenkins.io/hudson/security/Permission.html)
> - [hudson.security.ProjectMatrixAuthorizationStrategy](https://javadoc.jenkins.io/plugin/matrix-auth/hudson/security/ProjectMatrixAuthorizationStrategy.html)
> - [matrix-auth-plugin/src/main/java/hudson/security/ProjectMatrixAuthorizationStrategy.java](https://github.com/jenkinsci/matrix-auth-plugin/blob/master/src/main/java/hudson/security/ProjectMatrixAuthorizationStrategy.java)
> - [How to add permission in GlobalMatrixAuthorizationStrategy through the groovy - for hudson.sercurity.item.Move](https://issues.jenkins.io/browse/JENKINS-57832?attachmentViewMode=list)

### [list all Jenkins supported authorization permissions](https://stackoverflow.com/a/58035811/2940319)
```groovy
hudson.security.Permission.getAll().each { p ->
  println "${p.name} :\n" +
          "\t${p.id} : ${p.description}"
}
```

- [better one](https://gist.github.com/sboardwell/f1e85536fc13b8e4c0d108726239c027)
  ```groovy
  import hudson.security.GlobalMatrixAuthorizationStrategy
  import hudson.security.Permission
  import hudson.security.ProjectMatrixAuthorizationStrategy
  import jenkins.model.Jenkins

  String shortName( Permission p ) {
    Map<String, String> replacement = [
                   'Hudson' : 'Overall' ,
                 'Computer' : 'Agent'   ,
                     'Item' : 'Job'     ,
      'CredentialsProvider' : 'Credentials'
    ]
    p.id
     .tokenize('.')[-2..-1]
     .collect { replacement.get(it) ?: it }
     .join(' ')
  }

  Map<String, Permission> permissionIds = Permission.all.findAll { permission ->
    List<String> nonConfigurablePerms = ['RunScripts', 'UploadPlugins', 'ConfigureUpdateCenter']
    permission.enabled &&
      ! permission.id.startsWith('hudson.security.Permission') &&
      ! nonConfigurablePerms.any { permission.id.endsWith(it) }
  }.collect { permission ->
    [ (shortName(permission)): permission ]
  }.sum()
  ```

### get current authorization strategy class
```groovy
import hudson.model.*
import hudson.security.*

Hudson instance = Jenkins.getInstance()
def strategy = instance.getAuthorizationStrategy()
println strategy.getClass()
```
- result
  ```
  class hudson.security.ProjectMatrixAuthorizationStrategy
  ```

### get raw authorization and permissions info
```groovy
Jenkins.instance.authorizationStrategy.grantedPermissions.collect{ p, u ->
  println "\n${p} :\n\t${u}"
}
```
- or
  ```groovy
  Jenkins.instance.authorizationStrategy.grantedPermissions.collect{ p, u ->
    [ (p.id), u ]
  }
  ```

### ProjectMatrixAuthorizationStrategy
#### grant permission to user
```groovy
import hudson.security.GlobalMatrixAuthorizationStrategy
import hudson.security.Permission
import hudson.security.ProjectMatrixAuthorizationStrategy
import jenkins.model.Jenkins

ProjectMatrixAuthorizationStrategy authorizationStrategy = new ProjectMatrixAuthorizationStrategy()
String id   = 'hudson.model.Hudson.Administer'
String user = 'marslo'
authorizationStrategy.add( Permission.fromId(id), user )

// save strategy
Jenkins.instance.authorizationStrategy = authorizationStrategy
Jenkins.instance.save()
```

#### [add new configurations according to Map structure](https://gist.github.com/marslo/8eef5efc667785aaf338395b636a609d)

#### create new instance
- `new`
  ```groovy
  import hudson.security.*
  ProjectMatrixAuthorizationStrategy authorizationStrategy = new ProjectMatrixAuthorizationStrategy()
  ```

- [via `getAuthorizationStrategy`](https://stackoverflow.com/a/47486042/2940319)
  ```groovy
  import hudson.model.*
  import hudson.security.*

  def strategy = Jenkins.getInstance().getAuthorizationStrategy()
  def authorizationStrategy = strategy.class.newInstance()
  ```

- [new instance from name](https://gist.github.com/sboardwell/f1e85536fc13b8e4c0d108726239c027#file-matrix-based-auth-groovy-L178)
  ```groovy
  String instanceName = 'hudson.security.ProjectMatrixAuthorizationStrategy'
  def strategy = Class.forName(instanceName).newInstance()
  println strategy.class
  ```
  - result
    ```
    class hudson.security.ProjectMatrixAuthorizationStrategy
    ```

- get groups list
  ```groovy
  import hudson.model.*
  import hudson.security.*

  ProjectMatrixAuthorizationStrategy authorizationStrategy = new ProjectMatrixAuthorizationStrategy()
  println authorizationStrategy.getGroups()
  ```

### RoleBasedAuthorizationStrategy
#### add 'admin' user to all permissions
```groovy
import hudson.*
import hudson.security.*
import jenkins.model.*
import java.util.*
import com.michelin.cio.hudson.plugins.rolestrategy.*
import com.synopsys.arc.jenkins.plugins.rolestrategy.*
import java.lang.reflect.*
import java.util.logging.*
import groovy.json.*

import jenkins.*
import com.michelin.cio.hudson.plugins.rolestrategy.*

String admin = 'admin'

// Turn security on
RoleBasedAuthorizationStrategy authorizationStrategy = new RoleBasedAuthorizationStrategy()
// ProjectMatrixAuthorizationStrategy authorizationStrategy = new ProjectMatrixAuthorizationStrategy()
Jenkins.instance.setAuthorizationStrategy(authorizationStrategy)

Constructor[] constrs = Role.class.getConstructors()
for (Constructor<?> c : constrs) {
  c.setAccessible(true)
}

Method assignRoleMethod = RoleBasedAuthorizationStrategy.class.getDeclaredMethod( "assignRole", String.class, Role.class, String.class )
assignRoleMethod.setAccessible( true )
Set<Permission> adminPermissions = new HashSet<Permission>()
hudson.security.Permission.getAll(){ adminPermissions.add(Permission.fromId(it) }
Role adminRole = new Role( admin, adminPermissions )
authorizationStrategy.addRole( RoleBasedAuthorizationStrategy.GLOBAL, adminRole )
```

## crumb issuer

> reference:
> - [hudson.security.csrf.CrumbIssuer](https://javadoc.jenkins.io/hudson/security/csrf/CrumbIssuer.html)
> - [ivan-pinatti/jenkins-set-default-crumb-issuer.groovy](https://gist.github.com/ivan-pinatti/7d8a877aff42350f16fcb1eb094818d9)

### get crumb issuer
```groovy
import hudson.security.csrf.DefaultCrumbIssuer

DefaultCrumbIssuer issuer = jenkins.model.Jenkins.instance.crumbIssuer
String jenkinsCrumb = "${issuer.crumbRequestField}:${issuer.crumb}"
println jenkinsCrumb
// Jenkins-Crumb:b8a9cd5***********
```

### set crumb issuer
```groovy
import jenkins.model.Jenkins

Jenkins jenkins = jenkins.model.Jenkins.instance
jenkins.setCrumbIssuer(new DefaultCrumbIssuer(true))
jenkins.save()
```

### clean up all pending Async Resource Disposers items
```groovy
import org.jenkinsci.plugins.resourcedisposer.AsyncResourceDisposer
import org.jenkinsci.plugins.strictcrumbissuer.StrictCrumbIssuer

AsyncResourceDisposer disposer = AsyncResourceDisposer.get()
StrictCrumbIssuer issuer = jenkins.model.Jenkins.instance.crumbIssuer
String jenkinsCrumb = "${issuer.crumbRequestField}:${issuer.crumb}"
String url = Jenkins.instance.rootUrl + disposer.url

disposer.getBacklog().each { item ->
  println "\n${item.id} : \t${url}/stopTracking/?id=${item.id} : \t${item.class.simpleName} : \n" +
          "\t${item.getLastState().getDisplayName()} : \n" +
          "\t${item.getDisposable().node} : ${item.getDisposable().path}\n" +
          "\t${item.toString()}"
  println "removeing ${item.id} : "
  [ 'bash', '-c', 'curl -v -s ' +
                       '-u <user>:<token> ' +
                       '-X POST ' +
                       "-H \"Content-Type: application/json\" " +
                       "-H \"Accept: application/json\" " +
                       "-H \"${jenkinsCrumb}\" " +
                       "${url}/stopTracking/?id=${item.id} "
  ].execute().with{
    def stdout = new StringBuffer()
    def stderr = new StringBuffer()
    it.waitForProcessOutput( stdout, stderr )
    println "EXIT CODE: ${it.exitValue()}"
    println "ERROR: ${stderr}"
    println "OUTPUT: ${stdout}"
  }
}
```
