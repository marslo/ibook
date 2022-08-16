<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [setup server config](#setup-server-config)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




## setup server config

> [!TIP]
> <service_name> can be one of:
> - database
> - license
> - klocwork
> - <projects_root> is the projects_root where the servers are running

```bash
$ kwservice set-service-property klocwork host my.klocwork.com
Using projects root: /projects_root
# kwservice check
Using projects root: /projects_root
Local Host is: devops-klocwork-755dc7966b-pgsgq [10.244.6.65]
Checking License Server  [running on llic5-02:33138]
Checking Database Server [running on localhost:3306] (projects root is /projects_root)
Checking Klocwork Server [running on my.klocwork.com:8080]
```
