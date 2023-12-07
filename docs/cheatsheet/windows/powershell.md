<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [basic](#basic)
  - [echo](#echo)
- [system](#system)
  - [check current user is admin](#check-current-user-is-admin)
  - [maximum path length limitation](#maximum-path-length-limitation)
  - [list installed appx](#list-installed-appx)
  - [install system apps](#install-system-apps)
  - [restricted strategy](#restricted-strategy)
  - [enable pxe on the distribution point](#enable-pxe-on-the-distribution-point)
  - [search](#search)
  - [cortana](#cortana)
  - [install ssh-agent](#install-ssh-agent)
  - [deploy windows 10 in a test lab using configuration manager](#deploy-windows-10-in-a-test-lab-using-configuration-manager)
- [modules](#modules)
  - [list installed modules](#list-installed-modules)
  - [get package source](#get-package-source)
- [scripts](#scripts)
  - [environment](#environment)
  - [timezone](#timezone)
- [step-by-step guide to setup two-tier pki environment](#step-by-step-guide-to-setup-two-tier-pki-environment)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> - to execute powershell as administrator
>  - right click 'Run As Administrator'
>  - <kbd>ctrl</kbd>+<kbd>r</kbd> » `powershell` » <kbd>ctrl</kbd> + <kbd>shift</kbd> + <kbd>enter</kbd>
> - to verify powershell running as admin
>   ```powershell
>   > (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
>   True
>   ```
{% endhint %}

## basic
### echo
> references
> - [Redirection](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.2)
> - [Out-Null](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/out-null?view=powershell-7.2)

```powershell
Write-Warning "hello"
Write-Error "hello"
Write-Output "hello" | Out-Null
```

## system
### check current user is admin

{% hint style='info' %}
> references:
> - [How to: Tell if a PowerShell script is running as the Administrator](https://colinmackay.scot/2019/08/10/how-to-tell-if-a-powershell-script-is-running-as-the-administrator/)
> - [Get started with OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
> - [Universal test for Admin privileges](https://stackoverflow.com/a/35817852/2940319)
> - [well-known SIDs](https://learn.microsoft.com/en-US/windows-server/identity/ad-ds/manage/understand-security-identifiers#well-known-sids)
>   - `S-1-5-32-544` : `Administrators`
>   - `S-1-5-32-545` : `Users`
>   - `S-1-5-32-547` : `Power Users`
> - [Powershell Admin rights dont work in Windows Forms](https://stackoverflow.com/questions/68651418/powershell-admin-rights-dont-work-in-windows-forms)
{% endhint %}

```powershell
> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
True

# or
> $isAdmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole("Administrators")
> echo $isAdmin
True

# or via SID
> $isAdmin = (new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole(([System.Security.Principal.SecurityIdentifier]"S-1-5-32-544"))
> echo $isAdmin
True
```

![check current permissions](../../screenshot/win/powershell/windows-ssh-1.png)

- or
  ```powershell
  $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
  if (-not ($currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)))
  {
      Write-Warning "This script needs to be running as the administrator."
      Exit 1
  }

  Write-Host "You are running as the administrator."
  ```

- others
  ```bash
  > echo $currentPrincipal

  Identity     : System.Security.Principal.WindowsIdentity
  UserClaims   : {http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name: WORKGROUP\marslo,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid:
                 S-1-5-21-1801674531-527237240-682003330-164699,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid: S-1-1-0,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid: S-1-2-0...}
  DeviceClaims : {}
  Claims       : {http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name: WORKGROUP\marslo,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/primarysid:
                 S-1-5-21-1801674531-527237240-682003330-164699,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid: S-1-1-0,
                 http://schemas.microsoft.com/ws/2008/06/identity/claims/groupsid: S-1-2-0...}
  Identities   : {WORKGROUP\marslo}
  ```

### maximum path length limitation

{% hint style='info' %}
> references:
> - [Maximum Path Length Limitation](https://learn.microsoft.com/en-us/windows/win32/fileio/maximum-file-path-limitation?tabs=registry)
> - [Overcoming long path problem in Windows/PowerShell](https://igorpuhalo.wordpress.com/2019/08/29/overcoming-long-path-problem-in-powershell/)
{% endhint %}

```powershell
> New-ItemProperty `
      -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" `
      -Name "LongPathsEnabled" `
      -Value 1 `
      -PropertyType DWORD `
      -Force
```

- or via modify regedit
  ```batch
  > REG ADD "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t REG_DWORD /d 0x00000001 /f

  REM .reg
  REM Windows Registry Editor Version 5.00
  REM [HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FileSystem]
  REM "LongPathsEnabled"=dword:00000001
  ```

### list installed appx

{% hint style='info' %}
> references:
> - [Get-AppxPackage](https://www.pdq.com/powershell/get-appxpackage/)
> - [List all installed APPX packages, along with their display names](https://social.technet.microsoft.com/Forums/azure/en-US/06a7fed6-7775-4542-bf32-afbe8a48d49b/list-all-installed-appx-packages-along-with-their-display-names?forum=ITCG)
> - [How to view installed apps with PowerShell on Windows 10](https://pureinfotech.com/view-installed-apps-powershell-windows-10/)
{% endhint %}

```powershell
> Get-AppxPackage –AllUsers | Select Name, PackageFullName

# or
> winget list
```

- or search via keywords
  ```powershell
  PS C:\Users\marslo> Get-AppxPackage -Name *edge*
  Name              : Microsoft.MicrosoftEdgeDevToolsClient
  Publisher         : CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
  Architecture      : Neutral
  ResourceId        : neutral
  Version           : 1000.19041.1023.0
  PackageFullName   : Microsoft.MicrosoftEdgeDevToolsClient_1000.19041.1023.0_neutral_neutral_8wekyb3d8bbwe
  InstallLocation   : C:\Windows\SystemApps\Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe
  IsFramework       : False
  PackageFamilyName : Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe
  PublisherId       : 8wekyb3d8bbwe
  IsResourcePackage : False
  IsBundle          : False
  IsDevelopmentMode : False
  NonRemovable      : True
  IsPartiallyStaged : False
  SignatureKind     : System
  Status            : Ok

  # or
  > winget list chrome
  Name          Id            Version       Source
  -------------------------------------------------
  Google Chrome Google.Chrome 113.0.5672.93 winget
  ```

- or
  ```powershell
  Get-AppxPackage | Get-AppxPackageManifest |
    ForEach-Object {
      $_.Package.Applications.Application.VisualElements.DisplayName
    }
  ```

  - or exclude all `ms-`
    ```
    Get-AppxPackage | Get-AppxPackageManifest |
      ForEach-Object {
          $_.Package.Applications.Application.VisualElements.DisplayName
      } | Where-Object {
          $_ -notmatch '^ms'
      }
    ```

- or show name and display name
  ```powershell
  $Packages=Get-AppxPackage -PackageTypeFilter Main
  $PackageManager = New-Object Windows.Management.Deployment.PackageManager
  foreach ($Package in $Packages) {
    Write-Output $Package.PackageFullName
    try {
      $PackageUWP = $PackageManager.FindPackage($Package.PackageFullName)
      Write-Output $PackageUWP.DisplayName
      Write-Output ''
    }
    catch {
      throw
      break
    }
  }
  Remove-Variable Packages,PackageManager,Package,PackageUWP
  ```

### install system apps

{% hint style='info' %}
> references:
> - [SearchUI.exe Suspended Error on Windows 10 / 11 Fix](https://thegeekpage.com/searchui-exe-suspended-error/)
> - [How to Fix SearchUI.exe Suspended on Windows 10](https://appuals.com/how-to-fix-searchui-exe-suspended-on-windows-10/)
{% endhint %}

```powershell
> Get-AppXPackage -AllUsers | Where-Object {$_.InstallLocation -like "*SystemApps*"} | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

- [repaire all appx](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-search-bar-not-allowing-me-to-type/9fe73ae6-2da7-4e59-8aa1-d9518a58781b)
  ```powershell
  > Get-AppxPackage Microsoft.Windows.ShellExperienceHost | foreach {Add-AppxPackage -register "$($_.InstallLocation)\appxmanifest.xml" -DisableDevelopmentMode}
  > Get-AppXPackage | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
  ```

### restricted strategy

{% hint style='info' %}
> references:
> - [How to fix search problems in Windows 10](https://www.windowscentral.com/how-fix-taskbar-search-not-working-windows-10)
> - [Fix problems in Windows Search](https://learn.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/fix-problems-in-windows-search)
{% endhint %}

- check policy
  ```powershell
  > Get-ExecutionPolicy
  ```

- modify policy
  ```powershell
  > Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Unrestricted
  ```

- revert to previous policy
  ```powershell
  > Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy <policy>
  # i.e.:
  > Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Restricted
  ```

### enable pxe on the distribution point
```powershell
> WDSUTIL.exe /Set-Server /AnswerClients:None

# check macaddress
> (Get-NetAdapter "Ethernet").MacAddress
```

### search

{% hint style='info' %}
> references:
> - [Windows 10 - Search bar not allowing me to type](https://answers.microsoft.com/en-us/windows/forum/all/windows-10-search-bar-not-allowing-me-to-type/9fe73ae6-2da7-4e59-8aa1-d9518a58781b)
> - [Troubleshoot Windows Search performance](https://learn.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/windows-search-performance-issues?source=recommendations#defragment-the-index-database)
{% endhint %}

```powershell
> Get-AppXPackage -Name Microsoft.Windows.Search
Name              : Microsoft.Windows.Search
Publisher         : CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
Architecture      : Neutral
ResourceId        : neutral
Version           : 1.14.9.19041
PackageFullName   : Microsoft.Windows.Search_1.14.9.19041_neutral_neutral_cw5n1h2txyewy
InstallLocation   : C:\Windows\SystemApps\Microsoft.Windows.Search_cw5n1h2txyewy
IsFramework       : False
PackageFamilyName : Microsoft.Windows.Search_cw5n1h2txyewy
PublisherId       : cw5n1h2txyewy
IsResourcePackage : False
IsBundle          : False
IsDevelopmentMode : False
NonRemovable      : True
IsPartiallyStaged : False
SignatureKind     : System
Status            : Ok
```

#### scan health and restore health
```batch
> DISM.exe /Online /Cleanup-image /Scanhealth
> DISM.exe /Online /Cleanup-image /Restorehealth
```

#### execute searching diagnostic
```batch
> msdt -ep WindowsHelp id SearchDiagnostic
```

#### [defragment the index database](https://learn.microsoft.com/en-us/troubleshoot/windows-client/shell-experience/windows-search-performance-issues?source=recommendations#defragment-the-index-database)
```batch
> sc config wsearch start=disabled
> net stop wsearch
> esentutl.exe /d %AllUsersProfile%\Microsoft\Search\Data\Applications\Windows\Windows.edb
> sc config wsearch start=delayed-auto
> net start wsearch
```
#### reinstall windows search
```powershell
> Get-AppXPackage -Name Microsoft.Windows.Search | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

#### reinstall cortana
```powershell
> Get-AppXPackage -Name Microsoft.Windows.Cortana | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

#### reinstall StartMenuExperienceHost
```powershell
> taskkill /f /im explorer.exe
SUCCESS: The process "explorer.exe" with PID 20256 has been terminated.
> Get-AppXPackage -Name Microsoft.Windows.StartMenuExperienceHost | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
> start explorer
```

- status
  ```powershell
  PS C:\> Get-AppXPackage -Name Microsoft.Windows.StartMenuExperienceHost                                                                                                                                                                                                                                                                                                                                           Name              : Microsoft.Windows.StartMenuExperienceHost                                                                         Publisher         : CN=Microsoft Windows, O=Microsoft Corporation, L=Redmond, S=Washington, C=US                                      Architecture      : Neutral
  ResourceId        : neutral
  Version           : 10.0.19041.1023
  PackageFullName   : Microsoft.Windows.StartMenuExperienceHost_10.0.19041.1023_neutral_neutral_cw5n1h2txyewy
  InstallLocation   : C:\Windows\SystemApps\Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
  IsFramework       : False
  PackageFamilyName : Microsoft.Windows.StartMenuExperienceHost_cw5n1h2txyewy
  PublisherId       : cw5n1h2txyewy
  IsResourcePackage : False
  IsBundle          : False
  IsDevelopmentMode : False
  NonRemovable      : True
  IsPartiallyStaged : False
  SignatureKind     : System
  Status            : Ok
  ```

#### re-build ShellExperienceHost
```batch
> taskkill /f /im explorer.exe
> taskkill /f /im shellexperiencehost.exe
> timeout /t 3 /NOBREAK > nul
> del %localappdata%\Packages\Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy\TempState\* /q
> timeout /t 2 /NOBREAK > nul
> start explorer
> @echo on
```


### cortana
#### install

{% hint style='info' %}
> references:
> - [SearchUI.exe Suspended Error on Windows 10 / 11 Fix](https://thegeekpage.com/searchui-exe-suspended-error/)
> - [How to Fix SearchUI.exe Suspended on Windows 10](https://appuals.com/how-to-fix-searchui-exe-suspended-on-windows-10/)
{% endhint %}

```powershell
> Get-AppXPackage -Name Microsoft.Windows.Cortana | Foreach {Add-AppxPackage -DisableDevelopmentMode -Register "$($_.InstallLocation)\AppXManifest.xml"}
```

- remove the cache
  ```powershell
  > RD /S /Q "%LOCALAPPDATA%\Packages\Microsoft.Windows.Cortana_cw5n1h2txyewy\RoamingState"
  ```

#### remove
```powershell
> Get-AppxPackage -AllUsers Microsoft.549981C3F5F10
Name                   : Microsoft.549981C3F5F10
Publisher              : CN=Microsoft Corporation, O=Microsoft Corporation, L=Redmond, S=Washington, C=US
Architecture           : X64
ResourceId             :
Version                : 4.2204.13303.0
PackageFullName        : Microsoft.549981C3F5F10_4.2204.13303.0_x64__8wekyb3d8bbwe
InstallLocation        : C:\Program Files\WindowsApps\Microsoft.549981C3F5F10_4.2204.13303.0_x64__8wekyb3d8bbwe
IsFramework            : False
PackageFamilyName      : Microsoft.549981C3F5F10_8wekyb3d8bbwe
PublisherId            : 8wekyb3d8bbwe
PackageUserInformation : {S-1-5-21-1801674531-527237240-682003330-164699 [MARVELL\marslo]: Installed}
IsResourcePackage      : False
IsBundle               : False
IsDevelopmentMode      : False
NonRemovable           : False
Dependencies           : {Microsoft.NET.Native.Framework.2.2_2.2.29512.0_x64__8wekyb3d8bbwe,
                         Microsoft.NET.Native.Runtime.2.2_2.2.28604.0_x64__8wekyb3d8bbwe,
                         Microsoft.VCLibs.140.00_14.0.30704.0_x64__8wekyb3d8bbwe,
                         Microsoft.VCLibs.140.00.UWPDesktop_14.0.30704.0_x64__8wekyb3d8bbwe...}
IsPartiallyStaged      : False
SignatureKind          : Store
Status                 : Ok

> Get-AppxPackage -allusers Microsoft.549981C3F5F10 | Remove-AppxPackage
```

### install ssh-agent

{% hint style='info' %}
> references:
> - [Get started with OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse?tabs=powershell)
{% endhint %}

```powershell
# check available version
> Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH*'

# install
> Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0
> Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

> Get-Service ssh-agent | Set-Service -StartupType Automatic -PassThru | Start-Service
```

- start service
  ```powershell
  # Start the sshd service
  Start-Service sshd

  # OPTIONAL but recommended:
  Set-Service -Name sshd -StartupType 'Automatic'

  # Confirm the Firewall rule is configured. It should be created automatically by setup. Run the following to verify
  if (!(Get-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -ErrorAction SilentlyContinue | Select-Object Name, Enabled)) {
      Write-Output "Firewall Rule 'OpenSSH-Server-In-TCP' does not exist, creating it..."
      New-NetFirewallRule -Name 'OpenSSH-Server-In-TCP' -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
  } else {
      Write-Output "Firewall rule 'OpenSSH-Server-In-TCP' has been created and exists."
  }
  ```

- uninstall
  ```powershell
  # Uninstall the OpenSSH Client
  Remove-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

  # Uninstall the OpenSSH Server
  Remove-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
  ```


### deploy windows 10 in a test lab using configuration manager

{% hint style='info' %}
> references:
> - [Deploy Windows 10 in a test lab using Configuration Managerf](https://learn.microsoft.com/en-us/windows/deployment/windows-10-poc-sc-config-mgr)
{% endhint %}

- prerequisites
  ```powershell
  > Install-WindowsFeature Web-Windows-Auth,Web-ISAPI-Ext,Web-Metabase,Web-WMI,BITS,RDC,NET-Framework-Features,Web-Asp-Net,Web-Asp-Net45,NET-HTTP-Activation,NET-Non-HTTP-Activ
  # download SQLServer
  > Set-VMDvdDrive -VMName SRV1 -Path c:\VHD\SQLServer2014SP2-FullSlipstream-x64-ENU.iso
  > D:\setup.exe /q /ACTION=Install /ERRORREPORTING="False" /FEATURES=SQLENGINE,RS,IS,SSMS,TOOLS,ADV_SSMS,CONN /INSTANCENAME=MSSQLSERVER /INSTANCEDIR="C:\Program Files\Microsoft SQL Server" /SQLSVCACCOUNT="NT AUTHORITY\System" /SQLSYSADMINACCOUNTS="BUILTIN\ADMINISTRATORS" /SQLSVCSTARTUPTYPE=Automatic /AGTSVCACCOUNT="NT AUTHORITY\SYSTEM" /AGTSVCSTARTUPTYPE=Automatic /RSSVCACCOUNT="NT AUTHORITY\System" /RSSVCSTARTUPTYPE=Automatic /ISSVCACCOUNT="NT AUTHORITY\System" /ISSVCSTARTUPTYPE=Disabled /ASCOLLATION="Latin1_General_CI_AS" /SQLCOLLATION="SQL_Latin1_General_CP1_CI_AS" /TCPENABLED="1" /NPENABLED="1" /IAcceptSQLServerLicenseTerms
  # elevated windows powershell
  > New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action allow
  > New-NetFirewallRule -DisplayName "SQL Admin Connection" -Direction Inbound -Protocol TCP -LocalPort 1434 -Action allow
  > New-NetFirewallRule -DisplayName "SQL Database Management" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action allow
  > New-NetFirewallRule -DisplayName "SQL Service Broker" -Direction Inbound -Protocol TCP -LocalPort 4022 -Action allow
  > New-NetFirewallRule -DisplayName "SQL Debugger/RPC" -Direction Inbound -Protocol TCP -LocalPort 135 -Action allow
  # download ADK : https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install
  ```

- microsoft configuration manager
  ```powershell
  > $AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}"
  > Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0
  > Stop-Process -Name Explorer
  # download winmgmt (Microsoft Configuration Manager) : https://www.microsoft.com/en-us/evalcenter/evaluate-microsoft-endpoint-configuration-manager

  # verify WMI
  > Get-Service Winmgmt
  Status   Name               DisplayName
  ------   ----               -----------
  Running  Winmgmt            Windows Management Instrumentation

  > Test-NetConnection -ComputerName 192.168.0.2 -Port 135 -InformationLevel Detailed
  ComputerName             : 192.168.0.2
  RemoteAddress            : 192.168.0.2
  RemotePort               : 135
  AllNameResolutionResults :
  MatchingIPsecRules       :
  NetworkIsolationContext  : Internet
  InterfaceAlias           : Ethernet
  SourceAddress            : 192.168.0.2
  NetRoute (NextHop)       : 0.0.0.0
  PingSucceeded            : True
  PingReplyDetails (RTT)   : 0 ms
  TcpTestSucceeded         : True

  # from bat
  > C:\configmgr\SMSSETUP\BIN\X64\extadsch.exe
  > adsiedit.msc
  …

  # re-enable IE Enhanced Security Configuration
  > Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 1
  > Stop-Process -Name Explorer
  ```
- download mdop and install dart
- prepare for zero touch installation
- create a boot image for configuration manager

  ```powershell
  > Copy-Item -Path "C:\ProgramData\Microsoft\User Account Pictures\user.bmp" -Destination "C:\Sources\OSD\Branding\contoso.bmp"
  ```
- create a windows 10 reference image
  ```powershell
  > Set-VMDvdDrive -VMName SRV1 -Path c:\VHD\w10-enterprise.iso
  ...

  # setup hyper-v host computer
  > New-VM -Name REFW10X64-001 -SwitchName poc-internal -NewVHDPath "c:\VHD\REFW10X64-001.vhdx" -NewVHDSizeBytes 60GB
  > Set-VMMemory -VMName REFW10X64-001 -DynamicMemoryEnabled $true -MinimumBytes 1024MB -MaximumBytes 1024MB -Buffer 20
  > Set-VMDvdDrive -VMName REFW10X64-001 -Path c:\VHD\LiteTouchPE_x86.iso
  > Start-VM REFW10X64-001
  > vmconnect localhost REFW10X64-001
  ```
- add a windows 10 os image
  ```powershell
  > New-Item -ItemType Directory -Path "C:\Sources\OSD\OS\Windows 10 Enterprise x64"
  > cmd /c copy /z "C:\MDTBuildLab\Captures\REFW10X64-001.wim" "C:\Sources\OSD\OS\Windows 10 Enterprise x64"
  ```
- create a task sequence
- finalize the os configuration
- deploy windows 10 using pxe and configuration manager
  ```powershell
  > New-VM -Name "PC4" -NewVHDPath "c:\vhd\pc4.vhdx" -NewVHDSizeBytes 40GB -SwitchName poc-internal -BootDevice NetworkAdapter -Generation 2
  > Set-VMMemory -VMName "PC4" -DynamicMemoryEnabled $true -MinimumBytes 512MB -MaximumBytes 2048MB -Buffer 20
  > Start-VM PC4
  > vmconnect localhost PC4
  ```
  - deploy PC4
    ```powershell
    > New-VM -Name "PC4" -NewVHDPath "c:\vhd\pc4.vhdx" -NewVHDSizeBytes 60GB -SwitchName poc-internal -BootDevice NetworkAdapter -Generation 2
    > Set-VMMemory -VMName "PC4" -DynamicMemoryEnabled $true -MinimumBytes 1024MB -MaximumBytes 2048MB -Buffer 20
    > Set-VMNetworkAdapter -VMName PC4 -StaticMacAddress 00-15-5D-83-26-FF
    ```

  - open configuration management property
    ```batch
    > control.exe smscfgrc
    ```

- replace a client with windows 10 using configuration manager

## modules

> [!NOTE|label:references:]
> - [PowerShell Gallery](https://www.powershellgallery.com/)
>   - [DockerProvider](https://www.powershellgallery.com/packages/DockerProvider/0.0.0.3)
>   - [Difference between Docker from DockerProvider and DockerMsftProvider](https://stackoverflow.com/a/48231887/2940319)
> - [Get-InstalledModule](https://learn.microsoft.com/en-us/powershell/module/powershellget/get-installedmodule?view=powershellget-3.x)
> - [Get-Module](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/get-module?view=powershell-7.4)

### list installed modules
```powershell
> Get-InstalledModule

Version    Name                                Repository           Description
-------    ----                                ----------           -----------
1.13.0     7Zip4Powershell                     PSGallery            Powershell module for creating and...
1.0.0.8    DockerMsftProvider                  PSGallery            PowerShell module with commands fo...
0.87.3     PSWriteColor                        PSGallery            Write-Color is a wrapper around Wr...
2.2.16     VSSetup                             PSGallery            Visual Studio Setup PowerShell Module
0.5.2      WebKitDev                           PSGallery            PowerShell scripts for WebKit deve...
```

### get package source
```powershell
> Get-PackageSource -ProviderName DockerMsftProvider
Name                             ProviderName     IsTrusted  Location
----                             ------------     ---------  --------
DockerDefault                    DockerMsftPro... False      https://go.microsoft.com/fwlink/?LinkID=825636&clcid=0x409

> Get-PackageSource
Name                             ProviderName     IsTrusted  Location
----                             ------------     ---------  --------
PSGallery                        PowerShellGet    False      https://www.powershellgallery.com/api/v2
DockerDefault                    DockerMsftPro... False      https://go.microsoft.com/fwlink/?LinkID=825636&clcid=0x409
```


## scripts

> [!NOTE|label:references:]
> - [Windows Server 2019 - Scripting and Sharing](https://mpolinowski.github.io/docs/DevOps/Windows/2019-06-10--windows-server-2019-scripting-and-sharing/2019-06-10)
> - [* MicrosoftDockerProvider/DockerMsftProvider.psm1](https://github.com/OneGet/MicrosoftDockerProvider/blob/developer/DockerMsftProvider.psm1)
> - [* Install-DockerCE/install-docker-ce.ps1](https://github.com/microsoft/Windows-Containers/blob/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1)
> - [* install_docker_msft.ps1](https://github.com/pablodav/kubernetes-for-windows/blob/feature/kubespray_k8win1803/ansible/roles/windows/docker/files/install_docker_msft.ps1)
> - [* install_docker_windows_server.ps1](https://github.com/vinicius91/docker-windows-containers/blob/master/PowerShell-Scripts/install_docker_windows_server.ps1)
> - [* windows-tools-installation.md](https://gist.github.com/thxCode/cd8ec26795a56eb120b57675f0c067cf)
>   - [git_install.ps1)](https://gist.githubusercontent.com/thxCode/cd8ec26795a56eb120b57675f0c067cf/raw/c2f2dce527bae0c7ed913ae14ac58b64f5a2d97f/zz_git_install.ps1)
>   - [docker_install.ps1](https://gist.githubusercontent.com/thxCode/cd8ec26795a56eb120b57675f0c067cf/raw/10d748f604764aa337864941b99d79154cbc5fc2/zz_docker_install.ps1)
>   - [golang_install.ps1](https://gist.githubusercontent.com/thxCode/cd8ec26795a56eb120b57675f0c067cf/raw/c2f2dce527bae0c7ed913ae14ac58b64f5a2d97f/zz_golang_install.ps1)
>   - [tcpdump_install.ps1](https://gist.githubusercontent.com/thxCode/cd8ec26795a56eb120b57675f0c067cf/raw/c2f2dce527bae0c7ed913ae14ac58b64f5a2d97f/zz_tcpdump_install.ps1)
>   - [sshd_manage.ps1](https://gist.githubusercontent.com/thxCode/cd8ec26795a56eb120b57675f0c067cf/raw/897f2c41df99832d6f88f663a9c2ac442dee4875/zz_sshd_manage.ps1)

### environment

- [setup proxy](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon#proxy-configuration)
  ```powershell
  > [Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://username:password@proxy:port/", [EnvironmentVariableTarget]::Machine)
  ```

### timezone

> [!NOTE|label:references:]
> - [Virtualized time zone](https://learn.microsoft.com/en-us/virtualization/windowscontainers/manage-containers/virtual-time-zone)

- get timezone
  ```batch
  > tzutil /g
  Dateline Standard Time
  ```

  ```powershell
  > Get-TimeZone
  Id                         : Dateline Standard Time
  DisplayName                : (UTC-12:00) International Date Line West
  StandardName               : Dateline Standard Time
  DaylightName               : Dateline Daylight Time
  BaseUtcOffset              : -12:00:00
  SupportsDaylightSavingTime : False
  ```

- modify timezone
  ```batch
  > tzutil /s "Samoa Standard Time"
  > tzutil /g
  ```

## [step-by-step guide to setup two-tier pki environment](http://www.rebeladmin.com/2018/06/step-step-guide-setup-two-tier-pki-environment/)

```powershell
# Setup Standalone Root CA
> Add-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
> Install-ADcsCertificationAuthority -CACommonName “REBELAdmin Root CA” -CAType StandaloneRootCA -CryptoProviderName “RSA#Microsoft Software Key Storage Provider” -HashAlgorithmName SHA256 -KeyLength 2048 -ValidityPeriod Years -ValidityPeriodUnits 20

# DSConfigDN
> certutil.exe –setreg ca\DSConfigDN CN=Configuration,DC=rebeladmin,DC=com

# CDP Location
> Install-WindowsFeature Web-WebServer -IncludeManagementTools

# for virtual directory
> mkdir C:\CertEnroll
> New-smbshare -name CertEnroll C:\CertEnroll -FullAccess SYSTEM,"rebeladmin\Domain Admins" -ChangeAccess "rebeladmin\Cert Publishers"

# publish the CDP settings
> certutil -setreg CA\CRLPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%3%8%9.crl \n10:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10\n2:http://crt.rebeladmin.com/CertEnroll/%3%8%9.crl"

# AIA Location (Authority Information Access)
> certutil -setreg CA\CACertPublicationURLs "1:C:\Windows\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11\n2:http://crt.rebeladmin.com/CertEnroll/%1_%3%4.crt"

# CA Time Limits
> certutil -setreg ca\ValidityPeriod "Years"
> certutil -setreg ca\ValidityPeriodUnits 10

# CRL Time Limits
> Certutil -setreg CA\CRLPeriodUnits 13
> Certutil -setreg CA\CRLPeriod "Weeks"
> Certutil -setreg CA\CRLDeltaPeriodUnits 0
> Certutil -setreg CA\CRLOverlapPeriodUnits 6
> Certutil -setreg CA\CRLOverlapPeriod "Hours"

> Restart-Service certsvc

# New CRL
> certutil -crl
```

- Publish Root CA Data in to Active Directory
  ```powershell
  > certutil –f –dspublish "REBEL-CRTROOT_REBELAdmin Root CA.crt" RootCA
  > certutil –f –dspublish "REBELAdmin Root CA.crl"
  ```

- Setup Issuing CA
  ```powershell
  > Add-WindowsFeature ADCS-Cert-Authority -IncludeManagementTools
  > Add-WindowsFeature ADCS-web-enrollment
  > Install-ADcsCertificationAuthority -CACommonName “REBELAdmin IssuingCA” -CAType EnterpriseSubordinateCA -CryptoProviderName “RSA#Microsoft Software Key Storage Provider” -HashAlgorithmName SHA256 -KeyLength 2048
  > Install-ADCSwebenrollment
  ```

- Issue Certificate for Issuing CA
  ```powershell
  > certreq -submit "REBEL-CA1.rebeladmin.com_REBELAdmin IssuingCA.req"
  ```

  - go to Server Manager > Tools > Certificate Authority > Pending Certificates and the right click on the certificate > All Tasks > Issue
  - export
    ```powershell
    > certreq -retrieve 2 "C:\REBEL-CA1.rebeladmin.com_REBELAdmin_IssuingCA.crt"
    > Certutil –installcert "C:\REBEL-CA1.rebeladmin.com_REBELAdmin_IssuingCA.crt"
    > start-service certsvc
    ```

- Post Configuration Tasks
  ```powershell
  # CDP Location
  > certutil -setreg CA\CRLPublicationURLs "1:%WINDIR%\system32\CertSrv\CertEnroll\%3%8%9.crl\n2:http://crt.rebeladmin.com/CertEnroll/%3%8%9.crl\n3:ldap:///CN=%7%8,CN=%2,CN=CDP,CN=Public Key Services,CN=Services,%6%10"

  # AIA Location
  > certutil -setreg CA\CACertPublicationURLs "1:%WINDIR%\system32\CertSrv\CertEnroll\%1_%3%4.crt\n2:http://crt.rebeladmin.com/CertEnroll/%1_%3%4.crt\n3:ldap:///CN=%7,CN=AIA,CN=Public Key Services,CN=Services,%6%11"

  # CA and CRL Time Limits
  > certutil -setreg CA\CRLPeriodUnits 7
  > certutil -setreg CA\CRLPeriod “Days”
  > certutil -setreg CA\CRLOverlapPeriodUnits 3
  > certutil -setreg CA\CRLOverlapPeriod “Days”
  > certutil -setreg CA\CRLDeltaPeriodUnits 0
  > certutil -setreg ca\ValidityPeriodUnits 3
  > certutil -setreg ca\ValidityPeriod “Years”

  > Restart-Service certsvc
  > certutil -crl
  ```
  - run `PKIView.msc` to verify the configuration.
