<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [syntax](#syntax)
  - [entities and fields](#entities-and-fields)
  - [comparison operators](#comparison-operators)
  - [field criteria](#field-criteria)
  - [relative time operators](#relative-time-operators)
- [search](#search)
  - [find in files by name/pattern](#find-in-files-by-namepattern)
  - [find items (folder) some times ago by aql](#find-items-folder-some-times-ago-by-aql)
- [sort and limit](#sort-and-limit)
  - [find most recent item](#find-most-recent-item)
  - [find and pagination (sort and limit)](#find-and-pagination-sort-and-limit)
- [specify output fields](#specify-output-fields)
  - [example](#example)
- [call aql via CURL](#call-aql-via-curl)
  - [running via `curl -d`](#running-via-curl--d)
  - [running via `curl -T`](#running-via-curl--t)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [jfrog/artifactory-scripts](https://github.com/jfrog/artifactory-scripts)
> - [Artifactory Query Language (AQL)](https://jfrog.com/help/r/jfrog-rest-apis/artifactory-query-language-aql)
> - [Artifactory Query Language](https://jfrog.com/help/r/jfrog-rest-apis/artifactory-query-language) | [Artifactory Query Language (AQL)](https://jfrog.com/help/r/jfrog-artifactory-documentation/artifactory-query-language)
>   - [Using AQL With Remote Repositories](https://jfrog.com/help/r/jfrog-artifactory-documentation/using-aql-with-remote-repositories)
>   - [Using AQL With Virtual Repositories](https://jfrog.com/help/r/jfrog-artifactory-documentation/using-aql-with-virtual-repositories)
> - [Advanced Cleanup Using Artifactory Query Language (AQL)](https://jfrog.com/blog/advanced-cleanup-using-artifactory-query-language-aql/)

## syntax
### [entities and fields](https://jfrog.com/help/r/jfrog-artifactory-documentation/artifactory-query-language)

| DOMAIN           | FIELD NAME           | TYPE   |
|------------------|----------------------|--------|
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

### [comparison operators](https://jfrog.com/help/r/jfrog-artifactory-documentation/artifactory-query-language)

| OPERATOR  | TYPES                     |
|-----------|---------------------------|
| `$ne`     | `string, date, int, long` |
| `$eq`     | `string, date, int, long` |
| `$gt`     | `string, date, int, long` |
| `$gte`    | `string, date, int, long` |
| `$lt`     | `string, date, int, long` |
| `$lte`    | `string, date, int, long` |
| `$match`  | `string, date, int, long` |
| `$nmatch` | `string, date, int, long` |


### [field criteria](https://jfrog.com/help/r/jfrog-artifactory-documentation/field-criteria)

| ELEMENT          | DESCRIPTION                                          |
|------------------|------------------------------------------------------|
| Example          | Find items whose "name" field equals "ant-1.9.4.jar" |
| Regular notation | `items.find({"name":{"$eq":"ant-1.9.4.jar"}})`       |
| Short notation   | `items.find({"name":"ant-1.9.4.jar"})`               |

- example

  ```aql
  // find items whose "name" field matches the expression "*test.*"
  items.find({"name": {"$match" : "*test.*"}})

  // find items that have been downloaded over 5 times.
  // we need to include the "stat" specifier in "stat.downloads" since downloads is a field of the stat domain and not of the item domain.
  items.find({"stat.downloads":{"$gt":"5"}})

  // find items that have never been downloaded. note that when specifying zero downloads we use "null" instead of 0.
  // we need to include the "stat" specifier in "stat.downloads" since downloads is a field of the stat domain and not of the item domain.
  items.find({"stat.downloads":{"$eq":null}})

  // find builds that use a dependency that is a snapshot
  builds.find({"module.dependency.item.name":{"$match":"*SNAPSHOT*"}})
  ```

### [relative time operators](https://www.jfrog.com/confluence/display/RTF/Artifactory+Query+Language#ArtifactoryQueryLanguage-RelativeTimeOperators)

> [!NOTE|label:references:]
> - [aqlCleanup.groovy](https://github.com/JFrog/artifactory-scripts/blob/master/cleanup/aqlCleanup.groovy)
> - [Advanced Cleanup Using Artifactory Query Language (AQL)](https://jfrog.com/blog/advanced-cleanup-using-artifactory-query-language-aql/)

AQL supports specifying time intervals for queries using relative time. In other words, the time interval for the query will always be relative to the time that the query is run, so you don't have to change or formulate the time period, in some other way, each time the query is run. For example, you may want to run a query over the last day, or for the time period up to two weeks ago.

relative time is specified using the following two operators:

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


## search
### find in files by name/pattern

> [!NOTE|label:verbose]
> - `RT_URL`: `https://artifactory.sample.com/artifactory`
> - `account`: `username`
> - `password`: `password` or API token

#### same repo with `curl -d`
```bash
$ curl -fsSL -u ${account}:${password} \
       -X POST ${RT_URL}/api/search/aql \
       -H "Content-Type: text/plain" \
       -d 'items.find(
            {"repo" : "repo-name"},
            {"path" : {"$match":"*path/to/folder*"}},
            {"name" : {"$match":"name-*.json"}}
          ).include( "repo","path","name","created","updated","actual_md5","actual_sha1" )
          '
# or
$ curl -s -u ${account}:${password} \
       -X POST "${RT_URL}api/search/aql" \
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
          }).include( "name","repo","path","actual_md5","actual_sha1","size","type","property" )
          '
```

#### search in same repo with `curl -T`
```aql
items.find(
  {"repo" : "repo-name"},
  {"path" : {"$match":"path/to/folder*"}},
  {"name" : {"$match":"name-*.json"}}
).include( "repo","path","name","created","updated","actual_md5","actual_sha1" )

// -- or --
items.find ({
  "repo" : "repo-name",
  "path" : { "$match": "path/to/folder*" } ,
  "name" : { "$match": "name-*.json" }
}).include( "name","repo","path","created","actual_md5","actual_sha1","size","type","property" )

// -- or --
tems.find ({
  "path" : { "$ne" : "." },
  "repo" : "repo-name",
  "$or" : [
    {
      "$and" : [{
        "path" : { "$match": "path/to/folder" } ,
        "name" : { "$match": "name.zip" }
      }]
    },
    {
      "$and" : [{
        "path" : { "$match" : "path/to/folder/*" } ,
        "name" : { "$match" : "name.zip" }
      }]
    }
  ]
}).include( "name","repo","path","actual_md5","actual_sha1","size","type","property" )
```

```bash
$ curl -s -u "${account}":"${password}" \
          -XPOST \
          "${RT_URL}/artifactory/api/search/aql" \
          -T find.aql
```

#### in different repo
```aql
tems.find ({
  "path" : { "$ne" : "." },
  "$or" : [
    {
      "$and" : [{
        "repo" : "repo-name-1",
        "path" : { "$match": "path/to/folder/*" } ,
        "name" : { "$match": "name.txt" }
      }]
    },
    {
      "$and" : [{
        "repo" : "repo-name-2",
        "path" : { "$match" : "path/to/folder/*" } ,
        "name" : { "$match" : "name.txt"}
      }]
    }
  ]
}).include( "name", "repo", "path", "actual_md5", "actual_sha1", "size", "type", "property" )
```

### find items (folder) some times ago by aql

- find root folder && 4 weeks ago (by using `-T, --upload-file`)

  > [!NOTE|label:references:]
  > - [imarslo: write a file without indent space](../cheatsheet/text-processing/text-processing.html#write-a-file-without-indent-space)
  > - find.aql:
  >   ```aql
  >   items.find ({
  >     "repo": "my-repo",
  >     "type" : "folder" ,
  >     "depth" : "1",
  >     "created" : { "$before" : "4w" }
  >   })

  ```bash
  $ curl [-fsSL] \
         -X POST \
         -uadmin:password https://artifactory.sample.com/artifactory/api/search/aql \
         -T find.aql
  ```

- search by using `-d, --data`
  ```bash
  $ curl -s \
         --netrc-file ~/.marslo/.netrc \
         -X POST https://artifactory.sample.com/artifactory/api/search/aql \
         -H "Content-Type: text/plain" \
         -d """items.find ({ \"repo\": \"my-repo\", \"type\" : \"folder\" , \"depth\" : \"1\", \"created\" : { \"\$before\" : \"4mo\" } }) """

  # -- or --
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

  $ cat ~/.marslo/.netrc
  machine artifactory.sample.com
  login admin
  password password
  ```

  - or (with sort and limit)

    > [!NOT|label:references]
    > [Artifactory query language (AQL). How to write a not match query with $nmatch](https://medium.com/@MaheshSawaiker/artifactory-query-language-aql-how-to-write-a-not-match-query-with-nmatch-289b708c31ae)

    ```bash
    $ curl -k -i \
           -H 'Content-Type:text/plain' \
           -X POST 'https://artifactory.sample.com/artifactory/api/search/aql' \
           -d 'items.find ({
                            "repo": "proj-1-local",
                            "type" : "folder" ,
                            "depth" : "1",
                            "created" : { "$before" : "3days" }
                          }).sort({"$desc":["created"]}).limit(1)
              '
    ```

  - or `-d @<filename>`

    > [!NOTE|label:references:]
    > - [JFrog Artifactory REST API in 5min](https://greenido.wordpress.com/2019/08/13/jfrog-artifactory-rest-api-in-5min/)
    > - build.aql:
    > ```aql
    > builds.find({
    >   "name" : "ci - build - name",
    >   "created" : { "$before" : "10d" }
    > })
    > ```

    ```bash
    $ curl -s -g \
           -d @builds.json \
           -H "Content-Type: text/plain" \
           -X POST "${RT_URL}/api/search/aql"
    ```

## sort and limit

> [!TIP|label:references:]
> - [Sorting in AQL](https://jfrog.com/help/r/jfrog-artifactory-documentation/sorting-in-aql)
>   - syntax:
>     ```bash
>     .sort({"<$asc | $desc>" : ["<field1>", "<field2>",... ]})
>     ```
> - [Display Limits and Pagination](https://jfrog.com/help/r/jfrog-artifactory-documentation/display-limits-and-pagination)
> - [ARTIFACTORY: AQL- How to sort by Properties](https://jfrog.com/help/r/artifactory-aql-how-to-sort-by-properties/artifactory-aql-how-to-sort-by-properties)

### find most recent item

> [!NOTE|label:references:]
> - [search in same repo](#search-in-same-repo-with-curl--t)

```aql
// sort by created timestamp
items.find(
  {"repo" : "repo-name"},
  {"path" : {"$match":"path/to/folder*"}},
  {"name" : {"$match":"name-*.json"}}
).include( "repo","path","name","created","updated","actual_md5","actual_sha1" )
 .sort({"$desc":["created"]})
 .limit(1)
```

### find and pagination (sort and limit)

```aql
// run the same example, but this time, display up to 50 items but skipping the first 100
items.find({"name" : {"$match":"*.jar"})
     .sort({"$asc" : ["repo","name"]})
     .offset(100)
     .limit(50)
```

## specify output fields

> [!TIP|label:references:]
> - [Specify Output Fields](https://jfrog.com/help/r/jfrog-artifactory-documentation/specify-output-fields)
> - [Filtering Properties by Key](https://jfrog.com/help/r/jfrog-artifactory-documentation/filtering-properties-by-key)
>   ```aql
>   // get all properties
>   items.find().include("name", "repo", "property.*")
>
>   // get `version` only
>   items.find().include("name", "repo", "@version")
>   ```

### [example](https://jfrog.com/help/r/jfrog-artifactory-documentation/display-specific-fields)
```aql
// Find all items, and display the "name" and "repo" fields as well as the number of "downloads" from the corresponding "stat" entity
items.find().include("name", "repo", "stat.downloads")

// Find all items, and display the default item fields fields as well as the stat fields
items.find().include("stat")

// Find all items, and display the default item fields as well as the stat and the property fields
items.find().include("stat", "property")

// Find all items, and display the "name" and "repo" fields as well as the stat fields
items.find().include("name", "repo", "stat")

// Find all builds that generated items with an Apache license, and display the build fields as well as the item "name" fields. Click below to view the output of this query
builds.find(
  {
    "module.artifact.item.@license":{"$match":"Apache*"}
  }
).include("module.artifact.item.name")
```

## call aql via CURL
### running via `curl -d`

<!--sec data-title="curl manual for `-d, --data <data>`" data-id="section0" data-show=true data-collapse=true ces-->
> -d, --data <data>
>        (HTTP MQTT) Sends the specified data in a POST request to the HTTP server, in the same way that a browser
>        does when a user has filled in an HTML form and presses the submit button. This makes curl pass the data
>        to the server using the content-type application/x-www-form-urlencoded. Compare to -F, --form.
>
>        --data-raw is almost the same but does not have a special interpretation of the @ character. To post data
>        purely binary, you should instead use the --data-binary option. To URL-encode the value of a form field
>        you may use --data-urlencode.
>
>        If any of these options is used more than once on the same command line, the data pieces specified are
>        merged with a separating &-symbol. Thus, using '-d name=daniel -d skill=lousy' would generate a post
>        chunk that looks like 'name=daniel&skill=lousy'.
>
>        If you start the data with the letter @, the rest should be a file name to read the data from, or - if
>        you want curl to read the data from stdin. Posting data from a file named 'foobar' would thus be done
>        with -d, --data @foobar. When -d, --data is told to read from a file like that, carriage returns and
>        newlines are stripped out. If you do not want the @ character to have a special interpretation use
>        --data-raw instead.
>
>        The data for this option is passed on to the server exactly as provided on the command line. curl does
>        not convert, change or improve it. It is up to the user to provide the data in the correct form.
>
>        --data can be used several times in a command line
>
>        Examples:
>         curl -d "name=curl" https://example.com
>         curl -d "name=curl" -d "tool=cmdline" https://example.com
>         curl -d @filename https://example.com
>
>        See also --data-binary, --data-urlencode and --data-raw. This option is mutually exclusive to -F, --form
>        and -I, --head and -T, --upload-file.
<!--endsec-->

### running via `curl -T`

<!--sec data-title="curl manual for `-T, --upload-file`" data-id="section1" data-show=true data-collapse=true ces-->
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
