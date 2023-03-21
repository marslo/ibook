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
> - [Kubectl Config Set-Context | Tutorial and Best Practices](https://www.containiq.com/post/kubectl-config-set-context-tutorial-and-best-practices)
> - [Checklist: pros and cons of using multiple Kubernetes clusters, and how to distribute workloads between them](http://vadimeisenberg.blogspot.com/2019/03/multicluster-pros-and-cons.html)
{% endhint %}


> [!NOTE]
> others:
> - [Introducing kubectl](https://kubebyexample.com/learning-paths/application-development-kubernetes/lesson-1-running-containerized-applications)


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
