<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [chocolatey setup](#chocolatey-setup)
  - [install](#install)
  - [install behind a proxy](#install-behind-a-proxy)
  - [Non-Administrative install](#non-administrative-install)
  - [unisntall](#unisntall)
- [packages](#packages)
  - [install](#install-1)
  - [upgrade](#upgrade)
- [config](#config)
  - [list](#list)
  - [proxy](#proxy)
- [others](#others)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## chocolatey setup

> [!NOTE|label:references:]
> - [Installing Chocolatey CLI](https://docs.chocolatey.org/en-us/choco/setup/)
> - [install.ps1](https://community.chocolatey.org/install.ps1)

### install
- install with cmd.exe
  ```batch
  > @"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "[System.Net.ServicePointManager]::SecurityProtocol = 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
  ```

- install with powershell.exe
  ```powershell
  > Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
  ```

### [install behind a proxy](https://docs.chocolatey.org/en-us/choco/setup/#installing-behind-a-proxy)
```powershell
# cmd.exe
> @powershell -NoProfile -ExecutionPolicy Bypass -Command "[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" && SET PATH="%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

# powershell.exe
> [System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### [Non-Administrative install](https://docs.chocolatey.org/en-us/choco/setup/#non-administrative-install)
```powershell
> Get-Content ChocolateyInstallNonAdmin.ps1
# Set directory for installation - Chocolatey does not lock down the directory if not the default
$InstallDir='C:\ProgramData\chocoportable'
$env:ChocolateyInstall="$InstallDir"

# If your PowerShell Execution policy is restrictive, you may
# not be able to get around that. Try setting your session to
# Bypass.
Set-ExecutionPolicy Bypass -Scope Process -Force;

# All install options - offline, proxy, etc at
# https://chocolatey.org/install
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

### [unisntall](https://docs.chocolatey.org/en-us/choco/uninstallation/)

<!--sec data-title="powershell script" data-id="section0" data-show=true data-collapse=true ces-->
```powershell
$VerbosePreference = 'Continue'
if (-not $env:ChocolateyInstall) {
  $message = @(
    "The ChocolateyInstall environment variable was not found."
    "Chocolatey is not detected as installed. Nothing to do."
  ) -join "`n"

  Write-Warning $message
  return
}

if (-not (Test-Path $env:ChocolateyInstall)) {
  $message = @(
    "No Chocolatey installation detected at '$env:ChocolateyInstall'."
    "Nothing to do."
  ) -join "`n"

  Write-Warning $message
  return
}

<#
  Using the .NET registry calls is necessary here in order to preserve environment variables embedded in PATH values;
  Powershell's registry provider doesn't provide a method of preserving variable references, and we don't want to
  accidentally overwrite them with absolute path values. Where the registry allows us to see "%SystemRoot%" in a PATH
  entry, PowerShell's registry provider only sees "C:\Windows", for example.
#>
$userKey = [Microsoft.Win32.Registry]::CurrentUser.OpenSubKey('Environment',$true)
$userPath = $userKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

$machineKey = [Microsoft.Win32.Registry]::LocalMachine.OpenSubKey('SYSTEM\ControlSet001\Control\Session Manager\Environment\',$true)
$machinePath = $machineKey.GetValue('PATH', [string]::Empty, 'DoNotExpandEnvironmentNames').ToString()

$backupPATHs = @(
  "User PATH: $userPath"
  "Machine PATH: $machinePath"
)
$backupFile = "C:\PATH_backups_ChocolateyUninstall.txt"
$backupPATHs | Set-Content -Path $backupFile -Encoding UTF8 -Force

$warningMessage = @"
  This could cause issues after reboot where nothing is found if something goes wrong.
  In that case, look at the backup file for the original PATH values in '$backupFile'.
"@

if ($userPath -like "*$env:ChocolateyInstall*") {
  Write-Verbose "Chocolatey Install location found in User Path. Removing..."
  Write-Warning $warningMessage

  $newUserPATH = @(
      $userPath -split [System.IO.Path]::PathSeparator |
          Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
  ) -join [System.IO.Path]::PathSeparator

  # NEVER use [Environment]::SetEnvironmentVariable() for PATH values; see https://github.com/dotnet/corefx/issues/36449
  # This issue exists in ALL released versions of .NET and .NET Core as of 12/19/2019
  $userKey.SetValue('PATH', $newUserPATH, 'ExpandString')
}

if ($machinePath -like "*$env:ChocolateyInstall*") {
  Write-Verbose "Chocolatey Install location found in Machine Path. Removing..."
  Write-Warning $warningMessage

  $newMachinePATH = @(
      $machinePath -split [System.IO.Path]::PathSeparator |
          Where-Object { $_ -and $_ -ne "$env:ChocolateyInstall\bin" }
  ) -join [System.IO.Path]::PathSeparator

  # NEVER use [Environment]::SetEnvironmentVariable() for PATH values; see https://github.com/dotnet/corefx/issues/36449
  # This issue exists in ALL released versions of .NET and .NET Core as of 12/19/2019
  $machineKey.SetValue('PATH', $newMachinePATH, 'ExpandString')
}

# Adapt for any services running in subfolders of ChocolateyInstall
$agentService = Get-Service -Name chocolatey-agent -ErrorAction SilentlyContinue
if ($agentService -and $agentService.Status -eq 'Running') {
  $agentService.Stop()
}
# TODO: add other services here

Remove-Item -Path $env:ChocolateyInstall -Recurse -Force -WhatIf

'ChocolateyInstall', 'ChocolateyLastPathUpdate' | ForEach-Object {
  foreach ($scope in 'User', 'Machine') {
    [Environment]::SetEnvironmentVariable($_, [string]::Empty, $scope)
  }
}

$machineKey.Close()
$userKey.Close()
```

- additionally
  ```powershell
  if ($env:ChocolateyToolsLocation -and (Test-Path $env:ChocolateyToolsLocation)) {
    Remove-Item -Path $env:ChocolateyToolsLocation -WhatIf -Recurse -Force
  }

  foreach ($scope in 'User', 'Machine') {
    [Environment]::SetEnvironmentVariable('ChocolateyToolsLocation', [string]::Empty, $scope)
  }
  ```
<!--endsec-->

## packages

- [example](https://docs.chocolatey.org/en-us/choco/setup/#non-administrative-install)
  ```powershell
  > choco install puppet-agent.portable -y
  > choco install ruby.portable -y
  > choco install git.commandline -y

  # pick an editor
  > choco install visualstudiocode.portable -y                      # not yet available
  > choco install notepadplusplus.commandline -y
  > choco install nano -y
  > choco install vim-tux.portable

  # What else can I install without admin rights?
  # https://community.chocolatey.org/packages?q=id%3Aportable
  ```

### install
- sample log for lua

  > [!NOTE|label:packages:]
  > - [vcredist2005 64 bit](https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE)
  > - [vcredist2005 32 bit](https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE)
  > - [lua 5.1.5-52](https://github.com/rjpcomputing/luaforwindows/releases/download/v5.1.5-52/LuaForWindows_v5.1.5-52.exe)

  <!--sec data-title="sample output for lua" data-id="section1" data-show=true data-collapse=true ces-->
  ```powershell
  > choco install lua
  Chocolatey v2.3.0
  Installing the following packages:
  lua
  By installing, you accept licenses for the packages.
  Downloading package from source 'https://community.chocolatey.org/api/v2/'
  Progress: Downloading vcredist2005 8.0.50727.619501... 100%

  vcredist2005 v8.0.50727.619501 [Approved]
  vcredist2005 package files install completed. Performing other installation steps.
  Downloading vcredist2005 64 bit
    from 'https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x64.EXE'
  Progress: 100% - Completed download of C:\Users\marslo\AppData\Local\Temp\chocolatey\vcredist2005\8.0.50727.619501\vcredist_x64.EXE (3.03 MB).
  Download of vcredist_x64.EXE (3.03 MB) completed.
  Hashes match.
  Installing vcredist2005...
  vcredist2005 has been installed.
  Downloading vcredist2005 32 bit
    from 'https://download.microsoft.com/download/8/B/4/8B42259F-5D70-43F4-AC2E-4B208FD8D66A/vcredist_x86.EXE'
  Progress: 100% - Completed download of C:\Users\marslo\AppData\Local\Temp\chocolatey\vcredist2005\8.0.50727.619501\vcredist_x86.EXE (2.58 MB).
  Download of vcredist_x86.EXE (2.58 MB) completed.
  Hashes match.
  Installing vcredist2005...
  vcredist2005 has been installed.
    vcredist2005 may be able to be automatically uninstalled.
   The install of vcredist2005 was successful.
    Software installed as 'exe', install location is likely default.
  Downloading package from source 'https://community.chocolatey.org/api/v2/'
  Progress: Downloading Lua 5.1.5.52... 100%

  lua v5.1.5.52 [Approved]
  lua package files install completed. Performing other installation steps.
  Downloading lua
    from 'https://github.com/rjpcomputing/luaforwindows/releases/download/v5.1.5-52/LuaForWindows_v5.1.5-52.exe'
  Progress: 100% - Completed download of C:\Users\marslo\AppData\Local\Temp\chocolatey\Lua\5.1.5.52\LuaForWindows_v5.1.5-52.exe (27.8 MB).
  Download of LuaForWindows_v5.1.5-52.exe (27.8 MB) completed.
  Hashes match.
  Installing lua...
  lua has been installed.
    lua can be automatically uninstalled.
  Environment Vars (like PATH) have changed. Close/reopen your shell to
   see the changes (or in powershell/cmd.exe just type `refreshenv`).
   The install of lua was successful.
    Deployed to 'C:\Program Files (x86)\Lua\5.1\'

  Chocolatey installed 2/2 packages.
   See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
  ```
  <!--endsec-->

- sample output for lua53
  <!--sec data-title="sample output for lua53" data-id="section2" data-show=true data-collapse=true ces-->
  ```powershell
  > choco install lua53
  Chocolatey v2.2.2
  Installing the following packages:
  lua53
  By installing, you accept licenses for the packages.
  Progress: Downloading lua53 5.3.5... 100%

  lua53 v5.3.5 [Approved]
  lua53 package files install completed. Performing other installation steps.
  WARNING: Url has SSL/TLS available, switching to HTTPS for download
  Downloading lua53 64 bit
    from 'https://sourceforge.net/projects/luabinaries/files/5.3.5/Tools%20Executables/lua-5.3.5_Win64_bin.zip/download'
  Progress: 100% - Completed download of C:\Users\marslo\AppData\Local\Temp\chocolatey\lua53\5.3.5\lua53Install.zip (336.43 KB).
  Download of lua53Install.zip (336.43 KB) completed.
  Hashes match.
  Extracting C:\Users\marslo\AppData\Local\Temp\chocolatey\lua53\5.3.5\lua53Install.zip to C:\ProgramData\chocolatey\lib\lua53\tools...
  C:\ProgramData\chocolatey\lib\lua53\tools
  PATH environment variable does not have C:\ProgramData\chocolatey\lib\lua53\tools in it. Adding...
  Environment Vars (like PATH) have changed. Close/reopen your shell to
   see the changes (or in powershell/cmd.exe just type `refreshenv`).
   The install of lua53 was successful.
    Software installed to 'C:\ProgramData\chocolatey\lib\lua53\tools'

  Chocolatey installed 1/1 packages.
   See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).
  ```
  <!--endsec-->

### upgrade
- list outdated packages
  ```powershell
  > choco outdated
  Chocolatey v2.2.2
  Outdated Packages
   Output is package name | current version | available version | pinned?

  chocolatey|2.2.2|2.3.0|false
  Everything|1.4.11024|1.4.11026|false
  fd|9.0.0|10.1.0|false
  fzf|0.46.1|0.53.0|false
  go|1.22.0|1.23.0|false
  golang|1.22.0|1.23.0|false
  microsoft-windows-terminal|1.19.10302|1.20.11781|false
  neovim|0.9.5|0.10.1|false
  python|3.12.2|3.12.5|false
  python3|3.12.2|3.12.5|false
  python312|3.12.2|3.12.5|false
  vcredist140|14.38.33135|14.40.33810|false

  Chocolatey has determined 12 package(s) are outdated.
  ```

- upgrade all outdated packages
  ```powershell
  > choco upgrade all -y
  ...
  ...
  Upgraded:
   - chocolatey v2.3.0
   - Everything v1.4.11026
   - fd v10.1.0
   - fzf v0.53.0
   - go v1.23.0
   - golang v1.23.0
   - microsoft-windows-terminal v1.20.11781
   - python v3.12.5
   - python3 v3.12.5
   - python312 v3.12.5
   - vcredist140 v14.40.33810

  Failures
   - neovim (exited 2) - Error while running 'C:\ProgramData\chocolatey\lib\neovim\tools\chocolateyinstall.ps1'.
   See log for details.
  ```

## config

### list
```powershell
> choco config list
Chocolatey v2.2.2
cacheLocation =  | Cache location if not TEMP folder. Replaces `$env:TEMP` value for choco.exe process. It is highly recommended this be set to make Chocolatey more deterministic in cleanup.
commandExecutionTimeoutSeconds = 2700 | Default timeout for command execution. '0' for infinite.
containsLegacyPackageInstalls = true |
defaultPushSource =  | Default source to push packages to when running 'choco push' command.
defaultTemplateName =  | Default template name used when running 'choco new' command.
proxy = http://ipamunix.sample.com:8080 | Explicit proxy location.
proxyBypassList =  | Optional proxy bypass list. Comma separated.
proxyBypassOnLocal = true | Bypass proxy for local connections.
proxyPassword =  | Optional proxy password. Encrypted.
proxyUser =  | Optional proxy user.
upgradeAllExceptions =  | A comma-separated list of package names that should not be upgraded when running `choco upgrade all'. Defaults to empty.
webRequestTimeoutSeconds = 30 | Default timeout for web requests.
```

### proxy

> [!NOTE|label:references:]
> - [Use Chocolatey w/Proxy Server](https://docs.chocolatey.org/en-us/guides/usage/proxy-settings-for-chocolatey/)

- setup in config
  ```powershell
  > choco config set --name="'proxy'" --value="'http://ipamunix.sample.com:8080'"

  # optioanl
  > choco config set --name="'proxyUser'"          --value="'<USERNAME>'"
  > choco config set --name="'proxyPassword'"      --value="'<PASSWORD>'"
  > choco config set --name="'proxyBypassList'"    --value="'http://localhost,http://this.location/'"
  > choco config set --name="'proxyBypassOnLocal'" --value="'true'"
  ```

- using at runtime
  ```powershell
  > choco install <package> --proxy="'http://ipamunix.sample.com:8080'"

  # full format
  > choco install <package> --proxy="'http://ipamunix.sample.com:8080'",
                            --proxy-user="'<user>'",
                            --proxy-password="'<pwd>'",
                            --proxy-bypass-list="'<REGEX-BYPASS-LIST-COMMA-SEPARATED>'",
                            --proxy-bypass-on-local
  ```

- unset
  ```powershell
  > choco config unset proxy
  ```

## others
- update help
  ```powershell
  > Get-Help Get-ToolsLocation -Full

  Do you want to run Update-Help?
  The Update-Help cmdlet downloads the most current Help files for Windows PowerShell modules, and installs them on your
  computer. For more information about the Update-Help cmdlet, see https:/go.microsoft.com/fwlink/?LinkId=210614.
  [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): y
  ```
