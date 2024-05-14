<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [environment](#environment)
  - [install](#install)
  - [compltion](#compltion)
  - [status](#status)
- [get info](#get-info)
  - [auth](#auth)
  - [security](#security)
- [create approle](#create-approle)
  - [via CLI](#via-cli)
  - [via API](#via-api)
  - [get secret_id and role_id](#get-secret_id-and-role_id)
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
> - [Signed SSH certificates](https://developer.hashicorp.com/vault/docs/secrets/ssh/signed-ssh-certificates#host-key-signing)

## environment

### install
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

### compltion
```bash
$ vault -autocomplete-install
```

### status
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

## get info

### auth

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

### security

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

## create approle

### via CLI

- pre-setup
  ```bash
  $ export VAULT_ADDR='https://vault.domain.com'
  $ export VAULT_TOKEN='s.s**********************K'
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

### [via API](https://developer.hashicorp.com/vault/docs/auth/approle#via-the-api-1)
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

### get secret_id and role_id
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

## usage
### API

> [!NOET|label:references:]
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

### CLI

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

### [path-help](https://developer.hashicorp.com/vault/docs/commands#api-help)
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

### [stdin](https://developer.hashicorp.com/vault/docs/commands#stdin)
```bash
$ echo -n '{"value":"itsasecret"}' | vault kv put secret/password -

# or
$ echo -n "itsasecret" | vault kv put secret/password value=-
```

### [Files](https://developer.hashicorp.com/vault/docs/commands#files)
```bash
$ vault kv put secret/password @data.json

# or
$ vault kv put secret/password value=@data.txt
```

### basic usage
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
