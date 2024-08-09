<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [mongosh](#mongosh)
  - [install](#install)
  - [configure](#configure)
    - [config.set](#configset)
    - [Customize the mongosh Prompt](#customize-the-mongosh-prompt)
    - [auto-completion](#auto-completion)
    - [local files](#local-files)
  - [`--eval`](#--eval)
    - [execute command](#execute-command)
    - [eval command and show as json format](#eval-command-and-show-as-json-format)
  - [interactive mode](#interactive-mode)
    - [connect to remote server](#connect-to-remote-server)
    - [utility](#utility)
    - [show all tables](#show-all-tables)
    - [list data](#list-data)
    - [query](#query)
    - [get key name](#get-key-name)
  - [operation](#operation)
    - [comparison operators](#comparison-operators)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# mongosh

> [!NOTE|label:references:]
> - [Troubleshoot Connection Issues](https://www.mongodb.com/docs/atlas/troubleshoot-connection/)
> - [* Collection Methods](https://www.mongodb.com/docs/manual/reference/method/js-collection/)
> - [mongodb-js/mongosh](https://github.com/mongodb-js/mongosh)

## install

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

- check info
  ```bash
  $ mongosh --build-info
  ```

## configure

> [!NOTE|label:references:]
> - [Configure mongosh](https://www.mongodb.com/docs/mongodb-shell/configure-mongosh/)
> - [Configure Settings Using a Configuration File](https://www.mongodb.com/docs/mongodb-shell/reference/configure-shell-settings-global/#std-label-configure-settings-global)
>   - windows: `mongosh.cfg` same directory as `mongosh.exe`
>   - osx:
>       - `/usr/local/etc/mongosh.conf`
>       - `/opt/homebrew/etc/mongosh.conf`
>       - `/etc/mongosh.conf`
>   - linux: `/etc/mongosh.conf`
> - [Execute Code From a Configuration File](https://www.mongodb.com/docs/mongodb-shell/write-scripts/#std-label-mongosh-write-scripts-config-file)
> - [Configure Settings](https://www.mongodb.com/docs/mongodb-shell/reference/configure-shell-settings/)

```bash
# ubuntu 22.04
$ cat /etc/mongosh.conf
mongosh:
  displayBatchSize: 3000
```

### [config.set](https://stackoverflow.com/a/3705615/2940319)

> [!NOTE|label:references:]
> - [Printing Mongo query output to a file while in the mongo shell](https://stackoverflow.com/a/49654241/2940319)

```bash
db_name> DBQuery.shellBatchSize = 300

# verify
db_name> config.get('displayBatchSize')
300
db_name> config.set("displayBatchSize", 3000)
Setting "displayBatchSize" has been changed
db_name> config.get('displayBatchSize')
3000
db_name> config.get('inspectDepth')
6
$ cat ~/.mongodb/mongosh/config | jq -r .displayBatchSize
3000

# or via cmd
$ mongosh --eval 'DBQuery.shellBatchSize = 2000; db...'
```

### [Customize the mongosh Prompt](https://www.mongodb.com/docs/mongodb-shell/reference/customize-prompt/)

### auto-completion
```bash
$ npm i -g @mongosh/autocomplete
```

### local files

> [!NOTE|label:references:]
> - [Retrieve Shell Logs](https://www.mongodb.com/docs/mongodb-shell/logs/)

- logs

  | OPERATING SYSTEM  | PATH                                                  |
  | ----------------- | ----------------------------------------------------- |
  | macOS             | `~/.mongodb/mongosh/<LogID>_log`                      |
  | Linux             | `~/.mongodb/mongosh/<LogID>_log`                      |
  | Windows           | `%LOCALAPPDATA%/mongodb/mongosh/<LogID>_log`          |

  ```powershell
  > Get-Content %LOCALAPPDATA%/mongodb/mongosh/<LogID>_log
  ```

- command-line history

  | OPERATING SYSTEM | PATH                                                  |
  |------------------|-------------------------------------------------------|
  | macOS            | `~/.mongodb/mongosh/mongosh_repl_history`             |
  | Linux            | `~/.mongodb/mongosh/mongosh_repl_history`             |
  | Windows          | `%UserProfile%/.mongodb/mongosh/mongosh_repl_history` |

## `--eval`

### execute command
- list all `_id`
  ```bash
  $ mongosh "mongodb://mongodb.domain.com:27017" \
            --username username \
            --password $(pass show path/to/credential) \
            --authenticationDatabase db_name \
            --eval 'use db_name' \
            --eval 'db.collection.distinct("_id")' |

  # or
  $ mongosh "mongodb://mongodb.domain.com:27017" \
            --username username \
            --password $(pass show path/to/credential) \
            --authenticationDatabase db_name \
            --eval "db = db.getSiblingDB('db_name'); db.collection.distinct('_id')" |
    tr "'" '"'

  ```

### eval command and show as json format
```bash
$ mongosh "mongodb://mongodb.domain.com:27017" \
          --username username \
          --password $(pass show path/to/credential) \
          --authenticationDatabase db_name \
          --json=relaxed \
          --eval 'use db_name' \
          --eval 'printjson(db.collection.distinct("_id"))'

# or
$ mongosh "mongodb://mongodb.domain.com:27017" \
          --username username \
          --password $(pass show path/to/credential) \
          --authenticationDatabase db_name \
          --eval "db = db.getSiblingDB('db_name'); printjson(db.collection.distinct('_id'))" |
  tr "'" '"'

```

## interactive mode

> [!NOTE|label:references:]
> - [Run Commands](https://www.mongodb.com/docs/mongodb-shell/run-commands/)
> - [Collection Methods](https://www.mongodb.com/docs/manual/reference/method/js-collection/)
> - [mongosh Methods](https://www.mongodb.com/docs/manual/reference/method/)
> - [Methods](https://www.mongodb.com/docs/mongodb-shell/reference/methods/)
> - [Options](https://www.mongodb.com/docs/mongodb-shell/reference/options/)

### connect to remote server

> [!NOTE|label:references:]
> - [Connect to a Deployment](https://www.mongodb.com/docs/mongodb-shell/connect/)
> - [Connect via mongosh](https://www.mongodb.com/docs/atlas/mongo-shell-connection/)

```bash
# login
$ mongosh --host mongodb.domain.com \
          --port 27017 \
          --username 'username' \
          --password $(pass show path/to/credential) \
          --authenticationDatabase 'db_name'

# or
$ mongosh 'mongodb://mongodb.domain.com:27017' \
          --username 'username' \
          --password $(pass show path/to/credential) \
          --authenticationDatabase 'db_name'

Current Mongosh Log ID: 66b5a880d70a325006838725
Connecting to:          mongodb://<credentials>@mongodb.domain.com:27017/?directConnection=true&authSource=db_name&appName=mongosh+2.2.15
Using MongoDB:          6.0.2
Using Mongosh:          2.2.15
For mongosh info see: https://docs.mongodb.com/mongodb-shell/
test>

# use database
test> use db_name
switched to db db_name

db_name> db.hello()
{
  isWritablePrimary: true,
  topologyVersion: {
    processId: ObjectId('6616e407a0520bbbc6dbeace'),
    counter: Long('0')
  },
  maxBsonObjectSize: 16777216,
  maxMessageSizeBytes: 48000000,
  maxWriteBatchSize: 100000,
  localTime: ISODate('2024-08-09T05:52:20.150Z'),
  logicalSessionTimeoutMinutes: 30,
  connectionId: 235951,
  minWireVersion: 0,
  maxWireVersion: 17,
  readOnly: false,
  ok: 1
}
```

### utility

> [!NOTE|label:references:]
> - [mongosh Help](https://www.mongodb.com/docs/mongodb-shell/reference/access-mdb-shell-help/)
> - [EDITOR](https://stackoverflow.com/a/62803504/2940319)

```bash
db_name> help
db_name> db.collection.help()

# show dbs
test> show dbs

# get current db name
db_name> db.collection.getDB()
db_name

# get current collection name
db_name> db.collection.getName()
collection

# get stat of collection
db_name> db.collection.stats()
```

- [equivalent for "use db_name"](https://www.tutorialkart.com/mongodb/mongo-script/#gsc.tab=0)

  > [!NOTE|label:references:]
  > - [Specify which database to use in mongodb .js script](https://stackoverflow.com/a/64681997/2940319)
  > - [Script Does Not Include Connection Details](https://www.mongodb.com/docs/mongodb-shell/write-scripts/#script-does-not-include-connection-details)
  >   - [`db.getSiblingDB(<database>)`](https://www.mongodb.com/docs/manual/reference/method/db.getSiblingDB/#mongodb-method-db.getSiblingDB)

  ```bash
  db_name> db = db.getSiblingDB('db_name')
  ```

### show all tables

> [!NOTE|label:references:]
> - [How can I list all collections in the MongoDB shell?](https://stackoverflow.com/a/23734995/2940319)

```bash
db_name> db.getCollectionNames()

# or
db_name> show tables

# or
db_name> show collections
```

- [fileter tables](https://stackoverflow.com/a/51773579/2940319)
  ```bash
  db_name> db.getCollectionNames().filter( function(CollectionName) { return /klocwork/.test(CollectionName) })
  [ 'klocwork', 'klocwork_new' ]
  ```

### list data

> [!NOET|label:references:]
> - [How can I get all the doc ids in MongoDB?](https://stackoverflow.com/a/28389836/2940319)

- find the first data in table/collection
  ```bash
  db_name> db.collection.findOne()
  ```

-  list all data in table/collection
  ```bash
  db_name> printjson( db.getCollection('jobs').find().toArray() )

  # or
  db_name> db.collection.find().pretty()
  # or
  db_name> db.collection.find().toArray()
  ```

- get count
  ```bash
  db_name> db.collection.countDocuments()
  19

  # or
  db_name> db.collection.estimatedDocumentCount()
  19
  ```

- data size
  ```bash
  db_name> db.collection.dataSize()
  5068
  ```

### query

> [!NOTE|label:references:]
> - [How can I get all the doc ids in MongoDB?](https://stackoverflow.com/a/28389836/29403190)
> - [Query an Array](https://www.mongodb.com/docs/manual/tutorial/query-arrays/#query-an-array)
> - [List all values of a certain field in mongodb](https://stackoverflow.com/a/23273541/2940319)

- find data by `_id`
  ```bash
  db_name> db.collection.distinct('_id')
  [
    ObjectId('6544a0a06bdbf57e9914b1cd'),
    ObjectId('6544a3a5ba2f29b94c8eb4b1'),
    ObjectId('65450b1a715f2a7eb0c95658')
  ]

  # or
  db_name> db.collection.find({},{_id:1})
  [
    { _id: ObjectId('6544a0a06bdbf57e9914b1cd') },
    { _id: ObjectId('6544a3a5ba2f29b94c8eb4b1') },
    { _id: ObjectId('65450b1a715f2a7eb0c95658') }
  ]

  # or
  db_name> db.collection.find( {}, {_id:1} ).map( function(item){ return item._id; } )

  # or
  db_name> db.collection.find( {}, {_id:1} ).map( x => x._id )

  # or: https://stackoverflow.com/a/28389836/2940319
  db_name> db.runCommand ( { distinct: "collection", key: "_id" } )

  # or
  db_name> var arr=[]
  db_name> db.collection.find( {},{_id:1} ).forEach( function(doc){arr.push(doc._id)} )
  db_name> printjson( arr )
  ```

- list 2 columns
  ```bash
  db_name> db.collection.find({},{_id:1, timestamp:1}).pretty()

  # or
  db_name> db.collection.find({},{_id:1, timestamp:1}).toArray()

  # or
  db_name> printjson(db.collection.find({}, {_id:1, user:2}))
  ```

- query fiels in conditions

  > [!NOTE|label:references:]
  > - [Return only one field from MongoDB query](https://stackoverflow.com/a/70650152/2940319)
  > - [Search multiple fields for multiple values in MongoDB](https://stackoverflow.com/a/21418007/2940319)

  ```bash
  db_name> db.collection.find({user: 'Marslo Jiao'}, {_id:1, timestamp:2}).pretty()
  [
    {
      _id: ObjectId('66a14d301ce9a4bb04e8c2e1'),
      timestamp: '2024-07-24 11:51:28 PDT'
    },
    {
      _id: ObjectId('66a161038305d663fb9f6f0f'),
      timestamp: '2024-07-24 13:16:03 PDT'
    }
  ]

  # or
  db_name> db.collection.find({user: 'Marslo Jiao'}, {_id:1, timestamp:2}).toArray()
  [
    {
      _id: ObjectId('66a14d301ce9a4bb04e8c2e1'),
      timestamp: '2024-07-24 11:51:28 PDT'
    },
    {
      _id: ObjectId('66a161038305d663fb9f6f0f'),
      timestamp: '2024-07-24 13:16:03 PDT'
    }
  ]
  ```

- query in multiple values
  ```bash
  db_name> db.log_dashboard_docker.find( {'user': {$in: ['Marslo Jiao', 'John Doe']}}, {_id:1, timestamp:2} )
  ```

### get key name

> [!NOTE|label:references:]
> - [Get names of all keys in the collection](https://stackoverflow.com/a/2308036/2940319)

```bash
db_name> var arr=[]
db_name> db.collection.find().forEach(function(doc){Object.keys(doc).forEach(function(key){arr[key]=1})})
db_name> arr
[
  _id: 1,
  user: 1,
  update_details: 1,
  timestamp: 1
]

# or
db_name> doc = db.collection.findOne();
db_name> for ( key in doc ) print( key )
_id
user
update_details
timestamp
```

## operation
### comparison operators

> [!NOTE|label:references:]
> - [How to use comparison operators in MongoDB?](https://developerslogblog.wordpress.com/2019/10/15/mongodb-how-to-filter-by-multiple-fields/)

| OPERATOR | DESCRIPTION                |
|----------|----------------------------|
| `$eq`    | equal (=)                  |
| `$gt`    | greater than >             |
| `$gte`   | greater or equal than (>=) |
| `$in`    | in (in)                    |
| `$lt`    | less than (<)              |
| `$lte`   | less or equal than (<=)    |
| `$ne`    | not equal ()               |
| `$nin`   | not in (not in )           |

