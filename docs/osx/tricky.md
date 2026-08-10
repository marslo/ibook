<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get file metadata](#get-file-metadata)
  - [mdls - metadata list](#mdls---metadata-list)
  - [xattr](#xattr)
  - [exiftool](#exiftool)
  - [sips - images](#sips---images)
  - [identify - images](#identify---images)
- [migrate apps](#migrate-apps)
- [copy path](#copy-path)
  - [copy STDOUT into clipboard](#copy-stdout-into-clipboard)
  - [copy path from finder](#copy-path-from-finder)
- [input method auto switch](#input-method-auto-switch)
  - [im-select](#im-select)
  - [macime](#macime)
  - [macism](#macism)
- [create app](#create-app)
  - [cleanup icon cache and rebuild](#cleanup-icon-cache-and-rebuild)
  - [groovyConsole](#groovyconsole)
  - [python3 IDLE](#python3-idle)
  - [create dmg](#create-dmg)
- [reset file associations](#reset-file-associations)
- [add snippets for input](#add-snippets-for-input)
  - [enable Technical Symbols](#enable-technical-symbols)
  - [and snippets](#and-snippets)
  - [finally](#finally)
  - [unicode hex input](#unicode-hex-input)
- [others](#others)
  - [install font](#install-font)
  - [create image](#create-image)
  - [extract](#extract)
  - [disk](#disk)
  - [modify font in plist](#modify-font-in-plist)
  - [show process details](#show-process-details)
  - [`/usr/bin/xattr`](#usrbinxattr)
  - [hammerspoon](#hammerspoon)
- [tips](#tips)
  - [shutdown mac via commands](#shutdown-mac-via-commands)
  - [alert on mac when server is up](#alert-on-mac-when-server-is-up)
  - [turn off the screen without sleeping](#turn-off-the-screen-without-sleeping)
  - [disable startup music](#disable-startup-music)
  - [3D lock screen](#3d-lock-screen)
  - [take screenshot after 3 sec](#take-screenshot-after-3-sec)
  - [setup welcome text in login screen](#setup-welcome-text-in-login-screen)
  - [show message on desktop](#show-message-on-desktop)
  - [launch iOS simulator](#launch-ios-simulator)
  - [show startup launch apps](#show-startup-launch-apps)
  - [check detail diskage usage](#check-detail-diskage-usage)
  - [check User-level TCC permissions database](#check-user-level-tcc-permissions-database)
- [notch](#notch)
  - [reduce the menu bar item spacing](#reduce-the-menu-bar-item-spacing)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references]
> - [tips and tricks](https://gist.github.com/dive/3070807)

## get file metadata

> [!NOTE|label:references:]
> - [Terminal command to get all of a file's metadata?](https://apple.stackexchange.com/a/298974/254265)

### mdls - metadata list

```bash
$ mdls nvim-macos-arm64.tar.gz
_kMDItemDisplayNameWithExtensions  = "nvim-macos-arm64.tar.gz"
kMDItemContentCreationDate         = 2024-12-07 05:41:06 +0000
kMDItemContentCreationDate_Ranking = 2024-12-07 00:00:00 +0000
kMDItemContentModificationDate     = 2024-12-07 05:41:07 +0000
kMDItemContentType                 = "org.gnu.gnu-zip-archive"
kMDItemContentTypeTree             = (
    "org.gnu.gnu-zip-archive",
    "public.data",
    "public.item",
    "public.archive"
)
kMDItemDateAdded                   = 2024-12-07 05:41:08 +0000
kMDItemDisplayName                 = "nvim-macos-arm64.tar.gz"
kMDItemDocumentIdentifier          = 0
kMDItemFSContentChangeDate         = 2024-12-07 05:41:07 +0000
kMDItemFSCreationDate              = 2024-12-07 05:41:06 +0000
kMDItemFSCreatorCode               = ""
kMDItemFSFinderFlags               = 0
kMDItemFSHasCustomIcon             = (null)
kMDItemFSInvisible                 = 0
kMDItemFSIsExtensionHidden         = 0
kMDItemFSIsStationery              = (null)
kMDItemFSLabel                     = 0
kMDItemFSName                      = "nvim-macos-arm64.tar.gz"
kMDItemFSNodeCount                 = (null)
kMDItemFSOwnerGroupID              = 20
kMDItemFSOwnerUserID               = 503
kMDItemFSSize                      = 8796470
kMDItemFSTypeCode                  = ""
kMDItemInterestingDate_Ranking     = 2024-12-07 00:00:00 +0000
kMDItemKind                        = "gzip compressed archive"
kMDItemLogicalSize                 = 8796470
kMDItemPhysicalSize                = 8798208
kMDItemWhereFroms                  = (
    "https://objects.githubusercontent.com/github-production-release-asset-2e65be/16408992/ad802a23-1166-4836-8c5d-d9f285880360?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241207%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241207T054106Z&X-Amz-Expires=300&X-Amz-Signature=86c4bbf765c39941538a221b8c3a11f89961aef680a05a0995545a9a03175656&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dnvim-macos-arm64.tar.gz&response-content-type=application%2Foctet-stream",
    "https://github.com/neovim/neovim/releases/tag/v0.10.2"
)
```

### xattr
```bash
$ xattr nvim-macos-arm64.tar.gz
com.apple.macl
com.apple.metadata:kMDItemWhereFroms
com.apple.quarantine

$ xattr -l nvim-macos-arm64.tar.gz
com.apple.macl:
com.apple.metadata:kMDItemWhereFroms: bplist00�_https://objects.githubusercontent.com/github-production-release-asset-2e65be/16408992/ad802a23-1166-4836-8c5d-d9f285880360?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=releaseassetproduction%2F20241207%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20241207T054106Z&X-Amz-Expires=300&X-Amz-Signature=86c4bbf765c39941538a221b8c3a11f89961aef680a05a0995545a9a03175656&X-Amz-SignedHeaders=host&response-content-disposition=attachment%3B%20filename%3Dnvim-macos-arm64.tar.gz&response-content-type=application%2Foctet-stream_5https://github.com/neovim/neovim/releases/tag/v0.10.2
com.apple.quarantine: 0081;6753dff2;Chrome;
```

### exiftool

> [!NOTE|label:references:]
> - install via:
>   ```bash
>   $ brew install exiftool
>   ```

```bash
$ exiftool nvim-macos-arm64.tar.gz
ExifTool Version Number         : 13.00
File Name                       : nvim-macos-arm64.tar.gz
Directory                       : .
File Size                       : 8.8 MB
File Modification Date/Time     : 2024:12:06 21:41:07-08:00
File Access Date/Time           : 2024:12:06 21:41:10-08:00
File Inode Change Date/Time     : 2024:12:06 21:41:09-08:00
File Permissions                : -rw-r--r--
File Type                       : GZIP
File Type Extension             : gz
MIME Type                       : application/x-gzip
Compression                     : Deflated
Flags                           : (none)
Modify Date                     : 2024:10:03 02:00:52-07:00
Extra Flags                     : (none)
Operating System                : Unix
```

### sips - images
```bash
$ sips -g all kubernetes-operator.png
/Users/marslo/Desktop/kubernetes-operator.png
  pixelWidth: 2560
  pixelHeight: 2560
  typeIdentifier: public.png
  format: png
  formatOptions: default
  dpiWidth: 72.000
  dpiHeight: 72.000
  samplesPerPixel: 3
  bitsPerSample: 8
  hasAlpha: no
  space: RGB

$ sips -g all JCasC.svg
/Users/marslo/Desktop/JCasC.svg
  pixelWidth: 825.640
  pixelHeight: 1024.000
  typeIdentifier: public.svg-image
  format: svg
  formatOptions: default
  dpiWidth: 72.000
  dpiHeight: 72.000
  hasAlpha: no
```

### identify - images
```bash
$ identify -verbose kubernetes-operator.png
Image:
  Filename: kubernetes-operator.png
  Permissions: rw-r--r--
  Format: PNG (Portable Network Graphics)
  Mime type: image/png
  Class: DirectClass
  Geometry: 2560x2560+0+0
  Resolution: 28.34x28.34
  Print size: 90.3317x90.3317
  Units: PixelsPerCentimeter
  Colorspace: sRGB
  Type: TrueColor
  ...

$ identify -verbose JCasC.svg
Image:
  Filename: JCasC.svg
  Permissions: rw-------
  Format: SVG (Scalable Vector Graphics)
  Mime type: image/svg+xml
  Class: DirectClass
  Geometry: 826x1024+0+0
  Units: Undefined
  Colorspace: sRGB
  Type: TrueColorAlpha
  Base type: Undefined
  Endianness: Undefined
  Depth: 16-bit
  ...
```

## migrate apps

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

## copy path
### copy STDOUT into clipboard

> [!NOTE]
> - `pbcopy` for macOS
> - `xclip` for Linux

```bash
$ <cmd> | pbcopy
```

- example
  ```bash
  $ cat file | pbcopy
  $ pwd | pbcopy
  ```

### copy path from finder
- [*right-click*(<kbd>control</kbd> + left-click) -> <kbd>option</kbd>](https://osxdaily.com/2013/06/19/copy-file-folder-path-mac-os-x/)

![option key](../screenshot/osx/copy-path-optional-key.png)

- Automator -> Quick Action

![create quick action](../screenshot/osx/copy-path-service-1.png)

![content menu](../screenshot/osx/copy-path-service-2.png)

- [Automator -> Apple Script](https://apple.stackexchange.com/a/47234/254265)

  ```bash
  on run {input, parameters}

    try
      tell application "Finder" to set the clipboard to POSIX path of (target of window 1 as alias)
    on error
      beep
    end try

    return input
  end run
  ```

![copy path apple script](../screenshot/osx/copy-path-applescript.png)

![copy path shortcut key](../screenshot/osx/copy-path-shortcut.png)

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



> [!TIP|label:register openjdk]
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

```bash
$ cp /usr/local/opt/groovy/libexec/lib/groovy.icns groovyConsole.app/Contents/Resources

$ cat > groovyConsole.app/Contents/MacOS/groovyConsole << EOF
  -> #!/usr/bin/env bash
  ->
  -> JAVA_HOME="$(/usr/libexec/java_home -v 21)"
  -> GROOVY_HOME="$(/usr/local/bin/brew --prefix groovy)/libexec"
  -> GROOVY_VERSION="$(/usr/bin/sed -rn 's/^[^:]+:[[:blank:]]?([[:digit:].]+)[[:blank:]]?.+$/\1/p' < <(${GROOVY_HOME}/bin/groovy --version))"
  ->
  -> "${JAVA_HOME}"/bin/java \
  ->   -Dsun.awt.keepWorkingSetOnMinimize=true \
  ->   -Xdock:name=GroovyConsole \
  ->   -Xdock:icon="${GROOVY_HOME}"/lib/groovy.icns \
  ->   -classpath "${GROOVY_HOME}"/lib/groovy-"${GROOVY_VERSION}".jar \
  ->   -Dscript.name="${GROOVY_HOME}"/bin/groovyConsole \
  ->   -Dprogram.name=groovyConsole \
  ->   -Dgroovy.starter.conf="${GROOVY_HOME}"/conf/groovy-starter.conf \
  ->   -Dgroovy.home="${GROOVY_HOME}" \
  ->   -Dtools.jar="${JAVA_HOME}"/lib/tools.jar org.codehaus.groovy.tools.GroovyStarter \
  ->   --main groovy.console.ui.Console \
  ->   --conf "${GROOVY_HOME}"/conf/groovy-starter.conf \
  ->   --classpath .:"${JAVA_HOME}"/lib/tools.jar:"${JAVA_HOME}"/lib/dt.jar:"${GROOVY_HOME}"/lib
  -> EOF

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

  # vim:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:filetype=sh

  #--------------------------------------------------------------------------------------#

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

- try validate via execute `groovyConsole.app/Contents/MacOS/groovyConsole` directly. to see whether if the groovyConsole will be opened.

  ![Automator.app » show in Alfred](../screenshot/osx/runable-app-4.png)


#### modify `Info.plist`
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

- original
  ```bash
  <key>CFBundleExecutable</key>
  <string>Application Stub</string>
  <key>CFBundleIconFile</key>
  <string>AutomatorApplet</string>
  <key>CFBundleIdentifier</key>
  <string>com.apple.automator.groovyConsole</string>
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

  - others
    ```bash
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

- more:
  - Info.plist
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

  - [create dmg](#create-image)
    ```bash
    $ hdiutil create -volname IDLE -srcfolder ~/Desktop/IDLE.app -ov IDLE.dmg
    ....
    created: /Users/marslo/Desktop/IDLE.dmg

    # -- or --
    $ hdiutil create -volname 'Python3 IDLE' -srcfolder "$HOME/Desktop/Python3 IDLE.app" -ov "Python3 IDLE.dmg"
    ```

  - change default python3
    ```bash
    $ ln -sf /usr/local/bin/python3.12        /usr/local/bin/python3
    $ ln -sf /usr/local/bin/python3.12-config /usr/local/bin/python3-config

    # or
    $ brew unlink python@3.11
    $ brew unlink python@3.12
    $ brew link --force python@3.12

    # or
    $ brew link --force --overwrite python@3.12
    ```

### [create dmg](#create-image)

## reset file associations

> [!NOTE|label:references:]
> - [How to reset archive file associations to macOS defaults and get the default icons for archives?](https://discussions.apple.com/thread/251157128?answerId=252207174022&sortBy=rank#252207174022)
> - [Removing obsolete file type associations from "Open With" menu](https://discussions.apple.com/thread/2608812?answerId=12400909022&sortBy=rank#12400909022)

```bash
# reloading generators list
$ qlmanage -r

# resets the quicklook database
$ /System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister -kill -seed
# or
$ find /System/Library/Frameworks -type f -name "lsregister" -exec {} -kill -seed -r \;
```

## [add snippets for input](https://sspai.com/post/36203)
### enable Technical Symbols
- Input Method ⇢ **Show emoji and symbols**

  ![show emoji & symbols](../screenshot/osx/snippets-0.png)

- Open **Customized List** ⇢ **Technical Symbols**

  ![customized list](../screenshot/osx/snippets-1.png)

  ![technical symbols](../screenshot/osx/snippets-2.png)

### and snippets
- go to **System Preferences** ⇢ **Keyboard** ⇢ **Test**
- add snippets as below

  ![snippets](../screenshot/osx/snippets-3.png)

### finally

![test-1](../screenshot/osx/snippets-4.png)

![test-2](../screenshot/osx/snippets-5.png)

### unicode hex input

> [!NOTE|label:references:]
> - [3 Ways to Insert the Mac Command Symbol](https://instructionaltechtalk.com/3-ways-to-insert-the-mac-command-symbol/)

![unicode hex input](../screenshot/osx/osx-input-unicode-hex.gif)

#### settings

- click **input method** ⇢ **Open Keyboard Settings...**

  ![keyboard settings](../screenshot/osx/osx-input-unicode-hex-1.png)

- click **+** ⇢ **Others** ⇢ **Unicode Hex Input**

  ![unicode hex input](../screenshot/osx/osx-input-unicode-hex-2.png)


## others
### [install font](https://www.reddit.com/r/programming/comments/kj0prs/comment/ggvwadd/?utm_source=share&utm_medium=web2x&context=3)
```bash
$ curl --create-dirs \
       -O \
       --output-dir ~/.fonts \
       https://dtinth.github.io/comic-mono-font/ComicMono.ttf && \
  curl --create-dirs \
       -O \
       --output-dir ~/.fonts \
       https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf &&
  fc-cache -f -v
```

### create image

> [!NOTE|label:references:]
> - [How do I create a nice-looking DMG for Mac OS X using command-line tools?](https://stackoverflow.com/a/1513578/2940319)
> - [andreyvit/create-dmg](https://github.com/andreyvit/create-dmg)
> - [LinusU/node-appdmg](https://github.com/LinusU/node-appdmg)
> - [Mac打包dmg文件(更换背景图)](https://blog.csdn.net/u011236348/article/details/88772966)

#### background images

![image 1](https://github.com/marslo/mytools/raw/main/osx/Applications/dmg-backgound/.background.1.png)

![image 2](https://github.com/marslo/mytools/raw/main/osx/Applications/dmg-backgound/.background.2.png)

![image 3](https://github.com/marslo/mytools/raw/main/osx/Applications/dmg-backgound/.background.3.png)

#### create dmg from app

- via `hdiutil`

  > [!NOTE|label:references:]
  > - `-format`:
  >   - `UDRW`: read/write image
  >   - `UDRO`: read-only image
  >   - `UDCO`: ADC-compressed image
  >   - `UDZO`: zlib-compressed image
  >   - `UDBZ`: bzip2-compressed image
  >   - `ULFO`: lzfse-compressed image, introduced in macOS 10.11
  >   - `ULMO`: lzma-compressed image, introduced in macOS 10.15
  >   - `UDTO`: DVD/CD-R master for export
  >   - `UDSP`: SPARSE (grows with content)
  >   - `UDSB`: SPARSEBUNDLE (grows with content; bundle-backed)
  >   - `UFBI`: UDIF entire image with MD5 checksum

  ```bash
  $ hdiutil create -srcfolder "/Applications/Python3 IDLE.app" \
                   -volname 'Python3 IDLE' \
                   -fs HFS+ \
                   -fsargs "-c c=64,a=16,e=16" \
                   -format UDRW \
                   "Python3 IDLE.dmg" [ --debug ] [ --verbose ]

  # or
  $ hdiutil create -volname "Volume Name" \
                   -srcfolder /path/to/folder \
                   -ov diskimage.dmg

  # create encrypted image
  $ hdiutil create encrypted.dmg
                   -encryption AES-128 \
                   -stdinpass \
                   -volname "Volume Name" \
                   -srcfolder /path/to/folder \
                   -ov                       # overwrite any existing files
  # i.e.:
  $ hdiutil create mEncrypted.dmg \
                   -encryption \
                   -size 1g \
                   -volname "mEncrypted Disk Image" \
                   -fs JHFS+ \
                   -srcfolder /path/to/folder \
  Enter a new password to secure "mEncrypted.dmg":
  Re-enter new password:
  ....
  created: /Users/marslo/Desktop/mEncrypted.dmg

  # create read/write image with specific size
  $ hdiutil create ~/Desktop/mTest.dmg \
            -volname "Marslo Test" \
            -srcfolder ~/Desktop/mTest \
            -size 1g \
            -format UDRW                     # UDRW: read/write image
  ```

  ![hdiutil create image](../screenshot/osx/hdiutil-create-image.png)

  ![hdiutil create encrypted image](../screenshot/osx/hdiutil-create-encrypted.png)

- via `create-dmg`
  ```bash
  $ brew install create-dmg
  $ create-dmg --volname 'Python3 IDLE' \
               --volicon /opt/dmg-backgound/.idle.icns \
               --background /opt/dmg-backgound/.background.2.png \
               --icon 'Python3 IDLE.app' 225 275 \
               --app-drop-link 525 270 \
               --window-size 750 500 \
               --hide-extension 'Python3 IDLE.app' \
               'Python3 IDLE.dmg' '/Applications/Python3 IDLE.app'
  ```

  ![create-dmg](../screenshot/osx/create-dmg.png)

#### create dvd (for .iso, .img, .dmg)
```bash
$ hdiutil burn /path/to/image_file
```

#### create dmg for OS installer
```bash
$ sudo hdiutil create ~/Desktop/Lion.dmg -srcdevice /dev/disk2s4
```

#### resize the disk image
```bash
$ hdiutil resize -size <new size> <imagename>.dmg

# or
$ hdiutil resize -size 2g mEncrypted.dmg
```

#### restore disk images
```bash
$ sudo asr restore --source <disk image>.dmg --target /Volumes/<volume name>
```

### extract

- `.pkg`

  > [!NOTE|label:references:]
  > - [How can I open a .pkg file manually?](https://apple.stackexchange.com/a/309591/254265)

  ```bash
  $ xar -xvf foo.pkg
  ```

- `.dmg`

  ```bash
  $ 7z x foo.dmg

  # or
  $ hdiutil attach foo.dmg
  ```

### disk

{% hint style='tip' %}
> reference:
> - [Disk Management From the Command-Line, Part 1](http://www.theinstructional.com/guides/disk-management-from-the-command-line-part-1)
> - [Disk Management From the Command-Line, Part 2](http://www.theinstructional.com/guides/disk-management-from-the-command-line-part-2)
> - [Disk Management From the Command-Line, Part 3](http://www.theinstructional.com/guides/disk-management-from-the-command-line-part-3)
{% endhint %}

#### list disks and volumes
```bash
$ diskutil list

# or
$ diskutil list disk1

# or via `lsblk`: https://command-not-found.com/lsblk
$ docker run cmd.cat/lsblk lsblk
NAME   MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
vda    254:0    0  16G  0 disk
└─vda1 254:1    0  16G  0 part /etc/hosts

# or via `lshw`: https://command-not-found.com/lshw
$ docker run cmd.cat/lshw lshw -class disk
  *-virtio1
       description: Virtual I/O device
       physical id: 0
       bus info: virtio@1
       logical name: vda
       configuration: driver=virtio_blk

# or
$ system_profiler SPStorageDataType
```

#### check volume info
```bash
$ diskutil info <path/to/volumn>
# i.e.:
$ diskutil info /Volumes/iMarsloOSX/
   Device Identifier:         disk1s5
   Device Node:               /dev/disk1s5
   Whole:                     No
   Part of Whole:             disk1

   Volume Name:               iMarsloOSX
   Mounted:                   Yes
   Mount Point:               /
```

#### list the apfs info
```bash
$ diskutil apfs list
APFS Container (1 found)
|
+-- Container disk1 ********-****-****-****-************
    ====================================================
    APFS Container Reference:     disk1
    Size (Capacity Ceiling):      250685575168 B (250.7 GB)
    Capacity In Use By Volumes:   176258826240 B (176.3 GB) (70.3% used)
    Capacity Not Allocated:       74426748928 B (74.4 GB) (29.7% free)
    |
    +-< Physical Store...>
    |
    +-> ...

$ diskutil apfs list
APFS Containers (3 found)
|
+-- Container disk3 8FD21D62-C7F0-4554-B7C7-AE85BE52D8AA
    ====================================================
    APFS Container Reference:     disk3
    Size (Capacity Ceiling):      494384795648 B (494.4 GB)
    Capacity In Use By Volumes:   289735741440 B (289.7 GB) (58.6% used)
    Capacity Not Allocated:       204649054208 B (204.6 GB) (41.4% free)
    |
    +-< Physical Store disk0s2 1*******-****-****-****-***********8
    |   -----------------------------------------------------------
    |   APFS Physical Store Disk:   disk0s2
    |   Size:                       494384795648 B (494.4 GB)
    |
    +-> Volume disk3s1 2*******-****-****-****-***********E
        ---------------------------------------------------
        APFS Volume Disk (Role):   disk3s1 (Data)
        Name:                      Macintosh HD - Data (Case-insensitive)
        Mount Point:               /System/Volumes/Data
        Capacity Consumed:         256742236160 B (256.7 GB)
        Sealed:                    No
        FileVault:                 Yes (Unlocked)
```

#### create volume for case-sensitive APFS

> [!NOTE]
> - volume name: `CaseSensitive`
> - volume size: `4000m` (4GB)
> - disk identifier: `disk3`
> - case-sensitive:
>
> | CASE SENSITIVE | CASE INSENSITIVE |
> |:--------------:|:----------------:|
> | APFSX          | APFS             |

```bash
# for case-sensitive APFS
$ diskutil apfs addVolume disk3 APFSX CaseSensitive -quota 4000m

# remove
$ diskutil unmount /Volumes/CaseSensitive
$ diskutil apfs deleteVolume disk3s7
```

#### erase disk

{% hint style='tip' %}

| File System                 | Abbreviation |
|:----------------------------|:------------:|
| Mac OS Extended (Journaled) |    `JHFS+`   |
| Mac OS Extended             |    `HFS+`    |
| MS-DOS fat32                |    `FAT32`   |
| ExFAT                       |    `ExFAT`   |

{% endhint %}
- to list file systems
  ```bash
  $ diskutil listFilesystems
  ...
  -------------------------------------------------------------------------------
  PERSONALITY                     USER VISIBLE NAME
  -------------------------------------------------------------------------------
  Case-sensitive APFS             APFS (Case-sensitive)
    (or) APFSX
  APFS                            APFS
    (or) APFSI
  ExFAT                           ExFAT
  Free Space                      Free Space
    (or) FREE
  MS-DOS                          MS-DOS (FAT)
  MS-DOS FAT12                    MS-DOS (FAT12)
  MS-DOS FAT16                    MS-DOS (FAT16)
  MS-DOS FAT32                    MS-DOS (FAT32)
    (or) FAT32
  HFS+                            Mac OS Extended
  Case-sensitive HFS+             Mac OS Extended (Case-sensitive)
    (or) HFSX
  Case-sensitive Journaled HFS+   Mac OS Extended (Case-sensitive, Journaled)
    (or) JHFSX
  Journaled HFS+                  Mac OS Extended (Journaled)
    (or) JHFS+
  UFSD_NTFS                       Microsoft NTFS
  ```

  <!--sec data-title="ExFAT" data-id="section4" data-show=true data-collapse=true ces-->
  ```bash
  $ diskutil eraseDisk ExFAT iMarsloUSB /dev/disk2
  Started erase on disk2
  Unmounting disk
  Creating the partition map
  Waiting for partitions to activate
  Formatting disk2s2 as ExFAT with name iMarsloUSB
  Volume name      : iMarsloUSB
  Partition offset : 411648 sectors (210763776 bytes)
  Volume size      : 246534144 sectors (126225481728 bytes)
  Bytes per sector : 512
  Bytes per cluster: 131072
  FAT offset       : 2048 sectors (1048576 bytes)
  # FAT sectors    : 8192
  Number of FATs   : 1
  Cluster offset   : 10240 sectors (5242880 bytes)
  # Clusters       : 962984
  Volume Serial #  : 5ff81490
  Bitmap start     : 2
  Bitmap file size : 120373
  Upcase start     : 3
  Upcase file size : 5836
  Root start       : 4
  Mounting disk
  Finished erase on disk2
  ```
  <!--endsec-->

  <!--sec data-title="check" data-id="section5" data-show=true data-collapse=true ces-->
  ```bash
  $ diskutil info disk2s1
     Device Identifier:         disk2s1
     Device Node:               /dev/disk2s1
     Whole:                     No
     Part of Whole:             disk2

     Volume Name:               EFI
     Mounted:                   No

     Partition Type:            EFI
     File System Personality:   MS-DOS FAT32
     Type (Bundle):             msdos
     Name (User Visible):       MS-DOS (FAT32)
     ...
     ...

  $ diskutil info disk2s2
     Device Identifier:         disk2s2
     Device Node:               /dev/disk2s2
     Whole:                     No
     Part of Whole:             disk2

     Volume Name:               iMarsloUSB
     Mounted:                   Yes
     Mount Point:               /Volumes/iMarsloUSB

     Partition Type:            Microsoft Basic Data
     File System Personality:   ExFAT
     Type (Bundle):             exfat
     Name (User Visible):       ExFAT
     ...
     ...
  ```
  <!--endsec-->

##### verifying and repairing volumes
```bash
$ diskutil verifyVolume /Volumes/<volume name>
$ diskutil repairVolume /Volumes/<volume name>
```

#### rename volume
```bash
$ diskutil rename "<current name of volume>" "<new name>"
```

#### partitioning a disk

{% hint style='tip' %}
> reference:
> - `GPT`: GUID Partition Table
> - `APM`: Apple Partition Map
> - `MBR`: Master Boot Records
{% endhint %}

```bash
$ diskutil partitionDisk /dev/disk2 GPT JHFS+ New 0b
```

- multiple partitions
  ```bash
  $ diskutil partitionDisk /dev/disk2 GPT \
             JHFS+ First 10g \
             JHFS+ Second 10g \
             JHFS+ Third 10g \
             JHFS+ Fourth 10g \
             JHFS+ Fifth 0b
  ```

- splitting partitions
  ```bash
  $ diskutil splitPartition /dev/disk2s6 \
             JHFS+ Test 10GB \
             JHFS+ Test2 0b
  ```

- merging partitions
  ```bash
  $ diskutil mergePartitions \
             JHFS+ \
             NewName \
             <first disk identifier in range> \
             <last disk identifier in range>
  # i.e.:
  $ diskutil mergePartitions JHFS+ NewName disk2s4 disk2s6
  ```

#### [check usb](https://apple.stackexchange.com/a/170118/254265)

> [!NOTE|label:references:]
> - [tips and tricks](https://gist.github.com/dive/3070807)
> - [`system_profiler -usage`](https://gist.github.com/dive/3070807)

```bash
$ system_profiler SPUSBDataType

# get xml format
$ system_profiler -xml SPUSBDataType

# or
$ ioreg -p IOUSB

# or
$ ioreg -p IOUSB -w0 -l

# or get device name
$ ioreg -p IOUSB -w0 | sed 's/[^o]*o //; s/@.*$//' | grep -v '^Root.*'
```

### modify font in plist

> [!NOTE|label:references:]
> - [How to read plist information (bundle id) from a shell script](https://stackoverflow.com/a/56238780/2940319)

```bash
# check
$ /usr/libexec/PlistBuddy -c 'print ":/groovy/console/ui/:fontSize"' ~/Library/Preferences/groovy.console.ui.plist
18

# change
$ /usr/libexec/PlistBuddy -c 'Set ":/groovy/console/ui/:fontSize" 24' ~/Library/Preferences/groovy.console.ui.plist
$ /usr/libexec/PlistBuddy -c 'Print ":/groovy/console/ui/:fontSize"'  ~/Library/Preferences/groovy.console.ui.plist
24
```

<!--sec data-title="original" data-id="section6" data-show=true data-collapse=true ces-->
```bash
$ defaults read ~/Library/Preferences/groovy.console.ui.plist
{
    "/groovy/console/ui/" =     {
        autoClearOutput = true;
        compilerPhase = 4;
        currentFileChooserDir = "/Users/marslo/Desktop";
        decompiledFontSize = 12;
        fontSize = 18;
        frameHeight = 600;
        frameWidth = 800;
        frameX = 198;
        frameY = 201;
        horizontalSplitterLocation = 100;
        inputAreaHeight = 576;
        inputAreaWidth = 1622;
        outputAreaHeight = 354;
        outputAreaWidth = 1676;
        showClosureClasses = false;
        showIndyBytecode = false;
        showScriptClass = true;
        showScriptFreeForm = false;
        showScriptInOutput = false;
        showTreeView = true;
        threadInterrupt = true;
        verticalSplitterLocation = 100;
    };
}
```
<!--endsec-->

### show process details

![activity monitor](../screenshot/osx/activity-monitor.png)

### `/usr/bin/xattr`

> [!NOTE|label:references:]
> - [xattr](https://www.oreilly.com/library/view/macintosh-terminal-pocket/9781449328962/re38.html)
> - [How do I remove the "extended attributes" on a file in Mac OS X?](https://stackoverflow.com/a/58616002/2940319)

- init
  ```bash
  $ touch test.txt
  $ /usr/bin/xattr -l test.txt
  ```

- create attributes
  ```bash
  $ /usr/bin/xattr -w com.example.color blue test.txt
  $ /usr/bin/xattr -l test.txt
  com.example.color: blue
  ```

- print attributes
  ```bash
  $ /usr/bin/xattr -p com.example.color test.txt
  blue
  ```

- clear attributes
  ```bash
  $ /usr/bin/xattr -d com.example.color test.txt

  # or
  $ /usr/bin/xattr -c test.txt
  ```

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

#### switch input method in cursor/vscode
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

## tips
### shutdown mac via commands
```bash
$ osascript -e 'tell app 'loginwindow' to «event aevtrsdn»'
```

### [alert on mac when server is up](https://www.commandlinefu.com/commands/view/2853/alert-on-mac-when-server-is-up)
```bash
$ ping -o -i 30 HOSTNAME && osascript -e 'tell app "Terminal" to display dialog "Server is up" buttons "It?s about time" default button 1'
```

### [turn off the screen without sleeping](https://apple.stackexchange.com/a/266103/254265)
```bash
$ pmset displaysleepnow

# sleep
$ pmset sleepnow

# lock
$ pmset lock
```

### disable startup music
```bash
$ sudo nvram SystemAudioVolume=" "
```

### 3D lock screen
```bash
$ /System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend
```

### take screenshot after 3 sec
```bash
$ screencapture -T 3 -t jpg -P delayedpic.jpg
```

### setup welcome text in login screen
```bash
$ sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText 'Awesome Marslo!!'
```

### show message on desktop
```bash
$ sudo jamf displayMessage -message "Hello World!"
```

### [launch iOS simulator](https://medium.com/@abrisad_it/how-to-launch-ios-simulator-and-android-emulator-on-mac-cd198295532e)
```bash
$ xcrun simctl list
$ open -a Simulator --args -CurrentDeviceUDID <DEVICE-UDID>
```

- install the application on the device
  ```bash
  $ xcrun simctl install <DEVICE-UDID> <path to application bundle>
  $ xcrun simctl launch <DEVICE-UDID> <app bundle identifier>

  # or
  $ open -a Simulator.app

  # or
  $ open /Applications/Xcode.app/Contents/Developer/Applications/Simulator.app
  ```

### show startup launch apps
```bash
$ launchctl list
```

### check detail diskage usage
```bash
$ sudo fs_usage
21:03:47  ioctl        0.000003   iTerm2
21:03:47  ioctl        0.000003   iTerm2
21:03:47  close        0.000031   privoxy
21:03:47  select       0.000004   privoxy
...
```

### check User-level TCC permissions database

| auth_value | MEANING                                          | DESCRIPTION                                        |
| :--------: | ------------------------------------------------ | -------------------------------------------------- |
|     `0`    | Denied (拒绝/未决)                               | the app is denied access to the service            |
|     `1`    | Unknown                                          | state undetermined (rarely seen)                   |
|     `2`    | Allowed/Authorized (已允许)                      | the app is allowed access to the service           |
|     `3`    | Limited/Restricted (受限)                        | the app is allowed access but with limitations     |
|     `4`    | Auth pending / awaiting user prompt (待用户确认) | the app is awaiting user input to determine access |
|     `5`    | elevated / requires authorization (需鉴权)       | the app is requires elevated privileges            |

```bash
# check all permissions
$ sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service,client,auth_value FROM access;"

# check permissions for CleanMyMac5
$ sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service,client,auth_value FROM access WHERE client LIKE '%CleanMyMac5%';"
╭────────────────────────────────────────┬────────────────────────┬────────────╮
│                service                 │         client         │ auth_value │
╞════════════════════════════════════════╪════════════════════════╪════════════╡
│ kTCCServiceBluetoothAlways             │ com.macpaw.CleanMyMac5 │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder │ com.macpaw.CleanMyMac5 │          2 │
│ kTCCServiceSystemPolicyAppData         │ com.macpaw.CleanMyMac5 │          5 │
│ kTCCServiceSystemPolicyDocumentsFolder │ com.macpaw.CleanMyMac5 │          2 │
│ kTCCServiceSystemPolicyDesktopFolder   │ com.macpaw.CleanMyMac5 │          2 │
│ kTCCServicePhotos                      │ com.macpaw.CleanMyMac5 │          2 │
╰────────────────────────────────────────┴────────────────────────┴────────────╯

# check permissions for Calendar
$ sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service,client,auth_value FROM access WHERE client LIKE '%Calendar%';"
```

<!--sec data-title="sqlite3 tcc.db" data-id="section7" data-show=true data-collapse=true ces-->

```bash
$ sqlite3 ~/Library/Application\ Support/com.apple.TCC/TCC.db "SELECT service,client,auth_value FROM access;"
╭──────────────────────────────────────────┬───────────────────────────────────────────────────────────────────────────────────────────────────┬────────────╮
│                 service                  │                                              client                                               │ auth_value │
╞══════════════════════════════════════════╪═══════════════════════════════════════════════════════════════════════════════════════════════════╪════════════╡
│ kTCCServiceLiverpool                     │ com.apple.assistant.assistantd                                                                    │          2 │
│ kTCCServiceLiverpool                     │ com.apple.securityd                                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.transparencyd                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.triald                                                                                  │          2 │
│ kTCCServiceLiverpool                     │ com.apple.syncdefaultsd                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.imagent                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ /System/Library/PrivateFrameworks/UsageTracking.framework/Versions/A/UsageTrackingAgent           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.routined                                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.passd                                                                                   │          2 │
│ kTCCServiceUbiquity                      │ com.apple.weather.widget                                                                          │          2 │
│ kTCCServiceLiverpool                     │ com.apple.voicebankingd                                                                           │          0 │
│ kTCCServiceLiverpool                     │ /System/Library/PrivateFrameworks/TextToSpeechVoiceBankingSupport.framework/Support/voicebankingd │          2 │
│ kTCCServiceUbiquity                      │ com.apple.weather                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.stocks                                                                                  │          2 │
│ kTCCServiceUbiquity                      │ com.apple.stocks.detailintents                                                                    │          2 │
│ kTCCServiceUbiquity                      │ com.apple.finder                                                                                  │          2 │
│ kTCCServiceLiverpool                     │ com.apple.callhistory.sync-helper                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.findmy.findmylocateagent                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.siriknowledged                                                                          │          2 │
│ kTCCServiceLiverpool                     │ com.apple.avatarsd                                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.amsengagementd                                                                          │          2 │
│ kTCCServiceLiverpool                     │ com.apple.Passbook                                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.shortcuts                                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.StatusKitAgent                                                                          │          2 │
│ kTCCServiceLiverpool                     │ com.apple.knowledge-agent                                                                         │          2 │
│ kTCCServiceLiverpool                     │ com.apple.icloud.searchpartyuseragent                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.icloud.fmfd                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.willowd                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.donotdisturbd                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.identityservicesd                                                                       │          2 │
│ kTCCServiceLiverpool                     │ com.apple.suggestd                                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.sociallayerd                                                                            │          2 │
│ kTCCServiceLiverpool                     │ com.apple.Safari                                                                                  │          2 │
│ kTCCServiceLiverpool                     │ com.apple.UsageTrackingAgent                                                                      │          2 │
│ kTCCServiceLiverpool                     │ com.apple.cloudpaird                                                                              │          2 │
│ kTCCServiceLiverpool                     │ com.apple.textinput.KeyboardServices                                                              │          2 │
│ kTCCServiceFocusStatus                   │ com.microsoft.Outlook                                                                             │          2 │
│ kTCCServiceUbiquity                      │ com.apple.Safari                                                                                  │          2 │
│ kTCCServiceMicrophone                    │ us.zoom.xos                                                                                       │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.tinyspeck.slackmacgap                                                                         │          2 │
│ kTCCServiceMicrophone                    │ com.tinyspeck.slackmacgap                                                                         │          2 │
│ kTCCServiceCamera                        │ com.tinyspeck.slackmacgap                                                                         │          2 │
│ kTCCServiceBluetoothAlways               │ com.google.Chrome                                                                                 │          2 │
│ kTCCServiceWebBrowserPublicKeyCredential │ com.google.Chrome                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.protectedcloudstorage.protectedcloudkeysyncing                                          │          2 │
│ kTCCServiceAppleEvents                   │ us.zoom.pluginagent                                                                               │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceUbiquity                      │ com.apple.identityservicesd                                                                       │          2 │
│ kTCCServiceUbiquity                      │ com.apple.imagent                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.Maps                                                                                    │          2 │
│ kTCCServiceLiverpool                     │ com.apple.biomesyncd                                                                              │          2 │
│ kTCCServiceLiverpool                     │ com.apple.appleaccountd                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.gamed                                                                                   │          2 │
│ kTCCServiceLiverpool                     │ com.apple.security.cuttlefish                                                                     │          2 │
│ kTCCServiceLiverpool                     │ com.apple.ScreenTimeAgent                                                                         │          2 │
│ kTCCServiceLiverpool                     │ com.apple.upload-request-proxy.com.apple.photos.cloud                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.cloudphotod                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.bluetoothuserd                                                                          │          2 │
│ kTCCServiceLiverpool                     │ /System/Library/PrivateFrameworks/iCloudNotification.framework/iCloudNotificationAgent            │          2 │
│ kTCCServiceLiverpool                     │ com.apple.iCloudNotificationAgent                                                                 │          2 │
│ kTCCServiceUbiquity                      │ com.apple.universalcontrol                                                                        │          2 │
│ kTCCServiceLiverpool                     │ com.apple.stocks.widget                                                                           │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.accessibility.heard                                                                     │          2 │
│ kTCCServiceFileProviderDomain            │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServicePhotos                        │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceAddressBook                   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceReminders                     │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.systempreferences.AppleIDSettings                                                       │          2 │
│ kTCCServiceCalendar                      │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceBluetoothAlways               │ com.macpaw.CleanMyMac5                                                                            │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.macpaw.CleanMyMac5                                                                            │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.macpaw.CleanMyMac5                                                                            │          5 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.macpaw.CleanMyMac5                                                                            │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.macpaw.CleanMyMac5                                                                            │          2 │
│ kTCCServiceAddressBook                   │ com.runningwithcrayons.Alfred                                                                     │          2 │
│ kTCCServiceUbiquity                      │ com.apple.iBooksX                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.iBooksX                                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.iBooks.BookDataStoreService                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.iad-cloudkit                                                                            │          2 │
│ kTCCServiceReminders                     │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceWebBrowserPublicKeyCredential │ com.google.Chrome.canary                                                                          │          2 │
│ kTCCServiceBluetoothAlways               │ com.google.Chrome.canary                                                                          │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.googlecode.iterm2                                                                             │          5 │
│ kTCCServiceAppleEvents                   │ net.lowreal.KeyCast                                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.mlhost.CloudWorker                                                                      │          2 │
│ kTCCServiceAudioCapture                  │ us.zoom.xos                                                                                       │          2 │
│ kTCCServiceUbiquity                      │ com.apple.MobileSMS                                                                               │          2 │
│ kTCCServiceFocusStatus                   │ com.apple.MobileSMS                                                                               │          0 │
│ kTCCServiceUbiquity                      │ com.apple.TextEdit                                                                                │          2 │
│ kTCCServiceAppleEvents                   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceAppleEvents                   │ com.runningwithcrayons.Alfred                                                                     │          2 │
│ kTCCServiceFileProviderDomain            │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.Snipaste                                                                                      │          2 │
│ kTCCServiceUbiquity                      │ com.apple.Preview                                                                                 │          2 │
│ kTCCServiceUbiquity                      │ com.microsoft.Outlook                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.stickersd                                                                               │          2 │
│ kTCCServiceUbiquity                      │ com.apple.controlcenter                                                                           │          2 │
│ kTCCServiceCamera                        │ us.zoom.xos                                                                                       │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.hezongyidev.Bob                                                                               │          2 │
│ kTCCServiceUbiquity                      │ com.app77.pwsafemac                                                                               │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.microsoft.OneDrive                                                                            │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.microsoft.OneDrive                                                                            │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceBluetoothAlways               │ com.logi.ghub                                                                                     │          2 │
│ kTCCServiceSystemPolicyAppBundles        │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceAppleEvents                   │ com.runningwithcrayons.Alfred                                                                     │          2 │
│ kTCCServiceAppleEvents                   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceAddressBook                   │ com.stairways.keyboardmaestro.editor                                                              │          2 │
│ kTCCServiceAppleEvents                   │ com.stairways.keyboardmaestro.editor                                                              │          2 │
│ kTCCServiceLiverpool                     │ com.apple.stocks.detailintents                                                                    │          2 │
│ kTCCServiceBluetoothAlways               │ com.better365.menubar                                                                             │          2 │
│ kTCCServiceAppleEvents                   │ com.better365.menubar                                                                             │          2 │
│ kTCCServiceCalendar                      │ com.bjango.istatmenus.status                                                                      │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceCamera                        │ com.microsoft.rdc.macos                                                                           │          2 │
│ kTCCServiceMicrophone                    │ com.microsoft.rdc.macos                                                                           │          2 │
│ kTCCServiceAddressBook                   │ com.sogou.inputmethod.sogou                                                                       │          2 │
│ kTCCServiceSystemPolicyAppBundles        │ com.sogou.SogouInstaller                                                                          │          2 │
│ kTCCServiceCamera                        │ com.helloresolven.GIF-Brewery-3                                                                   │          2 │
│ kTCCServiceMicrophone                    │ com.helloresolven.GIF-Brewery-3                                                                   │          2 │
│ kTCCServiceMicrophone                    │ com.google.Chrome                                                                                 │          2 │
│ kTCCServiceAppleEvents                   │ com.pilotmoon.popclip-setapp                                                                      │          2 │
│ kTCCServiceAppleEvents                   │ com.pilotmoon.popclip-setapp                                                                      │          2 │
│ kTCCServiceLiverpool                     │ com.wiheads.paste-setapp                                                                          │          2 │
│ kTCCServicePhotos                        │ com.microsoft.Powerpoint                                                                          │          2 │
│ kTCCServicePhotos                        │ com.macpaw.CleanMyMac5                                                                            │          2 │
│ kTCCServiceFileProviderDomain            │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceUbiquity                      │ com.apple.Photos                                                                                  │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceUbiquity                      │ com.apple.mail                                                                                    │          2 │
│ kTCCServiceAppleEvents                   │ com.runningwithcrayons.Alfred                                                                     │          2 │
│ kTCCServiceLiverpool                     │ com.apple.mail                                                                                    │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.google.Chrome                                                                                 │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.Snipaste                                                                                      │          2 │
│ kTCCServiceBluetoothAlways               │ com.bjango.istatmenus                                                                             │          2 │
│ kTCCServiceBluetoothAlways               │ com.bjango.istatmenus.status                                                                      │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.microsoft.VSCode                                                                              │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.microsoft.VSCode                                                                              │          2 │
│ kTCCServiceUbiquity                      │ com.soggywaffles.paintbrush                                                                       │          2 │
│ kTCCServiceBluetoothAlways               │ com.okta.mobile                                                                                   │          2 │
│ kTCCServiceCamera                        │ com.google.Chrome                                                                                 │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.google.Chrome                                                                                 │          0 │
│ kTCCServiceUbiquity                      │ com.apple.QuickTimePlayerX                                                                        │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.Snipaste                                                                                      │          2 │
│ kTCCServiceFileProviderDomain            │ com.Snipaste                                                                                      │          2 │
│ kTCCServiceUbiquity                      │ com.apple.stocks                                                                                  │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/23.0.2/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceUbiquity                      │ com.apple.iWork.Numbers                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.iWork.Numbers                                                                           │          2 │
│ kTCCServiceFileProviderDomain            │ com.ScooterSoftware.BeyondCompare                                                                 │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.ScooterSoftware.BeyondCompare                                                                 │          5 │
│ kTCCServiceSystemPolicyRemovableVolumes  │ com.logi.ghub                                                                                     │          2 │
│ kTCCServiceCamera                        │ com.microsoft.Powerpoint                                                                          │          2 │
│ kTCCServiceFileProviderDomain            │ com.microsoft.Powerpoint                                                                          │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ org.vim.MacVim                                                                                    │          2 │
│ kTCCServiceSystemPolicyNetworkVolumes    │ org.mozilla.firefox                                                                               │          2 │
│ kTCCServiceMicrophone                    │ com.microsoft.Powerpoint                                                                          │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.paloaltonetworks.GlobalProtect.client                                                         │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.paloaltonetworks.GlobalProtect.client                                                         │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.paloaltonetworks.GlobalProtect.client                                                         │          2 │
│ kTCCServiceFileProviderDomain            │ com.paloaltonetworks.GlobalProtect.client                                                         │          2 │
│ kTCCServiceReminders                     │ com.paloaltonetworks.GlobalProtect.client                                                         │          2 │
│ kTCCServiceCamera                        │ com.google.Chrome.canary                                                                          │          2 │
│ kTCCServiceMicrophone                    │ com.google.Chrome.canary                                                                          │          2 │
│ kTCCServiceMicrophone                    │ cn.better365.ishot                                                                                │          2 │
│ kTCCServiceCamera                        │ cn.better365.ishot                                                                                │          2 │
│ kTCCServiceCamera                        │ cn.better365.iShotPro                                                                             │          2 │
│ kTCCServiceFileProviderDomain            │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceAppleEvents                   │ com.googlecode.iterm2                                                                             │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ org.spyder-ide.Spyder-6                                                                           │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ org.spyder-ide.Spyder-6                                                                           │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ org.spyder-ide.Spyder-6                                                                           │          2 │
│ kTCCServiceFileProviderDomain            │ org.spyder-ide.Spyder-6                                                                           │          2 │
│ kTCCServiceMicrophone                    │ dev.warp.Warp-Stable                                                                              │          0 │
│ kTCCServiceFileProviderDomain            │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceFileProviderDomain            │ dev.warp.Warp-Stable                                                                              │          0 │
│ kTCCServiceReminders                     │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceCalendar                      │ dev.warp.Warp-Stable                                                                              │          4 │
│ kTCCServiceSystemPolicyDesktopFolder     │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceSystemPolicyAppData           │ dev.warp.Warp-Stable                                                                              │          5 │
│ kTCCServicePhotos                        │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceAddressBook                   │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ dev.warp.Warp-Stable                                                                              │          2 │
│ kTCCServiceLiverpool                     │ com.moleskine.overlap                                                                             │          2 │
│ kTCCServiceCalendar                      │ com.moleskine.overlap                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.moleskine.overlap.IntentsExtension                                                            │          2 │
│ kTCCServiceLiverpool                     │ com.moleskine.overlap.Widgets-Extension                                                           │          2 │
│ kTCCServiceFileProviderDomain            │ com.microsoft.Word                                                                                │          2 │
│ kTCCServiceFileProviderDomain            │ com.microsoft.Excel                                                                               │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.tencent.qq                                                                                    │          2 │
│ kTCCServiceAppleEvents                   │ com.hezongyidev.Bob                                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.shortcuts.events                                                                        │          2 │
│ kTCCServiceUbiquity                      │ com.apple.shortcuts                                                                               │          2 │
│ kTCCServiceBluetoothAlways               │ org.chromium.Chromium                                                                             │          2 │
│ kTCCServiceFileProviderDomain            │ com.microsoft.VSCode                                                                              │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.microsoft.VSCode                                                                              │          2 │
│ kTCCServiceFocusStatus                   │ com.microsoft.OneDrive                                                                            │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/24.0.1/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceUbiquity                      │ com.apple.Spotlight                                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.CloudTelemetryService.xpc                                                               │          2 │
│ kTCCServiceLiverpool                     │ com.apple.mstreamd                                                                                │          2 │
│ kTCCServiceLiverpool                     │ com.apple.homeenergyd                                                                             │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/24.0.2/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceLiverpool                     │ io.sipapp.Sip-paddle                                                                              │          2 │
│ kTCCServiceWebBrowserPublicKeyCredential │ org.mozilla.firefox                                                                               │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.adobe.Reader                                                                                  │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ org.vim.MacVim                                                                                    │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/25/libexec/openjdk.jdk/Contents/Home/bin/java                        │          2 │
│ kTCCServiceBluetoothAlways               │ com.crowdstrike.falcon.App                                                                        │          2 │
│ kTCCServiceLiverpool                     │ com.apple.accessibility.AccessibilityUIServer                                                     │          2 │
│ kTCCServiceLiverpool                     │ com.apple.amsaccountsd                                                                            │          2 │
│ kTCCServiceLiverpool                     │ com.apple.contacts.postersyncd                                                                    │          2 │
│ kTCCServiceLiverpool                     │ com.apple.frauddefensed                                                                           │          2 │
│ kTCCServiceLiverpool                     │ com.apple.musicrecognition.mac                                                                    │          2 │
│ kTCCServiceLiverpool                     │ com.apple.aiml.mlpt.FedStats.MLHostPlugin                                                         │          2 │
│ kTCCServiceMicrophone                    │ cn.better365.iShotPro                                                                             │          2 │
│ kTCCServiceUbiquity                      │ /System/Library/PrivateFrameworks/VoiceShortcuts.framework/Versions/A/Support/siriactionsd        │          2 │
│ kTCCServiceBluetoothAlways               │ us.zoom.xos                                                                                       │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/25.0.1/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.apple.Automator                                                                               │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.tencent.xinWeChat                                                                             │          2 │
│ kTCCServiceAddressBook                   │ com.apple.iWork.Numbers                                                                           │          2 │
│ kTCCServiceSystemPolicyAppData           │ net.element26.outlookmsgviewer                                                                    │          5 │
│ kTCCServiceLiverpool                     │ com.apple.homeeventsd                                                                             │          2 │
│ kTCCServiceMediaLibrary                  │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceFileProviderDomain            │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/25.0.2/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceSystemPolicyAppData           │ us.zoom.pluginagent                                                                               │          5 │
│ kTCCServiceSystemPolicyAppData           │ com.microsoft.VSCode                                                                              │          5 │
│ kTCCServiceMicrophone                    │ com.tencent.xinWeChat                                                                             │          2 │
│ kTCCServiceLiverpool                     │ com.apple.ScreenTimeSettingsAgent                                                                 │          2 │
│ kTCCServiceLiverpool                     │ com.apple.businessservicesd                                                                       │          2 │
│ kTCCServiceAppleEvents                   │ com.docker.docker                                                                                 │          2 │
│ kTCCServiceSystemPolicyAppData           │ org.vim.MacVim                                                                                    │          5 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.apple.Terminal                                                                                │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.apple.Terminal                                                                                │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.apple.Terminal                                                                                │          2 │
│ kTCCServiceSystemPolicyAppBundles        │ com.apple.Terminal                                                                                │          0 │
│ kTCCServiceAppleEvents                   │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyNetworkVolumes    │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ /opt/homebrew/Cellar/openjdk/26.0.1/libexec/openjdk.jdk/Contents/Home/bin/java                    │          2 │
│ kTCCServiceFileProviderDomain            │ com.jgraph.drawio.desktop                                                                         │          2 │
│ kTCCServiceLiverpool                     │ com.apple.imtransferagent                                                                         │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ org.python.python                                                                                 │          2 │
│ kTCCServiceSystemPolicyAppBundles        │ com.todesktop.230313mzl4w4u92                                                                     │          0 │
│ kTCCServiceFileProviderDomain            │ com.anthropic.claudefordesktop                                                                    │          2 │
│ kTCCServiceSystemPolicyDownloadsFolder   │ com.anthropic.claudefordesktop                                                                    │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.anthropic.claudefordesktop                                                                    │          2 │
│ kTCCServiceSystemPolicyDocumentsFolder   │ com.anthropic.claudefordesktop                                                                    │          2 │
│ kTCCServiceLiverpool                     │ com.apple.aiml.mlpt.FedStats.MLHostPluginClassB                                                   │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.anthropic.claude-code                                                                         │          5 │
│ kTCCServiceAppleEvents                   │ com.todesktop.230313mzl4w4u92                                                                     │          2 │
│ kTCCServiceSystemPolicyDesktopFolder     │ com.anthropic.claude-code                                                                         │          2 │
│ kTCCServiceMicrophone                    │ com.anthropic.claudefordesktop                                                                    │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.microsoft.OneDrive                                                                            │          5 │
│ kTCCServiceSystemPolicyAppData           │ /Library/PrivilegedHelperTools/com.microsoft.autoupdate.helper                                    │          5 │
│ kTCCServiceMicrophone                    │ com.todesktop.230313mzl4w4u92                                                                     │          0 │
│ kTCCServiceSystemPolicyAppBundles        │ com.google.GoogleUpdater                                                                          │          2 │
│ kTCCServiceSystemPolicyAppData           │ com.todesktop.230313mzl4w4u92                                                                     │          5 │
╰──────────────────────────────────────────┴───────────────────────────────────────────────────────────────────────────────────────────────────┴────────────╯
```
<!--endsec-->

## notch

> [!TIP|label:references:]
> - [MacBook 刘海（Notch）增强工具推荐](https://utgd.net/article/20546)
> - [* How to fix Mac menu bar icons hidden by the MacBook notch](https://www.jessesquires.com/blog/2023/12/16/macbook-notch-and-menu-bar-fixes/)
> - [PSA: Reduce your menu bar spacing to fit more items](https://www.reddit.com/r/MacOS/comments/1dfu8w0/psa_reduce_your_menu_bar_spacing_to_fit_more_items/)
> - [Change the Menu Bar Item Spacing](https://www.reddit.com/r/MacOS/comments/vx7wb1/change_the_menu_bar_item_spacing/)
> - [2021 Macbook Pro 16" / 14" Menu Bar Size Limitation (Result of Display Notch)](https://discussions.apple.com/thread/253299524?sortBy=rank)

### reduce the menu bar item spacing

- read status
  ```bash
  $ defaults -currentHost read -globalDomain NSStatusItemSpacing
  $ defaults -currentHost read -globalDomain NSStatusItemSelectionPadding
  ```

- setup spacing
  ```bash
  $ defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
  $ defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8
  $ killall SystemUIServer
  ```

- revert
  ```bash
  $ defaults -currentHost delete -globalDomain NSStatusItemSpacing
  $ defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
  $ killall SystemUIServer
  ```
