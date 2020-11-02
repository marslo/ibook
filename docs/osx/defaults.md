<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [change Mac default settings](#change-mac-default-settings)
  - [Enable Key Repeat](#enable-key-repeat)
  - [Disable the .DS_Store file](#disable-the-ds_store-file)
  - [Enable the Hidden file](#enable-the-hidden-file)
  - [Reset iTerm Profile](#reset-iterm-profile)
  - [Dock performance setup](#dock-performance-setup)
  - [Safari Font Size](#safari-font-size)
  - [Disable Spotlight](#disable-spotlight)
  - [Disable Notification Center](#disable-notification-center)
  - [Disable the download apps security](#disable-the-download-apps-security)
  - [Disable the dashboard](#disable-the-dashboard)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->



## change Mac default settings
### Enable Key Repeat
```bash
$ defaults write -g ApplePressAndHoldEnabled -bool false
```

- Restore to Default
  ```bash
  $ defaults delete -g ApplePressAndHoldEnabled
  ```

### Disable the .DS_Store file
```bash
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```

- Enable the .DS_Store
  ```bash
  $ defaults write com.apple.desktopservices DSDontWriteNetworkStores false
  ```

### Enable the Hidden file
```bash
$ defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder
# OR
$ defaults write com.apple.finder AppleShowAllFiles YES
```

### Reset iTerm Profile
```bash
$ cd ~/Library/Preferences/com.googlecode.iterm2.plist
$ defaults delete com.googlecode.iterm2
```

### [Dock performance setup](https://sspai.com/post/33493)
- Minize Windows Using "suck" mode
  ```bash
  $ defaults write com.apple.dock mineffect suck; Killall Dock
  ```
  - Restore to Default:
    ```bash
    System Preferences -> Dock -> Minized Windows Using
    ```

- Highlight icon
  ```bash
  $ defaults write com.apple.dock mouse-over-hilite-stack -bool TRUE;killall Dock
  ```

  - Restore to Default:
    ```bash
    $ defaults delete com.apple.dock mouse-over-hilite-stack;killall Dock
    ```

- Remove none-opened apps
  ```bash
  $ defaults write com.apple.dock static-only -boolean true; killall Dock
  ```

  - Restore to Default:
    ```bash
    $ defaults delete com.apple.dock static-only; killall Dock
    ```

- Hidden icon
  ```bash
  $ defaults write com.apple.dock showhidden -bool true; Killall Dock
  ```
  - Restore to Default
    ```bash
    $ defaults delete com.apple.Dock showhidden; Killall Dock
    ```

### [Safari Font Size](https://discussions.apple.com/thread/7674863?start=0&tstart=0)
```bash
$ defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2MinimumFontSize -int 14
```

### Disable Spotlight
```bash
$ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
```

- Reenable Spotlight
  ```bash
  $ sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  ```

### Disable Notification Center
```bash
$ launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
$ killall NotificationCenter
```

- Reenable Notifaction Center
  ```bash
  $ launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
  ```

### Disable the download apps security
```bash
$ defaults write com.apple.LaunchServices LSQuarantine -bool NO
```

- Reenable the download apps security
  ```bash
  $ defaults write com.apple.LaunchServices LSQuarantine -bool YES
  ```

### Disable the dashboard
```bash
$ defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock
```

- re-enable the dashboard
  ```bash
  $ defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock
  ```
