<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [basic knowledge](#basic-knowledge)
- [create new key](#create-new-key)
  - [create new subkey](#create-new-subkey)
- [list keys](#list-keys)
  - [secret keys](#secret-keys)
  - [public keys](#public-keys)
  - [list key id](#list-key-id)
  - [list public key and account](#list-public-key-and-account)
- [remove keys](#remove-keys)
- [backup and restore keys](#backup-and-restore-keys)
  - [backup and export](#backup-and-export)
  - [restore and import](#restore-and-import)
  - [trust key](#trust-key)
- [usage](#usage)
  - [sign file](#sign-file)
  - [verify](#verify)
  - [decrypt file](#decrypt-file)
  - [sign and encrypt file](#sign-and-encrypt-file)
  - [git ssh commit signing](#git-ssh-commit-signing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [* The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual.html)
> - [* The GNU Privacy Guard Manual](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
> - [GPG入门教程](https://www.ruanyifeng.com/blog/2013/07/gpg.html)
> - [GPG(GnuPG)入门 ](https://www.cnblogs.com/time-is-life/p/9668999.html)
> - [FlowCrypt: PGP Encryption for Gmail](https://flowcrypt.com/)
> - Protecting Code Integrity with PGP
>   - [Protecting Code Integrity with PGP — Part 1: Basic Concepts and Tools](https://www.linux.com/news/protecting-code-integrity-pgp-part-1-basic-pgp-concepts-and-tools/) | [用 PGP 保护代码完整性（一）： 基本概念和工具](https://linux.cn/article-9524-1.html)
>   - [Protecting Code Integrity with PGP — Part 2: Generating Your Master Key](https://www.linux.com/news/protecting-code-integrity-pgp-part-2-generating-and-protecting-your-master-pgp-key/) | [用 PGP 保护代码完整性（二）：生成你的主密钥](https://linux.cn/article-9529-1.html)
>   - [Protecting Code Integrity with PGP — Part 3: Generating PGP Subkeys](https://www.linux.com/news/protecting-code-integrity-pgp-part-3-generating-pgp-subkeys/) | [用 PGP 保护代码完整性（三）：生成 PGP 子密钥](https://linux.cn/article-9607-1.html)
>   - [Protecting Code Integrity with PGP — Part 4: Moving Your Master Key to Offline Storage](https://www.linux.com/news/protecting-code-integrity-pgp-part-4-moving-your-master-key-offline-storage/) | [用 PGP 保护代码完整性（四）：将主密钥移到离线存储中](https://linux.cn/article-10402-1.html)
>   - [Protecting Code Integrity with PGP — Part 5: Moving Subkeys to a Hardware Device](https://www.linux.com/training-tutorials/protecting-code-integrity-pgp-part-5-moving-subkeys-hardware-device) | [用 PGP 保护代码完整性（五）：将子密钥移到一个硬件设备中](https://linux.cn/article-10415-1.html)
>   - [Protecting Code Integrity with PGP — Part 6: Using PGP with Git](https://www.linux.com/news/protecting-code-integrity-pgp-part-6-using-pgp-git/) | [用 PGP 保护代码完整性（六）：在 Git 上使用 PGP](https://linux.cn/article-10421-1.html)
>   - [Protecting Code Integrity with PGP — Part 7: Protecting Online Accounts](https://www.linux.com/news/protecting-code-integrity-pgp-part-7-protecting-online-accounts/) | [用 PGP 保护代码完整性（七）：保护在线帐户](https://linux.cn/article-10432-1.html)

## basic knowledge

> [!NOTE|label:references:]
> - to show `--dump-options`: `gpg --dump-options`

- [letters indicating](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)

  > [!TIP|label:references:]
  > - [简明 GPG 概念](https://zhuanlan.zhihu.com/p/137801979)
  > - GPG 密钥的能力中， [C]、[S]、[A] 均属于签名方案，只有 [E] 是加密方案
  > - [The GNU Privacy Guard Manual  : 4.2.1 How to change the configuration](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
  > - [OpenPGP Message Format : 5.2.3.21.  Key Flags](https://www.rfc-editor.org/rfc/rfc4880#section-5.2.3.21)
  > - [How are the GPG usage flags defined in the key details listing?](https://unix.stackexchange.com/a/230859/29178)
  > - [Anatomy of a GPG Key](https://davesteele.github.io/gpg/2014/09/20/anatomy-of-a-gpg-key/)


|  FLAG | MEANING       | FLAG             | CONSTANT          | COMMENTS                                      |
|:-----:|---------------|------------------|-------------------|-----------------------------------------------|
| `[C]` | Certification | `0x01`           | PUBKEY_USAGE_CERT | 认证其他秘钥/给其他证书签名                   |
| `[S]` | Signing       | `0x02`           | PUBKEY_USAGE_SIG  | 签名,如给文件添加数字签名, 给 git commit 签名 |
| `[A]` | Authenticate  | `0x20`           | PUBKEY_USAGE_AUTH | 身份验证, 如 ssh 登录                         |
| `[E]` | Encryption    | `0x04` or `0x08` | PUBKEY_USAGE_ENC  | 加密, 如给文件加密, 给邮件加密                |


| ABBREVIATION | NAME          |
|:------------:|---------------|
|     `pub`    | public key    |
|     `sec`    | secret key    |
|     `sub`    | public subkey |
|     `ssb`    | secret subkey |
|     `fpr`    | fingerprint   |


| TYPE              | IDENTIFIER | PURPOSE                                       |
|-------------------|:-----------:|-----------------------------------------------|
| master key        |    `sec`    | key management, sign subkeys, encrypt subkeys |
| signing subkey    |  `ssb [S]`  | git commit signing                            |
| encryption subkey |  `ssb [E]`  | file encryption and decrypt                   |

<!--sec data-title="gpg list packages" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ gpg --list-packets test.sig.txt
# off=0 ctb=a3 tag=8 hlen=1 plen=0 indeterminate
:compressed packet: algo=1
# off=2 ctb=90 tag=4 hlen=2 plen=13
:onepass_sig packet: keyid FFB1BEE8152BF644
  version 3, sigclass 0x00, digest 10, pubkey 22, last=1
# off=17 ctb=ac tag=11 hlen=2 plen=19
:literal data packet:
  mode b (62), created 1772105311, name="test.txt",
  raw data: 5 bytes
# off=38 ctb=88 tag=2 hlen=2 plen=117
:signature packet: algo 22, keyid FFB1BEE8152BF644                                  # secret key id
  version 4, created 1772105311, md5len 0, sigclass 0x00
  digest algo 10, begin of digest 4c bd
  hashed subpkt 33 len 21 (issuer fpr v4 145709648350D6FF157BAF20FFB1BEE8152BF644)  # fingerprint
  hashed subpkt 2 len 4 (sig created 2026-02-26)                                    # timestamp
  subpkt 16 len 8 (issuer key ID FFB1BEE8152BF644)                                  # secret key id
  data: [251 bits]
  data: [253 bits]
```
<!--endsec-->

## create new key

> [!NOTE|label:references:]
> - [Generating GPG Keys](https://www.files.com/docs/encryption/gpg-pgp/generating-gpg-keys)
> - [How to create GPG keypairs](https://www.redhat.com/sysadmin/creating-gpg-keypairs)
> - [Generating a new GPG key](https://docs.github.com/en/authentication/managing-commit-signature-verification/generating-a-new-gpg-key)

```bash
$ gpg --full-generate-key
```

- [or](https://superuser.com/a/1360557/112396)
  ```bash
  $ gpg --batch --gen-key <<EOF
  %no-protection
  Key-Type:1
  Key-Length:2048
  Subkey-Type:1
  Subkey-Length:2048
  Name-Real: <John Doe>
  Name-Email: <john.doe@domain.com>
  Expire-Date:0
  EOF
  ```

### create new subkey

> [!NOTE|label:key type]
> - `(10) ECC (sign only)` : for git commit signing - `[S]` or `[A]`
> - `(12) ECC (encrypt only)` : for file encryption ( i.e.: `pass` tool ) - `[E]`

#### non-interactive mode

> [!TIP]
> must with fingerprint of the primary key

```bash
# [S]
$ gpg --quick-add-key 7C0BF765E462F5A6C4A45FAF335A865859218D02 ed25519 sign 0

# [S]
$ gpg --quick-add-key 7C0BF765E462F5A6C4A45FAF335A865859218D02 ed25519 auth 0

# [SA]
$ gpg --quick-add-key 7C0BF765E462F5A6C4A45FAF335A865859218D02 ed25519 sign,auth 0
```

#### signing subkey

> [!NOTE|label:before new subkey added]
> ```bash
> $ gpg --list-keys --keyid-format long 335A865859218D02
> pub   ed25519/335A865859218D02 2026-02-26 [SCA]
>       7C0BF765E462F5A6C4A45FAF335A865859218D02
> uid                 [ultimate] marslo <marslo@domain.com>
> sub   cv25519/A03D9828C2C5B8DC 2026-02-26 [E]
> ```

```bash
# interactive mode - [S]
$ gpg --edit-key 335A865859218D02 addkey save
gpg> addkey
✓ (10) ECC (sign only)
✓ (1) Curve 25519
✓ 0
✓ Y
✓ Y
gpg> save

# result
$ gpg --list-keys --keyid-format long 335A865859218D02
pub   ed25519/335A865859218D02 2026-02-26 [SCA]
      7C0BF765E462F5A6C4A45FAF335A865859218D02
uid                 [ultimate] marslo <marslo@domain.com>
sub   cv25519/A03D9828C2C5B8DC 2026-02-26 [E]
sub   ed25519/19298D1B0CE81049 2026-02-26 [S]        # new [S] subkey
```

#### new auth subkey

> [!TIP|label:select sign or/and auth capability]
> ```bash
> Possible actions for this ECC key: Sign Authenticate
> Current allowed actions: Sign
>
>    (S) Toggle the sign capability
>    (A) Toggle the authenticate capability
>    (Q) Finished
> ```
> - OPTIONS:
>   - (S): disable sign capability, result: Current allowed actions: Authenticate
>   - (A): enable authenticate capability, result: Current allowed actions: Sign Authenticate

```bash
# interactive mode - [SA]
$ gpg --expert --edit-key 335A865859218D02 addkey
✓ (11) ECC (set your own capabilities)
✓ (A) Toggle the authenticate capability  # insert S to disable sign capability; insert A to enable authenticate capability
# result: Current allowed actions: Sign Authenticate
✓ (Q) Finished
✓ (1) Curve 25519
✓ 0 = key does not expire
✓ Y
✓ Y
# check
$ gpg --list-keys --keyid-format long 335A865859218D02
pub   ed25519/335A865859218D02 2026-02-26 [SCA]
      7C0BF765E462F5A6C4A45FAF335A865859218D02
uid                 [ultimate] marslo <marslo@domain.com>
sub   cv25519/A03D9828C2C5B8DC 2026-02-26 [E]
sub   ed25519/19298D1B0CE81049 2026-02-26 [S]
sub   ed25519/22026B709B13C5C6 2026-02-26 [A]        # new [A] subkey
```

#### remove
```bash
# with index of the subkey
$ gpg --edit-key 335A865859218D02 'key 2' delkey save
✓ Y
# or
$ printf "key 2\ndelkey\ny\nsave\n" |
  gpg --command-fd 0 --status-fd 1 --edit-key 335A865859218D02

# with fingerprint of the subkey
$ printf "key 60FB7DC32A27F96E\ndelkey\ny\nsave\n" |
  gpg --command-fd 0 --status-fd 1 --edit-key 335A865859218D02
```

## list keys
### secret keys
```bash
$ gpg --list-secret-keys --keyid-format=long
gpg: checking the trustdb
gpg: marginals needed: 3  completes needed: 1  trust model: pgp
gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
[keyboxd]
---------
sec   ed25519/5**************3 2024-05-08 [SC]
      00D2F41050BF7D9BE6B275455**************3
uid                 [ultimate] marslo <marslo@domain.com>
ssb   cv25519/188C36434D6B9F66 2024-05-08 [E]

$ gpg --list-secret-keys --keyid-format=long --with-subkey-fingerprint
```

### public keys
```bash
$ gpg --list-public-keys --keyid-format=long
[keyboxd]
---------
pub   ed25519/5**************4 2024-05-08 [SC]
      6AADCD68E268DEF623C4DD7E5**************4
uid                 [ultimate] marslo <marslo@domain.com>
sub   cv25519/F065036D0FF76ABA 2024-05-08 [E]

$ gpg --list-public-keys --keyid-format=long --with-subkey-fingerprint
```

### list key id
```bash
$ gpg --list-keys --with-colons |
      awk -F: '$1 == "pub" && ($2 == "e" || $2 == "r" || $2 == "u") { print $5 }'
```

- with fingerprint
  ```bash
  $ gpg --list-secret-keys --with-colons --fingerprint
  sec:u:255:22:5**************4:1715138996:::u:::scESC:::+::ed25519:::0:
  fpr:::::::::6AADCD68E268DEF623C4DD7E5**************4:
  grp:::::::::DA2F273B9FCDBCE44E8F5B1590CC29F774C557A5:
  uid:u::::1715138996::689D1C164C7C46F315D0FF60C5CDE6E509C6D853::marslo <marslo@domain.com>::::::::::0:
  ssb:u:255:18:F065036D0FF76ABA:1715138996::::::e:::+::cv25519::
  fpr:::::::::B6550514914F4E14976755BBF065036D0FF76ABA:
  grp:::::::::C55CD6EE8B06EC939090352069AB9D37CFA0C7FA:

  # list fingerprint only
  $ gpg --list-keys --with-colons | awk -F: '$1 == "fpr" { print $10 }'
  6AADCD68E268DEF623C4DD7E5**************4
  B6550514914F4E14976755BBF065036D0FF76ABA

  # or
  $ gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p'
  6AADCD68E268DEF623C4DD7E5**************4
  B6550514914F4E14976755BBF065036D0FF76ABA
  ```

### list public key and account
```bash
$ gpg --list-keys --with-colons |
  awk -F: '
    $1 == "pub" {
      key=""
      for ( i=1;i<=NF;i++ ) if ( $i ~ /[A-F0-9]{16}/ ) key=$i
    }
    $1 == "uid" {
      match( $10, /<([^>]+)>/, m )
      if ( key && m[1] ) print key, m[1]
    }'
91B7E555C9B67240 marslo@work.com
335A865859218D02 marslo@domain.com
```

## remove keys
- remove all keys
  ```bash
  $ gpg --yes --delete-secret-and-public-key "marslo"
  gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.

  sec  ed25519/1**************4 2024-05-08 marslo (marslo) <marslo@domain.com>

  Delete this key from the keyring? (y/N) y
  This is a secret key! - really delete? (y/N) y

  pub  ed25519/1**************4 2024-05-08 marslo (marslo) <marslo@domain.com>
  Delete this key from the keyring? (y/N) y
  ```

- [or via `--batch`](https://superuser.com/a/1631427/112396)
  ```bash
  $ gpg --list-keys --with-colons |
        awk -F: '$1 == "pub" && ($2 == "e" || $2 == "r" || $2 == "u") { print $5 }' |
        xargs gpg --batch --yes --delete-secret-and-public-key
  ```

- [or via fingerprint](https://superuser.com/a/1192732/112396)
  ```bash
  $ gpg --fingerprint --with-colons ${KEY_ID} |
        grep "^fpr" |
        sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |
        xargs gpg --batch --delete-secret-keys
  ```

## backup and restore keys

> [!NOTE|label:references:]
> - [How to export a GPG private key and public key to a file](https://unix.stackexchange.com/a/482559/29178)
> - [Moving GPG Keys Privately](https://vhs.codeberg.page/post/moving-gpg-keys-privately/)

### backup and export
#### backup
- gpg keys
  ```bash
  $ gpg --output <KEY_ID>.sec.gpg --armor --export-secret-keys --export-options export-backup <KEY_ID>
  # or
  $ gpg --output <KEY_ID>.pub.gpg --armor --export --export-options export-backup <KEY_ID>
  ```

- ssh keys
  ```bash
  # -- gpg keys --
  $ gpg --armor --export ${KEY_ID} > ${KEY_ID}-pub.asc
  $ gpg --armor --export-secret-keys ${KEY_ID} > ${KEY_ID}-sec.asc

  # -- ssh public key --
  $ COMMENT='marslo@gpg'
  $ echo "$(gpg --export-ssh-key ${KEY_ID} | cut -d' ' -f1,2) ${COMMENT}" > ~/.ssh/"${COMMENT}".pub

  # -- trust database --
  $ gpg --export-ownertrust > gpg-ownertrust.txt
  ```

#### export
- export public key
  ```bash
  # public key
  $ gpg --output public.gpg --armor --export <KEY_ID>
  # -- check content --
  $ gpg --armor --export <KEY_ID>

  # secret key
  $ gpg --output private.gpg --armor --export-secret-key <KEY_ID>
  # - or -
  $ gpg -o ~/private.asc --export-secret-key <KEY_ID>
  # -- check content --
  $ gpg --armor --export-secret-keys <KEY_ID>
  ```

- [export and ssh](https://unix.stackexchange.com/a/618702/29178)
  ```bash
  $ gpg --export-secret-key <KEY_ID> | ssh othermachine gpg --import
  ```

- [more](https://unix.stackexchange.com/a/618702/29178)
  ```bash
  $ gpg --output public.gpg --export <KEY_ID> && \
    gpg --output - --export-secret-key <KEY_ID> |
        cat public.gpg - |
        gpg --armor --output keys.asc --symmetric --cipher-algo AES256
  ```

### restore and import

> [!NOTE|label:references:]
> - [How to import secret keys into GPG keychain](https://unix.stackexchange.com/a/230859/29178)
> - [pass and gpg: No public key](https://unix.stackexchange.com/a/232341/29178)
> - [How to import secret gpg key (copied from one machine to another)?](https://unix.stackexchange.com/a/184952/29178)

#### restore

- ssh keys
  ```bash
  # gpg keys
  $ gpg --import ./*.asc

  # trust database
  $ gpg --import-ownertrust < gpg-ownertrust.txt
  ```

- import
  ```bash
  # private key
  $ gpg --import private.gpg

  # public key
  $ gpg --import public.gpg
  ```

### trust key

| TRUST LEVEL | DESCRIPTION      |
|-------------|------------------|
| `1`         | Don't know       |
| `2`         | Do NOT trust     |
| `3`         | Marginally trust |
| `4`         | Fully trust      |
| `5` / `6`   | Ultimately trust |

```bash
# i.e.: the 2nd key
$ PUB_KEY_ID=$(gpg --list-keys --with-colons | awk -F: '/^pub:/ {getline; print $10}' | sed -n '2p')
$ echo "${PUB_KEY_ID}:6:" | gpg --import-ownertrust
```

- interactive mode
  ```bash
  $ gpg --edit-key 5**************4 trust quit
    1 = I don't know or won't say
    2 = I do NOT trust
    3 = I trust marginally
    4 = I trust fully
    5 = I trust ultimately
    m = back to the main menu

  gpg> Your decision? 5
  gpg> Do you really want to set this key to ultimate trust? (y/N) y

  # check key again
  $ gpg --list-keys
  gpg: checking the trustdb
  gpg: marginals needed: 3  completes needed: 1  trust model: pgp
  gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
  /home/marslo/.gnupg/pubring.kbx
  -------------------------------
  pub   ed25519 2024-05-08 [SC]
        6AADCD68E268DEF623C4DD7E5**************4
  uid           [ultimate] marslo <marslo@domain.com>
  sub   cv25519 2024-05-08 [E]
  ```

#### recover from backup keys
```bash
$ gpg --import-options restore --import backupkeys.gpg
```

## usage

> [!NOTE|label:references:]
> - [GPG使用方法总结（密钥管理，加解密文件）](https://blog.csdn.net/vic_qxz/article/details/127225478)

### sign file

> [!TIP|label:encrypt string:]
> ```bash
> $ bash -c 'echo "test" | gpg --armor --sign --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02'
> -----BEGIN PGP MESSAGE-----
>
> owGbwMvMwCX2f+O+F6La31wYT3MnMWQuUH9SklpcwtVRysIgxsUgK6bIIhLOmdIc
> cO2/aPV6BZhiViaQSgYuTgGYSO9xRoaT+VctFpu/XOQzm0vuJ0/dyugdq2rbZ767
> a/bgx5HbjP2djAyPn2UvOXtKu6Fo+1yO59uOen3k+rDG8G3T6TmGhadF7Bx4AA==
> =RwCr
> -----END PGP MESSAGE-----
> ```
> check content with gpg info
> ```bash
> $ gpg --list-packets test.sig.txt
> ```

```bash
$ echo 'test' > test.txt

# without `--armor` option, the output file is binary format
$ gpg --sign --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 --output test.sig.txt test.txt
$ file test.sig.txt
test.sig.txt: data
$ cat test.sig.txt | od -c | head -1
0000000   � 001 233   �   �   �   �   %   � 177   �   � 027   �   �   �

# with `--armor` option, the output file is ASCII format
$ gpg --armor --sign --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 --output test.sig.txt test.txt
$ file test.sig.txt
test.sig.txt: PGP message Compressed Data (old)
$ cat test.sig.txt | od -c | head -2
0000000   -   -   -   -   -   B   E   G   I   N       P   G   P       M
0000020   E   S   S   A   G   E   -   -   -   -   -  \n  \n   o   w   G
```

#### sign file with clearsign

> [!TIP]
> - `--clear-sign` / `--clearsign` option is used to create a cleartext signature

```bash
$ echo 'test' > test.txt

# output - `test.txt.asc` (by default)
$ gpg --local-user FFB1BEE8152BF644 --clear-sign test.txt
# output - `test.txt.sig` ( customized )
$ gpg --local-user FFB1BEE8152BF644 --output test.txt.sig --clearsign test.txt

$ ls -Altrh test.txt*
-rw-r--r-- 1 marslo staff   5 Feb 26 02:46 test.txt
-rw-r--r-- 1 marslo staff 282 Feb 26 03:13 test.txt.asc

$ cat test.txt.asc
-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

test
-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQUVwlkg1DW/xV7ryD/sb7oFSv2RAUCaaAqwQAKCRD/sb7oFSv2
RAq5AQCKKpDSn5SG7gcq9/dQegTjALJXYX7HfpZo5fMUF76j5wD/VlRgNggILp09
Ystg6x4mulroIe/i04jqp3Hpwkuu7Q4=
=/B9O
-----END PGP SIGNATURE-----
```

### verify
```bash
$ gpg --verify --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 test.sig.txt
gpg: Signature made Thu Feb 26 03:06:21 2026 PST
gpg:                using EDDSA key 145709648350D6FF157BAF20FFB1BEE8152BF644
gpg: Good signature from "marslo <marslo@domain.com>" [ultimate]

# with details
$ gpg --status-fd=1 --verify --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 test.sig.txt
[GNUPG:] NEWSIG
gpg: Signature made Thu Feb 26 03:28:31 2026 PST
gpg:                using EDDSA key 145709648350D6FF157BAF20FFB1BEE8152BF644
[GNUPG:] KEY_CONSIDERED 7C0BF765E462F5A6C4A45FAF335A865859218D02 0
[GNUPG:] SIG_ID 0LEJonm9f6A4Hyv7rQXOyQsr1tQ 2026-02-26 1772105311
[GNUPG:] GOODSIG FFB1BEE8152BF644 marslo <marslo@domain.com>
gpg: Good signature from "marslo <marslo@domain.com>" [ultimate]
[GNUPG:] VALIDSIG 145709648350D6FF157BAF20FFB1BEE8152BF644 2026-02-26 1772105311 0 4 0 22 10 00 7C0BF765E462F5A6C4A45FAF335A865859218D02
[GNUPG:] KEY_CONSIDERED 7C0BF765E462F5A6C4A45FAF335A865859218D02 0
[GNUPG:] TRUST_ULTIMATE 0 pgp
```

### decrypt file
```bash
$ gpg --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 --output test.out.txt --decrypt test.sig.txt
gpg: Signature made Thu Feb 26 03:28:31 2026 PST
gpg:                using EDDSA key 145709648350D6FF157BAF20FFB1BEE8152BF644
gpg: Good signature from "marslo <marslo@domain.com>" [ultimate]

$ md5sum test.out.txt test.txt
d8e8fca2dc0f896fd7cb4cb0031ba249  test.out.txt
d8e8fca2dc0f896fd7cb4cb0031ba249  test.txt
```

### sign and encrypt file

> [!NOTE|label:references:]
> - local user ( for sign )
>  ```bash
>  $ gpg --list-keys --keyid-format long 7C0BF765E462F5A6C4A45FAF335A865859218D02
>  pub   ed25519/335A865859218D02 2026-02-26 [SCA]
>        7C0BF765E462F5A6C4A45FAF335A865859218D02
>  uid                 [ultimate] marslo <marslo@domain.com>
>  sub   cv25519/A03D9828C2C5B8DC 2026-02-26 [E]
>  sub   ed25519/FFB1BEE8152BF644 2026-02-26 [SA]
>  ```
>
> - recipient ( for encrypt )
>   ```bash
>   $ gpg --list-keys --keyid-format long  302C7795D25A5749FAA7212791B7E555C9B67240
>   pub   ed25519/91B7E555C9B67240 2026-02-26 [SCA]
>         302C7795D25A5749FAA7212791B7E555C9B67240
>   uid                 [ultimate] marslo <marslo@work.com>
>   sub   cv25519/634119494722F716 2026-02-26 [E]
>   ```

- sign and encrypt file
  ```bash
  $ echo 'test' > test.txt

  # sign and encrypt
  $ gpg --armor --sign --encrypt \
        --local-user 7C0BF765E462F5A6C4A45FAF335A865859218D02 \
        --recipient 302C7795D25A5749FAA7212791B7E555C9B67240 \
        --output test.enc.txt \
        test.txt

  # or with LONG_ID
  $ gpg --armor --sign --encrypt \
        --local-user FFB1BEE8152BF644 \
        --recipient 91B7E555C9B67240 \
        --output test.enc.txt \
        test.txt

  $ cat test.enc.txt
  -----BEGIN PGP MESSAGE-----

  hF4DY0EZSUci9xYSAQdA1W9caMvcD88Lf3tiTekuIvOuS8evHPPnfVLqxprr+www
  gCoZyUJRaQqqABqopJz3eWekC0bNidjLaprj8urmugweuyUVlgUMLzz4tBc4/wPu
  1MANAQkCENPL2MlAuISRKfH3Q/P5EdL/2tVcpLWnN+GnuxwQJd/IKPPKtVdpXjh2
  tNylc2kzZQx3PGdpzrGm8sDublWSO/xu/MyiCXt4UvqdRoHZt+l5GbGhCr60IvkR
  Cms4O/8CuKCUFL1iu3m0rrwoUWP7SHynaHb1rmCi/t9QZhv8rTq21zC0O1+s4pjz
  hWxmAi/8fR90n/jN8XSMnjva/W5/85eISfLNxHxjIEeDYGghy5TX9Gv5CxxYvNvI
  7bASbvqs3odqbxvDPfrqiQ==
  =8FtL
  -----END PGP MESSAGE-----
  ```

- decrypt and verify file
  ```bash
  $ gpg --local-user 91B7E555C9B67240 --output test.out.txt --decrypt test.enc.txt
  gpg: encrypted with cv25519 key, ID 634119494722F716, created 2026-02-26
        "marslo <marslo@work.com>"
  gpg: Signature made Thu Feb 26 02:49:18 2026 PST
  gpg:                using EDDSA key 145709648350D6FF157BAF20FFB1BEE8152BF644
  gpg: Good signature from "marslo <marslo@domain.com>" [ultimate]

  $ cat test.out.txt
  test

  $ sha256sum test.out.txt test.txt
  f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2  test.out.txt
  f2ca1bb6c7e907d06dafe4687e579fce76b37e4e93b7605022da52e6ccc26fd2  test.txt
  ```

### git ssh commit signing

> [!NOTE|label:references:]
> - check details in [* iMarslo: gpg ssh commit signing*](./ssh.md)
