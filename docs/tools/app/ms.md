<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [outlook](#outlook)
- [ms office](#ms-office)
- [logs](#logs)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


{% hint style='tip' %}
> reference:
> - [pbowden-msft/Unlicense](https://github.com/pbowden-msft/Unlicense/blob/master/Unlicense)
> - [Rebuild the Office database](https://support.microsoft.com/en-us/office/rebuild-the-office-database-c21643be-0f0d-4997-9ec1-8044080054b0)
> - [Outlook 2016 for Mac repeatedly prompts for authentication](https://docs.microsoft.com/en-us/outlook/troubleshoot/sign-in/repeated-prompts-authentication)
> - [Office for Mac repeatedly requesting keychain access](https://support.microsoft.com/en-us/office/office-for-mac-repeatedly-requesting-keychain-access-ced5a09c-3099-47cb-9190-e961bf63e240)
> - [If your Mac keeps asking for the login keychain password](https://support.apple.com/en-gb/HT201609)
> - [How to remove Office license files on a Mac](https://support.microsoft.com/en-us/office/how-to-remove-office-license-files-on-a-mac-b032c0f6-a431-4dad-83a9-6b727c03b193)
> - [Troubleshoot install or activation errors for Office for Mac](https://support.microsoft.com/en-us/office/what-to-try-if-you-can-t-install-or-activate-office-for-mac-5efba2b4-b1e6-4e5f-bf3c-6ab945d03dea?wt.mc_id=scl_installoffice_mac)
> - [Configure keychain](https://docs.microsoft.com/en-us/azure/active-directory/develop/howto-v2-keychain-objc?tabs=objc)

> download
> - [Microsoft Office 16.45.21011103](https://apphub.online/p/microsoft-office)
>   - [Microsoft_Office_16.45.21011103_BusinessPro_Installer.pkg](https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Office_16.45.21011103_BusinessPro_Installer.pkg)
>   - [Microsoft_Word_16.45.21011103_Installer.pkg](https://officecdn-microsoft-com.akamaized.net/pr/C1297A47-86C4-4C1F-97FA-950631F94777/MacAutoupdate/Microsoft_Word_16.45.21011103_Installer.pkg)
> - [Update history for Office for Mac](https://docs.microsoft.com/en-us/officeupdates/update-history-office-for-mac)
> - [Release notes for Office for Mac](https://docs.microsoft.com/en-us/officeupdates/release-notes-office-for-mac)
> - [Activate Office 2019 for macOS VoL.md](https://gist.github.com/zthxxx/9ddc171d00df98cbf8b4b0d8469ce90a)
> - [Uninstall Office for Mac](https://support.microsoft.com/en-us/office/uninstall-office-for-mac-eefa1199-5b58-43af-8a3d-b73dc1a8cae3?ui=en-us&rs=en-us&ad=us)
> - [Release history for Microsoft Auto Update (MAU)](https://docs.microsoft.com/en-us/officeupdates/release-history-microsoft-autoupdate)

> Q&A
> - ["There is a problem with your account. Try again later." - Mac (Sierra)](https://answers.microsoft.com/en-us/msoffice/forum/msoffice_word-mso_mac-mso_o365b/there-is-a-problem-with-your-account-try-again/b4e821b5-4163-40c5-99c3-230bb1db2161)
> - [Office 365 Business won't activate on Mac](https://answers.microsoft.com/en-us/msoffice/forum/msoffice_account/office-365-business-wont-activate-on-mac/51a3e684-4d7a-4993-b112-197941ea8601)
> - [How to troubleshoot issues that you encounter when you sign in to Office apps for Mac, iPad, iPhone, or iPod Touch when using Active Directory Federation Services](https://support.microsoft.com/en-us/office/how-to-troubleshoot-issues-that-you-encounter-when-you-sign-in-to-office-apps-for-mac-ipad-iphone-or-ipod-touch-when-using-active-directory-federation-services-e44357b4-c9c4-4580-a946-ef5dabdb98cd?ui=en-us&rs=en-us&ad=us)
{% endhint %}

### outlook
- [profile](https://answers.microsoft.com/en-us/msoffice/forum/msoffice_outlook-mso_mac-mso_365hp/where-is-the-microsoft-database-utility-in-mac/205f7e0a-153d-40dc-bafe-23485bedda01)
  ```bash
  $ ls ~/Library/Group Containers/UBF8T346G9.Office/Outlook/Outlook 15 Profiles/
  ```

- [reset outlook profile](https://answers.microsoft.com/en-us/msoffice/forum/msoffice_outlook-mso_mac-mso_o365b/how-to-create-new-profile-in-outlook-for-mac/7af4acf5-7f02-486b-9d6c-ae9f6f941ea8)
  ```bash
  $ open "/Applications/Microsoft Outlook.app/Contents/SharedSupport/Outlook Profile Manager.app"
  ```

### ms office
#### [uninstall completely](https://answers.microsoft.com/en-us/msoffice/forum/all/microsoftoffice161618081201installerpkg-download/09eb6c6b-8615-4c6e-93cf-4bba4f7dcac3)
  > If you still meet the issue, I suggest you try the following steps and resign into Office to check the result:
  > Navigated to Library folder and open Group Containers. Ctrl+click each of these folders if present, and Move to Trash.
  > ```bash
  > UBF8T346G9.ms
  > UBF8T346G9.Office
  > UBF8T346G9.OfficeOsfWebHost
  > ```
  > Warning: Outlook data will be removed when you move the three folders listed in this step to Trash. You should back up these folders before you delete them.

```bash
$ ls -1d ~/Library/Group\ Containers/UBF8T346G9.*/
/Users/marslo/Library/Group Containers/UBF8T346G9.Office/
/Users/marslo/Library/Group Containers/UBF8T346G9.OfficeOneDriveSyncIntegration/
/Users/marslo/Library/Group Containers/UBF8T346G9.OfficeOsfWebHost/
/Users/marslo/Library/Group Containers/UBF8T346G9.OneDriveStandaloneSuite/
/Users/marslo/Library/Group Containers/UBF8T346G9.com.microsoft.rdc/
/Users/marslo/Library/Group Containers/UBF8T346G9.ms/
```

- [pbowden-msft/Unlicense](https://github.com/pbowden-msft/Unlicense/blob/master/Unlicense)
- [[FIX] Error When Opening Word or Outlook on Mac (EXC_BAD_INSTRUCTION)](https://appuals.com/exc_bad_instruction/)
- [How to remove Office license files on a Mac](https://support.microsoft.com/en-us/office/how-to-remove-office-license-files-on-a-mac-b032c0f6-a431-4dad-83a9-6b727c03b193)
- [Having problems with Office and Outlook for Mac 2016 (Sept/Oct 2017)](https://www.itguyswa.com.au/problems-with-outlook-for-mac-2016-solved/)

### logs
- word: `~/Library/Containers/com.microsoft.Word /Data/Library/Caches/Microsoft/uls/ Com.microsoft.Word /logs`
  ```bash
  $ tail -f ~/Library/Containers/com.microsoft.Word/Data/Library/Caches/Microsoft/uls/com.microsoft.Word/logs/apple-device-log-20210114-2301.log
  ```
