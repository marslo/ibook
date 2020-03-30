<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [PuTTy](#putty)
  - [Backup PuTTy sessions](#backup-putty-sessions)
  - [Launchy PuTTy session as shortcut](#launchy-putty-session-as-shortcut)
  - [Backup PuTTy session](#backup-putty-session)
- [`wmic`](#wmic)
  - [Get the list of programs](#get-the-list-of-programs)
- [`regedit`](#regedit)
  - [Set `%USERPROFILE%` as `${HOME}` for **cygwin** (Inspired from here)](#set-%25userprofile%25-as-home-for-cygwin-inspired-from-here)
  - [Remove Graphics card context menu](#remove-graphics-card-context-menu)
  - [Set Environment Variables](#set-environment-variables)
  - [setx problem](#setx-problem)
  - [whoami check SID](#whoami-check-sid)
  - [Fingerprint Pro](#fingerprint-pro)
  - [Enable Gadgets](#enable-gadgets)
  - [issue about `"profile.d\Active"' is not recognized as an internal or external command`](#issue-about-profiled%5Cactive-is-not-recognized-as-an-internal-or-external-command)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## PuTTy
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

## `wmic`
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

## `regedit`
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

- others

> credit belongs to [How to Open Hidden System Folders with Windows’ Shell Command](https://www.howtogeek.com/257715/how-to-open-hidden-system-folders-with-windos-shell-command/)
> others: [Shell Commands to Access the Special Folders in Windows 10/8/7/Vista/XP](https://www.winhelponline.com/blog/shell-commands-to-access-the-special-folders/)

- `shell:AccountPictures` - `%AppData%\Microsoft\Windows\AccountPictures`
- `shell:AddNewProgramsFolder` - `Control Panel\All Control Panel Items\Get Programs`
- `shell:Administrative Tools` - `%AppData%\Microsoft\Windows\Start Menu\Programs\Administrative Tools`
- `shell:AppData` - `%AppData%`
- `shell:Application Shortcuts` - `%LocalAppData%\Microsoft\Windows\Application Shortcuts`
- `shell:AppsFolder` - `Applications`
- `shell:AppUpdatesFolder` - `Installed Updates`
- `shell:Cache` - `%LocalAppData%\Microsoft\Windows\INetCache`
- `shell:Camera Roll` - `%UserProfile%\Pictures\Camera Roll`
- `shell:CD Burning` - `%LocalAppData%\Microsoft\Windows\Burn\Burn`
- `shell:ChangeRemoveProgramsFolder` - `Control Panel\All Control Panel Items\Programs and Features`
- `shell:Common Administrative Tools` - `%ProgramData%\Microsoft\Windows\Start Menu\Programs\Administrative Tools`
- `shell:Common AppData` - `%ProgramData%`
- `shell:Common Desktop` - `%Public%\Desktop`
- `shell:Common Documents` - `%Public%\Documents`
- `shell:CommonDownloads` - `%Public%\Downloads`
- `shell:CommonMusic` - `%Public%\Music`
- `shell:CommonPictures` - `%Public%\Pictures`
- `shell:Common Programs` - `%ProgramData%\Microsoft\Windows\Start Menu\Programs`
- `shell:CommonRingtones` - `%ProgramData%\Microsoft\Windows\Ringtones`
- `shell:Common Start Menu` - `%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup`
- `shell:Common Startup` - `%ProgramData%\Microsoft\Windows\Start Menu\Programs\Startup`
- `shell:Common Templates` - `%ProgramData%\Microsoft\Windows\Templates`
- `shell:CommonVideo` - `%Public%\Videos`
- `shell:ConflictFolder` - `Control Panel\All Control Panel Items\Sync Center\Conflicts`
- `shell:ConnectionsFolder` - `Control Panel\All Control Panel Items\Network Connections`
- `shell:Contacts` - `%UserProfile%\Contacts`
- `shell:ControlPanelFolder` - `Control Panel\All Control Panel Items`
- `shell:Cookies` - `%LocalAppData%\Microsoft\Windows\INetCookies`
- `shell:Cookies\Low` - `%LocalAppData%\Microsoft\Windows\INetCookies\Low`
- `shell:CredentialManager` - `%AppData%\Microsoft\Credentials`
- `shell:CryptoKeys` - `%AppData%\Microsoft\Crypto`
- `shell:desktop` - `Desktop`
- `shell:device Metadata Store` - `%ProgramData%\Microsoft\Windows\DeviceMetadataStore`
- `shell:documentsLibrary` - `Libraries\Documents`
- `shell:downloads` - `%UserProfile%\Downloads`
- `shell:dpapiKeys` - `%AppData%\Microsoft\Protect`
- `shell:Favorites` - `%UserProfile%\Favorites`
- `shell:Fonts` - `%WinDir%\Fonts`
- `shell:Games` - `Games`
- `shell:GameTasks` - `%LocalAppData%\Microsoft\Windows\GameExplorer`
- `shell:History` - `%LocalAppData%\Microsoft\Windows\History`
- `shell:HomeGroupCurrentUserFolder` - `Homegroup\(user-name)`
- `shell:HomeGroupFolder` - `Homegroup`
- `shell:ImplicitAppShortcuts` - `%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned\ImplicitAppShortcuts`
- `shell:InternetFolder` - `Internet Explorer`
- `shell:Libraries` - `Libraries`
- `shell:Links` - `%UserProfile%\Links`
- `shell:Local AppData` - `%LocalAppData%`
- `shell:LocalAppDataLow` - `%UserProfile%\AppData\LocalLow`
- `shell:MusicLibrary` - `Libraries\Music`
- `shell:MyComputerFolder` - `This PC`
- `shell:My Music` - `%UserProfile%\Music`
- `shell:My Pictures` - `%UserProfile%\Pictures`
- `shell:My Video` - `%UserProfile%\Videos`
- `shell:NetHood` - `%AppData%\Microsoft\Windows\Network Shortcuts`
- `shell:NetworkPlacesFolder` - `Network`
- `shell:OneDrive` - `OneDrive`
- `shell:OneDriveCameraRoll` - `%UserProfile%\OneDrive\Pictures\Camera Roll`
- `shell:OneDriveDocuments` - `%UserProfile%\OneDrive\Documents`
- `shell:OneDriveMusic` - `%UserProfile%\OneDrive\Music`
- `shell:OneDrivePictures` - `%UserProfile%\OneDrive\Pictures`
- `shell:Personal` - `%UserProfile%\Documents`
- `shell:PicturesLibrary` - `Libraries\Pictures`
- `shell:PrintersFolder` - `All Control Panel Items\Printers`
- `shell:PrintHood` - `%AppData%\Microsoft\Windows\Printer Shortcuts`
- `shell:Profile` - `%UserProfile%`
- `shell:ProgramFiles` - `%ProgramFiles%`
- `shell:ProgramFilesCommon` - `%ProgramFiles%\Common Files`
- `shell:ProgramFilesCommonX64` - `%ProgramFiles%\Common Files (64-bit Windows only)`
- `shell:ProgramFilesCommonX86` - `%ProgramFiles(x86)%\Common Files (64-bit Windows only)`
- `shell:ProgramFilesX64` - `%ProgramFiles% (64-bit Windows only)`
- `shell:ProgramFilesX86` - `%ProgramFiles(x86)% (64-bit Windows only)`
- `shell:Programs` - `%AppData%\Microsoft\Windows\Start Menu\Programs`
- `shell:Public` - `%Public%`
- `shell:PublicAccountPictures` - `%Public%\AccountPictures`
- `shell:PublicGameTasks` - `%ProgramData%\Microsoft\Windows\GameExplorer`
- `shell:PublicLibraries` - `%Public%\Libraries`
- `shell:Quick Launch` - `%AppData%\Microsoft\Internet Explorer\Quick Launch`
- `shell:Recent` - `%AppData%\Microsoft\Windows\Recent`
- `shell:RecordedTVLibrary` - `Libraries\Recorded TV`
- `shell:RecycleBinFolder` - `Recycle Bin`
- `shell:ResourceDir` - `%WinDir%\Resources`
- `shell:Ringtones` - `%ProgramData%\Microsoft\Windows\Ringtones`
- `shell:Roamed Tile Images` - `%LocalAppData%\Microsoft\Windows\RoamedTileImages`
- `shell:Roaming Tiles` - `%AppData%\Microsoft\Windows\RoamingTiles`
- `shell:SavedGames` - `%UserProfile%\Saved Games`
- `shell:Screenshots` - `%UserProfile%\Pictures\Screenshots`
- `shell:Searches` - `%UserProfile%\Searches`
- `shell:SearchHistoryFolder` - `%LocalAppData%\Microsoft\Windows\ConnectedSearch\History`
- `shell:SearchHomeFolder` - `search-ms:`
- `shell:SearchTemplatesFolder` - `%LocalAppData%\Microsoft\Windows\ConnectedSearch\Templates`
- `shell:SendTo` - `%AppData%\Microsoft\Windows\SendTo`
- `shell:Start Menu` - `%AppData%\Microsoft\Windows\Start Menu`
- `shell:StartMenuAllPrograms` - `StartMenuAllPrograms`
- `shell:Startup` - `%AppData%\Microsoft\Windows\Start Menu\Programs\Startup`
- `shell:SyncCenterFolder` - `Control Panel\All Control Panel Items\Sync Center`
- `shell:SyncResultsFolder` - `Control Panel\All Control Panel Items\Sync Center\Sync Results`
- `shell:SyncSetupFolder` - `Control Panel\All Control Panel Items\Sync Center\Sync Setup`
- `shell:System` - `%WinDir%\System32`
- `shell:SystemCertificates` - `%AppData%\Microsoft\SystemCertificates`
- `shell:SystemX86` - `%WinDir%\SysWOW64`
- `shell:Templates` - `%AppData%\Microsoft\Windows\Templates`
- `shell:ThisPCDesktopFolder` - `Desktop`
- `shell:UsersFilesFolder` - `%UserProfile%`
- `shell:User Pinned` - `%AppData%\Microsoft\Internet Explorer\Quick Launch\User Pinned`
- `shell:UserProfiles` - `%HomeDrive%\Users`
- `shell:UserProgramFiles` - `%LocalAppData%\Programs`
- `shell:UserProgramFilesCommon` - `%LocalAppData%\Programs\Common`
- `shell:UsersLibrariesFolder` - `Libraries`
- `shell:VideosLibrary` - `Libraries\Videos`
- `shell:Windows` - `%WinDir%`
