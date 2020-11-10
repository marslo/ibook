<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Grafana](#grafana)
  - [reset password](#reset-password)
  - [Environment](#environment)
  - [Setup](#setup)
  - [configure](#configure)
- [Reference](#reference)
- [Code Pool](#code-pool)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Grafana

### [reset password](https://grafana.com/docs/grafana/latest/administration/cli/)
```bash
$ curl -X PUT -H "Content-Type: application/json" -d '{
  "oldPassword": "admin",
  "newPassword": "newpass",
  "confirmNew": "newpass"
}' http://admin:admin@<your_grafana_host>:3000/api/user/password
```

### Environment
```bash
# for pvc
kubems-01 ~ $ mkdir -p /opt/grafana/plugins
kubems-01 ~ $ sudo chwon -R 472:472 $_

# https://grafana.com/docs/grafana/latest/installation/docker/#migration-from-a-previous-version-of-the-docker-container-to-5-1-or-later
# 104:104 for version < 5.1
```
- [User ID changes](https://grafana.com/docs/grafana/latest/installation/docker/#user-id-changes)

|  Version |   User  | User ID |
|:--------:|:-------:|:-------:|
|  `< 5.1` | grafana |  `104`  |
| `>= 5.1` | grafana |  `472`  |


### Setup
- ns
    ```bash
    $ cat << EOF | k apply -f -
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
    $ cat << EOF | k apply -f -
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
    $ cat << EOF | k apply -f -
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
    $ cat << EOF | k apply -f -
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
    $ cat << EOF | k apply -f -
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
- ing
    ```bash
    $ cat << EOF | k apply -f -
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

### configure
#### `grafana-kubernetes-app`

```bash
$ cat ~/.kube/config | grep certificate-authority-data | awk '{print $2}' | base64 -d
$ cat ~/.kube/config | grep client-certificate-data | awk '{print $2}' | base64 -d
$ cat ~/.kube/config | grep client-key-data | awk '{print $2}' | base64 -d
```

![grafana-plugin-1.gif](../screenshot/grafana-plugin-1.gif)
![grafana-plugin-2.gif](../screenshot/grafana-plugin-2.gif)

#### dashboard (315)

![grafana-315.gif](../screenshot/grafana-315.gif)

## Reference
- [Scaling out Grafana with Kubernetes and AWS](https://medium.com/@fcgravalos/scaling-out-grafana-with-kubernetes-and-aws-62745257df10)
- [How To Setup Grafana On Kubernetes](https://devopscube.com/setup-grafana-kubernetes/)
- [Monitoring Kubernetes Clusters with Grafana](https://medium.com/htc-research-engineering-blog/monitoring-kubernetes-clusters-with-grafana-e2a413febefd)

## Code Pool
- [kubeless/manifests/monitoring](https://github.com/kubeless/kubeless/tree/master/manifests/monitoring)
- [kube-prometheus/manifests](https://github.com/coreos/kube-prometheus/tree/master/manifests)
- [kubernetes-handbook/manifests/prometheus](https://github.com/rootsongjc/kubernetes-handbook/tree/master/manifests/prometheus)
