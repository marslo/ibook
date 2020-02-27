<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Backup PuTTy sessions](#backup-putty-sessions)
- [Launchy PuTTy session as shortcut](#launchy-putty-session-as-shortcut)
- [Backup PuTTy session](#backup-putty-session)
- [Get the list of programs](#get-the-list-of-programs)
- [Set `%USERPROFILE%` as `${HOME}` for **cygwin** (Inspired from here)](#set-%25userprofile%25-as-home-for-cygwin-inspired-from-here)
- [Remove Graphics card context menu](#remove-graphics-card-context-menu)
- [Set Environment Variables](#set-environment-variables)
- [setx problem](#setx-problem)
- [whoami check SID](#whoami-check-sid)
- [Fingerprint Pro](#fingerprint-pro)
- [Enable Gadgets](#enable-gadgets)
- [issue about `"profile.d\Active"' is not recognized as an internal or external command`](#issue-about-profiled%5Cactive-is-not-recognized-as-an-internal-or-external-command)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Backup PuTTy sessions

```bat
C:> regedit /e "%userprofile%\desktop\putty-registry.reg" HKEY_CURRENT_USER\Software\Simontatham
```

### Launchy PuTTy session as shortcut

```bat
C:> [PuTTy.exe] -load [SessionName]
```

### Backup PuTTy session

```bat
C:> regedit /e "%userprofile%\desktop\putty-sessions.reg" HKEY_CURRENT_USER\Software\SimonTatham\PuTTY\Sessions
```

### Get the list of programs

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

### Set `%USERPROFILE%` as `${HOME}` for **cygwin** (Inspired from [here](http://stackoverflow.com/questions/225764/safely-change-home-directory-in-cygwin))

```bat
[15:55:36.30 C:\]
$ reg add HKCU\Environment /v HOME /t REG_EXPAND_SZ /d ^%USERPROFILE^%
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
