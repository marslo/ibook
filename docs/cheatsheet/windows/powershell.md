<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check current user is Admin](#check-current-user-is-admin)
- [echo](#echo)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### check current user is Admin
```powershell
> (New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
True
```

![check current permissions](../../screenshot/win/powershell/windows-ssh-1.png)


### echo
> references
> - [Redirection](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.2)
> - [Out-Null](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/out-null?view=powershell-7.2)

```powershell
Write-Warning "hello"
Write-Error "hello"
Write-Output "hello" | Out-Null
```
