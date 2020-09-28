<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [sdkmanager](#sdkmanager)
  - [list](#list)
  - [download sdk while building](#download-sdk-while-building)
  - [debug](#debug)
  - [install](#install)
- [android package management](#android-package-management)
  - [list remote sdk](#list-remote-sdk)
  - [list local sdk](#list-local-sdk)
  - [update sdk](#update-sdk)
- [manual download](#manual-download)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## sdkmanager

### list
#### list available package
```bash
$ sdkmanager --no_https --proxy=socks --proxy_port=1880 --proxy_host=localhost --list
Installed packages:=====================] 100% Computing updates...
  Path    | Version | Description              | Location
  ------- | ------- | -------                  | -------
  tools   | 26.1.1  | Android SDK Tools 26.1.1 | tools/

Available Packages:
  Path                                    | Version      | Description
  -------                                 | -------      | -------
  add-ons;addon-google_apis-google-15     | 3            | Google APIs
  add-ons;addon-google_apis-google-16     | 4            | Google APIs
  add-ons;addon-google_apis-google-17     | 4            | Google APIs
  add-ons;addon-google_apis-google-18     | 4            | Google APIs
  add-ons;addon-google_apis-google-19     | 20           | Google APIs
  add-ons;addon-google_apis-google-21     | 1            | Google APIs
  add-ons;addon-google_apis-google-22     | 1            | Google APIs
  add-ons;addon-google_apis-google-23     | 1            | Google APIs
  add-ons;addon-google_apis-google-24     | 1            | Google APIs
  add-ons;addon-google_gdk-google-19      | 11           | Glass Development Kit Preview
  build-tools;19.1.0                      | 19.1.0       | Android SDK Build-Tools 19.1
  build-tools;20.0.0                      | 20.0.0       | Android SDK Build-Tools 20
  build-tools;21.1.2                      | 21.1.2       | Android SDK Build-Tools 21.1.2
  ...
```

#### list
```bash
$  find /opt/android-sdk/ -name package.xml -exec sh -c 'eval $(xmllint --xpath "//*[local-name()='\'localPackage\'']/@path" $0) && echo $path' {} \;
platforms;android-26
platforms;android-17
platforms;android-22
platforms;android-23
platforms;android-24
platforms;android-18
platforms;android-21
platforms;android-19
platforms;android-25
platforms;android-16
docs
build-tools;24.0.1
build-tools;22.0.1
build-tools;25.0.2
build-tools;25.0.3
build-tools;23.0.1
...

$ sdkmanager --list --verbose
Info: Parsing legacy package: /opt/android-sdk/android-ndk
Info: Parsing /opt/android-sdk/build-tools/19.1.0/package.xml
Info: Parsing /opt/android-sdk/build-tools/20.0.0/package.xml
Info: Parsing /opt/android-sdk/build-tools/21.1.2/package.xml
Info: Parsing /opt/android-sdk/build-tools/22.0.1/package.xml
Info: Parsing /opt/android-sdk/build-tools/23.0.1/package.xml
...
```

#### list target
```bash
$  android list target
Available Android targets:
----------
id: 1 or "android-15"
     Name: Android 4.0.3
     Type: Platform
     API level: 15
     Revision: 5
     Skins: HVGA, QVGA, WQVGA400, WQVGA432, WSVGA, WVGA800 (default), WVGA854, WXGA720, WXGA800
 Tag/ABIs : no ABIs.
----------
id: 2 or "android-16"
     Name: Android 4.1.2
     Type: Platform
     API level: 16
     Revision: 5
     Skins: HVGA, QVGA, WQVGA400, WQVGA432, WSVGA, WVGA800 (default), WVGA854, WXGA720, WXGA800, WXGA800-7in
 Tag/ABIs : no ABIs.
----------
...
```

### [download sdk while building](https://discuss.gradle.org/t/http-s-proxy-problem/23427/2)
```bash
GRADLE_OPTS='-Dorg.gradle.daemon=false -Dandroid.builder.sdkDownload=true -Dorg.gradle.jvmargs=-Xmx2048M -Dhttp.proxyHost=sample.localnet -Dhttp.proxyPort=80 -Dhttps.proxyHost=sample.localnet -Dhttps.proxyPort=80' HTTPS_PROXY=http://sample.localnet:80 HTTP_PROXY=http://sample.localnet:80 _JAVA_OPTIONS='-Dhttp.proxyHost=sample.localnet -Dhttp.proxyPort=80 -Dhttps.proxyHost=sample.localnet -Dhttps.proxyPort=80' http_proxy=http://sample.localnet:80 https_proxy=http://sample.localnet:80
```

### [debug](https://stackoverflow.com/a/48810497)
```bash
$ strace -e trace=network -y -s 256 -f -o strace.log tools/bin/sdkmanager --update
```

### install
```bash
$ sdkmanager "platform-tools" "platforms;android-26"  --no_https --proxy=http --proxy_host=192.168.1.100 --proxy_port=8000 --verbose
Info: Parsing legacy package: /opt/android-sdk/android-ndk
Info: Parsing /opt/android-sdk/build-tools/19.1.0/package.xml
Info: Parsing /opt/android-sdk/build-tools/20.0.0/package.xml
Info: Parsing /opt/android-sdk/build-tools/21.1.2/package.xml
Info: Parsing /opt/android-sdk/build-tools/22.0.1/package.xml
Info: Parsing /opt/android-sdk/build-tools/23.0.1/package.xml
Info: Parsing /opt/android-sdk/build-tools/23.0.2/package.xml
Info: Parsing /opt/android-sdk/build-tools/23.0.3/package.xml
Info: Parsing /opt/android-sdk/build-tools/24.0.0/package.xml
Info: Parsing /opt/android-sdk/build-tools/24.0.1/package.xml
Info: Parsing /opt/android-sdk/build-tools/24.0.2/package.xml
Info: Parsing /opt/android-sdk/build-tools/24.0.3/pac kage.xml
...

```

#### plugin installation
```bash
$ sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" --no_https --proxy=http --proxy_host=192.168.1.100 --proxy_port=8000
    /opt/android-sdk/extras/m2repository/com/android/support/constraint/constraint-layout/1.0.2/constraint-layout-1.0.2.aar

$ sdkmanager "extras;android;m2repository;com;android;support;multidex;1.0.2" --no_https --proxy=http --proxy_host=192.168.1.100 --proxy_port=8000
    /opt/android-sdk/extras/android/m2repository/com/android/support/multidex/1.0.1/multidex-1.0.1.aar
"extras;android;m2repository;com;android;support;multidex;1.0.2"

$ sdkmanager "add-ons;addon-google_apis-google-21" --no_https --proxy=http --proxy_host=192.168.1.100 --proxy_port=8000
Done
/opt/android-sdk/add-ons/addon-google_apis-google-21
```

## android package management
### list remote sdk
```bash
$ android list sdk --no-https --proxy-host 192.168.1.100 --proxy-port 8000
Refresh Sources:
  Fetching http://dl.google.com/android/repository/addons_list-2.xml
  Validate XML
  Parse XML
  Fetched Add-ons List successfully
  Refresh Sources
  Fetching URL: http://dl.google.com/android/repository/repository-11.xml
  Validate XML: http://dl.google.com/android/repository/repository-11.xml
  Parse XML:    http://dl.google.com/android/repository/repository-11.xml
  Fetching URL: http://dl.google.com/android/repository/addon.xml
  Validate XML: http://dl.google.com/android/repository/addon.xml
  ...
```
### list local sdk
```bash
$ android list
Available Android targets:
----------
id: 1 or "android-16"
     Name: Android 4.1.2
     Type: Platform
     API level: 16
     Revision: 5
     Skins: HVGA, QVGA, WQVGA400, WQVGA432, WSVGA, WVGA800 (default), WVGA854, WXGA720, WXGA800, WXGA800-7in
 Tag/ABIs : no ABIs.
----------
id: 2 or "android-17"
     Name: Android 4.2.2
     Type: Platform
     API level: 17
     Revision: 3
     Skins: HVGA, QVGA, WQVGA400, WQVGA432, WSVGA, WVGA800 (default), WVGA854, WXGA720, WXGA800, WXGA800-7in
 Tag/ABIs : no ABIs.
----------
...
```
### update sdk
```bash
$  android update sdk --no-ui  --no-https --proxy-host 192.168.1.100 --proxy-port 8000
Refresh Sources:
  Fetching http://dl.google.com/android/repository/addons_list-2.xml
  Validate XML
  Parse XML
  Fetched Add-ons List successfully
  Refresh Sources
  Fetching URL: http://dl.google.com/android/repository/repository-11.xml
  Validate XML: http://dl.google.com/android/repository/repository-11.xml
  Parse XML:    http://dl.google.com/android/repository/repository-11.xml
  Fetching URL: http://dl.google.com/android/repository/addon.xml
  Validate XML: http://dl.google.com/android/repository/addon.xml
  Parse XML:    http://dl.google.com/android/repository/addon.xml
  Fetching URL: http://dl.google.com/android/repository/glass/addon.xml
  Validate XML: http://dl.google.com/android/repository/glass/addon.xml
  Parse XML:    http://dl.google.com/android/repository/glass/addon.xml
  Fetching URL: http://dl.google.com/android/repository/extras/intel/addon.xml
  Validate XML: http://dl.google.com/android/repository/extras/intel/addon.xml
  ...
```

## manual download
```bash
https://dl.google.com/android/repository/
https://dl.google.com/android/repository/tools_r25.2.5-linux.zip

Tools:
    Android SDK Platform-tools
        https://dl.google.com/android/repository/platform-tools_r25.0.3-linux.zip
        https://dl.google.com/android/repository/platform-tools_r25.0.3-linux.zip

    Android SDK Build-tools:
        - https://dl.google.com/android/repository/build-tools_r25.0.2-linux.zip
        - https://dl.google.com/android/repository/build-tools_r25.0.1-linux.zip
        - https://dl.google.com/android/repository/build-tools_r25-linux.zip
        - https://dl.google.com/android/repository/build-tools_r24.0.3-linux.zip
        - https://dl.google.com/android/repository/build-tools_r24.0.2-linux.zip
        - https://dl.google.com/android/repository/build-tools_r24.0.1-linux.zip
        - https://dl.google.com/android/repository/build-tools_r24-linux.zip
        - https://dl.google.com/android/repository/build-tools_r23.0.3-linux.zip
        - https://dl.google.com/android/repository/build-tools_r23.0.2-linux.zip
        - https://dl.google.com/android/repository/build-tools_r23.0.1-linux.zip
        - https://dl.google.com/android/repository/build-tools_r22.0.1-linux.zip
        - https://dl.google.com/android/repository/build-tools_r21.1.2-linux.zip
        - https://dl.google.com/android/repository/build-tools_r20-linux.zip
        - https://dl.google.com/android/repository/build-tools_r19.1-linux.zip

    Android 7.1.1 (API 25)
        - SDK Platform:
        https://dl.google.com/android/repository/platform-25_r03.zip
        platforms/android-25

    Android 7.0 (API 24)
        - SDK Platform:
        https://dl.google.com/android/repository/platform-24_r02.zip
        platforms/android-24

        - Document:
        https://dl.google.com/android/repository/docs-24_r01.zip
        docs/

        - Google APIs
        https://dl.google.com/android/repository/google_apis-24_r1.zip
        add-ons/addon-google_apis-google-24

    Android 6.0  (API 23)
        - SDK Platform
        https://dl.google.com/android/repository/platform-23_r03.zip
        platforms/android-23

        - Document:
        https://dl.google.com/android/repository/docs-23_r01.zip
        docs/

        - Google APIs
        https://dl.google.com/android/repository/google_apis-23_r01.zip
        add-ons/addon-google_apis-google-23

    Android 5.1.1 (API 22)
        - SDK Platform
        https://dl.google.com/android/repository/android-22_r02.zip
        platforms/android-23

        - Google APIs
        https://dl.google.com/android/repository/google_apis-22_r01.zip
        add-ons/addon-google_apis-google-22

    Extra:
        - Android Support Repository
        https://dl.google.com/android/repository/android_m2repository_r44.zip
        extras/android/m2repository

        - Android Auto Desktop Head Unit emulator
        https://dl.google.com/android/repository/desktop-head-unit-linux_r01.1.zip
        extras/google/auto

        - Google Play Services
        https://dl.google.com/android/repository/google_play_services_v9_rc41.zip
        extras/google/google_play_services

        - Google Repository
        https://dl.google.com/android/repository/google_m2repository_gms_v9_rc41_wear_2_0_rc6.zip
        extras/google/m2repository


        - Google Play APK Expansion library
        https://dl.google.com/android/repository/market_apk_expansion-r03.zip
        extras/google/market_apk_expansion

        - Google Play Licensing Library
        https://dl.google.com/android/repository/market_licensing-r02.zip
        extras/google/market_licensing

        - Google Play Billing Library
        https://dl.google.com/android/repository/play_billing_r05.zip
        extras/google/play_billing

        - Android Auto API Simulators
        https://dl.google.com/android/repository/simulator_r01.zip
        extras/google/simulators

        - Google USD Driver
        https://dl.google.com/android/repository/usb_driver_r11-windows.zip
        extras/google/usb_driver

        - Google Web Driver
        https://dl.google.com/android/repository/webdriver_r02.zip
        extras/google/webdriver

        - Intel x86 Emulator Accelerator (HAXM Installer)
        http://mirrors.neusoft.edu.cn/android/repository/extras/intel/
```
