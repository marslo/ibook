<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [params](#params)
  - [args](#args)
  - [groovy.cli.commons.CliBuilder](#groovyclicommonsclibuilder)
- [groovy script with params in Jenkins CLI](#groovy-script-with-params-in-jenkins-cli)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## params
### args
```groovy
#!/usr/bin/env groovy

println ".. args : ${args} : ${args.getClass()}"
```

- results:
  ```
  $ groovy params.groovy
  .. args : [] : class [Ljava.lang.String;

  $ groovy params.groovy a b c
  .. args : [a, b, c] : class [Ljava.lang.String;
  ```


### groovy.cli.commons.CliBuilder

> [!NOTE|label:references:]
> - [* Groovy 2.5 CliBuilder Renewal](https://picocli.info/groovy-2.5-clibuilder-renewal.html)
> - [Groovy Goodness: Parsing Commandline Arguments with CliBuilder](https://blog.mrhaki.com/2009/09/groovy-goodness-parsing-commandline.html)
> - [Groovy: parsing command-line arguments with CliBuilder](https://medium.com/@tambapps/groovy-parsing-command-line-arguments-with-clibuilder-44eaad1be4b4)
> - [Building CLIs with Groovy's CLI Builder](https://www.joshdurbin.net/posts/2020-3-groovy-clibuilder/)
> - [Class groovy.cli.commons.CliBuilder](https://docs.groovy-lang.org/latest/html/gapi/groovy/cli/commons/CliBuilder.html)
> - [CliBuilder.groovy](https://github.com/apache/groovy/blob/master/subprojects/groovy-cli-picocli/src/main/groovy/groovy/cli/picocli/CliBuilder.groovy)

```groovy
#!/usr/bin/env groovy

import groovy.cli.commons.CliBuilder
import groovy.cli.commons.OptionAccessor

List<String> allList   = [ 'a', 'b', 'c', 'd', 'e', 'f' ]
List<String> list      = [ 'a', 'b', 'c' ]
Boolean shouldSuppress = true

CliBuilder cli = new CliBuilder( usage: 'params.groovy [-a|-h]' )
cli.with {
  h longOpt: 'help',        'Show usage information'
  a longOpt: 'all-plugins', 'print all plugins'
}
OptionAccessor options = cli.parse(args)

// Show usage text when -h or --help option is used.
if ( options.h ) {
  cli.usage()
  return
}
if ( options.a ) { shouldSuppress = false }

println allList.findAll{ shouldSuppress ? list.contains(it) : it }
```

- results:
  - `--help` | `-h`
    ```
    $ groovy params.groovy -h
    usage: params.groovy [-a|-h]
     -a,--all-plugins   print all plugins
     -h,--help          Show usage information

    $ groovy params.groovy --help
    usage: params.groovy [-a|-h]
     -a,--all-plugins   print all plugins
     -h,--help          Show usage information
    ```

  - without parameters
    ```
    $ groovy params.groovy
    [a, b, c]
    ```

  - `--all-plugins` | `-a`
    ```
    $ groovy params.groovy -a
    [a, b, c, d, e, f]

    $ groovy params.groovy --all-plugins
    [a, b, c, d, e, f]
    ```

## groovy script with params in Jenkins CLI

> [!TIPS]
> only allows `args`. `CliBuilder` is not supported by default.

```bash
# without parameters
$ ssh JENKINS_URL groovy =< params-args.groovy

# with parameters
#                   params add before `<`
#                          +---+
$ ssh JENKINS_URL groovy = a b c < params-args.groovy
```
