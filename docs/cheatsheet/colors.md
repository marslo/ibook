<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [ansicolors](#ansicolors)
- [xterm 256 colors](#xterm-256-colors)
  - [xterm 256 colors chart](#xterm-256-colors-chart)
  - [256 colors cheat sheet](#256-colors-cheat-sheet)
- [man page colors](#man-page-colors)
  - [settings](#settings)
  - [using vim as man pager](#using-vim-as-man-pager)
  - [ansicolor issues in man page](#ansicolor-issues-in-man-page)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

{% hint style='tip' %}
> reference:
> - [* 256 Colors Cheat Sheet](https://www.ditig.com/256-colors-cheat-sheet)
> - [* 256 colors](https://robotmoon.com/256-colors/)
> - [* XTerm Color Cheat Sheet](https://www.tweaking4all.com/software/linux-software/xterm-color-cheat-sheet/)
> - [* Color names](https://proplot.readthedocs.io/en/stable/colors.html)
> - [* Web colors](https://www.wikiwand.com/en/Web_colors)
> - [256 Foreground and Background Colors - Full Chart](https://pypi.org/project/colored/)
> - [Bash tips: Colors and formatting (ANSI/VT100 Control sequences)](https://misc.flogisoft.com/bash/tip_colors_and_formatting)
> - [Bash Colors](https://www.shellhacks.com/bash-colors/)
> - [color grid](http://www.quut.com/berlin/ht/cgrid.html)
> - [Colours and Cursor Movement With tput](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x405.html)
> - [The 5 Best Color Picker Apps for Mac](https://www.makeuseof.com/tag/color-picker-apps-mac/)
> - [xterm 256color chart.svg](https://commons.wikimedia.org/wiki/File:Xterm_256color_chart.svg)
> - [Modifying the color of grep](https://askubuntu.com/a/1042242/92979)
{% endhint %}

> [!TIP]
> - foreground colors
>   ```
>   ┏━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━┓
>   ┃ ### ┃ GNOME Terminal          ┃ xterm                   ┃ non-GUI TTY           ┃
>   ┡━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━┩
>   │  39 │ «reset this color»      │ «reset this color»      │ «reset this color»    │
>   ├─────┼─────────────────────────┼─────────────────────────┼───────────────────────┤
>   │  30 │ very dark grey          │ black                   │ black                 │
>   │  31 │ dull red                │ red                     │ light red             │
>   │  32 │ dull green              │ light green             │ light green           │
>   │  33 │ dull yellow             │ yellow                  │ yellow                │
>   │  34 │ greyish blue            │ dark blue               │ sky blue              │
>   │  35 │ dull purple             │ purple                  │ purple                │
>   │  36 │ teal                    │ cyan                    │ cyan                  │
>   │  37 │ light grey              │ light grey              │ light grey            │
>   ├─────┼─────────────────────────┼─────────────────────────┼───────────────────────┤
>   │  90 │ dark grey               │ dull grey               │ dull grey             │
>   │  91 │ red                     │ bright red              │ bright red            │
>   │  92 │ lime green              │ bright green            │ bright green          │
>   │  93 │ yellow                  │ bright yellow           │ pure yellow           │
>   │  94 │ light greyish blue      │ dull blue               │ deep blue             │
>   │  95 │ light purple            │ magenta                 │ magenta               │
>   │  96 │ cyan                    │ bright cyan             │ bright cyan           │
>   │  97 │ off white               │ white                   │ white                 │
>   ├─────┴──────┬──────────────────┴─────────────────────────┴───────────────────────┤
>   │ 38;2;ʀ;ɢ;ʙ │ replace ʀ, ɢ, and ʙ with RGB values from 0 to 255                  │
>   │            │   for closest supported color (non-GUI TTY has only 16 colors!)    │
>   │ 38;5;ɴ     │ replace ɴ with value from 256-color chart below                    │
>   │            │   for closest supported color (non-GUI TTY has only 16 colors!)    │
>   └────────────┴────────────────────────────────────────────────────────────────────┘
>   ```
> - background colors
>  ```
>  ┏━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━┓
>  ┃ ### ┃ GNOME Terminal          ┃ xterm                   ┃ non-GUI TTY           ┃
>  ┡━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━┩
>  │  49 │ «reset this color»      │ «reset this color»      │ «reset this color»    │
>  ├─────┼─────────────────────────┼─────────────────────────┼───────────────────────┤
>  │  40 │ very dark grey          │ black                   │ black                 │
>  │  41 │ dull red                │ red                     │ light red             │
>  │  42 │ dull green              │ light green             │ light green           │
>  │  43 │ dull yellow             │ yellow                  │ yellow                │
>  │  44 │ greyish blue            │ dark blue               │ sky blue              │
>  │  45 │ dull purple             │ purple                  │ purple                │
>  │  46 │ teal                    │ cyan                    │ cyan                  │
>  │  47 │ light grey              │ light grey              │ light grey            │
>  ├─────┼─────────────────────────┼─────────────────────────┼╶╴╶╴╶╴╶╴╶╴╶╴╶╴╶╴╶╴╶╴╶╴╶┤
>  │ 100 │ dark grey               │ dull grey               │ black                 │
>  │ 101 │ red                     │ bright red              │ light red             │
>  │ 102 │ lime green              │ bright green            │ light green           │
>  │ 103 │ yellow                  │ bright yellow           │ yellow                │
>  │ 104 │ light greyish blue      │ dull blue               │ sky blue              │
>  │ 105 │ light purple            │ magenta                 │ purple                │
>  │ 106 │ cyan                    │ bright cyan             │ cyan                  │
>  │ 107 │ off white               │ white                   │ light grey            │
>  ├─────┴──────┬──────────────────┴─────────────────────────┴───────────────────────┤
>  │ 48;2;ʀ;ɢ;ʙ │ replace ʀ, ɢ, and ʙ with RGB values from 0 to 255                  │
>  │            │   for closest supported color (non-GUI TTY has only 8 colors!)     │
>  │ 48;5;ɴ     │ replace ɴ with value from 256-color chart below                    │
>  │            │   for closest supported color (non-GUI TTY has only 8 colors!)     │
>  └────────────┴────────────────────────────────────────────────────────────────────┘
>  ```
> - text styling
>   ```
>   ┏━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━━━┳━━━━━━━━━━━━━━━━━━━━━━━┓
>   ┃ ### ┃ GNOME Terminal          ┃ xterm                   ┃ non-GUI TTY           ┃
>   ┡━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━━━╇━━━━━━━━━━━━━━━━━━━━━━━┩
>   │     │ «reset style+colors»    │ «reset style+colors»    │ «reset style+colors»  │
>   │   0 │ «reset style+colors»    │ «reset style+colors»    │ «reset style+colors»  │
>   ├─────┼─────────────────────────┼─────────────────────────┼───────────────────────┤
>   │   1 │ +bold, +brighter color  │ +bold, +brighter color  │ +brighter color,      │
>   │     │                         │                         │   -forced grey        │
>   │   2 │ +fainter color          │ +fainter color          │ +forced grey          │
>   │   3 │ +italic                 │ +italic                 │ +forced green         │
>   │     │                         │                         │   ● overrides 2 and 4 │
>   │   4 │ +underline              │ +underline              │ +forced cyan          │
>   │     │                         │                         │   ● overrides 2       │
>   │   5 │ «no effect»             │ +blink                  │ «no effect»           │
>   │   7 │ +invert colors          │ +invert colors          │ +invert colors        │
>   │   8 │ +invisible              │ +invisible              │ «no effect»           │
>   │     │                         │   ● underline appears   │                       │
>   │   9 │ +strikethrough          │ +strikethrough          │ «no effect»           │
>   ├─────┼─────────────────────────┤                         ├───────────────────────┤
>   │  21 │ -bold, -brighter color, │ +double underline       │ -brighter color,      │
>   │     │   -fainter color        ├─────────────────────────┤   -forced grey        │
>   │  22 │ -bold, -brighter color, │ -bold, -brighter color, │ -brighter color,      │
>   │     │   -fainter color        │   -fainter color        │   -forced grey        │
>   │  23 │ -italic                 │ -italic                 │ -forced green         │
>   │  24 │ -underline              │ -underline,             │ -forced cyan          │
>   │     │                         │   -double underline     │                       │
>   │  25 │ «no effect»             │ -blink                  │ «no effect»           │
>   │  27 │ -invert colors          │ -invert colors          │ -invert colors        │
>   │  28 │ -invisible              │ -invisible              │ «no effect»           │
>   │  29 │ -strikethrough          │ -strikethrough          │ «no effect»           │
>   └─────┴─────────────────────────┴─────────────────────────┴───────────────────────┘
>   ```

## ansicolors
- 256 colors
  ```bash
  function 256color() {
    for i in {0..255}; do
      echo -e "\e[38;05;${i}m█${i}";
    done | column -c 180 -s ' '; echo -e "\e[m"
  }
  ```
  ![256 colors](../screenshot/colors/ansi/ansicolor-256-0.png)

  ```bash
  #!/bin/bash

  # This program is free software. It comes without any warranty, to
  # the extent permitted by applicable law. You can redistribute it
  # and/or modify it under the terms of the Do What The Fuck You Want
  # To Public License, Version 2, as published by Sam Hocevar. See
  # http://sam.zoy.org/wtfpl/COPYING for more details.

  for fgbg in 38 48 ; do # Foreground / Background
      for color in {0..255} ; do # Colors
          # Display the color
          printf "\e[${fgbg};5;%sm  %3s  \e[0m" $color $color
          # Display 6 colors per lines
          if [ $((($color + 1) % 6)) == 4 ] ; then
              echo # New line
          fi
      done
      echo # New line
  done
  exit 0
  ```
  ![256 colors](../screenshot/colors/ansi/ansicolor-256-1.png)

- colors and formatting
  ```bash
  #!/bin/bash

  # This program is free software. It comes without any warranty, to
  # the extent permitted by applicable law. You can redistribute it
  # and/or modify it under the terms of the Do What The Fuck You Want
  # To Public License, Version 2, as published by Sam Hocevar. See
  # http://sam.zoy.org/wtfpl/COPYING for more details.

  #Background
  for clbg in {40..47} {100..107} 49 ; do
    #Foreground
    for clfg in {30..37} {90..97} 39 ; do
      #Formatting
      for attr in 0 1 2 4 5 7 ; do
        #Print the result
        echo -en "\e[${attr};${clbg};${clfg}m ^[${attr};${clbg};${clfg}m \e[0m"
      done
      echo #Newline
    done
  done
  exit 0
  ```
  ![colors & formatting](../screenshot/colors/ansi/color-formatting.png)

  ```bash
  for attr in 0 1 2 3 4 5 6 7; do
    echo "------------------------------------------------"
    printf "ESC[%s;Foreground;Background - \n" $attr
    for fore in 30 31 32 33 34 35 36 37; do
        for back in 40 41 42 43 44 45 46 47; do
            printf '\033[%s;%s;%sm %02s;%02s\033[0m' $attr $fore $back $fore $back
        done
    printf '\n'
    done
    printf '\033[0m'
  done
  ```
  ![colors & formatting](../screenshot/colors/ansi/color-formatting-2.png)

- solarized color
  ```bash
  #!/bin/bash

  # solarized ansicolors (exporting for grins)
  export base03='\033[0;30;40m'
  export base02='\033[1;30;40m'
  export base01='\033[0;32;40m'
  export base00='\033[0;33;40m'
  export base0='\033[0;34;40m'
  export base1='\033[0;36;40m'
  export base2='\033[0;37;40m'
  export base3='\033[1;37;40m'
  export yellow='\033[1;33;40m'
  export orange='\033[0;31;40m'
  export red='\033[1;31;40m'
  export magenta='\033[1;35;40m'
  export violet='\033[0;35;40m'
  export blue='\033[1;34;40m'
  export cyan='\033[1;36;40m'
  export green='\033[1;32;40m'
  export reset='\033[0m'

  colors () {
    echo -e "base03  ${base03}Test$reset"
    echo -e "base02  ${base02}Test$reset"
    echo -e "base01  ${base01}Test$reset"
    echo -e "base00  ${base00}Test$reset"
    echo -e "base0   ${base0}Test$reset"
    echo -e "base1   ${base1}Test$reset"
    echo -e "base2   ${base2}Test$reset"
    echo -e "base3   ${base3}Test$reset"
    echo -e "yellow  ${yellow}Test$reset"
    echo -e "orange  ${orange}Test$reset"
    echo -e "red     ${red}Test$reset"
    echo -e "magenta ${magenta}Test$reset"
    echo -e "violet  ${violet}Test$reset"
    echo -e "blue    ${blue}Test$reset"
    echo -e "cyan    ${cyan}Test$reset"
    echo -e "green   ${green}Test$reset"
  }
  colors
  ```
  ![solarized colors](../screenshot/colors/ansi/solarized-colors.png)


## xterm 256 colors

> [!TIP]
> - [Web colors](https://www.wikiwand.com/en/Web_colors)

- blue
  ![blue](../screenshot/colors/blue.png)

- brown
  ![brown](../screenshot/colors/brown.png)

- cyan
  ![cyan](../screenshot/colors/cyan.png)

- gray.black
  ![gray.black](../screenshot/colors/gray.black.png)

- green
  ![green](../screenshot/colors/green.png)

- orange
  ![orange](../screenshot/colors/orange.png)

- pink
  ![pink](../screenshot/colors/pink.png)

- purple.magenta
  ![purple.magenta](../screenshot/colors/purple.magenta.png)

- red
  ![red](../screenshot/colors/red.png)

- white
  ![white](../screenshot/colors/white.png)

- yellow
  ![yellow](../screenshot/colors/yellow.png)

### xterm 256 colors chart

<a title="Jasonm23, CC0, via Wikimedia Commons" href="https://upload.wikimedia.org/wikipedia/commons/1/15/Xterm_256color_chart.svg">
  <img width="666" alt="xterm 256color chart" src="https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Xterm_256color_chart.svg/512px-Xterm_256color_chart.svg.png">
</a>


<a title="Color names" href="https://proplot.readthedocs.io/en/stable/_images/colors_2_0.svg">
  <img width="666" alt="color name" src="../screenshot/colors/colors_2.0.svg.png">
</a>

![Xterm_256color_chart](../screenshot/colors/Xterm_256color_chart.svg.png)

### 256 colors cheat sheet

| XTERM NUMBER |                XTERM NAME                |    HEX    | RGB              | HSL               | ANSI COLOR CODE |
|:------------:|:----------------------------------------:|:---------:|------------------|-------------------|:---------------:|
|       0      |          black<br>Black (SYSTEM)         | `#000000` | rgb(0,0,0)       | hsl(0,0%,0%)      |   `\e[38;5;0m`  |
|       1      |          red<br>Maroon (SYSTEM)          | `#800000` | rgb(128,0,0)     | hsl(0,100%,25%)   |   `\e[38;5;1m`  |
|       2      |          green<br>Green (SYSTEM)         | `#008000` | rgb(0,128,0)     | hsl(120,100%,25%) |   `\e[38;5;2m`  |
|       3      |         yellow<br>Olive (SYSTEM)         | `#808000` | rgb(128,128,0)   | hsl(60,100%,25%)  |   `\e[38;5;3m`  |
|       4      |           blue<br>Navy (SYSTEM)          | `#000080` | rgb(0,0,128)     | hsl(240,100%,25%) |   `\e[38;5;4m`  |
|       5      |        magenta<br>Purple (SYSTEM)        | `#800080` | rgb(128,0,128)   | hsl(300,100%,25%) |   `\e[38;5;5m`  |
|       6      |           cyan<br>Teal (SYSTEM)          | `#008080` | rgb(0,128,128)   | hsl(180,100%,25%) |   `\e[38;5;6m`  |
|       7      |       light_gray<br>Silver (SYSTEM)      | `#c0c0c0` | rgb(192,192,192) | hsl(0,0%,75%)     |   `\e[38;5;7m`  |
|       8      |        dark_gray<br>Grey (SYSTEM)        | `#808080` | rgb(128,128,128) | hsl(0,0%,50%)     |   `\e[38;5;8m`  |
|       9      |         light_red<br>Red (SYSTEM)        | `#ff0000` | rgb(255,0,0)     | hsl(0,100%,50%)   |   `\e[38;5;9m`  |
|      10      |       light_green<br>Lime (SYSTEM)       | `#00ff00` | rgb(0,255,0)     | hsl(120,100%,50%) |  `\e[38;5;10m`  |
|      11      |      light_yellow<br>Yellow (SYSTEM)     | `#ffff00` | rgb(255,255,0)   | hsl(60,100%,50%)  |  `\e[38;5;11m`  |
|      12      |        light_blue<br>Blue (SYSTEM)       | `#0000ff` | rgb(0,0,255)     | hsl(240,100%,50%) |  `\e[38;5;12m`  |
|      13      |     light_magenta<br>Fuchsia (SYSTEM)    | `#ff00ff` | rgb(255,0,255)   | hsl(300,100%,50%) |  `\e[38;5;13m`  |
|      14      |        light_cyan<br>Aqua (SYSTEM)       | `#00ffff` | rgb(0,255,255)   | hsl(180,100%,50%) |  `\e[38;5;14m`  |
|      15      |          white<br>White (SYSTEM)         | `#ffffff` | rgb(255,255,255) | hsl(0,0%,100%)    |  `\e[38;5;15m`  |
|      16      |              grey_0<br>Grey0             | `#000000` | rgb(0,0,0)       | hsl(0,0%,0%)      |  `\e[38;5;16m`  |
|      17      |           navy_blue<br>NavyBlue          | `#00005f` | rgb(0,0,95)      | hsl(240,100%,18%) |  `\e[38;5;17m`  |
|      18      |           dark_blue<br>DarkBlue          | `#000087` | rgb(0,0,135)     | hsl(240,100%,26%) |  `\e[38;5;18m`  |
|      19      |             blue_3a<br>Blue3             | `#0000af` | rgb(0,0,175)     | hsl(240,100%,34%) |  `\e[38;5;19m`  |
|      20      |             blue_3b<br>Blue3             | `#0000d7` | rgb(0,0,215)     | hsl(240,100%,42%) |  `\e[38;5;20m`  |
|      21      |              blue_1<br>Blue1             | `#0000ff` | rgb(0,0,255)     | hsl(240,100%,50%) |  `\e[38;5;21m`  |
|      22      |          dark_green<br>DarkGreen         | `#005f00` | rgb(0,95,0)      | hsl(120,100%,18%) |  `\e[38;5;22m`  |
|      23      |     deep_sky_blue_4a<br>DeepSkyBlue4     | `#005f5f` | rgb(0,95,95)     | hsl(180,100%,18%) |  `\e[38;5;23m`  |
|      24      |     deep_sky_blue_4b<br>DeepSkyBlue4     | `#005f87` | rgb(0,95,135)    | hsl(97,100%,26%)  |  `\e[38;5;24m`  |
|      25      |     deep_sky_blue_4c<br>DeepSkyBlue4     | `#005faf` | rgb(0,95,175)    | hsl(07,100%,34%)  |  `\e[38;5;25m`  |
|      26      |       dodger_blue_3<br>DodgerBlue3       | `#005fd7` | rgb(0,95,215)    | hsl(13,100%,42%)  |  `\e[38;5;26m`  |
|      27      |       dodger_blue_2<br>DodgerBlue2       | `#005fff` | rgb(0,95,255)    | hsl(17,100%,50%)  |  `\e[38;5;27m`  |
|      28      |             green_4<br>Green4            | `#008700` | rgb(0,135,0)     | hsl(120,100%,26%) |  `\e[38;5;28m`  |
|      29      |      spring_green_4<br>SpringGreen4      | `#00875f` | rgb(0,135,95)    | hsl(62,100%,26%)  |  `\e[38;5;29m`  |
|      30      |         turquoise_4<br>Turquoise4        | `#008787` | rgb(0,135,135)   | hsl(180,100%,26%) |  `\e[38;5;30m`  |
|      31      |     deep_sky_blue_3a<br>DeepSkyBlue3     | `#0087af` | rgb(0,135,175)   | hsl(93,100%,34%)  |  `\e[38;5;31m`  |
|      32      |     deep_sky_blue_3b<br>DeepSkyBlue3     | `#0087d7` | rgb(0,135,215)   | hsl(02,100%,42%)  |  `\e[38;5;32m`  |
|      33      |       dodger_blue_1<br>DodgerBlue1       | `#0087ff` | rgb(0,135,255)   | hsl(08,100%,50%)  |  `\e[38;5;33m`  |
|      34      |            green_3a<br>Green3            | `#00af00` | rgb(0,175,0)     | hsl(120,100%,34%) |  `\e[38;5;34m`  |
|      35      |      spring_green_3a<br>SpringGreen3     | `#00af5f` | rgb(0,175,95)    | hsl(52,100%,34%)  |  `\e[38;5;35m`  |
|      36      |           dark_cyan<br>DarkCyan          | `#00af87` | rgb(0,175,135)   | hsl(66,100%,34%)  |  `\e[38;5;36m`  |
|      37      |     light_sea_green<br>LightSeaGreen     | `#00afaf` | rgb(0,175,175)   | hsl(180,100%,34%) |  `\e[38;5;37m`  |
|      38      |      deep_sky_blue_2<br>DeepSkyBlue2     | `#00afd7` | rgb(0,175,215)   | hsl(91,100%,42%)  |  `\e[38;5;38m`  |
|      39      |      deep_sky_blue_1<br>DeepSkyBlue1     | `#00afff` | rgb(0,175,255)   | hsl(98,100%,50%)  |  `\e[38;5;39m`  |
|      40      |            green_3b<br>Green3            | `#00d700` | rgb(0,215,0)     | hsl(120,100%,42%) |  `\e[38;5;40m`  |
|      41      |      spring_green_3b<br>SpringGreen3     | `#00d75f` | rgb(0,215,95)    | hsl(46,100%,42%)  |  `\e[38;5;41m`  |
|      42      |      spring_green_2a<br>SpringGreen2     | `#00d787` | rgb(0,215,135)   | hsl(57,100%,42%)  |  `\e[38;5;42m`  |
|      43      |              cyan_3<br>Cyan3             | `#00d7af` | rgb(0,215,175)   | hsl(68,100%,42%)  |  `\e[38;5;43m`  |
|      44      |      dark_turquoise<br>DarkTurquoise     | `#00d7d7` | rgb(0,215,215)   | hsl(180,100%,42%) |  `\e[38;5;44m`  |
|      45      |         turquoise_2<br>Turquoise2        | `#00d7ff` | rgb(0,215,255)   | hsl(89,100%,50%)  |  `\e[38;5;45m`  |
|      46      |             green_1<br>Green1            | `#00ff00` | rgb(0,255,0)     | hsl(120,100%,50%) |  `\e[38;5;46m`  |
|      47      |      spring_green_2b<br>SpringGreen2     | `#00ff5f` | rgb(0,255,95)    | hsl(42,100%,50%)  |  `\e[38;5;47m`  |
|      48      |      spring_green_1<br>SpringGreen1      | `#00ff87` | rgb(0,255,135)   | hsl(51,100%,50%)  |  `\e[38;5;48m`  |
|      49      | medium_spring_green<br>MediumSpringGreen | `#00ffaf` | rgb(0,255,175)   | hsl(61,100%,50%)  |  `\e[38;5;49m`  |
|      50      |              cyan_2<br>Cyan2             | `#00ffd7` | rgb(0,255,215)   | hsl(70,100%,50%)  |  `\e[38;5;50m`  |
|      51      |              cyan_1<br>Cyan1             | `#00ffff` | rgb(0,255,255)   | hsl(180,100%,50%) |  `\e[38;5;51m`  |
|      52      |           dark_red_1<br>DarkRed          | `#5f0000` | rgb(95,0,0)      | hsl(0,100%,18%)   |  `\e[38;5;52m`  |
|      53      |         deep_pink_4a<br>DeepPink4        | `#5f005f` | rgb(95,0,95)     | hsl(300,100%,18%) |  `\e[38;5;53m`  |
|      54      |           purple_4a<br>Purple4           | `#5f0087` | rgb(95,0,135)    | hsl(82,100%,26%)  |  `\e[38;5;54m`  |
|      55      |           purple_4b<br>Purple4           | `#5f00af` | rgb(95,0,175)    | hsl(72,100%,34%)  |  `\e[38;5;55m`  |
|      56      |            purple_3<br>Purple3           | `#5f00d7` | rgb(95,0,215)    | hsl(66,100%,42%)  |  `\e[38;5;56m`  |
|      57      |         blue_violet<br>BlueViolet        | `#5f00ff` | rgb(95,0,255)    | hsl(62,100%,50%)  |  `\e[38;5;57m`  |
|      58      |           orange_4a<br>Orange4           | `#5f5f00` | rgb(95,95,0)     | hsl(60,100%,18%)  |  `\e[38;5;58m`  |
|      59      |             grey_37<br>Grey37            | `#5f5f5f` | rgb(95,95,95)    | hsl(0,0%,37%)     |  `\e[38;5;59m`  |
|      60      |     medium_purple_4<br>MediumPurple4     | `#5f5f87` | rgb(95,95,135)   | hsl(240,17%,45%)  |  `\e[38;5;60m`  |
|      61      |        slate_blue_3a<br>SlateBlue3       | `#5f5faf` | rgb(95,95,175)   | hsl(240,33%,52%)  |  `\e[38;5;61m`  |
|      62      |        slate_blue_3b<br>SlateBlue3       | `#5f5fd7` | rgb(95,95,215)   | hsl(240,60%,60%)  |  `\e[38;5;62m`  |
|      63      |        royal_blue_1<br>RoyalBlue1        | `#5f5fff` | rgb(95,95,255)   | hsl(240,100%,68%) |  `\e[38;5;63m`  |
|      64      |        chartreuse_4<br>Chartreuse4       | `#5f8700` | rgb(95,135,0)    | hsl(7,100%,26%)   |  `\e[38;5;64m`  |
|      65      |    dark_sea_green_4a<br>DarkSeaGreen4    | `#5f875f` | rgb(95,135,95)   | hsl(120,17%,45%)  |  `\e[38;5;65m`  |
|      66      |    pale_turquoise_4<br>PaleTurquoise4    | `#5f8787` | rgb(95,135,135)  | hsl(180,17%,45%)  |  `\e[38;5;66m`  |
|      67      |          steel_blue<br>SteelBlue         | `#5f87af` | rgb(95,135,175)  | hsl(210,33%,52%)  |  `\e[38;5;67m`  |
|      68      |        steel_blue_3<br>SteelBlue3        | `#5f87d7` | rgb(95,135,215)  | hsl(220,60%,60%)  |  `\e[38;5;68m`  |
|      69      |     cornflower_blue<br>CornflowerBlue    | `#5f87ff` | rgb(95,135,255)  | hsl(225,100%,68%) |  `\e[38;5;69m`  |
|      70      |       chartreuse_3a<br>Chartreuse3       | `#5faf00` | rgb(95,175,0)    | hsl(7,100%,34%)   |  `\e[38;5;70m`  |
|      71      |    dark_sea_green_4b<br>DarkSeaGreen4    | `#5faf5f` | rgb(95,175,95)   | hsl(120,33%,52%)  |  `\e[38;5;71m`  |
|      72      |         cadet_blue_2<br>CadetBlue        | `#5faf87` | rgb(95,175,135)  | hsl(150,33%,52%)  |  `\e[38;5;72m`  |
|      73      |         cadet_blue_1<br>CadetBlue        | `#5fafaf` | rgb(95,175,175)  | hsl(180,33%,52%)  |  `\e[38;5;73m`  |
|      74      |          sky_blue_3<br>SkyBlue3          | `#5fafd7` | rgb(95,175,215)  | hsl(200,60%,60%)  |  `\e[38;5;74m`  |
|      75      |        steel_blue_1a<br>SteelBlue1       | `#5fafff` | rgb(95,175,255)  | hsl(210,100%,68%) |  `\e[38;5;75m`  |
|      76      |       chartreuse_3b<br>Chartreuse3       | `#5fd700` | rgb(95,215,0)    | hsl(3,100%,42%)   |  `\e[38;5;76m`  |
|      77      |        pale_green_3a<br>PaleGreen3       | `#5fd75f` | rgb(95,215,95)   | hsl(120,60%,60%)  |  `\e[38;5;77m`  |
|      78      |         sea_green_3<br>SeaGreen3         | `#5fd787` | rgb(95,215,135)  | hsl(140,60%,60%)  |  `\e[38;5;78m`  |
|      79      |        aquamarine_3<br>Aquamarine3       | `#5fd7af` | rgb(95,215,175)  | hsl(160,60%,60%)  |  `\e[38;5;79m`  |
|      80      |    medium_turquoise<br>MediumTurquoise   | `#5fd7d7` | rgb(95,215,215)  | hsl(180,60%,60%)  |  `\e[38;5;80m`  |
|      81      |        steel_blue_1b<br>SteelBlue1       | `#5fd7ff` | rgb(95,215,255)  | hsl(195,100%,68%) |  `\e[38;5;81m`  |
|      82      |       chartreuse_2a<br>Chartreuse2       | `#5fff00` | rgb(95,255,0)    | hsl(7,100%,50%)   |  `\e[38;5;82m`  |
|      83      |         sea_green_2<br>SeaGreen2         | `#5fff5f` | rgb(95,255,95)   | hsl(120,100%,68%) |  `\e[38;5;83m`  |
|      84      |         sea_green_1a<br>SeaGreen1        | `#5fff87` | rgb(95,255,135)  | hsl(135,100%,68%) |  `\e[38;5;84m`  |
|      85      |         sea_green_1b<br>SeaGreen1        | `#5fffaf` | rgb(95,255,175)  | hsl(150,100%,68%) |  `\e[38;5;85m`  |
|      86      |       aquamarine_1a<br>Aquamarine1       | `#5fffd7` | rgb(95,255,215)  | hsl(165,100%,68%) |  `\e[38;5;86m`  |
|      87      |    dark_slate_gray_2<br>DarkSlateGray2   | `#5fffff` | rgb(95,255,255)  | hsl(180,100%,68%) |  `\e[38;5;87m`  |
|      88      |           dark_red_2<br>DarkRed          | `#870000` | rgb(135,0,0)     | hsl(0,100%,26%)   |  `\e[38;5;88m`  |
|      89      |         deep_pink_4b<br>DeepPink4        | `#87005f` | rgb(135,0,95)    | hsl(17,100%,26%)  |  `\e[38;5;89m`  |
|      90      |       dark_magenta_1<br>DarkMagenta      | `#870087` | rgb(135,0,135)   | hsl(300,100%,26%) |  `\e[38;5;90m`  |
|      91      |       dark_magenta_2<br>DarkMagenta      | `#8700af` | rgb(135,0,175)   | hsl(86,100%,34%)  |  `\e[38;5;91m`  |
|      92      |       dark_violet_1a<br>DarkViolet       | `#8700d7` | rgb(135,0,215)   | hsl(77,100%,42%)  |  `\e[38;5;92m`  |
|      93      |            purple_1a<br>Purple           | `#8700ff` | rgb(135,0,255)   | hsl(71,100%,50%)  |  `\e[38;5;93m`  |
|      94      |           orange_4b<br>Orange4           | `#875f00` | rgb(135,95,0)    | hsl(2,100%,26%)   |  `\e[38;5;94m`  |
|      95      |        light_pink_4<br>LightPink4        | `#875f5f` | rgb(135,95,95)   | hsl(0,17%,45%)    |  `\e[38;5;95m`  |
|      96      |              plum_4<br>Plum4             | `#875f87` | rgb(135,95,135)  | hsl(300,17%,45%)  |  `\e[38;5;96m`  |
|      97      |     medium_purple_3a<br>MediumPurple3    | `#875faf` | rgb(135,95,175)  | hsl(270,33%,52%)  |  `\e[38;5;97m`  |
|      98      |     medium_purple_3b<br>MediumPurple3    | `#875fd7` | rgb(135,95,215)  | hsl(260,60%,60%)  |  `\e[38;5;98m`  |
|      99      |        slate_blue_1<br>SlateBlue1        | `#875fff` | rgb(135,95,255)  | hsl(255,100%,68%) |  `\e[38;5;99m`  |
|      100     |           yellow_4a<br>Yellow4           | `#878700` | rgb(135,135,0)   | hsl(60,100%,26%)  |  `\e[38;5;100m` |
|      101     |             wheat_4<br>Wheat4            | `#87875f` | rgb(135,135,95)  | hsl(60,17%,45%)   |  `\e[38;5;101m` |
|      102     |             grey_53<br>Grey53            | `#878787` | rgb(135,135,135) | hsl(0,0%,52%)     |  `\e[38;5;102m` |
|      103     |    light_slate_grey<br>LightSlateGrey    | `#8787af` | rgb(135,135,175) | hsl(240,20%,60%)  |  `\e[38;5;103m` |
|      104     |       medium_purple<br>MediumPurple      | `#8787d7` | rgb(135,135,215) | hsl(240,50%,68%)  |  `\e[38;5;104m` |
|      105     |    light_slate_blue<br>LightSlateBlue    | `#8787ff` | rgb(135,135,255) | hsl(240,100%,76%) |  `\e[38;5;105m` |
|      106     |           yellow_4b<br>Yellow4           | `#87af00` | rgb(135,175,0)   | hsl(3,100%,34%)   |  `\e[38;5;106m` |
|      107     |  dark_olive_green_3a<br>DarkOliveGreen3  | `#87af5f` | rgb(135,175,95)  | hsl(90,33%,52%)   |  `\e[38;5;107m` |
|      108     |      dark_green_sea<br>DarkSeaGreen      | `#87af87` | rgb(135,175,135) | hsl(120,20%,60%)  |  `\e[38;5;108m` |
|      109     |    light_sky_blue_3a<br>LightSkyBlue3    | `#87afaf` | rgb(135,175,175) | hsl(180,20%,60%)  |  `\e[38;5;109m` |
|      110     |    light_sky_blue_3b<br>LightSkyBlue3    | `#87afd7` | rgb(135,175,215) | hsl(210,50%,68%)  |  `\e[38;5;110m` |
|      111     |          sky_blue_2<br>SkyBlue2          | `#87afff` | rgb(135,175,255) | hsl(220,100%,76%) |  `\e[38;5;111m` |
|      112     |       chartreuse_2b<br>Chartreuse2       | `#87d700` | rgb(135,215,0)   | hsl(2,100%,42%)   |  `\e[38;5;112m` |
|      113     |  dark_olive_green_3b<br>DarkOliveGreen3  | `#87d75f` | rgb(135,215,95)  | hsl(100,60%,60%)  |  `\e[38;5;113m` |
|      114     |        pale_green_3b<br>PaleGreen3       | `#87d787` | rgb(135,215,135) | hsl(120,50%,68%)  |  `\e[38;5;114m` |
|      115     |    dark_sea_green_3a<br>DarkSeaGreen3    | `#87d7af` | rgb(135,215,175) | hsl(150,50%,68%)  |  `\e[38;5;115m` |
|      116     |    dark_slate_gray_3<br>DarkSlateGray3   | `#87d7d7` | rgb(135,215,215) | hsl(180,50%,68%)  |  `\e[38;5;116m` |
|      117     |          sky_blue_1<br>SkyBlue1          | `#87d7ff` | rgb(135,215,255) | hsl(200,100%,76%) |  `\e[38;5;117m` |
|      118     |        chartreuse_1<br>Chartreuse1       | `#87ff00` | rgb(135,255,0)   | hsl(8,100%,50%)   |  `\e[38;5;118m` |
|      119     |        light_green_2<br>LightGreen       | `#87ff5f` | rgb(135,255,95)  | hsl(105,100%,68%) |  `\e[38;5;119m` |
|      120     |        light_green_3<br>LightGreen       | `#87ff87` | rgb(135,255,135) | hsl(120,100%,76%) |  `\e[38;5;120m` |
|      121     |        pale_green_1a<br>PaleGreen1       | `#87ffaf` | rgb(135,255,175) | hsl(140,100%,76%) |  `\e[38;5;121m` |
|      122     |       aquamarine_1b<br>Aquamarine1       | `#87ffd7` | rgb(135,255,215) | hsl(160,100%,76%) |  `\e[38;5;122m` |
|      123     |    dark_slate_gray_1<br>DarkSlateGray1   | `#87ffff` | rgb(135,255,255) | hsl(180,100%,76%) |  `\e[38;5;123m` |
|      124     |              red_3a<br>Red3              | `#af0000` | rgb(175,0,0)     | hsl(0,100%,34%)   |  `\e[38;5;124m` |
|      125     |         deep_pink_4c<br>DeepPink4        | `#af005f` | rgb(175,0,95)    | hsl(27,100%,34%)  |  `\e[38;5;125m` |
|      126     |   medium_violet_red<br>MediumVioletRed   | `#af0087` | rgb(175,0,135)   | hsl(13,100%,34%)  |  `\e[38;5;126m` |
|      127     |          magenta_3a<br>Magenta3          | `#af00af` | rgb(175,0,175)   | hsl(300,100%,34%) |  `\e[38;5;127m` |
|      128     |       dark_violet_1b<br>DarkViolet       | `#af00d7` | rgb(175,0,215)   | hsl(88,100%,42%)  |  `\e[38;5;128m` |
|      129     |            purple_1b<br>Purple           | `#af00ff` | rgb(175,0,255)   | hsl(81,100%,50%)  |  `\e[38;5;129m` |
|      130     |       dark_orange_3a<br>DarkOrange3      | `#af5f00` | rgb(175,95,0)    | hsl(2,100%,34%)   |  `\e[38;5;130m` |
|      131     |        indian_red_1a<br>IndianRed        | `#af5f5f` | rgb(175,95,95)   | hsl(0,33%,52%)    |  `\e[38;5;131m` |
|      132     |          hot_pink_3a<br>HotPink3         | `#af5f87` | rgb(175,95,135)  | hsl(330,33%,52%)  |  `\e[38;5;132m` |
|      133     |     medium_orchid_3<br>MediumOrchid3     | `#af5faf` | rgb(175,95,175)  | hsl(300,33%,52%)  |  `\e[38;5;133m` |
|      134     |       medium_orchid<br>MediumOrchid      | `#af5fd7` | rgb(175,95,215)  | hsl(280,60%,60%)  |  `\e[38;5;134m` |
|      135     |     medium_purple_2a<br>MediumPurple2    | `#af5fff` | rgb(175,95,255)  | hsl(270,100%,68%) |  `\e[38;5;135m` |
|      136     |      dark_goldenrod<br>DarkGoldenrod     | `#af8700` | rgb(175,135,0)   | hsl(6,100%,34%)   |  `\e[38;5;136m` |
|      137     |      light_salmon_3a<br>LightSalmon3     | `#af875f` | rgb(175,135,95)  | hsl(30,33%,52%)   |  `\e[38;5;137m` |
|      138     |          rosy_brown<br>RosyBrown         | `#af8787` | rgb(175,135,135) | hsl(0,20%,60%)    |  `\e[38;5;138m` |
|      139     |             grey_63<br>Grey63            | `#af87af` | rgb(175,135,175) | hsl(300,20%,60%)  |  `\e[38;5;139m` |
|      140     |     medium_purple_2b<br>MediumPurple2    | `#af87d7` | rgb(175,135,215) | hsl(270,50%,68%)  |  `\e[38;5;140m` |
|      141     |     medium_purple_1<br>MediumPurple1     | `#af87ff` | rgb(175,135,255) | hsl(260,100%,76%) |  `\e[38;5;141m` |
|      142     |             gold_3a<br>Gold3             | `#afaf00` | rgb(175,175,0)   | hsl(60,100%,34%)  |  `\e[38;5;142m` |
|      143     |          dark_khaki<br>DarkKhaki         | `#afaf5f` | rgb(175,175,95)  | hsl(60,33%,52%)   |  `\e[38;5;143m` |
|      144     |      navajo_white_3<br>NavajoWhite3      | `#afaf87` | rgb(175,175,135) | hsl(60,20%,60%)   |  `\e[38;5;144m` |
|      145     |             grey_69<br>Grey69            | `#afafaf` | rgb(175,175,175) | hsl(0,0%,68%)     |  `\e[38;5;145m` |
|      146     |   light_steel_blue_3<br>LightSteelBlue3  | `#afafd7` | rgb(175,175,215) | hsl(240,33%,76%)  |  `\e[38;5;146m` |
|      147     |    light_steel_blue<br>LightSteelBlue    | `#afafff` | rgb(175,175,255) | hsl(240,100%,84%) |  `\e[38;5;147m` |
|      148     |           yellow_3a<br>Yellow3           | `#afd700` | rgb(175,215,0)   | hsl(1,100%,42%)   |  `\e[38;5;148m` |
|      149     |   dark_olive_green_3<br>DarkOliveGreen3  | `#afd75f` | rgb(175,215,95)  | hsl(80,60%,60%)   |  `\e[38;5;149m` |
|      150     |    dark_sea_green_3b<br>DarkSeaGreen3    | `#afd787` | rgb(175,215,135) | hsl(90,50%,68%)   |  `\e[38;5;150m` |
|      151     |     dark_sea_green_2<br>DarkSeaGreen2    | `#afd7af` | rgb(175,215,175) | hsl(120,33%,76%)  |  `\e[38;5;151m` |
|      152     |        light_cyan_3<br>LightCyan3        | `#afd7d7` | rgb(175,215,215) | hsl(180,33%,76%)  |  `\e[38;5;152m` |
|      153     |     light_sky_blue_1<br>LightSkyBlue1    | `#afd7ff` | rgb(175,215,255) | hsl(210,100%,84%) |  `\e[38;5;153m` |
|      154     |        green_yellow<br>GreenYellow       | `#afff00` | rgb(175,255,0)   | hsl(8,100%,50%)   |  `\e[38;5;154m` |
|      155     |   dark_olive_green_2<br>DarkOliveGreen2  | `#afff5f` | rgb(175,255,95)  | hsl(90,100%,68%)  |  `\e[38;5;155m` |
|      156     |        pale_green_1b<br>PaleGreen1       | `#afff87` | rgb(175,255,135) | hsl(100,100%,76%) |  `\e[38;5;156m` |
|      157     |    dark_sea_green_5b<br>DarkSeaGreen2    | `#afffaf` | rgb(175,255,175) | hsl(120,100%,84%) |  `\e[38;5;157m` |
|      158     |    dark_sea_green_5a<br>DarkSeaGreen1    | `#afffd7` | rgb(175,255,215) | hsl(150,100%,84%) |  `\e[38;5;158m` |
|      159     |    pale_turquoise_1<br>PaleTurquoise1    | `#afffff` | rgb(175,255,255) | hsl(180,100%,84%) |  `\e[38;5;159m` |
|      160     |              red_3b<br>Red3              | `#d70000` | rgb(215,0,0)     | hsl(0,100%,42%)   |  `\e[38;5;160m` |
|      161     |         deep_pink_3a<br>DeepPink3        | `#d7005f` | rgb(215,0,95)    | hsl(33,100%,42%)  |  `\e[38;5;161m` |
|      162     |         deep_pink_3b<br>DeepPink3        | `#d70087` | rgb(215,0,135)   | hsl(22,100%,42%)  |  `\e[38;5;162m` |
|      163     |          magenta_3b<br>Magenta3          | `#d700af` | rgb(215,0,175)   | hsl(11,100%,42%)  |  `\e[38;5;163m` |
|      164     |          magenta_3c<br>Magenta3          | `#d700d7` | rgb(215,0,215)   | hsl(300,100%,42%) |  `\e[38;5;164m` |
|      165     |          magenta_2a<br>Magenta2          | `#d700ff` | rgb(215,0,255)   | hsl(90,100%,50%)  |  `\e[38;5;165m` |
|      166     |       dark_orange_3b<br>DarkOrange3      | `#d75f00` | rgb(215,95,0)    | hsl(6,100%,42%)   |  `\e[38;5;166m` |
|      167     |        indian_red_1b<br>IndianRed        | `#d75f5f` | rgb(215,95,95)   | hsl(0,60%,60%)    |  `\e[38;5;167m` |
|      168     |          hot_pink_3b<br>HotPink3         | `#d75f87` | rgb(215,95,135)  | hsl(340,60%,60%)  |  `\e[38;5;168m` |
|      169     |          hot_pink_2<br>HotPink2          | `#d75faf` | rgb(215,95,175)  | hsl(320,60%,60%)  |  `\e[38;5;169m` |
|      170     |             orchid<br>Orchid             | `#d75fd7` | rgb(215,95,215)  | hsl(300,60%,60%)  |  `\e[38;5;170m` |
|      171     |     medium_orchid_1a<br>MediumOrchid1    | `#d75fff` | rgb(215,95,255)  | hsl(285,100%,68%) |  `\e[38;5;171m` |
|      172     |            orange_3<br>Orange3           | `#d78700` | rgb(215,135,0)   | hsl(7,100%,42%)   |  `\e[38;5;172m` |
|      173     |      light_salmon_3b<br>LightSalmon3     | `#d7875f` | rgb(215,135,95)  | hsl(20,60%,60%)   |  `\e[38;5;173m` |
|      174     |        light_pink_3<br>LightPink3        | `#d78787` | rgb(215,135,135) | hsl(0,50%,68%)    |  `\e[38;5;174m` |
|      175     |              pink_3<br>Pink3             | `#d787af` | rgb(215,135,175) | hsl(330,50%,68%)  |  `\e[38;5;175m` |
|      176     |              plum_3<br>Plum3             | `#d787d7` | rgb(215,135,215) | hsl(300,50%,68%)  |  `\e[38;5;176m` |
|      177     |             violet<br>Violet             | `#d787ff` | rgb(215,135,255) | hsl(280,100%,76%) |  `\e[38;5;177m` |
|      178     |             gold_3b<br>Gold3             | `#d7af00` | rgb(215,175,0)   | hsl(8,100%,42%)   |  `\e[38;5;178m` |
|      179     |   light_goldenrod_3<br>LightGoldenrod3   | `#d7af5f` | rgb(215,175,95)  | hsl(40,60%,60%)   |  `\e[38;5;179m` |
|      180     |                tan<br>Tan                | `#d7af87` | rgb(215,175,135) | hsl(30,50%,68%)   |  `\e[38;5;180m` |
|      181     |        misty_rose_3<br>MistyRose3        | `#d7afaf` | rgb(215,175,175) | hsl(0,33%,76%)    |  `\e[38;5;181m` |
|      182     |           thistle_3<br>Thistle3          | `#d7afd7` | rgb(215,175,215) | hsl(300,33%,76%)  |  `\e[38;5;182m` |
|      183     |              plum_2<br>Plum2             | `#d7afff` | rgb(215,175,255) | hsl(270,100%,84%) |  `\e[38;5;183m` |
|      184     |           yellow_3b<br>Yellow3           | `#d7d700` | rgb(215,215,0)   | hsl(60,100%,42%)  |  `\e[38;5;184m` |
|      185     |             khaki_3<br>Khaki3            | `#d7d75f` | rgb(215,215,95)  | hsl(60,60%,60%)   |  `\e[38;5;185m` |
|      186     |   light_goldenrod_2a<br>LightGoldenrod2  | `#d7d787` | rgb(215,215,135) | hsl(60,50%,68%)   |  `\e[38;5;186m` |
|      187     |      light_yellow_3<br>LightYellow3      | `#d7d7af` | rgb(215,215,175) | hsl(60,33%,76%)   |  `\e[38;5;187m` |
|      188     |             grey_84<br>Grey84            | `#d7d7d7` | rgb(215,215,215) | hsl(0,0%,84%)     |  `\e[38;5;188m` |
|      189     |   light_steel_blue_1<br>LightSteelBlue1  | `#d7d7ff` | rgb(215,215,255) | hsl(240,100%,92%) |  `\e[38;5;189m` |
|      190     |            yellow_2<br>Yellow2           | `#d7ff00` | rgb(215,255,0)   | hsl(9,100%,50%)   |  `\e[38;5;190m` |
|      191     |  dark_olive_green_1a<br>DarkOliveGreen1  | `#d7ff5f` | rgb(215,255,95)  | hsl(75,100%,68%)  |  `\e[38;5;191m` |
|      192     |  dark_olive_green_1b<br>DarkOliveGreen1  | `#d7ff87` | rgb(215,255,135) | hsl(80,100%,76%)  |  `\e[38;5;192m` |
|      193     |     dark_sea_green_1<br>DarkSeaGreen1    | `#d7ffaf` | rgb(215,255,175) | hsl(90,100%,84%)  |  `\e[38;5;193m` |
|      194     |          honeydew_2<br>Honeydew2         | `#d7ffd7` | rgb(215,255,215) | hsl(120,100%,92%) |  `\e[38;5;194m` |
|      195     |        light_cyan_1<br>LightCyan1        | `#d7ffff` | rgb(215,255,255) | hsl(180,100%,92%) |  `\e[38;5;195m` |
|      196     |               red_1<br>Red1              | `#ff0000` | rgb(255,0,0)     | hsl(0,100%,50%)   |  `\e[38;5;196m` |
|      197     |         deep_pink_2<br>DeepPink2         | `#ff005f` | rgb(255,0,95)    | hsl(37,100%,50%)  |  `\e[38;5;197m` |
|      198     |         deep_pink_1a<br>DeepPink1        | `#ff0087` | rgb(255,0,135)   | hsl(28,100%,50%)  |  `\e[38;5;198m` |
|      199     |         deep_pink_1b<br>DeepPink1        | `#ff00af` | rgb(255,0,175)   | hsl(18,100%,50%)  |  `\e[38;5;199m` |
|      200     |          magenta_2b<br>Magenta2          | `#ff00d7` | rgb(255,0,215)   | hsl(09,100%,50%)  |  `\e[38;5;200m` |
|      201     |           magenta_1<br>Magenta1          | `#ff00ff` | rgb(255,0,255)   | hsl(300,100%,50%) |  `\e[38;5;201m` |
|      202     |        orange_red_1<br>OrangeRed1        | `#ff5f00` | rgb(255,95,0)    | hsl(2,100%,50%)   |  `\e[38;5;202m` |
|      203     |        indian_red_1c<br>IndianRed1       | `#ff5f5f` | rgb(255,95,95)   | hsl(0,100%,68%)   |  `\e[38;5;203m` |
|      204     |        indian_red_1d<br>IndianRed1       | `#ff5f87` | rgb(255,95,135)  | hsl(345,100%,68%) |  `\e[38;5;204m` |
|      205     |          hot_pink_1a<br>HotPink          | `#ff5faf` | rgb(255,95,175)  | hsl(330,100%,68%) |  `\e[38;5;205m` |
|      206     |          hot_pink_1b<br>HotPink          | `#ff5fd7` | rgb(255,95,215)  | hsl(315,100%,68%) |  `\e[38;5;206m` |
|      207     |     medium_orchid_1b<br>MediumOrchid1    | `#ff5fff` | rgb(255,95,255)  | hsl(300,100%,68%) |  `\e[38;5;207m` |
|      208     |         dark_orange<br>DarkOrange        | `#ff8700` | rgb(255,135,0)   | hsl(1,100%,50%)   |  `\e[38;5;208m` |
|      209     |            salmon_1<br>Salmon1           | `#ff875f` | rgb(255,135,95)  | hsl(15,100%,68%)  |  `\e[38;5;209m` |
|      210     |         light_coral<br>LightCoral        | `#ff8787` | rgb(255,135,135) | hsl(0,100%,76%)   |  `\e[38;5;210m` |
|      211     |    pale_violet_red_1<br>PaleVioletRed1   | `#ff87af` | rgb(255,135,175) | hsl(340,100%,76%) |  `\e[38;5;211m` |
|      212     |            orchid_2<br>Orchid2           | `#ff87d7` | rgb(255,135,215) | hsl(320,100%,76%) |  `\e[38;5;212m` |
|      213     |            orchid_1<br>Orchid1           | `#ff87ff` | rgb(255,135,255) | hsl(300,100%,76%) |  `\e[38;5;213m` |
|      214     |            orange_1<br>Orange1           | `#ffaf00` | rgb(255,175,0)   | hsl(1,100%,50%)   |  `\e[38;5;214m` |
|      215     |         sandy_brown<br>SandyBrown        | `#ffaf5f` | rgb(255,175,95)  | hsl(30,100%,68%)  |  `\e[38;5;215m` |
|      216     |      light_salmon_1<br>LightSalmon1      | `#ffaf87` | rgb(255,175,135) | hsl(20,100%,76%)  |  `\e[38;5;216m` |
|      217     |        light_pink_1<br>LightPink1        | `#ffafaf` | rgb(255,175,175) | hsl(0,100%,84%)   |  `\e[38;5;217m` |
|      218     |              pink_1<br>Pink1             | `#ffafd7` | rgb(255,175,215) | hsl(330,100%,84%) |  `\e[38;5;218m` |
|      219     |              plum_1<br>Plum1             | `#ffafff` | rgb(255,175,255) | hsl(300,100%,84%) |  `\e[38;5;219m` |
|      220     |              gold_1<br>Gold1             | `#ffd700` | rgb(255,215,0)   | hsl(0,100%,50%)   |  `\e[38;5;220m` |
|      221     |   light_goldenrod_2b<br>LightGoldenrod2  | `#ffd75f` | rgb(255,215,95)  | hsl(45,100%,68%)  |  `\e[38;5;221m` |
|      222     |   light_goldenrod_2c<br>LightGoldenrod2  | `#ffd787` | rgb(255,215,135) | hsl(40,100%,76%)  |  `\e[38;5;222m` |
|      223     |      navajo_white_1<br>NavajoWhite1      | `#ffd7af` | rgb(255,215,175) | hsl(30,100%,84%)  |  `\e[38;5;223m` |
|      224     |         misty_rose1<br>MistyRose1        | `#ffd7d7` | rgb(255,215,215) | hsl(0,100%,92%)   |  `\e[38;5;224m` |
|      225     |           thistle_1<br>Thistle1          | `#ffd7ff` | rgb(255,215,255) | hsl(300,100%,92%) |  `\e[38;5;225m` |
|      226     |            yellow_1<br>Yellow1           | `#ffff00` | rgb(255,255,0)   | hsl(60,100%,50%)  |  `\e[38;5;226m` |
|      227     |   light_goldenrod_1<br>LightGoldenrod1   | `#ffff5f` | rgb(255,255,95)  | hsl(60,100%,68%)  |  `\e[38;5;227m` |
|      228     |             khaki_1<br>Khaki1            | `#ffff87` | rgb(255,255,135) | hsl(60,100%,76%)  |  `\e[38;5;228m` |
|      229     |             wheat_1<br>Wheat1            | `#ffffaf` | rgb(255,255,175) | hsl(60,100%,84%)  |  `\e[38;5;229m` |
|      230     |          cornsilk_1<br>Cornsilk1         | `#ffffd7` | rgb(255,255,215) | hsl(60,100%,92%)  |  `\e[38;5;230m` |
|      231     |            grey_100<br>Grey100           | `#ffffff` | rgb(255,255,255) | hsl(0,0%,100%)    |  `\e[38;5;231m` |
|      232     |              grey_3<br>Grey3             | `#080808` | rgb(8,8,8)       | hsl(0,0%,3%)      |  `\e[38;5;232m` |
|      233     |              grey_7<br>Grey7             | `#121212` | rgb(18,18,18)    | hsl(0,0%,7%)      |  `\e[38;5;233m` |
|      234     |             grey_11<br>Grey11            | `#1c1c1c` | rgb(28,28,28)    | hsl(0,0%,10%)     |  `\e[38;5;234m` |
|      235     |             grey_15<br>Grey15            | `#262626` | rgb(38,38,38)    | hsl(0,0%,14%)     |  `\e[38;5;235m` |
|      236     |             grey_19<br>Grey19            | `#303030` | rgb(48,48,48)    | hsl(0,0%,18%)     |  `\e[38;5;236m` |
|      237     |             grey_23<br>Grey23            | `#3a3a3a` | rgb(58,58,58)    | hsl(0,0%,22%)     |  `\e[38;5;237m` |
|      238     |             grey_27<br>Grey27            | `#444444` | rgb(68,68,68)    | hsl(0,0%,26%)     |  `\e[38;5;238m` |
|      239     |             grey_30<br>Grey30            | `#4e4e4e` | rgb(78,78,78)    | hsl(0,0%,30%)     |  `\e[38;5;239m` |
|      240     |             grey_35<br>Grey35            | `#585858` | rgb(88,88,88)    | hsl(0,0%,34%)     |  `\e[38;5;240m` |
|      241     |             grey_39<br>Grey39            | `#626262` | rgb(98,98,98)    | hsl(0,0%,37%)     |  `\e[38;5;241m` |
|      242     |             grey_42<br>Grey42            | `#6c6c6c` | rgb(108,108,108) | hsl(0,0%,40%)     |  `\e[38;5;242m` |
|      243     |             grey_46<br>Grey46            | `#767676` | rgb(118,118,118) | hsl(0,0%,46%)     |  `\e[38;5;243m` |
|      244     |             grey_50<br>Grey50            | `#808080` | rgb(128,128,128) | hsl(0,0%,50%)     |  `\e[38;5;244m` |
|      245     |             grey_54<br>Grey54            | `#8a8a8a` | rgb(138,138,138) | hsl(0,0%,54%)     |  `\e[38;5;245m` |
|      246     |             grey_58<br>Grey58            | `#949494` | rgb(148,148,148) | hsl(0,0%,58%)     |  `\e[38;5;246m` |
|      247     |             grey_62<br>Grey62            | `#9e9e9e` | rgb(158,158,158) | hsl(0,0%,61%)     |  `\e[38;5;247m` |
|      248     |             grey_66<br>Grey66            | `#a8a8a8` | rgb(168,168,168) | hsl(0,0%,65%)     |  `\e[38;5;248m` |
|      249     |             grey_70<br>Grey70            | `#b2b2b2` | rgb(178,178,178) | hsl(0,0%,69%)     |  `\e[38;5;249m` |
|      250     |             grey_74<br>Grey74            | `#bcbcbc` | rgb(188,188,188) | hsl(0,0%,73%)     |  `\e[38;5;250m` |
|      251     |             grey_78<br>Grey78            | `#c6c6c6` | rgb(198,198,198) | hsl(0,0%,77%)     |  `\e[38;5;251m` |
|      252     |             grey_82<br>Grey82            | `#d0d0d0` | rgb(208,208,208) | hsl(0,0%,81%)     |  `\e[38;5;252m` |
|      253     |             grey_85<br>Grey85            | `#dadada` | rgb(218,218,218) | hsl(0,0%,85%)     |  `\e[38;5;253m` |
|      254     |             grey_89<br>Grey89            | `#e4e4e4` | rgb(228,228,228) | hsl(0,0%,89%)     |  `\e[38;5;254m` |
|      255     |             grey_93<br>Grey93            | `#eeeeee` | rgb(238,238,238) | hsl(0,0%,93%)     |  `\e[38;5;255m` |


## man page colors

{% hint style='tip' %}
> references:
> - [Bug 666587 - Some man pages include partial escape codes in output when piped or redirected](https://bugzilla.redhat.com/show_bug.cgi?id=666587)
> - [Bug 81003 - xman displays terminal control sequences](https://bugzilla.redhat.com/show_bug.cgi?id=81003)
> - [How to install man pages on CentOS Linux 6/7/8](https://www.cyberciti.biz/faq/how-to-install-man-pages-on-a-centos-linux-6-7/)
> - [Using Color with less](https://www.howtogeek.com/683134/how-to-display-man-pages-in-color-on-linux/)
> - [Colors in Man Pages](https://unix.stackexchange.com/a/147)
> - [How to View Colored Man Pages in Linux?](https://www.geeksforgeeks.org/how-to-view-colored-man-pages-in-linux/)
> - [Documentation on LESS_TERMCAP_* variables?](https://unix.stackexchange.com/a/108840)
{% endhint %}

### settings
- printf
  ```bash
  # The color of man page
  export LESS_TERMCAP_mb=$(printf "\\e[1;31m")         # begin blinding
  export LESS_TERMCAP_md=$(printf "\\e[1;31m")         # begin bold
  export LESS_TERMCAP_me=$(printf "\\e[0m")            # end mode
  export LESS_TERMCAP_se=$(printf "\\e[0m")            # end stadout-mode
  export LESS_TERMCAP_so=$(printf "\\e[1;44;33m")      # begin stadout-mode - info box
  export LESS_TERMCAP_so=$(printf "\\e[1;33m")      # begin stadout-mode - info box
  export LESS_TERMCAP_ue=$(printf "\\e[0m")            # end underline
  export LESS_TERMCAP_us=$(printf "\\e[1;32m")         # begin underline
  export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal
  export LESS='-eirMXR'
  export SYSTEMD_LESS=FRXMK
  export MANPAGER='less -s -M +Gg'
  ```

- tput
  ```bash
  export LESS_TERMCAP_mb=$(tput bold; tput setaf 2) # green
  export LESS_TERMCAP_md=$(tput bold; tput setaf 6) # cyan
  export LESS_TERMCAP_me=$(tput sgr0)
  export LESS_TERMCAP_so=$(tput bold; tput setaf 3; tput setab 4) # yellow on blue
  export LESS_TERMCAP_se=$(tput rmso; tput sgr0)
  export LESS_TERMCAP_us=$(tput smul; tput bold; tput setaf 7) # white
  export LESS_TERMCAP_ue=$(tput rmul; tput sgr0)
  export LESS_TERMCAP_mr=$(tput rev)
  export LESS_TERMCAP_mh=$(tput dim)
  export LESS_TERMCAP_ZN=$(tput ssubm)
  export LESS_TERMCAP_ZV=$(tput rsubm)
  export LESS_TERMCAP_ZO=$(tput ssupm)
  export LESS_TERMCAP_ZW=$(tput rsupm)
  export GROFF_NO_SGR=1         # For Konsole and Gnome-terminal
```

- $'\e'
  ```bash
  export LESS_TERMCAP_mb=$'\e[01;31m'       # begin blinking
  export LESS_TERMCAP_md=$'\e[01;37m'       # begin bold
  export LESS_TERMCAP_me=$'\e[0m'           # end all mode like so, us, mb, md, mr
  export LESS_TERMCAP_se=$'\e[0m'           # end standout-mode
  export LESS_TERMCAP_so=$'\e[45;93m'       # start standout mode
  export LESS_TERMCAP_ue=$'\e[0m'           # end underline
  export LESS_TERMCAP_us=$'\e[4;93m'        # start underlining
  ```

### using vim as man pager

> [!TIP]
> - [Using vim as a man-page viewer under Unix](https://vim.fandom.com/wiki/Using_vim_as_a_man-page_viewer_under_Unix)

```bash
export PAGER="/bin/sh -c \"unset PAGER;col -b -x | \
    vim -R -c 'set ft=man nomod nolist' -c 'map q :q<CR>' \
    -c 'map <SPACE> <C-D>' -c 'map b <C-U>' \
    -c 'nmap K :Man <C-R>=expand(\\\"<cword>\\\")<CR><CR>' -\""
```

### ansicolor issues in man page
- error
  ```bash
  1mNAME0m       <-- BAD
         man - an interface to the on-line reference manuals

  1mSYNOPSIS0m   <-- BAD
         1mman  22m[1m-C  4m22mfile24m]  [1m-d22m]  [1m-D22m]  <-- BAD
  ```

- solution
  ```bash
  $ yum install man-pages man-db man

  # or
  $ sudo yum update man-pages man-db man
  ```