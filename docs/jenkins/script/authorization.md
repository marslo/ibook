<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [security](#security)
  - [get securityRealm](#get-securityrealm)
- [authorization strategy](#authorization-strategy)
  - [decrypt credentials.xml](#decrypt-credentialsxml)
  - [list all Jenkins supported authorization permissions](#list-all-jenkins-supported-authorization-permissions)
  - [get current authorization strategy class](#get-current-authorization-strategy-class)
  - [get raw authorization and permissions info](#get-raw-authorization-and-permissions-info)
  - [ProjectMatrixAuthorizationStrategy](#projectmatrixauthorizationstrategy)
  - [RoleBasedAuthorizationStrategy](#rolebasedauthorizationstrategy)
- [crumb issuer](#crumb-issuer)
  - [get crumb issuer](#get-crumb-issuer)
  - [set crumb issuer](#set-crumb-issuer)
  - [clean up all pending Async Resource Disposers items](#clean-up-all-pending-async-resource-disposers-items)
  - [get crumb via cmd](#get-crumb-via-cmd)
- [credential](#credential)
  - [list all credentials](#list-all-credentials)
  - [StandardUsernamePasswordCredentials](#standardusernamepasswordcredentials)
  - [BasicSSHUserPrivateKey](#basicsshuserprivatekey)
  - [CertificateCredentials](#certificatecredentials)
  - [SystemCredentialsProvider](#systemcredentialsprovider)
  - [vault](#vault)
  - [encrypt/decrypt password](#encryptdecrypt-password)
- [tricky](#tricky)
  - [Access granted with Overall/SystemRead](#access-granted-with-overallsystemread)
  - [Access granted with Overall/Manage](#access-granted-with-overallmanage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## security

> [!NOTE|label:references:]
> - [getJavaSecurityAlgorithmReport.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/getJavaSecurityAlgorithmReport.groovy)

### [get securityRealm](https://stackoverflow.com/a/66606027/2940319)
```groovy
import hudson.security.*
import jenkins.security.*
import jenkins.model.Jenkins

def jenkins = jenkins.model.Jenkins.getInstance()
println jenkins.securityRealm
println jenkins.authorizationStrategy


// -- result --
// hudson.security.LDAPSecurityRealm@7d090e41
// hudson.security.ProjectMatrixAuthorizationStrategy@6d51bb9d
```

## authorization strategy

{% hint style='tip' %}
> reference:
> - [hudson.security.Permission](https://javadoc.jenkins.io/hudson/security/Permission.html)
> - [hudson.security.ProjectMatrixAuthorizationStrategy](https://javadoc.jenkins.io/plugin/matrix-auth/hudson/security/ProjectMatrixAuthorizationStrategy.html)
> - [matrix-auth-plugin/src/main/java/hudson/security/ProjectMatrixAuthorizationStrategy.java](https://github.com/jenkinsci/matrix-auth-plugin/blob/master/src/main/java/hudson/security/ProjectMatrixAuthorizationStrategy.java)
> - [How to add permission in GlobalMatrixAuthorizationStrategy through the groovy - for hudson.sercurity.item.Move](https://issues.jenkins.io/browse/JENKINS-57832?attachmentViewMode=list)
> - [Jenkins : Grant Cancel Permission for user and group that have Build permission](https://wiki.jenkins.io/display/JENKINS/Grant-Cancel-Permission-for-user-and-group-that-have-Build-permission.html)
> - [Accessing and dumping Jenkins credentials](https://www.codurance.com/publications/2019/05/30/accessing-and-dumping-jenkins-credentials)
{% endhint %}

### decrypt credentials.xml

> [!NOTE|label:references:]
> - [How to decrypt Jenkins passwords from credentials.xml?](https://devops.stackexchange.com/a/2192/3503)
> - [tweksteen/jenkins-decrypt](https://github.com/tweksteen/jenkins-decrypt)
> - [menski/jenkins-decrypt.py](https://gist.github.com/menski/8f9980999ed43246b9b2)

```groovy
hudson.util.Secret.fromString('{..string..}').getPlainText()
// or
hudson.util.Secret.fromString('{..string..}').getEncryptedValue()
```

- example
  ```bash
  hudson.util.Secret.fromString('{AQAAABAAAAAQszhBK4LXdjzjqP/7w8yQWbD4+Kf1ql4XnYEnPUyvP2o=}').getPlainText()
  // 123456
  ```

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

  // show result
  println permissionIds.collect {
    it.key + ' : ' + it.value.id
  }.join ('\n')

  'DONE'
  ```

### get current authorization strategy class
```groovy
import hudson.model.*
import hudson.security.*

Hudson instance = Jenkins.getInstance()
def strategy = instance.getAuthorizationStrategy()
println strategy.getClass()

// result
// class hudson.security.ProjectMatrixAuthorizationStrategy
```

### get raw authorization and permissions info
```groovy
Jenkins.instance
       .authorizationStrategy
       .grantedPermissions
       .collect{ p, u -> [ (p.id), u ] }

```
- or
  ```groovy
  Jenkins.instance
         .authorizationStrategy
         .grantedPermissions
         .each { p, u -> println "\n${p} :\n\t${u}" }
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

  // -- result --
  // class hudson.security.ProjectMatrixAuthorizationStrategy
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

### get crumb via cmd

> [!TIP|local:references:]
> - [CSRF Protection Explained](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/csrf-protection-explained)

- curl
  ```bash
  # after 2.176.2
  $ SERVER="https://localhost:8080"
  $ COOKIEJAR="$(mktemp)"
  $ CRUMB=$(curl -u "admin:admin" -s --cookie-jar "$COOKIEJAR" "$SERVER/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")

  # verify
  $ echo $CRUMB
  Jenkins-Crumb:786**********************************************************932

  # trigger a build
  $ curl -X POST \
         -u "admin:admin" \
         --cookie "$COOKIEJAR" \
         -H "$CRUMB" \
         https://${SERVER}/job/sandbox/build

  # to run script
  $ curl -d "script=System.getProperties()" \
         -u "admin:admin" \
         --cookie "$COOKIEJAR" \
         -H "$CRUMB" \
         https://${SERVER}/scriptText
  ```

- via wget
  ```bash
  # after 2.176.2
  $ SERVER="https://localhost:8080"
  $ COOKIEJAR="$(mktemp)"
  $ CRUMB="$(wget --quiet --user=admin --password=admin --auth-no-challenge --save-cookies "$COOKIEJAR" --keep-session-cookies -q --output-document - "$SERVER/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")"
  $ wget --user=admin --password=admin \
         --auth-no-challenge \
         --load-cookies "$COOKIEJAR" \
         --header="$CRUMB" \
         --post-data="" \
         --quiet \
         "$SERVER"/job/someJob/build
  ```

## credential

{% hint style='tip' %}
> references:
> - [* Setting Jenkins Credentials with Groovy](https://nickcharlton.net/posts/setting-jenkins-credentials-with-groovy.html)
> - [* addCredentials : hayderimran7/Jenkins_ssh_groovy.md](https://gist.github.com/hayderimran7/d6ab8a6a770cb970349e)
> - [* Jenkins Credentials Store Access via Groovy](https://stackoverflow.com/a/35215587/2940319)
> - [* Adding Google Service Account Credentials by a groovy script](https://stackoverflow.com/a/66553315/2940319)
> - [* Fetch the domain for each credential returned in a job template.](https://docs.cloudbees.com/docs/cloudbees-ci-kb/latest/client-and-managed-masters/fetch-the-domain-for-each-credential-returned-in-a-job-template)
> - [* update username/password crednetial](https://stackoverflow.com/a/32216097/2940319)
> - [* How to update credentials of specific folder in Jenkins using Groovy script?](https://stackoverflow.com/q/59696646/2940319)
> - [Extension Points defined in Credentials Plugin](https://www.jenkins.io/doc/developer/extensions/credentials/)
> - [CredentialsProvider.java](https://github.com/jenkinsci/credentials-plugin/blob/master/src/main/java/com/cloudbees/plugins/credentials/CredentialsProvider.java)
> - [Jenkins Pipelines: How to use withCredentials() from a shared-variable script](https://stackoverflow.com/a/54927543/2940319)
> - [Jenkins Credentials Store Access via Groovy](https://stackoverflow.com/questions/35205665/jenkins-credentials-store-access-via-groovy)
> - [How to get android signing certificate back from jenkins plugin](https://stackoverflow.com/questions/56167802/how-to-get-android-signing-certificate-back-from-jenkins-plugin)
> - [Go Decrypt Jenkins](https://www.thesubtlety.com/post/go-decrypt-jenkins/)
> - [* Jenkins: Decrypting all passwords in credentials.xml (via Jenkins execution console)](https://stackoverflow.com/a/56047194/2940319)
> - [How to get android signing certificate back from jenkins plugin](https://stackoverflow.com/a/56290348/2940319)
> - [bstapes/jenkins-decrypt](https://github.com/bstapes/jenkins-decrypt)
> - [* How to decrypt Jenkins passwords from credentials.xml?](https://devops.stackexchange.com/a/8692/3503)
> - [update Jenkins credentials by script](https://stackoverflow.com/a/32216097/2940319)
> - [Accessing and dumping Jenkins credentials](https://www.codurance.com/publications/2019/05/30/accessing-and-dumping-jenkins-credentials)
{% endhint %}

> [!TIP]
> something else :
> - [kubernetes-credentials-provider-plugin](https://jenkinsci.github.io/kubernetes-credentials-provider-plugin/examples/)
> - scripts:
>   - [* tuxfight3r/jenkins-decrypt.groovy](https://gist.github.com/tuxfight3r/eca9442ff76649b057ab)
>   - [* menski/jenkins-decrypt.py](https://gist.github.com/menski/8f9980999ed43246b9b2)
>   - [addCredentials.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/addCredentials.groovy)
>   - [changeCredentialPassword.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/changeCredentialPassword.groovy)
>   - [credentials-migration](https://github.com/cloudbees/jenkins-scripts/tree/master/credentials-migration)
>   - [list-credential.groovy](https://github.com/cloudbees/jenkins-scripts/blob/master/list-credential.groovy)
>
> api :
> - [com.cloudbees.plugins.credentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/Credentials.html)
>   - [CertificateCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/CertificateCredentials.html)
>   - [DomainRestrictedCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/domains/DomainRestrictedCredentials.html)
>   - [IdCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/IdCredentials.html)
>   - [PasswordCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/PasswordCredentials.html)
>   - [StandardCertificateCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/StandardCertificateCredentials.html)
>   - [StandardCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/StandardCredentials.html)
>   - [StandardUsernameCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/StandardUsernameCredentials.html)
>   - [StandardUsernamePasswordCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/StandardUsernamePasswordCredentials.html)
>   - [UsernameCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/UsernameCredentials.html)
>   - [UsernamePasswordCredentials](https://javadoc.jenkins.io/plugin/credentials/com/cloudbees/plugins/credentials/common/UsernamePasswordCredentials.html)
>   - [VaultUsernamePasswordCredential](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/common/VaultUsernamePasswordCredentialImpl.html)

### list all credentials
```groovy
import com.cloudbees.plugins.credentials.common.StandardCredentials
import com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.jenkins.plugins.sshcredentials.SSHUserPrivateKey;
import com.cloudbees.plugins.credentials.SystemCredentialsProvider

CredentialsProvider.lookupCredentials( StandardCredentials.class, jenkins.model.Jenkins.instance)
                   .sort{ it.id }
                   .each{
                     switch( it.class.simpleName ) {
                       case 'BasicSSHUserPrivateKey' :
                         println """
                                                             type : ${it.class.simpleName}
                                                               id : ${it.id}
                                                            scope : ${it.scope}
                                                         username : ${it.username}
                                                      description : ${it.description}
                                          privateKeysLastModified : ${it.privateKeysLastModified}
                                                   usernameSecret : ${it.usernameSecret ?: 'false'}
                                                      privateKeys : ${it.privateKeys.join('\n')}
                          """
                         break;

                       case 'CertificateCredentialsImpl' :
                          println """
                                                             type : ${it.class.simpleName}
                                                               id : ${it.id}
                                                            scope : ${it.scope}
                                                         password : ${it.password}
                                                      description : ${it.description}
                                                    keyStore.type : ${it.keyStore.type}
                                     keyStoreSource.keyStoreBytes : ${it.keyStoreSource.keyStoreBytes}
                             keyStoreSource.uploadedKeystoreBytes : ${it.keyStoreSource.uploadedKeystoreBytes}

                                                       properties : ${it.properties}
                                              properties.password : ${it.properties.password}
                                         properties.passwordEmpty : ${it.properties.passwordEmpty}
                                         properties.keyStore.type : ${it.properties.keyStore.type}
                          """
                         break;
                       case 'StringCredentialsImpl' :
                         println """
                                                             type : ${it.class.simpleName}
                                                               id : ${it.id}
                                                           secret : ${it.secret}
                                                      description : ${it.description}
                                                            scope : ${it.scope}
                        """
                         break;

                       case 'UsernamePasswordCredentialsImpl' :
                         println """
                                                             type : ${it.class.simpleName}
                                                               id : ${it.id}
                                                         username : ${it.username}
                                                         password : ${it.password}
                                                      description : ${it.description}
                                                   usernameSecret : ${it.usernameSecret ?: 'false'}
                         """
                         break;
                     }
                   }
```

- with vault
  ```groovy
  import com.cloudbees.plugins.credentials.common.StandardCredentials
  import com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials
  import com.cloudbees.plugins.credentials.CredentialsProvider
  import com.cloudbees.jenkins.plugins.sshcredentials.SSHUserPrivateKey;
  import com.cloudbees.plugins.credentials.SystemCredentialsProvider
  import com.datapipe.jenkins.vault.credentials.common.VaultUsernamePasswordCredential
  import com.datapipe.jenkins.vault.credentials.VaultAppRoleCredential
  import com.datapipe.jenkins.vault.credentials.common.VaultSSHUserPrivateKeyImpl
  import com.datapipe.jenkins.vault.credentials.common.VaultStringCredentialImpl

  CredentialsProvider.lookupCredentials( StandardCredentials.class, jenkins.model.Jenkins.instance)
                     .sort{ it.id }
                     .each{
                       switch( it.class.simpleName ) {
                         case 'BasicSSHUserPrivateKey' :
                           println """
                                                               type : ${it.class.simpleName}
                                                                 id : ${it.id}
                                                              scope : ${it.scope}
                                                           username : ${it.username}
                                                        description : ${it.description}
                                            privateKeysLastModified : ${it.privateKeysLastModified}
                                                     usernameSecret : ${it.usernameSecret ?: 'false'}
                                                        privateKeys : ${it.privateKeys.join('\n')}
                            """
                           break;

                         case 'CertificateCredentialsImpl' :
                            println """
                                                               type : ${it.class.simpleName}
                                                                 id : ${it.id}
                                                              scope : ${it.scope}
                                                           password : ${it.password}
                                                        description : ${it.description}
                                                      keyStore.type : ${it.keyStore.type}
                                       keyStoreSource.keyStoreBytes : ${it.keyStoreSource.keyStoreBytes}
                               keyStoreSource.uploadedKeystoreBytes : ${it.keyStoreSource.uploadedKeystoreBytes}

                                                         properties : ${it.properties}
                                                properties.password : ${it.properties.password}
                                           properties.passwordEmpty : ${it.properties.passwordEmpty}
                                           properties.keyStore.type : ${it.properties.keyStore.type}
                            """
                           break;
                         case 'StringCredentialsImpl' :
                           println """
                                                               type : ${it.class.simpleName}
                                                                 id : ${it.id}
                                                             secret : ${it.secret}
                                                        description : ${it.description}
                                                              scope : ${it.scope}
                          """
                           break;

                         case 'UsernamePasswordCredentialsImpl' :
                           println """
                                                               type : ${it.class.simpleName}
                                                                 id : ${it.id}
                                                           username : ${it.username}
                                                           password : ${it.password}
                                                        description : ${it.description}
                                                     usernameSecret : ${it.usernameSecret ?: 'false'}
                           """
                           break;

                         case 'VaultUsernamePasswordCredentialImpl' :
                           println """

                                                               type : ${it.class.simpleName}
                                                      engineVersion : ${it.engineVersion}
                                                                id  : ${it.id}
                                                              scope : ${it.scope}
                                                        description : ${it.description}
                                                        displayName : ${it.displayName}
                                                               path : ${it.path}
                                                        usernameKey : ${it.usernameKey}
                                                           username : ${it.username}
                                                        passwordKey : ${it.passwordKey}
                                                           password : ${it.password}
                                                     usernameSecret : ${it.usernameSecret ?: 'false'}
                           """
                           break;

                         case 'VaultAppRoleCredential':
                           println """
                                                               type : ${it.class.simpleName}
                                                                 id : ${it.id}
                                                             roleId : ${it.roleId}
                                                           secretId : ${it.secretId}
                                                               path : ${it.path}
                                                          namespace : ${it.namespace}
                                                              scope : ${it.scope}
                                                        description : ${it.description}
                           """
                           break;

                         case 'VaultSSHUserPrivateKeyImpl':
                           println """
                                                               type : ${it.class.simpleName}
                                                      engineVersion : ${it.engineVersion}
                                                                 id : ${it.id}
                                                              scope : ${it.scope}
                                                        description : ${it.description}
                                                        displayName : ${it.displayName}
                                                     usernameSecret : ${it.usernameSecret ?: 'false'}
                                                        usernameKey : ${it.usernameKey}
                                                           username : ${it.username}
                                                      privateKeyKey : ${it.privateKeyKey}
                                                        privateKeys : ${it.privateKeys.join('\n')}
                                                      passphraseKey : ${it.passphraseKey}
                                                         passphrase : ${ it.passphrase}
                           """
                           break;

                         case 'VaultStringCredentialImpl':
                           println """
                                                               type : ${it.class.simpleName}
                                                      engineVersion : ${it.engineVersion}
                                                                 id : ${it.id}
                                                        displayName : ${it.displayName}
                                                        description : ${it.description}
                                                         prefixPath : ${it.prefixPath}
                                                               path : ${it.path}
                                                             secret : ${it.secret}
                                                           valutKey : ${it.vaultKey}
                           """
                           break;
                       }
                      }
  ```

- [or](https://devops.stackexchange.com/a/8692/3503)
  ```groovy
  import com.cloudbees.plugins.credentials.CredentialsProvider
  import com.cloudbees.plugins.credentials.Credentials
  import com.cloudbees.plugins.credentials.domains.Domain
  import jenkins.model.Jenkins
  def indent = { String text, int indentationCount ->
    def replacement = "\t" * indentationCount
    text.replaceAll("(?m)^", replacement)
  }

  Jenkins.get().allItems().collectMany{ CredentialsProvider.lookupStores(it).toList()}.unique().forEach { store ->
    Map<Domain, List<Credentials>> domainCreds = [:]
    store.domains.each { domainCreds.put(it, store.getCredentials(it))}
    if (domainCreds.collectMany{ it.value}.empty) {
      return
    }
    def shortenedClassName = store.getClass().name.substring(store.getClass().name.lastIndexOf(".") + 1)
    println "Credentials for store context: ${store.contextDisplayName}, of type $shortenedClassName"
    domainCreds.forEach { domain , creds ->
      println indent("Domain: ${domain.name}", 1)
      creds.each { cred ->
        cred.properties.each { prop, val ->
          println indent("$prop = \"$val\"", 2)
        }
        println indent("-----------------------", 2)
      }
    }
  }
  ```

### StandardUsernamePasswordCredentials
```groovy
import com.cloudbees.plugins.credentials.common.StandardCredentials
import com.cloudbees.plugins.credentials.common.StandardUsernamePasswordCredentials
import com.cloudbees.plugins.credentials.CredentialsProvider

List<StandardUsernamePasswordCredentials> creds = CredentialsProvider.lookupCredentials(
  StandardUsernamePasswordCredentials.class,
  jenkins.model.Jenkins.instance
)

creds.sort{it.id}.each {
  println """
                id : ${it.id}
          username : ${it.username}
          password : ${it.password}
       description : ${it.description}
    usernameSecret : ${it.usernameSecret ?: 'false'}
  """
}

"DONE"
```

### BasicSSHUserPrivateKey
```groovy
import com.cloudbees.plugins.credentials.common.StandardCredentials;
import com.cloudbees.plugins.credentials.CredentialsProvider;
import com.cloudbees.jenkins.plugins.sshcredentials.impl.BasicSSHUserPrivateKey
import com.cloudbees.jenkins.plugins.sshcredentials.SSHUserPrivateKey;

List<BasicSSHUserPrivateKey> creds = CredentialsProvider.lookupCredentials(
  SSHUserPrivateKey.class ,                         // or BasicSSHUserPrivateKey.class
  jenkins.model.Jenkins.instance
).sort{ it.id }
 .each {
    println """
                        id  : ${it.id}
                      scope : ${it.scope}
                  username  : ${it.username}
               description  : ${it.description}
    privateKeysLastModified : ${it.privateKeysLastModified}
            usernameSecret  : ${it.usernameSecret ?: 'false'}
               privateKeys  : ${it.privateKeys.join('\n')}
    """
 }
```

### CertificateCredentials
```groovy
import com.cloudbees.plugins.credentials.common.StandardCredentials
import com.cloudbees.plugins.credentials.common.CertificateCredentials
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.cloudbees.plugins.credentials.SecretBytes
import com.cloudbees.plugins.credentials.impl.CertificateCredentialsImpl

CredentialsProvider.lookupCredentials(
  CertificateCredentials.class,
  jenkins.model.Jenkins.instance
).sort{ it.id }
 .each {
    SecretBytes secretKey = it.properties.keyStoreSource.uploadedKeystoreBytes
    println """
                       id : ${it.id}
                 password : ${it.password}
              description : ${it.description}
                    scope : ${it.scope}
            keyStore.type : ${it.properties.keyStore.type}
      SecretBytes.decrypt : ${SecretBytes.decrypt(it.keyStoreSource.keyStoreBytes)}
           encryptedValue : ${hudson.util.Secret.fromString(secretKey.toString()).encryptedValue}
                plainData : ${new String(SecretBytes.fromString(secretKey.toString()).getPlainData(), "ASCII")}
    """
}

"DONE"
```

### SystemCredentialsProvider
```groovy
import com.cloudbees.plugins.credentials.SystemCredentialsProvider

SystemCredentialsProvider systemCredentialsProvider = jenkins.model.Jenkins.instance.getExtensionList(
  'com.cloudbees.plugins.credentials.SystemCredentialsProvider'
).first()

systemCredentialsProvider.credentials.each {
  println """
             id : ${it.id}
    description : ${it.description}
          scope : ${it.scope}
         secret : ${it.secret}
  """
}
```

### vault

> [!NOTE|label:references:]
> - scripts:
>   - [vaultTokenCredential.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/vaultTokenCredential.groovy)

#### [VaultAppRoleCredential](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/VaultAppRoleCredential.html)

> [!NOTE|label:references:]
> - scripts
>   - [vaultAppRoleCredential.groovy](https://github.com/jenkinsci/jenkins-scripts/blob/master/scriptler/vaultAppRoleCredential.groovy)

```groovy
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.datapipe.jenkins.vault.credentials.VaultAppRoleCredential

List<VaultAppRoleCredential> creds = CredentialsProvider.lookupCredentials(
  VaultAppRoleCredential.class ,
  jenkins.model.Jenkins.instance
).sort{ it.id }

creds.each {
  println """
             type : ${it.class.simpleName}
            scope : ${it.scope}
    engineVersion : ${it.engineVersion}
               id : ${it.id}
      description : ${it.description}
        namespace : ${it.namespace}
             path : ${it.path}
         secretId : ${it.secretId}
           roleId : ${it.roleId}
  """
}
```

#### [VaultUsernamePasswordCredential](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/common/VaultUsernamePasswordCredentialImpl.html)
```groovy
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.datapipe.jenkins.vault.credentials.common.VaultUsernamePasswordCredential

List<VaultUsernamePasswordCredential> creds = CredentialsProvider.lookupCredentials(
  VaultUsernamePasswordCredential.class ,
  jenkins.model.Jenkins.instance
).sort{ it.id }

creds.each {
  println """
              type : ${it.class.simpleName}
             scope : ${it.scope}
     engineVersion : ${it.engineVersion}
                id : ${it.id}
       description : ${it.description}
              path : ${it.path}
       usernameKey : ${it.usernameKey}
          username : ${it.username}
       passwordKey : ${it.passwordKey}
          password : ${it.password}
    usernameSecret : ${it.usernameSecret ?: 'false'}
  """
}
```

#### [VaultUsernamePasswordCredentialImpl](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/common/VaultUsernamePasswordCredentialImpl.html)
```bash
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.datapipe.jenkins.vault.credentials.common.VaultUsernamePasswordCredentialImpl

List<VaultUsernamePasswordCredentialImpl> creds = CredentialsProvider.lookupCredentials(
  VaultUsernamePasswordCredentialImpl.class ,
  jenkins.model.Jenkins.instance
).sort{ it.id }

creds.each {
  println """
              type : ${it.class.simpleName}
     engineVersion : ${it.engineVersion}
               id  : ${it.id}
             scope : ${it.scope}
       description : ${it.description}
       displayName : ${it.displayName}
              path : ${it.path}
       usernameKey : ${it.usernameKey}
          username : ${it.username}
       passwordKey : ${it.passwordKey}
          password : ${it.password}
    usernameSecret : ${it.usernameSecret ?: 'false'}
  """
}
```

#### [VaultSSHUserPrivateKeyImpl](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/common/VaultSSHUserPrivateKeyImpl.html)
```bash
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.datapipe.jenkins.vault.credentials.common.VaultSSHUserPrivateKeyImpl

List<VaultSSHUserPrivateKeyImpl> creds = CredentialsProvider.lookupCredentials(
  VaultSSHUserPrivateKeyImpl.class,
  jenkins.model.Jenkins.instance
).sort{ it.id }

creds.each {
  println """
               type : ${it.class.simpleName}
              scope : ${it.scope}
      engineVersion : ${it.engineVersion}
                 id : ${it.id}
        description : ${it.description}
        displayName : ${it.displayName}
     usernameSecret : ${it.usernameSecret ?: 'false'}
        usernameKey : ${it.usernameKey}
           username : ${it.username}
      privateKeyKey : ${it.privateKeyKey}
        privateKeys : ${it.privateKeys.collect{ it.trim() }}
         privateKey : ${it.privateKey}
      passphraseKey : ${it.passphraseKey}
         passphrase : ${ it.passphrase}
  """
}
```

#### [VaultStringCredentialImpl](https://javadoc.jenkins.io/plugin/hashicorp-vault-plugin/com/datapipe/jenkins/vault/credentials/common/VaultStringCredentialImpl.html)
```bash
import com.cloudbees.plugins.credentials.CredentialsProvider
import com.datapipe.jenkins.vault.credentials.common.VaultStringCredentialImpl

List<VaultStringCredentialImpl> creds = CredentialsProvider.lookupCredentials(
  VaultStringCredentialImpl.class ,
  jenkins.model.Jenkins.instance
).sort{ it.id }

creds.each {
  println """
             type : ${it.class.simpleName}
    engineVersion : ${it.engineVersion}
            scope : ${it.scope}
               id : ${it.id}
      description : ${it.description}
      displayName : ${it.displayName}
       prefixPath : ${it.prefixPath}
             path : ${it.path}
         valutKey : ${it.vaultKey}
           secret : ${it.secret}
  """
}
```

### encrypt/decrypt password
```groovy
import hudson.util.Secret

String original  = 'marslo'
Secret secret    = Secret.fromString( original )
String encrypted = secret.getEncryptedValue()
Secret decrypted = Secret.decrypt( encrypted )

println """
   original : ${original}
  encrypted : ${encrypted}
  decrypted : ${decrypted}
"""

//   original : marslo
//  encrypted : {AQAAABAAAAAQyF78QAdq9bWCAeUi1VdYO7cB0CfG29KrvwZUU506zig=}
//  decrypted : marslo

```
- or
  ```groovy
  println hudson.util.Secret.fromString('marslo').getEncryptedValue()
  println hudson.util.Secret.decrypt( hudson.util.Secret.fromString('marslo').getEncryptedValue()

  // {AQAAABAAAAAQfwTdrtsFbS2MyOOA3kuO01p21CsVsSIpZg9FE1TMlMQ=}
  // marslo
  ```

## tricky

### [Access granted with Overall/SystemRead](https://www.jenkins.io/doc/book/security/access-control/permissions/#access-granted-with-overallsystemread)

{% hint style='tip' %}
This permission can be enabled by setting [the system property jenkins.security.SystemReadPermission](https://www.jenkins.io/doc/book/managing/system-properties/#jenkins-security-systemreadpermission) to true or installing the [Extended Read Permission](https://plugins.jenkins.io/extended-read-permission) plugin.
{% endhint %}

### [Access granted with Overall/Manage](https://www.jenkins.io/doc/book/security/access-control/permissions/#access-granted-with-overallmanage)

{% hint style='tip' %}
This permission can be enabled by setting [the system property jenkins.security.ManagePermission to true](https://www.jenkins.io/doc/book/managing/system-properties/#jenkins-security-managepermission) or installing [the Overall/Manage permission enabler](https://plugins.jenkins.io/manage-permission) plugin.
{% endhint %}
