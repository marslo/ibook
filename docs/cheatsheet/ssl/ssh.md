<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [generate SCA gpg key](#generate-sca-gpg-key)
- [backup and restore gpg key](#backup-and-restore-gpg-key)
  - [backup](#backup)
  - [restore](#restore)
- [ssh support](#ssh-support)
  - [generate ssh public key](#generate-ssh-public-key)
  - [start gpg-agent](#start-gpg-agent)
  - [authorize public key](#authorize-public-key)
- [git support](#git-support)
  - [set config globally](#set-config-globally)
  - [setup for multiple accounts and keys](#setup-for-multiple-accounts-and-keys)
  - [add gpg key to github](#add-gpg-key-to-github)
  - [verify](#verify)
  - [github gpg key management](#github-gpg-key-management)
- [tips](#tips)
  - [view the exported private key structure](#view-the-exported-private-key-structure)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [* iMarslo: gpg](./gpg.md)

| LETTER | MEANING       | FLAG             | CONSTANT          | COMMENTS                                      |
|--------|---------------|------------------|-------------------|-----------------------------------------------|
| `[C]`  | Certification | `0x01`           | PUBKEY_USAGE_CERT | 认证其他秘钥/给其他证书签名                   |
| `[S]`  | Signing       | `0x02`           | PUBKEY_USAGE_SIG  | 签名,如给文件添加数字签名, 给 git commit 签名 |
| `[A]`  | Authenticate  | `0x20`           | PUBKEY_USAGE_AUTH | 身份验证, 如 ssh 登录                         |
| `[E]`  | Encryption    | `0x04` or `0x08` | PUBKEY_USAGE_ENC  | 加密, 如给文件加密, 给邮件加密                |

## generate SCA gpg key

> [!TIP]
> - encryption method:
>   - Sign: `ed25519`
>   - Encrypt: `cv25519`
> - manual steps:
>> ```bash
>> $ gpg --full-generate-key
>> ```
>> 1. select `(9) ECC (sign and encrypt)`
>> 2. select `(1) Curve 25519`
>> 3. select `0 = key does not expire`

```bash
$ gpg --batch --passphrase '********' --pinentry-mode loopback --generate-key <<EOF
Key-Type: EDDSA
Key-Curve: ed25519
Subkey-Type: ECDH
Subkey-Curve: cv25519
Name-Real: marslo
Name-Email: marslo@domain.com
Expire-Date: 0
%commit
EOF
gpg: revocation certificate stored as '/Users/marslo/.gnupg/openpgp-revocs.d/8**********************56**************D.rev'

$ gpg --list-secret-keys --keyid-format=long
[keyboxd]
---------
sec   ed25519/6**************D 2026-02-12 [SCA]
      8**********************56**************D
uid                 [ultimate] marslo <marslo@domain.com>
ssb   cv25519/4**************D 2026-02-12 [E]
```

## backup and restore gpg key
### backup

```bash
$ KEY_ID=6**************D

# gpg keys
$ gpg --armor --export ${KEY_ID} > ${KEY_ID}-public.asc
$ gpg --armor --export-secret-keys ${KEY_ID} > ${KEY_ID}-secret.asc

# ssh public key
$ COMMENT='marslo@gpg'
$ echo "$(gpg --export-ssh-key ${KEY_ID} | cut -d' ' -f1,2) ${COMMENT}" > ~/.ssh/"${COMMENT}".pub

# trust database
$ gpg --export-ownertrust > gpg-ownertrust.txt
```

### restore

```bash
# gpg keys
$ gpg --import ./*.asc

# trust database
$ gpg --import-ownertrust < gpg-ownertrust.txt
```

## ssh support

### generate ssh public key

```bash
$ gpg --export-ssh-key 6**************D

# or with comment
$ COMMENT='marslo@gpg'
$ echo "$(gpg --export-ssh-key ${KEY_ID} | cut -d' ' -f1,2) ${COMMENT}" > ~/.ssh/${COMMENT}.pub
```

### start gpg-agent

```bash
$ cat ~/.bash_profile
export GPG_TTY=$(tty)
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

$ cat ~/.ssh/config
HOST *
     IdentitiesOnly            yes
     # using public key as IdentityFile, ssh will compare the fingerprint with ssh agent
     IdentityFile              ~/.ssh/marslo@gpg.pub
```

- verify fingerprint

  ```bash
  # check from public key
  $ ssh-keygen -f ~/.ssh/marslo@gpg.pub -l
  256 SHA256:V6nCfXgETxew3yUk7ids/pL7XH8BZjm4BZlL9hPrk3w marslo@gpg (ED25519)

  # check from ssh agent
  $ ssh-add -l -E sha256
  256 SHA256:V6nCfXgETxew3yUk7ids/pL7XH8BZjm4BZlL9hPrk3w (none) (ED25519)
  # or
  $ ssh-add -l
  256 SHA256:V6nCfXgETxew3yUk7ids/pL7XH8BZjm4BZlL9hPrk3w (none) (ED25519)
  ```

- verify GPG-Agent SSH Socket connection
  ```bash
  $ netstat -anl | grep "S.gpg-agent.ssh"
  6916d7c90a637341 stream      0      0 931fce012153f5f8                0                0                0 /Users/marslo/.gnupg/S.gpg-agent.ssh

  $ lsof -U | grep "S.gpg-agent.ssh"
  gpg-agent  3933 marslo    7u  unix 0x6916d7c90a637341      0t0      /Users/marslo/.gnupg/S.gpg-agent.ssh

  $ lsof ~/.gnupg/S.gpg-agent.ssh
  COMMAND    PID   USER   FD   TYPE             DEVICE SIZE/OFF NODE NAME
  gpg-agent 3933 marslo    7u  unix 0x6916d7c90a637341      0t0      /Users/marslo/.gnupg/S.gpg-agent.ssh
  ```

### authorize public key

```bash
$ cat ~/.ssh/${COMMENT}.pub |
  ssh <REMOET_SERVER> "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
# or
$ ssh-copy-id -i ~/.ssh/${COMMENT}.pub <REMOET_SERVER>

# verify
$ ssh <REMOET_SERVER>
```

## git support

### set config globally

```bash
$ git config --global user.signingkey 6**************D

# enable signature automatically
$ git config --global commit.gpgsign true

# for macOS
$ git config --global gpg.program $(which gpg)
```

### setup for multiple accounts and keys

```bash
$ cat ~/.gitconfig.d/person
[user]
  name       = marslo
  email      = marslo@person.com
  signingkey = 6**************D
[commit]
    gpgsign  = true
[tag]
    gpgsign  = true

$ cat ~/.gitconfig.d/work
[user]
  name       = marslo
  email      = marslo@work.com
  signingkey = 7**************3
[commit]
    gpgsign  = true
[tag]
    gpgsign  = true

$ cat ~/.gitconfig
[includeIf "gitdir/i:~/git/person/**"]
  path       = ~/.gitconfig.d/person
[includeIf "gitdir/i:~/git/work/**"]
  path       = ~/.gitconfig.d/work
```

### add gpg key to github
- get gpg public key
  ```bash
  # person
  $ gpg --armor --export 6**************D | pbcopy

  # work
  $ gpg --armor --export 7**************3 | pbcopy
  ```

- add in github
  1. go to `Settings` -> `SSH and GPG keys` -> `New GPG key`
  2. paste the gpg public key and save


### verify

> [!TIP|label:to show signature in `git log` and `git show`]
> ```bash
> $ git config --global log.showSignature true
> ```

```bash
# .. git commit -am '...'
$ git show --show-signature [--no-patch]
```

- shows in `git log` with `[%G?]%C`
  ```git
  [alias]
    pl = !git -c log.decorate=short --no-pager log --color --graph --abbrev-commit --date=relative --max-count=3 --pretty=tformat:"'%C(#678963)%h%C(reset) -%C(yellow)%d%C(reset) %s %C(green)(%cr) %C(italic blue)<%an>%C(reset) %C(italic #6971a3)[%G?]%C(reset)'"
  ```

  ```bash
  # example output: [G] -> with signature, [N] -> no signature
  $ git pl
  * 178ac121 - (HEAD -> marslo, origin/marslo) feat(conventional commits): add details for git conventional commits (8 days ago) <marslo> [G]
  * 8f1d4772 - fix(brew,cleanup): add the ultimate fix solution for brew environment (2 weeks ago) <marslo> [N]
  * f1aafe99 - feat(jf,fossa): introduce fossa CLI; add example for jf cli (2 weeks ago) <marslo> [N]
  ```

  ![git pl with gpg sign](../../screenshot/git/git-pl-gpg.png)


### github gpg key management

> [!NOTE|label:references:]
> - `gpg: Can't check signature: No public key`:
>   ```bash
>   $ git show -s HEAD --show-signature
>   commit 7eb9b4f124894a8ee7be153d763373423e1c9bd3 (origin/stable, origin/HEAD)
>   gpg: Signature made Fri Mar 13 12:11:32 2026 PDT
>   gpg:                using RSA key B5690EEEBB952194
>   gpg: Can't check signature: No public key
>   Author: John Doe <john.doe@mail.com>
>   Date:   2026-03-13 12:11:32 -0700 Friday
>   ```
> - [web-flow.gpg](https://github.com/web-flow.gpg)
> - [keyserver.ubuntu.com](https://keyserver.ubuntu.com/pks/lookup?search=968479A1AFF927E37D1A566BB5690EEEBB952194&fingerprint=on&op=index)
> - [0xB5690EEEBB952194](https://keyserver.ubuntu.com/pks/lookup?search=B5690EEEBB952194&fingerprint=on&op=index)

#### download
```bash
$ for k in $(gh api "users/web-flow/gpg_keys" --jq '.[]|@base64'); do
    id="$(echo ${k} | jq -Rr '@base64d|fromjson|.key_id')"
    raw=$(echo ${k} | jq -Rr '@base64d|fromjson|.raw_key')
    echo "${raw}" > "github-${id}.gpg"
  done

$ ls
github-4AEE18F83AFDEB23.gpg  github-B5690EEEBB952194.gpg
```

#### import
```bash
# import `B5690EEEBB952194`

# using curl
$ curl -s https://api.github.com/users/web-flow/gpg_keys |
  jq -r '.[] | select(.key_id == "B5690EEEBB952194") | .raw_key' |
  gpg --import

# using keyserver, with port 11371
$ gpg --keyserver pgp.mit.edu --recv-keys B5690EEEBB952194
gpg: key B5690EEEBB952194: public key "GitHub <noreply@github.com>" imported
gpg: Total number processed: 1
gpg:               imported: 1

# or with proxy + port 80
$ gpg --keyserver hkp://keyserver.ubuntu.com:80 \
      --keyserver-options http-proxy=http://proxy.domain.com:8080 \
      --recv-keys B5690EEEBB952194

# with port 443
$ gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys B5690EEEBB952194
gpg: key B5690EEEBB952194: "GitHub <noreply@github.com>" not changed
gpg: Total number processed: 1
gpg:              unchanged: 1
```

| PORT    | PROTOCOL | DESCRIPTION                | EXAMPLE                       |
|---------|----------|----------------------------|-------------------------------|
| `11371` | hkp      | default port for keyserver | keyserver.ubuntu.com          |
| `443`   | hkps     | for https proxy            | hkps://keyserver.ubuntu.com   |
| `80`    | hkp      | for http proxy             | hkp://keyserver.ubuntu.com:80 |

#### trust
```bash
$ gpg --list-keys 968479A1AFF927E37D1A566BB5690EEEBB952194
pub   rsa4096 2024-01-16 [SC]
      968479A1AFF927E37D1A566BB5690EEEBB952194
uid           [ unknown] GitHub <noreply@github.com>

$ echo "968479A1AFF927E37D1A566BB5690EEEBB952194:6:" | gpg --import-ownertrust
gpg: setting ownertrust to 6

$ gpg --list-keys 968479A1AFF927E37D1A566BB5690EEEBB952194
pub   rsa4096 2024-01-16 [SC]
      968479A1AFF927E37D1A566BB5690EEEBB952194
uid           [ultimate] GitHub <noreply@github.com>
```

## tips
### view the exported private key structure

```bash
$ gpg --list-packets <(gpg --export-secret-keys 6C549DA3FA02DB3D)
```
