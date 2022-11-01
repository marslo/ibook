<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [grafana](#grafana)
  - [environment](#environment)
  - [setup](#setup)
  - [dashboard](#dashboard)
  - [grafana settings](#grafana-settings)
  - [api](#api)
- [code pool](#code-pool)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## grafana

{% hint style='tip' %}
> references:
> - [* Setting Up Kubernetes Dashboard](https://www.youtube.com/watch?v=aB0TagEzTAw)
> - [* Deploy Grafana Enterprise on Kubernetes](https://grafana.com/docs/grafana/latest/installation/kubernetes/#deploy-grafana-enterprise-on-kubernetes)
> - [* Deploy Grafana on Kubernetes](https://grafana.com/docs/grafana/latest/installation/kubernetes/)
> - [* Kubernetes Integration](https://grafana.com/docs/grafana-cloud/kubernetes/integration-kubernetes/?pg=blog&plcmt=body-txt)
> - [* Install plugin from dockerfile](https://community.grafana.com/t/install-plugin-from-dockerfile/2603/5)
> - [* grafana/grafana-docker](https://github.com/grafana/grafana-docker/blob/master/Dockerfile)
> - [Scaling out Grafana with Kubernetes and AWS](https://medium.com/@fcgravalos/scaling-out-grafana-with-kubernetes-and-aws-62745257df10)
> - [How To Setup Grafana On Kubernetes](https://devopscube.com/setup-grafana-kubernetes/)
> - [Monitoring Kubernetes Clusters with Grafana](https://medium.com/htc-research-engineering-blog/monitoring-kubernetes-clusters-with-grafana-e2a413febefd)
> - [Configure a Grafana Docker image](https://grafana.com/docs/grafana/latest/administration/configure-docker/)
> - [Configure Grafana](https://grafana.com/docs/grafana/next/setup-grafana/configure-grafana/#configure-with-environment-variables)
> - [Grafana 6.2 documentation : Installing using Docker](https://www.bookstack.cn/read/grafana-v6.2/f54c77073729e6c9.md)
> - [Restart Grafana](https://grafana.com/docs/grafana/latest/installation/restart-grafana/)
> - [Grafana Loki Concise Tutorial](https://www.sobyte.net/post/2021-10/grafana-loki-usage/)
> - [Grafana CLI](https://grafana.com/docs/grafana/latest/administration/cli)
> - [* Prometheus data source](https://grafana.com/docs/grafana/latest/datasources/prometheus/)
> - [* GRAFANA SUPPORT FOR PROMETHEUS](https://prometheus.io/docs/visualization/grafana/)
> - [* Create Grafana Dashboards with Prometheus Metrics](https://www.programmingwithwolfgang.com/create-grafana-dashboards-with-prometheus-metrics)
{% endhint %}


### environment

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

```bash
# for pvc
kubems-01 ~ $ mkdir -p /opt/grafana/plugins
kubems-01 ~ $ sudo chown -R 472:472 $_

# https://grafana.com/docs/grafana/latest/installation/docker/#migration-from-a-previous-version-of-the-docker-container-to-5-1-or-later
# 104:104 for version < 5.1
```

- [user id changes](https://grafana.com/docs/grafana/latest/installation/docker/#user-id-changes)


  |  Version |   User  | User ID |
  |:--------:|:-------:|:-------:|
  |  `< 5.1` | grafana |  `104`  |
  | `>= 5.1` | grafana |  `472`  |


- path


  | SETTING                 | DEFAULT VALUE               |
  |-------------------------|-----------------------------|
  | `GF_PATHS_CONFIG`       | `/etc/grafana/grafana.ini`  |
  | `GF_PATHS_DATA`         | `/var/lib/grafana`          |
  | `GF_PATHS_HOME`         | `/usr/share/grafana`        |
  | `GF_PATHS_LOGS`         | `/var/log/grafana`          |
  | `GF_PATHS_PLUGINS`      | `/var/lib/grafana/plugins`  |
  | `GF_PATHS_PROVISIONING` | `/etc/grafana/provisioning` |


- environment


  | ENVIRONMENT VARIABLE         | EXAMPLE                                                                  |
  |------------------------------|--------------------------------------------------------------------------|
  | `GF_INSTALL_PLUGINS`         | `grafana-kubernetes-app,grafana-piechart-panel,http://my.com/plugin.zip` |
  | `GF_PATHS_PLUGINS`           | `/data/grafana/plugins`                                                  |
  | `GF_SERVER_ROOT_URL`         | `https://my.grafana.com`                                                 |
  | `GF_SECURITY_ADMIN_PASSWORD` | `admin`                                                                  |
  | `GF_DEFAULT_INSTANCE_NAME`   | -                                                                        |
  | `GF_SECURITY_ADMIN_USER`     | -                                                                        |
  | `GF_DATABASE_TYPE`           | `mysql`                                                                  |
  | `GF_DATABASE_HOST`           | -                                                                        |


### setup
- ns
  ```bash
  $ cat << EOF | kubectl apply -f -
  ---
  kind: Namespace
  apiVersion: v1
  metadata:
    name: kubernetes-dashboard
    labels:
      name: kubernetes-dashboard
  EOF
  ```

- sa
  ```bash
  $ cat << EOF | kubectl apply -f -
  ---
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    labels:
      k8s-app: grafana
    name: grafana-admin
    namespace: kubernetes-dashboard
  ---
  apiVersion: rbac.authorization.k8s.io/v1beta1
  kind: ClusterRoleBinding
  metadata:
    name: grafana-admin
    labels:
      k8s-app: grafana
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: cluster-admin
  subjects:
  - kind: ServiceAccount
    name: grafana
    namespace: kubernetes-dashboard
  EOF
  ```

- pv & pvc
  ```bash
  $ cat << EOF | kubectl apply -f -
  ---
  kind: PersistentVolume
  apiVersion: v1
  metadata:
    name: grafana
    labels:
      type: local
  spec:
    storageClassName: manual
    capacity:
      storage: 2Gi
    accessModes:
      - ReadWriteMany
    hostPath:
      path: "/opt/grafana"
  ---
  kind: PersistentVolumeClaim
  apiVersion: v1
  metadata:
    name: grafana
    namespace: kubernetes-dashboard
  spec:
    accessModes:
    - ReadWriteMany
    resources:
      requests:
        storage: 2Gi
    storageClassName: "manual"
    volumeName: grafana
  EOF
  ```

- deploy
  ```bash
  $ cat << EOF | kubectl apply -f -
  ---
  apiVersion: extensions/v1beta1
  kind: Deployment
  metadata:
    name: grafana
    namespace: kubernetes-dashboard
    labels:
      app: grafana
      component: core
  spec:
    replicas: 1
    strategy:
      rollingUpdate:
        maxSurge: 25%
        maxUnavailable: 25%
      type: RollingUpdate
    template:
      metadata:
        labels:
          app: grafana
          component: core
      spec:
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: kubernetes.io/hostname
                  operator: In
                  values:
                  - kubems-01
        containers:
        - image: grafana/grafana
          name: grafana
          imagePullPolicy: IfNotPresent
          resources:
            # keep request = limit to keep this container in guaranteed class
            limits:
              cpu: 512m
              memory: 512Mi
            requests:
              cpu: 256m
              memory: 256Mi
          env:
            # The following env variables set up basic auth twith the default admin user and admin password.
            - name: GF_SERVER_DOMAIN
              value: "grafana.marslo.com"
            - name: GF_SECURITY_ADMIN_PASSWORD
              value: "mypasswd"
            - name: GF_INSTALL_PLUGINS
              value: "grafana-kubernetes-app"
            - name: GF_SERVER_ROOT_URL
              value: "/"
            - name: GF_AUTH_BASIC_ENABLED
              value: "true"
            - name: GF_AUTH_ANONYMOUS_ENABLED
              value: "false"
          readinessProbe:
            httpGet:
              path: /login
              port: 3000
          volumeMounts:
          - name: grafana-persistent-storage
            mountPath: /var/lib/grafana
        restartPolicy: Always
        terminationGracePeriodSeconds: 30
        serviceAccountName: grafana
        volumes:
        - name: grafana-persistent-storage
          persistentVolumeClaim:
            claimName: grafana
  EOF
  ```

- svc
  ```bash
  $ cat << EOF | kubectl apply -f -
  ---
  apiVersion: v1
  kind: Service
  metadata:
    name: grafana
    namespace: kubernetes-dashboard
    labels:
      app: grafana
      component: core
  spec:
    type: CluslterIP
    ports:
      - name: http
        port: 3000
        protocol: TCP
    selector:
      app: grafana
      component: core
  EOF
  ```

- ingress
  ```bash
  $ cat << EOF | kubectl apply -f -
  apiVersion: extensions/v1beta1
  kind: Ingress
  metadata:
    name: grafana
    namespace: kubernetes-dashboard
  spec:
    rules:
    - host: grafana.marslo.com
     http:
       paths:
       - path: /
         backend:
          serviceName: grafana
          servicePort: http
    tls:
    - hosts:
      - grafana.marslo.com
      secretName: marslo-cert
  EOF
  ```

### dashboard

#### kubernetes cluster monitoring
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
  - setup
    ```bash
    $ cat ~/.kube/config | grep certificate-authority-data | awk '{print $2}' | base64 -d
    $ cat ~/.kube/config | grep client-certificate-data | awk '{print $2}' | base64 -d
    $ cat ~/.kube/config | grep client-key-data | awk '{print $2}' | base64 -d
    ```

![grafana-plugin-1.gif](../../screenshot/k8s/grafana-plugin-1.gif)



{% hint style='tip' %}
> references:
> - [Dashboards](https://grafana.com/grafana/dashboards/)
> - [Monitor Kubernetes easily with Grafana](https://grafana.com/solutions/kubernetes/monitor/?pg=dashboards&plcmt=featured-dashboard-1)
> - [Export and import](https://grafana.com/docs/grafana/v7.5/dashboards/export-import/#export-and-import)
> - [Create Grafana Dashboards with Prometheus Metrics](https://www.programmingwithwolfgang.com/create-grafana-dashboards-with-prometheus-metrics)
{% endhint %}

#### cluster
- [*`315` - Kubernetes cluster monitoring (via Prometheus)](https://grafana.com/grafana/dashboards/315-kubernetes-cluster-monitoring-via-prometheus/)

  ![grafana-315.gif](../../screenshot/k8s/grafana-315.gif)

- [*`8588` - Kubernetes Deployment Statefulset Daemonset metrics](https://grafana.com/grafana/dashboards/8588)
- [`6417` - Kubernetes Cluster (Prometheus)](https://grafana.com/grafana/dashboards/6417)
- [`3662` - Prometheus 2.0 Overview](https://grafana.com/grafana/dashboards/3662)


#### node
- [*`1860` - Node Exporter Full](https://grafana.com/grafana/dashboards/1860)
- [*`6287` - Host Overview](https://grafana.com/grafana/dashboards/6287)
- [*`10242` - Node Exporter Full with Node Name](https://grafana.com/grafana/dashboards/10242)

#### namespace
- [*`9809` - Kubernetes Namespace Resources](https://grafana.com/grafana/dashboards/9809)

#### pod
- [*`747` - Kubernetes Pod Metrics ](https://grafana.com/grafana/dashboards/747)
- [*`6336` - Kubernetes Pods](https://grafana.com/grafana/dashboards/6336)

#### jenkins
- [`9524` - a Jenkins performance and health overview for jenkinsci/prometheus-plugin](https://grafana.com/grafana/dashboards/9524)
- [`9964` - Jenkins: Performance and Health Overview](https://grafana.com/grafana/dashboards/9964)









### grafana settings

- cluster
  ```
  label_values(kube_pod_info, cluster)
  ```
  - or
    ```
    label_values(node_cpu_seconds_total, cluster)
    ```
- instance
  ```
  label_values(apiserver_request_total{job="apiserver"}, instance)
  ```

- node
  ```
  label_values(kube_node_info{cluster="$cluster"}, node)
  ```
  - or
    ```
    label_values(kubernetes_io_hostname)
    ```

- namespace
  ```
  label_values(kube_pod_info{cluster="$cluster"}, namespace)
  ```

- pod
  ```
  label_values(kube_pod_info{cluster="$cluster", namespace="$namespace"}, pod)
  ```

### api

> references:
> - [Grafana Docker and data persistence](https://community.grafana.com/t/grafana-docker-and-data-persistence/33702/2)

#### [reset password](https://grafana.com/docs/grafana/latest/administration/cli/)
```bash
$ curl -X PUT -H "Content-Type: application/json" -d '{
  "oldPassword": "admin",
  "newPassword": "newpass",
  "confirmNew": "newpass"
}' http://admin:admin@<your_grafana_host>:3000/api/user/password
```

#### set grafana admin password
{% raw %}
```bash
$ docker exec -t grafana \
              bash -c 'grafana-cli --homepath /usr/share/grafana admin reset-admin-password "{{ grafana_passwd }}"'
```
{% endraw %}

#### check if grafana can be accessed
{% raw %}
```bash
$ curl -s http://localhost:3000/api/org \
       -u {{ grafana_user }}:{{ grafana_passwd }}
```
{% endraw %}

#### create datasoure in grafana
{% raw %}
```bash
$ curl -L \
       --header 'Content-Type: application/json' \
       --header 'Accept: application/json' \
       -d@//docker_data/grafana_conf/grafanacfg.output http://localhost:3000/api/datasources \
       -u {{ grafana_user }}:{{ grafana_passwd }}
```
{% endraw %}

#### create TelegrafHost dashboard in grafana using jsonfile
{% raw %}
```bash
$ curl -L \
       --header 'Content-Type: application/json' \
       --header 'Accept: application/json' \
       -d@/home/Configfiles/dashboards/TelegrafHostMetrics.json http://localhost:3000/api/dashboards/db \
       -u {{ grafana_user }}:{{ grafana_passwd }}
```
{% endraw %}

#### create DockerMetrics dashboard in grafana using jsonfile
{% raw %}
```bash
$ curl --header 'Content-Type: application/json' \
       --header 'Accept: application/json' \
       -d@/home/Configfiles/dashboards/DockerMetricsperContainer.json http://localhost:3000/api/dashboards/db \
       -u {{ grafana_user }}:{{ grafana_passwd }}
```
{% endraw %}

#### create JVM dashboard in grafana using jsonfile
{% raw %}
```bash
$ curl --header 'Content-Type: application/json' \
       --header 'Accept: application/json' \
       -d@/home/Configfiles/dashboards/jvm-metrics-jolokia-2_rev1.json http://localhost:3000/api/dashboards/db \
       -u {{ grafana_user }}:{{ grafana_passwd }}
```
{% endraw %}


## code pool
- [kubeless/manifests/monitoring](https://github.com/kubeless/kubeless/tree/master/manifests/monitoring)
- [kube-prometheus/manifests](https://github.com/coreos/kube-prometheus/tree/master/manifests)
- [kubernetes-handbook/manifests/prometheus](https://github.com/rootsongjc/kubernetes-handbook/tree/master/manifests/prometheus)
