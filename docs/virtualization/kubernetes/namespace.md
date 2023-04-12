<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [create namespace](#create-namespace)
- [remove stuck namespace](#remove-stuck-namespace)
  - [check which item occupied the resource](#check-which-item-occupied-the-resource)
  - [remove all pods in namespace](#remove-all-pods-in-namespace)
  - [backup namespaces](#backup-namespaces)
  - [remove challenge.certmanager](#remove-challengecertmanager)
- [list](#list)
  - [list all namespaces with name only](#list-all-namespaces-with-name-only)
  - [list all quota in cluster](#list-all-quota-in-cluster)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='info' %}
> Reference:
> - [deleting namespace stuck at "Terminating" state](https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-408599873)
> - [A namespace is stuck in the Terminating state](https://www.ibm.com/docs/en/cloud-private/3.2.0?topic=console-namespace-is-stuck-in-terminating-state)
{% endhint %}

## create namespace
```bash
$ cat << EOF | kubectl apply -f -
apiVersion: v1
kind: Namespace
metadata:
  name: <name>
  labels:
    name: <name>
EOF
```
- or
  ```bash
  $ kaubectl create namespace <name>
  $ kubectl label namespace <name> name=<name> --overwrite
  ```

## remove stuck namespace
### check which item occupied the resource

> [!NOTE]
> references:
> - [Unable to Delete a Project or Namespace in OCP](https://access.redhat.com/solutions/4165791)
> - [Kubernetes Namespaces stuck in Terminating status](https://stackoverflow.com/a/62959634/2940319)
> - [Namespace "stuck" as Terminating, How I removed it](https://stackoverflow.com/a/57726448/2940319)
> - [How to fix Kubernetes namespaces stuck in the terminating state](https://www.redhat.com/sysadmin/troubleshooting-terminating-namespaces)

```bash
$ ns='marslo-test'
$ for _r in $(kubectl api-resources --verbs=list --namespaced -o name); do
    if [[ 'No resources found.' != "$(kubectl get -n ${ns} ${_r} 2>&1 >/dev/null)" ]]; then
      echo "---- ${_r} ----"
      kubectl get -n ${ns} ${_r}
    fi
  done

---- resourcequotas ----
NAME                     CREATED AT
builder-resource-quota   2019-11-15T17:12:52Z
---- secrets ----
NAME                  TYPE                                  DATA   AGE
default-token-l4s96   kubernetes.io/service-account-token   3      2y351d
---- serviceaccounts ----
NAME      SECRETS   AGE
default   1         2y351d
```

- [or modify `spec.finalizers`](https://stackoverflow.com/a/75434699/2940319)
  ```bash
  # to modify `"finalizers": [ "kubernet" ]` to `"finalizers": []`
  $ export NAMESPACE="monitoring"
  $ kubectl get namespace $NAMESPACE -o json  |
            tr -d "\n" |
            sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" |
            kubectl replace --raw /api/v1/namespaces/$NAMESPACE/finalize -f -
  ```

- or
  ```bash
  $ myns='marslo-test'
  $ for _i in $(kubectl api-resources --verbs=list --namespaced -o name); do
    echo ----- ${_i} ------
    kubectl get -n ${myns} ${_i}
  done
  ```

  <!--sec data-title="api resoureces results" data-id="section0" data-show=true data-collapse=true ces-->
  ```bash
  ----- configmaps ------
  No resources found.
  ----- endpoints ------
  No resources found.
  ----- events ------
  No resources found.
  ----- limitranges ------
  No resources found.
  ----- persistentvolumeclaims ------
  No resources found.
  ----- pods ------
  No resources found.
  ----- podtemplates ------
  No resources found.
  ----- replicationcontrollers ------
  No resources found.
  ----- resourcequotas ------
  No resources found.
  ----- secrets ------
  No resources found.
  ----- serviceaccounts ------
  No resources found.
  ----- services ------
  No resources found.
  ----- controllerrevisions.apps ------
  No resources found.
  ----- daemonsets.apps ------
  No resources found.
  ----- deployments.apps ------
  No resources found.
  ----- replicasets.apps ------
  No resources found.
  ----- statefulsets.apps ------
  No resources found.
  ----- horizontalpodautoscalers.autoscaling ------
  No resources found.
  ----- cronjobs.batch ------
  No resources found.
  ----- jobs.batch ------
  No resources found.
  ----- certificaterequests.certmanager.k8s.io ------
  No resources found.
  ----- certificates.certmanager.k8s.io ------
  No resources found.
  ----- challenges.certmanager.k8s.io ------
  NAME                            STATE     DOMAIN                         AGE
  marslo-dashboard-2318568841-0   pending   marslo-dashboard.mycompany.com   72m
  ----- issuers.certmanager.k8s.io ------
  No resources found.
  ----- orders.certmanager.k8s.io ------
  No resources found.
  ----- leases.coordination.k8s.io ------
  No resources found.
  ----- events.events.k8s.io ------
  No resources found.
  ----- daemonsets.extensions ------
  No resources found.
  ----- deployments.extensions ------
  No resources found.
  ----- ingresses.extensions ------
  No resources found.
  ----- networkpolicies.extensions ------
  No resources found.
  ----- replicasets.extensions ------
  No resources found.
  ----- pods.metrics.k8s.io ------
  No resources found.
  ----- ingresses.networking.k8s.io ------
  No resources found.
  ----- networkpolicies.networking.k8s.io ------
  No resources found.
  ----- poddisruptionbudgets.policy ------
  No resources found.
  ----- rolebindings.rbac.authorization.k8s.io ------
  No resources found.
  ----- roles.rbac.authorization.k8s.io ------
  No resources found.
  ```
  <!--endsec-->

- or list only available resources
  ```bash
  #!/usr/bin/env bash

  myns='marslo-test'
  for _i in $(kubectl api-resources --verbs=list --namespaced -o name); do
    if [[ "$(kubectl -n ${myns} get ${_i} 2>&1)" = No* ]]; then
      :
    else
      echo ----- ${_i} ------
      kubectl -n ${myns} get ${_i}
    fi
  done
  ```

- oneline
  ```bash
  $ kubectl api-resources  --namespaced=true -o name |
    xargs -n 1 -I {} bash -c "echo \"----- {} -----\"; kubectl get -n ${myns} {};"

  # --ignore-not-found
  # -t, --verbose
  #               Print the command line on the standard error output before executing it
  $ kubectl api-resources  --namespaced=true -o name |
    xargs -t -n 1 kubectl get --show-kind --ignore-not-found -n ${myns}
  ```

### remove all pods in namespace
```bash
$ kubectl delete pods -n <namespace> --all
```

- or
  ```bash
  $ kubectl delete po $(kubectl -n <namespace> get po -o jsonpath='{range .items[*]}{.metadata.name} ') \
            --force --grace-period=0 \
            -n <namespace>
  ```

#### [delete in all namespaces](https://stackoverflow.com/a/72655667/2940319)
```bash
$ kubectl get ns -o=custom-columns=Namespace:.metadata.name --no-headers |
          xargs -n1 kubectl delete pods --all -n
```

### backup namespaces
```bash
#!/usr/bin/env bash

# credit belongs to https://raw.githubusercontent.com/ppo/bash-colors/master/bash-colors.sh
# shellcheck disable=SC2015,SC2059
c() { [ $# == 0 ] && printf "\e[0m" || printf "$1" | sed 's/\(.\)/\1;/g;s/\([SDIUFNHT]\)/2\1/g;s/\([KRGYBMCW]\)/3\1/g;s/\([krgybmcw]\)/4\1/g;y/SDIUFNHTsdiufnhtKRGYBMCWkrgybmcw/12345789123457890123456701234567/;s/^\(.*\);$/\\e[\1m/g'; }
exitOnError() { if [ $? -ne 0 ]; then echo -e "$(c R)ERROR$(c) : $*" >&2; exit 1; fi; }
showHelp() { echo -e "${usage}"; exit 0; }

usage="""
\t $(c R)nsb$(c) - $(c iR)n$(c)ame$(c iR)s$(c)pace $(c iR)b$(c)ackup: to backup all available api-resources in given namespace
\nSYNOPSIS:
\n\t$(c sY)\$ nsb <namespace> [<namespace> [<namespace> [..]]]$(c)
\nEXAMPLE:
\n\tshow help
\t\t$(c G)\$ nsb$(c)
\n\tbackup namespace(s)
\t\t$(c G)\$ nsb <namespace> <namespace> <namespace> ...$(c)
"""

[[ 0 -eq $# ]] && showHelp
path="./backups-$(date +%Y%m%d)/namespace"

while read -r -d' ' ns; do

  echo -e "\n\n\n================================ $(c iY)${ns}$(c) ================================"
  for _ar in $(kubectl api-resources --verbs=list --namespaced -o name); do
    if [[ "$(kubectl -n ${ns} get ${_ar} 2>&1)" = No* ]]; then
      :
    else
      target="${path}/${ns}/${_ar}"
      mkdir -p "${target}"

      echo -e "\n----- $(c iY)${ns}$(c) : $(c iB)${_ar}$(c) ------"
      kubectl -n ${ns} get ${_ar} | tee "${target}/status.log"
      kubectl -n ${ns} describe ${_ar} > "${target}/${_ar}.describe.log"

      echo -e "\n... backup $(c iB)${_ar}$(c) all to ${target}/${_ar}.yml"
      kubectl -n ${ns} get ${_ar} -o yaml --export > "${target}/${_ar}.yml"

      while read -r name; do
        echo -e "\t... backup $(c iB)${_ar}$(c) $(c iG)${name}$(c) to ${target}/${name}.yml"
        if [[ "${name}" =~ .*-token-.* ]]; then
          kubectl -n ${ns} get ${_ar} ${name} -o yaml > ${target}/${name}.yml
        else
          kubectl -n ${ns} get ${_ar} ${name} -o yaml --export > ${target}/${name}.yml
        fi
      done < <(kubectl -n "${ns}" get "${_ar}" -o jsonpath='{range .items[*]}{.metadata.name}{"\n"}')

    fi
  done

  echo -e "======================================================================="
done <<< "$@ "
```

### remove challenge.certmanager
```bash
$ kubectl -n marslo-test delete challenges.certmanager.k8s.io marslo-dashboard-2318568841-0 \
          --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
challenge.certmanager.k8s.io "marslo-dashboard-2318568841-0" force deleted
####
stuck
####

$ kubectl get ns
NAME                   STATUS        AGE
cert-manager           Active        103d
...
marslo-test            Terminating   103d
...

$ kubectl delete namespace cert-manager

$ kubectl -n marslo-test describe challenges.certmanager.k8s.io
Name:         marslo-dashboard-2318568841-0
Namespace:    marslo-test
Labels:       acme.cert-manager.io/order-name=marslo-dashboard-2318568841
Annotations:  <none>
API Version:  certmanager.k8s.io/v1alpha1
Kind:         Challenge
Metadata:
  Creation Timestamp:             2020-01-02T13:24:46Z
  Deletion Grace Period Seconds:  0
  Deletion Timestamp:             2020-01-02T13:26:37Z
  Finalizers:
    finalizer.acme.cert-manager.io
# Please edit the object below. Lines beginning with a '#' will be ignored,
  Generation:  5
  Owner References:
    API Version:           certmanager.k8s.io/v1alpha1
    Block Owner Deletion:  true
    Controller:            true
    Kind:                  Order
    Name:                  marslo-dashboard-2318568841
    UID:                   06c2cc11-fd96-473d-b672-9e7495dee3bf
  Resource Version:        28236617
  Self Link:               /apis/certmanager.k8s.io/v1alpha1/namespaces/marslo-test/challenges/marslo-dashboard-2318568841-0
  UID:                     cc6f18e3-1035-4f9f-aa25-9fdcf2340d36
Spec:
  Authz URL:  https://acme-v02.api.letsencrypt.org/acme/authz-v3/2065855459
  Config:
    http01:
      Ingress Class:  nginx
  Dns Name:           marslo-dashboard.mycompany.com
  Issuer Ref:
    Kind:    ClusterIssuer
    Name:    marslo-cert
  Key:       cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY.TjEqvfuHdQXjDvwPm1FMc5pU4scT3qTDs5j4qc8XAqM
  Token:     cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY
  Type:      http-01
  URL:       https://acme-v02.api.letsencrypt.org/acme/chall-v3/2065855459/raQniA
  Wildcard:  false
Status:
  Presented:   true
  Processing:  true
  Reason:      Waiting for http-01 challenge propagation: failed to perform self checkubectl get request 'http://marslo-dashboard.mycompany.com/.well-known/acme-challenge/cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY': Get http://marslo-dashboard.mycompany.com/.well-known/acme-challenge/cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY: dial tcp: lookup marslo-dashboard.mycompany.com on 10.96.0.10:53: no such host
  State:       pending
Events:        <none>


## inspired from https://github.com/jetstack/cert-manager/issues/1582#issuecomment-515354712
$ kubectl -n marslo-test edit challenges.certmanager.k8s.io  marslo-dashboard-2318568841-0
challenge.certmanager.k8s.io/marslo-dashboard-2318568841-0 edited
## manual remove the finalizer
```

## list
### list all namespaces with name only
```bash
$ kubectl get ns -o custom-columns=":metadata.name" --no-headers
```
- or
  ```bash
  $ kubectl get ns -o name
  ```
- or
  ```bash
  $ kubectl get ns --no-headers -o name
  ```

### list all quota in cluster
```bash
$ while read ns; do
    echo "~~~~~~~~~~~~ ${ns} ~~~~~~~~~~~~~"
    kubectl -n ${ns} describe quota
  done < <(kubectl get ns -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}')
```
- or
  ```bash
  $ while IFS= read -rd ' ' ns; do
      echo "~~~> ${ns}"
      kubectl -n ${ns} describe quota
    done < <(kubectl get ns -o jsonpath="{.items[*].metadata.name}"
  ```
