<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [environment](#environment)
  - [install](#install)
  - [compltion](#compltion)
  - [status](#status)
- [get info](#get-info)
  - [auth](#auth)
  - [security](#security)
  - [list](#list)
- [approle](#approle)
  - [via CLI](#via-cli)
  - [via API](#via-api)
  - [get secret_id and role_id](#get-secret_id-and-role_id)
- [operator](#operator)
  - [tokens](#tokens)
    - [root tokens](#root-tokens)
  - [init](#init)
- [ssh](#ssh)
  - [client key sign](#client-key-sign)
    - [signing key & role configuration](#signing-key--role-configuration)
    - [client ssh authentication](#client-ssh-authentication)
  - [host key sign](#host-key-sign)
    - [verify](#verify)
  - [troubleshooting](#troubleshooting)
  - [ssh secrets engine (API)](#ssh-secrets-engine-api)
- [usage](#usage)
  - [API](#api)
  - [CLI](#cli)
  - [path-help](#path-help)
  - [stdin](#stdin)
  - [Files](#files)
  - [basic usage](#basic-usage)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:references]
> - [vault CLI](https://developer.hashicorp.com/vault/docs/commands)
> - [Integrate HashiCorp Vault with CICD tool(Jenkins)](https://medium.com/geekculture/integrate-hashicorp-vault-with-cicd-tool-jenkins-4bf712ad3f45)
> - [How To Read Vault’s Secrets from Jenkin’s Declarative Pipeline](https://codeburst.io/read-vaults-secrets-from-jenkin-s-declarative-pipeline-50a690659d6)
> - [Hashicorp vault how to list all roles](https://stackoverflow.com/a/60870106/2940319)
> - [AppRole auth method](https://developer.hashicorp.com/vault/docs/auth/approle)

# environment

## install
- macos
  ```bash
  $ brew tap hashicorp/tap
  $ brew install hashicorp/tap/vault
  ```

- ubunut/debian
  ```bash
  $ wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  $ echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
  $ sudo apt update && sudo apt install vault
  ```

- centos/rhel
  ```bash
  $ sudo yum install -y yum-utils
  $ sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
  $ sudo yum -y install vault
  ```

## compltion
```bash
$ vault -autocomplete-install
```

## status
```bash
$ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    5
Threshold       3
Version         1.9.0
Build Date      n/a
Storage Type    file
Cluster Name    vault-cluster-ea2f5821
Cluster ID      e034c5c3-53c6-2d38-2adf-e9bbd57ad87c
HA Enabled      false
```

# get info

## auth

- list role type
  ```bash
  $ vault auth list
  Path        Type       Accessor                 Description                Version
  ----        ----       --------                 -----------                -------
  approle/    approle    auth_approle_375212fa    n/a                        n/a
  ldap/       ldap       auth_ldap_8fc0eb82       n/a                        n/a
  token/      token      auth_token_f61ed5a6      token based credentials    n/a
  ```

- list roles
  ```bash
  $ vault list auth/approle/role
  Keys
  ----
  jenkins
  jenkins-role
  ```

- read role
  ```bash
  $ vault read auth/approle/role/jenkins
  Key                        Value
  ---                        -----
  bind_secret_id             true
  local_secret_ids           false
  secret_id_bound_cidrs      <nil>
  secret_id_num_uses         0
  secret_id_ttl              0s
  token_bound_cidrs          []
  token_explicit_max_ttl     0s
  token_max_ttl              4h
  token_no_default_policy    false
  token_num_uses             0
  token_period               0s
  token_policies             [service-ssh]
  token_ttl                  1h
  token_type                 default
  ```

## security

- get token
  ```bash
  $ vault auth list
  Path        Type       Accessor                 Description                Version
  ----        ----       --------                 -----------                -------
  approle/    approle    auth_approle_375212fa    n/a                        n/a
  ldap/       ldap       auth_ldap_8fc0eb82       n/a                        n/a
  token/      token      auth_token_f61ed5a6      token based credentials    n/a

  $ vault token lookup
  Key                 Value
  ---                 -----
  accessor            Wf********************5y
  creation_time       1640161759
  creation_ttl        0s
  display_name        root
  entity_id           n/a
  expire_time         <nil>
  explicit_max_ttl    0s
  id                  s.s**********************K
  meta                <nil>
  num_uses            0
  orphan              true
  path                auth/token/root
  policies            [root]
  ttl                 0s
  type                service
  ```

## list

- list all path
  ```bash
  $ vault secrets list [ -detailed ]
  Path                       Type         Accessor              Description
  ----                       ----         --------              -----------
  devops/                    kv           kv_374198a0           for devops
  ```

- list keys
  ```bash
  $ vault kv list devops/service-account/
  Keys
  ----
  read-only
  read-write
  read-write-delete
  ```

- get contents
  ```bash
  $ vault kv get devops/service-account/read-only
  =============== Secret Path ===============
  devops/data/service-account/read-only

  ======= Metadata =======
  Key                Value
  ---                -----
  created_time       2023-03-06T15:52:45.827580966Z
  custom_metadata    <nil>
  deletion_time      n/a
  destroyed          false
  version            5

  ============ Data ============
  Key                      Value
  ---                      -----
  cn                       read-only
  dn                       CN=read-only,OU=Service-Accounts,DC=example,DC=com
  password                 ********
  sAMAccountName           read-only
  username                 read-only
  ```

# approle

> [!NOTE|label:references:]
> - [Integrate HashiCorp Vault with CICD tool(Jenkins)](https://medium.com/geekculture/integrate-hashicorp-vault-with-cicd-tool-jenkins-4bf712ad3f45)

## via CLI

- pre-setup
  ```bash
  $ export VAULT_ADDR='https://vault.domain.com'
  $ export VAULT_TOKEN='s.s**********************K'

  # VAULT_TOKEN=$(vault print token)
  ```

- setup
  ```bash
  $ vault write auth/approle/role/devops \
                token_num_uses=0 \
                secret_id_num_uses=0 \
                policies="devops"
  Success! Data written to: auth/approle/role/devops

  $ vault read auth/approle/role/devops
  Key                        Value
  ---                        -----
  bind_secret_id             true
  local_secret_ids           false
  policies                   [devops]
  secret_id_bound_cidrs      <nil>
  secret_id_num_uses         0
  secret_id_ttl              0s
  token_bound_cidrs          []
  token_explicit_max_ttl     0s
  token_max_ttl              0s
  token_no_default_policy    false
  token_num_uses             0
  token_period               0s
  token_policies             [devops]
  token_ttl                  0s
  token_type                 default
  ```

## [via API](https://developer.hashicorp.com/vault/docs/auth/approle#via-the-api-1)
```bash
# enable auth method
$ curl \
      --header "X-Vault-Token: ..." \
      --request POST \
      --data '{"type": "approle"}' \
      http://127.0.0.1:8200/v1/sys/auth/approle

# create approle with policy
$ curl \
      --header "X-Vault-Token: ..." \
      --request POST \
      --data '{"policies": "dev-policy,test-policy"}' \
      http://127.0.0.1:8200/v1/auth/approle/role/my-role

# check identifier of role
$ curl \
      --header "X-Vault-Token: ..." \
      http://127.0.0.1:8200/v1/auth/approle/role/my-role/role-id
{
  "data": {
    "role_id": "988a9dfd-ea69-4a53-6cb6-9d6b86474bba"
  }
}

# create new security
$ curl \
      --header "X-Vault-Token: ..." \
      --request POST \
       http://127.0.0.1:8200/v1/auth/approle/role/my-role/secret-id
{
  "data": {
    "secret_id_accessor": "45946873-1d96-a9d4-678c-9229f74386a5",
    "secret_id": "37b74931-c4cd-d49a-9246-ccc62d682a25",
    "secret_id_ttl": 600,
    "secret_id_num_uses": 40
  }
}
```

## get secret_id and role_id
```bash
# read for role-id
$ vault read auth/approle/role/devops/role-id
Key        Value
---        -----
role_id    1*******-****-****-****-***********5

$ vault write -f auth/approle/role/srv-ssd-fw-devops/secret-id
Key                   Value
---                   -----
secret_id             3*******-****-****-****-***********3
secret_id_accessor    9*******-****-****-****-***********b
secret_id_ttl         0

# list for secret_id
$ vault list auth/approle/role/devops/secret-id
Keys
-----
9*******-****-****-****-***********b
```

# operator
## tokens

> [!NOTE|label:references:]
> - [Tokens](https://developer.hashicorp.com/vault/docs/concepts/tokens)
> - [token prefixes](https://developer.hashicorp.com/vault/docs/concepts/tokens#token-prefixes)
>
> | TOKEN TYPE      | VAULT 1.9.X + | VAULT 1.10 -   |
> |-----------------|---------------|----------------|
> | Service tokens  | `s.<random>`  | `hvs.<random>` |
> | Batch tokens    | `b.<random>`  | `hvb.<random>` |
> | Recovery tokens | `r.<random>`  | `hvr.<random>` |

### [root tokens](https://developer.hashicorp.com/vault/docs/concepts/tokens#root-tokens)

> [!TIP]
> - [Regenerate a Vault root token](https://developer.hashicorp.com/vault/docs/troubleshoot/generate-root-token)
> - [/sys/generate-root](https://developer.hashicorp.com/vault/api-docs/system/generate-root) the API key for root tokens

- initial root token with no expiration
  ```bash
  $ vault operator init
  ```

- generate root token with share holders ( with unseal key )

  > [!NOTE|label:references:]
  > - unseal key is necessary to generate root token
  > - [operator generate-root](https://developer.hashicorp.com/vault/docs/commands/operator/generate-root)

  ```bash
  $ vault operator generate-root
  ```

  - example:

    - generate an otp code for the final token
      ```bash
      $ vault operator generate-root -generate-otp
      ```

    - start a root token generation:
      ```bash
      $ vault operator generate-root -init
      ```

    - enter an unseal key to progress root token generation:
      ```bash
      $ vault operator generate-root
      ```

- check status
  ```bash
  $ vault operator generate-root -status
  Nonce         n/a
  Started       false
  Progress      0/3
  Complete      false
  OTP Length    26
  ```

## [init](https://developer.hashicorp.com/vault/docs/commands/operator)
```bash
$ vault operator init
Unseal Key 1: p******************************************Y
Unseal Key 2: /******************************************y
Unseal Key 3: j******************************************I
Unseal Key 4: V******************************************K
Unseal Key 5: l******************************************M

Initial Root Token: s.s**********************K
```

- [check status](https://developer.hashicorp.com/vault/docs/commands/operator/key-status)
  ```bash
  $ vault operator key-status
  Key Term            1
  Install Time        22 Dec 21 08:29 UTC
  Encryption Count    211817
  ```

- [generate new unseal key](https://developer.hashicorp.com/vault/docs/commands/operator/rekey)
  ```bash
  $ vault operator rekey
  ```

- seal/unseal
  ```bash
  $ vault operator seal
  $ vault operator unseal
  ```

# ssh

> [!NOTE|label:references:]
> - [Signed SSH certificates](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#host-key-signing)
> - [Managing SSH Access at Scale with HashiCorp Vault](https://www.hashicorp.com/blog/managing-ssh-access-at-scale-with-hashicorp-vault)

## client key sign
### [signing key & role configuration](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#signing-key-role-configuration)

- mount ssh secret engine
  ```bash
  $ vault secrets enable -path=devops-ssh ssh
  ```

- configure vault with a ca
  ```bash
  $ vault write devops-ssh/config/ca generate_signing_key=true
  # or with private/public key pairs
  $ vault write devops-ssh/config/ca \
          private_key="..." \
          public_key="..."

  ```

- add CA to all servers
  ```bash
  # download pem
  $ curl -o /etc/ssh/trusted-user-ca-keys.pem http://vault.sample.com:8200/v1/ssh-client-signer/public_key
  # or
  $ vault read -field=public_key devops-ssh/config/ca > /etc/ssh/trusted-user-ca-keys.pem

  # modify sshd_config to `TrustedUserCAKeys`
  $ sudo vim /etc/ssh/sshd_config
  ...
  TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem

  # restart sshd
  $ sudo systemctl daemon-reload
  $ sudo systemctl restart sshd.service
  ```

- create role
  ```bash
  $ vault write devops-ssh/roles/my-role -<<"EOH"
  {
    "algorithm_signer": "rsa-sha2-256",
    "allow_user_certificates": true,
    "allowed_users": "*",
    "allowed_extensions": "permit-pty,permit-port-forwarding",
    "default_extensions": {
      "permit-pty": ""
    },
    "key_type": "ca",
    "default_user": "ubuntu",
    "ttl": "30m0s"
  }
  EOH
  ```

### [client ssh authentication](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#client-ssh-authentication)
- create ssh-key paire
  ```bash
  $ ssh-keygen -t ed25519 -C "user@example.com"
  ```

- sign the public key
  ```bash
  $ vault write ssh-client-signer/sign/my-role \
      public_key=@$HOME/.ssh/id_ed25519.pub

  Key             Value
  ---             -----
  serial_number   c73f26d2340276aa
  signed_key      ssh-rsa-cert-v01@openssh.com AAAAHHNzaC1...

  # or customerize
  $ vault write ssh-client-signer/sign/my-role -<<"EOH"
  {
    "public_key": "ssh-rsa AAA...",
    "valid_principals": "my-user",
    "key_id": "custom-prefix",
    "extensions": {
      "permit-pty": "",
      "permit-port-forwarding": ""
    }
  }
  EOH
  ```

- saved the signed keys
  ```bash
  $ vault write -field=signed_key ssh-client-signer/sign/my-role \
      public_key=@$HOME/.ssh/id_ed25519.pub > signed-cert.pub

  # verify
  $ ssh-keygen -Lf ~/.ssh/signed-cert.pub

  # ssh
  $ ssh -i signed-cert.pub -i ~/.ssh/id_ed25519 username@10.0.23.5
  ```

## host key sign

- mount ssh security
  ```bash
  $ vault secrets enable -path=devops-ssh-hosts ssh
  Successfully mounted 'ssh' at 'devops-ssh-hosts'!
  ```

- configure CA
  ```bash
  $ vault write devops-ssh-hosts/config/ca generate_signing_key=true
  Key             Value
  ---             -----
  public_key      ssh-rsa AAAAB3NzaC1yc2EA...

  # or with key pairs
  $ vault write devops-ssh-hosts/config/ca \
          private_key="..." \
          public_key="..."
  ```

- extend host key certificate ttls
  ```bash
  $ vault secrets tune -max-lease-ttl=87600h devops-ssh-hosts
  ```

- create role
  ```bash
  $ vault write devops-ssh-hosts/roles/hostrole \
      key_type=ca \
      algorithm_signer=rsa-sha2-256 \
      ttl=87600h \
      allow_host_certificates=true \
      allowed_domains="localdomain,example.com" \
      allow_subdomains=true
  ```

- sign ssh public key
  ```bash
  $ vault write devops-ssh-hosts/sign/hostrole \
      cert_type=host \
      public_key=@/etc/ssh/ssh_host_ed25519_key.pub
  Key             Value
  ---             -----
  serial_number   3746eb17371540d9
  signed_key      ssh-rsa-cert-v01@openssh.com AAAAHHNzaC1y...
  ```

- signed certificate as `HostCertificate`
  ```bash
  $ vault write -field=signed_key devops-ssh-hosts/sign/hostrole \
      cert_type=host \
      public_key=@/etc/ssh/ssh_host_ed25519_key.pub > /etc/ssh/ssh_host_ed25519_key-cert.pub

  $ chmod 0640 /etc/ssh/ssh_host_ed25519_key-cert.pub

  # modify sshd_config
  $ sudo vim /etc/ssh/sshd_config
  ...
  # For client keys
  TrustedUserCAKeys /etc/ssh/trusted-user-ca-keys.pem
  ...
  # For host keys
  HostKey /etc/ssh/ssh_host_ed25519_key
  HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub

  $ sudo systemctl daemon-reload
  $ sudo systemctl restasrt sshd.service
  ```

### verify
- retrieve the host signing ca public key
  ```bash
  $ curl http://127.0.0.1:8200/v1/devops-ssh-hosts/public_key

  # or
  $ vault read -field=public_key devops-ssh-hosts/config/ca
  ```

- add into ~/.ssh/authorized_keys
  ```bash
  $ cat >> ~/.ssh/known_hosts << EOF
  @cert-authority *.example.com ssh-rsa AAAAB3NzaC1yc2EAAA...
  EOF
  ```

## [troubleshooting](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#troubleshooting)

- set verbose log level
  ```bash
  $ sudo vim /etc/ssh/sshd_config
  ...
  LogLevel VERBOSE

  $ sudo systemctl daemon-reload
  $ sudo systemctl restart sshd.services
  ```

- check in `/var/log/auth.log`
  ```bash
  $ tail -f /var/log/auth.log | grep --line-buffered "sshd"
  ```

## [ssh secrets engine (API)](https://developer.hashicorp.com/vault/api-docs/secret/ssh)

# usage
## API

> [!NOTE|label:references:]
> - [api v1.14.x](https://developer.hashicorp.com/vault/api-docs)

```bash
$ curl \
      -H "X-Vault-Token: f3b09679-3001-009d-2b80-9c306ab81aa6" \
      -H "X-Vault-Namespace: ns1/ns2/" \
      -X GET \
      http://127.0.0.1:8200/v1/secret/foo

# or
$ curl \
      -H "X-Vault-Token: f3b09679-3001-009d-2b80-9c306ab81aa6" \
      -X GET \
      http://127.0.0.1:8200/v1/ns1/ns2/secret/foo
```

## CLI

> [!NOTE|label:references:]
> - [* Vault commands (CLI)](https://developer.hashicorp.com/vault/docs/commands)
> - [Rotate Azure auth method root credentials with Vault CLI](https://developer.hashicorp.com/vault/tutorials/secrets-management/azure-root-cred-rotate)
>   - [auth](https://developer.hashicorp.com/vault/docs/commands/auth)
>   - [kv](https://developer.hashicorp.com/vault/docs/commands/kv)
>   - [list](https://developer.hashicorp.com/vault/docs/commands/list)
>   - [secrets](https://developer.hashicorp.com/vault/docs/commands/secrets)
>   - [policy](https://developer.hashicorp.com/vault/docs/commands/policy)
>   - [debug](https://developer.hashicorp.com/vault/docs/commands/debug)
>
> - [print curl commands](https://developer.hashicorp.com/vault/docs/commands#print-curl-command)
>  ```bash
>  $ vault write -output-curl-string  auth/userpass/users/bob password="long-password"
>  curl -X PUT -H "X-Vault-Request: true" -H "X-Vault-Token: $(vault print token)" -d '{"password":"long-password"}' http://127.0.0.1:8200/v1/auth/userpass/users/bob
>  ```
> - [print policy requirements](https://developer.hashicorp.com/vault/docs/commands#print-policy-requirements)
>   ```bash
>   $ vault kv put -output-policy kv/secret value=itsasecret
>   path "kv/data/secret" {
>     capabilities = ["create", "update"]
>   }
>   ```

## [path-help](https://developer.hashicorp.com/vault/docs/commands#api-help)
```bash
 $ vault path-help devops
   ...

     ^.*$

     ^config$
         Configures settings for the KV store

     ^data/(?P<path>.*)$
         Write, Patch, Read, and Delete data in the Key-Value Store.

     ^delete/(?P<path>.*)$
         Marks one or more versions as deleted in the KV store.

     ^destroy/(?P<path>.*)$
         Permanently removes one or more versions in the KV store

     ^metadata/(?P<path>.*)$
         Configures settings for the KV store

     ^undelete/(?P<path>.*)$
         Undeletes one or more versions from the KV store.
```
- and more
  ```bash
  $ vault path-help sys/mounts
  Request:        mounts
  Matching Route: ^mounts$

  ## DESCRIPTION
  This path responds to the following HTTP methods.

      GET /
          Lists all the mounted secret backends.

      GET /<mount point>
          Get information about the mount at the specified path.

      POST /<mount point>
          Mount a new secret backend to the mount point in the URL.

      POST /<mount point>/tune
          Tune configuration parameters for the given mount point.

      DELETE /<mount point>
          Unmount the specified mount point.
  ```

## [stdin](https://developer.hashicorp.com/vault/docs/commands#stdin)
```bash
$ echo -n '{"value":"itsasecret"}' | vault kv put secret/password -

# or
$ echo -n "itsasecret" | vault kv put secret/password value=-
```

## [Files](https://developer.hashicorp.com/vault/docs/commands#files)
```bash
$ vault kv put secret/password @data.json

# or
$ vault kv put secret/password value=@data.txt
```

## basic usage
```bash
$ export VAULT_ADDR='http://127.0.0.1:8200'
$ export VAULT_TOKEN=root

# enable azure
$ vault auth enable azure

# write config
$ vault write auth/azure/config \
              tenant_id="${TENANT_ID}" \
              client_id="${CLIENT_ID}" \
              client_secret="${CLIENT_SECRET}" \
              resource="https://management.azure.com/"

# write role
$ vault write auth/azure/role/rotation-role \
              bound_subscription_ids="${SUBSCRIPTION_ID}" \
              bound_resource_groups="${RESOURCE_GROUP_NAME}"

# login
$ vault write auth/azure/login \
              role="rotation-role" \
              jwt="${ACCESS_TOKEN_JWT}" \
              subscription_id="${SUBSCRIPTION_ID}" \
              resource_group_name="${RESOURCE_GROUP_NAME}" \
              vm_name="${VM_NAME}"
```

- result
  ```bash
  Key                               Value
  ---                               -----
  token                             hvs.XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  token_accessor                    XXXXXXXXXXXXXXXXXXXXXX
  token_duration                    768h
  token_renewable                   true
  token_policies                    ["default"]
  identity_policies                 []
  policies                          ["default"]
  token_meta_vm_name                vault-azure-tests-vm
  token_meta_resource_group_name    vault_azure_tests_XXXXXXXX
  token_meta_role                   rotation-role
  token_meta_subscription_id        XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXX
  ```
