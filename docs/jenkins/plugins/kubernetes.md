<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [namespace](#namespace)
- [generate credentials for pfx](#generate-credentials-for-pfx)
- [full steps](#full-steps)
- [configure in jenkins](#configure-in-jenkins)
- [using kubeconfig for remote cluster credential](#using-kubeconfig-for-remote-cluster-credential)
- [using ClusterRoleBinding](#using-clusterrolebinding)
- [Q&A](#qa)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Jenkins Kubernetes Plugin: Running Agents In Other Clusters](https://www.moogsoft.com/blog/jenkins-kubernetes-plugin-running-agents-in-other-clusters/)
> - [Jenkins Kubernetes Plugin: Using the plugin in your pipelines](https://www.moogsoft.com/blog/jenkins-kubernetes-plugin-using-the-plugin-in-your-pipelines/)
> - [Create Kubernetes Service Accounts and Kubeconfigs](https://docs.armory.io/armory-enterprise/armory-admin/manual-service-account/)
> - [Setup Jenkins Pipeline and Blue Ocean in Kubernetes](https://hustakin.github.io/bestpractice/setup-jenkins-pipeline-in-kubernetes/)
{% endhint %}

### namespace
#### namespace
```bash
$ cat << EOF | k apply -f -
  ---
  apiVersion: v1
  kind: Namespace
  metadata:
    name: jenkins
EOF
namespace/jenkins created
```

#### quota
```bash
$ cat << EOF | k apply -f -
  apiVersion: v1
  kind: ResourceQuota
  metadata:
    name: jenkins-quota
    namespace: jenkins
  spec:
    hard:
      requests.cpu: "16"
      requests.memory: 16Gi
      limits.cpu: "32"
      limits.memory: 32Gi
EOF
resourcequota/jenkins-quota edited
```

### generate credentials for pfx
#### ca.crt
```bash
$ grep certificate-authority-data ~/.kube/config | awk -F': ' '{print $NF}' |  base64 -d > ca.crt
# OR
$ sudo cat /etc/kubernetes/pki/ca.crt
```

#### client.crt & client.key
```bash
$ grep client-certificate-data ~/.kube/config | awk -F': ' '{print $NF}' |  base64 -d > client.crt
$ grep client-key-data ~/.kube/config | awk -F': ' '{print $NF}' |  base64 -d > client.key
```

#### cert.pfx
```bash
$ openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
Enter Export Password:
Verifying - Enter Export Password:

$ ls
ca.crt  cert.pfx  client.crt  client.key

# or

# using password 'marslo'
$ openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt -password pass:marslo
```

### full steps
```bash
$ cat ~/.kube/config \
      | grep certificate-authority-data \
      | awk '{print $2}' \
      | base64 -d > ca.crt
$ cat ~/.kube/config \
      | grep client-certificate-data \
      | awk '{print $2}' \
      | base64 -d > client.crt
$ cat ~/.kube/config \
      | grep client-key-data \
      | awk '{print $2}' \
      | base64 -d > client.key
$ openssl pkcs12 -export \
                 -out cert.pfx \
                 -in client.crt \
                 -inkey client.key \
                 -certfile ca.crt \
                 -password pass:devops
```

### configure in jenkins
* Go to `Manage Jenkins` -> `Configure System` or `Manage Jenkins` -> `Manage Nodes and Clouds` -> `Configure Clouds`
* `Add a new Cloud` -> `Kuberentes`
  * `Name`: <Anything you want>
  * `Kubernetes URL`:
    * get from `$ kubectl cluster-info`
    * using `https://kubernetes.default.svc.cluster.local`
  * `Kubernetes server certificate key`: content of `ca.crt`. (`$ cat ca.crt`)
  * `Credentials`:
    * `Add` -> `Jenkins`
    * **Kind**: `Certificate`

![plugin-1](../../screenshot/jenkins/k8s-plugin-1.png)

![plugin-2](../../screenshot/jenkins/k8s-plugin-2.png)

![plugin-3](../../screenshot/jenkins/k8s-plugin-3.png)

![plugin-4](../../screenshot/jenkins/k8s-plugin-4.png)

* Setup in Jenkins

![plugin-5](../../screenshot/jenkins/k8s-plugin-5.png)


### using kubeconfig for remote cluster credential

{% hint style='tip' %}
> reference:
> - [jenkinsci/kubernetes-cli-plugin](https://github.com/jenkinsci/kubernetes-cli-plugin/blob/master/README.md#using-the-plugin-from-the-web-interface)
> - [Kubernetes Plugin: Authenticate with a ServiceAccount to a remote cluster](https://support.cloudbees.com/hc/en-us/articles/360038636511-Kubernetes-Plugin-Authenticate-with-a-ServiceAccount-to-a-remote-cluster)
> - [Creating a kubeconfig file for a self-hosted Kubernetes cluster](http://docs.shippable.com/deploy/tutorial/create-kubeconfig-for-self-hosted-kubernetes-cluster/)
> - [How to find your Jenkins admin password on Kubernetes](https://opensource.com/article/19/6/jenkins-admin-password-helm-kubernetes)
{% endhint %}

#### get Kubernetes URL
```bash
$ k config view --minify | sed -n -re 's/^.*server: (https.*)$/\1/p'
```

- [or](https://gist.github.com/miry/9fbb8947510294c25285bda2a6e11900#gistcomment-2952487)
  ```bash
  $ k config view --minify --raw --output 'jsonpath={..cluster.server}'
  ```

#### generate CA

{% hint style='tip' %}
the content can be also found in `kubernetes-master:/etc/kubernetes/pki/ca.crt`
{% endhint %}

```bash
$ k -n jenkins get secret \
              $(k -n jenkins get sa jenkins-admin -o jsonpath={.secrets[0].name}) \
              -o jsonpath={.data.'ca\.crt'} \
              | base64 --decode
```
- or
  ```bash
  $ cat ~/.kube/config \
        | grep certificate-authority-data \
        | awk '{print $2}' \
        | base64 -d > ca.crt
  ```

#### Generate token in kubernetes
{% hint style='tip' %}
```bash
$ namespace='devops'
$ serviceAccount='jenkins-admin'
$ alias k='kubectl'
```
{% endhint %}

- setup sa
  ```bash
  $ k -n jenkins create sa jenkins-admin
  $ k -n jenkins create rolebinding jenkins-admin-binding \
                       --clusterrole=cluster-admin \
                       --serviceaccount=devops:jenkins-admin
  ```
- get token
  {% raw %}
  ```bash
  $ k -n jenkins \
         get sa jenkins-admin \
         -o go-template \
         --template='{{range .secrets}}{{.name}}{{"\n"}}{{end}}'
  jenkins-admin-token-kshsh

  $ k -n jenkins \
         get secrets jenkins-admin-token-kshsh \
         -o go-template \
         --template '{{index .data "token"}}' \
         | base64 -d
  eyJhbGciOiJSUzI1NiIsImtpZCI6IiJ9.***
  ```
  {% endraw %}

  more info
  ```bash
  $ k get secret -n jenkins
  NAME                        TYPE                                  DATA   AGE
  default-token-8k7vj         kubernetes.io/service-account-token   3      27m
  jenkins-admin-token-9r8pt   kubernetes.io/service-account-token   3      21m

  $ k -n jenkins get rolebinding
  NAME                    AGE
  jenkins-admin-binding   15m
  $ k -n jenkins describe rolebinding jenkins-admin-binding
  Name:         jenkins-admin-binding
  Labels:       <none>
  Annotations:  <none>
  Role:
    Kind:  ClusterRole
    Name:  cluster-admin
  Subjects:
    Kind            Name           Namespace
    ----            ----           ---------
    ServiceAccount  jenkins-admin  jenkins

  $ k describe clusterrolebindings jenkins-admin-cluster-binding
  Name:         jenkins-admin-cluster-binding
  Labels:       <none>
  Annotations:  <none>
  Role:
    Kind:  ClusterRole
    Name:  cluster-admin
  Subjects:
    Kind            Name           Namespace
    ----            ----           ---------
    ServiceAccount  jenkins-admin  jenkins
  ```

  - [or](https://support.cloudbees.com/hc/en-us/articles/360038636511-Kubernetes-Plugin-Authenticate-with-a-ServiceAccount-to-a-remote-cluster)
    ```bash
    $ k -n jenkins \
        get secret \
        $(k -n jenkins get sa jenkins-admin -o jsonpath={.secrets[0].name}) \
        -o jsonpath={.data.token} \
        | base64 --decode
    ```
  - [or](https://stackoverflow.com/a/48853727/2940319)
  {% raw %}
  ```bash
  $ k -n jenkins \
         get sa jenkins-admin \
         --template='{{range .secrets}}{{ .name }} {{end}}' \
         | xargs -n 1 k -n jenkins get secret \
                        --template='{{ if .data.token }}{{ .data.token }}{{end}}' \
                        | head -n 1 \
                        | base64 -d -
  ```
  {% endraw %}

#### setup in Jenkins
- credential setup
![kubeconfig cloud credential](../../screenshot/jenkins/kubeconfig-jenkins-admin-secretetxt.png)

- cloud setup
![kubeconfig cloud setup](../../screenshot/jenkins/kubeconfig-jenkins-admin.png)


### using ClusterRoleBinding

{% hint style='tip' %}
> references:
> - [Configure Service Accounts for Pods](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/)
> - [RoleBinding and ClusterRoleBinding](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#rolebinding-and-clusterrolebinding)
> - [Role and ClusterRole](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole)
> - [Jenkins minimal installation on Kubernetes](https://bootvar.com/jenkins-installation-on-kubernetes/)
{% endhint %}


> [!TIP]
> simplely it can be executed via commands:
> ```bash
> $ kubectl -n kube-system create sa <service-account>
> $ kubectl create clusterrolebinding <role-binding-name> --clusterrole cluster-admin --serviceaccount=<namespace>:<service-account>
> ```
> [!NOTE]: `<role-binding-name>` can be the same as `<service-account>`

```yaml
---
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    k8s-app: jenkins
  name: jenkins-admin
  namespace: jenkins
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
  namespace: jenkins
```

- using [RoleBinding](https://www.moogsoft.com/blog/jenkins-kubernetes-plugin-running-agents-in-other-clusters/)
  ```yaml
  ---
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: Role
  metadata:
   name: jenkins-admin
   namespace: jenkins
  rules:
  - apiGroups: [""]
   resources: ["pods"]
   verbs: ["create","delete","get","list","patch","update","watch"]
  - apiGroups: [""]
   resources: ["pods/exec"]
   verbs: ["create","delete","get","list","patch","update","watch"]
  - apiGroups: [""]
   resources: ["pods/log"]
    verbs: ["get","list","watch"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: RoleBinding
  metadata:
   name: jenkins-admin
   namespace: jenkins
  roleRef:
   apiGroup: rbac.authorization.k8s.io
   kind: Role
   name: jenkins-admin
  subjects:
  - kind: ServiceAccount
   name: jenkins-admin
  ```

- or [grant more permissions via RoleBinding](https://hustakin.github.io/bestpractice/setup-jenkins-pipeline-in-kubernetes/)
  ```yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    name: jenkins
    namespace: devops
  ---
  kind: ClusterRole
  apiVersion: rbac.authorization.k8s.io/v1beta1
  metadata:
    name: jenkins
  rules:
    - apiGroups: ["extensions", "apps"]
      resources: ["deployments"]
      verbs: ["create", "delete", "get", "list", "watch", "patch", "update"]
    - apiGroups: [""]
      resources: ["services"]
      verbs: ["create", "delete", "get", "list", "watch", "patch", "update"]
    - apiGroups: [""]
      resources: ["pods"]
      verbs: ["create","delete","get","list","patch","update","watch"]
    - apiGroups: [""]
      resources: ["pods/exec"]
      verbs: ["create","delete","get","list","patch","update","watch"]
    - apiGroups: [""]
      resources: ["pods/log"]
      verbs: ["get","list","watch"]
    - apiGroups: [""]
      resources: ["secrets"]
      verbs: ["get"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: ClusterRoleBinding
  metadata:
    name: jenkins
    namespace: devops
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: jenkins
  subjects:
    - kind: ServiceAccount
      name: jenkins
      namespace: devops
  ```

- or [get all permission via RoleBinding](https://docs.armory.io/armory-enterprise/armory-admin/manual-service-account/)
  ```yaml
  # spinnaker-role-and-rolebinding-target.yml
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: Role
  metadata:
    name: spinnaker-role
    namespace: target                       # Should be namespace you are granting access to
  rules:
  - apiGroups: ["*"]
    resources: ["*"]
    verbs: ["*"]
  ---
  apiVersion: rbac.authorization.k8s.io/v1
  kind: RoleBinding
  metadata:
    name: spinnaker-rolebinding
    namespace: target                       # Should be namespace you are granting access to
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: Role
    name: spinnaker-role                    # Should match name of Role
  subjects:
  - namespace: source                       # Should match namespace where SA lives
    kind: ServiceAccount
    name: spinnaker-service-account         # Should match service account name, above
  ```

### Q&A
- [Kubernetes agents are failing with `SocketTimeoutException: connect timed out`](https://support.cloudbees.com/hc/en-us/articles/360038066231-Kubernetes-agents-are-failing-with-SocketTimeoutException-connect-timed-out-)

- [Message: pods is forbidden: User "system:serviceaccount:jenkins:jenkins-admin" cannot list resource "pods" in API group](https://github.com/helm/charts/issues/1092#issuecomment-303292037)
  > solution:
  > - [lachie83/jenkins-service-account](https://gist.github.com/lachie83/17c1fff4eb58cf75c5fb11a4957a64d2)
  > - [see also](https://stackoverflow.com/a/59605326/2940319)
  > - [chukaofili/k8s-dashboard-admin-user.yaml](https://gist.github.com/chukaofili/9e94d966e73566eba5abdca7ccb067e6#file-k8s-dashboard-admin-user-yaml)

```bash
$ k -n <namespace> create rolebinding <sa>-binding \
                          --clusterrole=cluster-admin \
                          --serviceaccount=<namespace>:<sa>
$ k create clusterrolebinding jenkins-admin-cluster-binding \
                              --clusterrole cluster-admin \
                              --serviceaccount=<namespace>:jenkins-admin
```
  - thinking
    ```bash
    $ k -n jenkins auth can-i list pods --as jenkins-admin
    no

    $ k -n jenkins auth can-i list pods --as jenkins-admin-binding
    no

    $ k -n jenkins auth can-i list pods --as jenkins-admin-cluster-binding
    no
    ```