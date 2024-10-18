<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [helm](#helm)
- [CNI](#cni)
  - [calico](#calico)
  - [flannel](#flannel)
- [ingress](#ingress)
  - [ingress-nginx](#ingress-nginx)
- [monitoring](#monitoring)
  - [metrics-server](#metrics-server)
  - [kubernetes-dashboard](#kubernetes-dashboard)
    - [ingress for kubernetes-dashboard](#ingress-for-kubernetes-dashboard)
    - [RBAC](#rbac)
  - [prometheus stack](#prometheus-stack)
    - [grafana](#grafana)
- [tls](#tls)
  - [import tls](#import-tls)
  - [copy tls](#copy-tls)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!TIP|label:references]
> - [see also: iMarlso: tools](../tools.md)

# helm
```bash
$ curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
Downloading https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

# CNI
## calico
```bash
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/tigera-operator.yaml
$ kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.1/manifests/custom-resources.yaml

# verify
$ kubectl get pods -n calico-system
```

- calico tools

  > [!NOTE|label:references:]
  > - [install calicoctl](https://docs.tigera.io/calico/latest/operations/calicoctl/install)

  ```bash
  # calicoctl
  $ curl -L https://github.com/projectcalico/calico/releases/download/v3.28.1/calicoctl-linux-amd64 -o calicoctl
  $ chmod +x calicoctl
  $ sudo mv calicoctl /usr/local/bin/

  # kubectl-calico
  $ curl -L https://github.com/projectcalico/calico/releases/download/v3.28.1/calicoctl-linux-amd64 -o kubectl-calico
  $ chmod +x kubectl-calico
  $ sudo mv kubectl-calico /usr/local/bin/
  ```

## flannel

> [!NOTE|label:references:]
> - [#2695 dial tcp 10.96.0.1:443 timeout](https://github.com/projectcalico/calico/issues/2695)
> - [k8s安装插件出现dial tcp 10.96.0.1:443: i/o timeout问题解析](https://blog.csdn.net/qq_44847649/article/details/123504663)
> - [kube-flannel.yml](https://www.cnblogs.com/chaojiyingxiong/p/16896593.html)
> - [Kubernetes / Flannel – Failed to list *v1.Service](https://www.thenoccave.com/2020/08/kubernetes-flannel-failed-to-list-v1-service/)
>   - `$ cat /run/flannel/subnet.env`
>   - `$ kubectl get nodes k8s-node-01 -o jsonpath='{.spec.podCIDR}'`

- modify
  ```bash
  $ kubectl edit cm -n kube-system kube-flannel-cfg
  net-conf.json: |
       {
         "Network": "10.244.0.0/16",
         "Backend": {
           "Type": "vxlan"
         }
       }
  ```

- check
  ```bash
  $ kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'

  # e.g.: flannel
  $ kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
  10.244.21.0/24 10.244.4.0/24 10.244.1.0/24 10.244.10.0/24 10.244.20.0/24 10.244.7.0/24 10.244.5.0/24 10.244.17.0/24 10.244.3.0/24 10.244.0.0/24 10.244.6.0/24 10.244.12.0/24 10.244.13.0/24 10.244.16.0/24 10.244.15.0/24
  ```

# ingress

> [!NOTE|label:references:]
> - [入门级实操教程！从概念到部署，全方位了解 K8S Ingress](https://www.infoq.cn/article/vl7SZGQc2JUaM6IisAhE)
> - [k8s指南-Ingress](https://blog.csdn.net/xiaoyi52/article/details/128289679)

## ingress-nginx
```bash
$ helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
$ helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace

# or
$ helm upgrade --install ingress-nginx ingress-nginx \
       --repo https://kubernetes.github.io/ingress-nginx \
       --namespace ingress-nginx --create-namespace

# check value
$ helm show values ingress-nginx --repo https://kubernetes.github.io/ingress-nginx
```

# monitoring
## metrics-server
```bash
$ helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
$ helm upgrade --install metrics-server metrics-server/metrics-server --namespace monitoring --create-namespace

# without tls: https://github.com/kubernetes-sigs/metrics-server/issues/1221
$ helm upgrade metrics-server metrics-server/metrics-server --set args="{--kubelet-insecure-tls}" --namespace monitoring
```

## kubernetes-dashboard

> [!NOTE|label:references:]
> - [Configure Kubernetes Dashboard Web UI hosted with Nginx Ingress Controller](https://gist.github.com/s-lyn/3aba97628c922ddc4a9796ac31a6df2d)
> - [Enabling Kubernetes Dashboard over HTTPS with RBAC Authorization](https://blog.zachinachshon.com/k8s-dashboard/)
>   - Admin User
>   - Cluster Admin User
>   - Ready-only User
>   - Access via kubeconfig

```bash
# add kubernetes-dashboard repository
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
$ helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
```

### ingress for kubernetes-dashboard
```yaml
# v7.x
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard
  namespace: monitoring
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/secure-backends: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - sms-k8s-dashboard.sample.com
    secretName: sample-tls
  rules:
    - host: sms-k8s-dashboard.sample.com
      http:
        paths:
        - path: /
          backend:
            service:
              name: kubernetes-dashboard-kong-proxy
              port:
                number: 443
          pathType: Prefix
```

<!--sec data-title="older version" data-id="section0" data-show=true data-collapse=true ces-->
```yaml
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/secure-backends: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - sms-k8s-dashboard.sample.com
    secretName: sample-tls
  rules:
    - host: sms-k8s-dashboard.sample.com
      http:
        paths:
        - path: /
          backend:
            service:
              # or kubernetes-dashboard-kong-proxy for latest version
              name: kubernetes-dashboard
              port:
                number: 443
          pathType: Prefix
```
<!--endsec-->


### RBAC

#### [create admin user for kubernetes-dashboard](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md)

> [!NOTE|label:references:]
> - [Creating sample user](https://github.com/kubernetes/dashboard/blob/master/docs/user/access-control/creating-sample-user.md#creating-sample-user)
>   - using `ClusterRole` : `cluster-admin` for `kubernetes-dashboard-admin`
> - [Kubernetes - Dashboard 配置用户名密码方式登录](https://blog.csdn.net/lookboydfw/article/details/138320111)

- create ServiceAccount in namespace
  ```bash
  $ kubectl -n monitoring create serviceaccount kubernetes-dashboard-admin
  ```

- create ClusterRoleBinding for ServiceAccount
  ```bash
  $ kubectl create clusterrolebinding kubernetes-dashboard-admin \
            --clusterrole=cluster-admin \                              # default ClusterRole
            --serviceaccount=monitoring:kubernetes-dashboard-admin     # service account

  $ kubectl get clusterrolebinding kubernetes-dashboard-admin -o yaml | grep -v -E 'uid:|resourceVersion:|creationTimestamp:'
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: kubernetes-dashboard-admin
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard-admin
    namespace: monitoring
  ```

- generate token
  ```bash
  # admin
  $ kubectl -n monitoring create token kubernetes-dashboard-admin

  # normal user
  $ kubectl -n monitoring create token kubernetes-dashboard-metrics-scraper
  ```

- [manually create a long-lived api token for a serviceaccount](https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/#manually-create-a-long-lived-api-token-for-a-serviceaccount)
  ```bash
  $ kubectl -n monitoring apply -f - <<EOF
  apiVersion: v1
  kind: Secret
  metadata:
    name: kubernetes-dashboard-admin-token
    namespace: monitoring
    annotations:
      kubernetes.io/service-account.name: kubernetes-dashboard-admin
  type: kubernetes.io/service-account-token
  EOF

  # get token by service account
  $ kubectl -n monitoring get secrets -o jsonpath="{.items[?(@.metadata.annotations['kubernetes\.io/service-account\.name']=='kubernetes-dashboard-admin')].data.token}" | base64 -d
  # or
  $ kubectl -n monitoring get secrets -o jsonpath="{.items[?(@.metadata.annotations.kubernetes\.io/service-account\.name=='kubernetes-dashboard-admin')].data.token}" | base64 -d

  # or get token by describe token
  $ kubectl -n monitoring describe secrets $(kubectl -n monitoring get secret | grep kubernetes-dashboard-admin | awk '{print $1}') | grep 'token' | awk '{print $2}'
  ```

- or modify ClusterRole `kubernetes-dashboard-metrics-scraper` manually

  <!--sec data-title="manual modify ClusterRole" data-id="section1" data-show=true data-collapse=true ces-->

  > [!TIP]
  > for v7.x

  - clusterrole: `kubernetes-dashboard-metrics-scraper`
    ```yaml
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      annotations:
        meta.helm.sh/release-name: kubernetes-dashboard
        meta.helm.sh/release-namespace: monitoring
      labels:
        app.kubernetes.io/instance: kubernetes-dashboard
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/part-of: kubernetes-dashboard
        helm.sh/chart: kubernetes-dashboard-7.5.0
      name: kubernetes-dashboard-metrics-scraper
    rules:
    - apiGroups:
      - '*'
      resources:
      - '*'
      verbs:
      - '*'
    ```

    - original
      ```yaml
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
        annotations:
          meta.helm.sh/release-name: kubernetes-dashboard
          meta.helm.sh/release-namespace: monitoring
        labels:
          app.kubernetes.io/instance: kubernetes-dashboard
          app.kubernetes.io/managed-by: Helm
          app.kubernetes.io/part-of: kubernetes-dashboard
          helm.sh/chart: kubernetes-dashboard-7.5.0
        name: kubernetes-dashboard-metrics-scraper
      rules:
      - apiGroups:
        - metrics.k8s.io
        resources:
        - pods
        - nodes
        verbs:
        - get
        - list
        - watch
      ```

  - clusterrolebinding: `kubernetes-dashboard-metrics-scraper`
    ```bash
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      annotations:
        meta.helm.sh/release-name: kubernetes-dashboard
        meta.helm.sh/release-namespace: monitoring
      labels:
        app.kubernetes.io/instance: kubernetes-dashboard
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/part-of: kubernetes-dashboard
        helm.sh/chart: kubernetes-dashboard-7.5.0
      name: kubernetes-dashboard-metrics-scraper
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: kubernetes-dashboard-metrics-scraper
    subjects:
    - kind: ServiceAccount
      name: kubernetes-dashboard-metrics-scraper
      namespace: monitoring
    ```

  - serviceaccount: `kubernetes-dashboard-metrics-scraper`
    ```bash
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      annotations:
        meta.helm.sh/release-name: kubernetes-dashboard
        meta.helm.sh/release-namespace: monitoring
      labels:
        app.kubernetes.io/instance: kubernetes-dashboard
        app.kubernetes.io/managed-by: Helm
        app.kubernetes.io/part-of: kubernetes-dashboard
        helm.sh/chart: kubernetes-dashboard-7.5.0
      name: kubernetes-dashboard-metrics-scraper
      namespace: monitoring
    ```

  - generate token
    ```bash
    $ kubectl -n monitoring create token kubernetes-dashboard-metrics-scraper
    ey**********************WAA
    ```
  <!--endsec-->

  - older version

    <!--sec data-title="older version" data-id="section2" data-show=true data-collapse=true ces-->
    - clusterrole
      ```bash
      $ kubectl get clusterrole kubernetes-dashboard -o yaml
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRole
      metadata:
        labels:
          k8s-app: kubernetes-dashboard
        name: kubernetes-dashboard
      rules:
      - apiGroups:
        - '*'
        resources:
        - '*'
        verbs:
        - '*'
      ```

    - clusterrolebinding
      ```bash
      $ kubectl -n kube-system get clusterrolebindings kubernetes-dashboard -o yaml
      apiVersion: rbac.authorization.k8s.io/v1
      kind: ClusterRoleBinding
      metadata:
        name: kubernetes-dashboard
      roleRef:
        apiGroup: rbac.authorization.k8s.io
        kind: ClusterRole
        name: kubernetes-dashboard
      subjects:
      - kind: ServiceAccount
        name: kubernetes-dashboard
        namespace: kube-system
      ```

    - serviceaccount
      ```bash
      $ kubectl -n kube-system get sa kubernetes-dashboard -o yaml
      apiVersion: v1
      kind: ServiceAccount
      metadata:
        labels:
          k8s-app: kubernetes-dashboard
        name: kubernetes-dashboard
        namespace: kube-system
      ```

    - generate token
      ```bash
      $ kubectl -n kube-system create token kubernetes-dashboard
      ey**********************WAA
      ```
    <!--endsec-->


## prometheus stack

> [!NOTE|label:references:]
> - [assign different port for node-exporter in kube-prometheus-stack](https://stackoverflow.com/a/75427221/2940319)
> - [Prometheus+Grafana监控K8S集群(基于K8S环境部署)](https://blog.csdn.net/weixin_45623111/article/details/135381921)
> - [Grafana dashboard best practices](https://grafana.com/docs/grafana/latest/dashboards/build-dashboards/best-practices/):
>   - [* iMarslo: grafana dashboard](../monitor.md#dashboard)
>  - cluster level: 13332、13824、14518

```bash
$ helm repo add prometheus-stack https://prometheus-community.github.io/helm-charts
"prometheus-stack" has been added to your repositories

$ helm upgrade --install prometheus-stack prometheus-stack/kube-prometheus-stack --namespace monitoring

# if node-exporter has been deployed by kubespary, assign another port for kube-prometheus-stack
$ helm upgrade --install prometheus-stack prometheus-stack/kube-prometheus-stack \
               --namespace monitoring \
               --set prometheus-node-exporter.service.port=9200
Release "prometheus-stack" has been upgraded. Happy Helming!
NAME: prometheus-stack
LAST DEPLOYED: Tue Sep 10 22:53:40 2024
NAMESPACE: monitoring
STATUS: deployed
REVISION: 2
NOTES:
kube-prometheus-stack has been installed. Check its status by running:
  kubectl --namespace monitoring get pods -l "release=prometheus-stack"

Visit https://github.com/prometheus-operator/kube-prometheus for instructions on how to create & configure Alertmanager and Prometheus instances using the Operator.
```

#### ingress

- grafana

  > [!NOTE|label:references]
  > - [#1748 - Expose Grafana with Ingress](https://github.com/prometheus-operator/kube-prometheus/issues/1748)

  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: prometheus-stack-grafana
    namespace: monitoring
    annotations:
      kubernetes.io/ingress.class: "nginx"
      nginx.ingress.kubernetes.io/secure-backends: "true"
  spec:
    ingressClassName: nginx
    tls:
    - hosts:
      - sms-k8s-grafana.sample.com
      secretName: sample-tls
    rules:
      - host: sms-k8s-grafana.sample.com
        http:
          paths:
          - path: /
            backend:
              service:
                name: prometheus-stack-grafana
                port:
                  number: 80
            pathType: Prefix
  ```

- prometheus
  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: prometheus
    namespace: monitoring
    annotations:
      kubernetes.io/ingress.class: "nginx"
  spec:
    ingressClassName: nginx
    tls:
    - hosts:
      - sms-k8s-prometheus.marvell.com
      secretName: marvell-tls
    rules:
      - host: sms-k8s-prometheus.marvell.com
        http:
          paths:
          - path: /
            backend:
              service:
                name: prometheus-stack-kube-prom-prometheus
                port:
                  number: 9090
            pathType: Prefix
  ```

- alertmanager
  ```yaml
  ---
  apiVersion: networking.k8s.io/v1
  kind: Ingress
  metadata:
    name: alertmanager
    namespace: monitoring
    annotations:
      kubernetes.io/ingress.class: "nginx"
  spec:
    ingressClassName: nginx
    tls:
    - hosts:
      - sms-k8s-alertmgr.marvell.com
      secretName: marvell-tls
    rules:
      - host: sms-k8s-alertmgr.marvell.com
        http:
          paths:
          - path: /
            backend:
              service:
                name: prometheus-stack-kube-prom-alertmanager
                port:
                  number: 9093
            pathType: Prefix
  ```

#### admin account for grafana
```bash
# account
$ kubectl get secret --namespace monitoring prometheus-stack-grafana -o jsh='{.data.admin-user}' | base64 -d; echo

# password
$ kubectl get secret --namespace monitoring prometheus-stack-grafana -o jsonpath='{.data.admin-password}' | base64 -d; echo
```

### grafana
```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo list
NAME                    URL
kubernetes-dashboard    https://kubernetes.github.io/dashboard/
ingress-nginx           https://kubernetes.github.io/ingress-nginx
grafana                 https://grafana.github.io/helm-charts

$ helm repo update
$ helm search repo grafana/grafana

$ helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

# tls
## import tls
```bash
$ sudo kubectl -n kube-system create secret tls sample-tls --cert star_sample_com.full.crt --key star_sample_com.key --dry-run=client -o yaml > kube-system.sample-tls.yaml
```

## copy tls
```bash
$ kubectl --namespace=kube-system get secrets sample-tls -o yaml | grep -v '^\s*namespace:\s' | kubectl apply --namespace=monitoring -f -
secret/sample-tls created

$ kubectl --namespace=kube-system get secrets sample-tls -o yaml | grep -v '^\s*namespace:\s' | kubectl apply --namespace=kubernetes-dashboard -f -
secret/sample-tls created

$ kubectl --namespace=kube-system get secrets sample-tls -o yaml | grep -v '^\s*namespace:\s' | kubectl apply --namespace=ingress-nginx -f -
secret/sample-tls created

$ kubectl --namespace=kube-system get secrets sample-tls -o yaml | grep -v '^\s*namespace:\s' | kubectl apply --namespace=default -f -
secret/sample-tls created
```
