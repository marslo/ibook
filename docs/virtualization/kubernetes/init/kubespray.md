<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [python3](#python3)
- [ansible install](#ansible-install)
- [kubespray](#kubespray)
  - [modify configuration](#modify-configuration)
  - [install requirements](#install-requirements)
  - [reset](#reset)
  - [deploy](#deploy)
- [addons](#addons)
  - [grafana](#grafana)
  - [kubernetes-dashboard](#kubernetes-dashboard)
- [tips](#tips)
  - [CRIO](#crio)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [kubernetes-sigs/kubespray](https://github.com/kubernetes-sigs/kubespray) | [kubespray.io](https://kubespray.io/)
> - [Quick Start](https://kubespray.io/#/?id=quick-start)

## python3

```bash
$ sudo dnf install -y python3.12
$ sudo update-alternatives --config python3
$ python3 < <(curl -s https://bootstrap.pypa.io/get-pip.py)
$ python3 -m pip install --upgrade pip
```

## ansible install
```bash
$ python3 -m pip install pipx
$ pipx install ansible --include-deps
```

## kubespray

### modify configuration
```bash
$ declare -a IPS=(10.68.78.221 10.68.78.222 10.68.78.223)
$ CONFIG_FILE=inventory/sms-k8s/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

### install requirements

- using container
  ```bash
  $ TAG_NAME='v2.26.0'
  $ git clone --branch "${TAG_NAME}" https://github.com/kubernetes-sigs/kubespray.git kubespray-${TAG_NAME}
  $ docker pull quay.io/kubespray/kubespray:${TAG_NAME}

  $ cp -r sms-k8s ~/kubespary-${TAG_NAME}/inventory/
  $ docker run --rm -it --mount type=bind,source="$(pwd)"/kubespray-${TAG_NAME}/inventory/sms-k8s,dst=/kubespray/inventory/sms-k8s \
           --mount type=bind,source="${HOME}"/.ssh/sms-k8s-apiservers,dst=/root/.ssh/sms-k8s-apiservers \
           quay.io/kubespray/kubespray:${TAG_NAME} bash
  ```

- using local environment
  ```bash
  $ python3 -m venv ~/.venv/kubespray
  $ source ~/.venv/kubespray/bin/activate

  $ python3 -m pip install -U -r requirements.txt
  $ python3 -m pip install ruamel.yaml selinux
  ```

### reset
```bash
$ ansible-playbook -i inventory/sms-k8s/hosts.yaml \
                   --become --become-user=root \
                   --private-key /root/.ssh/sms-k8s-apiservers \
                   reset.yml -v
```

### deploy
```bash
$ ansible-playbook -i inventory/sms-k8s/hosts.yaml \
                   --become --become-user=root \
                   --private-key /root/.ssh/sms-k8s-apiservers \
                   cluster.yml -v
```

## addons
### grafana
```bash
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo list
NAME                    URL
kubernetes-dashboard    https://kubernetes.github.io/dashboard/
ingress-nginx           https://kubernetes.github.io/ingress-nginx
grafana                 https://grafana.github.io/helm-charts

$ helm repo update
$ helm search repo grafana/grafana

$ helm install grafana grafana/grafana --namespace monitoring --create-namespace
```

### kubernetes-dashboard

> [!NOTE|label:references:]
> - [Configure Kubernetes Dashboard Web UI hosted with Nginx Ingress Controller](https://gist.github.com/s-lyn/3aba97628c922ddc4a9796ac31a6df2d)

#### ingress for kubernetes-dashboard
```bash
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubernetes-dashboard
  namespace: kube-system
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/secure-backends: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - sms-k8s-dashboard.sample.com
    secretName: sample-tls
  rules:
    - host: sms-k8s-dashboard.sample.com
      http:
        paths:
        - path: /
          backend:
            service:
              # or kubernetes-dashboard-kong-proxy for latest version
              name: kubernetes-dashboard
              port:
                number: 443
          pathType: Prefix
```

#### RBAC
- clusterrole
  ```bash
  $ kubectl get clusterrole kubernetes-dashboard -o yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRole
  metadata:
    labels:
      k8s-app: kubernetes-dashboard
    name: kubernetes-dashboard
  rules:
  - apiGroups:
    - '*'
    resources:
    - '*'
    verbs:
    - '*'
  ```

- clusterrolebinding
  ```bash
  $ kubectl -n kube-system get clusterrolebindings kubernetes-dashboard -o yaml
  apiVersion: rbac.authorization.k8s.io/v1
  kind: ClusterRoleBinding
  metadata:
    name: kubernetes-dashboard
  roleRef:
    apiGroup: rbac.authorization.k8s.io
    kind: ClusterRole
    name: kubernetes-dashboard
  subjects:
  - kind: ServiceAccount
    name: kubernetes-dashboard
    namespace: kube-system
  ```

- serviceaccount
  ```bash
  $ kubectl -n kube-system get sa kubernetes-dashboard -o yaml
  apiVersion: v1
  kind: ServiceAccount
  metadata:
    labels:
      k8s-app: kubernetes-dashboard
    name: kubernetes-dashboard
    namespace: kube-system
  ```

- generate token
  ```bash
  $ kubectl -n kube-system create token kubernetes-dashboard
  ey**********************WAA
  ```


## tips
### CRIO
- `roles/kubernetes/preinstall/tasks/0080-system-configurations.yml`:

  > [!NOTE|label:references:]
  > - [#502 - Module 'selinux' has no attribute 'selinux_getpolicytype' on Oracle Linux 9](https://github.com/ansible-collections/ansible.posix/issues/502)
  > - [#10517 - setup module fails with AttributeError: 'module' object has no attribute 'selinux_getpolicytype' in get_selinux_facts on Fedora Stream 8](https://github.com/kubernetes-sigs/kubespray/issues/10517)
  >   ```bash
  >   The error was: AttributeError: module 'selinux' has no attribute 'selinux_getpolicytype'
  >   ```
  > - more info:
  >   ```bash
  >   $ rpm -ql python3-libselinux
  >   /usr/lib/.build-id
  >   /usr/lib/.build-id/36
  >   /usr/lib/.build-id/36/8611e651689a4ddfd849f50dedd4017bedc3fd
  >   /usr/lib/.build-id/c3
  >   /usr/lib/.build-id/c3/a51291a679339cfe9afdd4c61ba80d88bf8f1e
  >   /usr/lib64/python3.6/site-packages/_selinux.cpython-36m-x86_64-linux-gnu.so
  >   /usr/lib64/python3.6/site-packages/selinux
  >   /usr/lib64/python3.6/site-packages/selinux-2.9-py3.6.egg-info
  >   /usr/lib64/python3.6/site-packages/selinux/__init__.py
  >   /usr/lib64/python3.6/site-packages/selinux/__pycache__
  >   /usr/lib64/python3.6/site-packages/selinux/__pycache__/__init__.cpython-36.opt-1.pyc
  >   /usr/lib64/python3.6/site-packages/selinux/__pycache__/__init__.cpython-36.pyc
  >   /usr/lib64/python3.6/site-packages/selinux/audit2why.cpython-36m-x86_64-linux-gnu.so
  >   ```

  - remove task `Set selinux policy`
    {% raw %}
    ```bash
    14   - name: Set selinux policy
    15     ansible.posix.selinux:
    16       policy: targeted
    17       state: "{{ preinstall_selinux_state }}"
    18     when:
    19       - ansible_os_family == "RedHat"
    20       - "'Amazon' not in ansible_distribution"
    21       - slc.stat.exists
    22     tags:
    23       - bootstrap-os
    ```
    {% endraw %}

  -  [another solution](https://github.com/kubernetes-sigs/kubespray/issues/10517#issuecomment-2155869733)

- `/usr/local/bin/crictl` cannot be found
  - `all/all.yaml`
    ```bash
    bin_dir: /usr/bin
    ```

  - or mapping crictl
    ```bash
    # in all control nodes
    $ sudo ln -s /usr/bin/crictl /usr/local/bin/crictl
    ```

- `roles/kubernetes/node/tasks/facts.yml`
  - original:
    {% raw %}
    ```yaml
    17   - name: Gather cgroups facts for crio
    18     when: container_manager == 'crio'
    19     block:
    20     - name: Look up crio cgroup driver
    21       shell: "set -o pipefail && {{ bin_dir }}/{{ crio_status_command }} info | grep 'cgroup driver' | awk -F': ' '{ print $2; }'"
    ```
    {% endraw %}

  - modify to:
    ```yaml
    17   - name: Gather cgroups facts for crio
    18     when: container_manager == 'crio'
    19     block:
    20     - name: Look up crio cgroup driver
    21       shell: "set -o pipefail && sudo systemctl start crio; /usr/bin/crio status info | grep 'cgroup driver' | awk -F': ' '{ print $2; }'"
    ```

- `roles/download/tasks/download_container.yml`:

  - delete task `Download_container | Download image if required`
    {% raw %}
    ```bash
    57       - name: Download_container | Download image if required
    58         command: "{{ image_pull_command_on_localhost if download_localhost else image_pull_command
         }} {{ image_reponame }}"
    59         delegate_to: "{{ download_delegate if download_run_once else inventory_hostname }}"
    60         delegate_facts: true
    61         run_once: "{{ download_run_once }}"
    62         register: pull_task_result
    63         until: pull_task_result is succeeded
    64         delay: "{{ retry_stagger | random + 3 }}"
    65         retries: "{{ download_retries }}"
    66         become: "{{ user_can_become_root | default(false) or not download_localhost }}"
    67         environment: "{{ proxy_env if container_manager == 'containerd' else omit }}"
    68         when:
    69           - pull_required or download_run_once
    70           - not image_is_cached
    ```
    {% endraw %}
