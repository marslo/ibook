<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [mongosh](#mongosh)
  - [install](#install)
  - [connect to remote server](#connect-to-remote-server)
  - [execute command](#execute-command)
  - [execute command and print as json format](#execute-command-and-print-as-json-format)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## mongosh

> [!NOTE|label:references:]
> - [Troubleshoot Connection Issues](https://www.mongodb.com/docs/atlas/troubleshoot-connection/)
> - [Collection Methods](https://www.mongodb.com/docs/manual/reference/method/js-collection/)

### install

> [!NOTE|label:references:]
> - [Welcome to MongoDB Shell (mongosh)](https://www.mongodb.com/docs/mongodb-shell)
> - [Install mongosh](https://www.mongodb.com/docs/mongodb-shell/install/)

- universal
  ```bash
  $ version='mongosh-2.2.15-linux-arm64'
  $ curl -fsSL https://downloads.mongodb.com/compass/${version}.tgz | tar xzf - -C /opt/mongosh

  # setup PATH
  $ echo "export PATH=\$PATH:/opt/mongosh/${version}/bin" >> ~/.bashrc
  $ source ~/.bashrc

  # or link binary into PATH
  $ sudo cp /opt/mongosh/${version}/bin/mongosh_crypt_v1.dylib /usr/local/lib/
  $ sudo ln -s /opt/mongosh/${version}/bin/mongosh /usr/local/bin/mongosh
  ```

- debain
  ```bash
  $ sudo apt-get install gnupg
  $ wget -qO- https://www.mongodb.org/static/pgp/server-7.0.asc | sudo tee /etc/apt/trusted.gpg.d/server-7.0.asc

  # ubuntu 18.04
  $ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  # ubuntu 20.04
  $ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list
  # ubuntu 22.04
  $ echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

  # install
  $ sudo apt-get update
  $ sudo apt-get install -y mongodb-mongosh

  # or openssl 1.1
  $ sudo apt-get install -y mongodb-mongosh-shared-openssl11
  # or openssl 3.0
  $ sudo apt-get install -y mongodb-mongosh-shared-openssl3
  ```

- centos
  ```bash
  $ sudo bash -c "cat > /etc/yum.repos.d/mongodb-org-7.0.repo" <<EOF
  [mongodb-org-7.0]
  name=MongoDB Repository
  baseurl=https://repo.mongodb.org/yum/redhat/$releasever/mongodb-org/7.0/$basearch/
  gpgcheck=1
  enabled=1
  gpgkey=https://www.mongodb.org/static/pgp/server-7.0.asc
  EOF

  # install
  $ sudo yum install -y mongodb-mongosh
  # or openssl 1.1
  $ sudo yum install -y mongodb-mongosh-shared-openssl11
  # or openssl 3.0
  $ sudo yum install -y mongodb-mongosh-shared-openssl3

  # or RHEL8
  $ sudo yum install -y https://repo.mongodb.org/yum/redhat/8/mongodb-org/7.0/x86_64/RPMS/mongodb-mongosh-7.0.0-1.el8.x86_64.rpm
  ```

### connect to remote server
```bash
$ mongosh "mongodb://mongodb.domain.com:27017" --username 'username' --password 'password' --authenticationDatabase 'db_name'

# using pass tool
$ mongosh "mongodb://mongodb.domain.com:27017" \
          --username 'username' \
          --password $(pass show path/to/credential) \
          --authenticationDatabase 'db_name'
```

### execute command
- list all `_id`
  ```bash
  $ mongosh "mongodb://mongodb.domain.com:27017" \
            --username username \
            --password $(pass show path/to/credential) \
            --authenticationDatabase db_name \
            --eval "db = db.getSiblingDB('db_name'); db.klocwork.distinct('_id')" |
    tr "'" '"'
  ```

### execute command and print as json format
```bash
$ mongosh "mongodb://mongodb.domain.com:27017" \
          --username username \
          --password $(pass show path/to/credential) \
          --authenticationDatabase db_name \
          --eval "db = db.getSiblingDB('db_name'); printjson(db.klocwork.distinct('_id'))" |
  tr "'" '"'
```
