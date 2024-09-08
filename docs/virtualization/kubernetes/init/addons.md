<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [helm](#helm)
- [monitoring](#monitoring)
  - [kubernetes-dashboard](#kubernetes-dashboard)
  - [grafana](#grafana)
  - [metrics-server](#metrics-server)
- [CNI](#cni)
  - [calico](#calico)
  - [flannel](#flannel)
- [ingress](#ingress)
  - [ingress-nginx](#ingress-nginx)
- [tls](#tls)
  - [import tls](#import-tls)
  - [copy tls](#copy-tls)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## helm
```bash
$ curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
Downloading https://get.helm.sh/helm-v3.15.4-linux-amd64.tar.gz
Verifying checksum... Done.
Preparing to install helm into /usr/local/bin
helm installed into /usr/local/bin/helm
```

## monitoring
### kubernetes-dashboard
```bash
# add kubernetes-dashboard repository
$ helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/

# deploy a Helm Release named "kubernetes-dashboard" using the kubernetes-dashboard chart
$ helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard --create-namespace --namespace kubernetes-dashboard
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

### metrics-server
```bash
$ helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
$ helm upgrade --install metrics-server metrics-server/metrics-server --namespace monitoring --create-namespace

# without tls: https://github.com/kubernetes-sigs/metrics-server/issues/1221
$ helm upgrade metrics-server metrics-server/metrics-server --set args="{--kubelet-insecure-tls}" --namespace monitoring
```

## CNI
### calico
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

### flannel

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

## ingress
### ingress-nginx
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

## tls
### import tls
```bash
$ sudo kubectl -n kube-system create secret tls sample-tls --cert star_sample_com.full.crt --key star_sample_com.key --dry-run=client -o yaml > kube-system.sample-tls.yaml
```

### copy tls
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

