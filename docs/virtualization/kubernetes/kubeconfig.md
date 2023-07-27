<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [step by step](#step-by-step)
  - [defining clusters](#defining-clusters)
  - [defining users](#defining-users)
  - [defining contexts](#defining-contexts)
  - [setup default namespace](#setup-default-namespace)
  - [use contexts](#use-contexts)
- [OpenID Connect ( OIDC )](#openid-connect--oidc-)
- [Configure Access to Multiple Clusters](#configure-access-to-multiple-clusters)
  - [Create a second configuration file](#create-a-second-configuration-file)
  - [Clean up](#clean-up)
  - [with Proxy](#with-proxy)
- [get info](#get-info)
  - [basic view](#basic-view)
  - [server IP](#server-ip)
  - [get user](#get-user)
  - [get password](#get-password)
  - [get key](#get-key)
- [kubeadm-cfg.yml](#kubeadm-cfgyml)
- [have fun](#have-fun)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='info' %}
> references:
> - [* 创建 kubeconfig 文件](https://jimmysong.io/kubernetes-handbook/practice/create-kubeconfig.html)
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
>
> more usage:
> - [imarslo : kubectl config view](./certificates.html#basic-environment)
{% endhint %}

## step by step

### defining clusters
```bash
$ kubectl config set-cluster my-cluster --server=127.0.0.1:8087
```

#### [modify server](https://jamesdefabia.github.io/docs/user-guide/kubectl/kubectl_config_set-cluster/)
```bash
$ kubectl config set-cluster NAME --server=https://10.69.114.92:6443

# or
$ kubectl config set-cluster $(kubectl config current-context) --server=https://10.69.114.92:6443
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

### [setup default namespace](https://www.cloudytuts.com/tutorials/kubernetes/how-to-set-default-kubernetes-namespace/)
```bash
$ kubectl config set-context --current --namespace=<my_namespace>
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

> [!NOTE]
> references:
> - [cheatsheet : Kubectl context and configuration](https://kubernetes.io/docs/reference/kubectl/cheatsheet/#kubectl-context-and-configuration)

```bash
$ kubectl config set-cluster <my-cluster-name> --proxy-url=<my-proxy-url>

# i.e.
$ kubectl config set-cluster development --proxy-url=http://proxy.example.com:3128
```
- result
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

## get info

> [!INFO|label:references:]
> - [* imarslo : jsonpath](./pod.html#jsonpath)
> - [jsonpath support](https://kubernetes.io/docs/reference/kubectl/jsonpath/)
> - [JSONPath 支持](https://kubernetes.io/zh-cn/docs/reference/kubectl/jsonpath/)

### basic view
- get contexts list
  ```bash
  $ kubectl config --kubeconfig=config-demo get-contexts
  CURRENT   NAME           CLUSTER       AUTHINFO       NAMESPACE
  *         dev-frontend   development   developer      frontend
            dev-storage    development   developer      storage
            exp-test       test          experimenter   default
  ```
- get current context
  ```bash
  $ kubectl config --kubeconfig=config-demo current-context
  dev-frontend
  ```

- get clusters
  ```bash
  $ kubectl config --kubeconfig=config-demo get-clusters
  NAME
  development
  test
  ```

- get users
  ```bash
  $ kubectl config --kubeconfig=config-demo get-users
  NAME
  developer
  experimenter
  ```

### server IP
#### by cluster name
```bash
# get all cluster name
$ kubectl config --kubeconfig=config-demo view -o jsonpath="{.clusters[*].name}"
development test

$ kubectl config --kubeconfig=config-demo view \
                 -o jsonpath='{.clusters[?(@.name == "development")].cluster.server}'
https://1.2.3.4
```

#### current in-use via `--minify`

> [!NOTE]
> ```bash
> --minify=false:
>          Remove all information not used by current-context from the output
> ```

```bash
$ kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}'
https://1.2.3.4
# or
$ kubectl config view --minify -o jsonpath="{.clusters[].cluster.server}"
https://1.2.3.4

# more info
$ kubectl config view --minify -o jsonpath="{.clusters[*].name}"
development
# or
$ kubectl config view --minify -o jsonpath="{.clusters[].name}"
development
```

#### current in-use via `current-context`
```bash
# or get current cluster IP
$ kubectl config --kubeconfig=config-demo current-context
development
$ kubectl config --kubeconfig=config-demo view \
                 -o jsonpath="{.clusters[?(@.name == \"$(kubectl config --kubeconfig=config-demo current-context)\")].cluster.server}"
```


### get user
```bash
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[*].name}'
developer experimenter
```

### get password
```bash
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "experimenter")]}'
{"name":"experimenter","user":{"password":"some-password","username":"exp"}}

$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "experimenter")].user.password}'
some-password
```

### get key
```bash
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "developer")]}'
{"name":"developer","user":{"client-certificate":"fake-cert-file","client-key":"fake-key-seefile"}}
# or via base64 decoding
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "developer")]}' | base64 -d
    --minify=false:
  Remove all information not used by current-context from the output
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "developer")].user.client-key}'
fake-key-seefile
# or via base64 decoding
$ kubectl config --kubeconfig=config-demo view -o jsonpath='{.users[?(@.name == "developer")].user.client-key}' | base64 -d
```

## kubeadm-cfg.yml

> [!NOTE|label:references:]
> - [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/#kubeconfig-additional-users)

```bash
$ kubectl get cm kubeadm-config -n kube-system -o=jsonpath="{.data.ClusterConfiguration}"
```

## have fun
- [view config details](https://stackoverflow.com/a/53403859/2940319)
  ```bash
  exec >/tmp/output &&
  CONTEXT_NAME=kubernetes-admin@kubernetes \
  CONTEXT_CLUSTER=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${CONTEXT_NAME}\")].context.cluster}") \
  CONTEXT_USER=$(kubectl config view -o=jsonpath="{.contexts[?(@.name==\"${CONTEXT_NAME}\")].context.user}") && \
  echo "[" && \
  kubectl config view -o=json | jq -j --arg CONTEXT_NAME "$CONTEXT_NAME" '.contexts[] | select(.name==$CONTEXT_NAME)' && \
  echo "," && \
  kubectl config view -o=json | jq -j --arg CONTEXT_CLUSTER "$CONTEXT_CLUSTER" '.clusters[] | select(.name==$CONTEXT_CLUSTER)' && \
  echo "," && \
  kubectl config view -o=json | jq -j --arg CONTEXT_USER "$CONTEXT_USER" '.users[] | select(.name==$CONTEXT_USER)' && \
  echo -e "\n]\n" && \
  exec >/dev/tty && \
  cat /tmp/output | jq && \
  rm -rf /tmp/output
  ```

  - [or](https://stackoverflow.com/a/53403319/2940319)
    ```bash
    $ kubectl config view -o json |
      jq '. as $o
            | ."current-context" as $current_context_name
            | $o.contexts[] | select(.name == $current_context_name) as $context
            | $o.clusters[] | select(.name == $context.context.cluster) as $cluster
            | $o.users[] | select(.name == $context.context.user) as $user
            | {"current-context-name": $current_context_name, context: $context, cluster: $cluster, user: $user}'
    ```
