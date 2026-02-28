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


## tips
### view the exported private key structure

```bash
$ gpg --list-packets <(gpg --export-secret-keys 6C549DA3FA02DB3D)
```
