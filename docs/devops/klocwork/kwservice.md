<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [setup server config](#setup-server-config)
- [start/restart service](#startrestart-service)
- [check license status](#check-license-status)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> references:
> - [Security Best Practices + Klocwork](https://www.perforce.com/blog/kw/security-best-practices)
> - [Klocwork Insight 10.0 SR3 - Installation and Upgrade.pdf](http://cdn-devnet.klocwork.com/documents/members/Klocwork_Installation_and_Upgrade_EN_10_SR3.pdf)
{% endhint %}


## setup server config

> [!TIP]
> <service_name> can be one of:
> - database
> - license
> - klocwork
> - <projects_root> is the projects_root where the servers are running

```bash
$ kwservice set-service-property klocwork host my.klocwork.com
Using projects root: /projects/root
# kwservice check
Using projects root: /projects/root
Local Host is: klocwork-server-7*********-****q [10.244.6.65]
Checking License Server  [running on klocwork-license:443]
Checking Database Server [running on localhost:3306] (projects root is /projects/root)
Checking Klocwork Server [running on my.klocwork.com:8080]
```

## start/restart service

> [!TIP]
> references:
> - [Managing the Klocwork Servers](https://analyst.phyzdev.net/documentation/help/concepts/managingtheklocworkservers.htm)

- start
  ```bash
  $ kwservice --projects-root /projects/root start
  ```

- restart
  ```bash
  $ kwservice --projects-root /projects/root restart
  Using projects root: /projects_root
  Local Host is: klocwork-server-7*********-****4 [10.244.6.68]
  Re-starting License Server  [already running on klocwork-license:443]
  Re-starting Database Server [started on localhost:3306] (projects root is /projects/root)
  Re-starting Klocwork Server
  ```

- stop
  ```bash
  $ kwservice --projects-root /projects/root stop
  ```

## check license status

> [!TIP]
> references:
> - [Licensing](https://analyst.phyzdev.net/documentation/help/concepts/licensing.htm)
> - [How licensing works](https://analyst.phyzdev.net/documentation/help/concepts/howlicensingworks.htm)
> - [Can't connect to License Server](https://analyst.phyzdev.net/documentation/help/concepts/cantconnecttolicenseserver.htm)
> - [Changing the vendor daemon port in your license file](https://analyst.phyzdev.net/documentation/help/concepts/changingthevendordaemonportinyourlicensefile.htm)
> - [Licensing with multiple projects_root directories](https://analyst.phyzdev.net/documentation/help/concepts/1licensingwithmultipleprojectsrootdirectories.htm)
> - [Setting up redundant license servers](https://analyst.phyzdev.net/documentation/help/concepts/settingupredundantlicenseservers.htm)
> - [How Structure101 licensing works](https://analyst.phyzdev.net/documentation/help/concepts/howkw101licensingworks.htm)

```bash
$ kwservice --projects-root /projects/root check license
Using projects root: /projects/root
Local Host is: klocwork-server-755dc7966b-ndb94 [10.244.6.68]
Checking License Server  [running on klocwork-license:443]
```
