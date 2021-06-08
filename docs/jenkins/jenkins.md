<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [run Jenkins](#run-jenkins)
  - [in docker](#in-docker)
  - [in kubernetes](#in-kubernetes)
- [crumb](#crumb)
  - [get crumb](#get-crumb)
  - [visit API via crumb](#visit-api-via-crumb)
  - [restart Jenkins instance](#restart-jenkins-instance)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## run Jenkins
> refernce:
> - [Jenkins Features Controlled with System Properties](https://www.jenkins.io/doc/book/managing/system-properties/)
> - [-Dhudson.security.ArtifactsPermission=true](https://github.com/jenkinsci/docker/issues/202#issuecomment-244321911)
> - [remoting configuration](https://github.com/jenkinsci/remoting/blob/master/docs/configuration.md)
> - [IMPORTANT JENKINS COMMAND](https://rajeevtechblog.wordpress.com/2018/09/28/important-jenkins-command/)

### in docker
```bash
$ docker run \
         --name jenkins \
         --rm \
         --detach   \
         --network jenkins \
         --env DOCKER_HOST=tcp://docker:2376   \
         --env DOCKER_CERT_PATH=/certs/client \
         --env DOCKER_TLS_VERIFY=1   \
         --publish 8080:8080 \
         --publish 50000:50000   \
         --volume jenkins-data:/var/jenkins_home   \
         --volume jenkins-docker-certs:/certs/client:ro   \
         jenkins/jenkins:latest
```

- docker run with `JAVA_OPTS`
  ```bash
  $ docker run \
           --name jenkins \
           --detach   \
           --rm \
           --network jenkins \
           --env DOCKER_HOST=tcp://docker:2376   \
           --env DOCKER_CERT_PATH=/certs/client \
           --env DOCKER_TLS_VERIFY=1   \
           --publish 80:8080 \
           --publish 50000:50000   \
           --env JAVA_OPTS=" \
                  -DsessionTimeout=1440 \
                  -DsessionEviction=43200 \
                  -Djava.awt.headless=true \
                  -Djenkins.ui.refresh=true \
                  -Divy.message.logger.level=4 \
                  -Dhudson.Main.development=true \
                  -Duser.timezone='Asia/Chongqing' \
                  -Djenkins.install.runSetupWizard=true \
                  -Dhudson.security.ArtifactsPermission=true \
                  -Dpermissive-script-security.enabled=true  \
                  -Djenkins.slaves.NioChannelSelector.disabled=true \
                  -Dhudson.security.LDAPSecurityRealm.groupSearch=true \
                  -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false \
                  -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true \
                  -Dhudson.model.ParametersAction.keepUndefinedParameters=true \
                  -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true \
                  -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false \
                  -Dhudson.model.DirectoryBrowserSupport.CSP=\"sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;\" \
                " \
           --env JNLP_PROTOCOL_OPTS="-Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false" \
           --volume /opt/JENKINS_HOME:/var/jenkins_home \
           jenkins/jenkins:latest
  ```

### in kubernetes
> reference:
> - [official yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/jenkins.yml)
> - [official sa yaml](https://github.com/jenkinsci/kubernetes-plugin/blob/master/src/main/kubernetes/service-account.yml)

```bash
$ cat << EOF | kubectl apply -f -
# namespace
---
kind: Namespace
apiVersion: v1
metadata:
  name: devops
  labels:
    name: devops

# quota
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: quota
  namespace: devops
spec:
  hard:
    requests.cpu: "48"
    requests.memory: 48Gi
    limits.cpu: "48"
    limits.memory: 48Gi

# sa
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: jenkins
  name: jenkins-admin
  namespace: devops
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: jenkins-admin
  labels:
    k8s-app: jenkins
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: jenkins-admin
  namespace: devops

# pv & pvc
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: jenkins-pv
spec:
  capacity:
    storage: 200Gi
  accessModes:
    - ReadWriteMany
  nfs:
    server: 1.2.3.4
    path: "/jenkins_vol/jenkins/DEVOPS_JENKINS"
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: jenkins-pvc
  namespace: devops
spec:
  accessModes:
  - ReadWriteMany
  resources:
    requests:
      storage: 100Gi
  storageClassName: ""
  volumeName: jenkins-pv

# deploy
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins
  namespace: devops
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
            - matchExpressions:
              - key: kubernetes.io/hostname
                operator: In
                values:
                - aws-hostname-01
                - aws-hostname-02
      containers:
        - name: jenkins
          image: jenkins/jenkins:latest
          imagePullPolicy: IfNotPresent
          env:
            - name: JAVA_OPTS
              value: -Xms2048m
                     -Xmx10240m
                     -XX:PermSize=2048m
                     -XX:MaxPermSize=10240m
                     -Duser.timezone='Asia/Chongqing' \
                     -Dhudson.model.DirectoryBrowserSupport.CSP="sandbox allow-same-origin allow-scripts; default-src 'self'; script-src * 'unsafe-eval'; img-src *; style-src * 'unsafe-inline'; font-src *;"
                     -Djenkins.slaves.NioChannelSelector.disabled=true
                     -Djenkins.slaves.JnlpSlaveAgentProtocol3.enabled=false
                     -Djava.awt.headless=true
                     -Djenkins.security.ClassFilterImpl.SUPPRESS_WHITELIST=true
                     -Dhudson.model.ParametersAction.keepUndefinedParameters=true
                     -Dcom.cloudbees.workflow.rest.external.ChangeSetExt.resolveCommitAuthors=true
                     -Djenkins.install.runSetupWizard=true
                     -Dpermissive-script-security.enabled=true
                     -DsessionTimeout=1440
                     -DsessionEviction=43200
                     -Divy.message.logger.level=4
                     -Dhudson.plugins.active_directory.ActiveDirectorySecurityRealm.forceLdaps=false
            - name: JNLP_PROTOCOL_OPTS
              value: -Dorg.jenkinsci.remoting.engine.JnlpProtocol3.disabled=false
          ports:
            - name: http-port
              containerPort: 8080
            - name: jnlp-port
              containerPort: 50000
            - name: cli-port
              containerPort: 38338
          volumeMounts:
            - name: jenkins-home
              mountPath: /var/jenkins_home
          resources:
            requests:
              memory: '8Gi'
              cpu: '8'
            limits:
              memory: '16Gi'
              cpu: '16'
      volumes:
        - name: jenkins-home
          persistentVolumeClaim:
            claimName: jenkins-pvc
      serviceAccount: "jenkins-admin"

# svc
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins
spec:
  type: ClusterIP
  ports:
    - name: jenkins
      port: 8080
      targetPort: 8080
  selector:
    app: jenkins
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-discovery
  namespace: devops
spec:
  template:
    metadata:
      labels:
        name: jenkins-discovery
spec:
  type: NodePort
  ports:
    - name: jenkins-agent
      port: 50000
      targetPort: 50000
    - name: cli-agent
      port: 38338
      targetPort: 38338
  selector:
    app: jenkins

# ing (for traefik ingress)
---
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: jenkins
  namespace: devops
  annotations:
    kubernetes.io/ingress.class: traefik
    ingress.kubernetes.io/whitelist-x-forwarded-for: "false"
    traefik.frontend.redirect.entryPoint: https
    ingress.kubernetes.io/ssl-redirect: "true"
  labels:
    app: jenkins
spec:
  rules:
  - host: jenkins.mysite.com
    http:
      paths:
      - backend:
          serviceName: jenkins
          servicePort: 8080
  tls:
  - hosts:
    - jenkins.mysite.com
    secretName: mysite-tls
EOF
```

- for nginx ingress
  ```bash
  ---
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: jenkins
    namespace: devops
    annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/secure-backends: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
      kubernetes.io/ingress.allow-http: "false"
  spec:
    tls:
    - hosts:
      - jenkins.mysite.com
      secretName: mysite-certs
    rules:
    - host: jenkins.mysite.com
      http:
        paths:
        - path:
          backend:
            serviceName: jenkins
            servicePort: 8080
  ```

## crumb
> more info:
> - [Improved CSRF protection](https://jenkins.io/redirect/crumb-cannot-be-used-for-script)
> - [CSRF Protection](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-CSRFProtection)
> - [Remote Access API](https://www.jenkins.io/doc/book/using/remote-access-api/)
> - [Jenkins REST API example using crumb](https://gist.github.com/dasgoll/455522f09cb963872f64e23bb58804b2)
> - [CSRF Protection Explained](https://support.cloudbees.com/hc/en-us/articles/219257077-CSRF-Protection-Explained)

### get crumb
> [`jq` for multiple values](https://github.com/stedolan/jq/issues/785#issuecomment-101475408) and [another answer](https://github.com/stedolan/jq/issues/785#issuecomment-101842421)

- via groovy script
  ```groovy
  import hudson.security.csrf.DefaultCrumbIssuer

  DefaultCrumbIssuer issuer = jenkins.model.Jenkins.instance.crumbIssuer
  jenkinsCrumb = "${issuer.crumbRequestField}:${issuer.crumb}"
  ```
  - result
    ```groovy
    // println jenkinsCrumb
    // Jenkins-Crumb:7248f4a5***********
    ```

- via api
  ```bash
  $ curl -s 'http://jenkins.marslo.com/crumbIssuer/api/json' \
            | jq -r '[.crumbRequestField, .crumb] | "\(.[0]):\(.[1])"'
  Jenkins-Crumb:8b87b6ed98ef923******
  ```
  - [or](https://github.com/stedolan/jq/issues/785#issuecomment-574836419)
    ```bash
    $ curl -s 'http://jenkins.marslo.com/crumbIssuer/api/json' \
              | jq -r '[.crumbRequestField, .crumb] | join(":")'
    ```

  - [or](https://www.bbsmax.com/A/x9J2bBxgJ6/)
    ```bash
    $ curl -sSLg "http://${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)"
    Jenkins-Crumb:8b87b6ed98ef923******
    ```

  ![jenkins crumb](../screenshot/jenkins/jenkins-crumb.png)

### visit API via crumb
{% hint style='tip' %}
```bash
CRUMB=$(curl -sSLg http://jenkins.marslo.com/crumbIssuer/api/json | jq -r .crumb)
```
{% endhint %}

```bash
$ curl -H "Jenkins-Crumb:${CRUMB}" \
          http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters \
          -d 'cities=Lanzhou'
```
[or](https://www.jenkins.io/doc/book/using/remote-access-api/#RemoteaccessAPI-Submittingjobs)
```bash
$ curl -H "Jenkins-Crumb:${CRUMB}" \
          http://jenkins.marslo.com/job/marslo/job/sandbox/buildWithParameters \
          --data 'cities=Leshan,Chengdu' \
          --data 'provinces=Sichuan'
```
#### [build a job using the REST API and cURL](https://support.cloudbees.com/hc/en-us/articles/218889337-How-to-build-a-job-using-the-REST-API-and-cURL-)
```bash
$ curl -X POST http://developer:developer@localhost:8080/job/test/build
# build with parameters
$ curl -X POST \
          http://developer:developer@localhost:8080/job/test/build \
          --data-urlencode json='{"parameter": [{"name":"paramA", "value":"123"}]}'
```

### [restart Jenkins instance](https://support.cloudbees.com/hc/en-us/articles/216118748-How-to-Start-Stop-or-Restart-your-Instance-)
{% hint style='tip' %}
```bash
CRUMB=$(curl -sSLg http://jenkins.marslo.com/crumbIssuer/api/json | jq -r .crumb)
```
{% endhint %}

```bash
$ curl -X POST \
       -H "Jenkins-Crumb:${CRUMB}" \
       http://jenkins.marslo.com/safeRestart
```

