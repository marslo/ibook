<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [key components](#key-components)
  - [elastic stack](#elastic-stack)
  - [elk process schema](#elk-process-schema)
- [references](#references)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!NOTE|label:note:]
> - [* How to set up a secure logging platform with Elastic Stack and Search Guard](https://acagroup.be/en/blog/secure-logging-platform-elastic-stack-search-guard/)
> - [Kubernetes Logging with Filebeat and Elasticsearch Part 1](https://medium.com/@MetricFire/kubernetes-logging-with-filebeat-and-elasticsearch-part-1-b742f6bfaf13)
> - [Installing Elastic Stack](https://help.hcl-software.com/connections/v65/de/admin/install/cp_prereqs_dashboards_elasticstack_install.html) | [Setting up the index patterns in Kibana](https://help.hcl-software.com/connections/v65/de/admin/install/cp_prereqs_dashboards_elasticstack_index.html) | [Filtering out logs](https://help.hcl-software.com/connections/v65/de/admin/install/cp_prereqs_dashboards_elasticstack_filters.html) | [Using the Elasticsearch Curator](https://help.hcl-software.com/connections/v65/de/admin/install/cp_prereqs_dashboards_elasticstack_curator.html)
> - [Elasticsearch Sizing and Configuration](https://docs.jiffy.ai/admin_guide/tenant-admin-activities/audit-log/elasticsearch-sizing-and-configuration/)

## key components

- es-data
- es-master
- es-client
- kibana
- logstash
- filebeat

```bash
$ kubectl -n logging get deploy,sts
NAME                              DESIRED   CURRENT   UP-TO-DATE   AVAILABLE   AGE
deployment.extensions/es-client   1         1         1            1           2y130d
deployment.extensions/kibana      1         1         1            1           2y130d

NAME                         DESIRED   CURRENT   AGE
statefulset.apps/es-data     1         1         2y131d
statefulset.apps/es-master   2         2         2y132d
statefulset.apps/logstash    1         1         2y130d
```

### elastic stack

![elk stack](../screenshot/linux/elastic-stack.png)

### elk process schema

![elk process](../screenshot/linux/elk-process-schema.png)

## references

> [!NOTE|label:references:]
> - [Elastic 技术栈](https://www.yaolong.net/article/elastic/)
> - [Elastic 技术栈之快速入门](https://www.yaolong.net/article/elastic-quickstart/)
> - [Elastic 技术栈之 Logstash 基础](https://www.yaolong.net/article/elastic-logstash/)
> - [Elastic 技术栈之 Kibana](https://www.yaolong.net/article/elastic-kibana/)
> - [Elastic 技术栈之 Filebeat](https://www.yaolong.net/article/elastic-filebeat/)
> - [Elasticsearch的内存调优与解析](https://www.yaolong.net/article/es-heap-sizing/)
> - [理解Elasticsearch和面试总结](https://www.yaolong.net/article/elasticsearch-interview/)
>
> ELK
> - [HA Cluster](https://medium.com/faun/https-medium-com-thakur-vaibhav23-ha-es-k8s-7e655c1b7b61)
> - [Remote Cluster](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-remote-clusters.html#configuring-remote-clusters)
> - [Nodes](https://www.elastic.co/guide/en/elasticsearch/reference/current/modules-node.html)
>
> Shard/Index Routing
> - [Cluster-level shard allocation filtering](https://www.elastic.co/guide/en/elasticsearch/reference/current/allocation-filtering.html)
> - [Index-level shard allocation filtering](https://www.elastic.co/guide/en/elasticsearch/reference/current/shard-allocation-filtering.html)
>
> Open Distro
> [Open Distro References](https://aws.amazon.com/blogs/opensource/category/analytics/open-distro-for-elasticsearch/)
> [Open Distro on Kubernetes](https://aws.amazon.com/blogs/opensource/open-distro-for-elasticsearch-on-kubernetes/)
> [Open Distro Kibana Multi Tenant](https://aws.amazon.com/blogs/opensource/multi-tenant-kibana-open-distro-for-elasticsearch/)
>
> Logstash
> - [Grok filter pattern tester](https://grokdebug.herokuapp.com/)
>
> Filebeat
> - [Multiline input pattern tester](https://play.golang.org/p/10hI64vVPNa)
> - [Prebuilt RPI beats](https://github.com/RaoulDuke-Esq/Beats-Pi)
> - [RPI beats build script](https://github.com/josh-thurston/easyBEATS)
> - [beats with additional env_file processor](https://github.com/ccw/beats/tree/processor_env_file)
>
> Kubernetes - Helm Charts
> - [Open Distro](https://github.com/opendistro-for-elasticsearch/community/pull/56)
> - [Logstash](https://github.com/helm/charts/tree/master/stable/logstash)
> - [ELK](https://github.com/helm/charts/tree/master/stable/elastic-stack)
