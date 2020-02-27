<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

  - [pfx](#pfx)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### pfx

```bash
$ cat ~/.kube/config | grep certificate-authority-data | awk '{print $2}' | base64 -d > ca.crt
$ cat ~/.kube/config | grep client-certificate-data | awk '{print $2}' | base64 -d > client.crt
$ cat ~/.kube/config | grep client-key-data | awk '{print $2}' | base64 -d > client.key


$ openssl pkcs12 -export -out cert.pfx -inkey client.key -in client.crt -certfile ca.crt
Enter Export Password: marslo
Verifying - Enter Export Password: marslo

$ ls
ca.crt  cert.pfx  client.crt  client.key
```

## reference
- [Access Kubernetes API with Client Certificates](https://codefarm.me/2019/02/01/access-kubernetes-api-with-client-certificates/)
- [Public-key cryptography and X.509](https://codefarm.me/2019/01/31/public-key-cryptography-and-x509/)
- [Bootstrapping Kubernetes Clusters with kubeadm](https://codefarm.me/2019/01/28/bootstrapping-kubernetes-clusters-with-kubeadm/)
