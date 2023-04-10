<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [create secret](#create-secret)
  - [use raw data](#use-raw-data)
  - [from a file](#from-a-file)
  - [from file with base64](#from-file-with-base64)
- [decode the secret](#decode-the-secret)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




{% hint style='info' %}
> referecens:
> - [Managing Secrets using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/)
>   - [Managing Secrets using Configuration File](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-config-file/)
>   - [Managing Secrets using Kustomize](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kustomize/)
{% endhint %}


## create secret
### use raw data
```bash
$ kubectl create secret generic db-user-pass \
          --from-literal=username=admin \
          --from-literal=password='marslo'
```

### from a file
```bash
$ echo -n 'admin' > ./username.txt
$ echo -n 'marslo' > ./password.txt

$ kubectl create secret generic db-user-pass \
          --from-file=./username.txt \
          --from-file=./password.txt

# or `--from-file=[key=]source`
$ kubectl create secret generic db-user-pass \
          --from-file=username=./username.txt \
          --from-file=password=./password.txt
```

### from file with base64
```bash
$ echo -n 'admin' | base64
YWRtaW4=
$ echo -n '1f2d1e2e67df' | base64
MWYyZDFlMmU2N2Rm

# create manifest
$ cat secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysecret
type: Opaque
data:
  username: YWRtaW4=
  password: MWYyZDFlMmU2N2Rm

# create
$ kubectl apply -f ./secret.yaml
```

## decode the secret
```bash
$ kubectl get secret db-user-pass -o jsonpath='{.data}'
{ "password": "bWFyc2xvCg==", "username": "YWRtaW4=" }

$ echo 'bWFyc2xvCg==' | base64 -d
marslo
```

- oneline
  ```bash
  $ kubectl get secret db-user-pass -o jsonpath='{.data.password}' | base64 --decode
  ```
