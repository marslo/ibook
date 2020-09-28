<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Pod](#pod)
    - [List Pods name](#list-pods-name)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Pod

### List Pods name
[Inspired from here](https://stackoverflow.com/a/51612372/2940319)

- `-o name`
    ```bash
    $ k -n kube-system get pods -o name | head
    pod/coredns-c7ddbcccb-5cj5z
    pod/coredns-c7ddbcccb-lxsw6
    pod/coredns-c7ddbcccb-prjfk
    pod/etcd-node03
    pod/etcd-node04
    pod/etcd-node01
    pod/kube-apiserver-node03
    pod/kube-apiserver-node04
    pod/kube-apiserver-node01
    pod/kube-controller-manager-node03
    ```

- `--template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}'`
    ```bash
    $ k -n kube-system get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | head
    coredns-c7ddbcccb-5cj5z
    coredns-c7ddbcccb-lxsw6
    coredns-c7ddbcccb-prjfk
    etcd-node03
    etcd-node04
    etcd-node01
    kube-apiserver-node03
    kube-apiserver-node04
    kube-apiserver-node01
    kube-controller-manager-node03

    # OR

    $ k -n kube-system get pods --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | head
    coredns-c7ddbcccb-5cj5z
    coredns-c7ddbcccb-lxsw6
    coredns-c7ddbcccb-prjfk
    etcd-node03
    etcd-node04
    etcd-node01
    kube-apiserver-node03
    kube-apiserver-node04
    kube-apiserver-node01
    kube-controller-manager-node03
    ```

- `-o custom-columns=":metadata.name"`
    ```bash
    # https://stackoverflow.com/a/52691455/2940319

    $ k -n kube-system get pods -o custom-columns=":metadata.name" | head

    coredns-c7ddbcccb-5cj5z
    coredns-c7ddbcccb-lxsw6
    coredns-c7ddbcccb-prjfk
    etcd-node03
    etcd-node04
    etcd-node01
    kube-apiserver-node03
    kube-apiserver-node04
    kube-apiserver-node01
    ```

- `jsonpath={.items..metadata.name}`
    ```bash
    $ k -n kube-system get pods --output=jsonpath={.items..metadata.name}
    coredns-c7ddbcccb-5cj5z coredns-c7ddbcccb-lxsw6 coredns-c7ddbcccb-prjfk ...

    # or

    $ k -n kube-system get po -o jsonpath="{range .items[*]}{@.metadata.name}{'\n'}{end}" | head -10
    coredns-c7ddbcccb-5cj5z
    coredns-c7ddbcccb-lxsw6
    coredns-c7ddbcccb-prjfk
    etcd-node03
    etcd-node04
    etcd-node01
    kube-apiserver-node03
    kube-apiserver-node04
    kube-apiserver-node01
    kube-controller-manager-node03
    ```
