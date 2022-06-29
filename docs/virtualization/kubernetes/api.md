<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [acess cluster](#acess-cluster)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->




{% hint style='tip' %}
> references:
> - [Accessing Clusters](https://kubernetes.io/docs/tasks/access-application-cluster/access-cluster/)
> - [* one-page api reference for kubernetes v1.24](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.24/)
> - [* Kubernetes API](https://kubernetes.io/docs/reference/kubernetes-api/)
> - [* API Access Control](https://kubernetes.io/docs/reference/access-authn-authz/)
> - [using api](https://kubernetes.io/docs/reference/using-api/)
> - [customizing components with the kubeadm api](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/control-plane-flags/)
>   - [workload resources](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/)
>     - Pod
>     - PodTemplate
>     - ReplicationController
>     - ReplicaSet
>     - Deployment
>     - StatefulSet
>     - ControllerRevision
>     - DaemonSet
>     - Job
>     - CronJob
>     - HorizontalPodAutoscaler
>     - PriorityClass
>   - [service resources](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/)
>     - Service
>     - Endpoints
>     - EndpointSlice
>     - Ingress
>     - IngressClass
>   - [config and storage resources](https://kubernetes.io/docs/reference/kubernetes-api/config-and-storage-resources/)
>   - [authentication resources](https://kubernetes.io/docs/reference/kubernetes-api/authentication-resources/)
>   - [authorization resources](https://kubernetes.io/docs/reference/kubernetes-api/authorization-resources/)
>   - [policy resources](https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/)
>   - [cluster resources](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/)
>     - Node
>     - Namespace
>     - Event
>     - APIService
>     - Lease
>     - RuntimeClass
>     - FlowSchema v1beta2
>     - PriorityLevelConfiguration v1beta2
>     - Binding
>     - ComponentStatus
>   - [common definitions](https://kubernetes.io/docs/reference/kubernetes-api/common-definitions/)
{% endhint %}


> [!NOTE]
> There are several different proxies you may encounter when using Kubernetes: <p>
> - The kubectl proxy:
>   - runs on a user's desktop or in a pod
>   - proxies from a localhost address to the Kubernetes apiserver
>   - client to proxy uses HTTP
>   - proxy to apiserver uses HTTPS
>   - locates apiserver
>   - adds authentication headers
> <p>
> - The apiserver proxy:
>   - is a bastion built into the apiserver
>   - connects a user outside of the cluster to cluster IPs which otherwise might not be reachable
>   - runs in the apiserver processes
>   - client to proxy uses HTTPS (or http if apiserver so configured)
>   - proxy to target may use HTTP or HTTPS as chosen by proxy using available information
>   - can be used to reach a Node, Pod, or Service
>   - does load balancing when used to reach a Service
> <p>
> - The kube proxy:
>   - runs on each node
>   - proxies UDP and TCP
>   - does not understand HTTP
>   - provides load balancing
>   - is only used to reach services
> <p>
> - A Proxy/Load-balancer in front of apiserver(s):
>   - existence and implementation varies from cluster to cluster (e.g. nginx)
>   - sits between all clients and one or more apiservers
>   - acts as load balancer if there are several apiservers.
> <p>
> - Cloud Load Balancers on external services:
>   - are provided by some cloud providers (e.g. AWS ELB, Google Cloud Load Balancer)
>   - are created automatically when the Kubernetes service has type LoadBalancer
>   - use UDP/TCP only
>   - implementation varies by cloud provider.

## acess cluster
```bash
$ APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
$ TOKEN=$(kubectl describe secret default-token | grep -E '^token' | cut -f2 -d':' | tr -d " ")
$ curl ${APISERVER}/api --header "Authorization: Bearer ${TOKEN}" --insecure
{
  "kind": "APIVersions",
  "versions": [
    "v1"
  ],
  "serverAddressByClientCIDRs": [
    {
      "clientCIDR": "0.0.0.0/0",
      "serverAddress": "<master.ip>:6443"
    }
  ]
}
```

- using jsonpath
  ```bash
  $ APISERVER=$(kubectl config view --minify -o jsonpath='{.clusters[0].cluster.server}')
  $ TOKEN=$(kubectl get secret default-token -o jsonpath='{.data.token}' | base64 --decode)
  $ curl ${APISERVER}/api --header "Authorization: Bearer ${TOKEN}" --insecure
  ```

