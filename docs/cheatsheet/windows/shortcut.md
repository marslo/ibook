<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [shortcuts](#shortcuts)
  - [cmd admin](#cmd-admin)
  - [cmd admin without UAC check via Task Scheduler](#cmd-admin-without-uac-check-via-task-scheduler)
  - [lansettings](#lansettings)
  - [Desktop Icon Settings](#desktop-icon-settings)
  - [Notification Area Icons](#notification-area-icons)
  - [Personalization](#personalization)
  - [Screen Saver](#screen-saver)
  - [System](#system)
  - [System Icon](#system-icon)
  - [user environment variables](#user-environment-variables)
- [icons](#icons)
- [reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
reference :
- [Windows Start | Run commands](https://ss64.com/nt/run.html)
- [List of Commands to Open Control Panel Items in Windows 10](https://www.tenforums.com/tutorials/86339-list-commands-open-control-panel-items-windows-10-a.html)

{% endhint %}

## shortcuts

### cmd admin
{% hint style='tip' %}
> references:
> - [Create Elevated Command Prompt Shortcut in Windows 10](https://www.tenforums.com/tutorials/72407-create-elevated-command-prompt-shortcut-windows-10-a.html)
> - [Open Elevated Command Prompt in Windows 10](https://www.tenforums.com/tutorials/2790-open-elevated-command-prompt-windows-10-a.html)
{% endhint %}

- create shortcut by `New` -> `Shortcut`

  <img src="../../screenshot/win/cmd-admin-1.png" width="500">

- insert commands

  <img src="../../screenshot/win/cmd-admin-2.png" width="500">

- setup shortcut name

  <img src="../../screenshot/win/cmd-admin-3.png" width="500">

- setup `Run as administrator` for the shortcut

  <img src="../../screenshot/win/cmd-admin-5.png" width="600">

- move shortcut to `Start Menu` :
  <kbd>Ctrl</kbd> + <kbd>r</kbd> -> `shell:Programs`

  <img src="../../screenshot/win/cmd-admin-6.png" width="400">
  ![cmdadm](../../screenshot/win/cmd-admin-7.png)


### cmd admin without UAC check via [Task Scheduler](https://docs.microsoft.com/en-us/windows/win32/taskschd/about-the-task-scheduler)
{% hint style='tip' %}
> references:
> - [Create Administrator Mode Shortcuts Without UAC Prompts in Windows 10](https://www.howtogeek.com/638652/create-administrator-mode-shortcuts-without-uac-prompts-in-windows-10/)
> - [How to Create Administrator Shortcut Without UAC Password Prompt](https://windowsloop.com/create-administrator-elevated-shortcut-without-uac-password-prompt/)
{% endhint %}

#### configuration in Task Scheduler
- <kbd>win</kbd> -> insert `Task Scheduler` -> <kbd>Enter</kbd>
- `Task Scheduler (Local)` -> `Create Task...`
  ![cmdadm](../../screenshot/win/cmd-admin-without-uac/admin-cmd-1.png)

- **General** Tab : -> Name: `RunAdminCMD` (or any you want) -> `[x] Run with highest privileges`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-2.png" width="600">

- **Conditions** Tab : -> [ ] `Start the task only if the computer is on AC power`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-3.png" width="600">

- **Actions** Tab : -> `New` -> **Browse Program/script:** -> select the path (i.e.: `C:\Windows\System32\cmd.exe`) -> `OK`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-4.png" width="600">

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-4-1.png" width="600">

  or

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-4-2.png" width="600">

- **Triggers** Tab : -> `New` -> **Begin the task:** : `At Startup` (or `At log on`) -> `OK`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-5.png" width="600">

- **Settings** Tab : -> `[ ] Stop the task if runing longer than: 3 days` -> `OK`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-6.png" width="600">

- `Save` and `Run`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-7.png" width="400">

#### shortcut setup
- <kbd>right click</kbd> -> `New` -> `Shortcut`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-8.png" width="360">

- **Type the location of the item:** : `schtasks /run /tn "<taskName>"` -> `Next`
  ```batch
  schtasks /run /tn "<taskName>"
  ```
  - i.e.:
    ```batch
    schtasks /run /tn "RunAdminCMD"
    ```

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-9.png" width="600">

- **Type a name of this shortbut:** : any name you want (i.e.: `Command Prompt`) -> `Finish`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-10.png" width="600">

- <kbd>right click</kbd> the new shortcut -> `Properties` -> **Shortcut** Tab : `Change Icon`

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-12.png" width="400">

- **Look for icons in this file** :
  ```batch
  %SystemRoot%\System32\imageres.dll
  ```
  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-13.png" width="300">

- put the shortcut to anywhere you want

  <img src="../../screenshot/win/cmd-admin-without-uac/admin-cmd-14.png" width="256">

### [lansettings](https://stackoverflow.com/a/3648396/2940319)
- Internet Settings
  ```batch
  > inetcpl.cpl
  ```

- Internet Settings with Connections Tab
  ```batch
  > rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,4
  ```

  [or](https://stackoverflow.com/a/45907190/2940319)

  ```batch
  > inetcpl.cpl ,4
  ```

  [or](https://stackoverflow.com/a/3648390/2940319)
  ```batch
  > control inetcpl.cpl,,4
  ```

- [proxy setup](https://stackoverflow.com/a/16453587/2940319)
  ```batch
  > REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyServer  /d "hhttp=proxy-url:port;https=proxy-url:port;ftp=proxy-url:port;socks=proxy-url:port;" /t REG_SZ /f
  ```

### Desktop Icon Settings
```batch
> rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0
```

### Notification Area Icons
```batch
> explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}
```

### Personalization
```batch
> explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}
```

### Screen Saver
```batch
> rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1
```

### System
```batch
> control /name Microsoft.System
```

or

  ```batch
  > control sysdm.cpl
  ```

### System Icon
```batch
> explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0
```

### user environment variables
```batch
rundll32.exe sysdm.cpl,EditEnvironmentVariables
```

## [icons](https://www.digitalcitizen.life/where-find-most-windows-10s-native-icons/)
- `%SystemRoot%\System32\shell32.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-shell32.dll.png" width="300">

- `%SystemRoot%\system32\imageres.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-imageres.dll.png" width="300">

- `%systemroot%\system32\DeviceCenter.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-DeviceCenter.dll.png" width="300">

- `%systemroot%\explorer.exe`

  <img src="../../screenshot/win/shortcut-icons/icon-explorer.exe.png" width="300">

- `%systemroot%\system32\ddores.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-ddores.dll.png" width="300">

- `%systemroot%\system32\mmcndmgr.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-mmcndmgr.dll.png" width="300">

- `%systemroot%\system32\mmres.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-mmres.dll.png" width="300">

- `%systemroot%\system32\netcenter.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-netcenter.dll.png" width="300">

- `%systemroot%\system32\networkexplorer.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-networkexplorer.dll.png" width="300">

- `%systemroot%\system32\pnidui.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-pnidui.dll.png" width="300">

- `%systemroot%\system32\setupapi.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-setupapi.dll.png" width="300">

- `%systemroot%\system32\compstui.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-compstui.dll.png" width="300">

- `%systemroot%\system32\dsuiext.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-dsuiext.dll.png" width="300">

- `%systemroot%\system32\mstscax.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-mstscax.dll.png" width="300">

- `%systemroot%\system32\comres.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-comres.dll.png" width="300">

- `%systemroot%\system32\mstsc.exe`

  <img src="../../screenshot/win/shortcut-icons/icon-mstsc.exe.png" width="300">

- `%systemroot%\system32\actioncentercpl.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-actioncentercpl.dll.png" width="300">

- `%systemroot%\system32\aclui.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-aclui.dll.png" width="300">

- `%systemroot%\system32\autoplay.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-autoplay.dll.png" width="300">

- `%systemroot%\system32\comctl32.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-comctl32.dll.png" width="300">

- `%systemroot%\system32\xwizards.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-xwizards.dll.png" width="300">

- `%systemroot%\system32\ncpa.cpl`

  <img src="../../screenshot/win/shortcut-icons/icon-ncpa.cpl.png" width="300">

- `%systemroot%\system32\url.dll`

  <img src="../../screenshot/win/shortcut-icons/icon-url.dll.png" width="300">

- `%systemroot%\system32\pifmgr.dll`
- `%systemroot%\system32\accessibilitycpl.dl`
- `%systemroot%\system32\moricons.dll`
- `%systemroot%system32\netshell.dll`
- `%systemroot%\system32\sensorscpl.dll`
- `%systemroot%\system32\wmploc.dll`
- `%systemroot%\system32\wpdshext.dll`
- `systemroot%\system32\ieframe.dll`
- `%systemroot%\system32\wiashext.dll`

## reference
| Control Panel Item                               | `Commands`                                                                                                                                                                                 |
|:-------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Add a Device wizard                              | `%windir%\System32\DevicePairingWizard.exe`                                                                                                                                                |
| Add Hardware wizard                              | `%windir%\System32\hdwwiz.exe`                                                                                                                                                             |
| Add a Printer wizard                             | `rundll32.exe shell32.dll,SHHelpShortcuts_RunDLL AddPrinter`                                                                                                                               |
| Additional Clocks                                | `rundll32.exe shell32.dll,Control_RunDLL timedate.cpl,,1`                                                                                                                                  |
| Administrative Tools                             | `control /name Microsoft.AdministrativeTools` <br> OR <br> `control admintools`                                                                                                            |
| AutoPlay                                         | `control /name Microsoft.AutoPlay`                                                                                                                                                         |
| Backup and Restore (Windows 7)                   | `control /name Microsoft.BackupAndRestoreCenter`                                                                                                                                           |
| BitLocker Drive Encryption                       | `control /name Microsoft.BitLockerDriveEncryption`                                                                                                                                         |
| Color and Appearance                             | `explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageColorization`                                                                                      |
| Color Management                                 | `control /name Microsoft.ColorManagement`                                                                                                                                                  |
| Credential Manager                               | `control /name Microsoft.CredentialManager`                                                                                                                                                |
| Date and Time (Date and Time)                    | `control /name Microsoft.DateAndTime` <br> OR <br> `control timedate.cpl` <br> OR <br> `control date/time` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL timedate.cpl,,0`          |
| Date and Time (Additional Clocks)                | `rundll32.exe shell32.dll,Control_RunDLL timedate.cpl,,1`                                                                                                                                  |
| Default Programs                                 | `control /name Microsoft.DefaultPrograms`                                                                                                                                                  |
| Desktop Background                               | `explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921} -Microsoft.Personalization\pageWallpaper`                                                                                         |
| Desktop Icon Settings                            | `rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0`                                                                                                                                      |
| Device Manager                                   | `control /name Microsoft.DeviceManager` <br> OR <br> `control hdwwiz.cpl` <br> OR <br> `devmgmt.msc`                                                                                       |
| Devices and Printers                             | `control /name Microsoft.DevicesAndPrinters` <br> OR <br> `control printers`                                                                                                               |
| Ease of Access Center                            | `control /name Microsoft.EaseOfAccessCenter` <br> OR <br> `control access.cpl`                                                                                                             |
| File Explorer Options (General tab)              | `control /name Microsoft.FolderOptions` <br> OR <br> `control folders` <br> OR <br> `rundll32.exe shell32.dll,Options_RunDLL 0`                                                            |
| File Explorer Options (View tab)                 | `rundll32.exe shell32.dll,Options_RunDLL 7`                                                                                                                                                |
| File Explorer Options (Search tab)               | `rundll32.exe shell32.dll,Options_RunDLL 2`                                                                                                                                                |
| File History                                     | `control /name Microsoft.FileHistory`                                                                                                                                                      |
| Fonts                                            | `control /name Microsoft.Fonts` <br> OR <br> `control fonts`                                                                                                                               |
| Game Controllers                                 | `control /name Microsoft.GameControllers` <br> OR <br> `control joy.cpl`                                                                                                                   |
| Get Programs                                     | `control /name Microsoft.GetPrograms` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,1`                                                                                 |
| HomeGroup                                        | `control /name Microsoft.HomeGroup`                                                                                                                                                        |
| Indexing Options                                 | `control /name Microsoft.IndexingOptions` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL srchadmin.dll`                                                                             |
| Infrared                                         | `control /name Microsoft.Infrared` <br> OR <br> `control irprops.cpl` <br> OR `control /name Microsoft.InfraredOptions`                                                                    |
| Internet Properties (General tab)                | `control /name Microsoft.InternetOptions` <br> OR <br> `control inetcpl.cpl` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,0`                                         |
| Internet Properties (Security tab)               | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,1`                                                                                                                                   |
| Internet Properties (Privacy tab)                | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,2`                                                                                                                                   |
| Internet Properties (Content tab)                | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,3`                                                                                                                                   |
| Internet Properties (Connections tab)            | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,4`                                                                                                                                   |
| Internet Properties (Programs tab)               | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,5`                                                                                                                                   |
| Internet Properties (Advanced tab)               | `rundll32.exe shell32.dll,Control_RunDLL inetcpl.cpl,,6`                                                                                                                                   |
| iSCSI Initiator                                  | `control /name Microsoft.iSCSIInitiator`                                                                                                                                                   |
| Keyboard                                         | `control /name Microsoft.Keyboard` <br> OR <br> `control keyboard`                                                                                                                         |
| Language                                         | `control /name Microsoft.Language`                                                                                                                                                         |
| Mouse Properties (Buttons tab 0)                 | `control /name Microsoft.Mouse` <br> OR <br> `control main.cpl`<br> OR <br> `control mouse` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL main.cpl,,0`                             |
| Mouse Properties (Pointers tab 1)                | `control main.cpl,,1` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL main.cpl,,1`                                                                                                   |
| Mouse Properties (Pointer Options tab 2)         | `control main.cpl,,2` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL main.cpl,,2`                                                                                                   |
| Mouse Properties (Wheel tab 3)                   | `control main.cpl,,3` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL main.cpl,,3`                                                                                                   |
| Mouse Properties (Hardware tab 4)                | `control main.cpl,,4`<br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL main.cpl,,4`                                                                                                    |
| Network and Sharing Center                       | `control /name Microsoft.NetworkAndSharingCenter`                                                                                                                                          |
| Network Connections                              | `control ncpa.cpl` <br> OR <br> `control netconnections`                                                                                                                                   |
| Network Setup Wizard                             | `control netsetup.cpl`                                                                                                                                                                     |
| Notification Area Icons                          | `explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9}`                                                                                                                                  |
| ODBC Data Source Administrator                   | `control odbccp32.cpl`                                                                                                                                                                     |
| Offline Files                                    | `control /name Microsoft.OfflineFiles`                                                                                                                                                     |
| Performance Options (Visual Effects)             | `%windir%\system32\SystemPropertiesPerformance.exe`                                                                                                                                        |
| Performance Options (Data Execution Prevention)  | `%windir%\system32\SystemPropertiesDataExecutionPrevention.exe`                                                                                                                            |
| Personalization                                  | `explorer shell:::{ED834ED6-4B5A-4bfe-8F11-A626DCB6A921}`                                                                                                                                  |
| Phone and Modem                                  | `control /name Microsoft.PhoneAndModem`<br> OR <br> `control telephon.cpl`                                                                                                                 |
| Power Options                                    | `control /name Microsoft.PowerOptions` <br>OR<br> `control powercfg.cpl`                                                                                                                   |
| Power Options - Advanced settings                | `control powercfg.cpl,,1`                                                                                                                                                                  |
| Power Options - Create a Power Plan              | `control /name Microsoft.PowerOptions /page pageCreateNewPlan`                                                                                                                             |
| Power Options - Edit Plan Settings               | `control /name Microsoft.PowerOptions /page pagePlanSettings`                                                                                                                              |
| Power Options - System Settings                  | `control /name Microsoft.PowerOptions /page pageGlobalSettings`                                                                                                                            |
| Presentation Settings                            | `%windir%\system32\PresentationSettings.exe`                                                                                                                                               |
| Programs and Features                            | `control /name Microsoft.ProgramsAndFeatures` <br> OR <br> `control appwiz.cpl`                                                                                                            |
| Recovery                                         | `control /name Microsoft.Recovery`                                                                                                                                                         |
| Region (Formats tab)                             | `control /name Microsoft.RegionAndLanguage` <br> OR `control /name Microsoft.RegionalAndLanguageOptions /page /p:"Formats"` <br> OR <br> `control intl.cpl`<br> OR `control international` |
| Region (Location tab)                            | `control /name Microsoft.RegionalAndLanguageOptions /page /p:"Location"`                                                                                                                   |
| Region (Administrative tab)                      | `control /name Microsoft.RegionalAndLanguageOptions /page /p:"Administrative"`                                                                                                             |
| RemoteApp and Desktop Connections                | `control /name Microsoft.RemoteAppAndDesktopConnections`                                                                                                                                   |
| Scanners and Cameras                             | `control /name Microsoft.ScannersAndCameras` <br> OR <br> `control sticpl.cpl`                                                                                                             |
| Screen Saver Settings                            | `rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,1`                                                                                                                                      |
| Security and Maintenance                         | `control /name Microsoft.ActionCenter` <br> OR <br> `control wscui.cpl`                                                                                                                    |
| Set Associations                                 | `control /name Microsoft.DefaultPrograms /page pageFileAssoc`                                                                                                                              |
| Set Default Programs                             | `control /name Microsoft.DefaultPrograms /page pageDefaultProgram`                                                                                                                         |
| Set Program Access and Computer Defaults         | `rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,3`                                                                                                                                    |
| Sound (Playback tab)                             | `control /name Microsoft.Sound` <br> OR <br> `control mmsys.cpl` <br> OR `%windir%\System32\rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,0`                                          |
| Sound (Recording tab)                            | `%windir%\System32\rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,1`                                                                                                                   |
| Sound (Sounds tab)                               | `%windir%\System32\rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,2`                                                                                                                   |
| Sound (Communications tab)                       | `%windir%\System32\rundll32.exe shell32.dll,Control_RunDLL mmsys.cpl,,3`                                                                                                                   |
| Speech Recognition                               | `control /name Microsoft.SpeechRecognition`                                                                                                                                                |
| Storage Spaces                                   | `control /name Microsoft.StorageSpaces`                                                                                                                                                    |
| Sync Center                                      | `control /name Microsoft.SyncCenter`                                                                                                                                                       |
| System                                           | `control /name Microsoft.System`<br> OR <br> `control sysdm.cpl`                                                                                                                           |
| System Icons                                     | `explorer shell:::{05d7b0f4-2121-4eff-bf6b-ed3f69b894d9} \SystemIcons,,0`                                                                                                                  |
| System Properties (Computer Name)                | `%windir%\System32\SystemPropertiesComputerName.exe`                                                                                                                                       |
| System Properties (Hardware)                     | `%windir%\System32\SystemPropertiesHardware.exe`                                                                                                                                           |
| System Properties (Advanced)                     | `%windir%\System32\SystemPropertiesAdvanced.exe`                                                                                                                                           |
| System Properties (System Protection)            | `%windir%\System32\SystemPropertiesProtection.exe`                                                                                                                                         |
| System Properties (Remote)                       | `%windir%\System32\SystemPropertiesRemote.exe`                                                                                                                                             |
| Tablet PC Settings                               | `control /name Microsoft.TabletPCSettings`                                                                                                                                                 |
| Text to Speech                                   | `control /name Microsoft.TextToSpeech`                                                                                                                                                     |
| Troubleshooting                                  | `explorer shell:::{26EE0668-A00A-44D7-9371-BEB064C98683}\0\::{C58C4893-3BE0-4B45-ABB5-A63E4B8C8651}`                                                                                       |
| User Accounts                                    | `control /name Microsoft.UserAccounts`<br> OR <br> `control userpasswords`                                                                                                                 |
| User Accounts (netplwiz)                         | `netplwiz`<br> OR <br> `control userpasswords2`                                                                                                                                            |
| Windows Defender Firewall                        | `control /name Microsoft.WindowsFirewall` <br> OR <br> `control firewall.cpl`                                                                                                              |
| Windows Defender Firewall Allowed apps           | `explorer shell:::{4026492F-2F69-46B8-B9BF-5654FC07E423} -Microsoft.WindowsFirewall\pageConfigureApps`                                                                                     |
| Windows Defender Firewall with Advanced Security | `%WinDir%\System32\WF.msc`                                                                                                                                                                 |
| Windows Features                                 | `%windir%\System32\OptionalFeatures.exe` <br> OR <br> `rundll32.exe shell32.dll,Control_RunDLL appwiz.cpl,,2`                                                                              |
| Windows Mobility Center                          | `control /name Microsoft.MobilityCenter`                                                                                                                                                   |
| Work Folders                                     | `%windir%\System32\WorkFolders.exe`                                                                                                                                                        |
