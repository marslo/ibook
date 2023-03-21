<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [step by step](#step-by-step)
  - [defining clusters](#defining-clusters)
  - [defining users](#defining-users)
  - [defining contexts](#defining-contexts)
  - [use contexts](#use-contexts)
- [OpenID Connect ( OIDC )](#openid-connect--oidc-)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




{% hint style='info' %}
> references:
> - [创建k8s context](https://www.cnblogs.com/tiny1987/p/12018080.html)
> - [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
> - [Organizing Cluster Access Using kubeconfig Files](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/)
> - [kubectl config](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config)
> - [Kubectl Config Set-Context | Tutorial and Best Practices](https://www.containiq.com/post/kubectl-config-set-context-tutorial-and-best-practices)
> - [Checklist: pros and cons of using multiple Kubernetes clusters, and how to distribute workloads between them](http://vadimeisenberg.blogspot.com/2019/03/multicluster-pros-and-cons.html)
> - [kubectl config view](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_config_view/)
>
> others:
> - [Introducing kubectl](https://kubebyexample.com/learning-paths/application-development-kubernetes/lesson-1-running-containerized-applications)
{% endhint %}

## step by step

### defining clusters
```bash
$ kubectl config set-cluster my-cluster --server=127.0.0.1:8087
```

### defining users
- using token
  ```bash
  $ kubectl config set-credentials my-user --token=Py93bt12mT
  ```
- using basic authentication
  ```bash
  $ kubectl config set-credentials my-user --username=redhat-username --password=redhat-password
  ```

- using certificates
  ```bash
  $ kubectl config set-credentials my-user --client-certificate=redhat-certificate.crt --client-key=redhat-key.key
  ```

### defining contexts
```bash
$ kubectl config set-context --cluster=my-cluster --user=my-user
```

- by namespace
  ```bash
  $ kubectl config set-context my-context --cluster=my-cluster --user=my-user --namespace=redhat-dev
  ```

### use contexts
```bash
$ kubectl config use-context my-context
```

- verify
  ```bash
  $ kubectl config get-contexts
  CURRENT   NAME            CLUSTER           AUTHINFO      NAMESPACE
  *         my-context      172.0.7.2:6443    my-user       redhat-dev
            my-context-2    172.1.8.0:6443    my-user-2

  $ kubectl config current-context
  my-context
  ```

## OpenID Connect ( OIDC )
```bash
echo "-----BEGIN CERTIFICATE-----
....
-----END CERTIFICATE-----
" \ > ca-kubernetes-staging.pem

## set cluster
kubectl config set-cluster kubernetes-staging \
               --server=https://127.0.7.2:6443 \
               --certificate-authority=ca-kubernetes-staging.pem \
               --embed-certs

## set credential
kubectl config set-credentials marslo@kubernetes-staging  \
               --auth-provider=oidc  \
               --auth-provider-arg='idp-issuer-url=https://dex-k8s.sample.com/'  \
               --auth-provider-arg='client-id=dex-k8s-authenticator'  \
               --auth-provider-arg='client-secret=Z**********************0' \
               --auth-provider-arg='refresh-token=C**********************************************************************n' \
               --auth-provider-arg='id-token=e**********************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************A'

## set context
kubectl config set-context kubernetes-staging --cluster=kubernetes-staging --user=marslo@kubernetes-staging

## use context
kubectl config use-context kubernetes-staging
```

- verify
  ```bash
  # get id-token
  $ kubectl config view -o jsonpath='{.users[?(@.name == "marslo@kubernetes-staging")].user.auth-provider.config.id-token}'

  # get the password for the `e2e` user
  $ kubectl config view -o jsonpath='{.users[?(@.name == "e2e")].user.password}'
  ```

## [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)

> [!TIP]
> a configuration file describes `clusters`, `users`, and `contexts`

- set clusters
  ```bash
  # cluster development
  $ kubectl config --kubeconfig=config-demo \
                   set-cluster development \
                   --server=https://1.2.3.4 \
                   --certificate-authority=fake-ca-file

  # cluster test
  $ kubectl config --kubeconfig=config-demo \
                   set-cluster test \
                   --server=https://5.6.7.8 \
                   --insecure-skip-tls-verify
  ```
- set user

  > [!NOTE]
  > - To delete a user you can run `kubectl --kubeconfig=config-demo config unset users.<name>`
  > - To remove a cluster, you can run `kubectl --kubeconfig=config-demo config unset clusters.<name>`
  > - To remove a context, you can run `kubectl --kubeconfig=config-demo config unset contexts.<name>`

  ```bash
  # with CA
  $ kubectl config --kubeconfig=config-demo \
                   set-credentials developer \
                   --client-certificate=fake-cert-file \
                   --client-key=fake-key-seefile

  # with basic authentication
  $ kubectl config --kubeconfig=config-demo \
                   set-credentials experimenter \
                   --username=exp \
                   --password=some-password
  ```

- add context
  ```bash
  # user developer namespace frontend
  $ kubectl config --kubeconfig=config-demo \
                   set-context dev-frontend \
                   --cluster=development \
                   --namespace=frontend \
                   --user=developer

  # user developer namespace storage
  $ kubectl config --kubeconfig=config-demo \
                   set-context dev-storage \
                   --cluster=development \
                   --namespace=storage \
                   --user=developer

  # user experimenter
  $ kubectl config --kubeconfig=config-demo \
                   set-context exp-test \
                   --cluster=test \
                   --namespace=default \
                   --user=experimenter
  ```

- result
  ```bash
  $ kubectl config --kubeconfig=config-demo get-contexts
  CURRENT   NAME           CLUSTER       AUTHINFO       NAMESPACE
            dev-frontend   development   developer      frontend
            dev-storage    development   developer      storage
            exp-test       test          experimenter   default

  $ kubectl config --kubeconfig=config-demo view
  apiVersion: v1
  clusters:
  - cluster:
      certificate-authority: fake-ca-file
      server: https://1.2.3.4
    name: development
  - cluster:
      insecure-skip-tls-verify: true
      server: https://5.6.7.8
    name: test
  contexts:
  - context:
      cluster: development
      namespace: frontend
      user: developer
    name: dev-frontend
  - context:
      cluster: development
      namespace: storage
      user: developer
    name: dev-storage
  - context:
      cluster: test
      namespace: default
      user: experimenter
    name: exp-test
  current-context: ""
  kind: Config
  preferences: {}
  users:
  - name: developer
    user:
      client-certificate: fake-cert-file
      client-key: fake-key-seefile
  - name: experimenter
    user:
      password: some-password
      username: exp
  ```

- use context
  ```bash
  $ kubectl config --kubeconfig=config-demo use-context dev-frontend
  Switched to context "dev-frontend".

  $ kubectl config --kubeconfig=config-demo get-contexts
  CURRENT   NAME           CLUSTER       AUTHINFO       NAMESPACE
  *         dev-frontend   development   developer      frontend
            dev-storage    development   developer      storage
            exp-test       test          experimenter   default

  $ kubectl config --kubeconfig=config-demo view --minify
  apiVersion: v1
  clusters:
  - cluster:
      certificate-authority: fake-ca-file
      server: https://1.2.3.4
    name: development
  contexts:
  - context:
      cluster: development
      namespace: frontend
      user: developer
    name: dev-frontend
  current-context: dev-frontend
  kind: Config
  preferences: {}
  users:
  - name: developer
    user:
      client-certificate: fake-cert-file
      client-key: fake-key-seefile
  ```

### [Create a second configuration file](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#create-a-second-configuration-file)
- `KUBECONFIG` environment variable
  - linux
    ```bash
    $ export KUBECONFIG_SAVED="$KUBECONFIG"
    ```
  - windows
    ```powershell
    > $Env:KUBECONFIG_SAVED=$ENV:KUBECONFIG
    ```

- temporarily append two paths to your kubeconfig environment variable
  - linux
    ```bash
    $ export KUBECONFIG="${KUBECONFIG}:config-demo:config-demo-2"
    ```
  - windows
    ```powershell
    > $Env:KUBECONFIG=("config-demo;config-demo-2")
    ```

- [Append $HOME/.kube/config to your KUBECONFIG environment variable](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#append-home-kube-config-to-your-kubeconfig-environment-variable)
  - linux
    ```bash
    $ export KUBECONFIG="${KUBECONFIG}:${HOME}/.kube/config"
    ```
  - windows
    ```powershell
    > $Env:KUBECONFIG="$Env:KUBECONFIG;$HOME\.kube\config"
    ```

### [Clean up](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/#clean-up)
- linux
  ```bash
  $ export KUBECONFIG="$KUBECONFIG_SAVED"
  ```
- windows
  ```powershell
  > $Env:KUBECONFIG=$ENV:KUBECONFIG_SAVED
  ```

### [with Proxy](https://kubernetes.io/docs/concepts/configuration/organize-cluster-access-kubeconfig/#proxy)
```bash
apiVersion: v1
kind: Config

clusters:
- cluster:
    proxy-url: http://proxy.example.org:3128
    server: https://k8s.example.org/k8s/clusters/c-xxyyzz
  name: development

users:
- name: developer

contexts:
- context:
  name: development
```
