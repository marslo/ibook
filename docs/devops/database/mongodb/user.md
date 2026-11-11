

## admin

### admin but not root

```bash
$ docker exec -it MONGODB_SERVER mongosh --quiet --eval '
  db.getSiblingDB( "admin" ).createUser( {
    user: "ADMIN_USER",
    pwd: passwordPrompt(),
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "readWriteAnyDatabase", db: "admin" } ],
    mechanisms: [ "SCRAM-SHA-256" ]
  } )'
Enter password
********************************{ ok: 1 }
```

```bash
# ─── convert to root role ───────────────────────────────────────────────────────────────
# grant root role to ADMIN_USER user
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval 'db.getSiblingDB( "admin" ).grantRolesToUser( "ADMIN_USER", [ { role: "root", db: "admin" } ] ); printjson( db.getSiblingDB( "admin" ).getUser( "ADMIN_USER" ).roles )'
# and remove the redundant roles
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval '
  db.getSiblingDB( "admin" ).grantRolesToUser( "ADMIN_USER", [ { role: "root", db: "admin" } ] );
  db.getSiblingDB( "admin" ).revokeRolesFromUser( "ADMIN_USER", [ { role: "userAdminAnyDatabase", db: "admin" }, { role: "readWriteAnyDatabase", db: "admin" } ] );
  printjson( db.getSiblingDB( "admin" ).getUser( "ADMIN_USER" ).roles )'

# ─── verify ───────────────────────────────────────────────────────────────────────────────
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval 'printjson( db.getSiblingDB( "admin" ).getUsers() )'
Enter password: ********************************
{
  users: [
    {
      _id: 'admin.ADMIN_USER',
      userId: UUID('5*******-****-****-****-***********e'),
      user: 'ADMIN_USER',
      db: 'admin',
      roles: [ { role: 'root', db: 'admin' } ],
      mechanisms: [ 'SCRAM-SHA-256' ]
    }
  ],
  ok: 1
}
```

### admin and root

```bash
$ docker exec -it MONGODB_SERVER mongosh --quiet --eval '
  db.getSiblingDB( "admin" ).createUser( {
    user: "ADMIN_USER",
    pwd: passwordPrompt(),
    roles: [ { role: "root", db: "admin" } ],
    mechanisms: [ "SCRAM-SHA-256" ]
  } )'
```

### restrict access to localhost only
```bash
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval '
  db.getSiblingDB( "admin" ).updateUser( "ADMIN_USER", {
    authenticationRestrictions: [ { clientSource: [ "127.0.0.1", "::1" ] } ]
  } )'
Enter password: ********************************
{ ok: 1 }
```

## app user

```bash
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval '
  db.getSiblingDB( "APP_DB_NAME" ).createUser( {
    user: "APP_USER",
    pwd: passwordPrompt(),
    roles: [ { role: "readWrite", db: "APP_DB_NAME" } ],
    mechanisms: [ "SCRAM-SHA-256" ]
  } )'
Enter password: ********************************
Enter password
************************{ ok: 1 }
```

## verify

```bash
# unauthenticated → "requires authentication"
$ docker exec MONGODB_SERVER mongosh --quiet --eval 'db.getSiblingDB( "admin" ).runCommand( { listDatabases: 1 } )'

# app user → { ok: 1 }
$ docker exec -it MONGODB_SERVER mongosh -u APP_USER --authenticationDatabase APP_DB_NAME APP_DB_NAME --quiet --eval 'db.runCommand( { ping: 1 } )'

# app user on admin → "not authorized"
$ docker exec -it MONGODB_SERVER mongosh -u APP_USER --authenticationDatabase APP_DB_NAME --quiet --eval 'db.getSiblingDB( "admin" ).system.users.findOne()'

# admin role → [ { role: 'root', db: 'admin' } ]
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval 'printjson( db.getSiblingDB( "admin" ).getUser( "ADMIN_USER" ).roles )'

# admin restriction stored → [ { clientSource: [ '127.0.0.1', '::1' ] } ]
$ docker exec -it MONGODB_SERVER mongosh -u ADMIN_USER --authenticationDatabase admin --quiet --eval 'printjson( db.getSiblingDB( "admin" ).getUser( "ADMIN_USER", { showAuthenticationRestrictions: true } ).authenticationRestrictions )'

# admin over the network → "Authentication failed"
$ docker run --rm -it --network MONGO_NETWORK --entrypoint mongosh "${MONGO_IMAGE}" --host MONGODB_SERVER -u ADMIN_USER --authenticationDatabase admin --quiet --eval 'db.runCommand( { ping: 1 } )'

# WiredTiger cache cap → cache_size=256M
$ docker logs MONGODB_SERVER 2>&1 | grep -o -m1 'cache_size=[0-9]*M'

# dashboard mongo untouched
$ docker ps --filter name=MONGODB_SERVER --format '{{.Names}}  {{.Status}}'
```
