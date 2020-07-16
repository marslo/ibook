<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [nfs](#nfs)
  - [mount a nfs](#mount-a-nfs)
  - [check nfs mount](#check-nfs-mount)
  - [disconnect the mount](#disconnect-the-mount)
  - [setup nfs mount by default server boot](#setup-nfs-mount-by-default-server-boot)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## nfs

```bash
# example
nfs server: 1.2.3.4
sub-folder: /a/b
mount to local: /mnt/mynfs
```

### mount a nfs
```bash
$ sudo mkdir -p /mnt/mynfs
$ sudo mount -t nfs 1.2.3.4:/a/b /mnt/mynfs
```

- [test if sub-folder exists in remote nfs server](https://www.tecmint.com/how-to-setup-nfs-server-in-linux/)
    ```bash
    $ showmount -e 1.2.3.4 | grep '/a/b'
    ```

- environment setup
    ```bash
    # centos
    $ yum install nfs-utils nfs-utils-lib
    $ yum install portmap (not required with NFSv4)

    # ubuntu
    $ apt-get install nfs-utils nfs-utils-lib
    ```

### check nfs mount
```bash
$ df -h -F nfs [ | column -t ]
$ mount | column -t | grep -E 'type.*nfs
$ findmnt /mnt/mynfs
```

### disconnect the mount
```bash
$ sudo umount /mnt/mynfs
```

### setup nfs mount by default server boot
```bash
$ sudo bash -c "cat > /etc/fstab" << EOF
1.2.3.4:/a/b    /mnt/mynfs nfs default 0 0
EOF
```

## LVM

### check status
- `lsblk`
- `pvs`
- `lvs`
- `vgs`
- `pvscan`
- `lvscan`
- `pvdisplay`
- `vgdisplay`
- `lvdisplay`
- `fdisk -l`
- `sfdisk  -l -uM`
- `lshw -class disk`
- `hwinfo --block --short`
