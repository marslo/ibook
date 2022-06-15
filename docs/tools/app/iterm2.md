<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [tab](#tab)
  - [setup a colorful tab](#setup-a-colorful-tab)
  - [add favor color to a file (`~/.marslo/.colors`)](#add-favor-color-to-a-file-marslocolors)
- [[hidden settings](Hidden Settings)](#hidden-settingshidden-settings)
- [iTerm2 Python REPL](#iterm2-python-repl)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## tab
### setup a colorful tab
#### pick colors

{% hint style='tip' %}
> using : `tabset --list`
{% endhint %}

```bash
> $ while read i; do
>   c=$(echo $i | awk -F':' '{print $1}');
>   echo === $c === ;
>   tabset --add m-$c $c;
> done < csscolors.js

$ tabset --list
```

![tabset list](../../screenshot/iterm2/tabset-list-1.png)

### add favor color to a file (`~/.marslo/.colors`)
```bash
$ echo "<color-name>" >> ~/.marslo/.colors
```

#### get color hex (for [`it2setcolor`](https://github.com/gnachman/iterm2-website/blob/master/source/utilities/it2setcolor))

{% hint style='tip' %}
> download original csscolor.js if necessory:
> ```bash
> $ curl -fsSL -O https://raw.githubusercontent.com/jonathaneunice/iterm2-tab-set/master/csscolors.js
> ```
{% endhint %}

```bash
$ while read -r i; do
>   rgb=$(grep -E "\s$i:" csscolors.js | sed -re "s:.*\[(.*)\],?$:\1:";)
>   hexc=$(for c in $(echo ${rgb} | sed -re 's:,::g'); do printf '%x' $c; done)
>   echo -e """$i :\t$rgb :\t$hexc"""
>   echo "$hexc" >> ~/.marslo/.it2color
> done < ~/.marslo/.colors
```

result:
```bash
$ ./rgb2hex.sh
yellowgreen   : 154, 205, 50  : 9acd32
wheat         : 245, 222, 179 : f5deb3
tomato        : 255, 99, 71   : ff6347
steelblue     : 70, 130, 180  : 4682b4
tan           : 210, 180, 140 : d2b48c
sandybrown    : 244, 164, 96  : f4a460
plum          : 221, 160, 221 : dda0dd
palegoldenrod : 238, 232, 170 : eee8aa
palegreen     : 152, 251, 152 : 98fb98
navajowhite   : 255, 222, 173 : ffdead
olive         : 128, 128, 0   : 80800
moccasin      : 255, 228, 181 : ffe4b5
chartreuse    : 127, 255, 0   : 7fff0
palegreen     : 152, 251, 152 : 98fb98
mediumorchid  : 186, 85, 211  : ba55d3
royalblue     : 65, 105, 225  : 4169e1
olivedrab     : 107, 142, 35  : 6b8e23
khaki         : 240, 230, 140 : f0e68c
```

#### [show color in iterm2](https://raw.githubusercontent.com/marslo/mylinux/master/confs/home/.marslo/.marslorc)
```bash
$ cat << 'EOF' > ~/.profile
# iTerm2 tab titles
function itit {
  if [ "$1" ]; then
    unset PROMPT_COMMAND
    echo -ne "\\033]0;${1}\\007"

    if [ 2 -eq $# ]; then
      case $2 in
        [cC] )
          it2setcolor tab $(shuf -n 1 ~/.marslo/.it2colors) || echo
          ;;
        [bB] )
          printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "${1} \(user.gitBranch)" | base64)
          ;;
        [bB][cC] | [cC][bB] )
          printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "${1}" | base64)
          it2setcolor tab $(shuf -n 1 ~/.marslo/.it2colors) || echo
          ;;
      esac
    fi

  else
    export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/\~}\007";'
    printf "\e]1337;SetBadgeFormat=%s\a" $(echo -n "" | base64)
    it2setcolor tab default
  fi
}
EOF
```

- usage:
  ```bash
  $ itit 'title-string-here' [c][b]
  ```
- result:

![itit <string> c](../../screenshot/iterm2/itit-c.png)

![itit string bc](../../screenshot/iterm2/itit-bc.png)

## [hidden settings](Hidden Settings)
- To change the number of entries in the autocomplete menu:
  ```bash
  $ defaults write com.googlecode.iterm2 AutocompleteMaxOptions -int 10
  ```

- To change the number of coprocess commands remembered:
  ```bash
  $ defaults write com.googlecode.iterm2 "Coprocess MRU" -int 10
  ```

- To preserve whitespace in selections copied to the pasteboard:
  ```bash
  $ defaults write com.googlecode.iterm2 TrimWhitespaceOnCopy -bool false
  ```

- When you open a file from the finder in iTerm2 (e.g., by double-clicking a shell script), it will either open in a window or a tab. By default, it opens in a tab. You can change this with:
  ```bash
  $ defaults write com.googlecode.iterm2 OpenFileInNewWindows -bool true
  ```
- quite iTerm2 when the last session is closed
  ```bash

  $ defaults write com.googlecode.iterm2 MinRunningTime -float 10.0
  ```
- increase the delay before it attempts to reconfigure itself after a change of monitors
  ```bash
  $ defaults write com.googlecode.iterm2 UpdateScreenParamsDelay -float 1.0
  ```

- To change the number of paste history entries saved:
  ```bash
  defaults write com.googlecode.iterm2 MaxPasteHistoryEntries -int 20
  ```

- Pastes (both regular and slow) are done by splitting the text to paste into chunks. There is a delay between the transmission of each chunk. To change the speed that "paste" pastes at:
  ```bash
  $ defaults write com.googlecode.iterm2 QuickPasteBytesPerCall -int 1024
  $ defaults write com.googlecode.iterm2 QuickPasteDelayBetweenCalls -float 0.01
  ```

- To change the speed that "paste slowly" pastes at:
  ```bash
  $ defaults write com.googlecode.iterm2 SlowPasteBytesPerCall -int 16
  $ defaults write com.googlecode.iterm2 SlowPasteDelayBetweenCalls -float 0.125
  ```

- To disable using the pinch gesture to change font size:
  ```bash
  $ defaults write com.googlecode.iterm2 PinchToChangeFontSizeDisabled -bool true
  ```

- To keep LC_CTYPE from being set when locale environment variables are set:
  ```bash
  $ defaults write com.googlecode.iterm2 DoNotSetCtype -bool true
  ```

- To allow Growl notifications to be posted for the current tab:
  ```bash
  $ defaults write com.googlecode.iterm2 GrowlOnForegroundTabs -bool true
  ```

- To tune smart cursor color settings:
  ```bash
  $ defaults write com.googlecode.iterm2.plist SmartCursorColorBgThreshold -float 0.5
  $ defaults write com.googlecode.iterm2.plist SmartCursorColorFgThreshold -float 0.75
  ```

- To allow a three-finger tap to act like a three-finger click:
  ```bash
  $ defaults write com.googlecode.iterm2.plist ThreeFingerTapEmulatesThreeFingerClick \
  -bool true
  ```

- To change the set of characters that are considered part of a URL (besides alphanumerics):
  ```bash
  $ defaults write com.googlecode.iterm2.plist URLCharacterSet -string \
  ".?\\/:;%=&_-,+~#@!*'()|[]"
  ```

- To use some experimental optimizations that will improve performance (safety not guaranteed):
  ```bash
  $ defaults write com.googlecode.iterm2.plist ExperimentalOptimizationsEnabled \
  -bool true
  ```

- To tweak tab sizes:
  ```bash
  $ defaults write com.googlecode.iterm2 UseUnevenTabs -bool false
  $ defaults write com.googlecode.iterm2 MinTabWidth -int 75
  $ defaults write com.googlecode.iterm2 MinCompactTabWidth -int 60
  $ defaults write com.googlecode.iterm2 OptimumTabWidth -int 175
  ```

- To change your search engine:
  ```bash
  $ defaults write com.googlecode.iterm2 SearchCommand \
  -string "http://google.com/search?q=%@"
  ```

- To adjust the speed of the animation of the hotkey window's appearance and disappearance:
  ```bash
  $ defaults write com.googlecode.iterm2 HotkeyTermAnimationDuration \
  -float 0.25
  ```

- To adjust the amount of dimming of split panes. Set the value to a floating-point number between 0 (no dimming) and 1 (complete dimming). The default is 0.15:
  ```bash
  $ defaults write com.googlecode.iterm2 SplitPaneDimmingAmount \
  -float 0.25
  ```

## [iTerm2 Python REPL](https://iterm2.com/python-api/tutorial/running.html)
```bash
Welcome to the iTerm2 Python REPL!

This is an interactive Python interpreter where you can experiment with
scripts. Unlike standard Python interpreters, you can use "await" not inside an
async function. Here's an example script to try:

import iterm2
connection=await iterm2.Connection.async_create()
await iterm2.Window.async_create(connection)

⌘-click here for iTerm2 Python API Docs

>>>
```
