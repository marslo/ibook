<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [common usage](#common-usage)
  - [commands](#commands)
  - [usage](#usage)
- [Mac defaults](#mac-defaults)
  - [programming](#programming)
  - [disable the startup sounds](#disable-the-startup-sounds)
  - [Dock performance setup](#dock-performance-setup)
  - [keyboard & trackpad](#keyboard--trackpad)
  - [utilities](#utilities)
  - [screenshot](#screenshot)
  - [finder](#finder)
  - [menu bar](#menu-bar)
  - [mission control](#mission-control)
  - [feedback assistant](#feedback-assistant)
  - [time machine](#time-machine)
  - [dock](#dock)
- [backup & restore](#backup--restore)
  - [Moon](#moon)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [macOS defaults](https://macos-defaults.com/)
> - [How To Change Preferences From The Command Line On MacOS?](https://www.shell-tips.com/mac/defaults/)
> - [mac defaults](https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md)
{% endhint %}

## common usage
### commands

|   commands  | comments                                                     |
|:-----------:|--------------------------------------------------------------|
|   `read `   | prints the user’s settings to standard output                |
| `read-type` | prints the plist type for a given key                        |
|   `write`   | write a value for the given key                              |
|   `rename`  | rename a key                                                 |
|   `import`  | import a plist to a given domain                             |
|   `export`  | export a domain and all the keys as a plist                  |
|   `delete`  | delete a given key or a domain / all keys for a given domain |
|  `domains`  | prints the name of all domains                               |
|    `find`   | search all domains, keys, and values for a given word        |

### usage
#### basic usage
```bash
$ defaults read DOMAIN # gets all
$ defaults read DOMAIN PROPERTY_NAME # gets
$ defaults write DOMAIN PROPERTY_NAME VALUE # sets
$ defaults delete DOMAIN PROPERTY_NAME # resets a property
$ defaults delete DOMAIN # resets preferences
```

#### list all domains
```bash
$ defaults domains
```
- i.e.
  ```bash
  $ defaults domains | tr ',' '\n' | head
  ContextStoreAgent
   MobileMeAccounts
   com.100hps.captin
   com.ScooterSoftware.BeyondCompare
   com.app77.pwsafemac
   com.apple.AMPLibraryAgent
   com.apple.ATS
   com.apple.Accessibility
   com.apple.AdLib
   com.apple.AddressBook
  ```

## Mac defaults
### programming
#### xcode
- add additional Counterpart Suffixes
  - `"ViewModel" "View"`
    ```bash
    $ defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "ViewModel" "View" && killall Xcode
    ```
  - `"Router" "Interactor" "Builder"`
    ```bash
    $ defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "Router" "Interactor" "Builder" && killall Xcode
    ```
- Show Build Durations
  ```bash
  $ defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true && killall Xcode
  ```

#### reset iTerm Profile
```bash
$ cd ~/Library/Preferences/com.googlecode.iterm2.plist
$ defaults delete com.googlecode.iterm2
```

#### simulator
- set screenshot location
  - `~/Picture/Screenshots`
    ```bash
    $ defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string ~/Pictures/Screenshots
    ```
  - `~/Picture/Simulator Screenshots`
    ```bash
    $ defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string ~/Pictures/Simulator Screenshots
    ```

### [disable the startup sounds](https://www.youtube.com/watch?v=_OjQIh4Ro5A)
- disable
  ```bash
  $ sudo nvram StartupMute=%01
  ```
- enable
  ```bash
  $ sudo nvram StartupMute=%00
  ```

### [Dock performance setup](https://sspai.com/post/33493)
#### minimize Windows Using "suck" mode
```bash
$ defaults write com.apple.dock mineffect suck && killall Dock
```
- `genie`
  ```bash
  $ defaults write com.apple.dock mineffect genie && killall Dock
  ```
- `scale`
  ```bash
  $ defaults write com.apple.dock mineffect -string scale && killall Dock
  ```

#### Highlight icon
```bash
$ defaults write com.apple.dock mouse-over-hilite-stack -bool TRUE && killall Dock
```
- Restore to Default:
  ```bash
  $ defaults delete com.apple.dock mouse-over-hilite-stack && killall Dock
  ```

#### remove none-opened apps
```bash
$ defaults write com.apple.dock static-only -boolean true && killall Dock
```
- restore to default:
  ```bash
  $ defaults delete com.apple.dock static-only && killall Dock
  ```

#### hidden icon
```bash
$ defaults write com.apple.dock showhidden -bool true && killall Dock
```
- restore to default
  ```bash
  $ defaults delete com.apple.Dock showhidden && killall Dock
  ```

### keyboard & trackpad
#### enable Key Repeat
```bash
$ defaults write -g ApplePressAndHoldEnabled -bool false
```
- Restore to Default
  ```bash
  $ defaults delete -g ApplePressAndHoldEnabled
  ```

#### enable tap to click
```bash
$ defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
$ defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
$ defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
```

#### enable three finger to drag
```bash
$ defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
$ defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
```

#### fast keyboard response
```bash
$ defaults write NSGlobalDomain KeyRepeat -int 0.02
```
#### reduce key repeat delay
```bash
$ defaults write NSGlobalDomain InitialKeyRepeat -int 12
```

### utilities
#### avoid install resource validation
```bash
$ sudo spctl --master-disable
$ defaults write com.apple.LaunchServices LSQuarantine -bool false
```

#### disable the .DS_Store file
```bash
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores true
```
- Enable the .DS_Store
  ```bash
  $ defaults write com.apple.desktopservices DSDontWriteNetworkStores false
  ```

#### show battery percent
```bash
$ defaults write com.apple.menuextra.battery ShowPercent -string "YES"
```

#### [forbidden spell automatic correction](https://github.com/bestswifter/macbootstrap/blob/master/doc/system.md)
```bash
$ defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
$ defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
$ defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
```

#### disable notification centers
```bash
$ launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
$ killall NotificationCenter
```

#### Are you sure you want to open this application?
```bash
$ defaults write com.apple.LaunchServices LSQuarantine -bool false
```
- or
  ```bash
  $ sudo spctl — master-disable
  ```

#### none warning for unknow resource open
```bash
$ defaults write com.apple.LaunchServices LSQuarantine -bool false
```

#### enable the hidden file
```bash
$ defaults write com.apple.finder AppleShowAllFiles TRUE; killall Finder
```
- or
  ```bash
  $ defaults write com.apple.finder AppleShowAllFiles YES
  ```

#### [Safari Font Size](https://discussions.apple.com/thread/7674863?start=0&tstart=0)
```bash
$ defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2MinimumFontSize -int 14
```

#### disable Spotlight
```bash
$ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
```
- re-enable Spotlight
  ```bash
  $ sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
  ```

#### disable Notification Center
```bash
$ launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
$ killall NotificationCenter
```
- re-enable Notifaction Center
  ```bash
  $ launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist
  ```

#### Disable the download apps security
```bash
$ defaults write com.apple.LaunchServices LSQuarantine -bool NO
```
- re-enable the download apps security
  ```bash
  $ defaults write com.apple.LaunchServices LSQuarantine -bool YES
  ```

#### Disable the dashboard
```bash
$ defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock
```
- re-enable the dashboard
  ```bash
  $ defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock
  ```

### screenshot
#### shadow
- show
  ```bash
  $ defaults write com.apple.screencapture disable-shadow -bool false
  ```
- disable
  ```bash
  $ defaults write com.apple.screencapture disable-shadow -bool true
  ```

#### include date
- include
  ```bash
  $ defaults write com.apple.screencapture include-date -bool true
  ```
- not
  ```bash
  $ defaults write com.apple.screencapture include-date -bool false
  ```

#### save location
- `~/Desktop`
  ```bash
  $ defaults write com.apple.screencapture location -string ~/Desktop && killall SystemUIServer
  ```
- `~/Pictures`
  ```bash
  $ defaults write com.apple.screencapture location -string ~/Pictures && killall SystemUIServer
  ```

#### Display thumbnail
- display
  ```bash
  $ defaults write com.apple.screencapture show-thumbnail -bool true
  ```
- not show thumbnail
  ```bash
  $ defaults write com.apple.screencapture show-thumbnail -bool false
  ```

#### screenshot format
- `png`
  ```bash
  $ defaults write com.apple.screencapture type -string png
  ```
- `jpg`
  ```bash
  $ defaults write com.apple.screencapture type -string jpg
  ```

### finder
#### quitable
- hidden quite
  ```bash
  $ defaults write com.apple.finder QuitMenuItem -bool false && killall Finder
  ```
- enable quite
  ```bash
  $ defaults write com.apple.finder QuitMenuItem -bool true && killall Finder
  ```

#### show extension
- show
  ```bash
  $ defaults write NSGlobalDomain AppleShowAllExtensions -bool true && killall Finder
  ```
- not show
  ```bash
  $ defaults write NSGlobalDomain AppleShowAllExtensions -bool false && killall Finder
  ```

#### show hidden files
- show
  ```bash
  $ defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder
  ```
- not show
  ```bash
  $ defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder
  ```

#### change file extension warning
- show warning
  ```bash
  $ defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true && killall Finder
  ```
- silent
  ```bash
  $ defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false && killall Finder
  ```

#### save to disk or iCloud by default
- yes
  ```bash
  $ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool true
  ```
- no
  ```bash
  $ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
  ```

#### adjust toolbar title rollover delay
- `0.5`
  ```bash
  $ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0.5 && killall Finder
  ```
- `0`
  ```bash
  $ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0 && killall Finder
  ```
- `1`
  ```bash
  $ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 1 && killall Finder
  ```

#### set sidebar icon size
- small
  ```bash
  $ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 && killall Finder
  ```
- medium
  ```bash
  $ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2 && killall Finder
  ```
- large
  ```bash
  $ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3 && killall Finder
  ```

### menu bar
#### flash clock time separators
- stay solid
  ```bash
  $ defaults write com.apple.menuextra.clock FlashDateSeparators -bool false && killall SystemUIServer
  ```
- separator flashes
  ```bash
  $ defaults write com.apple.menuextra.clock FlashDateSeparators -bool true && killall SystemUIServer
  ```

#### set menu bar digital clock format
> region settings:
> - `ss` for seconds.
> - `HH` for 24-hour clock.
> - `EEE` for 3-letter day of the week.
> - `d MMM` for day of the month and 3-letter month.

- `EEE d MMM HH:mm:ss`
  ```bash
  $ defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"
  ```
- `EEE h:mm:ss`
  ```bash
  $ defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm:ss"
  ```
- `EEE HH:mm:ss`
  ```bash
  $ defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"
  ```

### mission control
#### rearrange automatically
- base on most of recent use
  ```bash
  $ defaults write com.apple.dock mru-spaces -bool true && killall Dock
  ```
- keep space arrangement
  ```bash
  $ defaults write com.apple.dock mru-spaces -bool false && killall Dock
  ```

### feedback assistant
#### auto gather
- allow large
  ```bash
  $ defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool true
  ```
- not allow
  ```bash
  $ defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool false
  ```

### time machine
#### disable dialog
```bash
$ defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true
```

### dock
#### change position
> available positions
> - bottom
> - left
> - right

- `left`
  ```bash
  $ defaults write com.apple.dock orientation -string left && killall Dock
  ```
- `right`
  ```bash
  $ defaults write com.apple.dock orientation -string right && killall Dock
  ```
- `bottom`
  ```bash
  $ defaults write com.apple.dock orientation -string bottom && killall Dock
  ```

#### change icon size
- `36`
  ```bash
  $ defaults write com.apple.dock tilesize -int 36 && killall Dock
  ```
- `48`
  ```bash
  $ defaults write com.apple.dock tilesize -int 48 && killall Dock
  ```
- read current value
  ```bash
  $ defaults read com.apple.dock tilesize
  64
  ```

#### autohide
- auto hide
  ```bash
  $ defaults write com.apple.dock autohide -bool true && killall Dock
  ```
- always show
  ```bash
  $ defaults write com.apple.dock autohide -bool false && killall Dock
  ```

#### autohide animation time
> precondition
> - setup autohide to true

- `0.5`
  ```bash
  $ defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall dock
  ```
- `2`
  ```bash
  $ defaults write com.apple.dock autohide-time-modifier -float 2 && killall dock
  ```
- `0`
  ```bash
  $ defaults write com.apple.dock autohide-time-modifier -float 0 && killall dock
  ```
- read current value
  ```bash
  $ defaults read com.apple.dock autohide-time-modifier
  1
  ```

#### autohide delay
> precondition
> - setup autohide to true

- `0.5`
  ```bash
  $ defaults write com.apple.dock autohide-delay -float 0.5 && killall Dock
  ```
- `0`
  ```bash
  $ defaults write com.apple.dock autohide-delay -float 0 && killall Dock
  ```
- read current value
  ```bash
  $ defaults read com.apple.dock autohide-delay
  0
  ```

#### show recently
- show
  ```bash
  $ defaults write com.apple.dock show-recents -bool true && killall Dock
  ```
- not show
  ```bash
  $ defaults write com.apple.dock show-recents -bool false && killall Dock
  ```


## backup & restore
### [Moon](https://manytricks.com/osticket/kb/faq.php?id=53)
- backup
  ```bash
  $ defaults export com.manytricks.Moom ~/Desktop/Moom.plist
  ```
- restore
  ```bash
  $ defaults import com.manytricks.Moom ~/Desktop/Moom.plist
  ```
