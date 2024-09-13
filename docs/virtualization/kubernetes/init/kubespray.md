<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [kubespray](#kubespray)
  - [requirements](#requirements)
    - [setup ssh key to root user](#setup-ssh-key-to-root-user)
    - [modify inventory](#modify-inventory)
    - [using container](#using-container)
    - [using local environment](#using-local-environment)
  - [execute ansible playbook](#execute-ansible-playbook)
    - [reset](#reset)
    - [deploy](#deploy)
    - [add nodes](#add-nodes)
    - [remove nodes](#remove-nodes)
    - [upgrade cluster](#upgrade-cluster)
- [addons](#addons)
  - [grafana](#grafana)
- [tips](#tips)
  - [CRIO](#crio)
  - [manual remove kubernetes-dashboard](#manual-remove-kubernetes-dashboard)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [kubernetes-sigs/kubespray](https://github.com/kubernetes-sigs/kubespray) | [kubespray.io](https://kubespray.io/)
> - [Quick Start](https://kubespray.io/#/?id=quick-start)

# kubespray

> [!NOTE|label:references:]
> - variables:
>   ```bash
>   $ VERSION='v2.26.0'
>   $ INVENTORY_DIR='sms-k8s'
>   $ SSH_KEY_NAME='sms-k8s'
>   ```

## requirements
### setup ssh key to root user
```bash
$ ssh-keygen -t ed25519 -C "${SSH_KEY_NAME}" -f ~/.ssh/"${SSH_KEY_NAME}" -P ''

# copy to remote servers
$ echo {01..05} | fmt -1 | while read -r _id; do
    ssh root@k8s-${_id} "[[ -d /root/.ssh ]] || mkdir -p /root/.ssh; chmod 700 /root/.ssh; [[ -f /root/.ssh/authorized_keys ]] || touch /root/.ssh/authorized_keys; chmod 600 /root/.ssh/authorized_keys"
    ssh root@k8s-${_id} "cat >> /root/.ssh/authorized_keys" < ~/.ssh/"${SSH_KEY_NAME}".pub
  done

# verify
$ ssh -vT -i ~/.ssh/"${SSH_KEY_NAME}" root@k8s-01
```

### modify inventory
```bash
$ git clone --branch "${VERSION}" https://github.com/kubernetes-sigs/kubespray.git kubespray-${VERSION}

# setup hosts.yaml
$ declare -a IPS=(10.68.78.221 10.68.78.222 10.68.78.223)
$ CONFIG_FILE=inventory/"${INVENTORY_DIR}"/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
```

### using container
```bash
# same version with kubespray ansbile playbook
$ docker pull quay.io/kubespray/kubespray:${VERSION}

$ cp -r ${INVENTORY_DIR} ~/kubespary-${VERSION}/inventory/
$ docker run --rm -it \
         --mount type=bind,source="$(pwd)"/kubespray-${VERSION}/inventory/${INVENTORY_DIR},dst=/kubespray/inventory/${INVENTORY_DIR} \
         --mount type=bind,source="${HOME}"/.ssh/${SSH_KEY_NAME},dst=/kubespray/inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
         quay.io/kubespray/kubespray:${VERSION} \
         bash

# inside container
$ ansible-playbook -i inventory/${INVENTORY_DIR}/hosts.yaml \
                   --become --become-user=root \
                   --private-key /kubespray/inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
                   <ACTION>.yml --flush-cache -v
```

### using local environment

- python3
  ```bash
  $ sudo dnf install -y python3.12
  $ sudo update-alternatives --config python3
  $ python3 < <(curl -s https://bootstrap.pypa.io/get-pip.py)
  $ python3 -m pip install --upgrade pip
  ```

- ansible install
  ```bash
  $ python3 -m pip install pipx
  $ pipx install ansible --include-deps
  ```

  ```bash
  # venv
  $ python3 -m venv ~/.venv/kubespray
  $ source ~/.venv/kubespray/bin/activate

  # install requirements
  $ python3 -m pip install -U -r requirements.txt
  $ python3 -m pip isntall -U -r contrib/inventory_builder/requirements.txt
  $ python3 -m pip install selinux
  ```

## execute ansible playbook
### reset
```bash
$ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                   --become --become-user=root \
                   --private-key inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
                   reset.yml --flush-cache -v
```

### deploy
```bash
$ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                   --become --become-user=root \
                   --private-key inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
                   cluster.yml --flush-cache -v

# running in k8s control plane
$ [[ -d $HOME/.kube ]] && rm -rf $HOME/.kube
$ mkdir -p $HOME/.kube
$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

<!--sec data-title="steps" data-id="section0" data-show=true data-collapse=true ces-->
```bash
PLAY RECAP *********************************************************************************************************************************
k8s-01              : ok=664  changed=104  unreachable=0    failed=0    skipped=1075 rescued=0    ignored=5
k8s-02              : ok=565  changed=90   unreachable=0    failed=0    skipped=952  rescued=0    ignored=2
k8s-03              : ok=567  changed=93   unreachable=0    failed=0    skipped=950  rescued=0    ignored=2
k8s-04              : ok=403  changed=50   unreachable=0    failed=0    skipped=622  rescued=0    ignored=0
k8s-05              : ok=403  changed=50   unreachable=0    failed=0    skipped=618  rescued=0    ignored=0

Friday 13 September 2024  02:36:27 +0000 (0:00:00.283)       3:06:50.832 ******
===============================================================================
etcd : Gen_certs | Write etcd member/admin and kube_control_plane client certs to other etcd nodes ------------------------------- 1412.84s
/kubespray/roles/etcd/tasks/gen_certs_script.yml:87 ---------------------------------------------------------------------------------------
kubernetes-apps/ingress_controller/ingress_nginx : NGINX Ingress Controller | Create manifests ------------------------------------ 779.09s
/kubespray/roles/kubernetes-apps/ingress_controller/ingress_nginx/tasks/main.yml:49 -------------------------------------------------------
kubernetes-apps/ansible : Kubernetes Apps | Lay Down CoreDNS templates ------------------------------------------------------------ 778.89s
/kubespray/roles/kubernetes-apps/ansible/tasks/coredns.yml:2 ------------------------------------------------------------------------------
network_plugin/calico : Calico | Create calico manifests -------------------------------------------------------------------------- 424.96s
/kubespray/roles/network_plugin/calico/tasks/install.yml:371 ------------------------------------------------------------------------------
policy_controller/calico : Create calico-kube-controllers manifests --------------------------------------------------------------- 280.41s
/kubespray/roles/kubernetes-apps/policy_controller/calico/tasks/main.yml:2 ----------------------------------------------------------------
etcd : Gen_certs | Gather etcd member/admin and kube_control_plane client certs from first etcd node ------------------------------ 210.21s
/kubespray/roles/etcd/tasks/gen_certs_script.yml:63 ---------------------------------------------------------------------------------------
kubernetes/control-plane : Joining control plane node to the cluster. ------------------------------------------------------------- 128.20s
/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-secondary.yml:86 ------------------------------------------------------------------
kubernetes-apps/ingress_controller/ingress_nginx : NGINX Ingress Controller | Apply manifests ------------------------------------- 113.23s
/kubespray/roles/kubernetes-apps/ingress_controller/ingress_nginx/tasks/main.yml:59 -------------------------------------------------------
etcdctl_etcdutl : Copy etcdctl and etcdutl binary from download dir ---------------------------------------------------------------- 81.16s
/kubespray/roles/etcdctl_etcdutl/tasks/main.yml:30 ----------------------------------------------------------------------------------------
kubernetes/control-plane : Kubeadm | Initialize first master ----------------------------------------------------------------------- 73.56s
/kubespray/roles/kubernetes/control-plane/tasks/kubeadm-setup.yml:192 ---------------------------------------------------------------------
kubernetes/control-plane : Install script to renew K8S control plane certificates -------------------------------------------------- 70.95s
/kubespray/roles/kubernetes/control-plane/tasks/main.yml:100 ------------------------------------------------------------------------------
container-engine/nerdctl : Nerdctl | Install nerdctl configuration ----------------------------------------------------------------- 70.88s
/kubespray/roles/container-engine/nerdctl/tasks/main.yml:29 -------------------------------------------------------------------------------
container-engine/crictl : Install crictl config ------------------------------------------------------------------------------------ 70.86s
/kubespray/roles/container-engine/crictl/tasks/crictl.yml:7 -------------------------------------------------------------------------------
etcdctl_etcdutl : Create etcdctl wrapper script ------------------------------------------------------------------------------------ 70.85s
/kubespray/roles/etcdctl_etcdutl/tasks/main.yml:41 ----------------------------------------------------------------------------------------
kubernetes/node : Write kubelet systemd init file ---------------------------------------------------------------------------------- 70.83s
/kubespray/roles/kubernetes/node/tasks/kubelet.yml:31 -------------------------------------------------------------------------------------
kubernetes/preinstall : NetworkManager | Prevent NetworkManager from managing Calico interfaces (cali*/tunl*/vxlan.calico) --------- 70.82s
/kubespray/roles/kubernetes/preinstall/tasks/0062-networkmanager-unmanaged-devices.yml:8 --------------------------------------------------
kubernetes/preinstall : NetworkManager | Prevent NetworkManager from managing K8S interfaces (kube-ipvs0/nodelocaldns) ------------- 70.82s
/kubespray/roles/kubernetes/preinstall/tasks/0062-networkmanager-unmanaged-devices.yml:21 -------------------------------------------------
kubernetes-apps/cluster_roles : Kubernetes Apps | Add ClusterRoleBinding to admit nodes -------------------------------------------- 70.81s
/kubespray/roles/kubernetes-apps/cluster_roles/tasks/main.yml:14 --------------------------------------------------------------------------
etcd : Configure | Copy etcd.service systemd file ---------------------------------------------------------------------------------- 70.79s
/kubespray/roles/etcd/tasks/configure.yml:48 ----------------------------------------------------------------------------------------------
etcd : Gen_certs | write openssl config -------------------------------------------------------------------------------------------- 70.78s
/kubespray/roles/etcd/tasks/gen_certs_script.yml:20 ---------------------------------------------------------------------------------------
```
<!--endsec-->

### [add nodes](https://kubespray.io/#/docs/getting_started/getting-started?id=adding-nodes)
```bash
$ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                   --become --become-user=root \
                   --private-key inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
                   scale.yml --flush-cache -v
```

### [remove nodes](https://kubespray.io/#/docs/getting_started/getting-started?id=remove-nodes)
```bash
$ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                   --become --become-user=root \
                   --private-key inventory/${INVENTORY_DIR}/.ssh/${SSH_KEY_NAME} \
                   --extra-vars "node=nodename,nodename2" \
                   remove-node.yml --flush-cache -v
```

### [upgrade cluster](https://kubespray.io/#/docs/operations/upgrades)
- upgrade kubernetes
  ```bash
  # i.e.: v1.18.10 to v1.19.7
  $ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                     -e kube_version=v1.18.10 -e upgrade_cluster_setup=true \
                     cluster.yml --flush-cache -v
  $ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                     -e kube_version=v1.19.7 -e upgrade_cluster_setup=true \
                     cluster.yml --flush-cache -v
  ```

- gracefully upgrade
  ```bash
  $ ansible-playbook -i inventory/"${INVENTORY_DIR}"/hosts.yaml \
                     -e kube_version=v1.19.7 \
                     upgrade-cluster.yml --flush-cache --become

  # upgrade one node at a time
  $ ansible-playbook -i inventory/sample/hosts.yaml \
                     -e kube_version=v1.20.7 \
                     -e "serial=1" \                         # upgrade one node at a time
                     upgrade-cluster.yml --flush-cache --become
  ```

# addons
## grafana
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

# tips
## CRIO
- `roles/kubernetes/preinstall/tasks/0080-system-configurations.yml`:

  > [!NOTE|label:references:]
  > - [#502 - Module 'selinux' has no attribute 'selinux_getpolicytype' on Oracle Linux 9](https://github.com/ansible-collections/ansible.posix/issues/502)
  > - [#10517 - setup module fails with AttributeError: 'module' object has no attribute 'selinux_getpolicytype' in get_selinux_facts on Fedora Stream 8](https://github.com/kubernetes-sigs/kubespray/issues/10517)
  >   ```bash
  >   The error was: AttributeError: module 'selinux' has no attribute 'selinux_getpolicytype'
  >   ```
  > - more info:
  >   <!--sec data-title="rpm -ql python3-libselinux" data-id="section1" data-show=true data-collapse=true ces-->
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
  >   <!--endsec-->

  - remove task `Set selinux policy` in `roles/kubernetes/preinstall/tasks/0080-system-configurations.yml`
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
    58         command: "{{ image_pull_command_on_localhost if download_localhost else image_pull_command }} {{ image_reponame }}"
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

## manual remove kubernetes-dashboard

> [!NOTE|label:references:]
> - [roles/kubernetes-apps/ansible/templates/dashboard.yml.j2](https://github.com/kubernetes-sigs/kubespray/blob/master/roles/kubernetes-apps/ansible/templates/dashboard.yml.j2)

```bash
$ kubectl -n kubernetes-dashboard delete deploy       kubernetes-metrics-scraper
$ kubectl -n kubernetes-dashboard delete deploy       kubernetes-dashboard
$ kubectl -n kubernetes-dashboard delete service      dashboard-metrics-scraper
$ kubectl -n kubernetes-dashboard delete service      kubernetes-dashboard
$ kubectl -n kubernetes-dashboard delete sa           kubernetes-dashboard
$ kubectl -n kubernetes-dashboard delete rolebindings kubernetes-dashboard
$ kubectl -n kubernetes-dashboard delete role         kubernetes-dashboard
$ kubectl -n kubernetes-dashboard delete cm           kubernetes-dashboard-settings
$ kubectl -n kubernetes-dashboard delete secrets      kubernetes-dashboard-key-holder
$ kubectl -n kubernetes-dashboard delete secrets      kubernetes-dashboard-csrf
$ kubectl -n kubernetes-dashboard delete secrets      kubernetes-dashboard-certs

$ kubectl delete ClusterRoleBinding kubernetes-dashboard
$ kubectl delete ClusterRole        kubernetes-dashboard
```
