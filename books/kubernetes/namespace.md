<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [remove stuck namespace](#remove-stuck-namespace)
  - [check which item occupied the resource](#check-which-item-occupied-the-resource)
  - [remove challenge.certmanager](#remove-challengecertmanager)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## remove stuck namespace
### check which item occupied the resource

```bash
$ myns='marslo-test'
$ for _i in $(kubectl api-resources --verbs=list --namespaced -o name); do
  echo ----- ${_i} ------
  kubectl get -n ${myns} ${_i}
done

# result:
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
marslo-dashboard-2318568841-0   pending   marslo-dashboard.marvell.com   72m
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

### remove challenge.certmanager

```bash
$ k -n marslo-test delete challenges.certmanager.k8s.io  marslo-dashboard-2318568841-0 --force --grace-period=0
warning: Immediate deletion does not wait for confirmation that the running resource has been terminated. The resource may continue to run on the cluster indefinitely.
challenge.certmanager.k8s.io "marslo-dashboard-2318568841-0" force deleted
####
stuck
####

$ k get ns
NAME                   STATUS        AGE
cert-manager           Active        103d
...
marslo-test            Terminating   103d
...

$ k delete namespace cert-manager

$ k -n marslo-test describe challenges.certmanager.k8s.io
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
  Dns Name:           marslo-dashboard.marvell.com
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
  Reason:      Waiting for http-01 challenge propagation: failed to perform self check GET request 'http://marslo-dashboard.marvell.com/.well-known/acme-challenge/cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY': Get http://marslo-dashboard.marvell.com/.well-known/acme-challenge/cq9ofBV9ugv0zdf6ZMoPtFJjhuNrg17hVbAzQK1t2HY: dial tcp: lookup marslo-dashboard.marvell.com on 10.96.0.10:53: no such host
  State:       pending
Events:        <none>


## inspired from https://github.com/jetstack/cert-manager/issues/1582#issuecomment-515354712
$ k -n marslo-test edit challenges.certmanager.k8s.io  marslo-dashboard-2318568841-0 
challenge.certmanager.k8s.io/marslo-dashboard-2318568841-0 edited
## manual remove the finalizer
```

## Reference
- [deleting namespace stuck at "Terminating" state](https://github.com/kubernetes/kubernetes/issues/60807#issuecomment-408599873)
