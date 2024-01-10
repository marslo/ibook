<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [system command](#system-command)
  - [use parameter in `xargs`](#use-parameter-in-xargs)
  - [find commands belongs to and come from](#find-commands-belongs-to-and-come-from)
  - [find alias come from](#find-alias-come-from)
  - [get command from PATH](#get-command-from-path)
  - [get all google website](#get-all-google-website)
- [perm](#perm)
  - [backup](#backup)
  - [restore](#restore)
  - [check perm](#check-perm)
- [gpg](#gpg)
  - [encrypt bash file](#encrypt-bash-file)
- [inode](#inode)
  - [get inode of a file](#get-inode-of-a-file)
  - [get inodes in a folder](#get-inodes-in-a-folder)
  - [check inode status](#check-inode-status)
  - [extend inode](#extend-inode)
- [check linux window size](#check-linux-window-size)
- [readline & bind](#readline--bind)
  - [get info](#get-info)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [Hidden features of Bash](https://stackoverflow.com/q/211378/2940319)

## system command
### [use parameter in `xargs`](https://unix.stackexchange.com/a/100972/29178)
```bash
$ find . -type f | xargs -n 1 -I FILE bash -c 'echo $(file --mime-type -b FILE)'
text/plain
text/plain
text/plain
inode/x-empty
text/plain
text/plain
text/plain
text/plain
text/plain
text/plain
```

### find commands belongs to and come from
- belongs to
  ```bash
  $ type which
  which is aliased to `alias | which -a --tty-only --read-alias --show-dot --show-tilde'

  $ type bello
  bello is a function
  bello ()
  {
    source "${iRCHOME}/.imac"
  }
  ```

- [come from](https://unix.stackexchange.com/a/322887/29178)
  ```bash
  $ shopt -s extdebug

  $ declare -F _completion_loader
  _completion_loader 2219 /usr/local/Cellar/bash-completion@2/2.11/share/bash-completion/bash_completion

  $ declare -F _docker
  _docker 5463 /usr/local/etc/bash_completion.d/docker

  $ declare -F __git_ps1
  __git_ps1 340 /usr/local/etc/bash_completion.d/git-prompt.sh

  $ declare -F bello
  bello 79 /Users/marslo/.marslo/.marslorc
  ```

  - linux
    ```bash
    $ bash --debugger
    $ declare -F _docker
    _docker 5011 /usr/share/bash-completion/completions/docker
    ```

### find alias come from

> [!NOTE|label:references:]
> - [Is it possible to check where an alias was defined?](https://unix.stackexchange.com/a/322468/29178)

```bash
$ bash -ixlc : 2>&1 | grep ...
$ zsh -ixc : 2>&1 | grep ...
```

- i.e.:
  ```bash
  $ bash -ixlc : 2>&1 | grep 'clr='
      /Users/marslo/.marslo/.alias/docker::16: alias 'dclr=docker system prune -a -f'
      /Users/marslo/.marslo/.alias/utils::22: alias clr=clear
  ```

### get command from PATH

> [!NOTE|label:references:]
> - [How to use `which` on an aliased command?](https://unix.stackexchange.com/q/10525/29178)

```bash
$ type -a kubectl
kubectl is aliased to `kubecolor'
kubectl is /Users/marslo/.docker/bin/kubectl
```

- `type -P`
  ```bash
  $ type -P kubectl
  /Users/marslo/.docker/bin/kubectl
  ```

- `/usr/bin/which`
  ```bash
  $ /usr/bin/which kubectl
  /Users/marslo/.docker/bin/kubectl
  ```

- `which --skip-alias`
  ```bash
  $ which --skip-alias kubectl
  ~/.docker/bin/kubectl
  ```

- `shopt -u expand_aliases`
  ```bash
  $ type -a kubectl
  kubectl is aliased to `kubecolor'
  kubectl is /Users/marslo/.docker/bin/kubectl

  $ shopt -u expand_aliases
  $ type -a kubectl
  kubectl is /Users/marslo/.docker/bin/kubectl

  $ shopt -s expand_aliases
  ```

- check alias only
  ```bash
  $ echo ${BASH_ALIASES[kubectl]}
  kubecolor
  ```

### get all google website
```bash
$ whois www.google.com

Whois Server Version 2.0

Domain names in the .com and .net domains can now be registered
with many different competing registrars. Go to http://www.internic.net
for detailed information.

  Server Name: WWW.GOOGLE.COM.VN
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TW
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TR
  Registrar: TUCOWS DOMAINS INC.
  Whois Server: whois.tucows.com
  Referral URL: http://domainhelp.opensrs.net

  Server Name: WWW.GOOGLE.COM.SA
  Registrar: OMNIS NETWORK, LLC
  Whois Server: whois.omnis.com
  Referral URL: http://domains.omnis.com

  Server Name: WWW.GOOGLE.COM.PK
  Registrar: INTERNET.BS CORP.
  Whois Server: whois.internet.bs
  Referral URL: http://www.internet.bs

  Server Name: WWW.GOOGLE.COM.PE
  Registrar: HOSTOPIA.COM INC. D/B/A APLUS.NET
  Whois Server: whois.names4ever.com
  Referral URL: http://www.aplus.net

  Server Name: WWW.GOOGLE.COM.MX
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.HK
  Registrar: GKG.NET, INC.
  Whois Server: whois.gkg.net
  Referral URL: http://www.gkg.net

  Server Name: WWW.GOOGLE.COM.DO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.CO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.BR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.AU
  Registrar: MELBOURNE IT, LTD. D/B/A INTERNET NAMES WORLDWIDE
  Whois Server: whois.melbourneit.com
  Referral URL: http://www.melbourneit.com

  Server Name: WWW.GOOGLE.COM.AR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

>>> Last update of whois database: Mon, 24 Feb 2014 17:24:05 UTC <<<
```


## perm

> [!NOTE|label:references:]
> - [backup and restore filer & folder permission](https://unix.stackexchange.com/a/128499/29178)

### backup
```bash
$ find . -printf '%m\t%u\t%g\t%p\0' > file.perm
```

### restore
```bash
while read -rd $'\0' perms user group file; do
  if [ -e "$file" ]; then
    chown "$user:$group" "$file"
    chmod "$perms" "$file"
  else
    echo "warning: $file not found"
  fi
done < file.perm
```

### check perm
- `find` & `printf`
  ```bash
  $ find $PWD -printf '%m\t%u\t%g\t%p\n' | head
  755 marslo  staff /Users/marslo
  755 marslo  staff /Users/marslo/.eclipse
  755 marslo  staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo
  644 marslo  staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/defaults.properties
  644 marslo  staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/infos.txt

  $ find $PWD -printf '%M %u %g %p\n' | head
  drwxr-xr-x marslo staff /Users/marslo
  drwxr-xr-x marslo staff /Users/marslo/.eclipse
  drwxr-xr-x marslo staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo
  -rw-r--r-- marslo staff /Users/marslo/.eclipse/org.eclipse.oomph.jreinfo/defaults.properties
  ```

- `stat`
  ```bash
  $ stat -c '%A %a %n' *
  drwx------ 700 Applications
  drwx------ 700 Desktop
  drwx------ 700 Documents
  drwx------ 700 Downloads
  drwx------ 700 Library
  drwx------ 700 Movies
  drwx------ 700 Music
  drwx------ 700 Pictures
  drwxr-xr-x 755 Public
  drwxr-xr-x 755 mywork
  drwxr-xr-x 755 test
  ```

- `namei`
    ```bash
    $ namei -l $PWD
    /Users/marslo
      / = drwxr-xr-x l=22 u=root/0 g=admin/80 s=704 m=07-16-2020@13:40:21
      Users = drwxr-xr-x l=6 u=root/0 g=admin/80 s=192 m=09-30-2019@04:22:36
      marslo = drwxr-xr-x l=72 u=marslo/501 g=staff/20 s=2304 m=07-16-2020@17:37:27
    ```

## gpg
### encrypt bash file
```bash
$ echo "ls" > script.bash; gpg -c script.bash; cat script.bash.gpg | gpg -d --no-mdc-warning | bash
```


## inode
### get inode of a file
```bash
$ l -i a_b
10224132 -rw-r--r-- 1 marslo marslo 10 Feb 21 00:43 a_b
```

### get inodes in a folder
- [`stat`](https://unix.stackexchange.com/a/121836/29178)
  ```bash
  $ stat -c '%i' ~
  686476
  ```

  - equivalent to
    ```bash
    $ ls -id ~
    686476 /Users/marslo
    ```

  - example
    ```bash
    $ ls -id  /local_storage/docker
    2818591238 /local_storage/docker
    ```

- `ls`
  ```bash
  $ ls /local_storage/docker -AiR1U |
       sed -rn '/^[./]/{h;n;};G;
           s|^ *([0-9][0-9]*)[^0-9][^/]*([~./].*):|\1:\2|p' |
       sort -t : -uk1.1,1n |
       cut -d: -f2 | sort -V |
       uniq -c | sort -rn | head -n10
       46 /Users/marslo/test/keepalived-2.0.18/lib
       29 /Users/marslo/test
       28 /Users/marslo/test/keepalived-2.0.18/doc/samples
       27 /Users/marslo/test/jenkins/vars
       23 /Users/marslo/test/keepalived-2.0.18
       22 /Users/marslo/test/keepalived-2.0.18/doc/source
       17 /Users/marslo/test/jenkins/jenkinsfile
       16 /Users/marslo/test/autosquash/.git/objects
       14 /Users/marslo/test/keepalived-2.0.18/keepalived/vrrp
       14 /Users/marslo/test/jenkins/configs/etc/yum.repos.d
  ```

- `df`
  ```bash
   $ df -i
  Filesystem                            Type   Inodes IUsed IFree IUse% Mounted on
  /dev/disk1s5s1                        apfs     2.3G  555K  2.3G    1% /
  /dev/disk1s4                          apfs     2.3G     2  2.3G    1% /System/Volumes/VM
  /dev/disk1s2                          apfs     2.3G  1.2K  2.3G    1% /System/Volumes/Preboot
  /dev/disk1s6                          apfs     2.3G    16  2.3G    1% /System/Volumes/Update
  /Library/Input Methods/SogouInput.app nullfs   2.3G  1.8M  2.3G    1% /private/var/folders/s3/mg_f3cv54nn7y758j_t46zt40000gn/T/AppTranslocation/1E49F6C4-251F-443B-8D8A-86DA8F531F09
  ```
- [`du`](https://unix.stackexchange.com/a/117098/29178)
  ```bash
  $ sudo du --inodes -S ~ \
         | sort -rh \
         | sed -n '1,50{/^.\{71\}/s/^\(.\{30\}\).*\(.\{37\}\)$/\1...\2/;p}' \
         | head -10
  14994 /Users/marslo/Library/Co...icrosoft User Data/OneNote/15.0/cache
  13453 /Users/marslo/Library/Gr...s/Main Profile/Files/S0/1/Attachments
  4667  /Users/marslo/Library/Caches/Google/Chrome Canary/Default/Cache
  4086  /Users/marslo/Library/Gro...ofiles/Marvell/Files/S0/1/Attachments
  3912  /Users/marslo/Library/Con...476b0cb6d7b78ea9f492c743c1bdfa/Avatar
  3359  /Users/marslo/Library/Con...6d7b78ea9f492c743c1bdfa/Stickers/File
  3174  /Users/marslo/Library/App...versions/3.8.6/openssl/share/man/man3
  3174  /Users/marslo/Library/App...6/openssl/share/doc/openssl/html/man3
  3174  /Users/marslo/Library/App...versions/3.7.9/openssl/share/man/man3
  3174  /Users/marslo/Library/App...9/openssl/share/doc/openssl/html/man3
  ```

### check inode status
```bash
$ sudo tune2fs -l /dev/sdb1 | grep inode
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype needs_recovery extent 64bit flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Free inodes:              234152632
First inode:              11
Journal inode:            8
First orphan inode:       44171696
Journal backup:           inode blocks
```

### extend inode
> reference:
> - [Modifying the inode count for an ext2/ext3/ext4 file system](http://kb.ictbanking.net/article.php?id=693)
> - [RHEL: Extending the maximum inode count on a ext2/ext3/ext4 filesystem](https://sites.google.com/site/syscookbook/rhel/rhel-fs-ext2_3_4-inode-count)


## [check linux window size](https://askubuntu.com/a/1020938/92979)
- check
  ```bash
  $ shopt | grep checkwinsize
  checkwinsize    on
  ```
- enable
  ```bash
  $ shopt -s checkwinsize
  ```

## readline & bind

> [!NOTE]
> - [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Completion.html)

### get info
- get current keymap
  ```bash
  $ bind -v | awk '/keymap/ {print $NF}'
  vi-insert
  ```

  - [tricky for switch keymap](https://unix.stackexchange.com/a/409866/29178)
    ```bash
    set keymap emacs
    "\ee": vi-editing-mode

    set keymap vi-insert
    "\e": vi-movement-mode

    set keymap vi-command
    "\ee": emacs-editing-mode
    ```
