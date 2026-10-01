<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [migrate/install apps](#migrateinstall-apps)
  - [install dmg apps](#install-dmg-apps)
  - [install pkg inside dmg](#install-pkg-inside-dmg)
- [create app](#create-app)
  - [cleanup icon cache and rebuild](#cleanup-icon-cache-and-rebuild)
  - [groovyConsole](#groovyconsole)
  - [python3 IDLE](#python3-idle)
  - [create dmg](#create-dmg)
- [show app info](#show-app-info)
  - [version](#version)
- [check appstore version](#check-appstore-version)
  - [fix false alarm](#fix-false-alarm)
- [input method auto switch](#input-method-auto-switch)
  - [im-select](#im-select)
  - [macime](#macime)
  - [macism](#macism)
  - [switch input method in cursor/vscode](#switch-input-method-in-cursorvscode)
- [others](#others)
  - [notch](#notch)
  - [hammerspoon](#hammerspoon)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## migrate/install apps

> [!NOTE|label:references:]
> ```
> "APP.app" is damaged and can't be opened. You should move it to the Trash
> ```
> root cause:<br>
> `scp -r` flattened the symlinks inside `Sparkle.framework` into duplicate real files (the links are no longer links), which broke the code-signature seal and made Gatekeeper flag the app as "damaged."

```bash
# ── with ditto ────────────────────
# source server
$ ditto -c -k --keepParent ~/Applications/<APP>.app <APP>.zip
# target server
$ scp <source>:/path/to/<APP>.zip .
$ ditto -x -k ./<APP>.zip ~/Applications/

# ── with rsync ────────────────────
$ rsync -a <source>:~/Applications/<APP>.app ~/Applications/

# ── tar + ssh ────────────────────
$ ssh <source> 'cd ~/Application && tar czf - <APP>.app' | tar xzf - -C ~/Applications/
```

```bash
# verify
$ spctl -a -vvv -t exec ~/Applications/<APP>.app
/Users/marslo/Applications/<APP>.app: accepted
source=Notarized Developer ID
origin=Developer ID Application: Lei Liu (CTW3P64G5P)
```

> [!NOTE|label:resource fork, Finder information, or similar detritus not allowed:]
> - error message:
>   ```
>   resource fork, Finder information, or similar detritus not allowed
>   Disallowed xattr com.apple.FinderInfo found on .../Updater.app
>   ```
> - check more [xattr](#xattr)

```bash
# ── error ──────────
$ codesign --verify --deep --strict --verbose=2 ~/Applications/<APP>.app
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/.
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/libswift_Concurrency.dylib
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/libswift_Concurrency.dylib
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Autoupdate
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Autoupdate
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Updater.app
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Installer.xpc
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Downloader.xpc
/Users/marslo/Applications/<APP>.app: resource fork, Finder information, or similar detritus not allowed
In subcomponent: /Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Updater.app
file with invalid attached data: Disallowed xattr com.apple.FinderInfo found on /Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Updater.app

# ── fix ────────────
$ xattr -rd com.apple.FinderInfo ~/Applications/<APP>.app
$ xattr -rd com.apple.ResourceFork ~/Applications/<APP>.app
# or clear all ( recursive + clear )
$ xattr -rc ~/Applications/<APP>.app

# ── result ────────
$ codesign --verify --deep --strict --verbose=2 ~/Applications/<APP>.app
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/.
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/libswift_Concurrency.dylib
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/libswift_Concurrency.dylib
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Downloader.xpc
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Autoupdate
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Autoupdate
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Updater.app
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Downloader.xpc
--prepared:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Installer.xpc
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/XPCServices/Installer.xpc
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/Updater.app
--validated:/Users/marslo/Applications/<APP>.app/Contents/Frameworks/Sparkle.framework/Versions/Current/.
/Users/marslo/Applications/<APP>.app: valid on disk
/Users/marslo/Applications/<APP>.app: satisfies its Designated Requirement
```

### install dmg apps

> [!NOTE|label:referenees:]
> - [install docker desktop on mac](https://docs.docker.com/desktop/install/mac-install/)
> - [MacOS/hdiutil](https://en.wikiversity.org/wiki/MacOS/hdiutil)
> - [hdiutil](https://ss64.com/osx/hdiutil.html)
> - [Can a Mac mount a Debian install CD?](https://unix.stackexchange.com/a/298785/29178)

```bash
$ hdiutil attach ~/Desktop/'Bartender 7.dmg'
$ ditto '/Volumes/Bartender 7/Bartender 7.app' '/Applications/Bartender 7.app'
$ codesign --verify --deep --strict '/Applications/Bartender 7.app' && echo VERIFY_OK
$ xattr -dr com.apple.quarantine '/Applications/Bartender 7.app'

# check info
$ hdiutil info

# detach/unmount
$ hdiutil detach '/Volumes/Bartender 7'
$ hdiutil detach -force '/Volumes/Bartender 7'
$ diskutil unmount '/Volumes/Bartender 7'
```

```bash
$ curl -O https://desktop.docker.com/mac/main/amd64/Docker.dmg

$ sudo hdiutil attach Docker.dmg
$ sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
$ sudo hdiutil detach /Volumes/Docker
```

### install pkg inside dmg
```bash
$ curl -fsSL -O https://download.oracle.com/java/21/latest/jdk-21_macos-x64_bin.dmg
$ hdiutil attach jdk-21_macos-x64_bin.dmg
$ sudo installer -pkg /Volumes/JDK\ 21.0.1/JDK\ 21.0.1.pkg -target /
$ sudo hdiutil detach /Volumes/JDK\ 21.0.1/
```

## create app

> [!NOTE|label:references:]
> - [* splaisan/appify.sh](https://gist.github.com/splaisan/e4ebae891f6f26f86e75)
> - [advorak/appify.sh](https://gist.github.com/advorak/1403124)
> - [pypi: mac-appify](https://pypi.org/project/mac-appify/)
> - [9 Automator Apps You Can Create in Under 5 Minutes](https://www.makeuseof.com/tag/10-automator-applications-create-5-minutes-mac/)
> - [How to create an OSX Application to wrap a call to a shell script?](https://apple.stackexchange.com/a/201309/254265)
> - [CREATE YOUR OWN CUSTOM ICONS IN OS X 10.7.5 OR LATER [UPDATED]](https://eshop.macsales.com/blog/28492-create-your-own-custom-icons-in-10-7-5-or-later/)

### cleanup icon cache and rebuild
```bash
$ sudo rm -rf "/Library/Caches/com.apple.iconservices.store"
$ killall -KILL iconservicesd
$ killall Finder Dock
```

### groovyConsole

> [!NOTE|label:Expectation:]
> case: run `groovyConsole` from Spotlight or Alfred
> - reference:
>   - [Install groovy console on Mac and make it runnable from dock](https://superuser.com/a/1303372/112396)

#### via Automator.app

> [!NOTE|label:tips]
> Automator.app will create whole bunch of necessary files for app. only need to replace the `CFBundleExecutable` filename

- Open **Automator.app** » **New** » **Application**

  ![Automator.app » select Application](../screenshot/osx/runable-app-1.png)

- Select **Run Shell Script** » save to <name>.app with empty shell script

  ![Automator.app » select Run Shell Script](../screenshot/osx/runable-app-2.png)

  ![Automator.app » save to an app](../screenshot/osx/runable-app-3.png)

#### via script

> [!NOTE|label:tips:]
> - get standalone commands for the script
>   ```bash
>   $ ps aux | grep groovyConsole | grep -v grep
>   marslo           63030   0.0  1.9 42636292 310724 s008  S+    2:06PM   0:12.48 /usr/local/opt/openjdk/bin/java -Dsun.awt.keepWorkingSetOnMinimize=true -Xdock:name=GroovyConsole -Xdock:icon=/usr/local/opt/groovy/libexec/lib/groovy.icns -classpath /usr/local/opt/groovy/libexec/lib/groovy-4.0.13.jar -Dscript.name=/usr/local/opt/groovy/libexec/bin/groovyConsole -Dprogram.name=groovyConsole -Dgroovy.starter.conf=/usr/local/opt/groovy/libexec/conf/groovy-starter.conf -Dgroovy.home=/usr/local/opt/groovy/libexec -Dtools.jar=/usr/local/opt/openjdk/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter --main groovy.console.ui.Console --conf /usr/local/opt/groovy/libexec/conf/groovy-starter.conf --classpath .:/usr/local/opt/openjdk/lib/tools.jar:/usr/local/opt/openjdk/lib/dt.jar:/usr/local/opt/groovy/libexec/lib:.
>   ```
>
>   ==> which would be:
>   ```bash
>   /usr/local/opt/openjdk/bin/java \
>        -Dsun.awt.keepWorkingSetOnMinimize=true \
>        -Xdock:name=GroovyConsole \
>        -Xdock:icon=/usr/local/opt/groovy/libexec/lib/groovy.icns \
>        -classpath /usr/local/opt/groovy/libexec/lib/groovy-4.0.13.jar \
>        -Dscript.name=/usr/local/opt/groovy/libexec/bin/groovyConsole \
>        -Dprogram.name=groovyConsole \
>        -Dgroovy.starter.conf=/usr/local/opt/groovy/libexec/conf/groovy-starter.conf \
>        -Dgroovy.home=/usr/local/opt/groovy/libexec \
>        -Dtools.jar=/usr/local/opt/openjdk/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \
>        --main groovy.console.ui.Console \
>        --conf /usr/local/opt/groovy/libexec/conf/groovy-starter.conf \
>        --classpath .:/usr/local/opt/openjdk/lib/tools.jar:/usr/local/opt/openjdk/lib/dt.jar:/usr/local/opt/groovy/libexec/lib:.
>   ```
>
>   <!--sec data-title="older version" data-id="section0" data-show=true data-collapse=true ces-->
>   ```bash
>   $ ps aux | grep groovyConsole | grep -v grep
>   marslo           50495   0.0  3.4 11683536 577828   ??  S     5:50PM   0:15.85 /Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/bin/java -Xdock:name=GroovyConsole -Xdock:icon=/usr/local/opt/groovy/libexec/lib/groovy.icns -Dgroovy.jaxb=jaxb -classpath /usr/local/opt/groovy/libexec/lib/groovy-3.0.6.jar -Dscript.name=/usr/local/opt/groovy/libexec/bin/groovyConsole -Dprogram.name=groovyConsole -Dgroovy.starter.conf=/usr/local/opt/groovy/libexec/conf/groovy-starter.conf -Dgroovy.home=/usr/local/opt/groovy/libexec -Dtools.jar=/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter --main groovy.console.ui.Console --conf /usr/local/opt/groovy/libexec/conf/groovy-starter.conf --classpath .:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/dt.jar:/usr/local/opt/groovy/libexec/lib:.
>   ```
>
>   ==> which would be:
>   ```bash
>   /Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/bin/java \
>           -Xdock:name=GroovyConsole \
>           -Xdock:icon=/usr/local/opt/groovy/libexec/lib/groovy.icns \
>           -Dgroovy.jaxb=jaxb \
>           -classpath /usr/local/opt/groovy/libexec/lib/groovy-3.0.6.jar \
>           -Dscript.name=/usr/local/opt/groovy/libexec/bin/groovyConsole \
>           -Dprogram.name=groovyConsole \
>           -Dgroovy.starter.conf=/usr/local/opt/groovy/libexec/conf/groovy-starter.conf \
>           -Dgroovy.home=/usr/local/opt/groovy/libexec \
>           -Dtools.jar=/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \
>           --main groovy.console.ui.Console \
>           --conf /usr/local/opt/groovy/libexec/conf/groovy-starter.conf \
>           --classpath .:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/dt.jar:/usr/local/opt/groovy/libexec/lib:.
>   ```
>   <!--endsec-->


{% hint style='tip' %}
> register openjdk:
> ```bash
> # -- -v 21 --
> $ brew install openjdk@21
> $ sudo ln -sfn "$(brew --prefix openjdk@21)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-21.jdk
>
> # -- -v 24 --
> $ brew install openjdk
> $ sudo ln -sfn "$(brew --prefix openjdk)/libexec/openjdk.jdk" /Library/Java/JavaVirtualMachines/openjdk-24.jdk
>
> # check
> $ /usr/libexec/java_home -V
> ```
{% endhint %}

```bash
$ cp /usr/local/opt/groovy/libexec/lib/groovy.icns groovyConsole.app/Contents/Resources

$ cat > groovyConsole.app/Contents/MacOS/groovyConsole << EOF
#!/usr/bin/env bash

JAVA_HOME="$(/usr/libexec/java_home -v 21)"
GROOVY_HOME="$(/usr/local/bin/brew --prefix groovy)/libexec"
GROOVY_VERSION="$(/usr/bin/sed -rn 's/^[^:]+:[[:blank:]]?([[:digit:].]+)[[:blank:]]?.+$/\1/p' < <(${GROOVY_HOME}/bin/groovy --version))"

"${JAVA_HOME}"/bin/java \
  -Dsun.awt.keepWorkingSetOnMinimize=true \
  -Xdock:name=GroovyConsole \
  -Xdock:icon="${GROOVY_HOME}"/lib/groovy.icns \
  -classpath "${GROOVY_HOME}"/lib/groovy-"${GROOVY_VERSION}".jar \
  -Dscript.name="${GROOVY_HOME}"/bin/groovyConsole \
  -Dprogram.name=groovyConsole \
  -Dgroovy.starter.conf="${GROOVY_HOME}"/conf/groovy-starter.conf \
  -Dgroovy.home="${GROOVY_HOME}" \
  -Dtools.jar="${JAVA_HOME}"/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \
  --main groovy.console.ui.Console \
  --conf "${GROOVY_HOME}"/conf/groovy-starter.conf \
  --classpath .:"${JAVA_HOME}"/lib/tools.jar:"${JAVA_HOME}"/lib/dt.jar:"${GROOVY_HOME}"/lib
EOF
```

```bash
# or HOMEBREW_PREFIX='/opt/homebrew'
#!/usr/bin/env bash

HOMEBREW_PREFIX='/opt/homebrew'
JAVA_HOME="${HOMEBREW_PREFIX}"/opt/openjdk
export JAVA_HOME
GROOVY_HOME="$("${HOMEBREW_PREFIX}"/bin/brew --prefix groovy)/libexec"
GROOVY_VERSION="$(/usr/bin/sed -rn 's/^[^:]+:[[:blank:]]?([[:digit:].]+)[[:blank:]]?.+$/\1/p' < <("${GROOVY_HOME}"/bin/groovy --version))"
"${JAVA_HOME}"/bin/java \
    -Dsun.awt.keepWorkingSetOnMinimize=true \
    -Xdock:name=GroovyConsole \
    -Xdock:icon="${GROOVY_HOME}"/lib/groovy.icns \
    -classpath "${GROOVY_HOME}"/lib/groovy-"${GROOVY_VERSION}".jar \
    -Dscript.name="${GROOVY_HOME}"/bin/groovyConsole \
    -Dprogram.name=groovyConsole \
    -Dgroovy.starter.conf="${GROOVY_HOME}"/conf/groovy-starter.conf \
    -Dgroovy.home="${GROOVY_HOME}" \
    -Dtools.jar="${JAVA_HOME}"/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \
    --main groovy.console.ui.Console \
    --conf "${GROOVY_HOME}"/conf/groovy-starter.conf \
    --classpath .:"${JAVA_HOME}"/lib/tools.jar:"${JAVA_HOME}"/lib/dt.jar:"${GROOVY_HOME}"/lib:.

# vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh:
```

```bash
$ chmod +x groovyConsole.app/Contents/MacOS/groovyConsole
$ ls -1 groovyConsole.app/Contents/MacOS/
Automator Application Stub                    # ignore it
groovyConsole                                 # ╮ <key>CFBundleExecutable</key>
                                              # ╯ <string>groovyConsole</string>

$ mv groovyConsole.app/ /Applications/
```

<!--sec data-title="older version" data-id="section1" data-show=true data-collapse=true ces-->
```bash
$ touch groovyConsole.app/Contents/MacOS/groovyConsole
$ cat > groovyConsole.app/Contents/MacOS/groovyConsole << EOF
  -> #!/usr/bin/env bash
  ->
  -> JAVA_HOME="$(/usr/local/bin/brew --prefix java)"
  -> # JAVA_HOME="$(/usr/local/bin/brew --prefix openjdk@17)"
  -> GROOVY_VERSION="$(/usr/local/bin/groovy --version | /usr/local/opt/gnu-sed/libexec/gnubin/sed -rn 's/^[^:]+:\s*([0-9\.]+).*$/\1/p')"
  -> GROOVY_HOME="$(/usr/local/bin/brew --prefix groovy)/libexec"
  ->
  -> "${JAVA_HOME}"/bin/java \
  ->     -Dsun.awt.keepWorkingSetOnMinimize=true \
  ->     -Xdock:name=GroovyConsole \
  ->     -Xdock:icon="${GROOVY_HOME}"/lib/groovy.icns \
  ->     -classpath "${GROOVY_HOME}"/lib/groovy-"${GROOVY_VERSION}".jar \
  ->     -Dscript.name="${GROOVY_HOME}"/bin/groovyConsole \
  ->     -Dprogram.name=groovyConsole \
  ->     -Dgroovy.starter.conf="${GROOVY_HOME}"/conf/groovy-starter.conf \
  ->     -Dgroovy.home="${GROOVY_HOME}" \
  ->     -Dtools.jar="${JAVA_HOME}"/lib/tools.jar \
  ->     org.codehaus.groovy.tools.GroovyStarter \
  ->         --main groovy.console.ui.Console \
  ->         --conf "${GROOVY_HOME}"/conf/groovy-starter.conf \
  ->         --classpath .:"${JAVA_HOME}"/lib/tools.jar:"${JAVA_HOME}"/lib/dt.jar:"${GROOVY_HOME}"/lib:.
  -> EOF

# or
$ cat > groovyConsole.app/Contents/MacOS/groovyConsole << EOF
  -> #!/bin/bash
  -> /Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/bin/java \\
  ->         -Xdock:name=GroovyConsole \\
  ->         -Xdock:icon=/usr/local/opt/groovy/libexec/lib/groovy.icns \\
  ->         -Dgroovy.jaxb=jaxb \\
  ->         -classpath /usr/local/opt/groovy/libexec/lib/groovy-3.0.6.jar \\
  ->         -Dscript.name=/usr/local/opt/groovy/libexec/bin/groovyConsole \\
  ->         -Dprogram.name=groovyConsole \\
  ->         -Dgroovy.starter.conf=/usr/local/opt/groovy/libexec/conf/groovy-starter.conf \\
  ->         -Dgroovy.home=/usr/local/opt/groovy/libexec \\
  ->         -Dtools.jar=/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \\
  ->         --main groovy.console.ui.Console \\
  ->         --conf /usr/local/opt/groovy/libexec/conf/groovy-starter.conf \\
  ->         --classpath .:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/tools.jar:/Library/Java/JavaVirtualMachines/jdk1.8.0_211.jdk/Contents/Home/lib/dt.jar:/usr/local/opt/groovy/libexec/lib:.
  -> EOF

$ chmod +x groovyConsole.app/Contents/MacOS/groovyConsole
```
<!--endsec-->

try validate via execute `groovyConsole.app/Contents/MacOS/groovyConsole` directly. to see whether if the groovyConsole will be opened.

![Automator.app » show in Alfred](../screenshot/osx/runable-app-4.png)


#### modify `Info.plist`

> [!NOTE|label:original]
> ```bash
> <key>CFBundleExecutable</key>
> <string>Application Stub</string>
> <key>CFBundleIconFile</key>
> <string>AutomatorApplet</string>
> <key>CFBundleIdentifier</key>
> <string>com.apple.automator.groovyConsole</string>
> ```

```bash
$ vim groovyConsole.app/Contents/Info.plist
...
<key>CFBundleExecutable</key>
<string>groovyConsole</string>           « the script name to MacOS/groovyConsole
<key>CFBundleIconFile</key>
<string>groovy</string>                  « for icon in Resources/groovy.icns
<key>CFBundleIdentifier</key>
<string>com.apple.groovyConsole</string>
...
```

#### additional
- set the icon for new app

  > [!NOTE|label:optional]

  ```bash
  $ cp /usr/local/opt/groovy/libexec/lib/groovy.icns groovyConsole.app/Contents/Resources

  # or
  $ ln -sf /usr/local/opt/groovy/libexec/lib/groovy.icns groovyConsole.app/Contents/Resources/groovy.icns
  ```

- create dmg
  ```bash
  $ hdiutil create -volname 'groovyConsole' \
                   -srcfolder ~/Desktop/groovyConsole.app \
                   -ov groovyConsole.dmg
  .......................
  created: /Users/marslo/Desktop/groovyConsole.dmg
  ```

### python3 IDLE

> [!NOTE|label:references:]
> - `python-tk@version` is necessary for `IDLE` to work
>   ```bash
>   $ brew install python-tk@3.11
>   $ brew install python-tk@3.12
>   $ brew install python-tk@3.13
>   $ brew install python-tk@3.14
>   ```

#### via automator.app
- script

  > [!TIP|label:tips:]
  > - the IDLE python version is based on which python is linked to `/usr/local/bin/python3`

  ```bash
  #!/usr/bin/env bash

  set -euo pipefail

  die() { printf >&2 ">> ERROR [IDLE] %s\n" "$*"; exit 1; }

  HOMEBREW_PREFIX="/opt/homebrew"
  PYTHON_SHORT_VERSION=$(/usr/bin/sed -rn 's/^([^[0-9]+)([0-9]+\.[0-9]+).*$/\2/p' < <("${HOMEBREW_PREFIX}"/bin/python3 --version) )
  PYTHON_TK_HOME="${HOMEBREW_PREFIX}/opt/python-tk@${PYTHON_SHORT_VERSION}"
  TCLTK_HOME="${HOMEBREW_PREFIX}/opt/tcl-tk"

  test -d "${PYTHON_TK_HOME}" || die "The python-tk@${PYTHON_SHORT_VERSION} formula is not installed. Please install it with '\$ brew install python-tk@${PYTHON_SHORT_VERSION}' and try again."
  test -f "${TCLTK_HOME}/lib/pkgconfig/tk.pc" || die "The tcl-tk formula is not installed. Please install it with '\$ brew install tcl-tk' and try again."
  command -v "${TCLTK_HOME}/bin/wish" || die "wish not found under ${TCLTK_PREFIX}/bin, please check your tcl-tk installation."

  /usr/bin/open "$("${HOMEBREW_PREFIX}"/bin/brew --prefix python@"${PYTHON_SHORT_VERSION}")"/IDLE\ 3.app

  # vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
  ```

  ![script in automator.app](../screenshot/osx/pythonIdle-automator.png)

- icon
  ```bash
  $ PYTHON_SHORT_VERSION=$(/usr/bin/sed -rn 's/^([^[0-9]+)([0-9]+\.[0-9]+).*$/\2/p' < <("${HOMEBREW_PREFIX}"/bin/python3 --version) )
  $ cp "$("${HOMEBREW_PREFIX}"/bin/brew --prefix python@${PYTHON_SHORT_VERSION})"/IDLE\ 3.app/Contents/Resources/IDLE.icns Python3\ IDLE.app/Contents/Resources/

  # modify "Python3 IDLE.app/Contents/Info.plist"
  $ PLIST="Python3 IDLE.app/Contents/Info.plist"
  $ /usr/libexec/PlistBuddy -c 'Delete :CFBundleIconName' "${PLIST}" 2>/dev/null || true
  $ /usr/libexec/PlistBuddy -c 'Set :CFBundleIconFile IDLE' "${PLIST}"
  # -- verify --
  $ /usr/libexec/PlistBuddy -c 'Print :CFBundleIconFile' "${PLIST}" 2>/dev/null
  IDLE
  $ plutil -p "${PLIST}" | rg 'CFBundleIcon(File|Name)'
  "CFBundleIconFile" => "IDLE"

  # -- result --
  <key>CFBundleIconFile</key>
  <string>IDLE</string>
  # -- original --
  <key>CFBundleIconFile</key>
  <string>ApplicationStub</string>

  # refresh icon cache
  $ /usr/bin/touch Python3\ IDLE.app
  ```

  ```bash
  # others
  $ cat IDLE.app/Contents/Info.plist
  <key>CFBundleGetInfoString</key>
  <string>3.11.6, © 2001-2023 Python Software Foundation</string>
  <key>CFBundleIconFile</key>
  <string>IDLE.icns</string>
  <key>CFBundleIdentifier</key>
  <string>org.python.IDLE</string>
  ```

#### via appify

> [!NOTE|label:references:]
> - [* splaisan/appify.sh](https://gist.github.com/splaisan/e4ebae891f6f26f86e75)
> - [advorak/appify.sh](https://gist.github.com/advorak/1403124)

- shell script
  ```bash
  $ cat > ~/IDLE << EOF
  #!/usr/bin/env bash

  set -euo pipefail

  die() { printf >&2 ">> ERROR [IDLE] %s\n" "$*"; exit 1; }

  HOMEBREW_PREFIX="/opt/homebrew"
  PYTHON_SHORT_VERSION=$(/usr/bin/sed -rn 's/^([^[0-9]+)([0-9]+\.[0-9]+).*$/\2/p' < <("${HOMEBREW_PREFIX}"/bin/python3 --version) )
  PYTHON_TK_HOME="${HOMEBREW_PREFIX}/opt/python-tk@${PYTHON_SHORT_VERSION}"
  TCLTK_HOME="${HOMEBREW_PREFIX}/opt/tcl-tk"

  test -d "${PYTHON_TK_HOME}" || die "The python-tk@${PYTHON_SHORT_VERSION} formula is not installed. Please install it with '\$ brew install python-tk@${PYTHON_SHORT_VERSION}' and try again."
  test -f "${TCLTK_HOME}/lib/pkgconfig/tk.pc" || die "The tcl-tk formula is not installed. Please install it with '\$ brew install tcl-tk' and try again."
  command -v "${TCLTK_HOME}/bin/wish" || die "wish not found under ${TCLTK_PREFIX}/bin, please check your tcl-tk installation."

  /usr/bin/open "$("${HOMEBREW_PREFIX}"/bin/brew --prefix python@"${PYTHON_SHORT_VERSION}")"/IDLE\ 3.app

  # vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh
  EOF
  ```

- create app via appify
  ```bash
  $ icon=$(brew --prefix python@3.12)/IDLE\ 3.app/Contents/Resources/IDLE.icns
  $ ./appify.sh -i ${icon} -s IDLE -n IDLE
  $ mv IDLE.app /Applications
  ```

  ![IDLE.app](../screenshot/osx/pythonIdle-runable.png)

- more: Info.plist

  <!--sec data-title="macOS 15.x" data-id="section2" data-show=true data-collapse=true ces-->
  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>English</string>
    <key>CFBundleExecutable</key>
    <string>IDLE</string>
    <key>CFBundleIconFile</key>
    <string>IDLE</string>
    <key>CFBundleIdentifier</key>
    <string>com.apple.automator.Python3-IDLE</string>
    <key>CFBundleName</key>
    <string>Python3 IDLE</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
  </dict>
  </plist>
  ```
  <!--endsec-->

  <!--sec data-title="macOS 14.x" data-id="section3" data-show=true data-collapse=true ces-->
  ```xml
  <?xml version="1.0" encoding="UTF-8"?>
  <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
  <plist version="1.0">
  <dict>
    <key>CFBundleExecutable</key>
    <string>IDLE</string>
    <key>CFBundleGetInfoString</key>
    <string>IDLE</string>
    <key>CFBundleIconFile</key>
    <string>IDLE</string>
    <key>CFBundleName</key>
    <string>IDLE</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleIdentifier</key>
    <string>org.python.IDLE</string>
  </dict>
  </plist>
  ```
  <!--endsec-->


### [create dmg](#create-image)
```bash
$ hdiutil create -volname IDLE -srcfolder ~/Desktop/IDLE.app -ov IDLE.dmg
....
created: /Users/marslo/Desktop/IDLE.dmg

# -- or --
$ hdiutil create -volname 'Python3 IDLE' -srcfolder "$HOME/Desktop/Python3 IDLE.app" -ov "Python3 IDLE.dmg"
```

```bash
# change default python3
$ ln -sf /usr/local/bin/python3.12        /usr/local/bin/python3
$ ln -sf /usr/local/bin/python3.12-config /usr/local/bin/python3-config

# or
$ brew unlink python@3.11
$ brew unlink python@3.12
$ brew link --force python@3.12

# or
$ brew link --force --overwrite python@3.12
```

## show app info

### version
```bash
# mdls
$ mdls -name kMDItemVersion /Applications/iTerm.app
kMDItemVersion = "3.6.10"
$ mdls -name kMDItemVersion ~/Applications/iTerm.app
kMDItemVersion = "3.7.20260512-nightly"

# CFBundleShortVersionString
$ defaults read ~/Applications/iTerm.app/Contents/Info.plist CFBundleShortVersionString
3.7.20260512-nightly
$ defaults read /Applications/iTerm.app/Contents/Info.plist CFBundleShortVersionString
3.6.10

# lsappinfo - current running app
$ lsappinfo info com.googlecode.iterm2
"iTerm2" ASN:0x0-0xa30a3: (in front)
    bundleID="com.googlecode.iterm2"
    bundle path="/Users/marslo/Applications/iTerm.app"
    executable path="/Users/marslo/Applications/iTerm.app/Contents/MacOS/iTerm2"
    pid = 5064 type="Foreground" flavor=3 Version="3.7.20260511-nightly" fileType="APPL" creator="ITRM" Arch=ARM64
    childASNs: ASN:0x0-0xa90a9:
    coalition: 1682
    parentASN="Alfred" ASN:0x0-0x84084:
    launch time =  2026/05/12 15:10:18 ( 2 hours, 50 minutes, 38.7915 seconds ago )
    checkin time = 2026/05/12 15:10:18 ( 2 hours, 50 minutes, 38.4025 seconds ago )
    launch to checkin time: 0.389042 seconds

# osascript - current
$ osascript -e 'get version of application id "com.googlecode.iterm2"'
3.7.20260512-nightly
```


## check appstore version

```bash
app="$HOME/Applications/Bob.app"
bundleId=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "${app}/Contents/Info.plist")
trackId=$(curl -s "https://itunes.apple.com/lookup?bundleId=${bundleId}&country=cn" | jq -r '.results[0].trackId')
latestVersion=$(curl -s "https://itunes.apple.com/lookup?id=${trackId}&country=cn" | jq -r '.results[0].version')

# or search via bundleId
trackId=$(curl -s "https://itunes.apple.com/lookup?bundleId=${bundleId}&country=cn" | jq -r '.results[] | select(.kind=="mac-software") | .version')
```

```bash
app='/Applications/iShot Pro.app'
bundleId=$(/usr/libexec/PlistBuddy -c 'Print :CFBundleIdentifier' "${app}/Contents/Info.plist")
local="$(/usr/libexec/PlistBuddy -c 'Print :CFBundleShortVersionString' "${app}/Contents/Info.plist" 2>/dev/null)"
online="$(curl -fsG 'https://itunes.apple.com/lookup' --data-urlencode "bundleId=${bundleId}" --data-urlencode 'country=cn' | plutil -extract results.0.version raw -o - - )"
echo "${bundleId}: local=${local}  online=${online}"
# cn.better365.iShotPro: local=2.6.8  online=2.6.8
```

### fix false alarm

```bash
$ db="${HOME}/Library/Caches/com.apple.appstoreagent/storeSystem.db"
$ sqlite3 "${db}" "SELECT bundle_id, update_state, store_software_version_id FROM mapi_app_update;"
# ╭───────────────────────┬──────────────┬──────────────────────╮
# │       bundle_id       │ update_state │ store_software_ve... │
# ╞═══════════════════════╪══════════════╪══════════════════════╡
# │ cn.better365.iShotPro │            1 │            888549430 │
# │ com.moleskine.overlap │            0 │            889377307 │
# ╰───────────────────────┴──────────────┴──────────────────────╯

# or
$ mapfile -t staleIds < <( sqlite3 "${db}" "SELECT bundle_id FROM mapi_app_update WHERE update_state=1;" )
$ printf "%s\n" "${staleIds[@]}"
cn.better365.iShotPro
```

```bash
$ bundleId='cn.better365.iShotPro'
$ db="$HOME/Library/Caches/com.apple.appstoreagent/storeSystem.db"
$ killall appstored appstoreagent 2>/dev/null

# ── force reset with bundle_id ──
$ sqlite3  "UPDATE mapi_app_update SET update_state=0 WHERE bundle_id='${bundleId}';"
# ── force reset all ──
$ for bundleId in "${staleIds[@]}"; do
    sqlite3 "${db}" "UPDATE mapi_app_update SET update_state=0 WHERE bundle_id='${bundleId}';"
  done
```

```bash
# clean the badge count
$ defaults write com.apple.appstored BadgeCount -int 0
$ defaults delete com.apple.appstored BadgeCount 2>/dev/null
killall appstored appstoreagent 2>/dev/null
```


## input method auto switch

### im-select
```bash
$ brew tap daipeihust/tap
$ brew install im-select

# or
$ curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh

# or compile from source
$ git clone https://github.com/laishulu/macism /tmp/macism
$ cd /tmp/macism && swiftc macism.swift -o macism
$ sudo mv macism /usr/local/bin/
```

### macime
```bash
$ brew tap riodelphino/tap
$ brew install macime
```

```bash
# list all input method
$ macime list
com.apple.keylayout.US
com.apple.CharacterPaletteIM
com.apple.inputmethod.ironwood
com.sogou.inputmethod.sogou.pinyin
com.sogou.inputmethod.sogou

# get current input method
$ macime get
com.sogou.inputmethod.sogou.pinyin

# switch input method
$ macime set com.apple.keylayout.US
```

```vim
" autocmd for force change input method
if executable('macime')
  let g:ime_en = 'com.apple.keylayout.US'
  augroup Ime_Switch
    autocmd!
    autocmd FocusGained  * call system( 'macime set ' . g:ime_en )
    autocmd InsertLeave  * call system( 'macime set ' . g:ime_en )
    autocmd CmdlineLeave * call system( 'macime set ' . g:ime_en )
  augroup END
endif

" --- or ---
if executable('macime')
  let g:ime_en = 'com.apple.keylayout.US'
  augroup Ime_Switch
    autocmd!
    autocmd WinEnter     * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
    autocmd InsertLeave  * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
    autocmd CmdlineLeave * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
  augroup END
endif
```

### macism
```bash
$ brew tap laishulu/homebrew
$ brew install macism
```

### switch input method in cursor/vscode
```lua
local MACIME  = "/opt/homebrew/bin/macime"
local ENGLISH = "com.apple.keylayout.US"

-- brew tap riodelphino/tap && brew install macime
local function switchToEnglish()
  hs.execute(MACIME .. " set " .. ENGLISH)
end

local function getFocusedDescription(app)
  local el = hs.axuielement.applicationElement(app):attributeValue("AXFocusedUIElement")
  if not el then return nil end
  return el:attributeValue("AXRoleDescription")
end

-- watch focus changes within Cursor
local observer

local function startObserver()
  local app = hs.application.get("Cursor")
  if not app then return end

  local axApp = hs.axuielement.applicationElement(app)
  observer = hs.axuielement.observer.new(app:pid())
  observer:addWatcher(axApp, "AXFocusedUIElementChanged")
  observer:callback(function()
    local a = hs.application.get("Cursor")
    if not a then return end
    local desc = getFocusedDescription(a)
    if desc == "editor" then
      switchToEnglish()
    end
  end)
  observer:start()
end

-- start observer when Cursor launches or is activated
hs.application.watcher.new(function(name, event, _)
  if name ~= "Cursor" then return end
  if event == hs.application.watcher.launched
  or event == hs.application.watcher.activated then
    startObserver()
  end
  if event == hs.application.watcher.terminated then
    if observer then observer:stop(); observer = nil end
  end
end):start()

-- handle already-running Cursor
startObserver()
```

## others

### notch

> [!TIP|label:references:]
> - [MacBook 刘海（Notch）增强工具推荐](https://utgd.net/article/20546)
> - [* How to fix Mac menu bar icons hidden by the MacBook notch](https://www.jessesquires.com/blog/2023/12/16/macbook-notch-and-menu-bar-fixes/)
> - [PSA: Reduce your menu bar spacing to fit more items](https://www.reddit.com/r/MacOS/comments/1dfu8w0/psa_reduce_your_menu_bar_spacing_to_fit_more_items/)
> - [Change the Menu Bar Item Spacing](https://www.reddit.com/r/MacOS/comments/vx7wb1/change_the_menu_bar_item_spacing/)
> - [2021 Macbook Pro 16" / 14" Menu Bar Size Limitation (Result of Display Notch)](https://discussions.apple.com/thread/253299524?sortBy=rank)


### hammerspoon

> [!NOTE|label:references:]
> - [Hammerspoon](https://www.hammerspoon.org/)

#### to show debug info
```lua
-- ~/.hammerspoon/init.lua
local function logFocused()
  local app = hs.application.get("Cursor")
  if not app then print("Cursor not running"); return end
  local focused = hs.axuielement.applicationElement(app):attributeValue("AXFocusedUIElement")
  if not focused then print("no focused element"); return end
  print("=== focused element ===")
  print("role:        " .. (focused:attributeValue("AXRole")            or "nil"))
  print("subrole:     " .. (focused:attributeValue("AXSubrole")         or "nil"))
  print("description: " .. (focused:attributeValue("AXRoleDescription") or "nil"))
  print("title:       " .. (focused:attributeValue("AXTitle")           or "nil"))
  print("identifier:  " .. (focused:attributeValue("AXIdentifier")      or "nil"))
  print("label:       " .. (focused:attributeValue("AXLabel")           or "nil"))
  print("=======================")
end

-- ctrl + F1: log focused element
hs.hotkey.bind({"ctrl"}, "f1", logFocused)
```
