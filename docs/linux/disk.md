<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check status](#check-status)
- [nfs](#nfs)
  - [mount a nfs](#mount-a-nfs)
  - [check mount](#check-mount)
  - [check remote mount version](#check-remote-mount-version)
  - [disconnect the mount](#disconnect-the-mount)
  - [setup nfs mount by default server boot](#setup-nfs-mount-by-default-server-boot)
  - [related configure](#related-configure)
  - [check NFS performance](#check-nfs-performance)
- [LVM](#lvm)
  - [example](#example)
- [ios](#ios)
  - [mount ios](#mount-ios)
- [performance](#performance)
  - [`iostat`](#iostat)
  - [`sar`](#sar)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## check status
- `$ lsblk`
- `$ ncdu`
- `$ pvs`
- `$ lvs`
- `$ vgs`
- `$ pvscan`
- `$ lvscan`
- `$ pvdisplay`
- `$ vgdisplay`
- `$ lvdisplay`
- `$ fdisk -l`
- `$ sfdisk  -l -uM`
- `$ lshw -class disk`
- `$ hwinfo --block --short`
- `$ cat /proc/partitions`
- `$ sudo blkid`


## nfs
{% hint style='tip' %}
```bash
# example
nfs server: 1.2.3.4
sub-folder: /a/b
mount to local: /mnt/mynfs
```
{% endhint %}

### mount a nfs
```bash
$ sudo mkdir -p /mnt/mynfs
$ sudo mount -t nfs 1.2.3.4:/a/b /mnt/mynfs

# or force using nfsversion 4
$ sudo mount -t nfs -o nfsvers=4 1.2.3.4:/a/b /mnt/mynfs -vvv
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

  # for nfs4

  # ubuntu
  $ apt-get install nfs-utils nfs-utils-lib
  ```

### check mount
```bash
$ cat /etc/mtab | grep /folder_name
/dev/sdb1 /folder_name ext4 rw,seclabel,relatime,stripe=64 0 0
```

#### [Check if folder is a mounted remote filesystem](https://unix.stackexchange.com/a/72224/29178)
```bash
$ df -P -T /folder_name
Filesystem     Type 1024-blocks     Used  Available Capacity Mounted on
/dev/sdb1      ext4  744******* 658***** 699*******       1% /folder_name
```

- `df`
  ```bash
  $ df /local_storage
  Filesystem      1K-blocks     Used  Available Use% Mounted on
  /dev/sdb1      744******* 658***** 699*******   1% /folder_name
  ```

- `/etc/fstab`
  ```bash
  $ cat /etc/fstab
  ```

- [`findmnt`](https://www.tecmint.com/find-mounted-file-systems-in-linux/)
  ```bash
  $ findmnt --fstab /local_storage
  TARGET         SOURCE    FSTYPE OPTIONS
  /local_storage /dev/sdb1 ext4   defaults
  ```

#### check nfs mount
```bash
$ df -h -F nfs [ | column -t ]
$ mount | column -t | grep -E 'type.*nfs
$ findmnt /mnt/mynfs
```

#### check mount version
{% hint style='tip' %}
- [`nfsstat -c` will show you the NFS version actually being used](https://unix.stackexchange.com/a/185831/29178)
- [`nfsstat -m` will show statistics on mounted NFS filesystems](https://unix.stackexchange.com/a/138999/29178)
- `grep nfs /proc/mounts` equals `nfsstat -m`
{% endhint %}

```bash
$ rpcinfo -p localhost
  program vers proto   port  service
   100000    4   tcp    111  portmapper
   100000    3   tcp    111  portmapper
   100000    2   tcp    111  portmapper
   100000    4   udp    111  portmapper
   100000    3   udp    111  portmapper
   100000    2   udp    111  portmapper
   100024    1   udp  38978  status
   100024    1   tcp  36415  status
   100021    1   udp  51669  nlockmgr
   100021    3   udp  51669  nlockmgr
   100021    4   udp  51669  nlockmgr
   100021    1   tcp  42699  nlockmgr
   100021    3   tcp  42699  nlockmgr
   100021    4   tcp  42699  nlockmgr
```

### check remote mount version
```bash
$ rpcinfo 1.2.3.4 | egrep "service|nfs"
   program version netid     address          service    owner
    100003    3    udp       1.2.3.4.8.1      nfs
    100003    3    tcp       1.2.3.4.8.1      nfs
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

### related configure
- `/etc/fstab`
- `/etc/nsswitch.conf`
- `/etc/nfsmount.conf`
- `/etc/nfs.conf`
- `/proc/mounts`

### check NFS performance

{% hint style='tip' %}
> references:
> - [Using nfsstat and nfsiostat to troubleshoot NFS performance issues on Linux](https://www.redhat.com/sysadmin/using-nfsstat-nfsiostat)
> - [NFS poor write performance](https://serverfault.com/questions/682000/nfs-poor-write-performance)
> - [Analyzing Linux NFS server performance](https://serverfault.com/questions/38756/analyzing-linux-nfs-server-performance)
{% endhint %}

- commands
  - `nfsstat`
  - `nfsiostat`
  - [collectl](http://collectl.sourceforge.net/)
    - `collectl -sjmf -oT`
    - `collectl -sn --verbose -oT`
    - `collectl -sJ -oTm`
  - [`tshark -R nfs -i eth0`](https://serverfault.com/a/38893/129815)
  - [`nfswatch`](http://nfswatch.sourceforge.net)
  - `netstat -plaute | grep nfs`
  - `watch -d "netstat -plaute | grep nfs | sort -k 4,5"`
  - `iostat -mx <delay in sec.> <devices>`
  - [`sudo fio --randrepeat=1 --ioengine=libaio --direct=0 --gtod_reduce=1 --name=test1 --filename=/media/ramdisk/test --bs=4k --iodepth=64 --size=4G --readwrite=randrw --rwmixread=75`](https://serverfault.com/a/938554/129815)
  - [`time dd if=/dev/zero of=/mnt/nfs/testfile bs=16k count=128k`](https://serverfault.com/a/324489/129815)
  - [`iozone -aRcU /mnt/nfs/ -f /mnt/nfs/testfile > logfile`](https://serverfault.com/a/324489/129815)

## LVM
> reference:
> - [CONFIGURING AND MANAGING LOGICAL VOLUMES](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_logical_volumes/index)
> - [CHAPTER 5. MODIFYING THE SIZE OF A LOGICAL VOLUME](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/8/html/configuring_and_managing_logical_volumes/assembly_modifying-logical-volume-size-configuring-and-managing-logical-volumes)

### example
- extends the logical volume /dev/myvg/homevol to 12 gigabytes
  ```bash
  $ sudo lvextend -L12G /dev/myvg/homevol
  lvextend -- extending logical volume "/dev/myvg/homevol" to 12 GB
  lvextend -- doing automatic backup of volume group "myvg"
  lvextend -- logical volume "/dev/myvg/homevol" successfully extended
  ```
- adds another gigabyte to the logical volume /dev/myvg/homevol
  ```bash
  $ sudo lvextend -L+1G /dev/myvg/homevol
  lvextend -- extending logical volume "/dev/myvg/homevol" to 13 GB
  lvextend -- doing automatic backup of volume group "myvg"
  lvextend -- logical volume "/dev/myvg/homevol" successfully extended
  ```

## ios
### [mount ios](https://www.tecmint.com/how-to-mount-and-unmount-an-iso-image-in-linux/)
```bash
$ [[ -z $(findmnt /mnt/tmp) ]] || umount -f /mnt/tmp
$ mkdir /mnt/tmp
$ mount -t iso9660 -o loop /vol/builds/os/linux/RHEL-6.6-20140926.0-Server-x86_64-dvd1.iso  /mnt/tmp/
```

## performance
### `iostat`
```bash
$ iostat -x -d 1
Linux 3.10.0-957.27.2.el7.x86_64 (dc5-ssdfwtst3)  01/15/2021  _x86_64_  (4 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.09    0.07   13.91     6.83    81.26    12.61     0.01    0.93   11.40    0.88   0.38   0.53
dm-0              0.00     0.00    0.07   14.00     6.83    81.26    12.53     0.01    0.95   11.60    0.90   0.38   0.53
dm-1              0.00     0.00    0.00    0.00     0.00     0.00    52.91     0.00    0.64    0.64    0.00   0.48   0.00
```

### `sar`
```bash
$ sar -bdp 1
Linux 3.10.0-957.27.2.el7.x86_64 (dc5-ssdfwtst3)  01/15/2021  _x86_64_  (4 CPU)

05:44:20 AM       tps      rtps      wtps   bread/s   bwrtn/s
05:44:21 AM    863.00    863.00      0.00  47048.00      0.00

05:44:20 AM       DEV       tps  rd_sec/s  wr_sec/s  avgrq-sz  avgqu-sz     await     svctm     %util
05:44:21 AM       sda    863.00  47048.00      0.00     54.52      2.86      3.33      0.16     14.20
05:44:21 AM centos-root    863.00  47048.00      0.00     54.52      2.88      3.33      0.16     14.20
05:44:21 AM centos-swap      0.00      0.00      0.00      0.00      0.00      0.00      0.00      0.00
```
