<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Generate Groovy API doc from command line](#generate-groovy-api-doc-from-command-line)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Generate Groovy API doc from command line

{% hint style='tip' %}
> credit belongs to
> - [HOW-TO Documenting Groovy with Groovydoc](https://www.javaworld.com/article/2074120/documenting-groovy-with-groovydoc.html)
> references:
> - [Documentation Comment Specification for the Standard Doclet (JDK 17)](https://docs.oracle.com/en/java/javase/17/docs/specs/javadoc/doc-comment-spec.html#link)
> references:
> - [javadoc - The Java API Documentation Generator](https://docs.oracle.com/javase/7/docs/technotes/tools/windows/javadoc.html#version)
> - [How and When To Deprecate APIs](https://docs.oracle.com/javase/7/docs/technotes/guides/javadoc/deprecation/deprecation.html)
> - [How to Write Doc Comments for the Javadoc Tool](https://www.oracle.com/technical-resources/articles/java/javadoc-tool.html)
> - [Chapter 10. Documentation with Javadoc](http://www.drjava.org/docs/user/ch10.html#:~:text=For%20example%2C%20most%20Javadoc%20comments,a%20description%20of%20that%20parameter.)
{% endhint %}

```bash
$ groovydoc -classpath /usr/local/Cellar/groovy/3.0.1/libexec/lib/ \
            -d output \
            -windowtitle "Groovy Logging Example" \
            -header "Groovy 1.8 Logging (Inspired by Actual Events)" \
            -footer "Inspired by Actual Events: Logging in Groovy 1.8" \
            -doctitle "Logging in Groovy 1.8 Demonstrated" \
            *.groovy *.java
```
