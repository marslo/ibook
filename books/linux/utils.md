<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Utils](#utils)
  - [Network](#network)
    - [Get Interface by command](#get-interface-by-command)
    - [get ipv4 address](#get-ipv4-address)
  - [system command](#system-command)
    - [use parameter in `xargs`](#use-parameter-in-xargs)
    - [findout commands from](#findout-commands-from)
    - [Get all google website](#get-all-google-website)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Utils
## Network
### Get Interface by command
```bash
interface=$(netstat -nr | grep -E 'UG|UGSc' | grep -E '^0.0.0|default' | grep -E '[0-9.]{7,15}' | awk -F' ' '{print $NF}')
# or get the route to github
interface=$(ip route get $(nslookup github.com | grep Server | awk -F' ' '{print $NF}') | sed -rn 's|.*dev\s+(\S+)\s+src.*$|\1|p')
```

### get ipv4 address
```bash
ipAddr=$(ip a s "${interface}" | sed -rn 's|.*inet ([0-9\.]{7,15})/[0-9]{2} brd.*$|\1|p')
```
## system command
### [use parameter in `xargs`](https://unix.stackexchange.com/a/100972/29178)
```bash
$ find . -type f | xargs -n 1 -I FILE bash -c 'echo $(file --mime-type -b FILE)'
text/plain
text/plain
text/plain
inode/x-empty
text/plain
text/plain
text/plain
text/plain
text/plain
text/plain
```

### findout commands from
```bash
$ type which
which is aliased to `alias | which -a --tty-only --read-alias --show-dot --show-tilde'

$ type bello
bello is a function
bello ()
{
    source "${iRCHOME}/.imac"
}
```

### Get all google website
```bash
$ whois www.google.com

Whois Server Version 2.0

Domain names in the .com and .net domains can now be registered
with many different competing registrars. Go to http://www.internic.net
for detailed information.

  Server Name: WWW.GOOGLE.COM.VN
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TW
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.TR
  Registrar: TUCOWS DOMAINS INC.
  Whois Server: whois.tucows.com
  Referral URL: http://domainhelp.opensrs.net

  Server Name: WWW.GOOGLE.COM.SA
  Registrar: OMNIS NETWORK, LLC
  Whois Server: whois.omnis.com
  Referral URL: http://domains.omnis.com

  Server Name: WWW.GOOGLE.COM.PK
  Registrar: INTERNET.BS CORP.
  Whois Server: whois.internet.bs
  Referral URL: http://www.internet.bs

  Server Name: WWW.GOOGLE.COM.PE
  Registrar: HOSTOPIA.COM INC. D/B/A APLUS.NET
  Whois Server: whois.names4ever.com
  Referral URL: http://www.aplus.net

  Server Name: WWW.GOOGLE.COM.MX
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.HK
  Registrar: GKG.NET, INC.
  Whois Server: whois.gkg.net
  Referral URL: http://www.gkg.net

  Server Name: WWW.GOOGLE.COM.DO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.CO
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.BR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

  Server Name: WWW.GOOGLE.COM.AU
  Registrar: MELBOURNE IT, LTD. D/B/A INTERNET NAMES WORLDWIDE
  Whois Server: whois.melbourneit.com
  Referral URL: http://www.melbourneit.com

  Server Name: WWW.GOOGLE.COM.AR
  Registrar: ENOM, INC.
  Whois Server: whois.enom.com
  Referral URL: http://www.enom.com

>>> Last update of whois database: Mon, 24 Feb 2014 17:24:05 UTC <<<
```
