<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [ssl.h](#sslh)
- [curl.h](#curlh)
- [expat.h](#expath)
- [tclsh](#tclsh)
- [asciidoc](#asciidoc)
- [docbook2x-texi](#docbook2x-texi)
- [hunspell](#hunspell)
- [ao](#ao)
- [ncurses](#ncurses)
- [bash_completion](#bash_completion)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### ssl.h
- issues:
  ```bash
  git-compat-util.h:213:25: fatal error: openssl/ssl.h: No such file or directory
  #include \<openssl/ssl.h\>
  ```

- Solution:
  - Ubuntu/Debian:
    ```bash
    $ sudo apt-get install libssl-dev
    ```

  - RHEL/CentOS
    ```bash
    $ sudo yum install openssl-devel
    ```

### curl.h
- issues:
  ```bash
  http.h:6:23: fatal error: curl/curl.h: No such file or directory
  #include \<curl/curl.h\>
  ```

- Solution:
    - For OpenSuse:
      ```bash
      $ sudo apt-get install libcurl4-openssl
      ```

    - For Ubuntu/Debian:
      ```bash
      $ sudo apt-get install libcurl4-openssl-dev
      ```

    - For RHEL/CentOS:
      ```bash
      $ sudo yum install libcurl libcurl-devel
      ```

- Reason:
`libcurl-dev` should be installed, but
  ```bash
  Package libcurl-dev is a virtual package provided by:
    libcurl4-openssl-dev 7.35.0-1ubuntu2
    libcurl4-nss-dev 7.35.0-1ubuntu2
    libcurl4-gnutls-dev 7.35.0-1ubuntu2
  You should explicitly select one to install.
  ```

### expat.h
- issues:
  ```bash
  http-push.c:17:19: fatal error: expat.h: No such file or directory
  #include \<expat.h\>
  ```

- Solution:
  - For Ubuntu/Debain:
    ```bash
    $ apt-cache search expat | grep dev
    libexpat1-dev - XML parsing C library - development kit
    lib64expat1-dev - XML parsing C library - development kit (64bit)
    libexpat-ocaml-dev - OCaml expat bindings
    lua-expat-dev - libexpat development files for the Lua language
    tdom-dev - fast XML/DOM/XPath/XSLT extension for Tcl written in C (development files)

    $ sudo apt-get install libexpat1-dev
    ```
  - For RHEL/CentOS:
    ```bash
    $ sudo yum install expat-devel
    ```

### tclsh
- issues:
  ```bash
  tclsh failed; using unoptimized loading
  MSGFMT    po/de.msg make[1]: *** [po/de.msg] Error 127
  make: *** [all] Error 2
  ```

- Solution:
  - For Ubuntu/Debain:
    ```bash
    $ sudo apt-get install gettext
    ```

### asciidoc
- issues
  ```bash
  ASCIIDOC git-add.html
  /bin/sh: 2: asciidoc: not found
  make[1]: *** [git-add.html] Error 127
  make[1]: Leaving directory `/home/marslo/Tools/Software/Programming/Git/git-master/Documentation'
  make: *** [doc] Error 2
  ```

- solution
  - For Ubuntu/Debain:
    ```bash
    $ apt-cache search asciidoc
    $ sudo apt-get install asciidoc
    ```

  - For RHEL/CentOS:
    ```bash
    $ yum install docbook-style-xsl
    $ rpm -ivh http://pkgs.repoforge.org/asciidoc/asciidoc-8.6.9-1.el6.rfx.noarch.rpm
    ```

### docbook2x-texi
- issues
  ```bash
  db2texi user-manual.texi
  /bin/sh: 2: docbook2x-texi: not found
  make[1]: *** [user-manual.texi] error 127
  make[1]: leaving directory `/home/marslo/tools/software/programming/git/git-master/documentation'
  make: *** [info] error 2
  ```

- solution
  - For Ubuntu/Debain:
    ```bash
    $ sudo apt-get install docbook2x
    ```
  - For RHEL/CentOS (Inspired from [Git for human beings google group](https://groups.google.com/d/msg/git-users/DMaDpy8Bpww/jqXULjp8ry8J)):
    ```bash
    $ sudo yum -y --enablerepo=*epel* install docbook2X
    $ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
    ```

### hunspell
- issues
  ```bash
  $ qmake-qt4
  Project MESSAGE: Install Prefix is: /usr/local
  Project ERROR: Package hunspell not found
  ```

- solution
  - For Ubuntu/Debain:
    ```bash
    $ sudo apt-get install hunspell
    $ sudo apt-get install libhunspell-dev
    ```

### ao
- issues
  ```bash
  $ qmake-qt4
  Project MESSAGE: Install Prefix is: /usr/local
  Project ERROR: Package ao not found
  ```

- solution
  - For Ubuntu/Debain:
    ```bash
    $ apt-cache search ao | grep dev
    libao-dev - Cross Platform Audio Output Library Development
    ...

    $ sudo apt-get install libao-dev
    ```

### ncurses
- issues
  ```bash
  no terminal library found
  checking for tgetent()... configure: error: NOT FOUND!
        You need to install a terminal library; for example ncurses.
        Or specify the name of the library with --with-tlib.
  ```

- solution
  - For RHEL/CentOS:
    ```bash
    $ yum install ncurses-devel
    ```

### bash_completion

- `bash: _filedir: command not found`

  > [!NOTE|label:references:]
  > - [#1305: bash:_filedir: command not found](https://github.com/Bash-it/bash-it/issues/1305)

  ```bash
  # modify
  BASH_COMPLETION="$(brew --prefix)/etc/profile.d/bash_completion.sh"
  # to
  BASH_COMPLETION="$(brew --prefix bash-completion)/etc/bash_completion"

  # and then
  test -f "${BASH_COMPLETION}" && source "${BASH_COMPLETION}"
  ```

  - result
    ```bash
    $ type _filedir
    _filedir is a function
    _filedir ()
    {
        local i IFS='
    ' xspec;
        _tilde "$cur" || return 0;
        local -a toks;
        local quoted tmp;
        _quote_readline_by_ref "$cur" quoted;
        toks=(${toks[@]-} $(compgen -d -- "$cur" | { while read -r tmp; do
        printf '%s\n' $tmp;
    done; }));
        if [[ "$1" != -d ]]; then
            [[ ${BASH_VERSINFO[0]} -ge 4 ]] && xspec=${1:+"!*.@($1|${1^^})"} || xspec=${1:+"!*.@($1|$(printf %s $1 | tr '[:lower:]' '[:upper:]'))"};
            toks=(${toks[@]-} $(compgen -f -X "$xspec" -- $quoted));
        fi;
        [ ${#toks[@]} -ne 0 ] && _compopt_o_filenames;
        COMPREPLY=("${COMPREPLY[@]}" "${toks[@]}")
    }

    $ fcf _filedir
    _filedir 632 /usr/local/opt/bash-completion/etc/bash_completion
    ```
