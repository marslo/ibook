<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [bash completion](#bash-completion)
  - [patterns in load completion](#patterns-in-load-completion)
  - [osx](#osx)
  - [linux](#linux)
  - [bash alias completion](#bash-alias-completion)
  - [git alias completion](#git-alias-completion)
  - [troubleshooting](#troubleshooting)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## bash completion

```bash
$ complete -W "--help --verbose --version" foo

$ foo <TAB>
--help     --verbose  --version

$ foo --v
--verbose  --version

$ foo --ver
```

> [!NOTE|label:references]
> - [* iMarslo: bash completion troubleshooting for linux](../../linux/troubleshooting.md#bash_completion)
> - [* iMarslo : `_vim()`](https://github.com/marslo/dotfiles/blob/main/.marslo/bash_completion.d/vim.sh)
> - create bash completion
>   - [* Creating a bash completion script](https://iridakos.com/programming/2018/03/01/bash-programmable-completion-tutorial)
>   - [* An introduction to bash completion: part 1](https://web.archive.org/web/20190722115536/https://debian-administration.org/article/316/An_introduction_to_bash_completion_part_1)
>   - [* An introduction to bash completion: part 2](https://web.archive.org/web/20200327211933/https://debian-administration.org/article/317/An_introduction_to_bash_completion_part_2)
>     ```bash
>     $ complete -W "--help --verbose --version" foo
>     ```
>   - [8.7 Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html)
>   - [8.6 Programmable Completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
>   - [8.8 A Programmable Completion Example](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html#A-Programmable-Completion-Example)
>   - [cykerway/complete-alias](https://github.com/cykerway/complete-alias)
>   - [Multi Level Bash Completion](https://stackoverflow.com/a/5303225/2940319)
>   - [List all commands that a shell knows](https://unix.stackexchange.com/a/94825/29178)
>   - [Integralist/1. bash autocomplete for your custom programs.md](https://gist.github.com/Integralist/0500e6b5aabf95034cd83eff8c9e2ead)
>   - [8.6 Programmable Completion : `_completion_loader()` ](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html)
>   - [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Completion.html)
>
> - paths:
>   - osx: `$(brew --prefix)/etc/bash_completion.d`
>     - completion files in `bash-completion@2`: `$(brew --prefix bash-completion@2)/share/bash-completion/completions/`
>   - centos: `/usr/share/bash-completion/completions` or `/etc/bash_completion.d`
>   - ubuntu: `/usr/share/bash-completion/completions`

- print existing completion
  ```bash
  $ complete -p vim
  complete -o bashdefault -o default -F _fzf_opts_completion vim

  $ complete -p ffs
  complete -o bashdefault -o default -o nosort -F _fd ffs

  $ complete -p ff
  complete -o bashdefault -o default -o nosort -F _fd ff
  ```

- remove completion
  ```bash
  $ complete -p vim
  complete -o bashdefault -o default -F _fzf_opts_completion vim

  $ complete -r vim

  $ complete -p vim
  -bash: complete: vim: no completion specification
  ```

- [list all completions](https://unix.stackexchange.com/a/94784/29178)

  > [!TIP|label:references:]
  > ```bash
  > $ compgen --help
  > Display possible completions depending on the options
  > ```

  ```bash
  $ complete

  # show all commands
  $ compgen -c
  ```

  |            COMMAND            | DESCRIPTION |
  |:------------------------------|-------------|
  | `$ compgen -c`                | commands    |
  | `$ compgen -a`                | aliases     |
  | `$ compgen -b`                | built-ins   |
  | `$ compgen -k`                | keywords    |
  | `$ compgen -A function`       | functions   |
  | `$ compgen -A function -abck` | all above   |


  <!--sec data-title="details..." data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  $ complete
  complete -o default -F _quotaon quotaon
  complete -o default -F _fzf_path_completion mv
  complete -F _postcat postcat
  complete -o default -o nospace -v -F _fzf_var_completion printenv
  complete -o default -F __start_kubectl kcn
  complete -F _filedir_xspec mpg321
  complete -F _filedir_xspec tex
  complete -F _make gmake
  complete -o bashdefault -o default -F _fzf_path_completion diff3
  complete -o default -F _ansible ansible
  complete -o default -F _fzf_path_completion head
  complete -o default -F __start_kubectl kt1
  complete -o default -F __start_kubectl kt2
  complete -o default -F _fzf_path_completion uniq
  complete -F _command else
  complete -o default -F __start_kubectl kt3
  complete -F _ldapdelete ldapdelete
  complete -F _configure configure
  complete -F _filedir_xspec freeamp
  complete -F _lzma lzma
  complete -o default -F __start_kubectl kcc
  complete -F _filedir_xspec gqmpeg
  complete -F _filedir_xspec texi2html
  complete -o default -F _complete_groovydoc groovydoc
  complete -F _filedir_xspec hbpp
  complete -F _xsltproc xsltproc
  complete -F _filedir_xspec jadetex
  complete -F _docker droot
  complete -o default -F _longopt mkfifo
  complete -o bashdefault -o default -F _fzf_path_completion svn
  complete -o default -F _fzf_path_completion tee
  complete -F _javaws javaws
  complete -F _mktemp mktemp
  complete -F _filedir_xspec rpm2cpio
  complete -F _docker dvi
  complete -F _make pmake
  complete -o default -F _repquota repquota
  complete -F _filedir_xspec hbrun
  complete -F _autoscan autoscan
  complete -o default -F __start_kubectl kubectl
  complete -o default -F _screen screen
  complete -F _filedir_xspec ps2pdf14
  complete -o default -F _fzf_path_completion grep
  complete -F _fzf_path_completion vi
  complete -F _autoreconf autoheader
  complete -F _composite composite
  complete -F _fzf_path_completion bat
  complete -F _filedir_xspec ps2pdf13
  complete -o default -F _longopt objdump
  complete -F _filedir_xspec ps2pdf12
  complete -o default -F _longopt sha1sum
  complete -o default -F _longopt cut
  complete -F _filedir_xspec lyx
  complete -o bashdefault -o default -F _fzf_path_completion file
  complete -F _gcc gpc
  complete -F _filedir_xspec latex
  complete -o default -F _look look
  complete -F _gradle gradlew.bat
  complete -o bashdefault -o default -F _fzf_path_completion hx
  complete -F _filedir_xspec poedit
  complete -F _fzf_path_completion view
  complete -o bashdefault -o default -F _fzf_path_completion dirname
  complete -F _function typeset
  complete -o bashdefault -o default -F _fzf_path_completion hg
  complete -F _command nohup
  complete -a -F _fzf_alias_completion unalias
  complete -F _vipw vipw
  complete -g groupdel
  complete -F _make gnumake
  complete -u groups
  complete -F _filedir_xspec chromium-browser
  complete -F _filedir_xspec opera
  complete -F _filedir_xspec kbabel
  complete -F _fzf_host_completion telnet
  complete -F _gcc g77
  complete -F _filedir_xspec bzme
  complete -o bashdefault -o default -F _fzf_complete_ssh ssh
  complete -F _command vsound
  complete -c which
  complete -F _fzf_path_completion tar
  complete -o default -F _longopt m4
  complete -F _filedir_xspec madplay
  complete -o default -F _fzf_opts_completion fzf-tmux
  complete -F _docker drm
  complete -F _filedir_xspec dviselect
  complete -o default -F _fzf_path_completion cp
  complete -F _mas mas
  complete -F _animate animate
  complete -F _man whatis
  complete -o default -F _complete_groovysh groovysh.sh
  complete -F _filedir_xspec evince
  complete -o bashdefault -o default -F _brew brew
  complete -F _docker dcleanall
  complete -F _filedir_xspec realplay
  complete -o default -F _longopt strip
  complete -o bashdefault -o default -o nospace -F __git_wrap__gitk_main gitk
  complete -v readonly
  complete -o nospace -F _fzf_path_completion rsync
  complete -F _ctest ctest
  complete -o nospace -F _fzf_dir_completion cd
  complete -o default -F _complete_groovydoc groovydoc.bash
  complete -F _known_hosts showmount
  complete -F _filedir_xspec kdvi
  complete -o default -F _longopt tac
  complete -F _ldapaddmodify ldapmodify
  complete -F _filedir_xspec elinks
  complete -F _known_hosts fping
  complete -o default -F _longopt env
  complete -o default -F _quota quota
  complete -F _gradle ./gradlew
  complete -u chfn
  complete -F _docker drp
  complete -F _filedir_xspec compress
  complete -F _filedir_xspec pdfjadetex
  complete -F _filedir_xspec kghostview
  complete -F _man man
  complete -F _filedir_xspec pbunzip2
  complete -o default -F _brctl brctl
  complete -c type
  complete -F _ldapcompare ldapcompare
  complete -F _known_hosts ssh-installkeys
  complete -F _filedir_xspec iceweasel
  complete -F _filedir_xspec gtranslator
  complete -F _fzf_path_completion unzip
  complete -o default -F _longopt expand
  complete -o default -F _complete_groovyConsole groovyConsole.bash
  complete -o bashdefault -o default -o nospace -F _fzf_path_completion git
  complete -F _filedir_xspec lrunzip
  complete -o default -F _fzf_path_completion ln
  complete -F _command aoss
  complete -F _docker drps
  complete -F _filedir_xspec ggv
  complete -F _filedir_xspec oomath
  complete -F _filedir_xspec dvipdfmx
  complete -o default -F _fzf_path_completion ld
  complete -F _fzf_path_completion gunzip
  complete -F _filedir_xspec makeinfo
  complete -F _filedir_xspec okular
  complete -o default -F _complete_groovysh groovysh
  complete -F _ldapsearch ldapsearch
  complete -F _command xargs
  complete -j -P '"%' -S '"' jobs
  complete -o default -F _complete_groovy groovy.sh
  complete -F _filedir_xspec oowriter
  complete -o bashdefault -o default -F _fzf_path_completion emacsclient
  complete -F _cpack cpack
  complete -o default -F _fzf_path_completion tail
  complete -o default -F _longopt unexpand
  complete -o default -F _longopt netstat
  complete -F _docker dexe
  complete -o default -F _fzf_path_completion ls
  complete -F _filedir_xspec epiphany
  complete -o nospace -F __gio gio
  complete -o bashdefault -o default -F _fzf_path_completion nvim
  complete -o dirnames -o nospace -F _fzf_dir_completion pushd
  complete -F _filedir_xspec acroread
  complete -o default -o nospace -v -F _fzf_var_completion unset
  complete -F _postmap postalias
  complete -F _nmap nmap
  complete -o default -F _longopt csplit
  complete -F _known_hosts rsh
  complete -F _filedir_xspec sxemacs
  complete -F _command exec
  complete -F _filedir_xspec aviplay
  complete -F _ldapmodrdn ldapmodrdn
  complete -F _filedir_xspec rgvim
  complete -F _chsh chsh
  complete -F _autoconf autoconf
  complete -o default -F _longopt nm
  complete -o default -F _longopt nl
  complete -o default -F _complete_grape grape.bash
  complete -o nospace -F _user_at_host ytalk
  complete -F _fzf_proc_completion kill
  complete -F _fzf_path_completion java
  complete -F _cmake cmake
  complete -u sux
  complete -F _cancel cancel
  complete -F _filedir_xspec znew
  complete -o default -F _complete_groovydoc groovydoc.sh
  complete -F _id id
  complete -o default -F _longopt paste
  complete -F _ldapaddmodify ldapadd
  complete -F _docker dip
  complete -o bashdefault -F _perldoc perldoc
  complete -F _filedir_xspec kwrite
  complete -F _root_command really
  complete -o default -F _complete_groovyc groovyc.bash
  complete -o bashdefault -o default -o nospace -F __git_wrap__tig_main tig
  complete -F _filedir_xspec firefox
  complete -o bashdefault -o default -F _fzf_path_completion open
  complete -F _ip ip
  complete -o default -F __start_kubectl klc
  complete -F _docker drit
  complete -F _filedir_xspec dvipdfm
  complete -F _filedir_xspec ly2dvi
  complete -F _filedir_xspec oodraw
  complete -F _docker drun
  complete -F _import import
  complete -o default -F __start_kubectl kcswatch
  complete -F _gzip pigz
  complete -o default -F __start_kubectl kln
  complete -F _autoscan autoupdate
  complete -F _known_hosts dig
  complete -o nospace -F _user_at_host talk
  complete -F _filedir_xspec xemacs
  complete -F _docker dls
  complete -o nospace -F _dd dd
  complete -F _jarsigner jarsigner
  complete -F _filedir_xspec kpdf
  complete -F _man apropos
  complete -o default -F _longopt df
  complete -F _command eval
  complete -F _docker di
  complete -F _postsuper postsuper
  complete -F _postconf postconf
  complete -F _filedir_xspec bibtex
  complete -o default -F _pip_completion pip
  complete -F _docker dclr
  complete -F _postfix postfix
  complete -F _fzf_path_completion chown
  complete -F _filedir_xspec netscape
  complete -o default -F _longopt wget
  complete -F _command do
  complete -F _cargo cargo
  complete -F _gradle gradle
  complete -F _pgrep pgrep
  complete -F _filedir_xspec gview
  complete -F _filedir_xspec lzfgrep
  complete -o bashdefault -o default -o nosort -F _fd ffs
  complete -F _filedir_xspec lzless
  complete -o default -F _fzf_path_completion du
  complete -F _renice renice
  complete -F _lsof lsof
  complete -F _docker dv
  complete -F _known_hosts tracepath
  complete -o default -F __start_kubectl kit
  complete -o default -F _fzf_path_completion wc
  complete -F _fzf_path_completion gzip
  complete -F _newgrp newgrp
  complete -o default -F _ansible-galaxy ansible-galaxy
  complete -F _filedir_xspec cdiff
  complete -F _fzf_path_completion emacs
  complete -F _filedir_xspec zipinfo
  complete -F _docker dcleani
  complete -F _filedir_xspec google-chrome
  complete -F _gcc c++
  complete -F _crontab crontab
  complete -F _filedir_xspec rview
  complete -A shopt shopt
  complete -F _docker dcleanc
  complete -F _root_command sudo
  complete -F _killall pkill
  complete -F _fzf_path_completion javac
  complete -F _fzf_path_completion ftp
  complete -o default -F _longopt uname
  complete -o bashdefault -o default -F _rg rg
  complete -F _known_hosts ping
  complete -F _filedir_xspec wine
  complete -F _filedir_xspec galeon
  complete -F _filedir_xspec pdflatex
  complete -F _docker dex
  complete -F _known_hosts rlogin
  complete -o default -F _fzf_opts_completion fzf
  complete -F _filedir_xspec portecle
  complete -o default -F _longopt sha384sum
  complete -o default -F _fzf_path_completion rm
  complete -F _filedir_xspec modplugplay
  complete -F _ri ri
  complete -o default -F _quotaoff quotaoff
  complete -F _filedir_xspec dillo
  complete -F _filedir_xspec fbxine
  complete -F _filedir_xspec lokalize
  complete -F _root_command gksudo
  complete -F _command nice
  complete -o default -F _longopt tr
  complete -o default -F _npm_completion npm
  complete -F _filedir_xspec oocalc
  complete -o default -F _complete_groovyc groovyc.sh
  complete -F _gradle gradlew
  complete -o default -F _longopt sha256sum
  complete -F _root_command gksu
  complete -F _filedir_xspec qiv
  complete -F _chgrp chgrp
  complete -F _filedir_xspec ps2pdfwr
  complete -o default -F _edquota edquota
  complete -F _filedir_xspec harbour
  complete -o bashdefault -o default -F _fzf_path_completion basename
  complete -o default -F _longopt ptx
  complete -F _filedir_xspec dvitype
  complete -o nospace -F __gsettings gsettings
  complete -F _gradle ./gradlew.bat
  complete -F _known_hosts traceroute
  complete -F _fzf_path_completion bzip2
  complete -j -P '"%' -S '"' fg
  complete -o bashdefault -o default -o nosort -F _fd ff
  complete -F _convert convert
  complete -F _filedir_xspec unpigz
  complete -o default -F _complete_groovy groovy
  complete -o bashdefault -o default -o nosort -F _fd fd
  complete -F _filedir_xspec mozilla
  complete -F _filedir_xspec dvips
  complete -o default -F _longopt who
  complete -F _montage montage
  complete -F _complete compgen
  complete -F _filedir_xspec ps2pdf
  complete -F _filedir_xspec gpdf
  complete -F _complete complete
  complete -F _filedir_xspec texi2dvi
  complete -o dirnames -F _umount umount
  complete -F _function function
  complete -o bashdefault -o default -F _fzf_path_completion mvim
  complete -o default -F _fzf_path_completion less
  complete -o default -F _longopt mknod
  complete -F _command padsp
  complete -F _passwd passwd
  complete -F _filedir_xspec kate
  complete -F _pkg_config pkg-config
  complete -o default -F _longopt bison
  complete -F _filedir_xspec mozilla-firefox
  complete -F _filedir_xspec kid3-qt
  complete -o default -F _longopt od
  complete -F _fzf_path_completion bunzip2
  complete -o default -o dirnames -F _mount mount
  complete -F _function declare
  complete -F _filedir_xspec pdftex
  complete -F _ag ag
  complete -o default -o nospace -F _fzf_var_completion export
  complete -F _vipw vigr
  complete -o default -F _ansible-doc ansible-doc
  complete -F _nslookup nslookup
  complete -F _ssh slogin
  complete -o nospace -F _alias alias
  complete -F _fzf_path_completion gvim
  complete -F _filedir_xspec kaffeine
  complete -F _stream stream
  complete -F _docker drdp
  complete -o default -F _complete_grape grape.sh
  complete -F _filedir_xspec mpg123
  complete -F _fzf_path_completion find
  complete -F _filedir_xspec lzegrep
  complete -o default -F _ansible-pull ansible-pull
  complete -o default -F _longopt split
  complete -o bashdefault -o default -F _fzf_path_completion zip
  complete -F _ssh autossh
  complete -F _filedir_xspec xv
  complete -o default -F _longopt fold
  complete -F _known_hosts mtr
  complete -o bashdefault -o default -F _fzf_path_completion ruby
  complete -o nospace -F _fzf_path_completion scp
  complete -F _known_hosts ping6
  complete -F _filedir_xspec timidity
  complete -F _filedir_xspec xdvi
  complete -F _filedir_xspec xfig
  complete -F _filedir_xspec xpdf
  complete -o default -F _longopt indent
  complete -o bashdefault -o default -F _fzf_path_completion chmod
  complete -o nospace -F _user_at_host finger
  complete -o bashdefault -o default -o nospace -F _python_argcomplete pipx
  complete -F _ktutil ktutil
  complete -F _xz xz
  complete -F _filedir_xspec oobase
  complete -F _docker dpa
  complete -F _fzf_path_completion perl
  complete -F _root_command kdesudo
  complete -F _docker drmi
  complete -F _filedir_xspec ogg123
  complete -F _filedir_xspec lzgrep
  complete -u w
  complete -F _filedir_xspec ee
  complete -F _sh sh
  complete -o default -F __start_kubectl kubecolor
  complete -F _docker dps
  complete -F _filedir_xspec gharbour
  complete -u su
  complete -o default -F _complete_grape grape
  complete -o default -F _longopt irb
  complete -F _known_hosts host
  complete -o default -F __start_kubectl k
  complete -o bashdefault -o default -F _fzf_path_completion ex
  complete -o default -F _complete_groovyConsole groovyConsole
  complete -o nospace -F __gdbus gdbus
  complete -F _sysctl sysctl
  complete -F _sqlite3 sqlite3
  complete -o default -F _iconv iconv
  complete -F _command tsocks
  complete -F _docker d
  complete -F _xmllint xmllint
  complete -o default -F _fzf_path_completion diff
  complete -F _ldapwhoami ldapwhoami
  complete -F _bzip2 pbzip2
  complete -F _postmap postmap
  complete -o bashdefault -o filenames -F _pandoc pandoc
  complete -F _filedir_xspec bzcat
  complete -F _filedir_xspec unlzma
  complete -F _filedir_xspec dragon
  complete -F _xzdec xzdec
  complete -o default -F _longopt shar
  complete -F _filedir_xspec ooimpress
  complete -F _cpio cpio
  complete -F _filedir_xspec xanim
  complete -o default -F _complete_groovysh groovysh.bash
  complete -o default -F _ansible-vault ansible-vault
  complete -j -P '"%' -S '"' disown
  complete -F _filedir_xspec xine
  complete -o default -F _longopt bash
  complete -o default -F _longopt md5sum
  complete -o bashdefault -o default -F _fzf_path_completion source
  complete -F _filedir_xspec amaya
  complete -F _filedir_xspec gv
  complete -F _make make
  complete -o default -F _fzf_path_completion curl
  complete -A stopped -P '"%' -S '"' bg
  complete -o default -F __start_kubectl kubeproxy
  complete -F _filedir_xspec kid3
  complete -o nospace -F __gresource gresource
  complete -F _filedir_xspec lilypond
  complete -o default -F _longopt bc
  complete -F _identify identify
  complete -F _filedir_xspec modplug123
  complete -o default -F __start_kubectl k4
  complete -F _pack200 pack200
  complete -A binding bind
  complete -o default -F _setquota setquota
  complete -b builtin
  complete -F _unpack200 unpack200
  complete -o default -F _quotacheck quotacheck
  complete -F _filedir_xspec pbzcat
  complete -F _known_hosts tracepath6
  complete -o default -F _complete_groovyc groovyc
  complete -o default -F _longopt shasum
  complete -F _command ltrace
  complete -o default -F __start_kubectl k3
  complete -F _fzf_path_completion gcc
  complete -F __app gapplication
  complete -o bashdefault -o default -F _fzf_path_completion xdg-open
  complete -o default -F _ansible-playbook ansible-playbook
  complete -u write
  complete -F _known_hosts traceroute6
  complete -F _fzf_path_completion jar
  complete -o default -F _longopt date
  complete -F _gcc gcj
  complete -F _filedir_xspec rgview
  complete -o default -F _fzf_path_completion cat
  complete -o default -F _fzf_path_completion awk
  complete -o default -F _complete_groovyConsole groovyConsole.sh
  complete -o default -F _longopt sha512sum
  complete -F _filedir_xspec unxz
  complete -o default -F _longopt seq
  complete -o default -F _longopt mkdir
  complete -F _filedir_xspec rvim
  complete -o default -F __start_kubectl krn
  complete -o default -F _longopt sha224sum
  complete -A helptopic help
  complete -F _fzf_path_completion sftp
  complete -A setopt set
  complete -o default -F __start_kubectl krc
  complete -F _compare compare
  complete -F _tmux tmux
  complete -F _ssh_copy_id ssh-copy-id
  complete -o default -F _fzf_path_completion sort
  complete -o default -F _longopt pr
  complete -o default -F _longopt colordiff
  complete -o default -F _fzf_path_completion patch
  complete -F _fzf_path_completion g++
  complete -o bashdefault -o default -F _fzf_path_completion python
  complete -F _conjure conjure
  complete -F _ldappasswd ldappasswd
  complete -F _filedir_xspec playmidi
  complete -o default -F __start_kubectl kcEvicted
  complete -o default -F _openssl openssl
  complete -o default -F _longopt fmt
  complete -o default -F _fzf_path_completion sed
  complete -F _tcpdump tcpdump
  complete -F _javadoc javadoc
  complete -F _filedir_xspec lzcat
  complete -o default -F _longopt gperf
  complete -F _command time
  complete -F _filedir_xspec zcat
  complete -F _mogrify mogrify
  complete -F _display display
  complete -F _root_command fakeroot
  complete -o default -F _complete_groovy groovy.bash
  complete -F _filedir_xspec lynx
  complete -u slay
  complete -F _filedir_xspec uncompress
  complete -F _autoreconf autoreconf
  complete -F _filedir_xspec xzcat
  complete -o default -F _fzf_dir_completion rmdir
  complete -F _filedir_xspec slitex
  complete -o bashdefault -o default -F _fzf_opts_completion vim
  complete -F _filedir_xspec aaxine
  complete -F _filedir_xspec advi
  complete -o bashdefault -o default -F _fzf_path_completion more
  complete -o default -F _longopt units
  complete -F _docker dcleanfull
  complete -o default -F _longopt touch
  complete -F _filedir_xspec lzmore
  complete -F _command then
  complete -F _command command
  complete -F _docker dkill
  complete -o default -F __start_kubectl kd
  complete -F _known_hosts fping6
  complete -u runuser
  complete -F _filedir_xspec dvipdf
  complete -o default -F __start_kubectl kc
  complete -F _gradle gradle.bat
  ```
  <!--endsec-->

### patterns in load completion

```bash
# i.e. *git*
$ ls -1 "${BASH_COMPLETION_DIR}"/*git*
/opt/homebrew/etc/bash_completion.d/git-completion.bash
/opt/homebrew/etc/bash_completion.d/git-extras
/opt/homebrew/etc/bash_completion.d/git-lfs
/opt/homebrew/etc/bash_completion.d/git-prompt.sh

# -- solution 1 --
if test -d "${BASH_COMPLETION_DIR}"; then
  if ls "${BASH_COMPLETION_DIR}"/*git*    >/dev/null 2>&1; then source <( cat "${BASH_COMPLETION_DIR}"/*git*    ) ; fi
  if ls "${BASH_COMPLETION_DIR}"/*docker* >/dev/null 2>&1; then source <( cat "${BASH_COMPLETION_DIR}"/*docker* ) ; fi
fi

# -- solution 2 --
# `compgen -G "${pattern}"` == `ls ${pattern}`
for pattern in '*git*' '*docker*'; do
  if compgen -G "${BASH_COMPLETION_DIR}/${pattern}" > /dev/null; then
    for f in "${BASH_COMPLETION_DIR}"/${pattern}; do source "${f}"; done
  fi
done

# --solution 3 --
# using `shopt -s nullglob` to avoid error when no match files
shopt -s nullglob
for script in "${BASH_COMPLETION_DIR}"/{*git*,*docker*}; do
  [[ -f "${script}" ]] && source "${script}"
done
shopt -u nullglob
```

### osx

> [!NOTE|label:references:]
> - [Bash Completion](https://sourabhbajaj.com/mac-setup/BashCompletion/)
> - [How to Enable Bash Completion on macOS](https://tecadmin.net/enable-bash-completion-on-macos/)
> - [iMarslo: brew bash-completion@2](../../osx/osx.md#bash-completion2)

```bash
$ brew install bash-completion
# or
$ brew install bash-completion@2

# -- add to bash_profile --
$ echo '[[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && source "$(brew --prefix)/etc/profile.d/bash_completion.sh"' >> ~/.bash_profile
$ echo 'command -v brew >/dev/null && source "$(brew --prefix git)"/etc/bash_completion.d/git-*.sh || source "$(brew --prefix git)"/etc/bash_completion.d/git-prompt.sh' >> ~/.bash_profile
# or
$ echo "[ -f /usr/local/etc/bash_completion  ] && . /usr/local/etc/bash_completion" >> ~/.bash_profile
$ cat ~/.bash_profile
[ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion
```

- to check link of bash-completion
  ```bash
  $ brew unlink bash-completion --dry-run
  Would remove:
  /usr/local/etc/bash_completion
  /usr/local/etc/bash_completion.d/abook
  /usr/local/etc/bash_completion.d/ant
  ...
  ```

- add more completion files
  ```bash
  $ fd --gen-completions bash | sudo tee $(brew --prefix)/etc/bash_completion.d/fd
  ```

- more
  ```bash
  $ brew search completion
  ==> Formulae
  apm-bash-completion       docker-completion         open-completion           stormssh-completion
  bash-completion ✔         fabric-completion         packer-completion         t-completion
  bash-completion@2         gem-completion            pip-completion            tmuxinator-completion
  boom-completion           gradle-completion ✔       rails-completion          vagrant-completion
  brew-cask-completion ✔    grunt-completion          rake-completion           wp-cli-completion
  bundler-completion        kitchen-completion        ruby-completion           yarn-completion
  cap-completion            launchctl-completion      rustc-completion          zsh-completions
  conda-zsh-completion      maven-completion          sonar-completion
  django-completion         mix-completion            spring-completion

  ==> Casks
  compositor
  ```

### linux

- enable
  ```bash
  if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
  fi
  ```

- add more completion files
  ```bash
  $ fd --gen-completions bash | sudo tee /usr/share/bash-completion/completions/fd
  ```

  - centos
    ```bash
    $ fd --gen-completions bash | sudo tee /etc/bash_completion.d/fd
    ```

### bash alias completion

> [!TIP|label:rerefences:]
> - [* iMarslo: complete-alias](../../virtualization/kubernetes/kubernetes.md#completealias)
> - [_complete_alias](https://unix.stackexchange.com/a/332522/29178) | [cykerway/complete-alias](https://github.com/cykerway/complete-alias)
> - [How to work with `complete -F _start_kubectl` when alias contains `--kubeconfig`?](https://stackoverflow.com/q/78259041/2940319) | [How do I get bash completion for command aliases?](https://unix.stackexchange.com/a/332522/29178)

- download/install
  ```bash
  # download bash_completion.sh for kubectl
  $ curl -fsSL https://github.com/cykerway/complete-alias/raw/master/complete_alias -o ~/.bash_completion.sh
  # or rhel/centos
  $ sudo curl -fsSL https://github.com/marslo/dotfiles/raw/main/.marslo/.completion/complete_alias -o /etc/profile.d/complete_alias.sh
  # or osx
  $ sudo curl -fsSL https://github.com/marslo/dotfiles/raw/main/.marslo/.completion/complete_alias -o $(brew --prefix)/etc/bash_completion.d/complete_alias

  $ sudo chmod +x !$
  ```

- setup for specific alias
  ```bash
  $ echo "complete -F _complete_alias <alias>" >> ~/.bash_profile

  # -- example --
  # i.e.: for kubec* ( kubectl or kubecolor )
  $ complete -o nosort -o bashdefault -o default -F _complete_alias $(alias | sed -rn 's/^alias ([^=]+)=.+kubec.+$/\1/p' | xargs)

  # or
  $ alias k=kubectl
  $ echo "complete -F _complete_alias k" >> ~/.bash_profile
  ```

### git alias completion

> [!TIP|label:see:]
> - [* iMarslo: alias completion](../../devops/git/alias.md#alias-completion)

### troubleshooting

- [`-bash: _compopt_o_filenames: command not found`](../../linux/devenv.md#bash-compoptofilenames-command-not-found)

- [`-bash: [: too many arguments`](../../linux/devenv.md#bash--too-many-arguments)

- `$ ssh bash_completion: _comp_compgen_known_hosts__impl: -F: an empty filename is specified`

  > [!NOTE|label:references:]
  > - [Problem with ssh and bash-completion](https://bbs.archlinux.org/viewtopic.php?pid=858200#p858200)
  > - [Autocomplete server names for SSH and SCP](https://unix.stackexchange.com/a/181603/29178)
  > - [`compgen -A hostname`](https://github.com/scop/bash-completion/blob/main/bash_completion#L2470) | [`__fzf_list_hosts`](https://github.com/junegunn/fzf/blob/master/shell/completion.bash#L436)

  - clear completion
    ```bash
    $ complete -r ssh
    ```

  - or add into `/usr/local/etc/bash_completion.d/ssh` or `$(brew --prefix)/etc/bash_completion.d/ssh`

    <!--sec data-title="ssh completion script" data-id="section3" data-show=true data-collapse=true ces-->
    ```bash
    # https://unix.stackexchange.com/a/181603/29178
    _ssh_hosts()
    {
        local cur prev opts
        COMPREPLY=()
        cur="${COMP_WORDS[COMP_CWORD]}"
        prev="${COMP_WORDS[COMP_CWORD-1]}"
        opts=$(command grep '^Host' ~/.ssh/config ~/.ssh/config.d/* 2>/dev/null | command grep -v '[?*]' | cut -d ' ' -f 2-)

        COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
        return 0
    }

    _ssh()
    {
        local cur prev configfile
        local -a config
        # configfile="$HOME/.ssh/config"

        COMPREPLY=()
        _get_comp_words_by_ref -n : cur prev
        #cur=`_get_cword :`
        #prev=`_get_pword`

        _ssh_suboption_check && return 0

        case $prev in
            -F|-i|-S)
                _filedir
                return 0
                ;;
            -c)
                _ssh_ciphers
                return 0
                ;;
            -m)
                _ssh_macs
                return 0
                ;;
            -l)
                COMPREPLY=( $( compgen -u -- "$cur" ) )
                return 0
                ;;
            -o)
                _ssh_options
                return 0
                ;;
            -w)
                _available_interfaces
                return 0
                ;;
            -b)
                _ssh_bindaddress
                return 0
                ;;
        esac

        if [[ "$cur" == -F* ]]; then
            cur=${cur#-F}
            _filedir
            # Prefix completions with '-F'
            COMPREPLY=( "${COMPREPLY[@]/#/-F}" )
            cur=-F$cur  # Restore cur
        elif [[ "$cur" == -* ]]; then
            COMPREPLY=( $( compgen -W '-1 -2 -4 -6 -A -a -C -f -g -K -k -M \
                -N -n -q -s -T -t -V -v -X -v -Y -y -b -b -c -D -e -F \
                -i -L -l -m -O -o -p -R -S -w' -- "$cur" ) )
        else
            # Search COMP_WORDS for '-F configfile' or '-Fconfigfile' argument
            set -- "${COMP_WORDS[@]}"
            while [ $# -gt 0 ]; do
                if [ "${1:0:2}" = -F ]; then
                    if [ ${#1} -gt 2 ]; then
                        configfile="$(dequote "${1:2}")"
                    else
                        shift
                        [ "$1" ] && configfile="$(dequote "$1")"
                    fi
                    break
                fi
                shift
            done
            # marslo >> disable _known_hosts_real from $configfile
            # marslo >> using self-defined _ssh_hosts function
            # _known_hosts_real -a -F "$configfile" "$cur"
            _ssh_hosts
            if [ $COMP_CWORD -ne 1 ]; then
                _compopt_o_filenames
                COMPREPLY=( "${COMPREPLY[@]}" $( compgen -c -- "$cur" ) )
            fi
        fi

        return 0
    }
    shopt -u hostcomplete && complete -F _ssh ssh slogin autossh

    $ complete -F _ssh ssh
    ```
    <!--endsec-->
