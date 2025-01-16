

## API

> [!NOTE|label:references:]
> - [Blue Ocean REST AP](https://github.com/jenkinsci/blueocean-plugin/blob/master/blueocean-rest/README.md)
> - [Package io.jenkins.blueocean.service.embedded.rest](https://javadoc.jenkins.io/plugin/blueocean-rest-impl/io/jenkins/blueocean/service/embedded/rest/package-summary.html)

### `/blue/rest/organizations/`

> [!NOTE|label:references:]
> - [io.jenkins.blueocean.service.embedded.rest.OrganizationContainerImpl](https://javadoc.jenkins.io/plugin/blueocean-rest-impl/io/jenkins/blueocean/service/embedded/rest/OrganizationContainerImpl.html)

```json
[
  {
    "_class": "io.jenkins.blueocean.service.embedded.rest.OrganizationImpl",
    "_links": {
      "pipelines": {
        "_class": "io.jenkins.blueocean.rest.hal.Link",
        "href": "/blue/rest/organizations/jenkins/pipelines/"
      },
      "self": {
        "_class": "io.jenkins.blueocean.rest.hal.Link",
        "href": "/blue/rest/organizations/jenkins/"
      },
      "user": {
        "_class": "io.jenkins.blueocean.rest.hal.Link",
        "href": "/blue/rest/organizations/jenkins/user/"
      },
      "users": {
        "_class": "io.jenkins.blueocean.rest.hal.Link",
        "href": "/blue/rest/organizations/jenkins/users/"
      }
    },
    "displayName": "Jenkins",
    "name": "jenkins"
  }
]
```


### `/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/`

> [!NOTE|label:references:]
> - the `JOB_NAME` is :
>   - bash : `sed -r 's|/|/pipelines/|g' <<< ${env.JOB_NAME}`
>   - groovy: `"${env.JOB_NAME}".replaceAll( '/', '/pipelines/' )`

```bash
# i.e.:
$ curl -fsSL https://jenkins.sample.com/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs |
       jq -r .[0]._links
{
  "prevRun": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11241/"
  },
  "parent": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/"
  },
  "tests": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/tests/"
  },
  "nodes": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/nodes/"
  },
  "log": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/log/"
  },
  "self": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/"
  },
  "blueTestSummary": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/blueTestSummary/"
  },
  "actions": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/actions/"
  },
  "steps": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/steps/"
  },
  "changeSet": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/changeSet/"
  },
  "artifacts": {
    "_class": "io.jenkins.blueocean.rest.hal.Link",
    "href": "/blue/rest/organizations/jenkins/pipelines/<FOLDER_NAME>/pipelines/<NAME>/runs/11242/artifacts/"
  }
}
```

### `/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/`

> [!NOTE|label:references:]
> - [io.jenkins.blueocean.rest.impl.pipeline.PipelineRunImpl](https://javadoc.jenkins.io/plugin/blueocean-pipeline-api-impl/io/jenkins/blueocean/rest/impl/pipeline/PipelineRunImpl.html)

```bash
# i.e.:
$ curl -fsSL https://jenkins.sample.com/blue/rest/organizations/jenkins/pipelines/<FOLDER>/pipelines/<NAME>/runs/<BUILD_ID>/ |
       jq -r .causes
[
  {
    "_class": "io.jenkins.blueocean.service.embedded.rest.AbstractRunImpl$BlueCauseImpl",
    "shortDescription": "Started by upstream project \"<FOLDER_NAME>/<UPSTREAM_JOB>\" build number 7,496",
    "upstreamBuild": 7496,
    "upstreamProject": "<FOLDER_NAME>/<UPSTREAM_JOB>",
    "upstreamUrl": "job/<FOLDER_NAME>/job/<UPSTREAM_JOB>/"
  }
]
```

### `/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/nodes`


```bash
# i.e.: get PipelineNodeImpl in format of:
#       <NODE_ID> (<NODE_TYPE>) -> <NODE_STATE> (<NODE_RESULT>) -> <NODE_DISPLAY_NAME>
$ curl -fsSL http://jenkins.sample.com/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/nodes/ |
       jq -r '.[] |
              select( ._class = "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl" ) |
              .id + " (" + .type + ")" + " -> " + .state + " (" + .result + ") -> " + .displayName
             ' |
       sort -uh
6 (STAGE) -> FINISHED (SUCCESS)
1035 (STAGE) -> FINISHED (SUCCESS)
1063 (STAGE) -> FINISHED (SUCCESS)
1117 (PARALLEL) -> FINISHED (SUCCESS)
1118 (PARALLEL) -> FINISHED (SUCCESS)
1119 (PARALLEL) -> FINISHED (SUCCESS)
1120 (PARALLEL) -> FINISHED (SUCCESS)
1121 (PARALLEL) -> FINISHED (SUCCESS)
1122 (PARALLEL) -> FINISHED (SUCCESS)
1123 (PARALLEL) -> FINISHED (SUCCESS)
1124 (PARALLEL) -> FINISHED (SUCCESS)
1125 (PARALLEL) -> FINISHED (SUCCESS)
1126 (PARALLEL) -> FINISHED (SUCCESS)
1127 (PARALLEL) -> FINISHED (SUCCESS)
1128 (PARALLEL) -> FINISHED (SUCCESS)
1129 (PARALLEL) -> FINISHED (SUCCESS)
1130 (PARALLEL) -> FINISHED (SUCCESS)
1131 (PARALLEL) -> FINISHED (SUCCESS)
1132 (PARALLEL) -> FINISHED (SUCCESS)
1133 (PARALLEL) -> FINISHED (SUCCESS)
1134 (PARALLEL) -> FINISHED (SUCCESS)
1135 (PARALLEL) -> FINISHED (SUCCESS)
1136 (PARALLEL) -> FINISHED (SUCCESS)
1137 (PARALLEL) -> FINISHED (SUCCESS)
1138 (PARALLEL) -> FINISHED (SUCCESS)
1139 (PARALLEL) -> FINISHED (SUCCESS)
1140 (PARALLEL) -> FINISHED (SUCCESS)
1141 (PARALLEL) -> FINISHED (SUCCESS)
1142 (PARALLEL) -> FINISHED (SUCCESS)
1143 (PARALLEL) -> FINISHED (SUCCESS)
1144 (PARALLEL) -> FINISHED (SUCCESS)
1145 (PARALLEL) -> FINISHED (SUCCESS)
1146 (PARALLEL) -> FINISHED (SUCCESS)
1147 (PARALLEL) -> FINISHED (SUCCESS)
1148 (PARALLEL) -> FINISHED (SUCCESS)
1149 (PARALLEL) -> FINISHED (SUCCESS)
1150 (PARALLEL) -> FINISHED (SUCCESS)
1151 (PARALLEL) -> FINISHED (SUCCESS)
1152 (PARALLEL) -> FINISHED (SUCCESS)
1153 (PARALLEL) -> FINISHED (SUCCESS)
1154 (PARALLEL) -> FINISHED (SUCCESS)
1155 (PARALLEL) -> FINISHED (SUCCESS)
1156 (PARALLEL) -> FINISHED (SUCCESS)
1157 (PARALLEL) -> FINISHED (SUCCESS)
1158 (PARALLEL) -> FINISHED (SUCCESS)
1159 (PARALLEL) -> FINISHED (SUCCESS)
1160 (PARALLEL) -> FINISHED (SUCCESS)
1161 (PARALLEL) -> FINISHED (SUCCESS)
1162 (PARALLEL) -> FINISHED (SUCCESS)
1163 (PARALLEL) -> FINISHED (SUCCESS)
1164 (PARALLEL) -> FINISHED (SUCCESS)
1165 (PARALLEL) -> FINISHED (SUCCESS)
1166 (PARALLEL) -> FINISHED (SUCCESS)
1167 (PARALLEL) -> FINISHED (SUCCESS)
1168 (PARALLEL) -> FINISHED (SUCCESS)
2338 (STAGE) -> FINISHED (SUCCESS)
2379 (STAGE) -> FINISHED (SUCCESS)
7077 (STAGE) -> FINISHED (SUCCESS)
8045 (STAGE) -> FINISHED (SUCCESS)
8055 (STAGE) -> FINISHED (SUCCESS)
8105 (PARALLEL) -> FINISHED (SUCCESS)
8106 (PARALLEL) -> FINISHED (SUCCESS)
8107 (PARALLEL) -> FINISHED (SUCCESS)
8108 (PARALLEL) -> FINISHED (SUCCESS)
8109 (PARALLEL) -> FINISHED (SUCCESS)
8110 (PARALLEL) -> FINISHED (SUCCESS)
8111 (PARALLEL) -> FINISHED (SUCCESS)
8112 (PARALLEL) -> FINISHED (SUCCESS)
8113 (PARALLEL) -> FINISHED (SUCCESS)
8114 (PARALLEL) -> FINISHED (SUCCESS)
8115 (PARALLEL) -> FINISHED (SUCCESS)
8116 (PARALLEL) -> FINISHED (SUCCESS)
8117 (PARALLEL) -> FINISHED (SUCCESS)
8118 (PARALLEL) -> FINISHED (SUCCESS)
8119 (PARALLEL) -> FINISHED (SUCCESS)
8120 (PARALLEL) -> FINISHED (SUCCESS)
8121 (PARALLEL) -> FINISHED (SUCCESS)
8122 (PARALLEL) -> FINISHED (SUCCESS)
8123 (PARALLEL) -> FINISHED (SUCCESS)
8124 (PARALLEL) -> FINISHED (SUCCESS)
8125 (PARALLEL) -> FINISHED (SUCCESS)
8126 (PARALLEL) -> FINISHED (SUCCESS)
8127 (PARALLEL) -> FINISHED (SUCCESS)
8128 (PARALLEL) -> FINISHED (SUCCESS)
8129 (PARALLEL) -> FINISHED (SUCCESS)
8130 (PARALLEL) -> FINISHED (SUCCESS)
8131 (PARALLEL) -> FINISHED (SUCCESS)
8132 (PARALLEL) -> FINISHED (SUCCESS)
8133 (PARALLEL) -> FINISHED (SUCCESS)
8134 (PARALLEL) -> FINISHED (SUCCESS)
8135 (PARALLEL) -> FINISHED (SUCCESS)
8136 (PARALLEL) -> FINISHED (SUCCESS)
8145 (PARALLEL) -> FINISHED (SUCCESS)
8146 (PARALLEL) -> FINISHED (SUCCESS)
8147 (PARALLEL) -> FINISHED (SUCCESS)
8148 (PARALLEL) -> FINISHED (SUCCESS)
8149 (PARALLEL) -> FINISHED (SUCCESS)
8150 (PARALLEL) -> FINISHED (SUCCESS)
8151 (PARALLEL) -> FINISHED (SUCCESS)
8152 (PARALLEL) -> FINISHED (SUCCESS)

# i.e.: get format as :
#       <PARENT_ID> -> <NODE_ID> (<NODE_TYPE>) -> <NODE_STATE> (<NODE_RESULT>) -> <NODE_DISPLAY_NAME>
$ curl -fsSL http://jenkins.sample.com/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/nodes/ |
       jq -r '.[] |
              select( ._class = "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl" ) |
              (.firstParent // "NO_EXIST") + " -> " + .id + " (" + .type + ")" + " -> " + .state + " (" + .result + ") -> " + .displayName
             '
```

### `/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/nodes/<NODE_ID>/steps/`

```bash
# i.e.: get PipelineStepImpl in format of:
#       <STEP_ID> -> <STEP_STATE> (<STEP_RESULT>) :
#       <STEP_DISPLAY_NAME>
$ curl -fsSL http://jenkins.sample.com/blue/rest/organizations/jenkins/pipelines/<JOB_NAME>/runs/<BUILD_ID>/nodes/<NODE_ID>/steps |
       jq -r '.[] |
              select( ._class = "io.jenkins.blueocean.rest.impl.pipeline.PipelineNodeImpl" ) |
              .id + " -> " + .state + " (" + .result + ")" + if ( .displayDescription != null or .displayDescription != "" ) then ( " :\n" + .displayDescription ) else "" end
             '
```
