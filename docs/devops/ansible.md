<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

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
> - [10 ansible vault examples to decrypt/encrypt string & files](https://www.golinuxcloud.com/ansible-vault-example-encrypt-string-playbook/)

## install
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
```bash
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

```bash
$ ansible-vault encrypt_string 'Test123!' --vault-id @prompt
New vault password (default):
Confirm new vault password (default):
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          39336533303637306662623236393539353531376334343333356564393861613837643939373236
          3734656435313762383534396637636662653633323537380a633634373761646635323564373239
          65643866343561363461656165653433656338373638646437306133346134376464393761633133
          3064386166383237630a386366333132396364343062663735646136343432643063326139366436
          6434
```

### reset key
```bash
$ ansible-vault rekey
```

### encrypt
```bash
$ ansible-vault encrypt
```

### decrypt
```bash
$ ansible-vault decrypt
```

### view
```bash
$ ansible-vault view
```
