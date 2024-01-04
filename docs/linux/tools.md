<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [apt](#apt)
  - [apt configuration](#apt-configuration)
  - [necessory pckages and dependencies](#necessory-pckages-and-dependencies)
  - [package auto-upgrade dislable](#package-auto-upgrade-dislable)
  - [disable server auto upgrade](#disable-server-auto-upgrade)
    - [revert hold settings](#revert-hold-settings)
    - [Show all Hold](#show-all-hold)
  - [complete remove an app](#complete-remove-an-app)
  - [gpg keys](#gpg-keys)
- [Raspberry Pi](#raspberry-pi)
  - [repository](#repository)
  - [jdk](#jdk)
- [system](#system)
  - [timezone setup](#timezone-setup)
  - [motd upgrade disable](#motd-upgrade-disable)
  - [set service auto-startup](#set-service-auto-startup)
- [application](#application)
  - [jdk and JAVA_HOME](#jdk-and-java_home)
  - [groovy](#groovy)
  - [gcc](#gcc)
  - [ruby](#ruby)
  - [mono](#mono)
  - [mysql](#mysql)
    - [built from source code](#built-from-source-code)
    - [install from apt repo](#install-from-apt-repo)
  - [mysql-connector (jdbc)](#mysql-connector-jdbc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# apt

> [!TIP|label:download deb only]
> - [Is there an apt command to download a deb file from the repositories to the current directory?](https://askubuntu.com/a/30581/92979)
>   ```bash
>   # get package name
>   $ sudo apt list --installed | grep <keywords>
>   $ apt-get install --reinstall --print-uris -qq <package-name> | cut -d"'" -f2
>   ```

## apt configuration
```bash
$ cat /etc/apt/apt.conf
Acquire::http::Proxy "http://161.91.27.236:8080";
Acquire::https::Proxy "http://161.91.27.236:8080";
Acquire::ftp::Proxy "http://161.91.27.236:8080";

$ cat /etc/apt/apt.conf.d/99ignoresave
Dir::Ignore-Files-Silently:: "(.save|.distupgrade)$";
Dir::Ignore-Files-Silently:: "\.gz$";
Dir::Ignore-Files-Silently:: "\.save$";
Dir::Ignore-Files-Silently:: "\.distUpgrade$";
Dir::Ignore-Files-Silently:: "\.list_$";
```

## necessory pckages and dependencies
```bash
$ sudo apt --list upgradable
$ sudo apt upgrade
$ sudo apt install sysv-rc-conf tree dos2unix iptables-persistent mailutils policycoreutils build-essential landscape-common gcc g++ make cmake
```

## package auto-upgrade dislable
```bash
$ sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
$ sudo sed -i 's/"1"/"0"/' /etc/apt/apt.conf.d/10periodic
$ sudo sed -i 's/"1"/"0"/' /etc/apt/apt.conf.d/20auto-upgrades
```

## disable server auto upgrade
```bash
# dpkg --list | grep jenkins
ii  jenkins                            2.19.4                             all          Jenkins monitors executions of repeated jobs, such as building a software
# echo "jenkins hold" | dpkg --set-selections
OR
# apt-mark hold jenkins
# dpkg --list | grep jenkins
hi  jenkins                            2.19.4                             all          Jenkins monitors executions of repeated jobs, such as building a software
```

### revert hold settings
```bash
$ sudo echo "jenkins install" | dpkg --set-selections
# OR
$ sudo apt-mark unhold jenkins
```

### Show all Hold

```bash
$ sudo apt-mark showhold
```

## complete remove an app
```bash
$ sudo systemctl stop mysql
$ sudo apt-get --purge autoremove mysql*
$ sudo apt-get autoclean
$ sudo apt --purge autoremove mysql*
$ sudo apt autoclean
$ sudo apt list --installed | grep mysql
$ sudo rm -rf /var/lib/mysql/debian-*.flag
$ sudo rm -rf /var/lib/mysql
$ sudo rm -rf /etc/mysql
```

## gpg keys

> [!NOTE|label:references:]
> - [Omv and Apt broken: Pending configuration changes](https://forum.openmediavault.org/index.php?thread/48094-omv-and-apt-broken-pending-configuration-changes/&postID=352338#post352338)
>   - `$ sudo dpkg -l | grep openmediavault`
>   - `$ sudo ls -alh /etc/apt/trusted.gpg.d/`
> - [apt-get update errors missing public keys](https://forum.openmediavault.org/index.php?thread/49140-apt-get-update-errors-missing-public-keys/)
> - [The following signatures couldn't be verified because the public key is not available](https://forums.raspberrypi.com/viewtopic.php?t=352539)

- openmediavault-keyring
  ```bash
  $ cd /tmp
  $ sudo wget https://packages.openmediavault.org/public/pool/main/o/openmediavault-keyring/openmediavault-keyring_1.0.2-2_all.deb
  $ sudo dpkg -i openmediavault-keyring
  $ sudo apt-get update
  ```

- install keyring
  ```bash
  $ sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 112695A0E562B32A
  ```

# Raspberry Pi

> [!NOTE|label:references:]
> - [* debian/dists/bullseye](https://ftp.debian.org/debian/dists/bullseye/main/)
> - [How to install and use Java 11 and JavaFX 11 on Raspberry Pi boards with ARMv6 processor](https://webtechie.be/post/2020-08-27-azul-zulu-java-11-and-gluon-javafx-11-on-armv6-raspberry-pi/)
> - [bellsoft: Liberica JDK Download Center](https://bell-sw.com/pages/downloads/#jdk-17-lts)
> - [bellsoft: Liberica JDK 11.0.2 Install Guide](https://docs.bell-sw.com/liberica-jdk/11.0.2b7/general/install-guide/)
> - [How to Install Java on Raspberry Pi](https://phoenixnap.com/kb/install-java-raspberry-pi)
> - [raspbian.raspberrypi.org: openjdk-11](http://raspbian.raspberrypi.org/raspbian/pool/main/o/openjdk-11/)
> - [PiJava - Part 2 - Installing Java 11 on a Raspberry PI 3 Model B+](https://webtechie.be/post/2019-03-13-pijava-part-2-java-11-on-raspberry-pi-3/)
> - [How to Update Java on Raspberry Pi](https://linuxhint.com/update-java-raspberry-pi/)
> - [Upgrading your Raspberry Pi to Bullseye](https://www.sanderh.dev/upgrade-Raspberry-Pi-bullseye/)
> - [Raspbian Mirrors](https://www.raspbian.org/RaspbianMirrors)
> - [How to change the Repository Mirror on Raspbian](https://pimylifeup.com/raspbian-repository-mirror/)

## repository
- `/etc/apt/source.list`
  ```bash
  $ cat /etc/apt/sources.list
  deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi
  # Uncomment line below then 'apt-get update' to enable 'apt-get source'
  # deb-src http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi

  # or
  $ cat /etc/apt/sources.list
  deb http://raspbian.raspberrypi.org/raspbian/ bullseye main contrib non-free rpi
  deb http://deb.debian.org/debian bullseye main contrib non-free
  deb http://security.debian.org/debian-security bullseye-security main contrib non-free
  deb http://deb.debian.org/debian bullseye-updates main contrib non-free
  ```

- `/etc/apt/sources.list.d/raspi.list`
  ```bash
  $ cat /etc/apt/sources.list.d/raspi.list
  deb http://archive.raspberrypi.org/debian/ bullseye main
  # Uncomment line below then 'apt-get update' to enable 'apt-get source'
  # deb-src http://archive.raspberrypi.org/debian/ bullseye main
  ```

## jdk

> [!NOTE|label:references:]
> - [* iMarslo: jdk/bellsoft](../tools/app/app.html#java)
> - [Liberica jdk : all versions](https://bell-sw.com/pages/downloads/)

# system
## timezone setup
```bash
$ sudo dpkg-reconfigure tzdata
```

## motd upgrade disable
```bash
$ sudo mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/org.90-updates-available.org
```

## set service auto-startup
```bash
$ sudo sysv-rc-config jenkins on
$ sudo sysv-rc-conf --list | grep jenkins
jenkins      0:off      1:off   2:on    3:on    4:on    5:on    6:off
$ sudo update-rc.d jenkins enable
update-rc.d: warning:  start runlevel arguments (none) do not match jenkins Default-Start values (2 3 4 5)
update-rc.d: warning:  stop runlevel arguments (none) do not match jenkins Default-Stop values (0 1 6)
 Enabling system startup links for /etc/init.d/jenkins ...
 Removing any system startup links for /etc/init.d/jenkins ...
   /etc/rc0.d/K20jenkins
   /etc/rc1.d/K20jenkins
   /etc/rc2.d/S20jenkins
   /etc/rc3.d/S20jenkins
   /etc/rc4.d/S20jenkins
   /etc/rc5.d/S20jenkins
   /etc/rc6.d/K20jenkins
 Adding system startup for /etc/init.d/jenkins ...
   /etc/rc0.d/K20jenkins -> ../init.d/jenkins
   /etc/rc1.d/K20jenkins -> ../init.d/jenkins
   /etc/rc6.d/K20jenkins -> ../init.d/jenkins
   /etc/rc2.d/S20jenkins -> ../init.d/jenkins
   /etc/rc3.d/S20jenkins -> ../init.d/jenkins
   /etc/rc4.d/S20jenkins -> ../init.d/jenkins
   /etc/rc5.d/S20jenkins -> ../init.d/jenkins
```

# application
## jdk and JAVA_HOME
* download jdk 1.8.0_121
  ```bash
  $ mkdir -p /opt/java && cd /opt/java
  $ wget --no-check-certificate \
         -c \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz

  # or
  $ curl -L -C - -b "oraclelicense=accept-securebackup-cookie" \
         -O http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
  $ tar xf jdk-8u121-linux-x64.tar.gz

  # or
  $ curl -L -C - -b "oraclelicense=accept-securebackup-cookie" \
         -fsS http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz |
    tar xzf - -C /opt/java
  ```

* setup java environment
  ```bash
  $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
  JAVA_HOME="/opt/java/jdk1.8.0_121"
  CLASSPATH=".:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar"
  PATH=/home/marslo/.marslo/myprograms/vim80/bin:$JAVA_HOME/bin:$PATH
  export JAVA_HOME CLASSPATH PATH
  EOF
  ```

* setup default jdk
  ```bash
  $ sudo update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_121/bin/java 999
  $ sudo update-alternatives --auto java
  $ sudo update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_121/bin/javac 999
  $ sudo update-alternatives --auto javac
  ```

## groovy
* download groovy binary pakcage
  ```bash
  $ mkdir -p /opt/groovy && cd /opt/groovy
  $ wget --no-check-certificate -c https://akamai.bintray.com/1c/1c4dff3b6edf9a8ced3bca658ee1857cee90cfed1ee3474a2790045033c317a9?__gda__=exp=1490346679~hmac=6d64a1c3596da50e470fb6a46b182ba2cacab553c66843c8ea292e1e70e4e243&response-content-disposition=attachment%3Bfilename%3D%22apache-groovy-binary-2.4.10.zip%22&response-content-type=application%2Foctet-stream&requestInfo=U2FsdGVkX19cWhR3RJcR6SCy74HUcDg470ifD-nH2EiE5uxtdI5EbUiW_jGoHgZZTVR3qgks9tiU5441axygT9z3ykqpL45d_-9oyTlOp8Gild5Z7iGRzCiwf0kba9uza8iWDxnIxgnUIg5tDe6N8ZQ3R0yFCY4c4w7czwBGyK0
  $ unzip apache-groovy-binary-2.4.10.zip
  ```

* setup groovy environment
  ```bash
  $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
  export GROOVY_HOME="/opt/groovy/groovy-2.4.10"'
  export PATH=$GROOVY_HOME/bin:$PATH'
  EOF
  ```

* set default groovy
  ```bash
  $ sudo update-alternatives --install /usr/bin/groovy groovy /opt/groovy/groovy-2.4.10/bin/groovy 999999999
  $ sudo update-alternatives --auto groovy

  # or
  $ sudo alternatives --config groovy
  ```

## gcc

> [!NOTE]
> - [Index of /sites/sourceware.org/pub/gcc/releases/](https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases)
> - [gcc.gnu.org](https://gcc.gnu.org/)
> - [Installing GCC](https://gcc.gnu.org/wiki/InstallingGCC)
> - [How To Install GCC on CentOS 7](https://linuxhostsupport.com/blog/how-to-install-gcc-on-centos-7/)

- install
  ```bash
  $ mdir -p /opt/gcc/gcc-13.2.0
  $ curl -fsSL https://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.2.0/gcc-13.2.0.tar.gz | tar xzf - -C /opt/gcc/gcc-13.2.0

  # prerequisites
  gcc-13.2.0 $ grep base_url= contrib/download_prerequisites
  base_url='http://gcc.gnu.org/pub/gcc/infrastructure/'
  gcc-13.2.0 $ ./contrib/download_prerequisites

  # config
  gcc-13.2.0 $ mkdir ../objdir && cd $_
  objdir $ ../gcc-13.2.0/configure --disable-multilib

  # make
  objdir $ NPROC="$(nproc)"
  objdir $ tmux                # it will take very long time to build, better using tmux to avoid interrupt by ssh session down
  objdir $ make -j${NPROC} [ | tee make.log ]

  # install
  objdir $ sudo make install
  ```

- configure
  ```bash
  $ sudo mv /usr/bin/g++{,.8.5.0}
  $ sudo mv /usr/bin/gcc{,.8.5.0}
  $ sudo mv /usr/bin/c++{,.8.5.0}

  $ sudo alternatives --install /usr/bin/g++ g++ /usr/local/bin/g++ 50
  $ sudo alternatives --install /usr/bin/gcc gcc /usr/local/bin/gcc 50
  $ sudo alternatives --install /usr/bin/c++ c++ /usr/local/bin/c++ 50
  ```

- verify
  ```bash
  $ gcc --version
  gcc (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  $ g++ --version
  g++ (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

  $ c++ --version
  c++ (GCC) 13.2.0
  Copyright (C) 2023 Free Software Foundation, Inc.
  This is free software; see the source for copying conditions.  There is NO
  warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  ```

## ruby

> [!NOTE|label:references:]
> - [How to Install Ruby 3.2 on CentOS & RHEL using RVM](https://tecadmin.net/install-ruby-3-on-centos/)
> - [rbenv/rbenv](https://github.com/rbenv/rbenv)
> - [rbenv/rbenv-installer](https://github.com/rbenv/rbenv-installer)
> - [* ftp:pub/ruby](https://ftp.ruby-lang.org/pub/ruby/)

- rbenv
  ```bash
  $ curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  # or
  $ wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer -O- | bash

  $ ~/.rbenv/bin/rbenv init
  $ echo 'export PATH="$PATH:$HOME/.rbenv/bin"' >> ~/.bashrc
  $ echo 'eval "$(/home/marslo/.rbenv/bin/rbenv init - bash)"' >> ~/.bashrc

  # list latest available versions
  $ rbenv install -l
  3.0.6
  3.1.4
  3.2.2
  3.3.0
  jruby-9.4.5.0
  mruby-3.2.0
  picoruby-3.0.0
  truffleruby-23.1.1
  truffleruby+graalvm-23.1.1

  # install
  $ rbenv install 3.3.0
  ==> Downloading ruby-3.3.0.tar.gz...
  -> curl -q -fL -o ruby-3.3.0.tar.gz https://cache.ruby-lang.org/pub/ruby/3.3/ruby-3.3.0.tar.gz
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100 21.0M  100 21.0M    0     0  27.6M      0 --:--:-- --:--:-- --:--:-- 27.5M
  ==> Installing ruby-3.3.0...
  -> ./configure "--prefix=$HOME/.rbenv/versions/3.3.0" --enable-shared --with-ext=openssl,psych,+
  -> make -j 32
  -> make install
  ==> Installed ruby-3.3.0 to /home/marslo/.rbenv/versions/3.3.0

  $ rbenv global 3.3.0
  ```

  - result
    ```bash
    $ ruby --version
    ruby 3.3.0 (2023-12-25 revision 5124f9ac75) [x86_64-linux]

    $ bundler --version
    Bundler version 2.5.3
    ```

- rvm
  ```bash
  $ sudo yum update -y
  $ sudo yum install curl gpg gcc gcc-c++ make libyaml-devel openssl-devel readline-devel zlib-devel -y

  $ command curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
  $ command curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
  $ curl -sSL https://get.rvm.io | bash -s stable
  $ echo "export PATH=\"$PATH:$HOME/.rvm/bin\"" >> ~/.bashrc

  # verify
  $ rvm --version
  rvm 1.29.12 (latest) by Michal Papis, Piotr Kuczynski, Wayne E. Seguin [https://rvm.io]

  # install ruby
  $ rvm install 3.3
  $ rvm use 3.3 --default
  ```

## mono

> [!NOTE]
> - [mono download](https://www.mono-project.com/download/stable/)
> - [mono repo](https://download.mono-project.com/repo/)

```bash
# centos 7
$ sudo su -c 'curl https://download.mono-project.com/repo/centos7-stable.repo |tee /etc/yum.repos.d/mono-centos7-stable.repo'

# centos 8
$ sudo rpm --import 'http://pool.sks-keyservers.net/pks/lookup?op=get&search=0x3fa7e0328081bff6a14da29aa6a19b38d3d831ef'
$ sudo dnf config-manager --add-repo https://download.mono-project.com/repo/centos8-stable.repo

$ sudo yum install mono-devel
$ mono --version
Mono JIT compiler version 6.12.0.107 (tarball Wed Dec  9 21:44:58 UTC 2020)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors. www.mono-project.com
        TLS:           __thread
        SIGSEGV:       altstack
        Notifications: epoll
        Architecture:  amd64
        Disabled:      none
        Misc:          softdebug
        Interpreter:   yes
        LLVM:          yes(610)
        Suspend:       hybrid
        GC:            sgen (concurrent by default)

# optional
$ sudo yum install mono-complete
```

## mysql
### built from source code
* build
  ```bash
  $ sudo groupadd mysql
  $ sudo useradd -g mysql mysql
  $ wget http://cdn.mysql.com/archives/mysql-5.5/mysql-5.5.41.tar.gz
  $ apt install ncurses-dev

  $ cd myaql-5.5.41
  $ cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
  -DDEFAULT_CHARSET=utf8 \
  -DDEFAULT_COLLATION=utf8_general_ci \
  -DENABLED_LOCAL_INFILE=ON \
  -DWITH_INNOBASE_STORAGE_ENGINE=1 \
  -DWITH_FEDERATED_STORAGE_ENGINE=1 \
  -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
  -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
  -DWITH_DEBUG=0 \
  -DMYSQL_TCP_PORT=3306
  $ make
  $ sudo make install

  $ sudo systemctl enable mysqld
  # or
  $ sysv-rc-conf mysqld on
  ```

* configure
  ```bash
  $ sudo chown -R mysql:mysql /usr/local/mysql
  $ /usr/local/mysql/scripts/mysql_install_db --user=mysql
  $ sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
  $ sudo chown -R root /usr/local/mysql/
  $ sudo chown -R mysql /usr/local/mysql/data
  $ /usr/local/mysql/bin/mysqld_safe --user=mysql &

  $ /usr/local/mysql/bin/mysqladmin -u root password '<PASSWORD>'
  # or
  $ /usr/local/mysql/bin/mysql_secure_installtion
  ```

### install from apt repo
```bash
$ sudo apt install mysql-server
```

#### install old version
```bash
$ sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
$ sudo apt update
$ sudo apt install mysql-server-5.6 mysql-client-5.6 -y
$ sudo mysql_secure_installation
```

#### reconfiguration
```bash
$ sudo service mysql start
$ sudo mysql_secure_installation
```

## mysql-connector (jdbc)
* download `mysql-connector-java-*.tar.gz` in [mysql official website](http://dev.mysql.com/downloads/connector/j) -> _Platform Independent_
  ```bash
  $ wget http://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz
  ```
