<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Install MySQL from Source code](#install-mysql-from-source-code)
  - [Usefull Links](#usefull-links)
  - [Compile and Install](#compile-and-install)
  - [Configuration and Initial](#configuration-and-initial)
  - [Set Environment](#set-environment)
  - [Check the mysql port](#check-the-mysql-port)
  - [Check variables](#check-variables)
- [Make mysql as boot start](#make-mysql-as-boot-start)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Install MySQL from Source code
### Usefull Links
- Community Server
    - [5.7 MySQL Community Server](http://dev.mysql.com/downloads/mysql/)
    - [5.6 MySQL Community Server](http://dev.mysql.com/downloads/mysql/5.6.html)
- MySQL source code
    - [mysql-5.7.3-m13.tar.gz](http://cdn.mysql.com/Downloads/MySQL-5.7/mysql-5.7.3-m13.tar.gz)
    - [mysql-5.6.16.tar.gz](http://dev.mysql.com/get/Downloads/MySQL-5.6/mysql-5.6.16.tar.gz)
- Documents
  - [MySQL Document](http://dev.mysql.com/doc/)
  - [MySQL Online manual](http://dev.mysql.com/doc/refman/5.7/en/)
  - [2.8.2. Installing MySQL Using a Standard Source Distribution](http://dev.mysql.com/doc/refman/5.7/en/installing-source-distribution.html)
  - [2.8.4. MySQL Source-Configuration Options](http://dev.mysql.com/doc/refman/5.7/en/source-configuration-options.html)

### Compile and Install
#### Preconfiguration Setup
##### Create user and group
```bash
$ sudo groupadd mysql
$ sudo useradd -r -g mysql mysql
```

##### Extract tar.gz
```bash
$ tar xf mysql-5.7.3-m13.tar.gz
$ cd mysql-5.7.3-m13
```

#### Compile and Install
```bash
$ cmake . -DCMAKE_INSTALL_PREFIX=/usr/local/mysql \
> -DDEFAULT_CHARSET=gbk \
> -DDEFAULT_COLLATION=gbk_chinese_ci \
> -DENABLED_LOCAL_INFILE=ON \
> -DWITH_INNOBASE_STORAGE_ENGINE=1 \
> -DWITH_FEDERATED_STORAGE_ENGINE=1 \
> -DWITH_BLACKHOLE_STORAGE_ENGINE=1 \
> -DMYSQL_UNIX_ADDR=/tmp/mysqld.sock \
> -DWITH_DEBUG=0 \
> -DMYSQL_TCP_PORT=3306
$ make
$ sudo make install
```

##### [cmake logs](https://github.com/Marslo/MyNotes/blob/master/MySQL/MySQL_Cmake_Logs.md)

### Configuration and Initial
#### Permission Manager
```bash
$ sudo chown -R mysql:mysql /usr/local/mysql
```

#### Initial MySQL
```bash
$ scripts/mysql_install_db --user=mysql
$ cp support-files/mysql.server /etc/init.d/mysqld
```

##### [Log of mysql_install_db --user=mysql](https://github.com/Marslo/MyNotes/blob/master/MySQL/mysql_install_db.md)

#### Change Permission again

```bash
$ sudo chown -R root .
$ sudo chown -R mysql data
```

#### Start mysqld_safe

```bash
$ sudo bin/mysqld_safe --user=mysql &
```

#### Setup root password

```bash
$ sudo ./bin/mysqladmin -u root password '<PASSWORDHERE>'
# Or
$ sudo ./bin/mysql_secure_installation
```

##### [Log of mysql_secure_installatioin](https://github.com/Marslo/MyNotes/blob/master/MySQL/mysql_secure_installation.md)

### Set Environment
```bash
$ sudo bash -c 'cat >> /etc/bash.bashrc' << EOF
> export PATH=/usr/local/mysql/bin:$PATH
> EOF
```

### Check the mysql port
```bash
$ sudo netstat -tunlp  | grep 3306
tcp6       0      0 :::3306                 :::*                    LISTEN      21712/mysqld
```

### Check variables

```bash
$ mysqladmin variables -p
Enter password:
```

## Make mysql as boot start

```bash
$ sudo chkconfig --add mysqld
$ sudo chkconfig --level 345 mysqld on
```
