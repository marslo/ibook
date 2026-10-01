<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [notch](#notch)
- [hammerspoon](#hammerspoon)
  - [to show debug info](#to-show-debug-info)
- [input method auto switch](#input-method-auto-switch)
  - [im-select](#im-select)
  - [macime](#macime)
  - [macism](#macism)
  - [switch input method in cursor/vscode](#switch-input-method-in-cursorvscode)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## notch

> [!TIP|label:references:]
> - [MacBook 刘海（Notch）增强工具推荐](https://utgd.net/article/20546)
> - [* How to fix Mac menu bar icons hidden by the MacBook notch](https://www.jessesquires.com/blog/2023/12/16/macbook-notch-and-menu-bar-fixes/)
> - [PSA: Reduce your menu bar spacing to fit more items](https://www.reddit.com/r/MacOS/comments/1dfu8w0/psa_reduce_your_menu_bar_spacing_to_fit_more_items/)
> - [Change the Menu Bar Item Spacing](https://www.reddit.com/r/MacOS/comments/vx7wb1/change_the_menu_bar_item_spacing/)
> - [2021 Macbook Pro 16" / 14" Menu Bar Size Limitation (Result of Display Notch)](https://discussions.apple.com/thread/253299524?sortBy=rank)


## hammerspoon

> [!NOTE|label:references:]
> - [Hammerspoon](https://www.hammerspoon.org/)

### to show debug info
```lua
-- ~/.hammerspoon/init.lua
local function logFocused()
  local app = hs.application.get("Cursor")
  if not app then print("Cursor not running"); return end
  local focused = hs.axuielement.applicationElement(app):attributeValue("AXFocusedUIElement")
  if not focused then print("no focused element"); return end
  print("=== focused element ===")
  print("role:        " .. (focused:attributeValue("AXRole")            or "nil"))
  print("subrole:     " .. (focused:attributeValue("AXSubrole")         or "nil"))
  print("description: " .. (focused:attributeValue("AXRoleDescription") or "nil"))
  print("title:       " .. (focused:attributeValue("AXTitle")           or "nil"))
  print("identifier:  " .. (focused:attributeValue("AXIdentifier")      or "nil"))
  print("label:       " .. (focused:attributeValue("AXLabel")           or "nil"))
  print("=======================")
end

-- ctrl + F1: log focused element
hs.hotkey.bind({"ctrl"}, "f1", logFocused)
```

## input method auto switch

### im-select
```bash
$ brew tap daipeihust/tap
$ brew install im-select

# or
$ curl -Ls https://raw.githubusercontent.com/daipeihust/im-select/master/install_mac.sh | sh

# or compile from source
$ git clone https://github.com/laishulu/macism /tmp/macism
$ cd /tmp/macism && swiftc macism.swift -o macism
$ sudo mv macism /usr/local/bin/
```

### macime
```bash
$ brew tap riodelphino/tap
$ brew install macime
```

```bash
# list all input method
$ macime list
com.apple.keylayout.US
com.apple.CharacterPaletteIM
com.apple.inputmethod.ironwood
com.sogou.inputmethod.sogou.pinyin
com.sogou.inputmethod.sogou

# get current input method
$ macime get
com.sogou.inputmethod.sogou.pinyin

# switch input method
$ macime set com.apple.keylayout.US
```

```vim
" autocmd for force change input method
if executable('macime')
  let g:ime_en = 'com.apple.keylayout.US'
  augroup Ime_Switch
    autocmd!
    autocmd FocusGained  * call system( 'macime set ' . g:ime_en )
    autocmd InsertLeave  * call system( 'macime set ' . g:ime_en )
    autocmd CmdlineLeave * call system( 'macime set ' . g:ime_en )
  augroup END
endif

" --- or ---
if executable('macime')
  let g:ime_en = 'com.apple.keylayout.US'
  augroup Ime_Switch
    autocmd!
    autocmd WinEnter     * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
    autocmd InsertLeave  * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
    autocmd CmdlineLeave * silent! call system( 'macime set ' . g:ime_en . ' &>/dev/null &' )
  augroup END
endif
```

### macism
```bash
$ brew tap laishulu/homebrew
$ brew install macism
```

### switch input method in cursor/vscode
```lua
local MACIME  = "/opt/homebrew/bin/macime"
local ENGLISH = "com.apple.keylayout.US"

-- brew tap riodelphino/tap && brew install macime
local function switchToEnglish()
  hs.execute(MACIME .. " set " .. ENGLISH)
end

local function getFocusedDescription(app)
  local el = hs.axuielement.applicationElement(app):attributeValue("AXFocusedUIElement")
  if not el then return nil end
  return el:attributeValue("AXRoleDescription")
end

-- watch focus changes within Cursor
local observer

local function startObserver()
  local app = hs.application.get("Cursor")
  if not app then return end

  local axApp = hs.axuielement.applicationElement(app)
  observer = hs.axuielement.observer.new(app:pid())
  observer:addWatcher(axApp, "AXFocusedUIElementChanged")
  observer:callback(function()
    local a = hs.application.get("Cursor")
    if not a then return end
    local desc = getFocusedDescription(a)
    if desc == "editor" then
      switchToEnglish()
    end
  end)
  observer:start()
end

-- start observer when Cursor launches or is activated
hs.application.watcher.new(function(name, event, _)
  if name ~= "Cursor" then return end
  if event == hs.application.watcher.launched
  or event == hs.application.watcher.activated then
    startObserver()
  end
  if event == hs.application.watcher.terminated then
    if observer then observer:stop(); observer = nil end
  end
end):start()

-- handle already-running Cursor
startObserver()
```
