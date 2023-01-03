<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [dockerfile](#dockerfile)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## dockerfile

{% hint style='tip' %}
> references:
> - [JDK Script Friendly URLs](https://www.oracle.com/java/technologies/jdk-script-friendly-urls/)
{% endhint %}

```dockerfile
ENV JAVA_PKG=https://download.oracle.com/java/17/latest/jdk-17_linux-x64_bin.tar.gz \
    JAVA_HOME=/usr/java/jdk-17

RUN set -eux; \
      JAVA_SHA256=$(curl "$JAVA_PKG".sha256) ; \
      curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
      echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c; \
      mkdir -p "$JAVA_HOME"; \
      tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1
```
