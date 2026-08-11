<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [groovy & jenkinsfile](#groovy--jenkinsfile)
  - [groovy libs setup](#groovy-libs-setup)
  - [jenkins libs setup](#jenkins-libs-setup)
  - [coc settings](#coc-settings)
  - [environment variables](#environment-variables)
  - [enhanced groovy tree-sitter](#enhanced-groovy-tree-sitter)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


# groovy & jenkinsfile

![lsp groovydoc](../../screenshot/vim/vim-groovydoc-lfs-lsp.png)

## groovy libs setup

> [!NOTE|label:references:]
> - download all groovy jar files with `-sources.jar` && `-javadoc.jar`

```bash
# install and setup
$ curl -fsSL https://github.com/marslo/mytools/raw/main/itool/groovy-libs.sh | bash -s -- --groovy --groovy-libs --path /opt/groovy

# check help
$ curl -fsSL https://github.com/marslo/mytools/raw/main/itool/groovy-libs.sh | bash -s -- --help
```

## jenkins libs setup

> [!NOTE|label:references:]
> - setup and linked all jar file into `${HOME}/.groovy/lib/`

```bash
$ curl -fsSL https://github.com/marslo/mytools/raw/main/itool/jenkins-libs.sh | bash -s -- --lts --ln --path /opt/jenkins

# check help
$ curl -fsSL https://github.com/marslo/mytools/raw/main/itool/jenkins-libs.sh | bash -s -- --help
```

## coc settings

```jsonc
{
  "groovy.project.referencedLibraries": [
    "/opt/groovy/latest/*",
    "$HOME/.groovy/lib/*",
    "/opt/jenkins/latest/WEB-INF/lib/*",
    "/opt/homebrew/opt/groovy/libexec/lib/*"
  ],
}
```

## environment variables

```bash
# ~/.bashrc or ~/.bash_profile

JAVA_HOME=$(/usr/libexec/java_home)
GROOVY_HOME="${HOMEBREW_OPT}/groovy/libexec"
_GROOVY_LIBS='/opt/groovy'
_JENKINS_LIBS="${HOME}/.groovy/lib"
GROOVY_CLASSPATH="${GROOVY_CLASSPATH:+$GROOVY_CLASSPATH:}"
test -d "${GROOVY_HOME}/lib"                  && GROOVY_CLASSPATH+=".:$(echo "${GROOVY_HOME}"/lib/*.jar   | tr ' ' ':'):"
test -d "${_GROOVY_LIBS}"                     && GROOVY_CLASSPATH+="$(echo "${_GROOVY_LIBS}"/latest/*.jar | tr ' ' ':'):"
test -d "${_GROOVY_LIBS}/extensions"          && GROOVY_CLASSPATH+="$(echo "${_GROOVY_LIBS}"/extensions/*/latest/*.jar | tr ' ' ':'):"
test -d "${_JENKINS_LIBS}"                    && GROOVY_CLASSPATH+="$(echo "${_JENKINS_LIBS}"/*.jar | tr ' ' ':'):"
test -f "${HOMEBREW_OPT}/coreutils/libexec/gnubin/paste" &&
     GROOVY_CLASSPATH=$( echo "${GROOVY_CLASSPATH}" | tr ':' '\n' | awk 'NF' | awk '!x[$0]++' | "${HOMEBREW_OPT}/coreutils/libexec/gnubin/paste" -s -d: )
test -f "${JAVA_HOME}/lib/tools.jar"          && GROOVY_CLASSPATH+=":${JAVA_HOME}/lib/tools.jar"
test -f "${JAVA_HOME}/lib/dt.jar"             && GROOVY_CLASSPATH+=":${JAVA_HOME}/lib/dt.jar"
CLASSPATH+=":${GROOVY_CLASSPATH}"
test -f "${HOMEBREW_OPT}/coreutils/libexec/gnubin/paste" &&
     CLASSPATH=$( echo "${CLASSPATH}" | tr ':' '\n' | awk 'NF' | awk '!x[$0]++' | "${HOMEBREW_OPT}/coreutils/libexec/gnubin/paste" -s -d: )
CPPFLAGS="-I${HOMEBREW_OPT}/openjdk/include"                   # https://stackoverflow.com/a/69504284/2940319
unset _GROOVY_LIBS _JENKINS_LIBS
```

## enhanced groovy tree-sitter

> [!NOTE|label:references:]
> - check details in [* iMarslo: nvim-treesitter](./nvim-treesitter.md)
