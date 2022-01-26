<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [certificate](#certificate)
  - [extend etcd](#extend-etcd)
- [references](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## certificate
> reference:
> - [Generate self-signed certificates](https://coreos.com/os/docs/latest/generate-self-signed-certificates.html)
> - [Certification authority root certificate expiry and renewal](https://serverfault.com/a/308100)
> - [Certificates](https://kubernetes.io/docs/concepts/cluster-administration/certificates/)
> - [CUSTOM CERTIFICATE AUTHORITY](https://choria.io/docs/configuration/custom_ca/)
> - [CONFIGURING ETCD RBAC](https://docs.projectcalico.org/reference/etcd-rbac/)
> - [Certificate Authority with CFSSL](https://jite.eu/2019/2/6/ca-with-cfssl/)
> - [Deploy a secure etcd cluster](https://pcocc.readthedocs.io/en/latest/deps/etcd-production.html)
> - [K8S Cluster tls Certificate Management](https://programmer.group/k8s-cluster-tls-certificate-management.html)

> [!TIP]
> ```bash
> # hostname
> master01Name='master01'
> master02Name='master02'
> master03Name='master03'
>
> # ipaddress
> master01IP='192.168.100.200'
> master01IP='192.168.100.201'
> master01IP='192.168.100.202'
> virtualIP='192.168.100.250'
>
> leadIP="${master01IP}"
> leadName="${master01Name}"
>
> k8sVer='v1.15.3'
> cfsslDownloadUrl='https://pkg.cfssl.org/R1.2'
>
> etcdVer='v3.3.15'
> etcdDownloadUrl='https://github.com/etcd-io/etcd/releases/download'
> etcdSSLPath='/etc/etcd/ssl'
> etcdInitialCluster="${master01Name}=https://${master01IP}:2380,${master02Name}=https://${master02IP}:2380,${master03Name}=https://${master03IP}:2380"
>
> keepaliveVer='2.0.18'
> haproxyVer='2.0.6'
> helmVer='v2.14.3'
>
> interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')
> ipAddr=$(ip a s "${interface}" | sed -rn 's|\W*inet[^6]\W*([0-9\.]{7,15}).*$|\1|p')
> peerName=$(hostname)
> ```

### extend etcd
- prepare
  ```bash
  $ sudo mkdir -p ${etcdSSLPath}
  $ cd ${etcdSSLPath}
  ```

> [!TIP]
> setup certificate in **major master**

| File       | Description                                                         |
| :-:        | :-:                                                                 |
| ca.csr     | The signing request that the Root will sign                         |
| ca.pem     | The unsigned intermediate so it’s useless, you can discard this one |
| ca-key.pem | The private key for your CA, do not lose this or share it           |


#### configuration
- `ca-config.json`
  ```bash
  master01 $ sudo bash -c 'cat > ${etcdSSLPath}/ca-config.json' << EOF
  {
      "signing": {
          "default": {
              "expiry": "43800h"
          },
          "profiles": {
              "server": {
                  "expiry": "43800h",
                  "usages": [
                      "signing",
                      "key encipherment",
                      "server auth",
                      "client auth"
                  ]
              },
              "client": {
                  "expiry": "43800h",
                  "usages": [
                      "signing",
                      "key encipherment",
                      "client auth"
                  ]
              },
              "peer": {
                  "expiry": "43800h",
                  "usages": [
                      "signing",
                      "key encipherment",
                      "server auth",
                      "client auth"
                  ]
              }
          }
      }
  }
  EOF
  ```

- CA
  ```bash
  master01 $ sudo bash -c 'cat > ${etcdSSLPath}/ca-csr.json' << EOF
  {
      "CN": "etcd",
      "key": {
          "algo": "rsa",
          "size": 2048
      }
  }
  EOF
  ```

- client
  ```bash
  master01 $ sudo bash -c 'cat > ${etcdSSLPath}/client.json' << EOF
  {
      "CN": "client",
      "key": {
          "algo": "ecdsa",
          "size": 256
      }
  }
  EOF
  ```

- generate cert for CA and Client
  ```bash
  $ cd ${etcdSSLPath}

  # ca
  $ sudo /usr/local/bin/cfssl gencert \
         -initca ca-csr.json \
         | sudo /usr/local/bin/cfssljson -bare ca -

  # client
  $ sudo /usr/local/bin/cfssl gencert \
         -ca=ca.pem \
         -ca-key=ca-key.pem \
         -config=ca-config.json \
         -profile=client client.json \
         | sudo /usr/local/bin/cfssljson -bare client
  ```

  - result
    ```bash
    master01 $ ls
    ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem
    ...
    master01 $ ls
    ca-config.json  ca.csr  ca-csr.json  ca-key.pem  ca.pem  client.csr  client.json  client-key.pem  client.pem
    ```
  - check expired time
    ```bash
    $ openssl x509 -in ca.pem -text -noout | grep -w Not
                Not Before: Sep 10 10:44:00 2019 GMT
                Not After : Sep  8 10:44:00 2024 GMT
    ```
  - verify
    ```bash
    $ ls /etc/etcd/ssl/*.pem \
         | grep -Ev 'key.pem$' \
         | xargs -L 1 -t  -i bash -c 'openssl verify -CAfile ca.pem {}'
    bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/ca.pem
    /etc/etcd/ssl/ca.pem: OK
    bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/client.pem
    /etc/etcd/ssl/client.pem: OK
    bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/peer.pem
    /etc/etcd/ssl/peer.pem: OK
    bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/server.pem
    /etc/etcd/ssl/server.pem: OK
    ```

- copy certs

> [!TIP]
> copy ected certificates to **another masters**

```bash
$ for i in {2..3}; do
  ssh master0${i} 'sudo mkdir -p ${etcdSSLPath}'
  rsync -avzrlpgoDP \
        --rsync-path='sudo rsync' \
        ${etcdSSLPath}/*.pem \
        master0${i}:${etcdSSLPath}/
  rsync -avzrlpgoDP \
        --rsync-path='sudo rsync' \
        ${etcdSSLPath}/ca-config.json \
        master0${i}:${etcdSSLPath}/
done
```

## references
- [使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [Creating a cluster with kubeadm v1.21](https://v1-21.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
