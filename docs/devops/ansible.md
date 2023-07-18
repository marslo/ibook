<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [environment](#environment)
  - [install](#install)
  - [upgrade](#upgrade)
  - [completion](#completion)
- [ansible-vault](#ansible-vault)
  - [encrypted files](#encrypted-files)
  - [prompt for the password](#prompt-for-the-password)
  - [reset key](#reset-key)
  - [encrypt](#encrypt)
  - [decrypt](#decrypt)
  - [view](#view)
- [ansible-galaxy](#ansible-galaxy)
- [ansible-playbook](#ansible-playbook)
- [troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Ansible 详解（四）：Ansible-vault](https://zhuanlan.zhihu.com/p/39158667)
> - [Ansible中文权威指南](http://www.ansible.com.cn/index.html)
>   - [Vault](http://www.ansible.com.cn/docs/playbooks_vault.html)
>   - [Playbooks](http://www.ansible.com.cn/docs/playbooks.html)
> - [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)
>   - [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
>   - [Protecting sensitive data with Ansible vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html)
>   - [* Ansible Vault](https://docs.ansible.com/ansible/2.8/user_guide/vault.html)
>   - [Tips and tricks](https://docs.ansible.com/ansible/3/user_guide/playbooks_best_practices.html#tip-for-variables-and-vaults)
>   - [ansible.builtin.template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
> - [10 ansible vault examples to decrypt/encrypt string & files](https://www.golinuxcloud.com/ansible-vault-example-encrypt-string-playbook/)

## environment

```bash
$ sudo dnf install wget yum-utils make gcc openssl-devel bzip2-devel libffi-devel zlib-devel
$ sudo dnf groupinstall 'development tools
$ sudo dnf -y install epel-release
$ sudo dnf install python39
$ sudo update-alternatives --config python
$ sudo update-alternatives --config python3
```

### install
```bash
$ python -m pip install --user ansible
```

- install for development
  ```bash
  $ python -m pip install --user https://github.com/ansible/ansible/archive/devel.tar.gz
  ```

### upgrade
```bash
$ python -m pip install --user --upgrade ansible
```

### [completion](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html#adding-ansible-command-shell-completion)
```bash
$ python -m pip install --user argcomplete
$ cat >> ~/.bashrc << EOF
  command -v ansible > /dev/null && eval $(register-python-argcomplete ansible)
                                 && eval $(register-python-argcomplete ansible-config)
                                 && eval $(register-python-argcomplete ansible-console)
                                 && eval $(register-python-argcomplete ansible-doc)
                                 && eval $(register-python-argcomplete ansible-galaxy)
                                 && eval $(register-python-argcomplete ansible-inventory)
                                 && eval $(register-python-argcomplete ansible-playbook)
                                 && eval $(register-python-argcomplete ansible-pull)
                                 && eval $(register-python-argcomplete ansible-vault)
EOF
```

- [completion.bash](https://github.com/dysosmus/ansible-completion)
  ```bash
  $ mkdir -p ~/.marslo/.completion
  $ git clone git@github.com:dysosmus/ansible-completion.git ~/.marslo/.completion/ansible-completion

  $ cat >> ~/.bashrc << EOF
  [ -d '~/.marslo/.completion/ansible-completion' ] && source <( cat ~/.marslo/.completion/ansible-completion/*.bash )
  EOF
  ```

  - or via `ln`
    ```bash
    $ ls -1 --color=none /path/to/ansible-completion/*.bash |
         xargs -t -I{} bash -c "ln -svf {} /usr/local/share/bash-completion/completions/\$(basename {} | awk -F'.' '{print \$1}')"
    ```

## ansible-vault

> [!NOTE]
> - [Encrypting content with Ansible Vault](https://docs.ansible.com/ansible/3/user_guide/vault.html)

### [encrypted files](https://docs.ansible.com/ansible/3/user_guide/vault.html#creating-encrypted-files)

> [!NOTE|label:references:]
> - [Why should text files end with a newline?](https://stackoverflow.com/q/729692/2940319)
> - [Removing a newline character at the end of a file](https://stackoverflow.com/a/27274234/2940319)
>   ```bash
>   $ truncate -s -1 /path/to/yaml
>   ```
> - [sed solution](https://stackoverflow.com/a/63777386/2940319)
>   ```bash
>   $ sed -z s/.$// pw.txt | od -c
>   0000000   a   b   c
>   0000003
>   ```
> - [printf solution](https://stackoverflow.com/a/12148703/2940319)
>   ```bash
>   $ printf %s "$(< pw.txt)" | od -c
>   0000000   a   b   c
>   0000003
>   ```
>
> - [head solution](https://stackoverflow.com/a/12579554/2940319)
>   ```bash
>   $ head -c -1 pw.txt | od -c
>   0000000   a   b   c  \n   e   f   g
>   0000007
>   ```

```bash
$ truncate -s -1 foo.yml

$ ansible-vault create --vault-id @prompt foo.yml
New vault password (default):
Confirm new vault password (default):

$ cat foo.yml
$ANSIBLE_VAULT;1.1;AES256
65393763393937353538636266646432646265643531343530623436373462633663333234653032
6131396532663939376339306261616637316561343531350a393536353331343837653265383037
30343839316531666530336134623135313535336136653232653533643131303364306265393336
3234366662313332640a613963633766663061643064356530643863373138393039326466333638
3638
```

- create with name
  ```bash
  $ ansible-vault create --vault-id test@prompt foo.yml
  New vault password (test):
  Confirm new vault password (test):

  $ cat foo.yml
  $ANSIBLE_VAULT;1.2;AES256;test
  33303164313336626433376532306266633237333038653931386531616637666637626238346339
  3764383262343066636236626666613562363130636565630a313966376138323931333635333266
  32633330356132626637663534633165356133653639653130303839336338336261316362343065
  3964613438623337630a663735313836353566326333323732303232303864393063646432353463
  3631
  ```

### [prompt for the password](https://docs.ansible.com/ansible/3/user_guide/vault.html#using-vault-id-without-a-vault-id)

> [!TIP]
> via `--vault-id @prompt`
>
> <br>
> - [How to see special characters?](https://www.unix.com/unix-for-dummies-questions-and-answers/151193-how-see-special-characters.html)
> - be aware of the `echo` will automatically appending the `\n` in the end of the line:
>   ```bash
>   $ echo 'abc' | od -c
>   0000000   a   b   c  \n
>   0000004
>   ```
> - with `echo -n`
>   ```bash
>   $ echo -n 'abc' | od -c
>   0000000   a   b   c
>   0000003
>   ```

```bash
$ echo -n 'Test123!' | ansible-vault encrypt_string --vault-id @prompt
New vault password (default):
Confirm new vault password (default):
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)

Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          62306630653236616438653236353135623936626332636337396432346235376364386233363938
          3930663634396138373139643031396433386339353634640a323938323431356330323363353335
          61636134636539326539623665393261643462396239653864313861393761633762313161386464
          3166333136366465370a323765386238646539613438333334633434613533373565326464383836
          6464
```

- or
  ```bash
  $ ansible-vault encrypt_string
  New Vault password:
  Confirm New Vault password:
  Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
  abc^D                          # ctrl-d twice
  Encryption successful
  !vault |
            $ANSIBLE_VAULT;1.1;AES256
            39323234633365393633306135386362373463356636633937336236643763616232383832396333
            3136343265346534306638343738363435393964353262330a313331323161653832656365336331
            36356564653565613664666631346434306366666163393463633030363732336436346364613638
            3038303934366166320a633064326333623062663362343031633065333138313762353534643530
            633
  ```

### reset key
```bash
$ ansible-vault rekey --vault-id @prompt /path/to/file
```

### encrypt
```bash
$ ansible-vault encrypt --vault-id @prompt /path/to/file
```

### decrypt
```bash
$ ansible-vault decrypt --vault-id @prompt /path/to/file
```

### view
```bash
$ ansible-vault view --vault-id @prompt /path/to/file
```

## ansible-galaxy

> [!NOTE|label:references:]
> - [* Kubernetes Collection for Ansible](https://galaxy.ansible.com/kubernetes/core)
>   - [ansible-collections/kubernetes.core](https://github.com/ansible-collections/kubernetes.core)
>   - [kubernetes.core.k8s](https://github.com/ansible-collections/kubernetes.core/blob/main/docs/kubernetes.core.k8s_inventory.rst)
> - [kubernetes.core](https://galaxy.ansible.com/kubernetes/core)
>   - [kubernetes.core.k8s](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/k8s_module.html#ansible-collections-kubernetes-core-k8s-module)
> - [Collections in the Kubernetes Namespace](https://docs.ansible.com/ansible/latest/collections/kubernetes/index.html)
> - [Kubernetes.Core](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/index.html#plugins-in-kubernetes-core)
> - [installing roles and collections from the same requirements.yml file](https://docs.ansible.com/ansible/latest/galaxy/user_guide.html#installing-roles-and-collections-from-the-same-requirements-yml-file)
> - [helm – Manages Kubernetes packages with the Helm package manager](https://docs.ansible.com/ansible/2.9/modules/helm_module.html)
> - [The Inside Playbook](https://www.ansible.com/blog)
>   - [Creating Kubernetes Dynamic Inventories with kubernetes.core Modules](https://www.ansible.com/blog/creating-kubernetes-dynamic-inventories-with-kubernetes.core-modules)
>   - [* Automating Helm using Ansible](https://www.ansible.com/blog/automating-helm-using-ansible)
>   - [k8s_taint](https://www.ansible.com/blog/whats-new-in-the-ansible-content-collection-for-kubernetes-2.3)
>   - [Kubernetes Meets Event-Driven Ansible](https://www.ansible.com/blog/kubernetes-meets-event-driven-ansible)

```bash
$ ansible-galaxy collection install kubernetes.core

# or
$ ansible-galaxy install -r requirements.yml
```

- [example](https://docs.ansible.com/ansible/latest/collections/kubernetes/core/helm_module.html#examples)

  <!--sec data-title="deploy prometheus and grafana via ansbile+helm" data-id="section0" data-show=true data-collapse=true ces-->
  {% raw %}
  ```bash
  - name: Deploy latest version of Prometheus chart inside monitoring namespace (and create it)
    kubernetes.core.helm:
      name: test
      chart_ref: stable/prometheus
      release_namespace: monitoring
      create_namespace: true

  # From repository
  - name: Add stable chart repo
    kubernetes.core.helm_repository:
      name: stable
      repo_url: "https://kubernetes.github.io/ingress-nginx"

  - name: Deploy latest version of Grafana chart inside monitoring namespace with values
    kubernetes.core.helm:
      name: test
      chart_ref: stable/grafana
      release_namespace: monitoring
      values:
        replicas: 2

  - name: Deploy Grafana chart on 5.0.12 with values loaded from template
    kubernetes.core.helm:
      name: test
      chart_ref: stable/grafana
      chart_version: 5.0.12
      values: "{{ lookup('template', 'somefile.yaml') | from_yaml }}"

  - name: Deploy Grafana chart using values files on target
    kubernetes.core.helm:
      name: test
      chart_ref: stable/grafana
      release_namespace: monitoring
      values_files:
        - /path/to/values.yaml

  - name: Remove test release and waiting suppression ending
    kubernetes.core.helm:
      name: test
      state: absent
      wait: true

  - name: Separately update the repository cache
    kubernetes.core.helm:
      name: dummy
      namespace: kube-system
      state: absent
      update_repo_cache: true

  - name: Deploy Grafana chart using set values on target
    kubernetes.core.helm:
      name: test
      chart_ref: stable/grafana
      release_namespace: monitoring
      set_values:
        - value: phase=prod
          value_type: string

  # From git
  - name: Git clone stable repo on HEAD
    ansible.builtin.git:
      repo: "http://github.com/helm/charts.git"
      dest: /tmp/helm_repo

  - name: Deploy Grafana chart from local path
    kubernetes.core.helm:
      name: test
      chart_ref: /tmp/helm_repo/stable/grafana
      release_namespace: monitoring

  # From url
  - name: Deploy Grafana chart on 5.6.0 from url
    kubernetes.core.helm:
      name: test
      chart_ref: "https://github.com/grafana/helm-charts/releases/download/grafana-5.6.0/grafana-5.6.0.tgz"
      release_namespace: monitoring

  # Using complex Values
  - name: Deploy new-relic client chart
    kubernetes.core.helm:
      name: newrelic-bundle
      chart_ref: newrelic/nri-bundle
      release_namespace: default
      force: True
      wait: True
      replace: True
      update_repo_cache: True
      disable_hook: True
      values:
        global:
          licenseKey: "{{ nr_license_key }}"
          cluster: "{{ site_name }}"
        newrelic-infrastructure:
          privileged: True
        ksm:
          enabled: True
        prometheus:
          enabled: True
        kubeEvents:
          enabled: True
        logging:
          enabled: True
  ```
  {% endraw %}
  <!--endsec-->

## ansible-playbook

> [!NOTE|label:references:]
> - [passwordless via environment variables](https://docs.ansible.com/archive/ansible/2.5/user_guide/playbooks_vault.html)

```bash
# without password
$ export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/password.txt
$ ansible-playbook -i hosts /path/to/yaml

# with password
$ ansible-playbook -i hosts /path/to/yaml --vault-id @prompt
```

## troubleshooting
- [generate the final yaml via `ansible.builtin.template`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
  ```yaml
  # in tasks/main.yaml
  - name: Template a file to local
    ansible.builtin.template:
      src: file_in_template.yaml
      dest: /local/path/to/yaml
  ```
