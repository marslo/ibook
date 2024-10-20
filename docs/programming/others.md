<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [java](#java)
- [others](#others)
  - [import data to sql and print process](#import-data-to-sql-and-print-process)
  - [get the cnf file location for mysql](#get-the-cnf-file-location-for-mysql)
  - [get the git change from .git/objects](#get-the-git-change-from-gitobjects)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## java

> [!NOTE|label:references:]
> - [Spring Boot Development Using Command Line Only](https://javadev.org/devtools/ide/neovim/example/)

## others
### import data to sql and print process
```bash
$ (pv -n ~/database.sql | mysql -u root -pPASSWORD -D database_name) 2>&1 | zenity --width 550 --progress --auto-close --auto-kill --title "Im
```

### get the cnf file location for mysql
```bash
$ mysql - ? | grep ".cnf" -C 1
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
The following groups are read: mysql client
```

### get the git change from .git/objects
```bash
$ find .git/objects -type f -printf "%P\n" | sed s,/,, | while read object; do
    echo "=== $obj $(git cat-file -t $object) ==="
    git cat-file -p $object
done
```
