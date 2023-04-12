<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [check current user is Admin](#check-current-user-is-admin)
- [echo](#echo)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


### check current user is Admin

> [!NOTE|label:references]
> - [How to: Tell if a PowerShell script is running as the Administrator](https://colinmackay.scot/2019/08/10/how-to-tell-if-a-powershell-script-is-running-as-the-administrator/)
> - [Get started with OpenSSH for Windows](https://learn.microsoft.com/en-us/windows-server/administration/openssh/openssh_install_firstuse)
> - [Universal test for Admin privileges](https://stackoverflow.com/a/35817852/2940319)
> - [well-known SIDs](https://learn.microsoft.com/en-US/windows-server/identity/ad-ds/manage/understand-security-identifiers#well-known-sids)
>   - `S-1-5-32-544` : `Administrators`
>   - `S-1-5-32-545` : `Users`
>   - `S-1-5-32-547` : `Power Users`
> - [Powershell Admin rights dont work in Windows Forms](https://stackoverflow.com/questions/68651418/powershell-admin-rights-dont-work-in-windows-forms)


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

### echo
> references
> - [Redirection](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_redirection?view=powershell-7.2)
> - [Out-Null](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/out-null?view=powershell-7.2)

```powershell
Write-Warning "hello"
Write-Error "hello"
Write-Output "hello" | Out-Null
```
