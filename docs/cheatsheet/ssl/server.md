<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [generate csr](#generate-csr)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [* iMarslo: Artifactory Nginx CSR](../../artifactory/nginx-cert.md)

## generate csr

```bash
# generate key
$ openssl genrsa -out dashboard.key 2048

# generate csr
$ openssl req -sha256 \
              -new \
              -key dashboard.key \
              -out dashboard.csr \
              -subj '/C=US/ST=California/L=Santa Clara/O=Company Name, Inc./CN=dashboard.kubernetes.com'
```
