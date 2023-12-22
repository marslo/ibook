<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

  - [system information](#system-information)
    - [Get OSX Info](#get-osx-info)
    - [Reboot if system freezed](#reboot-if-system-freezed)
    - [Setup HostName and LocalHostname](#setup-hostname-and-localhostname)
    - [Setup Bash as default SHELL](#setup-bash-as-default-shell)
    - [Disable Guest User](#disable-guest-user)
    - [Go to Hidden path in Finder](#go-to-hidden-path-in-finder)
    - [ReIndex Spotlight](#reindex-spotlight)
    - [copy STDOUT into clipboard](#copy-stdout-into-clipboard)
    - [Copy path from finder](#copy-path-from-finder)
  - [System Integrity Protection](#system-integrity-protection)
  - [change Mac default settings](#change-mac-default-settings)
  - [development environment](#development-environment)
    - [Setup JAVA_HOME](#setup-java_home)
    - [xCode](#xcode)
  - [Homebrew](#homebrew)
  - [system settings](#system-settings)
  - [accessory](#accessory)
  - [QnA](#qna)
    - [x86_64 liblzma.dylib in nokogiri](#x86_64-liblzmadylib-in-nokogiri)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->


## system information
### Get OSX Info
```bash
$ sw_vers
ProductName:	Mac OS X
ProductVersion:	10.15.6
BuildVersion:	19G73

$ /usr/sbin/system_profiler SPHardwareDataType
Hardware:

    Hardware Overview:

      Model Name: MacBook Pro
      Model Identifier: MacBookPro15,1
      Processor Name: 6-Core Intel Core i7
      Processor Speed: 2.2 GHz
      Number of Processors: 1
      Total Number of Cores: 6
      L2 Cache (per Core): 256 KB
      L3 Cache: 9 MB
      Hyper-Threading Technology: Enabled
      Memory: 16 GB
      Boot ROM Version: 1037.147.1.0.0 (iBridge: 17.16.16065.0.0,0)
      Serial Number (system): C02XFGWEJG5H
      Hardware UUID: 4EA008BF-9B36-5F1D-9151-AD4F64808AAB
      Activation Lock Status: Enabled
```

![system-info](../screenshot/osx/system_info.png)

#### get CPU information
```bash
$ sysctl -n machdep.cpu.brand_string
Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz

# or

$ sysctl machdep.cpu
machdep.cpu.max_basic: 22
machdep.cpu.max_ext: 2147483656
machdep.cpu.vendor: GenuineIntel
machdep.cpu.brand_string: Intel(R) Core(TM) i7-8750H CPU @ 2.20GHz
machdep.cpu.family: 6
...
```

#### get more details
```bash
$ sysctl -a
```

### Reboot if system freezed
```bash
$ sudo systemsetup -setrestartfreeze on
```

### Setup HostName and LocalHostname
```bash
$ sudo scutil --set HostName [HOSTNAME]
$ sudo scutil --set LocalHostName [HOSTNAME]
$ sudo scutil --set ComputerName [HOSTNAME]             # Optional
$ dscacheutil -flushcache                               # Flush the DNS Cache
$ sudo shutdown -r now
```

### Setup Bash as default SHELL
```bash
$ chsh -s /bin/bash
# OR
$ chsh -s `which bash`
```

### Disable Guest User
```bash
$ dscl . delete /Users/Guest
$ sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO
$ sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO
```

### Go to Hidden path in Finder

<kbd>Command</kbd>+<kbd>Shift</kbd>+<kbd>G</kbd>

### ReIndex Spotlight
```bash
$ sudo mdutil -i on /
$ sudo mdutil -E /
$ sudo mdutil -E /Volumes/marslo/
```

- [or](https://www.macrumors.com/how-to/rebuild-spotlight-search-index-on-mac/)
  ```bash
  $ sudo dutil -i off /
  $ sudo rm -rf /.Spotlight-V100
  $ sudo rm -rf /.Spotlight-V200
  $ sudo mdutil -i on /
  $ sudo mdutil -E /
  $ sudo mdutil -E /Volumes/marslo/
  ```

### copy STDOUT into clipboard
> refer to: [osx/tricky](../osx/tricky.md#copy-stdout-into-clipboard)

### Copy path from finder
> refer to: [osx/tricky](../osx/tricky.md##copy-path-from-finder)

## [System Integrity Protection](https://derflounder.wordpress.com/2015/10/01/system-integrity-protection-adding-another-layer-to-apples-security-model/)
> refer to: [osx/tricky](../osx/osx.md#system-integrity-protection)

## change Mac default settings
> refer to: [osx/defaults](../osx/defaults.md)

## development environment
### [Setup JAVA_HOME](https://docs.oracle.com/javase/9/install/installation-jdk-and-jre-macos.htm#JSJIG-GUID-C5F0BF25-3487-4F33-9275-7000C8E1C58C)
```bash
$ /usr/libexec/java_home -v 1.8.0.162 -exec javac -versioin
```

### xCode
> refer to [osx](../osx/osx.md#xcode)

#### xCode installation
- Install from App Store
- Offline Package
  - [xCode 9.0.1](https://download.developer.apple.com/Developer_Tools/Xcode_9.0.1/Xcode_9.0.1.xip)
  - [Command_Line_Tools_macOS_10.13_for_Xcode_9.0.1](https://download.developer.apple.com/Developer_Tools/Command_Line_Tools_macOS_10.13_for_Xcode_9.0.1/Command_Line_Tools_macOS_10.13_for_Xcode_9.0.1.dmg)
  - [All Packages](https://developer.apple.com/download/more/)
- [more details](../osx/osx.md#xcode)

#### xCode Setup
```bash
$ sudo xcodebuild -license [accept]
```

#### xCode CommandLine Tools
- Verify installed or not
  ```bash
  $ xcode-select -p
  ```

- xCode CommandLine tools Installation
  ```bash
  $ xcode-select --install
  xcode-select: note: install requested for command line developer tools
  ```

- upgrade CommandLine tools
  ```bash
  $ softwareupdate --all --install --force
  ```
  or
  ```bash
  $ sudo rm -rf /Library/Developer/CommandLineTools
  $ sudo xcode-select --install
  ```

#### xcode Components Installation
```bash
$ for pkg in /Applications/Xcode.app/Contents/Resources/Packages/*.pkg; do
>   sudo installer -pkg "$pkg" -target /;
> done
```

- example:
  ```bash
  $ ls -altrh /Applications/Xcode.app/Contents/Resources/Packages/
  total 180512
  -rw-r--r--   1 root  wheel    87K Mar 10  2017 MobileDeviceDevelopment.pkg
  -rw-r--r--   1 root  wheel   5.4M Sep 30 05:28 XcodeSystemResources.pkg
  -rw-r--r--   1 root  wheel    11K Sep 30 05:28 XcodeExtensionSupport.pkg
  -rw-r--r--   1 root  wheel    83M Sep 30 05:28 MobileDevice.pkg
  drwxr-xr-x   6 root  wheel   204B Oct 11 05:23 ./
  drwxr-xr-x  87 root  wheel   2.9K Oct 11 05:55 ../

  $ for pkg in /Applications/Xcode.app/Contents/Resources/Packages/*.pkg; do
   -> sudo installer -pkg "$pkg" -target /;
   -> done
  installer: Package name is MobileDevice
  installer: Upgrading at base path /
  installer: The upgrade was successful.
  installer: Package name is MobileDeviceDevelopment
  installer: Installing at base path /
  installer: The install was successful.
  installer: Package name is XcodeExtensionSupport
  installer: Installing at base path /
  installer: The install was successful.
  installer: Package name is XcodeSystemResources
  installer: Installing at base path /
  installer: The install was successful.
  ```

#### Enable Developer Mode
```bash
$ DevToolsSecurity -enable
```

#### show SDK path
```bash
$ xcrun --show-sdk-path
/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk
```

## Homebrew
> refer to: [osx/apps.md](../osx/apps.md#homebrew)

## system settings
> refer to: [osx/apps](../osx/apps.md#system-settings)

## accessory
> refer to: [osx/apps](../osx/apps.md#accessory)

## QnA
### [x86_64 liblzma.dylib in nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html)
- Solution 1:
  ```bash
  $ brew unlink xz
  $ gem install nokogiri # or gem install cupertino
  $ brew link xz
  ```

- Solutioin 2 (using system libraies):
  ```bash
  $ brew install libxml2
  $ gem install nokogiri -- --use-system-libraries --with-xml2-include=$(brew --prefix libxml2)/include/libxml2
  ```

  or
  ```bash
  $ bundle config build.nokogiri --use-system-libraries --with-xml2-include=$(brew --prefix libxml2)/include/libxml2
  $ bundle install
  ```

  or
  ```bash
  $ brew link --force libxml2
  $ gem install nokogiri -v '1.7.0.1'  -- --use-system-libraries --with-xml2-include=/usr/include/libxml2 --with-xml2-lib=/usr/lib
  ```

# Reference
- [osx chflags man page](https://ss64.com/osx/chflags.html)
- [Show Hidden Files in Mac OS X](http://osxdaily.com/2009/02/25/show-hidden-files-in-os-x/)
- [Mac Keyboard Shortcuts](https://www.danrodney.com/mac/)
- [How to reinstall macOS](https://support.apple.com/en-us/HT204904)
- [How to Find the Wi-Fi Password of your Current Network](https://www.labnol.org/software/find-wi-fi-network-password/28949/)
- [How to Find Wi-Fi Network Passwords from Command Line on Mac](http://osxdaily.com/2015/07/24/find-wi-fi-network-router-password-command-line-mac/)
- [5 Stupid Terminal Tricks to Keep You Entertained](http://osxdaily.com/2012/10/05/stupid-terminal-tricks/)
- [Install Nokogiri](http://www.nokogiri.org/tutorials/installing_nokogiri.html)
- [OSX实用命令](http://blog.topspeedsnail.com/archives/84)
- [Locking files and folders to prevent changes ](http://hints.macworld.com/article.php?story=20031017061722471)
