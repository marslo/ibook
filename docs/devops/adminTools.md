<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [encryption](#encryption)
  - [gpg](#gpg)
    - [basic knowledge](#basic-knowledge)
    - [create new key](#create-new-key)
    - [list keys](#list-keys)
    - [remove keys](#remove-keys)
    - [export/import keys](#exportimport-keys)
    - [usage](#usage)
  - [pass](#pass)
    - [env](#env)
    - [insert](#insert)
    - [generate](#generate)
    - [remove](#remove)
    - [advanced usage](#advanced-usage)
  - [PGP](#pgp)
  - [passwd](#passwd)
- [network tools](#network-tools)
  - [`vnstat`](#vnstat)
  - [`ipcalc`](#ipcalc)
  - [`iostat`](#iostat)
  - [`tcpdump`](#tcpdump)
  - [`dstat`](#dstat)
  - [strace](#strace)
  - [`dtruss`](#dtruss)
  - [sar](#sar)
  - [netcat](#netcat)
  - [`ip`](#ip)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='top' %}
> references:
> - [20 Command Line Tools to Monitor Linux Performance](http://www.tecmint.com/command-line-tools-to-monitor-linux-performance/)
> - [20 Linux System Monitoring Tools Every SysAdmin Should Know](http://www.cyberciti.biz/tips/top-linux-monitoring-tools.html)
> - [Top 25 Best Linux Performance Monitoring and Debugging Tools](http://thegeekstuff.com/2011/12/linux-performance-monitoring-tools/)
> - [http://www.thegeekstuff.com/2010/12/50-unix-linux-sysadmin-tutorials](http://www.thegeekstuff.com/2010/12/50-unix-linux-sysadmin-tutorials/)
> - [16 commands to check hardware information on Linux](http://www.binarytides.com/linux-commands-hardware-info/)
> - [Best UNIX shell-based tools](https://gist.github.com/mbbx6spp/1429161)
> - [* alebcay/awesome-shell](https://github.com/alebcay/awesome-shell/tree/master)
>   - [* zh-cn](https://github.com/alebcay/awesome-shell/blob/master/README_ZH-CN.md)
>   - [nosarthur/awesome-shell](https://github.com/nosarthur/awesome-shell)
> - [* rockerBOO/awesome-neovim](https://github.com/rockerBOO/awesome-neovim)
> - [jlevy/the-art-of-command-line](https://github.com/jlevy/the-art-of-command-line)
> - [Learn Enough Command Line to Be Dangerous](https://www.learnenough.com/command-line-tutorial/basics)
> - [Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
> - [Use Bash Strict Mode (Unless You Love Debugging)](http://redsymbol.net/articles/unofficial-bash-strict-mode/)
> - others
>   - [bayandin/awesome-awesomeness](https://github.com/bayandin/awesome-awesomeness)
>   - [emijrp/awesome-awesome](https://github.com/emijrp/awesome-awesome)
>   - [kahun/awesome-sysadmin](https://github.com/kahun/awesome-sysadmin)
> - [My Minimalist Over-powered Linux Setup Guide](https://medium.com/@jonyeezs/my-minimal-over-powered-linux-setup-guide-710931efb75b)
> - [* devynspencer/cute_commands.sh](https://gist.github.com/devynspencer/cfdce35b3230e72214ef)
{% endhint %}

# encryption
## gpg

> [!NOTE|label:references:]
> - [* The GNU Privacy Handbook](https://www.gnupg.org/gph/en/manual.html)
> - [* The GNU Privacy Guard Manual](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
> - [GPG入门教程](https://www.ruanyifeng.com/blog/2013/07/gpg.html)
> - [GPG(GnuPG)入门 ](https://www.cnblogs.com/time-is-life/p/9668999.html)
> - [FlowCrypt: PGP Encryption for Gmail](https://flowcrypt.com/)

### basic knowledge

- [letters indicating](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)

  > [!TIP|label:references:]
  > - [简明 GPG 概念](https://zhuanlan.zhihu.com/p/137801979)
  > - GPG 密钥的能力中， [C]、[S]、[A] 均属于签名方案，只有 [E] 是加密方案
  > - [The GNU Privacy Guard Manual  : 4.2.1 How to change the configuration](https://www.gnupg.org/documentation/manuals/gnupg/GPG-Configuration-Options.html)
  > - [OpenPGP Message Format : 5.2.3.21.  Key Flags](https://www.rfc-editor.org/rfc/rfc4880#section-5.2.3.21)
  > - [How are the GPG usage flags defined in the key details listing?](https://unix.stackexchange.com/a/230859/29178)
  > - [Anatomy of a GPG Key](https://davesteele.github.io/gpg/2014/09/20/anatomy-of-a-gpg-key/)


  | LETTER | MEANING       | flag             | CONSTANT          | COMMENTS                                      |
  |--------|---------------|------------------|-------------------|-----------------------------------------------|
  | `[C]`  | Certification | `0x01`           | PUBKEY_USAGE_CERT | 认证其他秘钥/给其他证书签名                   |
  | `[S]`  | Signing       | `0x02`           | PUBKEY_USAGE_SIG  | 签名,如给文件添加数字签名, 给 git commit 签名 |
  | `[A]`  | Authenticate  | `0x20`           | PUBKEY_USAGE_AUTH | 身份验证, 如 ssh 登录                         |
  | `[E]`  | Encryption    | `0x04` or `0x08` | PUBKEY_USAGE_ENC  | 加密, 如给文件加密, 给邮件加密                |


### create new key

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

### list keys
- secret keys
  ```bash
  $ gpg --list-secret-keys --keyid-format=long
  gpg: checking the trustdb
  gpg: marginals needed: 3  completes needed: 1  trust model: pgp
  gpg: depth: 0  valid:   1  signed:   0  trust: 0-, 0q, 0n, 0m, 0f, 1u
  [keyboxd]
  ---------
  sec   ed25519/505104FC7CD6CA33 2024-05-08 [SC]
        00D2F41050BF7D9BE6B27545505104FC7CD6CA33
  uid                 [ultimate] marslo <marslo.jiao@gmail.com>
  ssb   cv25519/188C36434D6B9F66 2024-05-08 [E]
  ```

- public keys
  ```bash
  $ gpg --list-public-keys --keyid-format=long
  [keyboxd]
  ---------
  pub   ed25519/5C0980808D968494 2024-05-08 [SC]
        6AADCD68E268DEF623C4DD7E5C0980808D968494
  uid                 [ultimate] marslo <marslo.jiao@gmail.com>
  sub   cv25519/F065036D0FF76ABA 2024-05-08 [E]
  ```

- list KEYID
  ```bash
  $ gpg --list-keys --with-colons |
        awk -F: '$1 == "pub" && ($2 == "e" || $2 == "r" || $2 == "u") { print $5 }'
  ```

- with fingerprint
  ```bash
  $ gpg --list-secret-keys --with-colons --fingerprint
  sec:u:255:22:5C0980808D968494:1715138996:::u:::scESC:::+::ed25519:::0:
  fpr:::::::::6AADCD68E268DEF623C4DD7E5C0980808D968494:
  grp:::::::::DA2F273B9FCDBCE44E8F5B1590CC29F774C557A5:
  uid:u::::1715138996::689D1C164C7C46F315D0FF60C5CDE6E509C6D853::marslo <marslo.jiao@gmail.com>::::::::::0:
  ssb:u:255:18:F065036D0FF76ABA:1715138996::::::e:::+::cv25519::
  fpr:::::::::B6550514914F4E14976755BBF065036D0FF76ABA:
  grp:::::::::C55CD6EE8B06EC939090352069AB9D37CFA0C7FA:

  # list fingerprint only
  $ gpg --list-keys --with-colons | awk -F: '$1 == "fpr" { print $10 }'
  6AADCD68E268DEF623C4DD7E5C0980808D968494
  B6550514914F4E14976755BBF065036D0FF76ABA

  # or
  $ gpg --list-secret-keys --with-colons --fingerprint | sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p'
  6AADCD68E268DEF623C4DD7E5C0980808D968494
  B6550514914F4E14976755BBF065036D0FF76ABA
  ```

### remove keys
- remove all keys
  ```bash
  $ gpg --yes --delete-secret-and-public-key "marslo"
  gpg (GnuPG) 2.4.5; Copyright (C) 2024 g10 Code GmbH
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.

  sec  ed25519/133597088DEF3074 2024-05-08 marslo (marslo) <marslo.jiao@gmail.com>

  Delete this key from the keyring? (y/N) y
  This is a secret key! - really delete? (y/N) y

  pub  ed25519/133597088DEF3074 2024-05-08 marslo (marslo) <marslo.jiao@gmail.com>
  Delete this key from the keyring? (y/N) y
  ```

- [or via `--batch`](https://superuser.com/a/1631427/112396)
  ```bash
  $ gpg --list-keys --with-colons \
      | awk -F: '$1 == "pub" && ($2 == "e" || $2 == "r" || $2 == "u") { print $5 }' \
      | xargs gpg --batch --yes --delete-secret-and-public-key
  ```

- [or via fingerprint](https://superuser.com/a/1192732/112396)
  ```bash
  $ gpg --fingerprint --with-colons ${GPG_KEY} |\
        grep "^fpr" |\
        sed -n 's/^fpr:::::::::\([[:alnum:]]\+\):/\1/p' |\
        xargs gpg --batch --delete-secret-keys
  ```

### export/import keys

> [!NOTE|label:references:]
> - [How to export a GPG private key and public key to a file](https://unix.stackexchange.com/a/482559/29178)
> - [Moving GPG Keys Privately](https://vhs.codeberg.page/post/moving-gpg-keys-privately/)

#### export
- export public key
  ```bash
  $ gpg --output public.pgp --armor --export <KEYID>
  ```

  - check content
    ```bash
    $ gpg --armor --export <KEYID>

    # i.e.:
    $ gpg --armor --export marslo
    -----BEGIN PGP PUBLIC KEY BLOCK-----
    ...
    -----END PGP PUBLIC KEY BLOCK-----
    ```

- export secret key
  ```bash
  $ gpg --output private.pgp --armor --export-secret-key <KEYID>
  # or
  $ gpg -o ~/private.asc --export-secret-key <KEYID>
  ```

  - [export and ssh](https://unix.stackexchange.com/a/618702/29178)
    ```bash
    $ gpg --export-secret-key SOMEKEYID | ssh othermachine gpg --import
    ```

  - [more](https://unix.stackexchange.com/a/618702/29178)
    ```bash
    $ gpg --output public.gpg --export SOMEKEYID && \
    $ gpg --output - --export-secret-key SOMEKEYID |\
          cat public.gpg - |\
          gpg --armor --output keys.asc --symmetric --cipher-algo AES256
    ```

  - check content
    ```bash
    $ gpg --armor --export-secret-keys <KEYID>

    # i.e.:
    $ gpg --armor --export-secret-keys marslo
    -----BEGIN PGP PRIVATE KEY BLOCK-----
    ...
    -----END PGP PRIVATE KEY BLOCK-----
    ```

- backup keys
  ```bash
  $ gpg --output backupkeys.pgp --armor --export-secret-keys --export-options export-backup <KEYID>
  # or
  $ gpg --output backupkeys.pgp --armor --export --export-options export-backup <KEYID>
  ```

#### import

> [!NOTE|label:references:]
> - [How to import secret keys into GPG keychain](https://unix.stackexchange.com/a/230859/29178)
> - [pass and gpg: No public key](https://unix.stackexchange.com/a/232341/29178)
> - [How to import secret gpg key (copied from one machine to another)?](https://unix.stackexchange.com/a/184952/29178)

```bash
# import private key
$ gpg --import private.pgp
gpg: /home/marslo/.gnupg/trustdb.gpg: trustdb created
gpg: key 5C0980808D968494: public key "marslo <marslo.jiao@gmail.com>" imported
gpg: key 5C0980808D968494: secret key imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg:       secret keys read: 1
gpg:   secret keys imported: 1

# list keys
$ gpg --list-keys
/home/marslo/.gnupg/pubring.kbx
-------------------------------
pub   ed25519 2024-05-08 [SC]
      6AADCD68E268DEF623C4DD7E5C0980808D968494
uid           [ unknown] marslo <marslo.jiao@gmail.com>
sub   cv25519 2024-05-08 [E]

# trust
$ gpg --edit-key 6AADCD68E268DEF623C4DD7E5C0980808D968494 trust quit
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
      6AADCD68E268DEF623C4DD7E5C0980808D968494
uid           [ultimate] marslo <marslo.jiao@gmail.com>
sub   cv25519 2024-05-08 [E]
```

- import publid key
  ```bash
  # import public key
  $ gpg --import public.pgp
  gpg: key 5C0980808D968494: "marslo <marslo.jiao@gmail.com>" not changed
  gpg: Total number processed: 1
  gpg:              unchanged: 1
  ```

- trust key
  ```bash
  # verify available
  $ gpg --edit-key <KEYID>

  # trust
  $ gpg --edit-key <KEYID>
  gpg> trust
  gpg> save
  gpg> quit
  ```

- recover from backup keys
  ```bash
  $ gpg --import-options restore --import backupkeys.pgp
  ```

### usage

> [!NOTE|label:references:]
> - [GPG使用方法总结（密钥管理，加解密文件）](https://blog.csdn.net/vic_qxz/article/details/127225478)

## pass

> [!NOTE]
> - [pass: the standard unix password manager](https://www.passwordstore.org/)
> - [git repo: password-store](https://git.zx2c4.com/password-store/)
> - [video: How to Use Pass Which Is a Command Line Password Manager](https://www.youtube.com/watch?v=w34xAnNdliE)
> - [How to Use Pass Which Is a Command Line Password Manager](https://nickjanetakis.com/blog/how-to-use-pass-which-is-a-command-line-password-manager)
> - [archlinux: pass](https://wiki.archlinux.org/title/Pass)
> - [compatible clients](https://www.passwordstore.org/#other)
> - [Clever uses of pass, the Unix password manager](https://vitalyparnas.com/guides/pass/#generate)
> - [Configuring Pass, the Standard Unix Password Manager](https://ryan.himmelwright.net/post/setting-up-pass/)

### env

> [!NOTE|label:references:]
> - [completion](https://git.zx2c4.com/password-store/tree/src/completion)

```bash
$ export PASSWORD_STORE_DIR=~/.password-store
```

- install
  ```bash
  # osx
  $ brew install pass

  # ubuntu/debian
  $ sudo apt-get install pass

  # fedora/rhel
  $ sudo yum install pass
  ```

- init

  > [!TIP|label:references:]
  > - [How to manage Linux passwords with the pass command](https://www.redhat.com/sysadmin/management-password-store)
  > - [I try to add passwords to the "pass" password manager. But my attempts fail with "no public key" GPG errors. Why?]()
  > - to avoid the issue like:
  >   ```bash
  >   $ pass generate test 30
  >   gpg: marslo: skipped: No public key
  >   gpg: [stdin]: encryption failed: No public key
  >   Password encryption aborted.
  >   ```

  ```bash
  $ gpg --full-generate-key
  ```

### insert
```bash
$ pass insert <NAME>

# i.e.:
$ pass insert test
Enter password for test: abc
Retype password for test: abc
$ pass test
abc

# copy
$ pass -c test
Copied test to clipboard. Will clear in 45 seconds.
```

![pass insert](../screenshot/linux/cmd-pass-insert.gif)


### generate

> [!NOTE|label:references:]
> - [PASSWORD_STORE_CHARACTER_SET_NO_SYMBOLS isn't respected](https://lists.zx2c4.com/pipermail/password-store/2018-January/003170.html)
> - [[pass] Provide symbol set as command line argument](https://lists.zx2c4.com/pipermail/password-store/2016-November/002429.html)
> - [How to generate secure passwords using terminal (Mac/Linux) ?](https://mnzel.medium.com/how-to-generate-secure-passwords-using-terminal-mac-linux-3e823cff3cac#:~:text=Simply%2C%20type%20in%20pwgen%20on,generate%20a%20list%20of%20passwords.&text=The%20above%20command%20will%20generate%204%20secured%20passwords%20with%2010,at%20least%201%20special%20character.)
> - [default and envs](https://git.zx2c4.com/password-store/tree/src/password-store.sh)
>   - `PASSWORD_STORE_DIR=$HOME/.password-store`
>   - `PASSWORD_STORE_EXTENSIONS_DIR=${PASSWORD_STORE_DIR}/.extensions`
>   - `PASSWORD_STORE_CLIP_TIME=45`
>   - `PASSWORD_STORE_GENERATED_LENGTH=25`
>   - others:
>     - `PASSWORD_STORE_CHARACTER_SET='[:alnum:].,!?&*%_~$#^@{}[]()<>|=/\+-'`
> - [Vim: word vs WORD](https://stackoverflow.com/a/54588479/2940319)
>
>   ![WORD VS. word](https://i.stack.imgur.com/7AZo6.png)

- customize charset
  ```bash
  $ export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9'
  $ yes | pass generate test 30
  The generated password for test is:
  HnD7XyeFDtOrw5oDhn22U8AjHVV9cf
  $ yes | pass generate test 30
  The generated password for test is:
  t57PYCw4r0tHSXCa4zW2DVGNuizQ1k

  $ export PASSWORD_STORE_CHARACTER_SET='a-zA-Z0-9()'
  $ yes | pass generate test 50
  The generated password for test is:
  wof1Hw92QXe(G3)MkMRp5Wx3UCMgHIpt)7ENNn(f8r(ZRcztQ1
  $ yes | pass generate test 30
  The generated password for test is:
  60m2XHtqfTsvfJT(YYV1wKlBBoOJYb
  ```

- generate qrcode
  ```bash
  $ pass generate <name> --qrcode
  ```

- [generate via `/dev/urandom`](https://lists.zx2c4.com/pipermail/password-store/2016-November/002429.html)
  ```bash
  $ head /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c 32 && echo
  xGPqC%MeE2HU3NkH#JeA##RB^YbX49cd

  $ head /dev/urandom | tr -dc 'A-Za-z0-9!@#$%^&*()' | head -c 32 && echo
  6yeV1yy%3h4V!KHLf5e0vNAIl5oD#s!W

  $ head /dev/urandom | tr -dc 'A-Za-z0-9!"#$%&'\''()*+,-./:;<=>?@[\]^_`{|}~' | head -c 32 && echo
  +&7<o(zfE[WC30v'D[&RH~;qM-8J>oQC
  ```

### remove
```bash
$ pass rm test -f
removed '/Users/marslo/.marslo/.password-store/test.gpg'
```

### advanced usage

> [!NOTE|label:references:]
> - extensions
>   - [roddhjav/pass-tomb](https://github.com/roddhjav/pass-tomb)
>   - [tadfisher/pass-otp)](https://github.com/tadfisher/pass-otp)
>   - [roddhjav/pass-import](https://github.com/roddhjav/pass-import)
>   - [roddhjav/pass-update](https://github.com/roddhjav/pass-update)
>   - [roddhjav/pass-audit](https://github.com/roddhjav/pass-audit)
>   - [ayushnix/pass-coffin](https://github.com/ayushnix/pass-coffin)
>   - [ayushnix/pass-tessen](https://github.com/ayushnix/pass-tessen)

- pw
  ```bash
  pw() {
    export PASSWORD_STORE_CLIP_TIME=8
    export PASSWORD_STORE_X_SELECTION=primary
    pass -c2 $1; sleep 5; pass -c $1; sleep 5; pass otp -c $1; exit
  }
  ```

- extend

  ```bash
  # ~/.bashrc
  $ alias passred="PASSWORD_STORE_DIR=~/.pass/red pass"
  $ alias passblue="PASSWORD_STORE_DIR=~/.pass/blue pass"

  $ cat /usr/share/bash-completion/completions/pass
  _passred(){
      PASSWORD_STORE_DIR=~/.pass/red/ _pass
  }
  complete -o filenames -o nospace -F _passred passred
  _passblue(){
      PASSWORD_STORE_DIR=~/.pass/blue/ _pass
  }
  complete -o filenames -o nospace -F _passblue passblue
  $ source /usr/share/bash-completion/completions/pass
  ```

- git
  ```bash
  $ git config --global credential.helper /usr/bin/pass-git-helper

  $ cat ~/.gitconfig
  [github.com]
  target=dev/github

  [*.fooo-bar.*]
  target=dev/fooo-bar
  ```

  - client
    ```bash
    # create local password store
    $ pass init <gpg key id>
    # enable management of local changes through git
    $ pass git init
    # add the the remote git repository as 'origin'
    $ pass git remote add origin user@server:~/.password-store
    # push your local pass history
    $ pass git push -u --all
    ```

## PGP

> [!NOTE|label:references:]
> - Protecting Code Integrity with PGP
>   - [Protecting Code Integrity with PGP — Part 1: Basic Concepts and Tools](https://www.linux.com/news/protecting-code-integrity-pgp-part-1-basic-pgp-concepts-and-tools/) | [用 PGP 保护代码完整性（一）： 基本概念和工具](https://linux.cn/article-9524-1.html)
>   - [Protecting Code Integrity with PGP — Part 2: Generating Your Master Key](https://www.linux.com/news/protecting-code-integrity-pgp-part-2-generating-and-protecting-your-master-pgp-key/) | [用 PGP 保护代码完整性（二）：生成你的主密钥](https://linux.cn/article-9529-1.html)
>   - [Protecting Code Integrity with PGP — Part 3: Generating PGP Subkeys](https://www.linux.com/news/protecting-code-integrity-pgp-part-3-generating-pgp-subkeys/) | [用 PGP 保护代码完整性（三）：生成 PGP 子密钥](https://linux.cn/article-9607-1.html)
>   - [Protecting Code Integrity with PGP — Part 4: Moving Your Master Key to Offline Storage](https://www.linux.com/news/protecting-code-integrity-pgp-part-4-moving-your-master-key-offline-storage/) | [用 PGP 保护代码完整性（四）：将主密钥移到离线存储中](https://linux.cn/article-10402-1.html)
>   - [Protecting Code Integrity with PGP — Part 5: Moving Subkeys to a Hardware Device](https://www.linux.com/training-tutorials/protecting-code-integrity-pgp-part-5-moving-subkeys-hardware-device) | [用 PGP 保护代码完整性（五）：将子密钥移到一个硬件设备中](https://linux.cn/article-10415-1.html)
>   - [Protecting Code Integrity with PGP — Part 6: Using PGP with Git](https://www.linux.com/news/protecting-code-integrity-pgp-part-6-using-pgp-git/) | [用 PGP 保护代码完整性（六）：在 Git 上使用 PGP](https://linux.cn/article-10421-1.html)
>   - [Protecting Code Integrity with PGP — Part 7: Protecting Online Accounts](https://www.linux.com/news/protecting-code-integrity-pgp-part-7-protecting-online-accounts/) | [用 PGP 保护代码完整性（七）：保护在线帐户](https://linux.cn/article-10432-1.html)


## passwd

> [!NOTE|label:references:]
> - [Managing Linux users with the passwd command](https://www.redhat.com/sysadmin/managing-users-passwd)

# network tools

> [!NOTE|label:see also:]
> - [iMarslo : linux/network](../linux/network.html)

## `vnstat`

![vnstat](../screenshot/linux/vnstat.png)

```bash
$ vnstat -l 1 -i en7
Monitoring en7...    (press CTRL-C to stop)

   rx:     4.10 kbit/s   21.00 KiB          tx:         0 bit/s   6.00 KiB^C

 en7  /  traffic statistics
                           rx         |       tx
--------------------------------------+------------------
  bytes                    21.00 KiB  |        6.00 KiB
--------------------------------------+------------------
          max           53.25 kbit/s  |    12.29 kbit/s
      average           17.20 kbit/s  |     4.92 kbit/s
          min                0 bit/s  |         0 bit/s
--------------------------------------+------------------
  packets                         60  |              52
--------------------------------------+------------------
          max                 15 p/s  |          16 p/s
      average                  6 p/s  |           5 p/s
          min                  2 p/s  |           0 p/s
--------------------------------------+------------------
  time                    10 seconds
```

## `ipcalc`

![ipcalc](../screenshot/linux/ipcalc.png)

```bash
$ ipcalc 10.25.130.2/23
Address:   10.25.130.2          00001010.00011001.1000001 0.00000010
Netmask:   255.255.254.0 = 23   11111111.11111111.1111111 0.00000000
Wildcard:  0.0.1.255            00000000.00000000.0000000 1.11111111
=>
Network:   10.25.130.0/23       00001010.00011001.1000001 0.00000000
HostMin:   10.25.130.1          00001010.00011001.1000001 0.00000001
HostMax:   10.25.131.254        00001010.00011001.1000001 1.11111110
Broadcast: 10.25.131.255        00001010.00011001.1000001 1.11111111
Hosts/Net: 510                   Class A, Private Internet

$ ipcalc 10.25.131.1/23
Address:   10.25.131.1          00001010.00011001.1000001 1.00000001
Netmask:   255.255.254.0 = 23   11111111.11111111.1111111 0.00000000
Wildcard:  0.0.1.255            00000000.00000000.0000000 1.11111111
=>
Network:   10.25.130.0/23       00001010.00011001.1000001 0.00000000
HostMin:   10.25.130.1          00001010.00011001.1000001 0.00000001
HostMax:   10.25.131.254        00001010.00011001.1000001 1.11111110
Broadcast: 10.25.131.255        00001010.00011001.1000001 1.11111111
Hosts/Net: 510                   Class A, Private Internet
```

## `iostat`
```bash
$ iostat
              disk0       cpu    load average
    KB/t  tps  MB/s  us sy id   1m   5m   15m
   19.85   37  0.72   3  1 96  1.78 1.90 1.69
```

## `tcpdump`

> [!NOTE|label:references:]
> - [* Tcpdump](https://www.kancloud.cn/pshizhsysu/linux/1799754)

```bash
$ sudo tcpdump -A -i en7
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on en7, link-type EN10MB (Ethernet), capture size 262144 bytes
00:33:02.787671 IP 10.25.130.117.53629 > a23-43-240-92.deploy.static.akamaitechnologies.com.https: Flags [.], ack 697481089, win 2048, length 0
E..(....@...
..u.+.\.}..r...)...P...:...
00:33:02.790119 IP 10.25.130.117.51541 > sh-vdc01.mycompany.com.domain: 53089+ PTR? 92.240.43.23.in-addr.arpa. (43)
E..GP....._.
..u
&t..U.5.3...a...........92.240.43.23.in-addr.arpa.....
00:33:02.812866 ARP, Request who-has gw-voice-idf.cdu-cn.mycompany.com tell gw-vg224-idf.cdu-cn.mycompany.com, length 46
....
....
13 packets captured
25 packets received by filter
0 packets dropped by kernel
```

- [or](https://superuser.com/a/1567926/112396)
  ```bash
  $ sudo tcpdump -n -i any src or dst target.ip.address [ -v ]

  # i.e.
  $ sudo tcpdump -n -i any src or dst git.domain.com -v
  tcpdump: data link type PKTAP
  tcpdump: listening on any, link-type PKTAP (Apple DLT_PKTAP), snapshot length 524288 bytes
  00:02:55.698822 IP (tos 0x0, ttl 64, id 0, offset 0, flags [DF], proto TCP (6), length 52)
      10.25.130.104.63447 > 10.69.78.140.29418: Flags [F.], cksum 0x8fe0 (correct), seq 2566890566, ack 4019765769, win 2058, options [nop,nop,TS val 1955309758 ecr 154499413], length 0
  ```

## `dstat`

![dstat](../screenshot/linux/dstat.png)

## strace

> [!NOTE|label:references:]
> - [I have a tab completion that hangs, is it possible to use strace to find out what is going on?](https://unix.stackexchange.com/a/525582/29178)
> - [Resolve nested aliases to their source commands](https://unix.stackexchange.com/a/441389/29178)

```bash
$ ... run cmd ...

# or
$ pid=$(echo ??)
$ sudo strace -fp ${pid} -o log

# or
$ sudo -v
$ sudo strace -fp $$ -o log &
```

- more
  ```bash
  $ set -o functrace xtrace
  $ PS4=' ${BASH_SOURCE}:$FUNCNAME:$LINENO: '
  ```

- [debug script](https://askubuntu.com/a/678919/92979)

  <!--sec data-title="debug script" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  $ strace -e clone,execve,pipe,dup2 \
           -f bash -c 'cat <(/bin/true) <(/bin/false) <(/bin/echo)'
  execve("/usr/bin/bash", ["bash", "-c", "cat <(/bin/true) <(/bin/false) <"...], 0x7fff9b9c6f98 /* 75 vars */) = 0
  pipe([3, 4])                            = 0
  dup2(3, 63)                             = 63
  clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7cf6a8ca10) = 289963
  strace: Process 289963 attached
  [pid 289962] pipe([3, 4])               = 0
  [pid 289962] dup2(3, 62)                = 62
  [pid 289962] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289963] dup2(4, 1)                 = 1
  [pid 289962] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289964
  strace: Process 289964 attached
  [pid 289963] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289962] pipe([3, 4])               = 0
  strace: Process 289965 attached
  [pid 289963] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289965
  [pid 289962] dup2(3, 61)                = 61
  [pid 289962] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289964] dup2(4, 1)                 = 1
  [pid 289965] execve("/bin/true", ["/bin/true"], 0x55ec7c007680 /* 73 vars */strace: Process 289966 attached
   <unfinished ...>
  [pid 289962] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289966
  [pid 289964] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD <unfinished ...>
  [pid 289965] <... execve resumed>)      = 0
  strace: Process 289967 attached
  [pid 289964] <... clone resumed>, child_tidptr=0x7f7cf6a8ca10) = 289967
  [pid 289966] dup2(4, 1)                 = 1
  [pid 289967] execve("/bin/false", ["/bin/false"], 0x55ec7c007af0 /* 73 vars */ <unfinished ...>
  [pid 289966] clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7f7cf6a8ca10) = 289968
  [pid 289967] <... execve resumed>)      = 0
  strace: Process 289968 attached
  [pid 289962] execve("/usr/bin/cat", ["cat", "/dev/fd/63", "/dev/fd/62", "/dev/fd/61"], 0x55ec7c007bc0 /* 73 vars */ <unfinished ...>
  [pid 289968] execve("/bin/echo", ["/bin/echo"], 0x55ec7c007e20 /* 73 vars */ <unfinished ...>
  [pid 289962] <... execve resumed>)      = 0
  [pid 289968] <... execve resumed>)      = 0
  [pid 289965] +++ exited with 0 +++
  [pid 289963] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289965, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289963] +++ exited with 0 +++
  [pid 289962] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289963, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289967] +++ exited with 1 +++
  [pid 289964] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289967, si_uid=10564, si_status=1, si_utime=0, si_stime=0} ---
  [pid 289964] +++ exited with 1 +++
  [pid 289962] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289964, si_uid=10564, si_status=1, si_utime=0, si_stime=0} ---

  [pid 289968] +++ exited with 0 +++
  [pid 289966] --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289968, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  [pid 289966] +++ exited with 0 +++
  --- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=289966, si_uid=10564, si_status=0, si_utime=0, si_stime=0} ---
  +++ exited with 0 +++
  ```
  <!--endsec-->

- [xtrace](https://unix.stackexchange.com/a/441389/29178)
  ```bash
  xtrace() {
      local eval_cmd
      printf -v eval_cmd '%q' "${@}"
      { set -x
        eval "${eval_cmd}"
      } 2>&1 | grep '^++'
      return "${PIPESTATUS[0]}"
  }
  ```

## [`dtruss`](https://stackoverflow.com/a/31045613/2940319)

> [!TIP]
> - the MacOS alternatives `strace`
> - [Using modified dtruss.sh](https://stackoverflow.com/q/73724074/2940319)

```bash
$ sudo dtruss <cmd>
```

<!--sec data-title="sudo dtruss ls" data-id="section1" data-show=true data-collapse=true ces-->
```bash
$ sudo dtruss ls
dtrace: system integrity protection is on, some features will not be available

SYSCALL(args)      = return
README.md   artifactory  devops   jenkins  osx    screenshot  vim
SUMMARY.md  cheatsheet   english  linux    programming  tools     virtualization
munmap(0x1155AB000, 0xA0000)     = 0 0
munmap(0x11564B000, 0x8000)    = 0 0
munmap(0x115653000, 0x4000)    = 0 0
munmap(0x115657000, 0x4000)    = 0 0
munmap(0x11565B000, 0x58000)     = 0 0
fsgetpath(0x7FF7BA418580, 0x400, 0x7FF7BA418568)     = 40 0
fsgetpath(0x7FF7BA418580, 0x400, 0x7FF7BA418568)     = 14 0
csrctl(0x0, 0x7FF7BA41898C, 0x4)     = -1 1
__mac_syscall(0x7FF819AD4E1B, 0x2, 0x7FF7BA4187F0)     = 0 0
csrctl(0x0, 0x7FF7BA41899C, 0x4)     = -1 1
__mac_syscall(0x7FF819AD1DA4, 0x5A, 0x7FF7BA418930)    = 0 0
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
open("/\0", 0x20100000, 0x0)     = 3 0
openat(0x3, "System/Cryptexes/OS\0", 0x100000, 0x0)    = 4 0
dup(0x4, 0x0, 0x0)     = 5 0
fstatat64(0x4, 0x7FF7BA4176D1, 0x7FF7BA417AD0)     = 0 0
openat(0x4, "System/Library/dyld/\0", 0x100000, 0x0)     = 6 0
fcntl(0x6, 0x32, 0x7FF7BA417760)     = 0 0
dup(0x6, 0x0, 0x0)     = 7 0
dup(0x5, 0x0, 0x0)     = 8 0
close(0x3)     = 0 0
close(0x5)     = 0 0
close(0x4)     = 0 0
close(0x6)     = 0 0
shared_region_check_np(0x7FF7BA418048, 0x0, 0x0)     = 0 0
fsgetpath(0x7FF7BA4185B0, 0x400, 0x7FF7BA4184E8)     = 83 0
fcntl(0x8, 0x32, 0x7FF7BA4185B0)     = 0 0
close(0x8)     = 0 0
close(0x7)     = 0 0
getfsstat64(0x0, 0x0, 0x2)     = 9 0
getfsstat64(0x106102040, 0x4C38, 0x2)    = 9 0
getattrlist("/\0", 0x7FF7BA4184F0, 0x7FF7BA418460)     = 0 0
stat64("/System/Volumes/Preboot/Cryptexes/OS/System/Library/dyld/dyld_shared_cache_x86_64h\0", 0x7FF7BA418828, 0x0)    = 0 0
dtrace: error on enabled probe ID 1690 (ID 845: syscall::stat64:return): invalid address (0x0) in action #11 at DIF offset 12
stat64("/usr/local/Cellar/coreutils/9.4/bin/gls\0", 0x7FF7BA417CC0, 0x0)     = 0 0
open("/usr/local/Cellar/coreutils/9.4/bin/gls\0", 0x0, 0x0)    = 3 0
mmap(0x0, 0x33358, 0x1, 0x40002, 0x3, 0x0)     = 0x105B18000 0
fcntl(0x3, 0x32, 0x7FF7BA417DD0)     = 0 0
close(0x3)     = 0 0
munmap(0x105B18000, 0x33358)     = 0 0
stat64("/usr/local/Cellar/coreutils/9.4/bin/gls\0", 0x7FF7BA418220, 0x0)     = 0 0
stat64("/usr/lib/libSystem.B.dylib\0", 0x7FF7BA417230, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/libSystem.B.dylib\0", 0x7FF7BA4171E0, 0x0)    = -1 2
stat64("/usr/lib/libSystem.B.dylib\0", 0x7FF7BA417230, 0x0)    = -1 2
stat64("/usr/lib/libobjc.A.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/libobjc.A.dylib\0", 0x7FF7BA414E30, 0x0)    = -1 2
stat64("/usr/lib/libobjc.A.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_blocks.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_blocks.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_blocks.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libxpc.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libxpc.dylib\0", 0x7FF7BA414E30, 0x0)  = -1 2
stat64("/usr/lib/system/libxpc.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_trace.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_trace.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_trace.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libcorecrypto.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libcorecrypto.dylib\0", 0x7FF7BA414E30, 0x0) = -1 2
stat64("/usr/lib/system/libcorecrypto.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_malloc.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_malloc.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_malloc.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libdispatch.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libdispatch.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libdispatch.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_featureflags.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_featureflags.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_featureflags.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_c.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_c.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libsystem_c.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/libc++.1.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/libc++.1.dylib\0", 0x7FF7BA414E30, 0x0)     = -1 2
stat64("/usr/lib/libc++.1.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/libc++abi.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/libc++abi.dylib\0", 0x7FF7BA414E30, 0x0)    = -1 2
stat64("/usr/lib/libc++abi.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libdyld.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libdyld.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libdyld.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_info.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_info.dylib\0", 0x7FF7BA414E30, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_info.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_darwin.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_darwin.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_darwin.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_notify.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_notify.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_notify.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_networkextension.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_networkextension.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_networkextension.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_asl.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_asl.dylib\0", 0x7FF7BA414E30, 0x0) = -1 2
stat64("/usr/lib/system/libsystem_asl.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_symptoms.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_symptoms.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_symptoms.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_containermanager.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_containermanager.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_containermanager.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_configuration.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_configuration.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_configuration.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_sandbox.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_sandbox.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_sandbox.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libquarantine.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libquarantine.dylib\0", 0x7FF7BA414E30, 0x0) = -1 2
stat64("/usr/lib/system/libquarantine.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_coreservices.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_coreservices.dylib\0", 0x7FF7BA414E20, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_coreservices.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_m.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_m.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libsystem_m.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libmacho.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libmacho.dylib\0", 0x7FF7BA414E30, 0x0)  = -1 2
stat64("/usr/lib/system/libmacho.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libcommonCrypto.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libcommonCrypto.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libcommonCrypto.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libunwind.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libunwind.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libunwind.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/liboah.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/liboah.dylib\0", 0x7FF7BA414E30, 0x0)     = -1 2
stat64("/usr/lib/liboah.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libcopyfile.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libcopyfile.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libcopyfile.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libcompiler_rt.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libcompiler_rt.dylib\0", 0x7FF7BA414E30, 0x0)    = -1 2
stat64("/usr/lib/system/libcompiler_rt.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_collections.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_collections.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_collections.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_secinit.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_secinit.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_secinit.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libremovefile.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libremovefile.dylib\0", 0x7FF7BA414E30, 0x0) = -1 2
stat64("/usr/lib/system/libremovefile.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libkeymgr.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libkeymgr.dylib\0", 0x7FF7BA414E30, 0x0)   = -1 2
stat64("/usr/lib/system/libkeymgr.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_dnssd.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_dnssd.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_dnssd.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/usr/lib/system/libcache.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libcache.dylib\0", 0x7FF7BA414E30, 0x0)  = -1 2
stat64("/usr/lib/system/libcache.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/libSystem.B.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/libSystem.B.dylib\0", 0x7FF7BA414E30, 0x0)    = -1 2
stat64("/usr/lib/libSystem.B.dylib\0", 0x7FF7BA414E80, 0x0)    = -1 2
stat64("/usr/lib/system/libsystem_darwindirectory.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
stat64("/System/Volumes/Preboot/Cryptexes/OS/usr/lib/system/libsystem_darwindirectory.dylib\0", 0x7FF7BA414E20, 0x0)     = -1 2
stat64("/usr/lib/system/libsystem_darwindirectory.dylib\0", 0x7FF7BA414E80, 0x0)     = -1 2
open("/dev/dtracehelper\0", 0x2, 0x0)    = 3 0
ioctl(0x3, 0x80086804, 0x7FF7BA416E18)     = 0 0
close(0x3)     = 0 0
open("/usr/local/Cellar/coreutils/9.4/bin/gls\0", 0x0, 0x0)    = 3 0
__mac_syscall(0x7FF819AD4E1B, 0x2, 0x7FF7BA4163D0)     = 0 0
map_with_linking_np(0x7FF7BA415FB0, 0x1, 0x7FF7BA415FE0)     = -1 22
close(0x3)     = 0 0
mprotect(0x105B08000, 0x4000, 0x1)     = 0 0
shared_region_check_np(0xFFFFFFFFFFFFFFFF, 0x0, 0x0)     = 0 0
mprotect(0x106100000, 0x40000, 0x1)    = 0 0
access("/AppleInternal/XBS/.isChrooted\0", 0x0, 0x0)     = -1 2
bsdthread_register(0x7FF819DC9B9C, 0x7FF819DC9B88, 0x2000)     = 1073742303 0
getpid(0x0, 0x0, 0x0)    = 49682 0
shm_open(0x7FF819C6CF42, 0x0, 0x19C6B388)    = 3 0
fstat64(0x3, 0x7FF7BA417340, 0x0)    = 0 0
mmap(0x0, 0x4000, 0x1, 0x40001, 0x3, 0x0)    = 0x105B1A000 0
close(0x3)     = 0 0
ioctl(0x2, 0x4004667A, 0x7FF7BA417404)     = 0 0
mprotect(0x105B23000, 0x1000, 0x0)     = 0 0
mprotect(0x105B2D000, 0x1000, 0x0)     = 0 0
mprotect(0x105B2E000, 0x1000, 0x0)     = 0 0
mprotect(0x105B38000, 0x1000, 0x0)     = 0 0
mprotect(0x105B1E000, 0x98, 0x1)     = 0 0
mprotect(0x105B1E000, 0x98, 0x3)     = 0 0
mprotect(0x105B1E000, 0x98, 0x1)     = 0 0
mprotect(0x105B39000, 0x1000, 0x1)     = 0 0
mprotect(0x105B3A000, 0x98, 0x1)     = 0 0
mprotect(0x105B3A000, 0x98, 0x3)     = 0 0
mprotect(0x105B3A000, 0x98, 0x1)     = 0 0
mprotect(0x105B1E000, 0x98, 0x3)     = 0 0
mprotect(0x105B1E000, 0x98, 0x1)     = 0 0
mprotect(0x105B39000, 0x1000, 0x3)     = 0 0
mprotect(0x105B39000, 0x1000, 0x1)     = 0 0
mprotect(0x106100000, 0x40000, 0x3)    = 0 0
mprotect(0x106100000, 0x40000, 0x1)    = 0 0
issetugid(0x0, 0x0, 0x0)     = 0 0
mprotect(0x106100000, 0x40000, 0x3)    = 0 0
getentropy(0x7FF7BA416C30, 0x20, 0x0)    = 0 0
mprotect(0x106100000, 0x40000, 0x1)    = 0 0
mprotect(0x106100000, 0x40000, 0x3)    = 0 0
mprotect(0x106100000, 0x40000, 0x1)    = 0 0
getattrlist("/usr/local/opt/coreutils/libexec/gnubin/ls\0", 0x7FF7BA4172E0, 0x7FF7BA4172F8)    = 0 0
access("/usr/local/Cellar/coreutils/9.4/bin\0", 0x4, 0x0)    = 0 0
open("/usr/local/Cellar/coreutils/9.4/bin\0", 0x0, 0x0)    = 3 0
fstat64(0x3, 0x7FAEECF042E0, 0x0)    = 0 0
csrctl(0x0, 0x7FF7BA41753C, 0x4)     = 0 0
fcntl(0x3, 0x32, 0x7FF7BA4171F0)     = 0 0
close(0x3)     = 0 0
open("/usr/local/Cellar/coreutils/9.4/bin/Info.plist\0", 0x0, 0x0)     = -1 2
proc_info(0x2, 0xC212, 0xD)    = 64 0
csops_audittoken(0xC212, 0x10, 0x7FF7BA417540)     = -1 22
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
csops(0xC212, 0x0, 0x7FF7BA4179A4)     = 0 0
mprotect(0x106100000, 0x40000, 0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_COLLATE\0", 0x0, 0x0)    = 3 0
fcntl_nocancel(0x3, 0x3, 0x0)    = 0 0
getrlimit(0x1008, 0x7FF7BA417D10, 0x0)     = 0 0
fstat64(0x3, 0x7FF7BA417C88, 0x0)    = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_CTYPE\0", 0x0, 0x0)    = 3 0
fcntl_nocancel(0x3, 0x3, 0x0)    = 0 0
fstat64(0x3, 0x7FF7BA417DD0, 0x0)    = 0 0
fstat64(0x3, 0x7FF7BA417BD8, 0x0)    = 0 0
lseek(0x3, 0x0, 0x1)     = 0 0
lseek(0x3, 0x0, 0x0)     = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_MONETARY\0", 0x0, 0x0)     = 3 0
fstat64(0x3, 0x7FF7BA417DD8, 0x0)    = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_NUMERIC\0", 0x0, 0x0)    = 3 0
fstat64(0x3, 0x7FF7BA417DD8, 0x0)    = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_TIME\0", 0x0, 0x0)     = 3 0
fstat64(0x3, 0x7FF7BA417DD8, 0x0)    = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
open_nocancel("/usr/share/locale/en_US.UTF-8/LC_MESSAGES/LC_MESSAGES\0", 0x0, 0x0)     = 3 0
fstat64(0x3, 0x7FF7BA417DD8, 0x0)    = 0 0
dtrace: error on enabled probe ID 1714 (ID 961: syscall::read_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x3)    = 0 0
ioctl(0x1, 0x4004667A, 0x7FF7BA418324)     = 0 0
ioctl(0x1, 0x40087468, 0x7FF7BA4183F0)     = 0 0
open_nocancel(".\0", 0x1100004, 0x0)     = 3 0
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
dtrace: error on enabled probe ID 1741 (ID 573: syscall::sysctl:return): invalid kernel access in action #10 at DIF offset 28
fstatfs64(0x3, 0x7FF7BA417AB0, 0x0)    = 0 0
getdirentries64(0x3, 0x7FAEED80FC00, 0x2000)     = 568 0
close_nocancel(0x3)    = 0 0
sigprocmask(0x1, 0x0, 0x7FF7BA418350)    = 0x0 0
sigaltstack(0x0, 0x7FF7BA418340, 0x0)    = 0 0
fstat64(0x1, 0x7FF7BA416E58, 0x0)    = 0 0
ioctl(0x1, 0x4004667A, 0x7FF7BA416EA4)     = 0 0
dtrace: error on enabled probe ID 1712 (ID 963: syscall::write_nocancel:return): invalid kernel access in action #12 at DIF offset 68
dtrace: error on enabled probe ID 1712 (ID 963: syscall::write_nocancel:return): invalid kernel access in action #12 at DIF offset 68
close_nocancel(0x1)    = 0 0
close_nocancel(0x2)    = 0 0
```
<!--endsec-->

- troubleshooting

  - [`dtrace: system integrity protection is on`](https://stackoverflow.com/a/60910410/2940319)

    > [!TIP]
    > - [* iMarlso: osx/system integrity protection](../osx/osx.html#system-integrity-protection)

    ```
    # csrutil disable
    # or
    # csrutil enable --without dtrace
    # or
    # csrutil enable --without dtrace --without debug
    ```

## sar

## netcat

> [!NOTE]
> references:
> - [the netcat command in linux](https://www.baeldung.com/linux/netcat-command)

- check particular port
  ```bash
  $ nc -zv 127.0.0.1 22
  Connection to 127.0.0.1 port 22 [tcp/ssh] succeeded!
  ```

- check ports in range
  ```bash
  $ nc -znv -w 1 127.0.0.1 20-30
  nc: connectx to 127.0.0.1 port 20 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 21 (tcp) failed: Connection refused
  Connection to 127.0.0.1 port 22 [tcp/*] succeeded!
  nc: connectx to 127.0.0.1 port 23 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 24 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 25 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 26 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 27 (tcp) failed: Connection refused
  nc: connectx to 127.0.0.1 port 28 (tcp) failed: Connection refused
  ```

- running simple web server
  ```bash
  $ cat > index.html <<<EOF
  <!DOCTYPE html>
  <html>
      <head>
          <title>Simple Netcat Server</title>
      </head>
      <body>
          <h1>Welcome to simple netcat server!<h1>
      </body>
      </body>
  <html>
  EOF

  $ echo -e "HTTP/1.1 200 OK\n\n$(cat index.html)" | nc -l 1234
  ```

- or getting more
  ```bash
  $ while true; do echo -e "HTTP/1.1 200 OK\n\n$(cat index.html)" | nc -l -w 1 1234; done
  GET / HTTP/1.1
  Host: localhost:1234
  Connection: keep-alive
  sec-ch-ua: "Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"
  sec-ch-ua-mobile: ?0
  sec-ch-ua-platform: "macOS"
  Upgrade-Insecure-Requests: 1
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36
  Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7
  Sec-Fetch-Site: none
  Sec-Fetch-Mode: navigate
  Sec-Fetch-User: ?1
  Sec-Fetch-Dest: document
  Accept-Encoding: gzip, deflate, br
  Accept-Language: en,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7

  GET /favicon.ico HTTP/1.1
  Host: localhost:1234
  Connection: keep-alive
  sec-ch-ua: "Chromium";v="110", "Not A(Brand";v="24", "Google Chrome";v="110"
  sec-ch-ua-mobile: ?0
  User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36
  sec-ch-ua-platform: "macOS"
  Accept: image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8
  Sec-Fetch-Site: same-origin
  Sec-Fetch-Mode: no-cors
  Sec-Fetch-Dest: image
  Referer: http://localhost:1234/
  Accept-Encoding: gzip, deflate, br
  Accept-Language: en,zh-CN;q=0.9,zh;q=0.8,en-US;q=0.7

  ...
  ```

  ![netcat web service](../screenshot/linux/netcat-1234-html.png)

- [reverse proxy with netcat](https://www.baeldung.com/linux/netcat-command#reverse-proxy-with-netcat)


## `ip`
```bash
$ ip addr show | sed -nE "s/inet\s(.*)\/[0-9]+.*\s(\w+)/\2 \1/p"
  lo0 127.0.0.1
  en0 192.168.1.71

# for linux
$ ip addr show | sed -nE "s/inet\s(.*)\/[0-9]+.*\s(\w+)/\2 \1/p" | column -to ' => '
lo0 => 127.0.0.1
en0 => 192.168.1.71
```

# others

> [!NOTE|label:references:]
> - [完全指南：在 Linux 中如何打印和管理打印机](https://linux.cn/article-9538-1.html)
> - [440+ 个免费的编程 & 计算机科学的在线课程](https://linux.cn/article-9443-1.html)
> - [在 Linux 上用 DNS 实现简单的负载均衡](https://linux.cn/article-9777-1.html)
> - [Python 字节码介绍](https://linux.cn/article-9816-1.html)
