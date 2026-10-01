<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [get file metadata](#get-file-metadata)
  - [mdls - metadata list](#mdls---metadata-list)
  - [`/usr/bin/xattr`](#usrbinxattr)
  - [exiftool](#exiftool)
  - [sips - images](#sips---images)
  - [identify - images](#identify---images)
- [copy path](#copy-path)
  - [copy STDOUT into clipboard](#copy-stdout-into-clipboard)
  - [copy path from finder](#copy-path-from-finder)
- [reset file associations](#reset-file-associations)
- [add snippets for input](#add-snippets-for-input)
  - [enable technical symbols](#enable-technical-symbols)
  - [and snippets](#and-snippets)
  - [finally](#finally)
  - [unicode hex input](#unicode-hex-input)
- [others](#others)
  - [install font](#install-font)
  - [extract](#extract)
  - [modify font in plist](#modify-font-in-plist)
  - [show process details](#show-process-details)
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
  - [check User-level TCC permissions database](#check-user-level-tcc-permissions-database)
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

### `/usr/bin/xattr`

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

> [!NOTE|label:references:]
> - [xattr](https://www.oreilly.com/library/view/macintosh-terminal-pocket/9781449328962/re38.html)
> - [How do I remove the "extended attributes" on a file in Mac OS X?](https://stackoverflow.com/a/58616002/2940319)

```bash
# init
$ touch test.txt
$ /usr/bin/xattr -l test.txt
```

```bash
# create attributes
$ /usr/bin/xattr -w com.example.color blue test.txt
$ /usr/bin/xattr -l test.txt
com.example.color: blue
```

```bash
# print attributes
$ /usr/bin/xattr -p com.example.color test.txt
blue
```

```bash
# clear attributes
$ /usr/bin/xattr -d com.example.color test.txt
# or
$ /usr/bin/xattr -c test.txt
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

## copy path
### copy STDOUT into clipboard

> [!NOTE]
> - `pbcopy` for macOS
> - `xclip` for Linux

```bash
$ <cmd> | pbcopy
```

```bash
# example
$ command cat file | pbcopy
$ pwd | pbcopy
$ printf '%s' "${PWD}" | pbcopy            # without newline
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
### enable technical symbols

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

```bash
# install the application on the device
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

### reduce the menu bar item spacing

```bash
# read status
$ defaults -currentHost read -globalDomain NSStatusItemSpacing
$ defaults -currentHost read -globalDomain NSStatusItemSelectionPadding
```

```bash
# setup spacing
$ defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
$ defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8
$ killall SystemUIServer
```

```bash
# revert
$ defaults -currentHost delete -globalDomain NSStatusItemSpacing
$ defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
$ killall SystemUIServer
```
