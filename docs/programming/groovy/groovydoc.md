<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Generate Groovy API doc from command line](#generate-groovy-api-doc-from-command-line)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Generate Groovy API doc from command line

> credit belongs to [HOW-TO Documenting Groovy with Groovydoc](https://www.javaworld.com/article/2074120/documenting-groovy-with-groovydoc.html)

```bash
$ groovydoc -classpath /usr/local/Cellar/groovy/3.0.1/libexec/lib/
            -d output
            -windowtitle "Groovy Logging Example"
            -header "Groovy 1.8 Logging (Inspired by Actual Events)"
            -footer "Inspired by Actual Events: Logging in Groovy 1.8"
            -doctitle "Logging in Groovy 1.8 Demonstrated"
            *.groovy *.java
```
