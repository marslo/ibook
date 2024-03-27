<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [syntax](#syntax)
  - [Entities and Fields](#entities-and-fields)
  - [Comparison Operators](#comparison-operators)
- [relative time operators](#relative-time-operators)
- [find in files by name/pattern](#find-in-files-by-namepattern)
- [find items (folder) some times ago by aql](#find-items-folder-some-times-ago-by-aql)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


> [!TIP|label:references:]
> - [jfrog/artifactory-scripts](https://github.com/jfrog/artifactory-scripts)

## syntax
### [Entities and Fields](https://jfrog.com/help/r/jfrog-artifactory-documentation/artifactory-query-language)

| DOMAIN           | FIELD NAME           | TYPE   |
| ---------------- | -------------------- | ------ |
| item             | repo                 | String |
| item             | path                 | String |
| item             | name                 | String |
| item             | created              | Date   |
| item             | modified             | Date   |
| item             | updated              | Date   |
| item             | created_by           | String |
| item             | modified_by          | String |
| item             | type                 | Enum   |
| item             | depth                | Int    |
| item             | original_md5         | String |
| item             | actual_md5           | String |
| item             | original_sha1        | String |
| item             | actual_sha1          | String |
| item             | sha256               | String |
| item             | size                 | Long   |
| item             | virtual_repos        | String |
| entry            | name                 | String |
| entry            | path                 | String |
| promotion        | created              | String |
| promotion        | created_by           | String |
| promotion        | status               | String |
| promotion        | repo                 | String |
| promotion        | comment              | String |
| promotion        | user                 | String |
| build            | url                  | String |
| build            | name                 | String |
| build            | number               | String |
| build            | created              | Date   |
| build            | created_by           | String |
| build            | modified             | Date   |
| build            | modified_by          | String |
| build            | Started              | Date   |
| property         | key                  | String |
| property         | value                | String |
| stat             | downloaded           | Date   |
| stat             | downloads            | Int    |
| stat             | downloaded_by        | String |
| stat             | remote_downloads     | Int    |
| stat             | remote_downloaded    | Date   |
| stat             | remote_downloaded_by | String |
| stat             | remote_origin        | String |
| stat             | remote_path          | String |
| artifact         | name                 | String |
| artifact         | type                 | String |
| artifact         | sha1                 | String |
| artifact         | md5                  | String |
| module           | name                 | String |
| dependency       | name                 | String |
| dependency       | scope                | String |
| dependency       | type                 | String |
| dependency       | sha1                 | String |
| dependency       | md5                  | String |
| release          | name                 | String |
| release          | version              | String |
| release          | status               | String |
| release          | created              | String |
| release          | signature            | String |
| release_artifact | path                 | String |


### [Comparison Operators](https://jfrog.com/help/r/jfrog-artifactory-documentation/artifactory-query-language)

| OPERATOR  | TYPES                     |
| --- | --- |
| `$ne`     | `string, date, int, long` |
| `$eq`     | `string, date, int, long` |
| `$gt`     | `string, date, int, long` |
| `$gte`    | `string, date, int, long` |
| `$lt`     | `string, date, int, long` |
| `$lte`    | `string, date, int, long` |
| `$match`  | `string, date, int, long` |
| `$nmatch` | `string, date, int, long` |


## [relative time operators](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-RelativeTimeOperators)

> [!NOTE|label:references:]
> - [aqlCleanup.groovy](https://github.com/JFrog/artifactory-scripts/blob/master/cleanup/aqlCleanup.groovy)
> - [Advanced Cleanup Using Artifactory Query Language (AQL)](https://jfrog.com/blog/advanced-cleanup-using-artifactory-query-language-aql/)

AQL supports specifying time intervals for queries using relative time. In other words, the time interval for the query will always be relative to the time that the query is run, so you don't have to change or formulate the time period, in some other way, each time the query is run. For example, you may want to run a query over the last day, or for the time period up to two weeks ago.

Relative time is specified using the following two operators:

| OPERATORS   | PARAPHRASE                                                                    |
| :---------: | ----------------------------------------------------------------------------- |
| `$before`   | The query is run over complete period up to specified time.                   |
| `$last`     | The query is run over period from the specified time until the query is run   |

Time periods are specified with a number and one of the following suffixes:

|  TIME PERIOD | SUFFIXES       |
|:------------:|:--------------:|
| milliseconds | "mills", "ms"  |
|    seconds   | "seconds", "s" |
|    minutes   | "minutes"      |
|     days     | "days", "d"    |
|     weeks    | "weeks", "w"   |
|    months    | "months", "mo" |
|     years    | "years", "y"   |


## find in files by name/pattern

- running via `curl -d`
  ```bash
  $ curl -s -u ${account}:${password} \
         -X POST "${RT_URL}/artifactory/api/search/aql" \
         -H 'content-type: text/plain' \
         -d 'items.find ({
              "path" : { "\$ne" : "." },
              "\$or" : [{
                "\$and" : [{
                  "repo" : "${repo}",
                  "path" : { "\$match": "${path}" } ,
                  "name" : { "\$match": "${name}" }
                }]
              },
              { "\$and" : [{
                    "repo" : "${repo}",
                    "path" : { "\$match" : "${path}/*" } ,
                    "name" : { "\$match" : "${name}"}
                }]
              }]
            }).include( "name", "repo", "path", "actual_md5", "actual_sha1", "size", "type", "property" )
         '
  ```

- running via `curl -T`
  ```bash
  $ cat find.aql
  tems.find ({
    "path" : { "$ne" : "." },
    "repo" : "rt-repo",
    "$or" : [{
      "$and" : [{
        "path" : { "$match": "path/to/folder" } ,
        "name" : { "$match": "name.zip" }
      }]
    },
    { "$and" : [{
          "path" : { "$match" : "path/to/folder/*" } ,
          "name" : { "$match" : "name.zip"}
      }]
    }]
  }).include( "name", "repo", "path", "actual_md5", "actual_sha1", "size", "type", "property" )

  $ curl -s -u "${account}":"${password}" \
            -XPOST \
            "${RT_URL}/artifactory/api/search/aql" \
            -T find.aql
  ```

- in same repo
  ```bash
  $ cat find.aql
  tems.find ({
    "path" : { "$ne" : "." },
    "repo" : "rt-repo",
    "$or" : [{
      "$and" : [{
        "path" : { "$match": "path/to/folder" } ,
        "name" : { "$match": "name.zip" }
      }]
    },
    { "$and" : [{
          "path" : { "$match" : "path/to/folder/*" } ,
          "name" : { "$match" : "name.zip"}
      }]
    }]
  }).include( "name", "repo", "path", "actual_md5", "actual_sha1", "size", "type", "property" )
  ```

- in different repo
  ```bash
  $ cat find.aql
  tems.find ({
    "path" : { "$ne" : "." },
    "$or" : [{
      "$and" : [{
        "repo" : "rt-repo-1",
        "path" : { "$match": "path/to/folder/*" } ,
        "name" : { "$match": "name.txt" }
      }]
    },
    { "$and" : [{
          "repo" : "rt-repo-2",
          "path" : { "$match" : "path/to/folder/*" } ,
          "name" : { "$match" : "name.txt"}
      }]
    }]
  }).include( "name", "repo", "path", "actual_md5", "actual_sha1", "size", "type", "property" )
  ```

## find items (folder) some times ago by aql

- find root folder && 4 weeks ago (by using `-T, --upload-file`)

  > [!NOTE]
  > [imarslo: write a file without indent space](../cheatsheet/text-processing/text-processing.html#write-a-file-without-indent-space)

  ```bash
  $ cat find.aql
  items.find ({
    "repo": "my-repo",
    "type" : "folder" ,
    "depth" : "1",
    "created" : {
      "$before" : "4w"
    }
  })

  $ curl [-s] \
         -X POST \
         -uadmin:password https://artifactory.sample.com/artifactory/api/search/aql \
         -T find.aql
  ```

<!--sec data-title="curl manual for `-T, --upload-file`" data-id="section0" data-show=true data-collapse=true ces-->
> -T, --upload-file <file>
>         This transfers the specified local file to the remote URL. If there is no file  part  in  the
>         specified  URL,  curl will append the local file name. NOTE that you must use a trailing / on
>         the last directory to really prove to Curl that there is no file name or curl will think that
>         your  last  directory  name  is  the remote file name to use. That will most likely cause the
>         upload operation to fail. If this is used on an HTTP(S) server, the PUT command will be used.
>
>         Use the file name "-" (a single dash) to use stdin instead of a given file.  Alternately, the
>         file name "." (a single period) may be specified instead of "-" to use stdin in  non-blocking
>         mode to allow reading server output while stdin is being uploaded.
>
>         You  can  specify  one -T, --upload-file for each URL on the command line. Each -T, --upload-
>         file + URL pair specifies what to upload and to where. curl also supports "globbing"  of  the
>         -T,  --upload-file  argument,  meaning  that you can upload multiple files to a single URL by
>         using the same URL globbing style supported in the URL, like this:
>
>          curl --upload-file "{file1,file2}" http://www.example.com
>
>         or even
>
>          curl -T "img[1-1000].png" ftp://ftp.example.com/upload/
<!--endsec-->


- search by using `-d, --data`
  ```bash
  $ curl -s \
         --netrc-file ~/.marslo/.netrc \
         -X POST https://artifactory.sample.com/artifactory/api/search/aql \
         -H "Content-Type: text/plain" \
         -d """items.find ({ \"repo\": \"my-repo\", \"type\" : \"folder\" , \"depth\" : \"1\", \"created\" : { \"\$before\" : \"4mo\" } }) """

  $ cat ~/.marslo/.netrc
  machine artifactory.sample.com
  login admin
  password password
  ```

<!--sec data-title="curl manual for `-d, --data`" data-id="section1" data-show=true data-collapse=true ces-->
> d, --data <data>
>          (HTTP) Sends the specified data in a POST request to the HTTP server, in the same way that  a
>          browser  does when a user has filled in an HTML form and presses the submit button. This will
>          cause curl to pass the data to the  server  using  the  content-type  application/x-www-form-
>          urlencoded.  Compare to -F, --form.
>
>          --data-raw  is almost the same but does not have a special interpretation of the @ character.
>          To post data purely binary, you should instead use the --data-binary option.   To  URL-encode
>          the value of a form field you may use --data-urlencode.
>
>          If  any  of  these  options  is used more than once on the same command line, the data pieces
>          specified will be merged together with a separating &-symbol. Thus, using '-d name=daniel  -d
>          skill=lousy' would generate a post chunk that looks like 'name=daniel&skill=lousy'.
>
>          If  you  start  the  data  with the letter @, the rest should be a file name to read the data
>          from, or - if you want curl to read the data from stdin. Multiple files can  also  be  speci-
>          fied.  Posting  data  from  a file named from a file like that, carriage returns and newlines
>          will be stripped out. If you don't want the @ character to have a special interpretation  use
>          --data-raw instead.
>
>          See  also --data-binary and --data-urlencode and --data-raw. This option overrides -F, --form
>          and -I, --head and -T, --upload-file.
<!--endsec-->

  - or
  ```bash
  $ curl -s \
         --netrc-file ~/.marslo/.netrc \
         -X POST https://artifactory.sample.com/artifactory/api/search/aql \
         -H "Content-Type: text/plain" \
         -d """items.find ({ \
                 \"repo\": \"my-repo\", \
                 \"type\" : \"folder\" , \
                 \"depth\" : \"1\", \
                 \"created\" : { \"\$before\" : \"4mo\" } \
              })
            """ \
         | jq --raw-output .results[].name?
  ```

  - or (with sort and limit)
  > [Artifactory query language (AQL). How to write a not match query with $nmatch](https://medium.com/@MaheshSawaiker/artifactory-query-language-aql-how-to-write-a-not-match-query-with-nmatch-289b708c31ae)

  ```bash
  $ curl -X POST \
         -k \
         -H 'Content-Type:text/plain' \
         -i \
         'https://artifactory.sample.com/artifactory/api/search/aql' \
         -d 'items.find ({
                          "repo": "proj-1-local",
                          "type" : "folder" ,
                          "depth" : "1",
                          "created" : { "$before" : "3days" }
                        }).sort({"$desc":["created"]}).limit(1)
            '
  ```

  - or `-d @<filename>`
  > [JFrog Artifactory REST API in 5min](https://greenido.wordpress.com/2019/08/13/jfrog-artifactory-rest-api-in-5min/)

  ```bash
  $ cat builds.json
  builds.find({
    "name" : "ci - build - name",
    "created" : {
      "$before" : "10d"
    }
  })

  $ curl -s \
         -g \
         -d @builds.json \
         -H "Content-Type: text/plain" \
         -X POST "https://${rtURL}/api/search/aql"
  ```
