<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

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
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
this for renew extend CA mode
<br>
stacked CA mode can found from [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
{% endhint %}

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
  {% tabs %}

  {% tab title="openssl" %}
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
         | egrep -v 'ca.crt$' \
         | xargs -L 1 -t -i bash -c 'openssl x509 -noout -text -in {} | grep After'
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver-kubelet-client.crt | grep After
              Not After : Sep 16 07:51:58 2020 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/apiserver.crt | grep After
              Not After : Sep 16 07:51:59 2020 GMT
  bash -c openssl x509 -noout -text -in /etc/kubernetes/pki/front-proxy-client.crt | grep After
              Not After : Sep 16 07:52:00 2020 GMT
  ```
  {% endtab %}

  {% tab title="or" %}
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
         | egrep -v 'ca.crt$' \
         | xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```
  {% endtab %}

  {% tab title="or" %}
  ```bash
  $ ls -1 /etc/kubernetes/pki/*.crt \
         | grep -Ev 'ca.crt$' \
         | xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```
  {% endtab %}
  {% endtabs %}

- [pem for extend etcd](https://stackoverflow.com/a/21297927/2940319)
  {% tabs %}

  {% tab title="openssl" %}
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
  {% endtab %}

  {% tab title="or" %}
  ```bash
  $ find /etc/etcd/ssl/ -type f -name '*.pem' \
         | egrep -v '*-key.pem$' \
         | xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/ca.pem
  notAfter=Sep  8 10:44:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/client.pem
  notAfter=Sep  8 10:49:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/server.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/peer.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  ```
  {% endtab %}

  {% tab title="or" %}
  ```bash
  $ ls -1 /etc/etcd/ssl/*.pem \
         | grep -Ev '\-key.pem$' \
         | xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```
  {% endtab %}
  {% endtabs %}

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
    -> sudo rm -rf /etc/kubernetes/pki/${i}.{key,crt};
    -> done
  ```

- kubeconfig
  ```bash
  $ for i in admin kubelet controller-manager scheduler; do
    sudo mv /etc/kubernetes/${i}.conf{,.orig};
    done
  ```

- restore
  {% tabs %}
  {% tab title="/etc/kubernetes/pki" %}
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
      for j in crt key; do
        sudo mv /etc/kubernetes/pki/${i}.${j}{.orig,}
      done
    done
  ```
  {% endtab %}

  {% tab title="/etc/kubrnetes/*.conf" %}
  ```bash
  $ for i in admin kubelet controller-manager scheduler; do
    sudo mv /etc/kubernetes/${i}.conf{.orig,}
  done
  ```
  {% endtab %}

  {% tab title="or" %}
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    -> sudo cp ~/k8s-cert-expired/${i}.{key,crt} /etc/kubernetes/pki/
    -> done
  ```
  {% endtab %}

  {% endtabs %}

### renew cert
- major master

> *major master* is the master node bind with load balance ip. the key master node picked by keepalived. check it by using:
> `ip a s "${interface}" | sed -rn 's|\W*inet[^6]\W*([0-9\.]{7,15}).*$|\1|p'`
>
> [kubeadm-conf.yaml](https://raw.githubusercontent.com/marslo/mytools/master/kubernetes/init/kubeadm-conf.yaml)

{% hint style="info" %}
renew cert in **major master**
{% endhint %}

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


{% tabs %}
{% tab title="renew in major master" %}
```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
   sudo kubeadm alpha certs renew ${i}
   done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```
{% endtab %}

{% tab title="renew with --config kubeadm-conf.yaml" %}
```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
   sudo kubeadm --config kubeadm-conf.yaml alpha certs renew ${i}
   done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```
{% endtab %}

{% tab title="or" %}
```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
   sudo kubeadm alpha certs renew ${i} --config=kubeadm-conf.yaml
   done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```
{% endtab %}

{% endtabs %}

- redundant masters

{% hint style="info" %}
sync renewed certificates to **another masters**
{% endhint %}

{% tabs %}
{% tab title="rsync *.key *.crt *.pub" %}
```bash
$ leadIP=<master-1>
$ for pkg in '*.key' '*.crt' '*.pub'; do
    sudo rsync -avzrlpgoDP \
               --rsync-path='sudo rsync' \
               root@${leadIP}:"/etc/kubernetes/pki/${pkg}" \
               /etc/kubernetes/pki/
    done
```
{% endtab %}
{% endtabs %}


- verify

{% tabs %}
{% tab title="openssl" %}
```bash
$ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
           | egrep -v 'ca.crt$' \
           | xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver.crt 
notAfter=Sep 18 12:10:31 2021 GMT
bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver-kubelet-client.crt 
notAfter=Sep 18 12:10:31 2021 GMT
bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/front-proxy-client.crt 
notAfter=Sep 18 12:10:31 2021 GMT
```
{% endtab %}

{% tab title="or" %}
```bash
$ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
       | xargs -L 1 -t -i bash -c 'openssl x509 -in {} -noout -text |grep "Not "'
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
{% endtab %}
{% endtabs %}


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
  | configuration file | path      |
  | :-          :      | : -     : |
  | `config`           | `~/.kube` |

  ```bash
  $ sudo cp /etc/kubernetes/admin.conf ~/.kube/config
  $ sudo chown $(id -u):$(id -g) $HOME/.kube/config
  $ sudo chmod 644 $HOME/.kube/config
  ```

### Restart the master components

{% tabs %}
{% tab title="kill one by one" %}
```bash
$ sudo kill -s SIGHUP $(pidof kube-apiserver)
$ sudo kill -s SIGHUP $(pidof kube-controller-manager)
$ sudo kill -s SIGHUP $(pidof kube-scheduler)
```
{% endtab %}

{% tab title="or" %}
```bash
$ for i in kube-apiserver kube-controller-manager kube-scheduler; do
    sudo kill -s SIGHUP $(pidof ${i})
    done
```
{% endtab %}
{% endtabs %}


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
  $ echo -n \
    | openssl s_client -connect x.x.x.x:6443 2>&1 \
    | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' \
    | openssl x509 -text -noout \
    | grep Not
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
sudo rm -rf /var/lib/kubelet/pki/*
sudo systemctl restart kubelet
sudo systemctl status kubelet.service
```

## certificates generation
### pfx
```bash
$ cat ~/.kube/config | grep certificate-authority-data | awk '{print $2}' | base64 -d > ca.crt
$ cat ~/.kube/config | grep client-certificate-data | awk '{print $2}' | base64 -d > client.crt
$ cat ~/.kube/config | grep client-key-data | awk '{print $2}' | base64 -d > client.key


$ openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
Enter Export Password: marslo
Verifying - Enter Export Password: marslo

$ ls
ca.crt  cert.pfx  client.crt  client.key
```

## reference
- [Access Kubernetes API with Client Certificates](https://codefarm.me/2019/02/01/access-kubernetes-api-with-client-certificates/)
- [Public-key cryptography and X.509](https://codefarm.me/2019/01/31/public-key-cryptography-and-x509/)
- [Bootstrapping Kubernetes Clusters with kubeadm](https://codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/)
- [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
