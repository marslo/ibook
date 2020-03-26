
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
