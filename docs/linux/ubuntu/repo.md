<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [keyring](#keyring)
  - [`apt-key`](#apt-key)
  - [`curl`](#curl)
  - [`gpg`](#gpg)
  - [Ghostbird/add-repository](#ghostbirdadd-repository)
  - [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Google Linux Software Repositories](https://www.google.com/linuxrepositories/)
> - [How To Build a Debian Packages](https://forums.debian.net/viewtopic.php?f=16&t=38976)
> - [Official Archive Mirrors for Ubuntu](https://launchpad.net/ubuntu/+archivemirrors)

## keyring

> [!NOTE]
> - [* iMarslo : gpg](../../cheatsheet/bash/bash.html#gpg)
> - [step by step by `apt-key add`](https://github.com/microsoft/WSL/issues/3286#issuecomment-402594992)
> - [Hockeypuck OpenPGP keyserver](http://keyserver.ubuntu.com/)
> - for
>   ```bash
>   The following signatures couldn't be verified because the public key is not available: NO_PUBKEY 112696A0E562B32A NO_PUBKEY 54404762BBB6E853
>   ```

### `apt-key`
```bash
$ apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 54404762BBB6E853
# or
$ apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 54404762BBB6E853
```

### `curl`

> [!NOTE|label:references:]
> - [#3286: Ubuntu 18.04 gpg dirmngr IPC connect call failed](https://github.com/microsoft/WSL/issues/3286#issuecomment-402594992)

```bash
#                                                                0x<PUBKEY>
#                                                                v
$ curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x112696A0E562B32A" | sudo apt-key add
$ curl -sL "http://keyserver.ubuntu.com/pks/lookup?op=get&search=0x54404762BBB6E853" | sudo apt-key add
```

- or manually download
  ```bash
  $ cat armored-keys.asc | sudo apt-key add
  ```

  ![manual download keyring](../../screenshot/linux/keyserver-pgp-keyring.png)

### `gpg`
```bash
$ gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
```

- more options
  ```bash
  $ gpg --ignore-time-conflict \
        --no-options \
        --no-default-keyring \
        --homedir /tmp/tmp.Hrb5ETPac2 \
        --no-auto-check-trustdb \
        --trust-model always \
        --keyring /etc/apt/trusted.gpg \
        --primary-keyring /etc/apt/trusted.gpg \
        --keyserver keyserver.ubuntu.com \
        --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
  ```

### [Ghostbird/add-repository](https://gist.github.com/Ghostbird/83eb5bcd2ffd4a6b6966137a2e1c4caf)
```bash
$ ./add-repository "https://keyserver.ubuntu.com/pks/lookup?search=0x3fa7e0328081bff6a14da29aa6a19b38d3d831ef&op=get" "deb https://download.mono-project.com/repo/debian stable-buster main" mono-official-stable.list
```

### [others](https://github.com/mono/mono/issues/21584#issuecomment-1354833031)
```bash
# dockerfile
RUN apt install -y gnupg ca-certificates
RUN gpg --keyserver keyserver.ubuntu.com --recv 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN gpg --export 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF | tee /usr/share/keyrings/mono.gpg >/dev/null
RUN gpg --batch --yes --delete-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb [signed-by=/usr/share/keyrings/mono.gpg] https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN apt update
RUN apt install -y mono-devel
```
