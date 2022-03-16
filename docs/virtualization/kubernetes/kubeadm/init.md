<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [HA Cluster](#ha-cluster)
  - [basic environment](#basic-environment)
    - [cfssl](#cfssl)
    - [etcd](#etcd)
    - [keepalive](#keepalive)
  - [extend etcd](#extend-etcd)
    - [configuration](#configuration)
    - [generate cert for CA and Client](#generate-cert-for-ca-and-client)
    - [peer](#peer)
    - [enable etcd service](#enable-etcd-service)
    - [HAProxy](#haproxy)
  - [kubeadm init](#kubeadm-init)
    - [kubeadm-conf.yaml](#kubeadm-confyaml)
    - [init master](#init-master)
    - [sync PKI](#sync-pki)
  - [references](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# HA Cluster

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

## basic environment
### cfssl
```bash
$ sudo bash -c "curl -o /usr/local/bin/cfssl ${cfsslDownloadUrl}/cfssl_linux-amd64"
$ sudo bash -c "curl -o /usr/local/bin/cfssljson ${cfsslDownloadUrl}/cfssljson_linux-amd64"
$ sudo chmod +x /usr/local/bin/cfssl*
```

### etcd
```bash
$ curl -sSL ${etcdDownloadUrl}/${etcdVer}/etcd-${etcdVer}-linux-amd64.tar.gz |
 |  |  |  sudo tar -xzv --strip-components=1 -C /usr/local/bin/
```

### keepalive
```bash
$ mkdir -p ~/temp
$ sudo mkdir -p /etc/keepalived/

$ curl -fsSL ${keepaliveDownloadUrl}/keepalived-${keepaliveVer}.tar.gz |
       tar xzf - -C ~/temp
$ cd ~/temp/keepalived-${keepaliveVer}
$ ./configure && make
$ sudo make install
$ sudo cp keepalived/keepalived.service /etc/systemd/system/

$ sudo bash -c 'cat > /etc/keepalived/keepalived.conf' <<EOF
! Configuration File for keepalived
global_defs {
  router_id LVS_DEVEL
}
vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  weight -2
  fall 10
  rise 2
}
vrrp_instance VI_1 {
  state MASTER
  interface ${interface}
  virtual_router_id 51
  priority 101
  authentication {
    auth_type PASS
    auth_pass 4be37dc3b4c90194d1600c483e10ad1d
  }
  virtual_ipaddress {
    ${virtualIpAddr}
  }
  track_script {
    check_apiserver
  }
}
EOF

$ sudo bash -c 'cat > /etc/keepalived/check_apiserver.sh' <<EOF
#!/bin/sh
errorExit() {
  echo "*** \$*" 1>&2
  exit 1
}
curl --silent --max-time 2 --insecure https://localhost:6443/ -o /dev/null || errorExit "Error GET https://localhost:6443/"
if ip addr | grep -q ${virtualIpAddr}; then
    curl --silent --max-time 2 --insecure https://${virtualIpAddr}:6443/ -o /dev/null || errorExit "Error GET https://${virtualIpAddr}:6443/"
fi
EOF

$ sudo systemctl enable keepalived.service
$ sudo systemctl start keepalived.service
```

## extend etcd
- prepare
  ```bash
  $ sudo mkdir -p ${etcdSSLPath}
  $ cd ${etcdSSLPath}
  ```

> [!TIP]
> setup certificate in **major master**
>

| File       | Description                                                         |
| :-:        | :-:                                                                 |
| ca.csr     | The signing request that the Root will sign                         |
| ca.pem     | The unsigned intermediate so it’s useless, you can discard this one |
| ca-key.pem | The private key for your CA, do not lose this or share it           |


### configuration
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

### generate cert for CA and Client
```bash
$ cd ${etcdSSLPath}

# ca
$ sudo /usr/local/bin/cfssl gencert \
       -initca ca-csr.json |
       sudo /usr/local/bin/cfssljson -bare ca -

# client
$ sudo /usr/local/bin/cfssl gencert \
       -ca=ca.pem \
       -ca-key=ca-key.pem \
       -config=ca-config.json \
       -profile=client client.json |
       sudo /usr/local/bin/cfssljson -bare client
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
  $ ls /etc/etcd/ssl/*.pem |
       grep -Ev 'key.pem$' |
       xargs -L 1 -t  -i bash -c 'openssl verify -CAfile ca.pem {}'
  bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/ca.pem
  /etc/etcd/ssl/ca.pem: OK
  bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/client.pem
  /etc/etcd/ssl/client.pem: OK
  bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/peer.pem
  /etc/etcd/ssl/peer.pem: OK
  bash -c openssl verify -CAfile ca.pem /etc/etcd/ssl/server.pem
  /etc/etcd/ssl/server.pem: OK
  ```

#### copy certs

> [!TIP]
> copy ected certificates to **following masters**

```bash
# running in major master
$ for i in {2..3}; do
  ssh master0${i} 'sudo mkdir -p ${etcdSSLPath}'
  for pkg in ca-config.json  ca-key.pem  ca.pem  client-key.pem  client.pem; do
    rsync -avzrlpgoDP \
          --rsync-path='sudo rsync' \
          ${etcdSSLPath}/${pkg} \
          master0${i}:${etcdSSLPath}/
  done
done

# or running in following master one by one
$ for pkg in ca-config.json  ca-key.pem  ca.pem  client-key.pem  client.pem; do
  sudo rsync -avzrlpgoDP \
             --rsync-path='sudo rsync' \
             root@${leadHost}:${etcdSSLPath}/${pkg} \
             ${etcdSSLPath}/
done
```

### peer

> [!TIP]
> running in all masters

```bash
$ sudo bash -c "/usr/local/bin/cfssl print-defaults csr > ${etcdSSLPath}/config.json"
$ sudo sed -i '0,/CN/{s/example\.net/'"${peerName}"'/}' ${etcdSSLPath}/config.json
$ sudo sed -i 's/www\.example\.net/'"${ipAddr}"'/' ${etcdSSLPath}/config.json
$ sudo sed -i 's/example\.net/'"${peerName}"'/' ${etcdSSLPath}/config.json

$ cd ${etcdSSLPath}/
$ ls
ca-config.json  ca-csr.json  ca.pem      client.json     client.pem
ca.csr          ca-key.pem   client.csr  client-key.pem  config.json

$ sudo /usr/local/bin/cfssl gencert \
       -ca=ca.pem \
       -ca-key=ca-key.pem \
       -config=ca-config.json \
       -profile=server config.json |
       sudo /usr/local/bin/cfssljson -bare server

$ sudo /usr/local/bin/cfssl gencert \
       -ca=ca.pem \
       -ca-key=ca-key.pem \
       -config=ca-config.json \
       -profile=peer config.json |
       sudo /usr/local/bin/cfssljson -bare peer

# in following masters
$ ls
ca-config.json  ca.pem          client.pem   peer.csr      peer.pem    server-key.pem
ca-key.pem      client-key.pem  config.json  peer-key.pem  server.csr  server.pem
```

### enable etcd service

> [!TIP]
> running in all masters

```bash
$ sudo bash -c 'cat >/etc/systemd/system/etcd.service' <<EOF
[Install]
WantedBy=multi-user.target
[Unit]
Description=Etcd Server
Documentation=https://github.com/Marslo/mytools
Conflicts=etcd.service
Conflicts=etcd2.service
[Service]
Type=notify
WorkingDirectory=/var/lib/etcd/
Restart=always
RestartSec=5s
EnvironmentFile=-/etc/etcd/etcd.conf
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/local/bin/etcd"
Restart=on-failure
RestartSec=5
LimitNOFILE=65536
[Install]
WantedBy=multi-user.target
EOF

$ sudo bash -c 'cat > /etc/etcd/etcd.conf' <<EOF
ETCD_NAME=${peerName}
ETCD_DATA_DIR="/var/lib/etcd/default.etcd"
#ETCD_WAL_DIR=""
#ETCD_SNAPSHOT_COUNT="10000"
#ETCD_HEARTBEAT_INTERVAL="100"
#ETCD_ELECTION_TIMEOUT="1000"
ETCD_LISTEN_PEER_URLS="https://0.0.0.0:2380"
ETCD_LISTEN_CLIENT_URLS="https://0.0.0.0:2379"
#ETCD_MAX_SNAPSHOTS="5"
#ETCD_MAX_WALS="5"
#ETCD_CORS=""
#
#[cluster]
ETCD_INITIAL_ADVERTISE_PEER_URLS="https://${ipAddr}:2380"
# if you use different ETCD_NAME (e.g. test), set ETCD_INITIAL_CLUSTER value for this name, i.e. "test=http://
..."
ETCD_INITIAL_CLUSTER="${etcdInitialCluster}"
ETCD_INITIAL_CLUSTER_STATE="new"
ETCD_INITIAL_CLUSTER_TOKEN="etcd-cluster"
ETCD_ADVERTISE_CLIENT_URLS="https://${ipAddr}:2379"
#ETCD_DISCOVERY=""
#ETCD_DISCOVERY_SRV=""
#ETCD_DISCOVERY_FALLBACK="proxy"
#ETCD_DISCOVERY_PROXY=""
#ETCD_STRICT_RECONFIG_CHECK="false"
#ETCD_AUTO_COMPACTION_RETENTION="0"
#
#[proxy]
#ETCD_PROXY="off"
#ETCD_PROXY_FAILURE_WAIT="5000"
#ETCD_PROXY_REFRESH_INTERVAL="30000"
#ETCD_PROXY_DIAL_TIMEOUT="1000"
#ETCD_PROXY_WRITE_TIMEOUT="5000"
#ETCD_PROXY_READ_TIMEOUT="0"
#
#[security]
ETCD_CERT_FILE="${etcdSSLPath}/server.pem"
ETCD_KEY_FILE="${etcdSSLPath}/server-key.pem"
ETCD_CLIENT_CERT_AUTH="true"
ETCD_TRUSTED_CA_FILE="${etcdSSLPath}/ca.pem"
ETCD_AUTO_TLS="true"
ETCD_PEER_CERT_FILE="${etcdSSLPath}/peer.pem"
ETCD_PEER_KEY_FILE="${etcdSSLPath}/peer-key.pem"
#ETCD_PEER_CLIENT_CERT_AUTH="false"
ETCD_PEER_TRUSTED_CA_FILE="${etcdSSLPath}/ca.pem"
ETCD_PEER_AUTO_TLS="true"
#
#[logging]
#ETCD_DEBUG="false"
# examples for -log-package-levels etcdserver=WARNING,security=DEBUG
#ETCD_LOG_PACKAGE_LEVELS=""
#[profiling]
#ETCD_ENABLE_PPROF="false"
#ETCD_METRICS="basic"
EOF

$ sudo systemctl daemon-reload
$ sudo systemctl enable --now etcd
$ sudo systemctl start etcd.service
```

### HAProxy

> [!TIP]
> for HA-Proxy version 2.0.6

```bash
$ sudo bash -c 'cat > /etc/haproxy/haproxy.cfg' <<EOF
#---------------------------------------------------------------------
# Example configuration for a possible web application.  See the
# full configuration options online.
#
#   http://haproxy.1wt.eu/download/2.0/doc/configuration.txt
#
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# Global settings
#---------------------------------------------------------------------
global
    # to have these messages end up in /var/log/haproxy.log you will
    # need to:
    #
    # 1) configure syslog to accept network log events.  This is done
    #    by adding the '-r' option to the SYSLOGD_OPTIONS in
    #    /etc/sysconfig/syslog
    #
    # 2) configure local2 events to go to the /var/log/haproxy.log
    #   file. A line like the following can be added to
    #   /etc/sysconfig/syslog
    #
    #    local2.*                       /var/log/haproxy.log
    #
    log         127.0.0.1 local2

    chroot      /var/lib/haproxy
    pidfile     /var/run/haproxy.pid
    maxconn     4000
    user        haproxy
    group       haproxy
    daemon

    # turn on stats unix socket
    stats socket /var/lib/haproxy/stats

#---------------------------------------------------------------------
# common defaults that all the 'listen' and 'backend' sections will
# use if not designated in their block
#---------------------------------------------------------------------
defaults
    mode                    http
    log                     global
    option                  httplog
    option                  dontlognull
    option http-server-close
    option forwardfor       except 127.0.0.0/8
    option                  redispatch
    retries                 3
    timeout http-request    10s
    timeout queue           1m
    timeout connect         10s
    timeout client          1m
    timeout server          1m
    timeout http-keep-alive 10s
    timeout check           10s
    maxconn                 3000

#---------------------------------------------------------------------
# kubernetes apiserver frontend which proxys to the backends
#---------------------------------------------------------------------
frontend kubernetes-apiserver
    mode                 tcp
    bind                 *:16443
    option               tcplog
    default_backend      kubernetes-apiserver

#---------------------------------------------------------------------
# round robin balancing between the various backends
#---------------------------------------------------------------------
backend kubernetes-apiserver
    mode        tcp
    balance     roundrobin
    option      tcplog
    option      tcp-check
    server      ${master01Name}    ${master01IP}:6443 check
    server      ${master02Name}    ${master02IP}:6443 check
    server      ${master03Name}    ${master03IP}:6443 check

#---------------------------------------------------------------------
# collection haproxy statistics message
#---------------------------------------------------------------------
listen stats
#   bind                 *:1080
    bind                 :8000
    stats auth           <admin>:<password>
    maxconn              50
    stats refresh        10s
    stats realm          HAProxy\ Statistics
    stats uri            /healthy

$ sudo systemctl enable haproxy.service
$ sudo systemctl start haproxy.service
$ sudo ss -lnt | grep -E "16443|8080"
```

## kubeadm init

### kubeadm-conf.yaml

> [!TIP]
> create kubeconfig in all masters

```bash
$ cat > kubeadm-conf.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
kubernetesVersion: ${k8sVer}
controlPlaneEndpoint: "${virtualIpAddr}:6443"
etcd:
  external:
    endpoints:
      - https://${master1Ip}:2379
      - https://${master2Ip}:2379
      - https://${master3Ip}:2379
    caFile: ${etcdSSLPath}/ca.pem
    certFile: ${etcdSSLPath}/client.pem
    keyFile: ${etcdSSLPath}/client-key.pem
networking:
  dnsDomain: cluster.local
  podSubnet: 10.244.0.0/16
  serviceSubnet: 10.96.0.0/12
apiServer:
  certSANs:
    - ${virtualIpAddr}
    - ${master1Ip}
    - ${master1Name}
    - ${master2Ip}
    - ${master2Name}
    - ${master3Ip}
    - ${master3Name}
  extraArgs:
    etcd-cafile: ${etcdSSLPath}/ca.pem
    etcd-certfile: ${etcdSSLPath}/client.pem
    etcd-keyfile: ${etcdSSLPath}/client-key.pem
  timeoutForControlPlane: 4m0s
imageRepository: k8s.gcr.io
clusterName: "dc5tst-cluster"
EOF
```

### init master

> [!TIP]
> init master in major master ONLY

```bash
$ sudo modprobe br_netfilter
$ sudo sysctl net.bridge.bridge-nf-call-iptables=1
$ sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
$ sudo swapoff -a
$ sudo bash -c "sed -e 's:^\\(.*swap.*\\)$:# \\1:' -i /etc/fstab"
$ setenforce 0
$ sudo bash -c "sed 's/^SELINUX=enforcing$/SELINUX=permissive/' -i /etc/selinux/config"

$ sudo kubeadm init --config kubeadm-conf.yaml --ignore-preflight-errors=all
$ mkdir -p "$HOME/.kube"
$ sudo cp -i /etc/kubernetes/admin.conf "$HOME/.kube/config"
$ sudo chown "$(id -u)":"$(id -g)" "$HOME/.kube/config"
```

### sync PKI

> [!TIP]
> sync PKI in following masters ONLY

```bash
$ for pkg in '*.key' '*.crt' '*.pub'; do
  sudo rsync -avzrlpgoDP \
             --rsync-path='sudo rsync' \
             root@${leadIP}:"/etc/kubernetes/pki/${pkg}" \
             /etc/kubernetes/pki/
done
$ sudo rm -rf /etc/kubernetes/pki/apiserver*
# sudo cp -r /root/etcd* /etc/kubernetes/pki/
```


## references
- [belloHAKubeCluster.sh](https://raw.githubusercontent.com/marslo/mytools/master/kubernetes/belloHAKubeCluster.sh)
- [kube-up.sh](https://github.com/kubernetes/kubernetes/blob/master/cluster/kube-up.sh)
- [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)
- [Configuring each kubelet in your cluster using kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/kubelet-integration/)
- [Creating a cluster with kubeadm v1.21](https://v1-21.docs.kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [使用 kubeadm 创建集群](https://kubernetes.io/zh/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/)
- [一步步打造基于Kubeadm的高可用Kubernetes集群-第一部分](https://tonybai.com/2017/05/15/setup-a-ha-kubernetes-cluster-based-on-kubeadm-part1/)
- [一步步打造基于Kubeadm的高可用Kubernetes集群-第二部分](https://tonybai.com/2017/05/15/setup-a-ha-kubernetes-cluster-based-on-kubeadm-part2/)
- [以Kubeadm方式安装的Kubernetes集群的探索](https://tonybai.com/2017/01/24/explore-kubernetes-cluster-installed-by-kubeadm/)
- [使用Kubeadm搭建Kubernetes HA（1.10.1）](https://blog.csdn.net/chenleiking/article/details/80136449)
- [使用Kubeadm + HAProxy + Keepalived部署高可用Kubernetes集群](https://blog.csdn.net/chenleiking/article/details/84841394)
