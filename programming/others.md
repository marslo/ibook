<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Import data to SQL and print process](#import-data-to-sql-and-print-process)
- [Get the cnf file location for MySQL](#get-the-cnf-file-location-for-mysql)
- [Get the git change from .git/objects](#get-the-git-change-from-gitobjects)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Import data to SQL and print process
```bash
$ (pv -n ~/database.sql | mysql -u root -pPASSWORD -D database_name) 2>&1 | zenity --width 550 --progress --auto-close --auto-kill --title "Im
```

### Get the cnf file location for MySQL

```bash
$ mysql - ? | grep ".cnf" -C 1
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
The following groups are read: mysql client
```

### Get the git change from .git/objects

```bash
$ find .git/objects -type f -printf "%P\n" | sed s,/,, | while read object; do
    echo "=== $obj $(git cat-file -t $object) ==="
    git cat-file -p $object
done
```
