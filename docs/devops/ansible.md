<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

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
  - [tags](#tags)
- [[vault CLI]](#vault-cli)
  - [environment variables](#environment-variables)
  - [kv get](#kv-get)
  - [kv list](#kv-list)
- [ansible-config](#ansible-config)
  - [get all default](#get-all-default)
- [plugin](#plugin)
  - [lookup](#lookup)
  - [Become](#become)
- [troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Ansible中文权威指南](http://www.ansible.com.cn/index.html)
>   - [Vault](http://www.ansible.com.cn/docs/playbooks_vault.html)
>   - [Playbooks](http://www.ansible.com.cn/docs/playbooks.html)
> - [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)
>   - [Installing Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
>   - [Tips and tricks](https://docs.ansible.com/ansible/3/user_guide/playbooks_best_practices.html#tip-for-variables-and-vaults)
>   - [ansible.builtin.template](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
> - [Sample Ansible setup](https://docs.ansible.com/ansible/latest/tips_tricks/sample_setup.html)
> - [How to build your inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html)
> - [* Filters](https://docs.ansible.com/ansible/2.9/user_guide/playbooks_filters.html#filters)
> - [用 Ansible 实现网络自动化](https://linux.cn/article-9964-1.html)

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

# or via pipx
$ python3 -m pip install pipx
$ pipx ensurepath
$ pipx install ansible --include-deps
```

- install for development
  ```bash
  $ python -m pip install --user https://github.com/ansible/ansible/archive/devel.tar.gz
  ```

### upgrade
```bash
$ python -m pip install --user --upgrade ansible

# with pipx
$ pipx upgrade --include-injected ansible
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
> - [* iMarslo : check line ending](../cheatsheet/text-processing/text-processing.html#check-line-ending)
> - [* iMarslo : remove the ending '\n'](../cheatsheet/text-processing/text-processing.html#remove-the-ending-%5Cn)
> - [Ansible Documentation](https://docs.ansible.com/ansible/latest/index.html)
>   - [* Ansible Vault](https://docs.ansible.com/ansible/2.8/user_guide/vault.html)
>   - [Protecting sensitive data with Ansible vault](https://docs.ansible.com/ansible/latest/vault_guide/index.html)
>   - [Encrypting content with Ansible Vault](https://docs.ansible.com/ansible/3/user_guide/vault.html)
>   - [Using Vault in playbooks](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_vault.html)
> - [10 ansible vault examples to decrypt/encrypt string & files](https://www.golinuxcloud.com/ansible-vault-example-encrypt-string-playbook/)
> - [Ansible 详解（四）：Ansible-vault](https://zhuanlan.zhihu.com/p/39158667)

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

- decrypt from string
  ```bash
  # encrypt
  $ echo -n 'a' | ansible-vault encrypt_string
  Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)

  Encryption successful
  !vault |
            $ANSIBLE_VAULT;1.1;AES256
            63666334316139653431343330386139346466356439373263643566373062613666653362353738
            3630386133363464313964666230313062666662396161650a313165353966393136643932643434
            64306666613835333130613866303730623538313136323236653732663461623532343035626262
            3932643631653739350a306131666337633831653233623638396438386535623938626133653332
            3464

  # decrypt
  $ echo -n '$ANSIBLE_VAULT;1.1;AES256
  63666334316139653431343330386139346466356439373263643566373062613666653362353738
  3630386133363464313964666230313062666662396161650a313165353966393136643932643434
  64306666613835333130613866303730623538313136323236653732663461623532343035626262
  3932643631653739350a306131666337633831653233623638396438386535623938626133653332
  3464' | ansible-vault decrypt
  Decryption successful
  a
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
> - [https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugins](https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugins)

```bash
# without password
$ export ANSIBLE_VAULT_PASSWORD_FILE=/path/to/password.txt
$ ansible-playbook -i hosts /path/to/yaml

# with password
$ ansible-playbook -i hosts /path/to/yaml --vault-id @prompt
```

### tags

> [!NOTE|label:references]
> - [Special tags: always and never](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_tags.html#special-tags-always-and-never)
> - [Use Ansible tags to save time on playbook runs](https://www.redhat.com/sysadmin/ansible-tags-fast-playbook-runs)

#### never
```yaml
$ cat sample.yaml
---

- hosts: localhost
  gather_facts: False
  tasks:

    - name: Hello tag example
      debug:
        msg: "Hello!"
      tags:
        - hello

    - name: No tag example
      debug:
        msg: "How are you?"

    - name: Goodbye tag example
      debug:
        msg: "Goodbye!"
      tags:
        - goodbye
        - never                        # will not be executed unless using `--tags goodbye`
```

- result
  ```bash
  $ ansible-playbook sample.yaml

  PLAY [localhost] *************************************************************************
  TASK [Hello tag example] *****************************************************************
  ok: [localhost] => {
      "msg": "Hello!"
  }

  TASK [No tag example] ********************************************************************
  ok: [localhost] => {
      "msg": "How are you?"
  }

  PLAY RECAP *******************************************************************************
  localhost           : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  ```

- result with `--tags`
  ```bash
  $ ansible-playbook sample.yaml --tags goodbye

  PLAY [localhost] *************************************************************************

  TASK [Goodbye tag example] ***************************************************************
  ok: [localhost] => {
      "msg": "Goodbye!"
  }

  PLAY RECAP *******************************************************************************
  localhost           : ok=1    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
  ```

## [vault CLI]

> [!NOTE|label:references:]
> - [Vault CLI commands](https://cloud.ibm.com/docs/secrets-manager?topic=secrets-manager-vault-cli)
> - [Vault commands (CLI)](https://developer.hashicorp.com/vault/docs/commands)
> - [Using Ansible command line tools](https://docs.ansible.com/ansible/latest/command_guide/index.html)

### environment variables
```bash
$ export VAULT_ADDR=https://vault.example.com
$ export VAULT_TOKEN=s.s**********************K
```

### [kv get](https://developer.hashicorp.com/vault/docs/commands/kv/get)
```bash
$ vault kv get -mount=project service-account/account
============= Secret Path =============
project/data/service-account/account

======= Metadata =======
Key                Value
---                -----
created_time       2024-06-19T06:51:35.036120169Z
custom_metadata    <nil>
deletion_time      n/a
destroyed          false
version            9

============= Data =============
Key                       Value
---                       -----
email                     account@sample.com
password                  eW7[xRF(rgA@x)n£LN75?R5b.k2z1+
username                  account

# with json foramt
$ vault kv get -format=json -mount=project service-account/account
```

### [kv list](https://developer.hashicorp.com/vault/docs/commands/kv/list)
```bash
$ vault kv list project/service-account
Keys
----
account
```

## [ansible-config](https://docs.ansible.com/ansible/latest/reference_appendices/config.html#inventory-unparsed-warning)

> [!NOTE|label:referencs:]
> - [v2.4 Configuration file](https://docs.ansible.com/archive/ansible/2.4/intro_configuration.html)

### get all default
```bash
$ ansible-config init --disabled -t all
```

- disable localhost warning
  ```bash
  $ cat ansible.cfg
  [defaults]
  localhost_warning=false
  ```

## plugin
### [lookup](https://docs.ansible.com/ansible/latest/plugins/lookup.html)

> [!NOTE|label:references:]
> - [自动化运维 | Ansible lookup](http://www.manongjc.com/detail/57-jamkqmdgyzomkhf.html)
> - sample code
>   {% raw %}
>   ```bash
>   $ ls --color=none lookup* | xargs -n1 -t cat
>   cat lookup-content.txt
>   hello world
>
>   cat lookup.yaml
>   ---
>   - hosts: localhost
>     tasks:
>     vars:
>        contents: "{{ lookup('file', '/home/marslo/iMarslo/study/code/ansible/lookup-content.txt')}}"
>     tasks:
>        - debug: msg="the content of file lookup-content.txt is {{contents}}"
>   ```
>   {% endraw %}

```bash
$ ansible-playbook lookup.yaml
PLAY [localhost] *************************************************************************

TASK [Gathering Facts] *******************************************************************
Monday 24 July 2023  17:43:51 -0700 (0:00:00.007)       0:00:00.007 ***********
ok: [localhost]

TASK [debug] *****************************************************************************
Monday 24 July 2023  17:43:51 -0700 (0:00:00.935)       0:00:00.943 ***********
ok: [localhost] => {}

MSG:

the content of file lookup-content.txt is hello world

PLAY RECAP *******************************************************************************
localhost                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

Monday 24 July 2023  17:43:52 -0700 (0:00:00.030)       0:00:00.974 ***********
===============================================================================
Gathering Facts ------------------------------------------------------------------- 0.94s
debug ----------------------------------------------------------------------------- 0.03s
```

### [Become](https://docs.ansible.com/ansible/latest/plugins/become.html#become-plugins)

> [!NOTE|label:references:]
> - [Understanding privilege escalation: become](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_privilege_escalation.html#using-become)
> - [Ansible Become](https://learning-ocean.com/tutorials/ansible/ansible-become/)

## troubleshooting
- [generate the final yaml via `ansible.builtin.template`](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/template_module.html)
  ```yaml
  # in tasks/main.yaml
  - name: Template a file to local
    ansible.builtin.template:
      src: file_in_template.yaml
      dest: /local/path/to/yaml
  ```
