<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Log for ./bin/mysql_secure_installation](#log-for-binmysql_secure_installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Log for ./bin/mysql_secure_installation
```bash
$ sudo ./bin/mysql_secure_installation

NOTE: RUNNING ALL THE STEPS FOLLOWING THIS IS RECOMMENDED
FOR ALL MySQL SERVERS IN PRODUCTION USE!  PLEASE READ EACH
STEP CAREFULLY!


In order to log into MySQL to secure it, we'll need the
current password for the root user. If you've just installed
MySQL, and you haven't set the root password yet, the
password will be blank, so you should just press enter here.

Enter password:


OK, successfully used password, moving on...

validate_password plugin is installed on the server.
The subsequent steps will run with the existing configuration
of the plugin.


Setting the root password ensures that nobody can log into
the MySQL root user without the proper authorisation.
You already have a root password set.


Strength of the password: 25

Change the root password? (Press y|Y for Yes, any other key for No) : n

 ... skipping.

By default, a MySQL installation has an anonymous user,
allowing anyone to log into MySQL without having to have
a user account created for them. This is intended only for
testing, and to make the installation go a bit smoother.
You should remove them before moving into a production
environment.

Remove anonymous users? (Press y|Y for Yes, any other key for No) : y


Success.. Moving on..



Normally, root should only be allowed to connect from
'localhost'. This ensures that someone cannot guess at
the root password from the network.

Disallow root login remotely? (Press y|Y for Yes, any other key for No) : n

 ... skipping.
By default, MySQL comes with a database named 'test' that
anyone can access. This is also intended only for testing,
and should be removed before moving into a production
environment.


Remove test database and access to it? (Press y|Y for Yes, any other key for No) : y
 - Dropping test database...
 ... Success!
 - Removing privileges on test database...
 ... Success!
Reloading the privilege tables will ensure that all changes
made so far will take effect immediately.

Reload privilege tables now? (Press y|Y for Yes, any other key for No) : y
 ... Success!
All done! If you've completed all of the above steps, your
MySQL installation should now be secure.
```
