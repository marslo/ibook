<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [renew](#renew)
  - [check expired cert](#check-expired-cert)
  - [backup](#backup)
  - [clean expired certificates](#clean-expired-certificates)
  - [renew cert](#renew-cert)
  - [renew kubeconfig](#renew-kubeconfig)
  - [restart kubelet service](#restart-kubelet-service)
  - [sync to another kubernetes masters](#sync-to-another-kubernetes-masters)
  - [verify](#verify)
- [certificates generation](#certificates-generation)
  - [pfx](#pfx)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## renew
> reference:
> - [Renewing Kubernetes 1.10.x cluster certificates](https://www.ibm.com/support/knowledgecenter/SSCKRH_1.0.3/platform/t_certificate_renewal.html)
> - [Renew cluster certificates](https://www.alibabacloud.com/help/doc-detail/122584.htm)
> - [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)

### check expired cert
- crt for kubernetes
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
         | egrep -v 'ca.crt$' \
         | xargs -L 1 -t  -i bash -c 'openssl x509 -noout -text -in {} | grep After'
  bash -c openssl x509  -noout -text -in /etc/kubernetes/pki/apiserver-kubelet-client.crt|grep After
              Not After : Sep 16 07:51:58 2020 GMT
  bash -c openssl x509  -noout -text -in /etc/kubernetes/pki/apiserver.crt|grep After
              Not After : Sep 16 07:51:59 2020 GMT
  bash -c openssl x509  -noout -text -in /etc/kubernetes/pki/front-proxy-client.crt|grep After
              Not After : Sep 16 07:52:00 2020 GMT
  ```

  or
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
         | egrep -v 'ca.crt$' \
         | xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver.crt
  notAfter=Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver-kubelet-client.crt
  notAfter=Sep 18 12:10:31 2021 GMT
  bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/front-proxy-client.crt
  notAfter=Sep 18 12:10:31 2021 GMT
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
  $ find /etc/etcd/ssl/ -type f -name '*.pem' \
         | egrep -v '*-key.pem$' \
         | xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/ca.pem
  notAfter=Sep  8 10:44:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/client.pem
  notAfter=Sep  8 10:49:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/server.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/peer.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  ```


### backup
```bash
$ mkdir ~/k8s-cert-expired
$ sudo cp -r /etc/kubernetes/pki ~/k8s-cert-expired/
$ sudo cp -r /etc/kubernetes/*.conf ~/k8s-cert-expired/
$ sudo cp -rp /var/lib/kubelet/pki /var/lib/kubelet/pki.orig
$ sudo cp -r /var/lib/kubelet/config.yaml{,.orig}
```

### clean expired certificates
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
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
      for j in crt key; do
        sudo mv /etc/kubernetes/pki/${i}.${j}{.orig,}
      done
    done
  ```
  ```bash
  $ for i in admin kubelet controller-manager scheduler; do
    sudo mv /etc/kubernetes/${i}.conf{.orig,}
    done
  ```

  or
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    -> sudo cp ~/k8s-cert-expired/${i}.{key,crt} /etc/kubernetes/pki/
    -> done
  ```

### renew cert
{% hint style="info" %}
renew cert in one of kubernetes master
{% endhint %}

> [kubeadm-conf.yaml](https://raw.githubusercontent.com/marslo/mytools/master/kubernetes/init/kubeadm-conf.yaml)

```bash
$ for i in apiserver apiserver-kubelet-client front-proxy-client; do
  sudo kubeadm alpha certs renew ${i}
  done
certificate for serving the Kubernetes API renewed
certificate for the API server to connect to kubelet renewed
certificate for the front proxy client renewed
```

  - or
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
    sudo kubeadm --config kubeadm-conf.yaml alpha certs renew ${i}
    done
  certificate for serving the Kubernetes API renewed
  certificate for the API server to connect to kubelet renewed
  certificate for the front proxy client renewed
  ```

  - or
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
     sudo kubeadm alpha certs renew ${i} --config=kubeadm-conf.yaml
     done
  certificate for serving the Kubernetes API renewed
  certificate for the API server to connect to kubelet renewed
  certificate for the front proxy client renewed
  ```

- verify
  - cert
    ```bash
    $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print \
               | egrep -v 'ca.crt$' \
               | xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
    bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver.crt 
    notAfter=Sep 18 12:10:31 2021 GMT
    bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/apiserver-kubelet-client.crt 
    notAfter=Sep 18 12:10:31 2021 GMT
    bash -c openssl x509 -enddate -noout -in /etc/kubernetes/pki/front-proxy-client.crt 
    notAfter=Sep 18 12:10:31 2021 GMT
    ```

    or
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

### renew kubeconfig
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

#### Restart the master components
```bash
$ sudo kill -s SIGHUP $(pidof kube-apiserver)
$ sudo kill -s SIGHUP $(pidof kube-controller-manager)
$ sudo kill -s SIGHUP $(pidof kube-scheduler)
```

  - or
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

### sync to another kubernetes masters
```bash
$
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
