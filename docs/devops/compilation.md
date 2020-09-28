<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ssl.h](#sslh)
- [curl.h](#curlh)
- [expat.h](#expath)
- [tclsh](#tclsh)
- [asciidoc](#asciidoc)
- [docbook2x-texi](#docbook2x-texi)
- [hunspell](#hunspell)
- [ao](#ao)
- [ncurses](#ncurses)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### ssl.h
- Problem:

        git-compat-util.h:213:25: fatal error: openssl/ssl.h: No such file or directory
        #include \<openssl/ssl.h\>

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
- Problem:

        http.h:6:23: fatal error: curl/curl.h: No such file or directory
        #include \<curl/curl.h\>

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

        Package libcurl-dev is a virtual package provided by:
          libcurl4-openssl-dev 7.35.0-1ubuntu2
          libcurl4-nss-dev 7.35.0-1ubuntu2
          libcurl4-gnutls-dev 7.35.0-1ubuntu2
        You should explicitly select one to install.

### expat.h
- Problem:

        http-push.c:17:19: fatal error: expat.h: No such file or directory
        #include \<expat.h\>

- Solution:

    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MarsloJiao ~/Marslo/Tools/git) ->
    └─ $ apt-cache search expat | grep dev
    libexpat1-dev - XML parsing C library - development kit
    lib64expat1-dev - XML parsing C library - development kit (64bit)
    libexpat-ocaml-dev - OCaml expat bindings
    lua-expat-dev - libexpat development files for the Lua language
    tdom-dev - fast XML/DOM/XPath/XSLT extension for Tcl written in C (development files)
    ┌─ (marslo@MarsloJiao ~/Marslo/Tools/git) ->
    └─ $ sudo apt-get install libexpat1-dev
    ```


    - For RHEL/CentOS:

    ```bash
    ┌─ (marslo@MarsloJiao ~/Marslo/Tools/git) ->
    └─ $ sudo yum install expat-devel
    ```

### tclsh
- Problem:

        tclsh failed; using unoptimized loading
        MSGFMT    po/de.msg make[1]: *** [po/de.msg] Error 127
        make: *** [all] Error 2

- Solution:

    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ sudo apt-get install gettext
    ```

### asciidoc
- Problem

        ASCIIDOC git-add.html
        /bin/sh: 2: asciidoc: not found
        make[1]: *** [git-add.html] Error 127
        make[1]: Leaving directory `/home/marslo/Tools/Software/Programming/Git/git-master/Documentation'
        make: *** [doc] Error 2

- Solution
    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ apt-cache search asciidoc
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ sudo apt-get install asciidoc
    ```

    - For RHEL/CentOS:

    ```bash
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ yum install docbook-style-xsl
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ rpm -ivh http://pkgs.repoforge.org/asciidoc/asciidoc-8.6.9-1.el6.rfx.noarch.rpm
    ```

### docbook2x-texi
- Problem

        db2texi user-manual.texi
        /bin/sh: 2: docbook2x-texi: not found
        make[1]: *** [user-manual.texi] error 127
        make[1]: leaving directory `/home/marslo/tools/software/programming/git/git-master/documentation'
        make: *** [info] error 2

- Solution

    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ sudo apt-get install docbook2x
    ```

    - For RHEL/CentOS (Inspired from [Git for human beings google group](https://groups.google.com/d/msg/git-users/DMaDpy8Bpww/jqXULjp8ry8J)):


    ```bash
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ sudo yum -y --enablerepo=*epel* install docbook2X
    ┌─ (marslo@MJ ~/Tools/Software/Programming/Git/git-master) ->
    └─ $ sudo ln -s /usr/bin/db2x_docbook2texi /usr/bin/docbook2x-texi
    ```

### hunspell
- Problem

```bash
┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
└─ $ qmake-qt4
Project MESSAGE: Install Prefix is: /usr/local
Project ERROR: Package hunspell not found
```

- Solution

    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
    └─ $ sudo apt-get install hunspell
    ┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
    └─ $ sudo apt-get install libhunspell-dev
    ```

### ao
- Problem

```bash
┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
└─ $ qmake-qt4
Project MESSAGE: Install Prefix is: /usr/local
Project ERROR: Package ao not found
```

- Solution

    - For Ubuntu/Debain:

    ```bash
    ┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
    └─ $ apt-cache search ao | grep dev
    libao-dev - Cross Platform Audio Output Library Development
    ...
    ┌─ (marslo@MarsloJiao ~/Tools/Git/goldendict) ->
    └─ $ sudo apt-get install libao-dev
    ```


### ncurses
- Problem

        no terminal library found
        checking for tgetent()... configure: error: NOT FOUND!
              You need to install a terminal library; for example ncurses.
              Or specify the name of the library with --with-tlib.

- Solution
    - For Ubuntu/Debain:

   - For RHEL/CentOS:

    ```bash
    ┌─ (marslo@MarsloJiao ~/Marslo/Tools/vim) ->
    └─ $ yum install ncurses-devel
    ```
