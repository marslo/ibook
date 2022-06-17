<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [references](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## references

{% hint style='tip' %}
references:
> - [Bootstrapping clusters with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/)
> - [Customizing components with the kubeadm API](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/)
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)
> - [Considerations for large clusters](https://kubernetes.io/docs/setup/best-practices/cluster-large/)
> - [PKI certificates and requirements](https://kubernetes.io/docs/setup/best-practices/certificates/)
{% endhint %}


- [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)
  ```bash
  # Update HOST0, HOST1 and HOST2 with the IPs of your hosts
  export HOST0=10.0.0.6
  export HOST1=10.0.0.7
  export HOST2=10.0.0.8

  # Update NAME0, NAME1 and NAME2 with the hostnames of your hosts
  export NAME0="infra0"
  export NAME1="infra1"
  export NAME2="infra2"

  # Create temp directories to store files that will end up on other hosts.
  mkdir -p /tmp/${HOST0}/ /tmp/${HOST1}/ /tmp/${HOST2}/

  HOSTS=(${HOST0} ${HOST1} ${HOST2})
  NAMES=(${NAME0} ${NAME1} ${NAME2})

  for i in "${!HOSTS[@]}"; do
  HOST=${HOSTS[$i]}
  NAME=${NAMES[$i]}
  cat << EOF > /tmp/${HOST}/kubeadmcfg.yaml
  ---
  apiVersion: "kubeadm.k8s.io/v1beta3"
  kind: InitConfiguration
  nodeRegistration:
      name: ${NAME}
  localAPIEndpoint:
      advertiseAddress: ${HOST}
  ---
  apiVersion: "kubeadm.k8s.io/v1beta3"
  kind: ClusterConfiguration
  etcd:
      local:
          serverCertSANs:
          - "${HOST}"
          peerCertSANs:
          - "${HOST}"
          extraArgs:
              initial-cluster: ${NAMES[0]}=https://${HOSTS[0]}:2380,${NAMES[1]}=https://${HOSTS[1]}:2380,${NAMES[2]}=https://${HOSTS[2]}:2380
              initial-cluster-state: new
              name: ${NAME}
              listen-peer-urls: https://${HOST}:2380
              listen-client-urls: https://${HOST}:2379
              advertise-client-urls: https://${HOST}:2379
              initial-advertise-peer-urls: https://${HOST}:2380
  EOF
  done
  ```

- Generate the certificate authority

  > [!TIP]
  > to generate:
  > - `/etc/kubernetes/pki/etcd/ca.crt`
  > - `/etc/kubernetes/pki/etcd/ca.key`


  ```bash
  $ kubeadm init phase certs etcd-ca
  ```

- Create certificates for each member
  ```bash
  kubeadm init phase certs etcd-server --config=/tmp/${HOST2}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-peer --config=/tmp/${HOST2}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
  kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST2}/kubeadmcfg.yaml
  cp -R /etc/kubernetes/pki /tmp/${HOST2}/
  # cleanup non-reusable certificates
  find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

  kubeadm init phase certs etcd-server --config=/tmp/${HOST1}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-peer --config=/tmp/${HOST1}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
  kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST1}/kubeadmcfg.yaml
  cp -R /etc/kubernetes/pki /tmp/${HOST1}/
  find /etc/kubernetes/pki -not -name ca.crt -not -name ca.key -type f -delete

  kubeadm init phase certs etcd-server --config=/tmp/${HOST0}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-peer --config=/tmp/${HOST0}/kubeadmcfg.yaml
  kubeadm init phase certs etcd-healthcheck-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
  kubeadm init phase certs apiserver-etcd-client --config=/tmp/${HOST0}/kubeadmcfg.yaml
  # No need to move the certs because they are for HOST0

  # clean up certs that should not be copied off this host
  find /tmp/${HOST2} -name ca.key -type f -delete
  find /tmp/${HOST1} -name ca.key -type f -delete
  ```

- Copy certificates and kubeadm configs
  ```bash
  USER=ubuntu
  HOST=${HOST1}
  scp -r /tmp/${HOST}/* ${USER}@${HOST}:
  ssh ${USER}@${HOST}
  USER@HOST $ sudo -Es
  root@HOST $ chown -R root:root pki
  root@HOST $ mv pki /etc/kubernetes/
  ```

- Create the static pod manifests
  ```bash
  root@HOST0 $ kubeadm init phase etcd local --config=/tmp/${HOST0}/kubeadmcfg.yaml
  root@HOST1 $ kubeadm init phase etcd local --config=$HOME/kubeadmcfg.yaml
  root@HOST2 $ kubeadm init phase etcd local --config=$HOME/kubeadmcfg.yaml
  ```
- [Optional]: Check the cluster health
  ```bash
  docker run --rm -it \
             --net host \
             -v /etc/kubernetes:/etc/kubernetes k8s.gcr.io/etcd:${ETCD_TAG} etcdctl \
             --cert /etc/kubernetes/pki/etcd/peer.crt \
             --key /etc/kubernetes/pki/etcd/peer.key \
             --cacert /etc/kubernetes/pki/etcd/ca.crt \
             --endpoints https://${HOST0}:2379 \
             endpoint health \
             --cluster
  ...
  https://[HOST0 IP]:2379 is healthy: successfully committed proposal: took = 16.283339ms
  https://[HOST1 IP]:2379 is healthy: successfully committed proposal: took = 19.44402ms
  https://[HOST2 IP]:2379 is healthy: successfully committed proposal: took = 35.926451ms
  ```
