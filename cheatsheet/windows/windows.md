<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [process](#process)
  - [get the list of programs (`wmic`)](#get-the-list-of-programs-wmic)
  - [`ps auxf`](#ps-auxf)
- [shortcut](#shortcut)
  - [cmd admin](#cmd-admin)
  - [lansettings](#lansettings)
  - [Desktop Icon Settings](#desktop-icon-settings)
  - [Notification Area Icons](#notification-area-icons)
  - [Personalization](#personalization)
  - [Screen Saver](#screen-saver)
  - [System](#system)
  - [System Icon](#system-icon)
- [CLSID](#clsid)
  - [usage](#usage)
  - [details](#details)
- [`regedit`](#regedit)
  - [Set `%USERPROFILE%` as `${HOME}` for **cygwin**](#set-%25userprofile%25-as-home-for-cygwin)
  - [PuTTy](#putty)
  - [disable screensaver](#disable-screensaver)
  - [Remove Graphics card context menu](#remove-graphics-card-context-menu)
  - [Set Environment Variables](#set-environment-variables)
  - [setx problem](#setx-problem)
  - [whoami check SID](#whoami-check-sid)
  - [Fingerprint Pro](#fingerprint-pro)
  - [Enable Gadgets](#enable-gadgets)
  - [issue about `"profile.d\Active"' is not recognized as an internal or external command`](#issue-about-profiled%5Cactive-is-not-recognized-as-an-internal-or-external-command)
- [`shell`](#shell)
  - [<kbd>win</kbd> + <kbd>r</kbd>](#kbdwinkbd--kbdrkbd)
  - [details](#details-1)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> reference:
> - [windows commandline](https://www.windows-commandline.com/)
> - [TenForums](https://www.tenforums.com/)

## process
### get the list of programs (`wmic`)
```bat
[12:26:33.40 C:\Windows\SysWOW64]
$ wmic product get name,version
Name                                                                     Version
ALM-Platform Loader 11.5x                                                11.52.444.0
Microsoft Lync Web App Plug-in                                           15.8.8308.577
Google App Engine                                                        1.8.6.0
Microsoft Office Professional Plus 2010                                  14.0.6029.1000
Microsoft Office OneNote MUI (English) 2010                              14.0.6029.1000
...
```

### `ps auxf`
- `tasklist`
  ```bat
  > tasklist

  Image Name                     PID Session Name        Session#    Mem Usage
  ========================= ======== ================ =========== ============
  System Idle Process              0 Services                   0          4 K
  System                           4 Services                   0      8,236 K
  smss.exe                       520 Services                   0      1,164 K
  csrss.exe                      864 Services                   0      4,340 K
  wininit.exe                    960 Services                   0      4,744 K
  csrss.exe                      968 Console                    1     11,396 K
  services.exe                   108 Services                   0      7,776 K
  lsass.exe                       96 Services                   0     22,176 K
  ```

## [shortcut](https://www.tenforums.com/tutorials/86339-list-commands-open-control-panel-items-windows-10-a.html)
### cmd admin
- create shortcut by `New` -> `Shortcut`

![new](../../screenshot/win/cmd-admin-1.png)

- insert commands

![new](../../screenshot/win/cmd-admin-2.png)

- setup shortcut name

![cmdadm](../../screenshot/win/cmd-admin-3.png)

- setup `Run as administrator` for the shortcut

![cmdadm](../../screenshot/win/cmd-admin-5.png)

- move shortcut to `Start Menu`

![cmdadm](../../screenshot/win/cmd-admin-6.png)

![cmdadm](../../screenshot/win/cmd-admin-7.png)

### [lansettings](https://stackoverflow.com/a/3648396/2940319)
- Internet Settings
  ```bat
  > inetcpl.cpl
  ```

- Internet Settings with Connections Tab
  ```bat
  > rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,4
  ```

  [or](https://stackoverflow.com/a/45907190/2940319)

  ```bat
  > inetcpl.cpl ,4
  ```

  [or](https://stackoverflow.com/a/3648390/2940319)
  ```bat
  > control inetcpl.cpl,,4
  ```

- [proxy setup](https://stackoverflow.com/a/16453587/2940319)
  ```bat
  > REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer  /d "hhttp=proxy-url:port;https=proxy-url:port;ftp=proxy-url:port;socks=proxy-url:port;" /t REG_SZ /f
  ```

### Desktop Icon Settings
```bat
> rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
```

### Notification Area Icons
```bat
> explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}
```

### Personalization
```bat
> explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}
```

### Screen Saver
```bat
> rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1
```

### System
```bat
> control /name Microsoft.System
```

or

  ```bat
  > control sysdm.cpl
  ```

### System Icon
```bat
> explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0
```

## [CLSID](https://www.tenforums.com/tutorials/3123-clsid-key-guid-shortcuts-list-windows-10-a.html)
> reference [CLSID Key (GUID) Shortcuts List for Windows 10](https://www.tenforums.com/tutorials/3123-clsid-key-guid-shortcuts-list-windows-10-a.html)
> http://www.klapac.funsite.cz/mediawiki/index.php?title=List_of_Windows_10_CLSID_Key_(GUID)_Shortcuts

### usage
```bat
> explorer.exe shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}
```

or

  ```bat
  > explorer.exe /e,::{CLSID key number}
  ```

### details
[clsid](./clsid.md)

## `regedit`
### [Set `%USERPROFILE%` as `${HOME}` for **cygwin**](http://stackoverflow.com/questions/225764/safely-change-home-directory-in-cygwin)
```bat
[15:55:36.30 C:\]
$ reg add HKCU\Environment /v HOME /t REG_EXPAND_SZ /d ^%USERPROFILE^%
```

### PuTTy
- Backup PuTTy sessions
  ```bat
  C:> regedit /e "%userprofile%\desktop\putty-registry.reg" HKEY_CURRENT_USER\Software\Simontatham
  ```

- Launchy PuTTy session as shortcut
  ```bat
  C:> [PuTTy.exe] -load [SessionName]
  ```

- Backup PuTTy session
  ```bat
  C:> regedit /e "%userprofile%\desktop\putty-sessions.reg" HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions
  ```

### [disable screensaver](https://gist.github.com/Otiel/8d15d21593b481c1e525500762db52ba)
> reference [Configure screensaver command line](https://www.windows-commandline.com/configure-screensaver-command-line/)

```bat
REM  Disable the screensaver
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaverIsSecure /t REG_SZ /d 0 /f
REG ADD "HKCU\SOFTWARE\Policies\Microsoft\Windows\Control Panel\Desktop" /v ScreenSaveActive /t REG_SZ /d 0 /f
```
- or by using autohotkey
  ```ahk
  CoordMode, Mouse, Screen
  Loop
  {
    ; Move mouse
    MouseMove, 1, 1, 0, R
    ; Replace mouse to its original location
    MouseMove, -1, -1, 0, R
    ; Wait before moving the mouse again
    Sleep, 600000
  }
  return
  ```

  [or](https://autohotkey.com/board/topic/13510-move-mouse-when-not-in-use-to-disable-screensaver/)
  ```ahk
  #Persistent
  SetTimer, WatchCursor, 100
  return

  Loop
  {
    WatchCursor:
    MouseGetPos,X1 ,Y1
    Sleep 10000
    MouseGetPos,X2,Y2
    if X1=X2 And Y1=Y2
    {
      MouseMove,100,100
      Sleep, 10000
      MouseMove,200,200
      Sleep, 10000
    }
  }
  ```

### Remove Graphics card context menu
- Unregister igfxpph.dll
  ```bat
  [11:39:50.61 C:\]
  $ regsvr32 /u igfxpph.dll
  ```

- Remove register
    - Setting from regedit
    ```bat
    [11:47:10.20 C:\]
    $ REG DELETE "HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\igfxcui" /f
    ```

    - Setting from setx
    ```bat
    [11:47:10.20 C:\]
    $ REG DELETE "HKEY_CLASSES_ROOT\Directory\Background\shellex\ContextMenuHandlers\igfxcui" /f
    ```

### Set Environment Variables
- Set User Varialbe
  ```bat
  [13:48:11.20 C:\]
  $ setx VIM_HOME C:\Marslo\MyProgramFiles\Vim\vim74\gvim.exe
  ```

- Set System Variable
  ```bat
  [13:48:11.20 C:\]
  $ setx /M VIM_HOME C:\Marslo\MyProgramFiles\Vim\vim74\gvim.exe
  ```

#### details
[windows default environment variable](./env.md)

### setx problem

```bat
[14:31:18.67 C:\]
$ setx /M PATH %PATH%;%M2_HOME%\bin
ERROR: Invalid syntax. Default option is not allowed more than '2' time(s).
Type "SETX /?" for usage.
```

- Fix:
  ```bat
  [14:31:18.67 C:\]
  $ REG ADD "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v Path /t REG_SZ /d "%path%;%M2_HOME%\bin" /f
  ```

### whoami check SID

```bat
[15:59:24.12 C:\Windows\SysWOW64]
$ whoami /user
USER INFORMATION
----------------
User Name        SID
================ ===============================================
mj\marslo_jiao S-1-5-21-354581543-3608027983-2995495404-970613
```

### Fingerprint Pro

```bat
URL: www.lenovo.com
Help link: support.lenovo.com
Installation folder: C:\Program Files\Lenovo\Fingerprint Manager Pro\
Uninstaller: "C:\Program Files\InstallShield Installation Information\{314FAD12-F785-4471-BCE8-AB506642B9A1}\setup.exe" -runfromtemp -l0x0409 -removeonly
Estimated size: 70.21 MB
```

### Enable Gadgets

```bat
Windows Registry Editor Version 5.00
[HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar]
"TurnOffSidebar"=-
[HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Windows\Sidebar]
"TurnOffSidebar"=-
```

### [issue about `"profile.d\Active"' is not recognized as an internal or external command`](https://github.com/cmderdev/cmder/issues/1102#issuecomment-251550950)

- regedit
  ```bat
  [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor]
  "Autorun"="@CHCP 65001>nul"
  ```

- cmd
  ```bat
  $ REG ADD "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Command Processor" /v AutoRun /t REG_SZ /d "@CHCP 65001>nul" /f
  ```

## `shell`
### <kbd>win</kbd> + <kbd>r</kbd>
- appfolder
  ```bat
  > shell:appfolder
  ```

- startup folder
  ```bat
  > shell:startup
  > shell:Common Startup
  ```

### details
[shell:folder](./shell:folder.md)
