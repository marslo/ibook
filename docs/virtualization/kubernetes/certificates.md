<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [renew both certificates and kubeconfig](#renew-both-certificates-and-kubeconfig)
  - [check info](#check-info)
    - [crt](#crt)
    - [pem for external etcd](#pem-for-external-etcd)
    - [backup](#backup)
    - [clean environment](#clean-environment)
    - [restore backup](#restore-backup)
  - [v1.12.3](#v1123)
    - [renew certificates](#renew-certificates)
    - [renew kubeconfig](#renew-kubeconfig)
    - [sync to redundant masters](#sync-to-redundant-masters)
    - [restart kubelet](#restart-kubelet)
  - [v1.15.3](#v1153)
    - [renew certificates](#renew-certificates-1)
    - [sync to redundant masters](#sync-to-redundant-masters-1)
    - [renew kubeconfig](#renew-kubeconfig-1)
    - [restart the master components](#restart-the-master-components)
    - [restart kubelet service](#restart-kubelet-service)
    - [verify](#verify)
  - [renew work node](#renew-work-node)
    - [backup](#backup-1)
    - [restart `kubelet`](#restart-kubelet)
  - [certificates generation](#certificates-generation)
    - [pfx](#pfx)
- [renew kubeconfig only](#renew-kubeconfig-only)
  - [basic environment](#basic-environment)
  - [renew kubeconfig](#renew-kubeconfig-2)
    - [generate new certificate (csr)](#generate-new-certificate-csr)
    - [signing the certificate via `ca.crt`](#signing-the-certificate-via-cacrt)
    - [renew via `kubeadm alpha`](#renew-via-kubeadm-alpha)
    - [renew via `kubectl config`](#renew-via-kubectl-config)
    - [renew via `base64` manually](#renew-via-base64-manually)
    - [vaildate](#vaildate)
    - [more details](#more-details)
- [reference](#reference)
  - [Required certificates:](#required-certificates)
  - [Certificate paths](#certificate-paths)
  - [Configure certificates for user accounts](#configure-certificates-for-user-accounts)
  - [files are used as follows](#files-are-used-as-follows)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [extenal etcd topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#external-etcd-topology) certificates located in : `/etc/etcd/ssl`
> - [stacked etcd topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#stacked-etcd-topology) certificates located in : `/etc/kubernetes/pki/etcd`
> <br>
> references:
> - [Renew a Kubernetes certificate with a 10-year expiration date](https://www.sobyte.net/post/2021-10/update-k8s-10y-expire-certs/)
> - stacked CA mode can found from [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
> - [Configure Access to Multiple Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/)
> <br>
> regenerate the kubeadm.yaml
> ```bash
> $ sudo kubeadm config view
> ```

# renew both certificates and kubeconfig
## check info
### crt
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

- or
  ```bash
  $ find /etc/kubernetes/pki/ -type f -name "*.crt" -print |
         egrep -v 'ca.crt$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

- or
  ```bash
  $ ls -1 /etc/kubernetes/pki/*.crt |
         grep -Ev 'ca.crt$' |
         xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

### [pem for external etcd](https://stackoverflow.com/a/21297927/2940319)
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

- or
  ```bash
  $ find /etc/etcd/ssl/ -type f -name '*.pem' |
         egrep -v '*-key.pem$' |
         xargs -L 1 -t -i bash -c 'openssl x509 -enddate -noout -in {}'
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/ca.pem
  notAfter=Sep  8 10:44:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/client.pem
  notAfter=Sep  8 10:49:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/server.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  bash -c openssl x509 -enddate -noout -in /etc/etcd/ssl/peer.pem
  notAfter=Sep  8 11:03:00 2024 GMT
  ```

- or
  ```bash
  $ ls -1 /etc/etcd/ssl/*.pem |
          grep -Ev '\-key.pem$' |
          xargs -L 1 -t  -i bash -c 'openssl x509 -enddate -noout -in {}'
  ```

### backup
```bash
# timestampe=$(date +"%Y%m%d%H%M%S")
$ timestampe=$(date +"%Y%m%d")
$ backupFolder="$HOME/k8s-cert-expired-${timestampe}"

$ mkdir "${backupFolder}"
$ sudo cp -rp --parents /etc/kubernetes/pki "${backupFolder}"

# for external etcd
# sudo cp -rp --parents /etc/etcd/ssl "${backupFolder}"

# for kubelet
$ sudo cp -rp /var/lib/kubelet/config.yaml{,.backup.${timestampe}}
$ sudo cp -rp --parents /var/lib/kubelet/pki "${backupFolder}"
$ sudo cp -rp --parents /var/lib/kubelet/pki{,.backup.${timestampe}}
$ sudo cp -rp --parents /var/lib/kubelet/config.yaml "${backupFolder}"

# for kubeconfig
$ sudo cp -rp --parents /etc/kubernetes/*.conf "${backupFolder}"
$ sudo cp -rp ~/.kube/config{,.backup.${timestampe}}
```

### clean environment
```bash
# for `/etc/kubernetes/pki`
$ echo {apiserver,apiserver-kubelet-client,apiserver-etcd-client,front-proxy-client} |
       fmt -1 |
       xargs -I{} bash -c "sudo cp -rp /etc/kubernetes/pki/{}.crt{,.backup.${timestampe}};
                           sudo mv /etc/kubernetes/pki/{}.key{,.backup.${timestampe}}"

# for kubeconfig
$ echo {admin,kubelet,controller-manager,scheduler} |
       fmt -1 |
       xargs -I{} bash -c "sudo mv /etc/kubernetes/{}.conf{,.backup.${timestampe}}"

$ echo {peer,healthcheck-client,server}.{crt,key} |
       fmt -1 |
       xargs -I{} bash -c "sudo mv /etc/kubernets/pki/etcd/${}{,.backup.${timestampe}}"
```

### restore backup
TBD


## v1.12.3

> [!TIP]
> for [stacked etcd topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#stacked-etcd-topology) <br>
>
> ```bash
> $ kubectl version --short
> Client Version: v1.12.3
> Server Version: v1.12.3
> ```

> references:
> - [Renewing Kubernetes cluster certificates 1.0.2](https://www.ibm.com/docs/en/fci/1.0.2?topic=kubernetes-renewing-cluster-certificates)
> - [Renewing Kubernetes cluster certificates 1.1.0](https://www.ibm.com/docs/en/fci/1.1.0?topic=kubernetes-renewing-cluster-certificates)
> - [Renewing Kubernetes 1.10.x cluster certificates](https://www.ibm.com/docs/en/fci/1.0.3?topic=kubernetes-renewing-110x-cluster-certificates)

### renew certificates
```bash
$ sudo kubeadm [--config kubeadm.yaml] alpha phase certs renew [commands]
```

<div class="alert alert-success hints-alert">
  <div class="hints-icon">
  <i class="fa fa-mortar-board"></i>
  </div>
  <div class="hints-container">
  <blockquote>
    <h4>Available Commands:</h4>
    <table>
      <thead>
        <tr>
          <th>commands</th>
          <th>comments</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>all</code></td>
          <td>renew all available certificates</td>
        </tr>
        <tr>
          <td><code>apiserver</code></td>
          <td>Generates the certificate for serving the kubernetes API</td>
        </tr>
        <tr>
          <td><code>apiserver-etcd-client</code></td>
          <td>Generates the client apiserver uses to access etcd</td>
        </tr>
        <tr>
          <td><code>apiserver-kubelet-client</code></td>
          <td>Generates the Client certificate for the API server to connect to kubelet</td>
        </tr>
        <tr>
          <td><code>front-proxy-client</code></td>
          <td>Generates the client for the front proxy</td>
        </tr>
        <tr>
          <td><code>etcd-healthcheck-client</code></td>
          <td>Generates the client certificate for liveness probes to healtcheck etcd</td>
        </tr>
        <tr>
          <td><code>etcd-peer</code></td>
          <td>Generates the credentials for etcd nodes to communicate with each other</td>
        </tr>
        <tr>
          <td><code>etcd-server</code></td>
          <td>Generates the certificate for serving etcd</td>
        </tr>
      </tbody>
    </table>
  </blockquote>
  </div>
</div>

- i.e.
  ```bash
  $ sudo kubeadm --config ~/kubeadm.yaml alpha phase certs renew all

  # or

  # for /etc/kubernetes/pki/*.crt
  $ echo {apiserver,apiserver-kubelet-client,front-proxy-client} |
         fmt -1 |
         xargs -I{} bash -c "sudo kuabeadm --config ~/kubeadm.yaml alpha phase certs renew {}"

  # for /etc/kubernetes/pki/etcd/*.crt
  $ echo {etcd-server,etcd-peer,etcd-healthcheck-client} |
         fmt -1 |
         xargs -I{} bash -c "sudo kuabeadm --config ~/kubeadm.yaml alpha phase certs renew {}"
  ```

#### generate new certificates
```bash
$ sudo kubeadm [--config kubeadm.yaml] alpha phase certs [commands]
```

<div class="alert alert-success hints-alert">
  <div class="hints-icon">
  <i class="fa fa-mortar-board"></i>
  </div>
  <div class="hints-container">
  <blockquote>
    <table>
      <thead>
        <tr>
        <th>commands</th>
        <th>comments</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>all</code></td>
          <td>Generates all PKI assets necessary to establish the control plane</td>
        </tr>
        <tr>
          <td><code>apiserver</code></td>
          <td>Generates the certificate for serving the kubernetes API</td>
        </tr>
        <tr>
          <td><code>apiserver-etcd-client</code></td>
          <td>Generates the client apiserver uses to access etcd</td>
        </tr>
        <tr>
          <td><code>apiserver-kubelet-client</code></td>
          <td>Generates the Client certificate for the API server to connect to kubelet</td>
        </tr>
        <tr>
          <td><code>ca</code></td>
          <td>Generates the self-signed kubernetes CA to provision identities for other kuberenets components</td>
        </tr>
        <tr>
          <td><code>etcd-ca</code></td>
          <td>Generates the self-signed CA to provision identities for etcd</td>
        </tr>
        <tr>
          <td><code>etcd-healthcheck-client</code></td>
          <td>Generates the client certificate for liveness probes to healtcheck etcd</td>
        </tr>
        <tr>
          <td><code>etcd-peer</code></td>
          <td>Generates the credentials for etcd nodes to communicate with each other</td>
        </tr>
        <tr>
          <td><code>etcd-server</code></td>
          <td>Generates the certificate for serving etcd</td>
        </tr>
        <tr>
          <td><code>front-proxy-ca</code></td>
          <td>Generates the self-signed CA to provision identities for front proxy</td>
        </tr>
        <tr>
          <td><code>front-proxy-client</code></td>
          <td>Generates the client for the front proxy</td>
        </tr>
        <tr>
          <td><code>sa</code></td>
          <td>Generates a private key for signing service account tokens along with its public key</td>
        </tr>
        <tr>
          <td><code>renew</code></td>
          <td>Renews certificates for a Kubernetes cluster</td>
        </tr>
      </tbody>
    </table>
  </blockquote>
  </div>
</div>


- re-generate `/etc/kubernetes/pki/etcd/*.crt` for modify `X509 Subject Alternative Name`:
  ```bash
  $ sudo kubeadm --config ~/kubeadm.yaml alpha phase certs etcd-server
  $ sudo kubeadm --config ~/kubeadm.yaml alpha phase certs etcd-peer
  $ sudo kubeadm --config ~/kubeadm.yaml alpha phase certs etcd-healthcheck-client

  # or
  $ echo {etcd-server,etcd-peer,etcd-healthcheck-client} |
         fmt -1 |
         xargs -I{} bash -c "sudo kubeadm --config ~/kubeadm.yaml alpha phase certs {}"
  ```

  - check `X509 Subject Alternative Name`
    ```bash
    $ openssl x509 -noout -text -in /path/to/NAME.crt
    ```

### renew kubeconfig
```bash
# clean all config in /etc/kubenernets/*.conf, i.e.:
# echo {admin,controller-manager,kubelet,scheduler} | fmt -1 | xargs -I{} bash -c "sudo rm -rf {}.conf"
$ sudo kubeadm [--config ~/kubeadm.yaml] alpha phase kubeconfig [commands]
```

#### renew all kubeconfig
```bash
$ sudo kubeadm --config ~/kubeadm.yaml alpha phase kubeconfig all
[endpoint] WARNING: port specified in controlPlaneEndpoint overrides bindPort in the controlplane address
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/etc/kubernetes/scheduler.conf"

# or
$ echo {admin,controller-manager,kubelet,scheduler} |
       fmt -1 |
       xargs -I{} bash -c "sudo kubeadm --config ~/kubeadm.yaml alpha phase kubeconfig {}"
```

<div class="alert alert-success hints-alert">
  <div class="hints-icon">
  <i class="fa fa-mortar-board"></i>
  </div>
  <div class="hints-container">
  <blockquote>
    <h4>Available Commands:</h4>
    <table>
      <thead>
        <tr>
        <th>commands</th>
        <th>comments</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>all</code></td>
          <td>Generates all kubeconfig files necessary to establish the control plane and the admin kubeconfig file</td>
        </tr>
        <tr>
          <td><code>admin</code></td>
          <td>Generates a kubeconfig file for the admin to use and for kubeadm itself</td>
        </tr>
        <tr>
          <td><code>controller_manager</code></td>
          <td>Generates a kubeconfig file for the controller manager to use</td>
        </tr>
        <tr>
          <td><code>kubelet</code></td>
          <td>Generates a kubeconfig file for the kubelet to use. Please note that this should be used *only* for bootstrapping purposes</td>
        </tr>
        <tr>
          <td><code>scheduler</code></td>
          <td>Generates a kubeconfig file for the scheduler to use</td>
        </tr>
        <tr>
          <td><code>user</code></td>
          <td>Outputs a kubeconfig file for an additional user</td>
        </tr>
      </tbody>
    </table>
  </blockquote>
  </div>
</div>


#### update `~/.kube/config`
```bash
$ sudo rm -rf ~/.kube/config
$ sudo cp /etc/kubernetes/admin.conf ~/.kube/config
$ sudo chown devops:devops ~/.kube/config
$ sudo chmod 644 ~/.kube/config
```

### sync to redundant masters
```bash
$ for pkg in '*.key' '*.crt' '*.pub'; do
    sudo rsync -avzrlpgoDP \
               -e "ssh -i $HOME/.ssh/id_ed25519" \
               --rsync-path='sudo rsync' \
               devops@<majorMaster>:"/etc/kubernetes/pki/${pkg}" /etc/kubernetes/pki/
  done

# for stacked etcd
$ for _i in server healthcheck-client peer; do
    sudo rsync -avzrlpgoDP  \
               -e "ssh -i $HOME/.ssh/id_ed25519" \
               --rsync-path='sudo rsync' \
               devops@<majorMaster>"/etc/kubernetes/pki/etcd/${_i}.{crt,key}" /etc/kubernetes/pki/etcd/
 done

# for kubeconfig
$ for _i in admin kubelet controller-manager scheduler; do
    sudo rsync -avzrlpgoDP \
               -e "ssh -i $HOME/.ssh/id_ed25519" \
               --rsync-path='sudo rsync' \
               devops@<majorMaster>:"/etc/kubernetes/${_i}.conf" /etc/kubernetes/
 done
```

### restart kubelet
#### kill all services
```bash
$ sudo kill -s SIGHUP $(pidof kube-apiserver)
$ sudo kill -s SIGHUP $(pidof kube-controller-manager)
$ sudo kill -s SIGHUP $(pidof kube-scheduler)
```

#### restart service
```bash
$ sudo rm -rf /var/lib/kubelet/pki/*
$ sudo systemctl status kubelet
$ sudo systemctl restart kubelet
$ sudo systemctl --no-pager -l status kubelet
```

## v1.15.3

> reference:
> - [Renewing Kubernetes 1.14.x cluster certificates](https://www.ibm.com/support/knowledgecenter/SSCKRH_1.0.3/platform/t_certificate_renewal_k14.html)
> - [Renew cluster certificates](https://www.alibabacloud.com/help/doc-detail/122584.htm)
> - [Certificate Management with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/kubeadm-certs/)
> - [kubeadm alpha](https://kubernetes.io/docs/reference/setup-tools/kubeadm/kubeadm-alpha/)
> - [kubeadm alpha](https://kubernetes-docsy-staging.netlify.app/docs/reference/setup-tools/kubeadm/kubeadm-alpha/)
> - [Kubernetes v1.15 - Administration with kubeadm](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/_print/)

> [!TIP]
> for [external etcd topology](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/ha-topology/#external-etcd-topology) <br>
>
> ```bash
> $ kubectl version --short
> Client Version: v1.15.3
> Server Version: v1.15.3
> ```

### renew certificates

> [!TIP]
> in **major master**
> <br>
> NOTE: *major master* is the master node bind with load balance ip.
> <br>
> the key master node picked by keepalived. check it by using:
> ```bash
> ip a s "${interface}" | sed -rn 's|\W*inet[^6]\W*([0-9\.]{7,15}).*$|\1|p'
> ```
> <br>
> references:
> - [kubeadm-conf.yaml](https://raw.githubusercontent.com/marslo/mytools/master/kubernetes/init/kubeadm-conf.yaml)

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

- or
  ```bash
  $ for i in apiserver apiserver-kubelet-client front-proxy-client; do
      sudo kubeadm --config kubeadm-conf.yaml alpha certs renew ${i}
    done
  certificate for serving the Kubernetes API renewed
  certificate for the API server to connect to kubelet renewed
  certificate for the front proxy client renewed
  ```

### sync to redundant masters

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

  - or
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

#### setup `~/.kube/config`
```bash
$ sudo cp /etc/kubernetes/admin.conf ~/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
$ sudo chmod 644 $HOME/.kube/config
```

| configuration file | path      |
|:------------------:|:---------:|
| `config`           | `~/.kube` |


### [restart the master components](https://stackoverflow.com/a/62911194)
```bash
$ sudo kill -s SIGHUP $(pidof kube-apiserver)
$ sudo kill -s SIGHUP $(pidof kube-controller-manager)
$ sudo kill -s SIGHUP $(pidof kube-scheduler)
```

- or
  ```bash
  $ echo {kube-apiserver,kube-controller-manager,kube-scheduler} |
         fmt -1 |
         xargs -I{} bash -c "sudo kill -s SIGHUP $(pidof {}) "
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
#### via kubernetes api (`load.balance.ip.address:6443`)
```bash
$ echo -n |
       openssl s_client -connect x.x.x.:6443 2>&1 |
       sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' |
       openssl x509 -text -noout |
       grep Not
            Not Before: Sep 17 07:51:58 2019 GMT
            Not After : Sep 21 09:09:00 2021 GMT
```

## renew work node
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
## basic environment

> [!TIP]
> ```bash
> $ kubectl version --short
> Client Version: v1.12.3
> Server Version: v1.12.3
> ```

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

## renew kubeconfig
> references:
> - [Configure certificates for user accounts](https://kubernetes.io/docs/setup/best-practices/certificates/#configure-certificates-for-user-accounts)
> - [kubernetes > about the cluster-admin cluster role binding](https://networkandcode.github.io/kubernetes/2020/03/16/cluster-admin.html)


<div class="alert alert-success hints-alert">
  <div class="hints-icon">
  <i class="fa fa-mortar-board"></i>
  </div>
  <div class="hints-container">
  <blockquote>

    <h4>Subjects:</h4>
    <h5>configuration files</h5>
    <table>
      <thead>
        <tr>
        <th>config</th>
        <th>subject</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>controller-manager.conf</code></td>
          <td><code>Subject: CN=system:kube-contdoller-manager</code></td>
        </tr>
        <tr>
          <td><code>admin.conf</code></td>
          <td><code>Subject: O=system:masters, CN=kubernetes-admin</code></td>
        </tr>
        <tr>
          <td><code>scheduler.conf</code></td>
          <td><code>Subject: O=system:masters, CN=system:kube-scheduler</code></td>
        </tr>
        <tr>
          <td><code>kubelet.conf</code></td>
          <td><code>Subject: O=system:nodes, CN=system:node:kubernetes-master01 ( CN=system:node:<HOSTNAME> )</code></td>
        </tr>
      </tbody>
    </table>
    <br>
    <h5>configuration files</h5>
    <table>
      <thead>
        <tr>
        <th>certs</th>
        <th>subject</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td><code>front-proxy-client.crt</code></td>
          <td><code>Subject: CN=front-proxy-client</code></td>
        </tr>
        <tr>
          <td><code>server.crt</code></td>
          <td><code>Subject: CN=kubernetes-master01</code> ( <code>CN=HOSTNAME</code> )</td>
        </tr>
        <tr>
          <td><code>peer.crt</code></td>
          <td><code>Subject: CN=kubernetes-master01</code> ( <code>CN=HOSTNAME</code> )</td>
        </tr>
        <tr>
          <td><code>healthcheck-client.crt</code></td>
          <td><code>Subject: O=system:masters, CN=kube-etcd-healthcheck-client</code></td>
        </tr>
        <tr>
          <td><code>apiserver.crt</code></td>
          <td><code>Subject: CN=kube-apiserver</code></td>
        </tr>
        <tr>
          <td><code>apiserver-kubelet-client.crt</code></td>
          <td><code>Subject: O=system:masters, CN=kube-apiserver-kubelet-client</code></td>
        </tr>
        <tr>
          <td><code>apiserver-etcd-client.crt</code></td>
          <td><code>Subject: O=system:masters, CN=kube-apiserver-etcd-client</code></td>
        </tr>
      </tbody>
    </table>

  </blockquote>
  </div>
</div>

### generate new certificate (csr)
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

### signing the certificate via `ca.crt`
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

> [!TIP]
> ```bash
> $ cp ~/.kube/config config
>
> $ kubectl --kubeconfig=config get ns
> error: You must be logged in to the server (Unauthorized)
> ```

### renew via [`kubeadm alpha`](https://www.cnblogs.com/justmine/p/11314843.html)

- 1.15-
  ```bash
  $ sudo kubeadm [--config ~/kubeadm.yaml] alpha phase kubeconfig all
  ```

  - renew all certs
    ```bash
    $ sudo kubeadm [--config ~/kubeadm.yaml] alpha phase certs renew all
    ```
  - re-generate all certs
    ```bash
    $ sudo kubeadm [--config ~/kubeadm.yaml] alpha phase certs all
    ```

- v1.15+
  ```bash
  $ sudo kubeadm [--config ~/kubeadm.yaml] alpha certs renew all
  ```

  - renew all certs
    ```bash
    $ sudo kubeadm [--config ~/kubeadm.yaml] alpha certs renew all
    ```

### renew via `kubectl config`

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

### renew via `base64` manually
```bash
$ sed -re "s/(.*client-certificate-data:)(.*)$/\1 $(cat marslo.crt | base64 -w0)/g" -i config
$ sed -re "s/(.*client-key-data:)(.*)$/\1 $(cat marslo.key| base64 -w0)/g" -i config
```

### vaildate
```bash
$ kubectl --kubeconfig=config get ns | grep kube
kube-public            Active   3y10d
kube-system            Active   3y10d
```

### more details

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


# reference

> [!TIP]
> reference:
> - [* Kubernetes中的证书工作机制](https://blog.51cto.com/u_15127645/4342894)
> - [证书](https://kubernetes.io/zh/docs/tasks/administer-cluster/certificates/)
> - [手动档搭建 Kubernetes HA 集群](https://mritd.com/2017/07/21/set-up-kubernetes-ha-cluster-by-binary/)
> - [Certificates](https://kubernetes.io/docs/tasks/administer-cluster/certificates/)
> - [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
> - [Generate self-signed certificates](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html)
> - [Certification authority root certificate expiry and renewal](https://serverfault.com/a/308100)
> - [Certificates](https://kubernetes.io/docs/concepts/cluster-administration/certificates/)
> - [CUSTOM CERTIFICATE AUTHORITY](https://choria.io/docs/configuration/custom_ca/)
> - [CONFIGURING ETCD RBAC](https://docs.projectcalico.org/reference/etcd-rbac/)
> - [Certificate Authority with CFSSL](https://jite.eu/2019/2/6/ca-with-cfssl/)
> - [Deploy a secure etcd cluster](https://pcocc.readthedocs.io/en/latest/deps/etcd-production.html)
> - [K8S Cluster tls Certificate Management](https://programmer.group/k8s-cluster-tls-certificate-management.html)
> - [Access Kubernetes API with Client Certificates](https://codefarm.me/2019/02/01/access-kubernetes-api-with-client-certificates/)
> - [Public-key cryptography and X.509](https://codefarm.me/2019/01/31/public-key-cryptography-and-x509/)
> - [Bootstrapping Kubernetes Clusters with kubeadm](https://codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/)
> - [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
> - [how to renew the certificate when apiserver cert expired?](https://github.com/kubernetes/kubeadm/issues/581#issuecomment-421477139)
> - [Can not access my kubernetes cluster even if all my server certificates are valid](https://stackoverflow.com/a/52964957)
> - [The Cluster API Book](https://cluster-api.sigs.k8s.io/tasks/certs/generate-kubeconfig.html)
> - [K8S 集群中的认证、授权与 kubeconfig](http://www.xuyasong.com/?p=2054)
> - [Certificate Signing Requests](https://kubernetes.io/docs/reference/access-authn-authz/certificate-signing-requests/)
> - [Authenticating](https://kubernetes.io/docs/reference/access-authn-authz/authentication/)
> - [Kubernetes – KUBECONFIG and Context](https://theithollow.com/2019/02/11/kubernetes-kubeconfig-and-context/)
> - [The connection to the server x.x.x.:6443 was refused - did you specify the right host or port? Kubernetes](https://stackoverflow.com/a/65409311/2940319)
> - [Troubleshooting kubectl Error: The connection to the server x.x.x.x:6443 was refused – did you specify the right host or port?](https://www.thegeekdiary.com/troubleshooting-kubectl-error-the-connection-to-the-server-x-x-x-x6443-was-refused-did-you-specify-the-right-host-or-port/)
> - [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)

## Required certificates:

| Default CN                      |         Parent CA         |  O (in Subject)  |      kind      |                         hosts (SAN)                         |
|:--------------------------------|:-------------------------:|:----------------:|:--------------:|:-----------------------------------------------------------:|
| `kube-etcd`                     |          etcd-ca          |         -        | server, client | `hostname` <br> `Host_IP` <br> `localhost` <br> `127.0.0.1` |
| `kube-etcd-peer`                |          etcd-ca          |         -        | server, client | `hostname` <br> `Host_IP` <br> `localhost` <br> `127.0.0.1` |
| `kube-etcd-healthcheck-client`  |          etcd-ca          |         -        |     client     |                              -                              |
| `kube-apiserver-etcd-client`    |          etcd-ca          | `system:masters` |     client     |                              -                              |
| `kube-apiserver`                |       kubernetes-ca       |         -        |     server     |          `hostname`, `Host_IP`, `advertise_IP`, [1]         |
| `kube-apiserver-kubelet-client` |       kubernetes-ca       | `system:masters` |     client     |                              -                              |
| `front-proxy-client`            | kubernetes-front-proxy-ca |         -        |     client     |                              -                              |

## [Certificate paths](https://kubernetes.io/docs/setup/best-practices/certificates/#certificate-paths)

| Default CN                      | recommended key path           | recommended cert path          | command                   | key argument                 | cert argument                                                               |
|:--------------------------------|:-------------------------------|--------------------------------|---------------------------|------------------------------|-----------------------------------------------------------------------------|
| `etcd-ca`                       | `etcd/ca.key`                  | `etcd/ca.crt`                  | `kube-apiserver`          | -                            | `--etcd-cafile`                                                             |
| `kube-apiserver-etcd-client`    | `apiserver-etcd-client.key`    | `apiserver-etcd-client.crt`    | `kube-apiserver`          | `--etcd-keyfile`             | `--etcd-certfile`                                                           |
| `kubernetes-ca`                 | `ca.key`                       | `ca.crt`                       | `kube-apiserver`          | -                            | `--client-ca-file`                                                          |
| `kubernetes-ca`                 | `ca.key`                       | `ca.crt`                       | `kube-controller-manager` | `--cluster-signing-key-file` | `--client-ca-file` <br> `--root-ca-file` <br> `--cluster-signing-cert-file` |
| `kube-apiserver`                | `apiserver.key`                | `apiserver.crt`                | `kube-apiserver`          | `--tls-private-key-file`     | `--tls-cert-file`                                                           |
| `kube-apiserver-kubelet-client` | `apiserver-kubelet-client.key` | `apiserver-kubelet-client.crt` | `kube-apiserver`          | `--kubelet-client-key`       | `--kubelet-client-certificate`                                              |
| `front-proxy-ca`                | `front-proxy-ca.key`           | `front-proxy-ca.crt`           | `kube-apiserver`          | -                            | `--requestheader-client-ca-file`                                            |
| `front-proxy-ca`                | `front-proxy-ca.key`           | `front-proxy-ca.crt`           | `kube-controller-manager` | -                            | `--requestheader-client-ca-file`                                            |
| `front-proxy-client`            | `front-proxy-client.key`       | `front-proxy-client.crt`       | `kube-apiserver`          | `--proxy-client-key-file`    | `--proxy-client-cert-file`                                                  |
| `etcd-ca`                       | `etcd/ca.key`                  | `etcd/ca.crt`                  | `etcd`                    | -                            | `--trusted-ca-file` <br> `--peer-trusted-ca-file`                           |
| `kube-etcd`                     | `etcd/server.key`              | `etcd/server.crt`              | `etcd`                    | `--key-file`                 | `--cert-file`                                                               |
| `kube-etcd-peer`                | `etcd/peer.key`                | `etcd/peer.crt`                | `etcd`                    | `--peer-key-file`            | `--peer-cert-file`                                                          |
| `etcd-ca`                       | -                              | `etcd/ca.crt`                  | `etcdctl`                 | -                            | `--cacert`                                                                  |
| `kube-etcd-healthcheck-client`  | `etcd/healthcheck-client.key`  | `etcd/healthcheck-client.crt`  | `etcdctl`                 | `--key`                      | `--cert`                                                                    |

## [Configure certificates for user accounts](https://kubernetes.io/docs/setup/best-practices/certificates/#configure-certificates-for-user-accounts)

| filename                  | credential name            | Default CN                          |  O (in Subject)  |
|:--------------------------|----------------------------|-------------------------------------|:----------------:|
| `admin.conf`              | default-admin              | `kubernetes-admin`                  | `system:masters` |
| `kubelet.conf`            | default-auth               | `system:node:<nodeName>` (see note) |  `system:nodes`  |
| `controller-manager.conf` | default-controller-manager | `system:kube-controller-manager`    |         -        |
| `scheduler.conf`          | default-scheduler          | `system:kube-scheduler`             |         -        |

## files are used as follows
| filename                    | command                     | comment                                                               |
| :-------------------------- | :-------------------------: | --------------------------------------------------------------------- |
| `admin.conf`                | `kubectl`                   | Configures administrator user for the cluster                         |
| `kubelet.conf`              | `kubelet`                   | One required for each node in the cluster.                            |
| `controller-manager.conf`   | `kube-controller-manager`   | Must be added to manifest in manifests/kube-controller-manager.yaml   |
| `scheduler.conf`            | `kube-scheduler`            | Must be added to manifest in manifests/kube-scheduler.yaml            |

