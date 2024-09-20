

## apple script

{% hint style='tip' %}
> reference:
> - [How to automate your keyboard in Mac OS X with AppleScript](https://eastmanreference.com/how-to-automate-your-keyboard-in-mac-os-x-with-applescript)
> - [AppleScript Command Sendkeys](https://apple.stackexchange.com/a/314650/254265)
> - [How can I get rid of this osascript output?](https://stackoverflow.com/a/4147769/2940319)
> - [Running a command in a new Mac OS X Terminal window](https://stackoverflow.com/q/989349)
{% endhint %}

- sample code:
  ```applescript
  tell application "System Events"
    key code 124 using {shift down, command down} --> Right arrow
    key code 8 using command down --> ⌘-C
    key code {4, 14, 37, 37, 31, 47} --> H, e, l, l, o, .

    keystroke "v" using command down --> ⌘-V
    keystroke "Hello." --> H, e, l, l, o, .
  end tell
  ```

## key code

> [!NOTE|label:references:]
> - [* Complete list of AppleScript key codes](https://eastmanreference.com/complete-list-of-applescript-key-codes)
> - [Key Codes for Function and Special Keys in Applescript](https://macbiblioblog.blogspot.com/2014/12/key-codes-for-function-and-special-keys.html)

|          KEY         | KEY CODE |  |  KEY | KEY CODE |  | KEY | KEY CODE |
|:--------------------:|:--------:|--|:----:|:--------:|--|:---:|:--------:|
|         `!1`         |   `18`   |  | `"'` |   `39`   |  | `I` |   `34`   |
|         `@2`         |   `19`   |  | `_-` |   `27`   |  | `O` |   `31`   |
|         `#3`         |   `20`   |  | `+=` |   `24`   |  | `P` |   `35`   |
|         `$4`         |   `21`   |  | `<,` |   `43`   |  | `K` |   `40`   |
|         `%5`         |   `23`   |  | `>.` |   `47`   |  | `L` |   `37`   |
|         `^6`         |   `22`   |  | `?/` |   `44`   |  | `Z` |    `6`   |
|         `&7`         |   `26`   |  |  `N` |   `45`   |  | `X` |    `7`   |
|         `*8`         |   `28`   |  |  `M` |   `46`   |  | `C` |    `8`   |
|         `(9`         |   `25`   |  |  `Q` |   `12`   |  | `V` |    `9`   |
|         `)0`         |   `29`   |  |  `W` |   `13`   |  | `B` |   `11`   |
|    <code>~`</code>   |   `50`   |  |  `E` |   `14`   |  | `A` |    `0`   |
|         `{[`         |   `33`   |  |  `R` |   `15`   |  | `S` |    `1`   |
|         `}]`         |   `30`   |  |  `T` |   `17`   |  | `D` |    `2`   |
| <code>&vert;\</code> |   `42`   |  |  `Y` |   `16`   |  | `F` |    `3`   |
|         `:;`         |   `41`   |  |  `U` |   `32`   |  | `G` |    `5`   |
|                      |          |  |  `H` |    `4`   |  | `J` |   `38`   |

### function keys

|         KEY        | KEY CODE |  |          KEY         | KEY CODE |  |          KEY         | KEY CODE |
|:------------------:|:--------:|--|:--------------------:|:--------:|--|:--------------------:|:--------:|
|    `␣`<br>space    |   `49`   |  |      `⇥`<br>tab      |   `48`   |  |     `⌫`<br>delete    |   `51`   |
|    `⏎`<br>return   |   `36`   |  | `⌦`<br>forwarddelete |   `117`  |  |    `␊`<br>linefeed   |   `52`   |
|     `⎋`<br>esc     |   `53`   |  |    `⌘`<br>command    |   `55`   |  |     `⇧`<br>shift     |   `56`   |
|   `⇪`<br>capslock  |   `57`   |  |     `⌥`<br>option    |   `58`   |  |    `⌃`<br>control    |   `59`   |
| `⇧`<br>right shift |   `60`   |  |  `⌥`<br>right option |   `61`   |  | `⌃`<br>right control |   `62`   |
|     `⇱`<br>home    |    115   |  |      `⇲`<br>end      |    119   |  |    `⇞`<br>page up    |    116   |
|  `⇟`<br>page down  |    121   |  |   `←`<br>left arrow  |    123   |  |  `→`<br>right arrow  |    124   |
|  `↓`<br>down arrow |    125   |  |    `↑`<br>up arrow   |    126   |  |           -          |     -    |

### Fn keys

|  KEY  | KEY CODE |  |  KEY  | KEY CODE |  |  KEY  | KEY CODE |
|:-----:|:--------:|--|:-----:|:--------:|--|:-----:|:--------:|
|  `F1` |   `122`  |  |  `F2` |   `120`  |  |  `F3` |   `99`   |
|  `F4` |   `118`  |  |  `F5` |   `96`   |  |  `F6` |   `97`   |
|  `F7` |   `98`   |  |  `F8` |   `100`  |  |  `F9` |   `101`  |
| `F10` |   `109`  |  | `F11` |   `103`  |  | `F12` |   `111`  |

### Number pad

| KEY | KEY CODE |  |   KEY   | KEY CODE |  | KEY | KEY CODE |
|:---:|:--------:|--|:-------:|:--------:|--|:---:|:--------:|
| `1` |   `83`   |  |   `2`   |   `84`   |  | `3` |   `85`   |
| `4` |   `86`   |  |   `5`   |   `87`   |  | `6` |   `88`   |
| `7` |   `89`   |  |   `8`   |   `91`   |  | `9` |   `92`   |
| `0` |   `82`   |  |   `*`   |   `67`   |  | `/` |   `75`   |
| `+` |   `69`   |  |   `-`   |   `78`   |  | `=` |   `81`   |
| `.` |   `65`   |  | `clear` |   `71`   |  |  -  |    -     |
