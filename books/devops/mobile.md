<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ios](#ios)
  - [get info](#get-info)
  - [idevice](#idevice)
  - [list apps](#list-apps)
  - [install app](#install-app)
  - [idevicediagnostics](#idevicediagnostics)
- [andriod](#andriod)
  - [environment](#environment)
  - [get info](#get-info-1)
  - [show list](#show-list)
  - [install & uninstall](#install--uninstall)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## ios
### get info
#### [get info from *.plist](https://stackoverflow.com/questions/11307275/how-can-i-find-the-version-number-of-an-iphone-app-from-the-ipa)
```bash
$ /usr/libexec/PlistBuddy -c "Print :CFBundleIdentifier" package/Info.plist
com.mycompany.myapp.demo

$ /usr/libexec/PlistBuddy -c print package/Info.plist | grep CFBundleVersion
    CFBundleVersion = 185
```

#### get ipa file information
```bash
$ gem install shenzhen
$ ipa info myapp-0.3.0/myapp.ipa
security: SecPolicySetValue: One or more parameters passed to a function were not valid.
+-----------------------------+---------------------------------------------------------+
| AppIDName                   | mymobileapp                                             |
| ApplicationIdentifierPrefix | 9BXY7H1234                                              |
| CreationDate                | 2017-04-13T04:58:51+00:00                               |
| Platform                    | iOS                                                     |
| Entitlements                | keychain-access-groups: ["9BXY7H1234.*"]                |
|                             | get-task-allow: false                                   |
|                             | application-identifier: 9BXY7H1234.com.mycompany.my.app |
|                             | com.apple.developer.healthkit: true                     |
|                             | com.apple.developer.team-identifier: 9BXY7H1234         |
|                             | aps-environment: production                             |
| ExpirationDate              | 2018-04-13T04:58:51+00:00                               |
| Name                        | myappPilotAppDistribution                               |
| ProvisionsAllDevices        | true                                                    |
| TeamIdentifier              | 9BXY7H1234                                              |
| TeamName                    | mycompany (China) Investment Co., Ltd                   |
| TimeToLive                  | 365                                                     |
| UUID                        | 4b73738f-d730-49e4-a8eb-0031275cdee4                    |
| Version                     | 1                                                       |
| Codesigned                  | False                                                   |
+-----------------------------+---------------------------------------------------------+

```

#### check version
- `mobileprovision`
    ```bash
    $ unzip -l myapp-0.3.0/myapp.ipa  | grep mobileprovision
                                     7589  06-30-2017 17:29   Payload/myapp.app/embedded.mobileprovision
    ```

- get version
    ```bash
    $ unzip -p myapp-0.3.0/myapp.ipa "Payload/myapp.app/embedded.mobileprovision" | security cms -D | egrep \<key.*Version -A 1 | egrep \<integer | sed -r -e 's:^.*integer>(.*)<.*$:\1:'
    security: SecPolicySetValue: One or more parameters passed to a function were not valid.
    1
    ```

- details
    ```bash
    $ unzip -p myapp-0.3.0/myapp.ipa "Payload/myapp.app/embedded.mobileprovision" | security cms -D | grep version
    security: SecPolicySetValue: One or more parameters passed to a function were not valid.
    <?xml version="1.0" encoding="UTF-8"?>
    <plist version="1.0">

    $ unzip -p myapp-0.3.0/myapp.ipa "Payload/myapp.app/embedded.mobileprovision" | security cms -D | egrep \<key.*Version -A 1 | egrep \<integer
    security: SecPolicySetValue: One or more parameters passed to a function were not valid.
            <integer>1</integer>

    $ unzip -p myapp-0.3.0/myapp.ipa "Payload/myapp.app/embedded.mobileprovision" | security cms -D
    security: SecPolicySetValue: One or more parameters passed to a function were not valid.
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
            <key>AppIDName</key>
            <string>myapp</string>
            <key>ApplicationIdentifierPrefix</key>
            <array>
            <string>9BXY7H1234</string>
            </array>
    ...
    ```

#### [get uuid](https://gist.github.com/benvium/2568707)
```bash
uuid=$(/usr/libexec/PlistBuddy -c 'Print :UUID' /dev/stdin <<< $(security cms -D -i ${mp})_)
uuid=$(/usr/libexec/PlistBuddy -c 'Print :Entitlements:application-identifier' /dev/stdin <<< $(security cms -D -i ${mp})_)
```

### idevice

- list real devices
    ```bash
    $ idevice_id -l
    02be8bb96f479db9ff691f7e57c2344d170b363c
    521d2bba6b5da32ad61aa7ea516fc45e31300a0f
    ```

- list simulator & devices
    ```bash
    $ instruments -s devices
    Known Devices:
    devops-slave08 [BEFBB759-F3EF-5053-94B4-EC21E6F032F7]
    devops-iphone (11.2.6) [521d2bba6b5da32ad61aa7ea516fc45e31300a0f]
    devops-ipad (11.2.6) [02be8bb96f479db9ff691f7e57c2344d170b363c]
    Apple TV 1080p (10.2) [F546057D-6F75-40C6-ADB2-958ED8ACAF45] (Simulator)
    iPad (5th generation) (10.3.1) [7D221270-6E99-4C25-B3F0-FD3ABF4ADE38] (Simulator)
    iPad Air (10.3.1) [C4AC315A-FD89-4D6B-B7B9-3CDA2088A36E] (Simulator)
    iPad Air 2 (10.3.1) [01F1D17D-5666-4B40-A8DC-F38FB7E3A266] (Simulator)
    ...
    ```

### list apps
```bash
$ ideviceinstaller -u ${DEVICEID} --list-apps
CFBundleIdentifier, CFBundleVersion, CFBundleDisplayName
com.mycompany.my.app, "1384", "myapp"
```

#### List the 3rd part apps
```bash
$ ideviceinstaller -u ${DEVICEID} --list-apps -o list_user
CFBundleIdentifier, CFBundleVersion, CFBundleDisplayName
com.mycompany.my.app, "1384", "myapp"
```

#### list default apps
```bash
$ ideviceinstaller -u ${DEVICEID} --list-apps -o list_system
CFBundleIdentifier, CFBundleVersion, CFBundleDisplayName
com.apple.AXUIViewService, "1", "AXUIViewService"
com.apple.AccountAuthenticationDialog, "1.0", "AccountAuthenticationDialog"
com.apple.AdSheetPhone, "1.0", "iAd"
com.apple.AppStore, "1", "App Store"
com.apple.AskPermissionUI, "1.0", "AskPermissionUI"
com.apple.CTCarrierSpaceAuth, "1", "CTCarrierSpaceAuth"
...
```

### install app
```bash
$ /usr/local/bin/ideviceinstaller -u ${DEVICEID} --install $(find ${WORKSPACE}/package -name "*.ipa")
WARNING: could not locate iTunesMetadata.plist in archive!
WARNING: could not locate Payload/myapp.app/SC_Info/myapp.sinf in archive!
Copying '/Users/devops/workspace/platform_mobile_deploy/package/myapp_ios_app-1.1.1389.ipa' to device... DONE.
Installing 'com.mycompany.my.app'
Install: CreatingStagingDirectory (5%)
Install: ExtractingPackage (15%)
Install: InspectingPackage (20%)
Install: TakingInstallLock (20%)
Install: PreflightingApplication (30%)
Install: InstallingEmbeddedProfile (30%)
Install: VerifyingApplication (40%)
Install: CreatingContainer (50%)
Install: InstallingApplication (60%)
Install: PostflightingApplication (70%)
Install: SandboxingApplication (80%)
Install: GeneratingApplicationMap (90%)
Install: Complete
```

### [idevicediagnostics](http://krypted.com/uncategorized/command-line-ios-device-management/)
#### restart device
```bash
$ idevicediagnostics restart -u ${DEVICEID}
Restarting device.
```

#### get provision
```bash
$ idevicediagnostics diagnostics All -u ${DEVICEID}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>GasGauge</key>
    <dict>
        <key>CycleCount</key>
        <integer>3</integer>
        <key>DesignCapacity</key>
        <integer>1810</integer>
        <key>FullChargeCapacity</key>
        <integer>1900</integer>
        <key>Status</key>
        <string>Success</string>
</dict>
```
#### [idevicepair](http://krypted.com/uncategorized/command-line-ios-device-management/)
```bash
$ idevicepair pair -u 521d2bba6b5da32ad61aa7ea516fc45e31300a0f
SUCCESS: Paired with device 521d2bba6b5da32ad61aa7ea516fc45e31300a0f

$ idevicepair pair -u 02be8bb96f479db9ff691f7e57c2344d170b363c
SUCCESS: Paired with device 02be8bb96f479db9ff691f7e57c2344d170b363c
```

#### [ideviceprovision](http://krypted.com/uncategorized/command-line-ios-device-management/)
```bash
$ ideviceprovision list -u ${DEVICEID}
Device has 4 provisioning profiles installed:
4b73738f-d730-49e4-a8eb-0031275cdee4 - myappPilotAppDistribution
b84ef185-a387-4a1d-8a41-3230708c6b31 - iOS Team Provisioning Profile: com.mycompany.cdtest.WebDriverAgentRunner
59ecee46-f43f-4a87-a89e-f9b03f14cf01 - XC iOS: com.mycompany.myapp.demo
83d90272-79fe-4f8f-8ea5-8f18f60b5683 - myappDemoDev
```

## [andriod](https://gist.github.com/Pulimet/5013acf2cd5b28e55036c82c91bd56d8)
### environment
```bash
$ ln -sf /opt/android/platform-tools/adb /usr/local/bin/adb
$ ln -sf /opt/android/build-tools/27.0.3/aapt /usr/local/bin/aapt
$ ln -sf /opt/android/build-tools/27.0.3/aapt2 /usr/local/bin/aapt2
```
### get info
#### [get bundle id from *.ipa](http://www.growingwiththeweb.com/2014/01/handy-adb-commands-for-android.html)
```bash
$ aapt dump badging ${apkFile} | grep package | sed -r -e "s:^.*name='([^']*).*$:\\1:"
$ aapt dump badging package/myapp-1.3.85.apk | grep package | sed -r -e "s:^.*name='([^']*).*$:\\1:"
com.mycompany.myapp.demo

$ aapt dump badging package/myapp-1.3.85.apk | grep package
package: name='com.mycompany.myapp.demo' versionCode='1030085' versionName='1.3.85' platformBuildVersionName='8.0.0'
$ aapt dump badging package/myapp-1.3.85.apk
package: name='com.mycompany.myapp.demo' versionCode='1030085' versionName='1.3.85' platformBuildVersionName='8.0.0'
sdkVersion:'19'
targetSdkVersion:'26'
uses-permission: name='android.permission.INTERNET'
uses-permission: name='android.permission.ACCESS_NETWORK_STATE'
uses-permission: name='android.permission.ACCESS_WIFI_STATE'
uses-permission: name='android.permission.READ_PHONE_STATE'
uses-permission: name='android.permission.WRITE_EXTERNAL_STORAGE'
uses-permission: name='android.permission.READ_EXTERNAL_STORAGE'
...
```

#### [get imei](https://stackoverflow.com/questions/6852106/is-there-an-android-shell-or-adb-command-that-i-could-use-to-get-a-devices-imei)
```bash
$ adb shell service call iphonesubinfo 1 | awk -F "'" '{print $2}' | sed '1 d' | tr -d '.' | awk '{print}' ORS=
864226033999836

$ echo "[device.imei]: [$(adb shell service call iphonesubinfo 1 | awk -F "'" '{print $2}' | sed '1 d'| tr -d '\n' | tr -d '.' | tr -d ' ')]"
[device.imei]: [864226033999836]

$ echo "[device.imei]: [$(adb shell service call iphonesubinfo 1 | awk -F "'" '{print $2}' | sed '1 d'| tr -d '\n' | tr -d '.' | tr -d ' ')]"; adb shell getprop | grep "model\|version.sdk\|manufacturer\|ro.serialno\|product.name\|brand\|version.release\|build.id\|security_patch" | sed 's/ro\.//g'
[device.imei]: [864226033999836]
[persist.sys.modelnumber]: [NX569H]
[build.id]: [MMB29M]
[build.version.release]: [6.0.1]
[build.version.sdk]: [23]
[build.version.security_patch]: [2017-02-01]
[product.brand]: [nubia]
[product.manufacturer]: [nubia]
[product.model]: [NX569H]
[product.name]: [NX569H]
[serialno]: [fac7ea46]
```

#### get andriod version
```bash
$ adb shell getprop ro.build.version.release
6.0.1
```

### show list
#### [list installed apps](http://www.growingwiththeweb.com/2014/01/handy-adb-commands-for-android.html)
```bash
$ adb -s fac7ea46 shell 'pm list packages' | grep 'com.mycompany.myapp.demo'
package:com.mycompany.myapp.demo
```

#### list all apps
```bash
$ adb -s ${DEVICEID} shell 'pm list packages -f' | sed -e 's/.*=//' | sed 's/\r//g' | sort
android
cn.nubia.accounts
cn.nubia.aftersale
cn.nubia.applockmanager
cn.nubia.apps
cn.nubia.appsettingsinfoproviders
cn.nubia.autoagingtest
cn.nubia.bbs
cn.nubia.bootanimationinfo
...
```

#### [list connected device](http://www.growingwiththeweb.com/2014/01/handy-adb-commands-for-android.html)
```bash
$ adb devices
List of devices attached
fac7ea46    device

$ adb devices -l
List of devices attached
fac7ea46               device usb:343089152X product:NX569H model:NX569H device:NX569H transport_id:2
```

### install & uninstall
#### install
```bash
$ adb -s ${DEVICEID} install -r "$(find . -name '*.apk')"

$ adb -s fac7ea46 install ${WORKSPACE}/package/myapp-1.3.84.apk
[  0%] /data/local/tmp/myapp-1.3.84.apk
[  1%] /data/local/tmp/myapp-1.3.84.apk
[  2%] /data/local/tmp/myapp-1.3.84.apk
[  3%] /data/local/tmp/myapp-1.3.84.apk
[  3%] /data/local/tmp/myapp-1.3.84.apk
[  4%] /data/local/tmp/myapp-1.3.84.apk
[  5%] /data/local/tmp/myapp-1.3.84.apk
[  6%] /data/local/tmp/myapp-1.3.84.apk
[  7%] /data/local/tmp/myapp-1.3.84.apk
[  7%] /data/local/tmp/myapp-1.3.84.apk
...
```

#### uninstall
```bash
$ adb -s ${DEVICEID} uninstall ${BUNDLEID}
```

e.g.:
```bash
$ adb -s fac7ea46 uninstall com.mycompany.myapp.demo
Success

$ if adb -s fac7ea46 shell 'pm list packages' | grep 'com.mycompany.myapp.demo'; then
> adb -s fac7ea46 uninstall com.mycompany.myapp.demo
> fi
```
