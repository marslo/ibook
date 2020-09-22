<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [APT](#apt)
  - [APT Configuration](#apt-configuration)
  - [Necessory Pckages and Dependencies](#necessory-pckages-and-dependencies)
  - [Package Auto-Upgrade Dislable](#package-auto-upgrade-dislable)
  - [Disable Server Auto Upgrade](#disable-server-auto-upgrade)
  - [Revert Hold Settings](#revert-hold-settings)
  - [Show all Hold](#show-all-hold)
  - [Complete Remove an App](#complete-remove-an-app)
- [System](#system)
  - [Timezone Setup](#timezone-setup)
  - [MOTD Upgrade Disable](#motd-upgrade-disable)
  - [Set Service Auto-Startup](#set-service-auto-startup)
- [Application](#application)
  - [JDK and JAVA_HOME](#jdk-and-java_home)
  - [Groovy](#groovy)
  - [MySQL](#mysql)
    - [Built from Source Code](#built-from-source-code)
    - [Install from APT Repo](#install-from-apt-repo)
    - [Install old version](#install-old-version)
    - [Reconfiguration](#reconfiguration)
  - [MySQL-Connector (JDBC)](#mysql-connector-jdbc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# APT
## APT Configuration

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

## Necessory Pckages and Dependencies

    $ sudo apt --list upgradable
    $ sudo apt upgrade
    $ sudo apt install sysv-rc-conf tree dos2unix iptables-persistent mailutils policycoreutils build-essential landscape-common gcc g++ make cmake

## Package Auto-Upgrade Dislable

    $ sudo sed -i 's/Prompt=.*/Prompt=never/' /etc/update-manager/release-upgrades
    $ sudo sed -i 's/"1"/"0"/' /etc/apt/apt.conf.d/10periodic
    $ sudo sed -i 's/"1"/"0"/' /etc/apt/apt.conf.d/20auto-upgrades

## Disable Server Auto Upgrade

    # dpkg --list | grep jenkins
    ii  jenkins                            2.19.4                             all          Jenkins monitors executions of repeated jobs, such as building a software
    # echo "jenkins hold" | dpkg --set-selections
    OR
    # apt-mark hold jenkins
    # dpkg --list | grep jenkins
    hi  jenkins                            2.19.4                             all          Jenkins monitors executions of repeated jobs, such as building a software

## Revert Hold Settings

    # echo "jenkins install" | dpkg --set-selections
    OR
    # apt-mark unhold jenkins

## Show all Hold

    # apt-mark showhold

## Complete Remove an App

    # systemctl stop mysql
    # apt-get --purge autoremove mysql*
    # apt-get autoclean
    # apt --purge autoremove mysql*
    # apt autoclean
    # apt list --installed | grep mysql
    # rm -rf /var/lib/mysql/debian-*.flag
    # rm -rf /var/lib/mysql
    # rm -rf /etc/mysql


# System
## Timezone Setup

    # sudo dpkg-reconfigure tzdata

## MOTD Upgrade Disable

    # sudo mv /etc/update-motd.d/90-updates-available /etc/update-motd.d/org.90-updates-available.org

## Set Service Auto-Startup

    # sysv-rc-config jenkins on
    # sysv-rc-conf --list | grep jenkins
    jenkins      0:off      1:off   2:on    3:on    4:on    5:on    6:off
    # update-rc.d jenkins enable
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

# Application
## JDK and JAVA_HOME
* Download JDK 1.8.0_121

        # mkdir -p /opt/java && cd /opt/java
        # wget --no-check-certificate -c --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
        OR
        # curl -L -C - -b "oraclelicense=accept-securebackup-cookie" -O http://download.oracle.com/otn-pub/java/jdk/8u121-b13/e9e7ea248e2c4826b92b3f075a80e441/jdk-8u121-linux-x64.tar.gz
        # tar xf jdk-8u121-linux-x64.tar.gz

* Setup JAVA environment

        $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
        JAVA_HOME="/opt/java/jdk1.8.0_121"
        CLASSPATH=".:$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar"
        PATH=/home/marslo/.marslo/myprograms/vim80/bin:$JAVA_HOME/bin:$PATH
        export JAVA_HOME CLASSPATH PATH
        EOF

* Setup default JDK

        # update-alternatives --install /usr/bin/java java /opt/java/jdk1.8.0_121/bin/java 999
        # update-alternatives --auto java
        # update-alternatives --install /usr/bin/javac javac /opt/java/jdk1.8.0_121/bin/javac 999
        # update-alternatives --auto javac

## Groovy
* Download Groovy Binary Pakcage

        # mkdir -p /opt/groovy && cd /opt/groovy
        # wget --no-check-certificate -c https://akamai.bintray.com/1c/1c4dff3b6edf9a8ced3bca658ee1857cee90cfed1ee3474a2790045033c317a9?__gda__=exp=1490346679~hmac=6d64a1c3596da50e470fb6a46b182ba2cacab553c66843c8ea292e1e70e4e243&response-content-disposition=attachment%3Bfilename%3D%22apache-groovy-binary-2.4.10.zip%22&response-content-type=application%2Foctet-stream&requestInfo=U2FsdGVkX19cWhR3RJcR6SCy74HUcDg470ifD-nH2EiE5uxtdI5EbUiW_jGoHgZZTVR3qgks9tiU5441axygT9z3ykqpL45d_-9oyTlOp8Gild5Z7iGRzCiwf0kba9uza8iWDxnIxgnUIg5tDe6N8ZQ3R0yFCY4c4w7czwBGyK0
        # unzip apache-groovy-binary-2.4.10.zip

* Setup Groovy Environment

        $ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
        export GROOVY_HOME="/opt/groovy/groovy-2.4.10"'
        export PATH=$GROOVY_HOME/bin:$PATH'
        EOF

* Set Default Groovy

        # update-alternatives --install /usr/bin/groovy groovy /opt/groovy/groovy-2.4.10/bin/groovy 999999999
        # update-alternatives --auto groovy

## MySQL
### Built from Source Code
* Build

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
        or
        $ sysv-rc-conf mysqld on

* Configure

        $ sudo chown -R mysql:mysql /usr/local/mysql
        $ /usr/local/mysql/scripts/mysql_install_db --user=mysql
        $ sudo cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
        $ sudo chown -R root /usr/local/mysql/
        $ sudo chown -R mysql /usr/local/mysql/data
        $ /usr/local/mysql/bin/mysqld_safe --user=mysql &
        $ /usr/local/mysql/bin/mysqladmin -u root password '<PASSWORD>'
        OR
        $ /usr/local/mysql/bin/mysql_secure_installtion

### Install from APT Repo

    $ sudo apt install mysql-server

### Install old version

    $ sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
    $ sudo apt update
    $ sudo apt install mysql-server-5.6 mysql-client-5.6 -y
    $ sudo mysql_secure_installation

### Reconfiguration

    $ sudo service mysql start
    $ sudo mysql_secure_installation

## MySQL-Connector (JDBC)
* Download `mysql-connector-java-*.tar.gz` at [MySQL Official Website](http://dev.mysql.com/downloads/connector/j) -> _Platform Independent_

        $ wget http://cdn.mysql.com//Downloads/Connector-J/mysql-connector-java-5.1.40.tar.gz
