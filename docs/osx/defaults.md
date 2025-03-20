<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [usage](#usage)
  - [commands](#commands)
  - [usage](#usage-1)
    - [basic usage](#basic-usage)
    - [list all domains](#list-all-domains)
- [defaults](#defaults)
  - [programming](#programming)
    - [xCode](#xcode)
    - [iTerm2](#iterm2)
    - [terminal](#terminal)
    - [developer mode](#developer-mode)
  - [utilities](#utilities)
  - [screenshot](#screenshot)
    - [suppress "Allow For One Month"](#suppress-allow-for-one-month)
  - [finder](#finder)
    - [hidden file](#hidden-file)
    - [quit via ⌘ + Q](#quit-via-%E2%8C%98--q)
    - [default location](#default-location)
    - [timestamp on zip filenames](#timestamp-on-zip-filenames)
    - [extension](#extension)
    - [view](#view)
    - [icon](#icon)
    - [bars](#bars)
    - [panel](#panel)
    - [others](#others)
  - [desktop](#desktop)
  - [menu bar](#menu-bar)
  - [dock](#dock)
    - [show](#show)
    - [icon](#icon-1)
    - [animation](#animation)
    - [autohide](#autohide)
    - [others](#others-1)
  - [mission control](#mission-control)
  - [keyboard](#keyboard)
  - [trackpad](#trackpad)
  - [browser](#browser)
    - [chrome](#chrome)
    - [safari](#safari)
  - [system](#system)
    - [hot corners](#hot-corners)
    - [modifiers](#modifiers)
    - [reduce the menu bar item spacing](#reduce-the-menu-bar-item-spacing)
    - [Launchpad](#launchpad)
    - [dashboard](#dashboard)
    - [keyboard remapping](#keyboard-remapping)
    - [keyboard](#keyboard-1)
    - [reset dns cache](#reset-dns-cache)
    - [QuickTime](#quicktime)
    - [App Store](#app-store)
    - [sleep mode](#sleep-mode)
    - [screensaver](#screensaver)
  - [others](#others-2)
- [backup & restore](#backup--restore)
  - [Moon](#moon)
  - [vscode](#vscode)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [* defaults-write.com](https://www.defaults-write.com/)
>   - [10 terminal commands to speed up macOS High Sierra on your Mac](https://www.defaults-write.com/speed-up-macos-high-sierra/)
> - [* macOS defaults list](https://macos-defaults.com/)
> - [macOS defaults](https://macos-defaults.com/)
> - [How To Change Preferences From The Command Line On MacOS?](https://www.shell-tips.com/mac/defaults/)
> - [mac defaults](https://github.com/kevinSuttle/macOS-Defaults/blob/master/REFERENCE.md)
> - [uson1x/hack.sh](https://gist.github.com/uson1x/2275613)
> - [Maya/mac settings.sh](https://charlesreid1.com/wiki/Maya/mac_settings.sh)
>   - [dotfiles/mac/mac_settings.sh](https://git.charlesreid1.com/dotfiles/mac/src/branch/main/mac_settings.sh)
> - [osx-for-hackers.sh](https://blocks.roadtolarissa.com/mhkeller/d7e0cd4dc30236291622)
> - [brandonb927/osx-for-hackers.sh](https://gist.github.com/brandonb927/3195465)
> - [mathiasbynens/dotfiles](https://github.com/mathiasbynens/dotfiles)
>   - [.macos](https://github.com/mathiasbynens/dotfiles/blob/main/.macos)
> - [akachrislee/osx](https://gist.github.com/akachrislee/3220956)
> - [Clear and disable recent items in OS X dock and applications](https://simon.heimlicher.com/technology/disable-recent-items/)
> - [* How to Factory Reset MacBook](https://mackeeper.com/blog/step-by-step-guide-to-reset-mac-to-factory-settings/)
{% endhint %}

# usage
## commands

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

## usage
### basic usage
```bash
# gets all
$ defaults read DOMAIN

# gets
$ defaults read DOMAIN PROPERTY_NAME

# find
$ defaults find <KEYWORD>

# get type
$ defaults read-type <DOMAIN> <KEY>

# rename
$ defaults rename <DOMAIN> <OLD_KEY> <NEW_KEY>

# sets
$ defaults write DOMAIN PROPERTY_NAME VALUE

# resets a property
$ defaults delete DOMAIN PROPERTY_NAME

# resets preferences
$ defaults delete DOMAIN
```

### list all domains
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

# defaults
## programming
### xCode
#### add additional Counterpart Suffixes
```bash
# `"ViewModel" "View"`
$ defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "ViewModel" "View" && killall Xcode

# `"Router" "Interactor" "Builder"`
$ defaults write com.apple.dt.Xcode IDEAdditionalCounterpartSuffixes -array-add "Router" "Interactor" "Builder" && killall Xcode
```

#### show build durations
```bash
$ defaults write com.apple.dt.Xcode ShowBuildOperationDuration -bool true && killall Xcode
```

#### [add additional counterpart suffixes](https://macos-defaults.com/xcode/ideadditionalcounterpartsuffixes.html)
```bash
# add "ViewModel" and "View"
$ defaults write com.apple.dt.Xcode "IDEAdditionalCounterpartSuffixes" -array-add "ViewModel" "View" && killall Xcode

# add "Router", "Interactor" and "Builder"
$ defaults write com.apple.dt.Xcode "IDEAdditionalCounterpartSuffixes" -array-add "Router" "Interactor" "Builder" && killall Xcode
```

#### [show build durations](https://macos-defaults.com/xcode/showbuildoperationduration.html)
```bash
$ defaults write com.apple.dt.Xcode "ShowBuildOperationDuration" -bool "true" && killall Xcode
```

### iTerm2
#### profile
```bash
# reset
$ cd ~/Library/Preferences/com.googlecode.iterm2.plist
$ defaults delete com.googlecode.iterm2
```

#### prompt when quitting
```bash
# disable
$ defaults write com.googlecode.iterm2 PromptOnQuit -bool false
```

### terminal
```bash
# UTF-8 encoding
$ defaults write com.apple.terminal StringEncodings -array 4

# theme
$ defaults write com.apple.terminal "Default Window Settings" -string "gruvbox-dark"
$ defaults write com.apple.terminal "Startup Window Settings" -string "gruvbox-dark"

# more
$ defaults read com.apple.terminal
```

#### enable security keyboard

> [!NOTE|label:references:]
> - [How secure is "Secure Keyboard Entry" in Mac OS X's Terminal?](https://security.stackexchange.com/a/47786/8918)

```bash
$ defaults write com.apple.terminal SecureKeyboardEntry -bool true
```

#### line marks
```bash
# disable
$ defaults write com.apple.terminal ShowLineMarks -int 0
```

#### [modify theme](https://github.com/mathiasbynens/dotfiles/blob/main/.macos#L628C33-L628C53)
```bash
$ osascript <<EOD

tell application "Terminal"

  local allOpenedWindows
  local initialOpenedWindows
  local windowID
  set themeName to "Solarized Dark xterm-256color"

  (* Store the IDs of all the open terminal windows. *)
  set initialOpenedWindows to id of every window

  (* Open the custom theme so that it gets added to the list
     of available terminal themes (note: this will open two
     additional terminal windows). *)
  do shell script "open '$HOME/init/" & themeName & ".terminal'"

  (* Wait a little bit to ensure that the custom theme is added. *)
  delay 1

  (* Set the custom theme as the default terminal theme. *)
  set default settings to settings set themeName

  (* Get the IDs of all the currently opened terminal windows. *)
  set allOpenedWindows to id of every window

  repeat with windowID in allOpenedWindows

    (* Close the additional windows that were opened in order
       to add the custom theme to the list of terminal themes. *)
    if initialOpenedWindows does not contain windowID then
      close (every window whose id is windowID)

    (* Change the theme for the initial opened terminal windows
       to remove the need to close them in order for the custom
       theme to be applied. *)
    else
      set current settings of tabs of (every window whose id is windowID) to settings set themeName
    end if

  end repeat
end tell
EOD
```

### developer mode

> [!NOTE|label:references:]
> - [MacOS Catalina "Developer Tools" tab is hidden](https://stackoverflow.com/a/65240575/2940319)
> - [Authorize a non-admin developer in Xcode / Mac OS](https://stackoverflow.com/a/1837935/2940319)

```bash
$ sudo spctl developer-mode enable-terminal
Terminal added as a developer tool. Enable in the Privacy & Security Settings.

# or
$ sudo /usr/sbin/DevToolsSecurity --enable
```

![developer mode](../screenshot/osx/spctl-developer-mode.png)

## utilities

#### [startup sounds](https://www.youtube.com/watch?v=_OjQIh4Ro5A)
```bash
# disable
$ sudo nvram StartupMute=%01
# or
$ sudo nvram SystemAudioVolume=" "

# enable
$ sudo nvram StartupMute=%00
```

#### [forbidden spell automatic correction](https://github.com/bestswifter/macbootstrap/blob/master/doc/system.md)
```bash
$ defaults write -g NSAutomaticQuoteSubstitutionEnabled  -bool false
$ defaults write -g NSAutomaticDashSubstitutionEnabled   -bool false
$ defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
```

#### disable notification centers
```bash
$ launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && killall NotificationCenter
```

#### are you sure you want to open this application?

{% hint style='tip' %}
> references:
> - [How to fix: This is an application downloaded from the Internet. Are you sure you want to open it?](https://www.idownloadblog.com/2017/04/20/fix-application-from-internet-gatekeeper/)
> - [disable application quarantine message](https://macos-defaults.com/misc/lsquarantine.html)
> - [* iMarslo: xattr](./tricky.md#usrbinxattr)
{% endhint %}

```bash
# old version
$ sudo spctl --master-disable
# new version
$ sudo spctl --global-disable
Globally disabling the assessment system needs to be confirmed in System Settings

# disable quarantine
$ defaults write com.apple.LaunchServices LSQuarantine -bool false

$ /usr/bin/xattr -c /path/to/app
# or
$ /usr/bin/xattr -d com.apple.quarantine /path/to/app
```

![allow application from](../screenshot/osx/allow-application-from-1.png)

![allow application from](../screenshot/osx/allow-application-from-2.png)

## screenshot

### suppress "Allow For One Month"

> [!NOTE|label:references:]
> - [Stop macOS 15 Sequoia monthly screen recording prompts](https://lapcatsoftware.com/articles/2024/8/10.html)
> - [How to stop "Allow For One Month" in macOS 15 Sequoia - especially when replayd ScreenCaptureApprovals.plist is missing?](https://apple.stackexchange.com/a/475541/254265)
> - [screencapture-nag-remover](https://github.com/luckman212/screencapture-nag-remover)

```bash
# check info
$ defaults read ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist
{
    "/Applications/Bob.app/Contents/MacOS/Bob" = "2024-09-19 22:33:43 +0000";
    "/Applications/GIF Brewery 3.app/Contents/MacOS/GIF Brewery 3" = "2024-09-21 10:34:48 +0000";
    "/Applications/Snipaste.app/Contents/MacOS/Snipaste" = "2024-10-22 07:04:02 +0000";
    "/Applications/zoom.us.app/Contents/MacOS/zoom.us" = "2024-10-15 06:12:23 +0000";
}

# update one
$ defaults write ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist \
           "/Applications/Snipaste.app/Contents/MacOS/Snipaste" \
           -date "3024-01-01 00:00:00 +0000"

# update all
$ defaults read ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist |
  sed -nr 's|^\s*"([^"]+)".*$|\1|p' |
  while read -r _name; do
    defaults write ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist \
             "${_name}" -date "3024-01-01 00:00:00 +0000" ;
  done

# verify
$ defaults read ~/Library/Group\ Containers/group.com.apple.replayd/ScreenCaptureApprovals.plist
{
    "/Applications/Bob.app/Contents/MacOS/Bob" = "3024-01-01 00:00:00 +0000";
    "/Applications/GIF Brewery 3.app/Contents/MacOS/GIF Brewery 3" = "3024-01-01 00:00:00 +0000";
    "/Applications/Snipaste.app/Contents/MacOS/Snipaste" = "3024-01-01 00:00:00 +0000";
    "/Applications/zoom.us.app/Contents/MacOS/zoom.us" = "3024-01-01 00:00:00 +0000";
}
```

#### set screenshot location
```bash
# `~/Picture/Screenshots`
$ defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string ~/Pictures/Screenshots

# `~/Picture/Simulator Screenshots`
$ defaults write com.apple.iphonesimulator ScreenShotSaveLocation -string ~/Pictures/Simulator Screenshots
```

#### shadow
```bash
# show
$ defaults write com.apple.screencapture disable-shadow -bool false && killall SystemUIServer

# disable
$ defaults write com.apple.screencapture disable-shadow -bool true && killall SystemUIServer
```

#### include date
```bash
# include
$ defaults write com.apple.screencapture include-date -bool true && killall SystemUIServer

# disable
$ defaults write com.apple.screencapture include-date -bool false && killall SystemUIServer
```

#### save location
```bash
# `~/Desktop`
$ defaults write com.apple.screencapture location -string ~/Desktop && killall SystemUIServer

# `~/Pictures`
$ defaults write com.apple.screencapture location -string ~/Pictures && killall SystemUIServer
```

#### thumbnail
```bash
# display
$ defaults write com.apple.screencapture show-thumbnail -bool true

# disable thumbnail
$ defaults write com.apple.screencapture show-thumbnail -bool false
```

#### screenshot format
```bash
# `png`
$ defaults write com.apple.screencapture type -string png

# `jpg`
$ defaults write com.apple.screencapture type -string jpg
```

## finder

### hidden file
#### show hidden files

> [!TIP|label:shortcuts:]
> - <kbd>⇧</kbd> + <kbd>⌘</kbd> + <kbd>.</kbd> ( <kbd>shift</kbd> + <kbd>command</kbd> + <kbd>.</kbd> )

```bash
# show
$ defaults write com.apple.Finder AppleShowAllFiles -bool true && killall Finder
# or
$ defaults write com.apple.finder AppleShowAllFiles YES

# -- global mode --
$ defaults write -g AppleShowAllFiles -bool true

# disable
$ defaults write com.apple.Finder AppleShowAllFiles -bool false && killall Finder
# or
$ defaults write com.apple.Finder AppleShowAllFiles NO
```

#### disable the `.DS_Store` and `._*`

> [!NOTE|label:references:]
> - [Junk files created by macOS (or Finder)...](https://discussions.apple.com/thread/251428275?answerId=252779543022#252779543022)
>   - You can disable MDS on a specific volume, but you need to create a hidden file to do it
>     ```bash
>     $ sudo touch /Volumes/{drive name}/.metadata_never_index
>     ```
> - [more details](https://apple.stackexchange.com/a/208495/254265)
>   - `.DS_Store` – The name of a file in the Apple OS X operating system for storing custom attributes of a folder such as the position of icons or the choice of a background image (Read more)
>   - `.Spotlight-V100` – This file holds information to speed up the 'Spotlight Search' feature. Deleting would simply force this information to be re-indexed if you performed another Spotlight Search for an item in this folder.
>   - `.apDisk` – This file holds information about shared folders and can be safely removed as it will be automatically re-created if Apple needs it.
>   - `.VolumeIcon.icns` – This file is used to store the icon of the volume (USB device) if the volume uses a custom icon and not the default icon. If you want the device to continue using this default icon, or if the folder/device you want to clean contains an application, you might want to keep this file in your system. As a side note, if you wanted to create a custom icon for your device you could create/download an .icns file and rename it .VolumeIcon.icns and place in your folder/device.
>   - `.fseventsd` – This file is used as a buffer for the File System Events daemon. If you are using a program that is monitoring this folder/device, this file might be used to store temporary data.
>   - `.Trash` & `.Trashes` – These folders are used to hold deleted items the same way that the 'Trash' icon from the dock works. If you don't need this feature on your folder/device, you can clean this folder to save space.
>   - `.TemporaryItems` – This file is used by the OS to hold temporary data when files are being copied/moved/appended. If you are running any programs that are accessing the folder/device you want to clean, and you aren't copying or moving any files, then this file can simply hold old data for caching.

```bash
# network drives
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
# usb drives
$ defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# enable
$ defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool false
$ defaults write com.apple.desktopservices DSDontWriteUSBStores -bool false
```

- result
  ```bash
  $ defaults read com.apple.desktopservices
  {
      DSDontWriteNetworkStores = 1;
      DSDontWriteUSBStores = 1;
  }
  ```

### [quit via ⌘ + Q](https://macos-defaults.com/finder/quitmenuitem.html)
```bash
# hidden quite
$ defaults write com.apple.finder QuitMenuItem -bool false && killall Finder

# enable quite
$ defaults write com.apple.finder QuitMenuItem -bool true && killall Finder
```

### default location
```bash
$ defaults write com.apple.finder NewWindowTarget -string "PfDe"
$ defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"
```

### timestamp on zip filenames
```bash
# enable
$ defaults write com.apple.Finder ArchiveTimestamp -bool true

# disable
$ defaults delete com.apple.Finder ArchiveTimestamp
```

#### [empty trashcan after 30 days](https://macos-defaults.com/finder/fxremoveoldtrashitems.html)
```bash
$ defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" && killall Finder
```

#### finder sound
```bash
# turn on
$ defaults write com.apple.Finder FinderSounds -bool false

# turn off
$ defaults delete com.apple.Finder FinderSounds
```

#### trash sounds
```bash
# disable
$ defaults write com.apple.Finder WarnOnEmptyTrash -bool false
```

### extension
```bash
# show
$ defaults write NSGlobalDomain AppleShowAllExtensions -bool true && killall Finder
# disable
$ defaults write NSGlobalDomain AppleShowAllExtensions -bool false && killall Finder

# show warning when change file extension warning
$ defaults write com.apple.finder FXEnableExtensionChangeWarning -bool true && killall Finder
# silent when change file extension warning
$ defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false && killall Finder
```

### view
#### full POSIX path in toolbar title
```bash
$ defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
```

#### column view

> [!TIP]
> - [view modes](https://www.defaults-write.com/change-default-view-style-in-os-x-finder/)
> - [Default view style](https://macos-defaults.com/finder/fxpreferredviewstyle.html)
>   - `icnv` : Icon View
>   - `clmv` : Column View
>   - `Flwv` : Cover Flow View
>   - `Nlsv` : List View

```bash
$ defaults write com.apple.finder FXPreferredViewStyle clmv && killall Finder
```

#### [keep folder on top](https://macos-defaults.com/finder/_fxsortfoldersfirst.html)
```bash
$ defaults write com.apple.finder "_FXSortFoldersFirst" -bool "true" && killall Finder

# for desktop
$ defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true" && killall Finder
```

#### animation when opening the Info window in Finder
```bash
# disable
$ defaults write com.apple.Finder DisableAllAnimations -bool true
```

### icon
#### [set sidebar icon size](https://macos-defaults.com/finder/nstableviewdefaultsizemode.html)
```bash
# small: 1
$ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 1 && killall Finder

# medium: 2
$ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2 && killall Finder

# large: 3
$ defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 3 && killall Finder
```

#### show item info near icons
```bash
$ /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
```

#### show item info to right of icons
```bash
$ /usr/libexec/PlistBuddy -c "Set DesktopViewSettings:IconViewSettings:labelOnBottom false" ~/Library/Preferences/com.apple.finder.plist
```

#### snap-to-grid for icons
```bash
$ /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
```

#### increase grid spacing for icons
```bash
$ /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
```

#### increase the size of icons
```bash
$ /usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
$ /usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 80" ~/Library/Preferences/com.apple.finder.plist
```

### bars
#### show path bar
```bash
$ defaults write com.apple.finder ShowPathbar -bool true
```

#### show status bar
```bash
$ defaults write com.apple.finder ShowStatusBar -bool true
```

#### show icon in the title bar
```bash
$ defaults write com.apple.universalaccess "showWindowTitlebarIcons" -bool "true" && killall Finder
```

#### adjust toolbar title rollover delay
```bash
# `0.5`
$ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0.5 && killall Finder
# `0`
$ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0 && killall Finder
# `1`
$ defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 1 && killall Finder
```

### panel
```bash
# expand save panel by default
$ defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
$ defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# expand print panel by default
$ defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
$ defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
```

### others
#### search scope

> [!TIP]
> - [default search scope](https://macos-defaults.com/finder/fxdefaultsearchscope.html)
>   - `SCcf` : Search the current folder
>   - `SCsp` : Use the previous search scope
>   - `SCev` : Search this Mac

```bash
# use current directory as default search scope
$ defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
```

#### disk image verification
```bash
# disable
$ defaults write com.apple.frameworks.diskimages skip-verify -bool true
$ defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
$ defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
```

#### silent quiet
```bash
# quit printer app once the print jobs complete
$ defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
```

#### save to disk or iCloud
```bash
# yes: save to iCloud
$ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool true

# no: save to disk by default
$ defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
```

#### select && copy from quicklook
```bash
$ defaults write com.apple.finder QLEnableTextSelection -bool true ; killall Finder
```

#### spring loading
```bash
# enable spring loading
$ defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# disable spring loading delay
defaults write NSGlobalDomain com.apple.springing.delay -float 0
```

#### volume mounted
```bash
# open finder automatically
$ defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool true
$ defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool true
$ defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool true
```

## desktop
#### show wallpaper location
```bash
# show
$ defaults write com.apple.dock desktop-picture-show-debug-text -bool true

# not show
$ defaults delete com.apple.dock desktop-picture-show-debug-text
```

#### [keep folders on top](https://macos-defaults.com/desktop/_fxsortfoldersfirstondesktop.html)
```bash
$ defaults write com.apple.finder "_FXSortFoldersFirstOnDesktop" -bool "true" && killall Finder
```

#### [quick hidden desktop icons](https://www.defaults-write.com/os-x-how-to-quickly-hide-the-desktop-icons/)
```bash
$ defaults write com.apple.finder CreateDesktop -bool false && killall Finder

# revert back
$ defaults write com.apple.finder CreateDesktop true && killall Finder
```

#### icons
- show external disk
  ```bash
  $ defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
  ```

- show hard drive
  ```bash
  $ defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
  ```

- show connected servers
  ```bash
  $ defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
  ```

- show removeable media ( CDs, DVDs and iPods )
  ```bash
  $ defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
  ```

## menu bar
#### transparency
```bash
# disable transparency
$ defaults write com.apple.universalaccess reduceTransparency -bool true
```

#### highlight color
```bash
# green
$ defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# black
$ defaults write NSGlobalDomain AppleHighlightColor -string "0.500000 0.500000 0.500000"
```

#### flash clock time separators
```bash
# stay solid
$ defaults write com.apple.menuextra.clock FlashDateSeparators -bool false && killall SystemUIServer

# separator flashes
$ defaults write com.apple.menuextra.clock FlashDateSeparators -bool true && killall SystemUIServer
```

#### [set menu bar digital clock format](https://macos-defaults.com/menubar/dateformat.html)

> [!NOTE|label:region settings:]
> - `ss` for seconds.
> - `HH` for 24-hour clock.
> - `EEE` for 3-letter day of the week.
> - `d MMM` for day of the month and 3-letter month.

```bash
# `EEE d MMM HH:mm:ss`
$ defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm:ss"

# `EEE h:mm:ss`
$ defaults write com.apple.menuextra.clock DateFormat -string "EEE h:mm:ss"

# `EEE HH:mm:ss`
$ defaults write com.apple.menuextra.clock DateFormat -string "EEE HH:mm:ss"
```

#### menu bar transparency
```bash
# disable transparency
$ defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
```

## dock

> [!NOTE|label:references:]
> - [Dock performance setup](https://sspai.com/post/33493)
> - [revert dock to default](https://www.defaults-write.com/reset-mac-dock-default/)
>   ```bash
>   $ defaults delete com.apple.dock && killall Dock
>   ```
> - [macOS defaults](https://lupin3000.github.io/macOS/defaults/)

### show
#### add a blank space
```bash
$ defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}' && killall Dock
```

#### add recent items folder
```bash
$ defaults write com.apple.dock persistent-others -array-add '{"tile-data" = {"list-type" = 1;}; "tile-type" = "recents-tile";}' && killall Dock

# current status
$ defaults read com.apple.Dock persistent-others
(
)
```

#### [group window by app](https://macos-defaults.com/mission-control/expose-group-apps.html)
```bash
$ defaults write com.apple.dock "expose-group-apps" -bool "true" && killall Dock
```

#### position

> [!TIP]
> - [* Access Dock settings from macOS UI](x-apple.systempreferences:com.apple.preference.dock?Dock)

```bash
# `left`
$ defaults write com.apple.dock orientation -string left   && killall Dock

# `right`
$ defaults write com.apple.dock orientation -string right  && killall Dock

# `bottom`
$ defaults write com.apple.dock orientation -string bottom && killall Dock
```

#### disable delay of dock displaying
```bash
$ defaults write com.apple.Dock autohide-delay -float 0 && killall Dock
```

#### show recently
```bash
# show
$ defaults write com.apple.dock show-recents -bool true && killall Dock

# disable show
$ defaults write com.apple.dock show-recents -bool false && killall Dock
```

#### recent use rearrange space
```bash
# disable
$ defaults write com.apple.dock mru-spaces -bool false && killall Dock
```

### icon
#### highlight icon
```bash
$ defaults write com.apple.dock mouse-over-hilite-stack -bool true && killall Dock

# revert
$ defaults delete com.apple.dock mouse-over-hilite-stack && killall Dock
```

#### icon size
- tilesize
  ```bash
  # `48`
  $ defaults write com.apple.dock tilesize -int 48 && killall Dock

  # read current value
  $ defaults read com.apple.dock tilesize
  46
  ```

- [largesize](https://www.defaults-write.com/enable-a-larger-dock-icon-size-than-default/)
  ```bash
  # 72
  $ defaults write com.apple.dock largesize -float 72 && killall Dock
  ```

#### remove none-opened apps ( show only active Apps )
```bash
$ defaults write com.apple.dock static-only -boolean true && killall Dock

# revert
$ defaults delete com.apple.dock static-only && killall Dock
```

#### whether show hidden icon
```bash
# show semi-transparent icon in hide mode
$ defaults write com.apple.dock showhidden -bool true && killall Dock

# show no differences with non-hide
$ defaults delete com.apple.Dock showhidden && killall Dock
```

### animation
#### opening applications animation
```bash
# enable
$ defaults write com.apple.dock launchanim -bool true

# disable
$ defaults write com.apple.dock launchanim -bool false
```

#### animations when opening and closing windows
```bash
# disable
$ defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false
```

#### animations when opening a Quick Look window
```bash
# disable
$ defaults write -g QLPanelAnimationDuration -float 0
```

#### animation of minimize windows
```bash
# * `suck`
$ defaults write com.apple.dock mineffect suck && killall Dock

# `genie`
$ defaults write com.apple.dock mineffect genie && killall Dock

# `scale`
$ defaults write com.apple.dock mineffect -string scale && killall Dock
```

### autohide
```bash
# auto hide
$ defaults write com.apple.dock autohide -bool true && killall Dock

# always show
$ defaults write com.apple.dock autohide -bool false && killall Dock
```

#### autohide animation delay

> [!NOTE|label:precondition]
> - setup autohide to true

```bash
# `0.5`
$ defaults write com.apple.dock autohide-time-modifier -float 0.5 && killall Dock

# `2`
$ defaults write com.apple.dock autohide-time-modifier -float 2 && killall Dock

# `0`
$ defaults write com.apple.dock autohide-time-modifier -float 0 && killall Dock

# read current value
$ defaults read com.apple.dock autohide-time-modifier
1
```

#### autohide delay

> [!NOTE|label:precondition]
> - setup autohide to true

```bash
# `0.5`
$ defaults write com.apple.dock autohide-delay -float 0.5 && killall Dock

# `0`
$ defaults write com.apple.dock autohide-delay -float 0 && killall Dock

# read current value
$ defaults read com.apple.dock autohide-delay
0
```

### others
#### 2D Dock
```bash
$ defaults write com.apple.dock no-glass -bool true
```

#### enable iTunes track notifications in the dock
```bash
$ defaults write com.apple.dock itunes-notifications -bool true
```

#### highlight hover effect
```bash
# enable highlight
$ defaults write com.apple.dock mouse-over-hilte-stack -bool true
```

#### speeding up mission control animations
```bash
$ defaults write com.apple.dock expose-animation-duration -float 0.1
$ defaults write com.apple.dock "expose-group-by-app" -bool true
```

#### spring loading for all Dock items
```bash
$ defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true
```

#### indicator lights for open apps
```bash
# show indicators lights
$ defaults write com.apple.dock show-process-indicators -bool true
```

## mission control
#### rearrange automatically
```bash
# base on most of recent use
$ defaults write com.apple.dock mru-spaces -bool true && killall Dock

# keep space arrangement
$ defaults write com.apple.dock mru-spaces -bool false && killall Dock
```

#### [switch to space with open windows](https://macos-defaults.com/mission-control/applespacesswitchonactivate.html)
```bash
$ defaults write NSGlobalDomain "AppleSpacesSwitchOnActivate" -bool "true" && killall Dock
```

#### [displays have separate spaces](https://macos-defaults.com/mission-control/spans-displays.html)
```bash
$ defaults write com.apple.spaces "spans-displays" -bool "true" && killall SystemUIServer
```

## keyboard

> [!NOTE|label:references:]
> - [Key repeat in GitHub Codespaces](https://stackoverflow.com/a/76385233/2940319)
> - [How can I disable `ApplePressAndHoldEnabled` for a specific application](https://stackoverflow.com/a/70911250/2940319)
> - [#31919: Characters don't repeat when ApplePressAndHoldEnabled is disabled for VSCode](https://github.com/Microsoft/vscode/issues/31919#issuecomment-343897993)
> - [How to Enable Key-Repeating for Vim](https://vimforvscode.com/enable-key-repeat-vim)

#### [key repeat](https://blog.csdn.net/m290345792/article/details/110383724)
```bash
$ defaults write NSGlobalDomain ApplePressAndHoldEnabled -boolean false

# or
$ defaults write -g ApplePressAndHoldEnabled -bool false
```

- restore
  ```bash
  $ defaults delete -g ApplePressAndHoldEnabled
  ```

- key repeat for in specific apps
  ```bash
  # chrome
  $ defaults delete -g ApplePressAndHoldEnabled
  $ defaults write "com.google.Chrome" ApplePressAndHoldEnabled 0

  # vscode
  $ defaults delete com.microsoft.VSCode ApplePressAndHoldEnabled
  $ defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  ```

- read form NSGlobalDomain
  ```bash
  $ defaults read NSGlobalDomain KeyRepeat
  2
  ```

#### fast keyboard response
```bash
$ defaults write NSGlobalDomain KeyRepeat -int 0.02
```

#### reduce key repeat delay
```bash
$ defaults write NSGlobalDomain InitialKeyRepeat -int 12
```

#### enable full keyboard access

> [!TIP]
>  Enable full keyboard access for all controls (e.g. enable Tab in modal dialogs)

```bash
$ defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```

#### auto-correct
```bash
# disable
$ defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# enable
$ defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true
```

#### auto-capitalization

![auto capitalization](../screenshot/osx/system-capitalization.png)

```bash
# disable
$ defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# enable
$ defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
```

#### keyboard illumination
```bash
# turn off keyboard illumination when computer is not used for 5 minutes
$ defaults write com.apple.BezelServices kDimTime -int 300
```

#### increasing sound quality for bluetooth
```bash
$ defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 40
```

## trackpad

> [!TIP]
> - [* Access Trackpad settings from macOS UI](x-apple.systempreferences:com.apple.preference.trackpad?trackpadTab)

#### [click weight](https://macos-defaults.com/trackpad/firstclickthreshold.html)
```bash
# light: 0
$ defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "0"

# medium: 1
$ defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "1"

# firm: 2
$ defaults write com.apple.AppleMultitouchTrackpad "FirstClickThreshold" -int "2"
```

#### [enable dragging with drag lock](https://macos-defaults.com/trackpad/draglock.html)
```bash
$ defaults write com.apple.AppleMultitouchTrackpad "DragLock" -bool "true"
```

#### [Enable dragging without drag lock](https://macos-defaults.com/trackpad/dragging.html)
```bash
$ defaults write com.apple.AppleMultitouchTrackpad "Dragging" -bool "true"
```

#### [enable dragging with three finger drag](https://macos-defaults.com/trackpad/trackpadthreefingerdrag.html)
```bash
$ defaults write com.apple.AppleMultitouchTrackpad "TrackpadThreeFingerDrag" -bool "true"
```

#### enable tap to click

> [!NOTE|label:references:]
> ```bash
> $ defaults -currentHost read NSGlobalDomain  | grep trackpad
>     "com.apple.trackpad.enableSecondaryClick" = 1;
>     "com.apple.trackpad.fiveFingerPinchSwipeGesture" = 2;
>     "com.apple.trackpad.fourFingerHorizSwipeGesture" = 2;
>     "com.apple.trackpad.fourFingerPinchSwipeGesture" = 2;
>     "com.apple.trackpad.fourFingerVertSwipeGesture" = 2;
>     "com.apple.trackpad.momentumScroll" = 1;
>     "com.apple.trackpad.pinchGesture" = 1;
>     "com.apple.trackpad.rotateGesture" = 1;
>     "com.apple.trackpad.scrollBehavior" = 2;
>     "com.apple.trackpad.threeFingerDragGesture" = 0;
>     "com.apple.trackpad.threeFingerHorizSwipeGesture" = 2;
>     "com.apple.trackpad.threeFingerTapGesture" = 2;
>     "com.apple.trackpad.threeFingerVertSwipeGesture" = 2;
>     "com.apple.trackpad.twoFingerDoubleTapGesture" = 1;
>     "com.apple.trackpad.twoFingerFromRightEdgeSwipeGesture" = 3;
>     "com.apple.trackpad.version" = 5;
> ```

```bash
$ defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
$ defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
$ defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
```

- or
  ```bash
  # read
  $ defaults read NSGlobalDomain com.apple.trackpad.forceClick
  0
  # set via:
  $ defaults write -g com.apple.trackpad.forceClick 0
  ```

#### enable three finger to drag
```bash
$ defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
$ defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
```

#### trackpad & mouse speed
```bash
$ defaults write -g com.apple.trackpad.scaling 2
$ defaults write -g com.apple.mouse.scaling 2.5

# read
$ defaults read NSGlobalDomain com.apple.trackpad.scaling
2
$ defaults read NSGlobalDomain com.apple.mouse.scaling
2.5
```

#### battery percent
```bash
# show battery percent
$ defaults write com.apple.menuextra.battery ShowPercent -string "YES"
```

#### remaining battery time
```bash
$ defaults write com.apple.menuextra.battery ShowTime -string "YES"
```

## browser
### chrome
#### sensitive backswipe
```bash
# disable on trackpads
$ defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool false
$ defaults write com.google.Chrome.canary AppleEnableSwipeNavigateWithScrolls -bool false

# disable on magic mouse
$ defaults write com.google.Chrome AppleEnableMouseSwipeNavigateWithScrolls -bool false
$ defaults write com.google.Chrome.canary AppleEnableMouseSwipeNavigateWithScrolls -bool false
```

#### system-native print preview
```bash
$ defaults write com.google.Chrome DisablePrintPreview -bool true
$ defaults write com.google.Chrome.canary DisablePrintPreview -bool true
```

#### expand the print dialog
```bash
$ defaults write com.google.Chrome PMPrintingExpandedStateForPrint2 -bool true
$ defaults write com.google.Chrome.canary PMPrintingExpandedStateForPrint2 -bool true
```

### safari
#### [show full url](https://macos-defaults.com/safari/showfullurlinsmartsearchfield.html)
```bash
$ defaults write com.apple.Safari "ShowFullURLInSmartSearchField" -bool "true" && killall Safari
```

#### dns prefetching
```bash
# disable
$ defaults write com.apple.safari WebKitDNSPrefetchingEnabled -boolean false

# enable
$ defaults write com.apple.safari WebKitDNSPrefetchingEnabled -boolean true
```

#### bookmarks
```bash
# hidden bookmark
$ defaults write com.apple.Safari ShowFavoritesBar -bool false

# removing useless icons from bookmark bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"
```

#### sidebar
```bash
# hidden
$ defaults write com.apple.Safari ShowSidebarInTopSites -bool false
```

#### thumbnail cache
```bash
# disable
$ defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2
```

#### debug mode
```bash
# enable debug menu
$ defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
# or
$ defaults write com.apple.Safari IncludeInternalDebugMenu 1
```

![debug mode](../screenshot/osx/osx-safari-debug.png)


#### standard deply
```bash
# disable
$ defaults write com.apple.Safari WebKitInitialTimedLayoutDelay 0.25

```

#### develop menu and the web inspector
```bash
# develop menu and the web inspector
$ defaults write com.apple.Safari IncludeDevelopMenu -bool true
$ defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
$ defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true

# context menu for web inspector
$ defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
```

#### search banners
```bash
# search banners default to Contains instead of Starts With
$ defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false
```

#### backspace key to previous page
```bash
# disable
$ defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true
```

#### [safari font size](https://discussions.apple.com/thread/7674863?start=0&tstart=0)
```bash
$ defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2MinimumFontSize -int 14
```

## system

### hot corners

> [!TIP|label:references:]
> - [Setting Mac hot corners in the terminal](https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de)
>   - `0`: No Option
>   - `2`: Mission Control
>   - `3`: Show application windows
>   - `4`: Desktop
>   - `5`: Start screen saver
>   - `6`: Disable screen saver
>   - `7`: Dashboard
>   - `10`: Put display to sleep
>   - `11`: Launchpad
>   - `12`: Notification Center
>   - `13`: Lock Screen
> - [Hot Corners profiles](https://blog.jiayu.co/2018/12/quickly-configuring-hot-corners-on-macos/)

```bash
# bottom left - desktop
$ defaults write com.apple.dock wvous-bl-corner -int 4 && killall Dock

# bottom right - application windows
$ defaults write com.apple.dock wvous-br-corner -int 3 && killall Dock

# top right - mission control
$ defaults write com.apple.dock wvous-tr-corner -int 2 && killall Dock

# current settings
$ defaults read com.apple.dock | grep corner
    "wvous-bl-corner" = 4;
    "wvous-br-corner" = 3;
    "wvous-tr-corner" = 2;

# or
$ defaults read com.apple.dock | grep corner | sed -n -E 's/    "(.+)" = (.+);/\1=\2/p'
wvous-bl-corner=4
wvous-br-corner=3
wvous-tr-corner=2
```

![hot corners](../screenshot/osx/osx-hot-cornor.png)

### modifiers

> [!TIP|label:references:]
> - [Setting Mac hot corners in the terminal](https://dev.to/darrinndeal/setting-mac-hot-corners-in-the-terminal-3de)
>   - `0`: No Modifier
>   - `131072`: Shift Key
>   - `262144`: Control Key
>   - `524288`: Option Key
>   - `1048576`: Command Key

```bash
# current settings
$ defaults read com.apple.dock | grep 'modifier'
    "autohide-time-modifier" = "0.5";
    "wvous-bl-modifier" = 0;
    "wvous-br-modifier" = 0;
    "wvous-tr-modifier" = 0

# or
$ defaults read com.apple.dock | grep modifier | sed -n -E 's/    "(.+)" = (.+);/\1=\2/p'
autohide-time-modifier="0.5"
wvous-bl-modifier=0
wvous-br-modifier=0
wvous-tr-modifier=0
```

### reduce the menu bar item spacing

> [!TIP|label:see also]
> - [* iMarslo: notch](./tricky.md#reduce-the-menu-bar-item-spacing)

```bash
# get current status
$ defaults -currentHost read -globalDomain NSStatusItemSpacing
$ defaults -currentHost read -globalDomain NSStatusItemSelectionPadding

# setup spacing
$ defaults -currentHost write -globalDomain NSStatusItemSpacing -int 12
$ defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 8
$ killall SystemUIServer

# revert
$ defaults -currentHost delete -globalDomain NSStatusItemSpacing
$ defaults -currentHost delete -globalDomain NSStatusItemSelectionPadding
$ killall SystemUIServer
```

### Launchpad

#### enlarge icon
```bash
# enlarge
$ defaults write com.apple.Dock springboard-rows -int 4
$ defaults write com.apple.Dock springboard-columns -int 4

# shrink
$ defaults write com.apple.Dock springboard-rows -int 10
$ defaults write com.apple.Dock springboard-columns -int 10

# reset
$ defaults delete com.apple.Dock springboard-rows
$ defaults delete com.apple.Dock springboard-columns
$ defaults write com.apple.Dock ResetLaunchPad -bool true
```

#### reset launchpad
```bash
$ defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock
# or
$ [ -e ~/Library/Application\ Support/Dock/*.db ] && rm ~/Library/Application\ Support/Dock/*.db

# revert back
$ defaults delete com.apple.dock springboard-rows
$ defaults delete com.apple.dock springboard-columns
$ defaults write com.apple.dock ResetLaunchPad -bool true && killall Dock
```

### dashboard

#### disable dashboard
```bash
# disable
$ defaults write com.apple.dashboard mcx-disabled -boolean YES && killall Dock

# enable
$ defaults write com.apple.dashboard mcx-disabled -boolean NO && killall Dock
```

### keyboard remapping

> [!NOTE|label:references:]
> - ONLY for filco Minila
>   - [How to remap modifier keys in macOS Ventura or Monterey](https://www.theverge.com/23591533/mac-remap-keyboard-how-to)
> - for filco minila air, enable dip switch 2, 5 and 6
>   - 2: change CapsLock and Esc
>   - 5: Mac-specific mode
>   - 6: power saving mode

![keyboard remapping for macos](../screenshot/osx/osx-keyboard-remapping.png)

### keyboard
```bash
# read
$ defaults read NSGlobalDomain NSUserDictionaryReplacementItems

# quote option
$ defaults read NSGlobalDomain "KB_DoubleQuoteOption"
"abc"
$ defaults read NSGlobalDomain "KB_SingleQuoteOption"
'abc'

# repeat
```

### reset dns cache

> [!NOTE|label:references:]
> - [How to Flush DNS Cache on a Mac](https://www.lifewire.com/flush-dns-cache-on-a-mac-5209298)
> - [How to Flush DNS on Mac – MacOS Clear DNS Cache](https://www.freecodecamp.org/news/how-to-flush-dns-on-mac-macos-clear-dns-cache/)
> - [How to reset the DNS cache in OS X](https://www.defaults-write.com/how-to-reset-the-dns-cache-in-os-x/)

```bash
$ sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder
```

| MACOS VERSION                | COMMAND                                                         |
|------------------------------|-----------------------------------------------------------------|
| macOS 12 (Monterey)          | `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder` |
| macOS 11 (Big Sur)           | `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder` |
| macOS 10.15 (Catalina)       | `sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder` |
| macOS 10.14 (Mojave)         | `sudo killall -HUP mDNSResponder`                               |
| macOS 10.13 (High Sierra)    | `sudo killall -HUP mDNSResponder`                               |
| macOS 10.12 (Sierra)         | `sudo killall -HUP mDNSResponder`                               |
| OS X 10.11 (El Capitan)      | `sudo killall -HUP mDNSResponder`                               |
| OS X 10.10 (Yosemite)        | `sudo discoveryutil udnsflushcaches`                            |
| OS X 10.9 (Mavericks)        | `sudo killall -HUP mDNSResponder`                               |
| OS X 10.8 (Mountain Lion)    | `sudo killall -HUP mDNSResponder`                               |
| Mac OS X 10.7 (Lion)         | `sudo killall -HUP mDNSResponder`                               |
| Mac OS X 10.6 (Snow Leopard) | `sudo dscacheutil -flushcache`                                  |
| Mac OS X 10.5 (Leopard)      | `sudo lookupd -flushcache`                                      |
| Mac OS X 10.4 (Tiger)        | `lookupd -flushcache`                                           |

#### cursor
- blink rate
  ```bash
  # 1000 = 1 sec
  $ defaults write -g NSTextInsertionPointBlinkPeriodOn -float 200
  $ defaults write -g NSTextInsertionPointBlinkPeriodOff -float 200

  # revert
  $ defaults delete -g NSTextInsertionPointBlinkPeriodOn
  $ defaults delete -g NSTextInsertionPointBlinkPeriodOff
  ```

#### active dark mode
```bash
$ defaults write -g NSRequiresAquaSystemAppearance -bool true
# logout and login

# revert
$ defaults write -g NSRequiresAquaSystemAppearance -bool false
```

- read from `NSGlobalDomain`
  ```bash
  $ defaults read NSGlobalDomain AppleInterfaceStyle
  Dark
  ```

#### automatic terminate inactive apps
```bash
# disable
$ defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# enable
$ defaults write NSGlobalDomain NSDisableAutomaticTermination -bool false
```

#### viewer windows mode
```bash
# non-floating mode
$ defaults write com.apple.helpviewer DevMode -bool true

# floating mode
$ defaults write com.apple.helpviewer DevMode -bool false
```

#### textEdit
```bash
# plain text mode
$ defaults write com.apple.TextEdit RichText -int 0
# revert
$ defaults delete com.apple.TextEdit RichText

# UTF-8 in TextEdit
$ defaults write com.apple.TextEdit PlainTextEncoding -int 4
$ defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
```

#### disk utility
```bash
# enable debug menu
$ defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
$ defaults write com.apple.DiskUtility advanced-image-options -bool true
```

### QuickTime

> [!NOTE|label:references:]
> - [QuickTime](https://lupin3000.github.io/macOS/defaults/#quicktime)

#### auto-play
```bash
# enable autostart movies
$ defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# disable autostart movies
$ defaults delete com.apple.QuickTimePlayerX MGPlayMovieOnOpen
```

#### rounded corners
```bash
# diable rounded corners
$ defaults write com.apple.QuickTimePlayerX MGCinematicWindowDebugForceNoRoundedCorners -bool true

# enable rounded corners
$ defaults delete com.apple.QuickTimePlayerX MGCinematicWindowDebugForceNoRoundedCorners
```

#### controller bar
```bash
# disable controller bar
$ defaults write com.apple.QuickTimePlayerX MGUIVisibilityNeverAutoshow -bool true

# enable controller bar
$ defaults delete com.apple.QuickTimePlayerX MGUIVisibilityNeverAutoshow
```

#### auto show subtitles
```bash
# enable auto show subtitles
$ defaults write com.apple.QuickTimePlayerX MGEnableCCAndSubtitlesOnOpen -bool true

# disable auto show subtitles
$ defaults delete com.apple.QuickTimePlayerX MGEnableCCAndSubtitlesOnOpen
```

### App Store
```bash
# enable the webkit developer tools
$ defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# enable debug menu
$ defaults write com.apple.appstore ShowDebugMenu -bool true

# enable the automatic update check
$ defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# check for software updates daily instead of weekly
$ defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# download newly available updates in background
$ defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# install system data files & security updates
$ defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# automatically download apps purchased on other macs
$ defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# turn on app auto-update
$ defaults write com.apple.commerce AutoUpdate -bool true

# allow the app store to reboot machine on macos updates
$ defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
```

#### activity monitor
```bash
# show main window
$ defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# visualize cpu usage
$ defaults write com.apple.ActivityMonitor IconType -int 5

# show all processes
$ defaults write com.apple.ActivityMonitor ShowCategory -int 0

# sort via cpu usage
$ defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
$ defaults write com.apple.ActivityMonitor SortDirection -int 0

# update frequency
$ defaults write com.apple.ActivityMonitor "UpdatePeriod" -int "1" && killall Activity\ Monitor

# dock icon type
## 1: regular icon
$ defaults write com.apple.ActivityMonitor "IconType" -int "0" && killall Activity\ Monitor
## 2: show network usage over time
$ defaults write com.apple.ActivityMonitor "IconType" -int "2" && killall Activity\ Monitor
## 3: show disk usage over time, as two mirrored line graphs
$ defaults write com.apple.ActivityMonitor "IconType" -int "3" && killall Activity\ Monitor
## 5: show the current cpu usages, as a verticle meter.
$ defaults write com.apple.ActivityMonitor "IconType" -int "5" && killall Activity\ Monitor
## 6: show cpu usage history, graphed over time
$ defaults write com.apple.ActivityMonitor "IconType" -int "6" && killall Activity\ Monitor
```

#### over-the-top focus ring animation
```bash
# disable
$ defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false
```

#### spotlight
```bash
# disable
$ sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# enable
$ sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# [not recommended] hide icon
$ sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search

# stop indexing in a specific volume
$ sudo mdutil -i off "/Volumes/<name>"

# stop mdutil in a specific volume
$ sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes/<name>"
```

#### change indexing order
```bash
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}' \
  '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
  '{"enabled" = 0;"name" = "MENU_OTHER";}' \
  '{"enabled" = 0;"name" = "MENU_CONVERSION";}' \
  '{"enabled" = 0;"name" = "MENU_EXPRESSION";}' \
  '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
  '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'

# Load new settings before rebuilding the index
killall mds > /dev/null 2>&1
# make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# rebuild the index from scratch
sudo mdutil -E / > /dev/null
```

#### crash reporter
```bash
# disable
$ defaults write com.apple.CrashReporter DialogType none
```

#### notification center
```bash
# disable
$ launchctl unload -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && killall NotificationCenter

# enable
$ launchctl load -w /System/Library/LaunchAgents/com.apple.notificationcenterui.plist && killall NotificationCenter
```
#### time machine
```bash
# disable dialog
$ defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# or disable local backup
$ hash tmutil &> /dev/null && sudo tmutil disablelocal
```

#### scrollbars
```bash
# always show
$ defaults write NSGlobalDomain AppleShowScrollBars -string "Auto"
```

#### rubber-band scrolling
```bash
# disable
$ defaults write -g NSScrollViewRubberbanding -int 0

# enable
$ defaults delete -g NSScrollViewRubberbanding
```

#### airdrop
```bash
# enable airdrop from ethernet
$ defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
```

#### ASCII control characters using caret notation in standard text views

> [!NOTE|label:references:]
> - [#465 : NSTextShowsControlCharacters setting causes Mail to freeze](https://github.com/mathiasbynens/dotfiles/issues/465)
> - [Mail App Freezes/Hangs OS X 10.10.2](https://discussions.apple.com/thread/6801271)

```bash
$ defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true
```

#### system-wide resume ( disable tab memory )
```bash
# disable
$ defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false
```

#### loginwindow
```bash
# reveal ip address, hostname, os version, etc. when clicking the clock in the login window
$ sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName

# revert
$ sudo defaults delete /Library/Preferences/com.apple.loginwindow AdminHostInfo
```

### sleep mode

> [!TIP]
> - check current status
>   ```bash
>   $ pmset -g
>
>   # show detail
>   $ pmset -g assertions
>
>   # show log
>   $ pmset -g log
>   ```
> - references:
>   - [Prevent Mac from sleeping when lid closed on Mojave / Catalina](https://apple.stackexchange.com/a/361398/254265)
>   - [Command-line stop MacBook from sleeping when lid is closed?](https://apple.stackexchange.com/a/374958/254265)
>   - [How can I keep my Mac awake AND locked?](https://apple.stackexchange.com/a/380228/254265)
>   - [Mac not sleeping when lid is closed](https://apple.stackexchange.com/a/367540/254265)
>   - [man caffeinate](https://ss64.com/mac/caffeinate.html)

<!--sec data-title="pmset sample data" data-id="section0" data-show=true data-collapse=true ces-->
```bash
$ pmset -g
System-wide power settings:
 DestroyFVKeyOnStandby    0
Currently in use:
 standby              1
 Sleep On Power Button 1
 hibernatefile        /var/vm/sleepimage
 powernap             1
 networkoversleep     0
 disksleep            180
 sleep                0 (sleep prevented by bluetoothd, sharingd, powerd, useractivityd, runningboardd)
 hibernatemode        3
 ttyskeepawake        1
 displaysleep         30
 tcpkeepalive         1
 lowpowermode         0
 womp                 1

# or
$ pmset -g
System-wide power settings:
 DestroyFVKeyOnStandby    0
Currently in use:
 standby              1
 Sleep On Power Button 1
 hibernatefile        /var/vm/sleepimage
 powernap             1
 networkoversleep     0
 disksleep            180
 sleep                0 (sleep prevented by sharingd, powerd, bluetoothd)
 hibernatemode        3
 ttyskeepawake        1
 displaysleep         0
 tcpkeepalive         1
 lowpowermode         0
 womp                 1
```
<!--endsec-->

#### [check status](https://apple.stackexchange.com/a/464866/254265)
```bash
$ pmset -g assertions | grep SystemSleep
   PreventSystemSleep             0
   PreventUserIdleSystemSleep     1
   pid 1253(sharingd): [0x00005c8600019765] 00:01:29 PreventUserIdleSystemSleep named: "Handoff"
   pid 322(powerd): [0x0000329f000191ea] 03:00:17 PreventUserIdleSystemSleep named: "Powerd - Prevent sleep while display is on"
   pid 371(bluetoothd): [0x00005cdb0001977b] 00:00:04 PreventUserIdleSystemSleep named: "com.apple.BTStack"
```

#### no idle
```bash
$ pmset noidle
```

#### never go to slepp mode
```bash
# default
$ sudo systemsetup -getcomputersleep
Computer Sleep: after 120 minutes

# never go to sleep mode
$ sudo systemsetup -setcomputersleep Off
2024-12-09 14:20:14.400 systemsetup[18647:239595] ### Error:-99 File:/AppleInternal/Library/BuildRoots/289ffcb4-455d-11ef-953d-e2437461156c/Library/Caches/com.apple.xbs/Sources/Admin/InternetServices.m Line:379
setcomputersleep: Never
# or
$ sudo systemsetup -setcomputersleep Off > /dev/null

# get
$ sudo systemsetup -getcomputersleep
Computer Sleep: Never

# disable computer sleep and stop the display from shutting off
$ sudo pmset -a sleep 0
$ sudo pmset -a displaysleep 0

# disable hibernatemode to speeds up entering sleep mode
$ sudo pmset -a hibernatemode 0
```

#### [display sleep](https://apple.stackexchange.com/a/35718/254265)

```bash
# set display off timer
$ sudo pmset -a displaysleep 30

$ sudo pmset -a displaysleep 180
Warning: Idle sleep timings for "Battery Power" may not behave as expected.
- Display sleep should have a lower timeout than system sleep.
Warning: Idle sleep timings for "AC Power" may not behave as expected.
- Display sleep should have a lower timeout than system sleep.

# get display off timer
$ sudo pmset -g | grep displaysleep
displaysleep         180
```

#### set standby
```bash
# to 24 hours
$ sudo pmset -a standbydelay 86400
```

#### power button in stand-by mode
```bash
# disable
$ defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

# revert to original
$ defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool yes
```

#### remove sleep image file
```bash
$ sudo rm /Private/var/vm/sleepimage
# creating a zero-byte file instead of
$ sudo touch /Private/var/vm/sleepimage
# make sure be rewritten
$ sudo chflags uchg /Private/var/vm/sleepimage
```

#### un-useful sudden motion sensor for SSDs
```bash
# disable
$ sudo pmset -a sms 0
```

#### smart quotes and smart dashes
```bash
# disable
$ defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
$ defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
```

#### requiring password immediately

> [!NOTE|label:references:]
> - [Disable screensaver password requirement from command line](https://apple.stackexchange.com/a/51454/254265)

```bash
$ defaults write com.apple.screensaver askForPassword -int 1
$ defaults write com.apple.screensaver askForPasswordDelay -int 0
```

#### subpixel font rendering
```bash
# enable subpixel font rendering on non-Apple LCDs
$ defaults write NSGlobalDomain AppleFontSmoothing -int 2
```

#### HiDPI display modes
```bash
$ sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true
$ sudo reboot
```

#### prevent automatic sleep when display is off

![prevent automatic sleep when display is off](../screenshot/osx/prevent-automatic-sleep-when-display-off.png)

### screensaver

> [!NOTE|label:references:]
> - [#1332 MacOS Sonoma Screen Saver Configuration plist](https://github.com/JohnCoates/Aerial/issues/1332)
> - [phaselden/FlipIt](https://github.com/phaselden/FlipIt) | [alexanderk23/gluqlo](https://github.com/alexanderk23/gluqlo)

```bash
$ defaults -currentHost read com.apple.screensaver
{
    CleanExit = 1;
    idleTime = 3600;
    moduleDict =     {
        moduleName = Shell;
        path = "/System/Library/ExtensionKit/Extensions/Shell.appex";
        type = 0;
    };
    tokenRemovalAction = 0;
}

$ cd ~/Library/Application\ Support/com.apple.wallpaper/Store; \
  plutil -extract "AllSpacesAndDisplays.Idle.Content.Choices.0.Configuration" raw Index.plist | base64 --decode > temp.plist; \
  plutil -p temp.plist
{
  "module" => {
    "relative" => "file:///System/Library/ExtensionKit/Extensions/Shell.appex"
  }
}
```

## others
#### feedback assistant
- auto gather
  ```bash
  # allow large
  $ defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool true

  # not allow
  $ defaults write com.apple.appleseed.FeedbackAssistant Autogather -bool false
  ```

#### [sidecar on incompatible macs](https://www.defaults-write.com/enable-sidecar-incompatible-macs/)
```bash
$ defaults write com.apple.sidecar.display AllowAllDevices -bool true;
$ defaults write com.apple.sidecar.display hasShownPref -bool true;
$ open /System/Library/PreferencePanes/Sidecar.prefPane
```

#### open photos automatically
```bash
# disable
$ defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true

# revert back
$ defaults -currentHost delete com.apple.ImageCapture disableHotPlug
```

#### [show one application at a time](https://www.defaults-write.com/show-one-application-at-a-time/)
```bash
$ defaults write com.apple.dock single-app -bool true && killall Dock

# revert to orignial
$ defaults write com.apple.dock single-app -bool no && killall Dock
```

#### [gatekeeper](https://www.defaults-write.com/disable-gatekeeper-on-your-mac/)
```bash
# disable
$ defaults write /Library/Preferences/com.apple.security GKAutoRearm -bool false

# revert to original
$ defaults delete /Library/Preferences/com.apple.security GKAutoRearm
```

![gatekeeper](../screenshot/osx/osx-gatekeeper.png)

#### music song notifications
```bash
# show
$ defaults write com.apple.Music "userWantsPlaybackNotifications" -bool "false" && killall Music
```

#### [confirm changes popup](https://macos-defaults.com/misc/nsclosealwaysconfirmschanges.html)
```bash
# disable
$ defaults write NSGlobalDomain "NSCloseAlwaysConfirmsChanges" -bool "true"
```

#### [function keys behavior](https://macos-defaults.com/misc/applekeyboardfnstate.html)
```bash
# default
$ defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

# setup
$ defaults write NSGlobalDomain com.apple.keyboard.fnState -bool true
```

#### disable Recent Items

> [!NOTE|label:references:]
> - [Clear and disable recent items in OS X dock and applications](https://simon.heimlicher.com/technology/disable-recent-items/)
> - [How to remove Apple Menu > Recent Items completely? — Servers entry stuck](https://discussions.apple.com/thread/254464926?answerId=258347063022&sortBy=rank#258347063022)

![disable recent itmes](../screenshot/osx/osx-recents.png)

# backup & restore
## [Moon](https://manytricks.com/osticket/kb/faq.php?id=53)
- backup
  ```bash
  $ defaults export com.manytricks.Moom ~/Desktop/Moom.plist
  ```
- restore
  ```bash
  $ defaults import com.manytricks.Moom ~/Desktop/Moom.plist
  ```

## vscode
#### [extension](https://superuser.com/a/1452176)
- backup
  ```bash
  $ code --list-extensions >> vs_code_extensions_list.txt
  ```
- restore
  ```bash
  $ cat vs_code_extensions_list.txt | xargs -n 1 code --install-extension
  ```

#### [settings](https://superuser.com/a/1481920)
- `$HOME/Library/Application Support/Code/User/settings.json`
