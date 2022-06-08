<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [etcd](#etcd)
  - [re-add etcd](#re-add-etcd)
- [grafana](#grafana)
  - [kubernetes cluster monitoring](#kubernetes-cluster-monitoring)
  - [references](#references)
  - [api](#api)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## etcd

{% hint style='tip' %}
> references:
> - [Operating etcd clusters for Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/)
> - [Set up a High Availability etcd Cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/setup-ha-etcd-with-kubeadm/)
{% endhint %}

### re-add etcd

```bash
$ ssh devops@kubernets.master
$ docker run -it \
             -v /var/lib/etcd:/var/lib/etcd \
             -v /etc/kubernetes/pki/etcd:/etc/kubernetes/pki/etcd \
             -p 2380:2380 \
             -p 2379:2379 \
             --network=host \
             k8s.gcr.io/etcd:3.2.24

# running inside docker
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member list
 >> a874c87fd42044f: name=<master1Hostname> peerURLs=https://<master1IP>:2380 clientURLs=https://<master1IP>:2379 isLeader=true
 >> 3be12ef2ee5f92e7(unstarted): name=<master3Hostname> peerURLs=https://<master3IP>:2380
 >> da3e2155721a00f6: name=<master2Hostname> peerURLs=https://<master2IP>:2380 clientURLs=https://<master2IP>:2379 isLeader=false


# remove "unstarted" node
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member remove 3be12ef2ee5f92e7

# re-add again
$ etcdctl --ca-file /etc/kubernetes/pki/etcd/ca.crt \
          --cert-file /etc/kubernetes/pki/etcd/peer.crt \
          --key-file /etc/kubernetes/pki/etcd/peer.key \
          -endpoints=https://<master3IP>:2379,https://<master2IP>:2379,https://<master1IP>:2379 \
          member add <master3Hostname> https://<master3IP>:2380
```

## grafana

{% hint style='tip' %}
> references:
> - [* Deploy Grafana Enterprise on Kubernetes](https://grafana.com/docs/grafana/latest/installation/kubernetes/#deploy-grafana-enterprise-on-kubernetes)
> - [* Deploy Grafana on Kubernetes](https://grafana.com/docs/grafana/latest/installation/kubernetes/)
> - [* Kubernetes Integration](https://grafana.com/docs/grafana-cloud/kubernetes/integration-kubernetes/?pg=blog&plcmt=body-txt)
> - [* Install plugin from dockerfile](https://community.grafana.com/t/install-plugin-from-dockerfile/2603/5)
> - [* grafana/grafana-docker](https://github.com/grafana/grafana-docker/blob/master/Dockerfile)
> - [Configure a Grafana Docker image](https://grafana.com/docs/grafana/latest/administration/configure-docker/)
> - [Configure Grafana](https://grafana.com/docs/grafana/next/setup-grafana/configure-grafana/#configure-with-environment-variables)
> - [Grafana 6.2 documentation : Installing using Docker](https://www.bookstack.cn/read/grafana-v6.2/f54c77073729e6c9.md)
> - [Restart Grafana](https://grafana.com/docs/grafana/latest/installation/restart-grafana/)
> - [Grafana Loki Concise Tutorial](https://www.sobyte.net/post/2021-10/grafana-loki-usage/)
> - [Grafana CLI](https://grafana.com/docs/grafana/latest/administration/cli)
{% endhint %}

### kubernetes cluster monitoring
- [devopsprodigy-kubegraf-app](https://grafana.com/grafana/plugins/devopsprodigy-kubegraf-app/)
  - install via `grafana-cli`
    ```bash
    $ grafana-cli plugins install devopsprodigy-kubegraf-app
    ```

  - setup sa and cluster role
    ```bash
    $ kubectl create ns kubegraf
    $ kubectl apply -f https://raw.githubusercontent.com/devopsprodigy/kubegraf/master/kubernetes/serviceaccount.yaml
    $ kubectl apply -f https://raw.githubusercontent.com/devopsprodigy/kubegraf/master/kubernetes/clusterrole.yaml
    $ kubectl apply -f https://raw.githubusercontent.com/devopsprodigy/kubegraf/master/kubernetes/clusterrolebinding.yaml
    $ kubectl apply -f https://raw.githubusercontent.com/devopsprodigy/kubegraf/master/kubernetes/secret.yaml
    ```

  - create private certificate

    {% hint style='tip' %}
    copy `/etc/kubernetes/pki/grafana-kubegraf.crt` to all masters
    {% endhint %}

    ```bash
    $ openssl genrsa -out ~/grafana-kubegraf.key 2048
    $ openssl req -new -key ~/grafana-kubegraf.key -out ~/grafana-kubegraf.csr -subj "/CN=grafana-kubegraf/O=monitoring"
    $ openssl x509 -req -in ~/grafana-kubegraf.csr -CA /etc/kubernetes/pki/ca.crt -CAkey /etc/kubernetes/pki/ca.key -out /etc/kubernetes/pki/grafana-kubegraf.crt -CAcreateserial
    ```
    - get token
      ```bash
      $ kubectl get secret grafana-kubegraf-secret -o jsonpath={.data.token} -n kubegraf | base64 -d
      ```

- [grafana-kubernetes-app](https://grafana.com/grafana/plugins/grafana-kubernetes-app/)

  {% hint style='tip' %}
  @deprecated
  {% endhint %}

  - install via `grafana-cli`
    ```bash
    $ grafana-cli plugins install kubernetes-app
    ```

### references

- path

  |         SETTING         | DEFAULT VALUE               |
  |:-----------------------:|-----------------------------|
  |    `GF_PATHS_CONFIG`    | `/etc/grafana/grafana.ini`  |
  |     `GF_PATHS_DATA`     | `/var/lib/grafana`          |
  |     `GF_PATHS_HOME`     | `/usr/share/grafana`        |
  |     `GF_PATHS_LOGS`     | `/var/log/grafana`          |
  |    `GF_PATHS_PLUGINS`   | `/var/lib/grafana/plugins`  |
  | `GF_PATHS_PROVISIONING` | `/etc/grafana/provisioning` |


- environment

  > [!TIP]
  > - [reference](https://grafana.com/docs/grafana/next/setup-grafana/configure-grafana/#override-configuration-with-environment-variables)
  > Do not use environment variables to add new configuration settings. Instead, use environmental variables to override existing options.
  > <p>
  > To override an option:
  > ```bash
  > GF_<SectionName>_<KeyName>
  > ```
  > <p>
  >If you need to specify the version of a plugin, then you can add it to the `GF_INSTALL_PLUGINS` environment variable.
  > Otherwise, the latest is used. For example:
  > ```bash
  > -e "GF_INSTALL_PLUGINS=grafana-clock-panel 1.0.1,grafana-simple-json-datasource 1.3.5"
  > ```


  |     ENVIRONMENT VARIABLE     | EXAMPLE                                                                  |
  |:----------------------------:|--------------------------------------------------------------------------|
  |     `GF_INSTALL_PLUGINS`     | `grafana-kubernetes-app,grafana-piechart-panel,http://my.com/plugin.zip` |
  |      `GF_PATHS_PLUGINS`      | `/data/grafana/plugins`                                                  |
  |     `GF_SERVER_ROOT_URL`     | `https://my.grafana.com`                                                 |
  | `GF_SECURITY_ADMIN_PASSWORD` | `admin`                                                                  |
  |  `GF_DEFAULT_INSTANCE_NAME`  | -                                                                        |
  |   `GF_SECURITY_ADMIN_USER`   | -                                                                        |
  |      `GF_DATABASE_TYPE`      | `mysql`                                                                  |
  |      `GF_DATABASE_HOST`      | -                                                                        |


### api

> references:
> - [Grafana Docker and data persistence](https://community.grafana.com/t/grafana-docker-and-data-persistence/33702/2)

- Set Grafana admin password

  {% raw %}
  ```bash
  $ docker exec -t grafana bash -c  'grafana-cli --homepath /usr/share/grafana admin reset-admin-password "{{ grafana_passwd }}"'
  ```
  {% endraw %}

- check if grafana can be accessed

  {% raw %}
  ```bash
  $ curl -s http://localhost:3000/api/org -u {{ grafana_user }}:{{ grafana_passwd }}
  ```
  {% endraw %}

- create datasoure in grafana

  {% raw %}
  ```bash
  $ curl -L --header 'Content-Type: application/json' --header 'Accept: application/json' -d@//docker_data/grafana_conf/grafanacfg.output http://localhost:3000/api/datasources -u {{ grafana_user }}:{{ grafana_passwd }}
  ```
  {% endraw %}

- create TelegrafHost dashboard in grafana using jsonfile

  {% raw %}
  ```bash
  $ curl -L --header 'Content-Type: application/json' --header 'Accept: application/json' -d@/home/Configfiles/dashboards/TelegrafHostMetrics.json  http://localhost:3000/api/dashboards/db -u {{ grafana_user }}:{{ grafana_passwd }}
  ```
  {% endraw %}

- create DockerMetrics dashboard in grafana using jsonfile

  {% raw %}
  ```bash
  $ curl --header 'Content-Type: application/json' --header 'Accept: application/json' -d@/home/Configfiles/dashboards/DockerMetricsperContainer.json  http://localhost:3000/api/dashboards/db -u {{ grafana_user }}:{{ grafana_passwd }}
  ```
  {% endraw %}

- create JVM dashboard in grafana using jsonfile

  {% raw %}
  ```bash
  $ curl --header 'Content-Type: application/json' --header 'Accept: application/json' -d@/home/Configfiles/dashboards/jvm-metrics-jolokia-2_rev1.json  http://localhost:3000/api/dashboards/db -u {{ grafana_user }}:{{ grafana_passwd }}
  ```
  {% endraw %}
