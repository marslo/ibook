<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [renew certs and kubeconfig](#renew-certs-and-kubeconfig)
  - [renew master](#renew-master)
    - [check info](#check-info)
    - [backup](#backup)
    - [renew cert](#renew-cert)
    - [renew kubeconfig](#renew-kubeconfig)
    - [Restart the master components](#restart-the-master-components)
    - [restart kubelet service](#restart-kubelet-service)
    - [verify](#verify)
  - [renew working node](#renew-working-node)
    - [backup](#backup-1)
    - [restart `kubelet`](#restart-kubelet)
  - [certificates generation](#certificates-generation)
    - [pfx](#pfx)
- [renew kubeconfig only](#renew-kubeconfig-only)
  - [environment check](#environment-check)
  - [renew data in kubeconfig](#renew-data-in-kubeconfig)
    - [generate the new cert](#generate-the-new-cert)
    - [signing the key](#signing-the-key)
    - [update kubeconfig](#update-kubeconfig)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> this for renew extend CA mode
>
> stacked CA mode can found from [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)

# renew certs and kubeconfig
## renew master
> reference:
> - [Renewing Kubernetes 1.14.x cluster certificates](https://www.ibm.com/support/knowledgecenter/SSCKRH_1.0.3/platform/t_certificate_renewal_k14.html)
> - [Renew cluster certificates](https://www.alibabacloud.com/help/doc-detail/122584.htm)
> - [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
> - [kubeadm alpha](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/)

### check info

- kubernetes version
  ```bash
  $ kubectl version --short
  Client Version: v1.15.3
  Server Version: v1.15.3
  ```

- crt for kubernetes
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
         egrep -v 'ca.crt$' |
         xargs -L 1 -t -i bash -c 'openssl x509 -noout -text -in {} | grep After'
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-kubelet-client.crt | grep After
              Not After : Sep 16 07:51:58 2020 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep After
              Not After : Sep 16 07:51:59 2020 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/front-proxy-client.crt | grep After
              Not After : Sep 16 07:52:00 2020 GMT
  ```

  or
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
         egrep -v 'ca.crt$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

  or
  ```bash
  $ ls -1 /etc/kubernetes/pki/*.crt |
         grep -Ev 'ca.crt$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

- [pem for extend etcd](https://stackoverflow.com/a/21297927/2940319)
  ```bash
  $ for i in ca client server peer; do
    echo /etc/etcd/ssl/$i.pem
    openssl x509 -enddate -noout -in /etc/etcd/ssl/$i.pem
  done
  /etc/etcd/ssl/ca.pem
  notAfter=Sep  8 10:44:00 2024 GMT
  /etc/etcd/ssl/client.pem
  notAfter=Sep  8 10:49:00 2024 GMT
  /etc/etcd/ssl/server.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  /etc/etcd/ssl/peer.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  ```

  or
  ```bash
  $ find /etc/etcd/ssl/ -type f -name '*.pem' |
         egrep -v '*-key.pem$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/ca.pem
  notAfter=Sep  8 10:44:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/client.pem
  notAfter=Sep  8 10:49:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/server.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/peer.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  ```

  or
  ```bash
  $ ls -1 /etc/etcd/ssl/*.pem |
          grep -Ev '\-key.pem$' |
          xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

### backup
```bash
$ mkdir ~/k8s-cert-expired
$ sudo cp -r /etc/kubernetes/pki ~/k8s-cert-expired/
$ sudo cp -r /etc/kubernetes/*.conf ~/k8s-cert-expired/
$ sudo cp -rp /var/lib/kubelet/pki /var/lib/kubelet/pki.orig
$ sudo cp -r /var/lib/kubelet/config.yaml{,.orig}
```

#### clean expired certificates
- `/etc/kubernetes/pki`
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    sudo mv /etc/kubernetes/pki/${i}.key{,.orig}
    sudo cp /etc/kubernetes/pki/${i}.crt{,.orig}
  done
  ```

  or
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
      sudo rm -rf /etc/kubernetes/pki/${i}.{key,crt};
    done
  ```

- kubeconfig
  ```bash
  $ for i in admin kubelet controller-manager scheduler; do
      sudo mv /etc/kubernetes/${i}.conf{,.orig};
    done
  ```

- restore
  - `/etc/kuberentes/pki/*.key`
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
      for j in crt key; do
        sudo mv /etc/kubernetes/pki/${i}.${j}{.orig,}
      done
    done
  ```

    or
    ```bash
    $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
        sudo cp ~/k8s-cert-expired/${i}.{key,crt} /etc/kubernetes/pki/
      done
    ```

  - `/etc/kubernetes/*.conf`
    ```bash
    $ for i in admin kubelet controller-manager scheduler; do
      sudo mv /etc/kubernetes/${i}.conf{.orig,}
    done
    ```

### renew cert
- major master

> *major master* is the master node bind with load balance ip. the key master node picked by keepalived. check it by using:
> `ip a s "${interface}" | sed -rn 's|\W*inet[^6]\W*([0-9\.]{7,15}).*$|\1|p'`
>
> [kubeadm-conf.yaml](https://raw.githubusercontent.com/marslo/mytools/master/kubernetes/init/kubeadm-conf.yaml)

> [!NOTE]
> renew cert in **major master**

  <table>
    <thead>
      <tr>
        <th style="text-align:center">certificate files</th>
        <th style="text-align:center">path</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <td style="text-align:left">
          <ul>
            <li><code>apiserver.crt</code></li>
            <li><code>apiserver.key</code></li>
            <li><code>apiserver-kubelet-client.crt</code></li>
            <li><code>apiserver-kubelet-client.key</code></li>
            <li><code>front-proxy-client.crt</code></li>
            <li><code>front-proxy-client.key</code></li>
          </ul>
        </td>
        <td style="text-align:center"><code>/etc/kubernetes/pki</code></td>
      </tr>
    </tbody>
  </table>

```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
   sudo kubeadm alpha certs renew ${i}
  done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```


or
```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    sudo kubeadm --config kubeadm-conf.yaml alpha certs renew ${i}
  done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```

or
```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    sudo kubeadm alpha certs renew ${i} --config=kubeadm-conf.yaml
  done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```

- redundant masters

> [!NOTE]
> sync renewed certificates to **another masters**

  ```bash
  $ leadIP=<master-1>
  $ for pkg in '*.key' '*.crt' '*.pub'; do
      sudo rsync -avzrlpgoDP \
                 --rsync-path='sudo rsync' \
                 root@${leadIP}:"/etc/kubernetes/pki/${pkg}" \
                 /etc/kubernetes/pki/
    done
  ```

- verify
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
             egrep -v 'ca.crt$' |
             xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver.crt
  notAfter=Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver-kubelet-client.crt
  notAfter=Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/front-proxy-client.crt
  notAfter=Sep 18 12:10:31 2021 GMT
  ```

  or
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
         xargs -L 1 -t -i bash -c 'openssl x509 -in {} -noout -text |grep "Not "'
  bash -c openssl x509 -in /etc/kubernetes/pki/ca.crt -noout -text |grep "Not "
              Not Before: Sep 17 07:51:58 2019 GMT
              Not After : Sep 14 07:51:58 2029 GMT
  bash -c openssl x509 -in /etc/kubernetes/pki/front-proxy-ca.crt -noout -text |grep "Not "
              Not Before: Sep 17 07:52:00 2019 GMT
              Not After : Sep 14 07:52:00 2029 GMT
  bash -c openssl x509 -in /etc/kubernetes/pki/apiserver.crt -noout -text |grep "Not "
              Not Before: Sep 17 07:51:58 2019 GMT
              Not After : Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -in /etc/kubernetes/pki/apiserver-kubelet-client.crt -noout -text |grep "Not "
              Not Before: Sep 17 07:51:58 2019 GMT
              Not After : Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -in /etc/kubernetes/pki/front-proxy-client.crt -noout -text |grep "Not "
              Not Before: Sep 17 07:52:00 2019 GMT
              Not After : Sep 18 12:10:31 2021 GMT
  ```

### renew kubeconfig

<table>
  <thead>
    <tr style="text-align:center">
      <th style="text-align:center">config files</th>
      <th style="text-align:center">path</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td style="text-align:left">
        <ul>
          <li><code>admin.conf</code></li>
          <li><code>kubelet.conf</code></li>
          <li><code>controller-manager.conf</code></li>
          <li><code>scheduler.conf</code></li>
        </ul>
      </td>
      <td style="text-align:center"><code>/etc/kubernetes/</code></td>
    </tr>
  </tbody>
</table>

```bash
$ sudo kubeadm --config kubeadm-conf.yaml init phase kubeconfig all
[kubeconfig] Using kubeconfig folder "/etc/kubernetes"
[kubeconfig] Writing "admin.conf" kubeconfig file
[kubeconfig] Writing "kubelet.conf" kubeconfig file
[kubeconfig] Writing "controller-manager.conf" kubeconfig file
[kubeconfig] Writing "scheduler.conf" kubeconfig file
```

- setup `~/.kube/config`
  ```bash
  $ sudo cp /etc/kubernetes/admin.conf ~/.kube/config
  $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
  $ sudo chmod 644 $HOME/.kube/config
  ```

| configuration file | path      |
|:------------------:|:---------:|
| `config`           | `~/.kube` |


### [Restart the master components](https://stackoverflow.com/a/62911194)
```bash
$ sudo kill -s SIGHUP $(pidof kube-apiserver)
$ sudo kill -s SIGHUP $(pidof kube-controller-manager)
$ sudo kill -s SIGHUP $(pidof kube-scheduler)
```

  or
  ```bash
  $ for i in kube-apiserver kube-controller-manager kube-scheduler; do
      sudo kill -s SIGHUP $(pidof ${i})
    done
  ```

### restart kubelet service
```bash
$ sudo rm -rf /var/lib/kubelet/pki/*
$ sudo systemctl restart kubelet
```
- verify
  ```bash
  $ sudo systemctl status kubelet
  ● kubelet.service - kubelet: The Kubernetes Node Agent
     Loaded: loaded (/usr/lib/systemd/system/kubelet.service; enabled; vendor preset: disabled)
    Drop-In: /usr/lib/systemd/system/kubelet.service.d
             └─10-kubeadm.conf
     Active: active (running) since Mon 2020-09-21 04:25:33 PDT; 55s ago
       Docs: https://kubernetes.io/docs/
   Main PID: 11891 (kubelet)
      Tasks: 19
     Memory: 126.5M
     CGroup: /system.slice/kubelet.service
             └─11891 /usr/bin/kubelet --bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/...
  ...
  ```

### verify
  - kubernetes api (`load.balance.ip.address:6443`)
  ```bash
  $ echo -n |
         openssl s_client -connect x.x.x.:6443 2>&1 |
         sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' |
         openssl x509 -text -noout |
         grep Not
              Not Before: Sep 17 07:51:58 2019 GMT
              Not After : Sep 21 09:09:00 2021 GMT
  ```

## renew working node
### backup
```bash
$ mkdir k8s-cert-expired
$ sudo cp -rp /var/lib/kubelet/pki k8s-cert-expired/
$ sudo cp -r /var/lib/kubelet/pki{,.orig}
```

### restart `kubelet`
```bash
$ sudo rm -rf /var/lib/kubelet/pki/*
$ sudo systemctl restart kubelet
$ sudo systemctl status kubelet.service
```

## certificates generation
### pfx
```bash
$ grep certificate-authority-data ~/.kube/config |
       awk '{print $2}' |
       base64 -d > ca.crt
$ grep client-certificate-data ~/.kube/config |
       awk '{print $2}' |
       base64 -d > client.crt
$ grep client-key-data ~/.kube/config |
       awk '{print $2}' |
       base64 -d > client.key

$ openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
Enter Export Password: marslo
Verifying - Enter Export Password: marslo

$ ls
ca.crt  cert.pfx  client.crt  client.key
```

# renew kubeconfig only
## environment check
- kubectl version
  ```bash
  $ kubectl version --short
  Client Version: v1.12.3
  Server Version: v1.12.3
  ```

- certs
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
         egrep -v 'ca.crt$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -noout -text -in {} | grep After'
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/front-proxy-client.crt | grep Not
              Not After : May 28 11:48:39 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/server.crt | grep Not
              Not After : May 28 11:48:40 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/peer.crt | grep Not
              Not After : May 28 11:48:41 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/healthcheck-client.crt | grep Not
              Not After : May 28 11:48:40 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep Not
              Not After : May 28 11:48:37 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-kubelet-client.crt | grep Not
              Not After : May 28 11:48:38 2022 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-etcd-client.crt | grep Not
              Not After : May 28 11:48:42 2022 GMT
  ```

- [`kubectl config view`](https://networkandcode.github.io/kubernetes/2020/03/16/cluster-admin.html)
  ```bash
  $ kubectl config get-contexts
  CURRENT   NAME                          CLUSTER      AUTHINFO           NAMESPACE
  *         kubernetes-admin@kubernetes   kubernetes   kubernetes-admin

  $ kubectl config current-context
  kubernetes-admin@kubernetes

  $ kubectl config view -o jsonpath={.contexts}; echo
  [map[name:kubernetes-admin@kubernetes context:map[user:kubernetes-admin cluster:kubernetes]]]

  $ kubectl config view -o jsonpath={.users}; echo
  [map[name:kubernetes-admin user:map[client-certificate-data:REDACTED client-key-data:REDACTED]]]

  $ kubectl config view
  apiVersion: v1
  clusters:
  - cluster:
      certificate-authority-data: DATA+OMITTED
      server: https://1.2.3.4:1234
    name: kubernetes
  contexts:
  - context:
      cluster: kubernetes
      user: kubernetes-admin
    name: kubernetes-admin@kubernetes
  current-context: kubernetes-admin@kubernetes
  kind: Config
  preferences: {}
  users:
  - name: kubernetes-admin
    user:
      client-certificate-data: REDACTED
      client-key-data: REDACTED
  ```

- kubeconfig
  ```bash
  $ kubectl --kubeconfig=config get namespace
  error: the server doesn't have a resource type "namespace"

  $ sudo grep 'client-certificate-data' $HOME/.kube/config |
         awk '{print $2}' |
         base64 -d |
         openssl x509 -text -noout |
         grep -E 'Not|Subject:'

              Not Before: Dec  8 05:43:01 2020 GMT
              Not After : Dec  8 05:43:01 2021 GMT
          Subject: O=system:masters, CN=kubernetes-admin
  ```

## renew data in kubeconfig
> references:
> - [Configure certificates for user accounts](https://kubernetes.io/docs/setup/best-practices/certificates/#configure-certificates-for-user-accounts)
> - [kubernetes > about the cluster-admin cluster role binding](https://networkandcode.github.io/kubernetes/2020/03/16/cluster-admin.html)

{% hint style='tip' %}
> subjects:
> - config:
>   - `controller-manager.conf` : `Subject: CN=system:kube-controller-manager`
>   - `admin.conf` : `Subject: O=system:masters, CN=kubernetes-admin`
>   - `scheduler.conf` : `Subject: O=system:masters, CN=system:kube-scheduler`
>   - `kubelet.conf` : `Subject: O=system:nodes, CN=system:node:kubernetes-master01` ( `CN=system:node:<HOSTNAME>` )
> - certs:
>   - `front-proxy-client.crt` : `Subject: CN=front-proxy-client`
>   - `server.crt` : `Subject: CN=kubernetes-master01` ( `CN=<HOSTNAME>` )
>   - `peer.crt` : `Subject: CN=kubernetes-master01` ( `CN=<HOSTNAME>` )
>   - `healthcheck-client.crt` : `Subject: O=system:masters, CN=kube-etcd-healthcheck-client`
>   - `apiserver.crt` : `Subject: CN=kube-apiserver`
>   - `apiserver-kubelet-client.crt` : `Subject: O=system:masters, CN=kube-apiserver-kubelet-client`
>   - `apiserver-etcd-client.crt` : `Subject: O=system:masters, CN=kube-apiserver-etcd-client`
{% endhint %}

- details:

  > reference:
  > - [Get user and group from current-context](https://stackoverflow.com/questions/61157272/what-role-and-rolebinding-is-kubectl-associated-to)

  - conf:
    ```bash
    # current kubeconfig context
    $ kubectl config view --raw -o json |
              jq ".users[] | select(.name==\"$(kubectl config view -o jsonpath='{.users[].name}')\")" |
              jq -r '.user["client-certificate-data"]' |
              base64 -d |
              openssl x509 -text |
              grep "Subject:"
            Subject: O=system:masters, CN=kubernetes-admin

    # for all confs
    $ find /etc/kubernetes/ -type f -name "*.conf" -print |
           grep -Ev 'kubelet.conf$' |
           xargs -L1 -t -i bash -c "sudo grep 'client-certificate-data' {} \
                                         | awk '{print \$2}' \
                                         | base64 -d \
                                         | openssl x509 -noout -text \
                                         | grep --color=always Subject\: \
                                   "
    bash -c sudo grep 'client-certificate-data' /etc/kubernetes/controller-manager.conf | awk '{print $2}' | base64 -d | openssl x509 -noout -text | grep --color=always Subject\:
            Subject: CN=system:kube-controller-manager
    bash -c sudo grep 'client-certificate-data' /etc/kubernetes/admin.conf | awk '{print $2}' | base64 -d | openssl x509 -noout -text | grep --color=always Subject\:
            Subject: O=system:masters, CN=kubernetes-admin
    bash -c sudo grep 'client-certificate-data' /etc/kubernetes/scheduler.conf | awk '{print $2}' | base64 -d | openssl x509 -noout -text | grep --color=always Subject\:
            Subject: O=system:masters, CN=system:kube-scheduler

    $ sudo openssl x509 -in $(sudo grep 'client-certificate' /etc/kubernetes/kubelet.conf |
           awk '{print $2}') -text -noout | grep --color=always Subject\:
            Subject: O=system:nodes, CN=system:node:kubernetes-master01
    ```

  - certs
    ```bash
    $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
          grep -Ev 'ca.crt$' |
          xargs -L1 -t -i bash -c 'openssl x509 -noout -text -in {} | grep --color=always Subject\:'
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/front-proxy-client.crt | grep --color=always Subject\:
            Subject: CN=front-proxy-client
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/server.crt | grep --color=always Subject\:
            Subject: CN=kubernetes-master01
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/peer.crt | grep --color=always Subject\:
            Subject: CN=kubernetes-master01
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/etcd/healthcheck-client.crt | grep --color=always Subject\:
    ubject: O=system:masters, CN=kube-apiserver-etcd-client
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep --color=always Subject\:
            Subject: CN=kube-apiserver
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-kubelet-client.crt | grep --color=always Subject\:
            Subject: O=system:masters, CN=kube-apiserver-kubelet-client
    bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-etcd-client.crt | grep --color=always Subject\:
            Subject: O=system:masters, CN=kube-apiserver-etcd-client
    ```

  - about `system:masters`
    ```bash
    $ kubectl get clusterrolebinding cluster-admin -o yaml
    $ kubectl get clusterrolebinding cluster-admin -o json | jq -r .subjects[0].name
    system:masters

    $ kubectl get clusterrolebindings -o json |
              jq -r '.items[] | select(.subjects[0].kind=="Group") | select(.subjects[0].name=="system:masters") | .metadata.name'
    cluster-admin
    ```

### generate the new cert
```bash
$ openssl req -subj "/O=system:masters/CN=kubernetes-admin" \
              -new \
              -newkey rsa:2048 \
              -nodes \
              -out marslo.csr \
              -keyout marslo.key  \
              -out marslo.csr
```

- or
  ```bash
  $ openssl genrsa -out marslo.key 2048
  $ openssl req -new -key marslo.key -out marslo.csr -subj "/O=system:masters/CN=kubernetes-admin"
  ```

### signing the key
```bash
$ sudo openssl x509 -req \
                    -in marslo.csr \
                    -CA /etc/kubernetes/pki/ca.crt \
                    -CAkey /etc/kubernetes/pki/ca.key \
                    -CAcreateserial \
                    -out marslo.crt \
                    -days 365 \
                    -sha256
```
- result
  ```bash
  $ ls -Altrh . /etc/kubernetes/pki/ca*
  -rw------- 1 root root 1.7K Dec  6  2018 ca.key
  -rw-r--r-- 1 root root 1.1K Dec  6  2018 ca.crt
  -rw-r--r-- 1 root root   17 Dec 15 01:31 ca.srl

  $ ls -Altrh ./
  -rw-rw-r-- 1 devops devops 1.7K Dec 15 01:31 marslo.key
  -rw-rw-r-- 1 devops devops  936 Dec 15 01:31 marslo.csr
  -rw-r--r-- 1 root   root   1021 Dec 15 01:31 marslo.crt

  $ sudo openssl x509 -in marslo.crt -text -noout | grep -E 'Subject:|Not'
              Not Before: Dec 15 09:31:55 2021 GMT
              Not After : Dec 15 09:31:55 2022 GMT
          Subject: O=system:masters, CN=kubernetes-admin
  ```

### update kubeconfig
#### copy config
```bash
$ cp ~/.kube/config config

$ kubectl --kubeconfig=config get ns
error: You must be logged in to the server (Unauthorized)
```

#### [via `kubeadm alpha` to renew all config](https://www.cnblogs.com/justmine/p/11314843.html)

- kubernetes older version ( 1.15- )
  ```bash
  $ sudo mkdir -p /etc/kubernetes/config.backup
  $ sudo mv /etc/kuberetens/*.conf /etc/kubernetes/config.backup
  $ sudo kubeadm alpha phase kubeconfig all
  ```

  - renew all certs
    ```bash
    $ sudo mkdir -p /etc/kubernetes/pki/backups
    $ for _i in apiserver front-proxy-client healthcheck-client server peer; do
        sudo mv /etc/kubernetes/pki/${_i}.* /etc/kubernetes/pki/backups
      done
    $ sudo kubeadm alpha phase certs all
    ```

- v1.15+
  ```bash
  $ sudo kubeadm alpha certs renew all
  ```

  - renew all certs
    ```bash
    $ sudo kubeadm alpha certs renew all
    ```

#### via `kubectl config`
> reference:
> - [kubectlp-command#config](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#config)

```bash
$ kubectl config set-credentials kubernetes-admin \
                 --embed-certs=true \
                 --certificate-authority=/etc/kubernetes/pki/ca.crt \
                 --client-certificate=./marslo.crt \
                 --client-key=./marslo.key \
                 --kubeconfig=config

$ kubectl config set-context kubernetes-admin@kubernetes \
                 --cluster=kubernetes \
                 --user=kubernetes-admin
```

#### manual update via `base64`
```bash
$ sed -re "s/(.*client-certificate-data:)(.*)$/\1 $(cat marslo.crt | base64 -w0)/g" -i config
$ sed -re "s/(.*client-key-data:)(.*)$/\1 $(cat marslo.key| base64 -w0)/g" -i config
```

#### vaildate
```bash
$ kubectl --kubeconfig=config get ns | grep kube
kube-public            Active   3y10d
kube-system            Active   3y10d
```

# reference
- [Access Kubernetes API with Client Certificates](https://codefarm.me/2019/02/01/access-kubernetes-api-with-client-certificates/)
- [Public-key cryptography and X.509](https://codefarm.me/2019/01/31/public-key-cryptography-and-x509/)
- [Bootstrapping Kubernetes Clusters with kubeadm](https://codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/)
- [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
- [Renewing Kubernetes cluster certificates 1.0.2](https://www.ibm.com/docs/en/fci/1.0.2?topic=kubernetes-renewing-cluster-certificates)
- [Renewing Kubernetes cluster certificates 1.1.0](https://www.ibm.com/docs/en/fci/1.1.0?topic=kubernetes-renewing-cluster-certificates)
- [Renewing Kubernetes 1.10.x cluster certificates](https://www.ibm.com/docs/en/fci/1.0.3?topic=kubernetes-renewing-110x-cluster-certificates)
- [how to renew the certificate when apiserver cert expired?](https://github.com/kubernetes/kubeadm/issues/581#issuecomment-421477139)
- [Can not access my kubernetes cluster even if all my server certificates are valid](https://stackoverflow.com/a/52964957)
- [The Cluster API Book](https://cluster-api.sigs.k8s.io/tasks/certs/generate-kubeconfig.html)
- [K8S 集群中的认证、授权与 kubeconfig](http://www.xuyasong.com/?p=2054)
- [Certificate Signing Requests](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/)
- [Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
- [Kubernetes – KUBECONFIG and Context](https://theithollow.com/2019/02/11/kubernetes-kubeconfig-and-context/)
