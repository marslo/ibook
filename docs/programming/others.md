<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [others](#others)
  - [import data to sql and print process](#import-data-to-sql-and-print-process)
  - [get the cnf file location for mysql](#get-the-cnf-file-location-for-mysql)
  - [get the git change from .git/objects](#get-the-git-change-from-gitobjects)
- [unicode](#unicode)
  - [simple arrows](#simple-arrows)
  - [arrows with modifications](#arrows-with-modifications)
  - [arrows with bent tips](#arrows-with-bent-tips)
  - [keyboard symbols and circle arrows](#keyboard-symbols-and-circle-arrows)
  - [harpoons](#harpoons)
  - [PAIRED ARROWS AND HARPOONS](#paired-arrows-and-harpoons)
  - [DOUBLE ARROWS](#double-arrows)
  - [miscellaneous arrows and keyboard symbols](#miscellaneous-arrows-and-keyboard-symbols)
  - [white arrows and keyboard symbols](#white-arrows-and-keyboard-symbols)
  - [miscellaneous arrows](#miscellaneous-arrows)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## others

### import data to sql and print process
```bash
$ (pv -n ~/database.sql | mysql -u root -pPASSWORD -D database_name) 2>&1 | zenity --width 550 --progress --auto-close --auto-kill --title "Im
```

### get the cnf file location for mysql
```bash
$ mysql - ? | grep ".cnf" -C 1
Default options are read from the following files in the given order:
/etc/my.cnf /etc/mysql/my.cnf /usr/local/mysql/etc/my.cnf ~/.my.cnf
The following groups are read: mysql client
```

### get the git change from .git/objects
```bash
$ find .git/objects -type f -printf "%P\n" | sed s,/,, | while read object; do
    echo "=== $obj $(git cat-file -t $object) ==="
    git cat-file -p $object
done
```

## unicode

{% hint style='tip' %}
> reference
> - [arrow](https://unicode-table.com/en/sets/arrow-symbols/)
> - [Arrows](https://unicode.org/charts/nameslist/n_2190.html)
> - [amp-what](https://www.amp-what.com/unicode/search/down%20arrow)
{% endhint %}

### simple arrows

| CODE | SYMBOLS | EXPLANATION                       |
|:----:|:-------:|-----------------------------------|
| 2190 |    ←    | LEFTWARDS ARROW                   |
| 20EA |    ◌⃪    | combining leftwards arrow overlay |
| 2191 |    ↑    | UPWARDS ARROW                     |
| 2192 |    →    | RIGHTWARDS ARROW                  |
| 2193 |    ↓    | DOWNWARDS ARROW                   |
| 2194 |    ↔    | LEFT RIGHT ARROW                  |
| 2195 |    ↕    | UP DOWN ARROW                     |
| 2196 |    ↖    | NORTH WEST ARROW                  |
| 2197 |    ↗    | NORTH EAST ARROW                  |
| 2198 |    ↘    | SOUTH EAST ARROW                  |
| 2199 |    ↙    | SOUTH WEST ARROW                  |

### arrows with modifications

| CODE | SYMBOLS | EXPLANATION                       |
|:----:|:-------:|-----------------------------------|
| 219A |    ↚    | LEFTWARDS ARROW WITH STROKE       |
| 219B |    ↛    | RIGHTWARDS ARROW WITH STROKE      |
| 219C |    ↜    | LEFTWARDS WAVE ARROW              |
| 2B3F |    ⬿    | wave arrow pointing directly left |
| 219D |    ↝    | RIGHTWARDS WAVE ARROW             |
| 219E |    ↞    | LEFTWARDS TWO HEADED ARROW        |
| 219F |    ↟    | UPWARDS TWO HEADED ARROW          |
| 21A0 |    ↠    | RIGHTWARDS TWO HEADED ARROW       |
| 21A1 |    ↡    | DOWNWARDS TWO HEADED ARROW        |
| 21A2 |    ↢    | LEFTWARDS ARROW WITH TAIL         |
| 21A3 |    ↣    | RIGHTWARDS ARROW WITH TAIL        |
| 21A4 |    ↤    | LEFTWARDS ARROW FROM BAR          |
| 21A5 |    ↥    | UPWARDS ARROW FROM BAR            |
| 21A6 |    ↦    | RIGHTWARDS ARROW FROM BAR         |
| 21A7 |    ↧    | DOWNWARDS ARROW FROM BAR          |
| 21A8 |    ↨    | UP DOWN ARROW WITH BASE           |
| 21A9 |    ↩    | LEFTWARDS ARROW WITH HOOK         |
| 21AA |    ↪    | RIGHTWARDS ARROW WITH HOOK        |
| 21AB |    ↫    | LEFTWARDS ARROW WITH LOOP         |
| 21AC |    ↬    | RIGHTWARDS ARROW WITH LOOP        |
| 21AD |    ↭    | LEFT RIGHT WAVE ARROW             |
| 21AE |    ↮    | LEFT RIGHT ARROW WITH STROKE      |
| 21AF |    ↯    | DOWNWARDS ZIGZAG ARROW            |


### arrows with bent tips

> [!TIP]
> Other arrows with bent tips to complete this set can be found in the Miscellaneous Symbols and Arrows block.


| CODE | SYMBOLS | EXPLANATION                         |
|:----:|:-------:|-------------------------------------|
| 21B0 |    ↰    | UPWARDS ARROW WITH TIP LEFTWARDS    |
| 21B1 |    ↱    | UPWARDS ARROW WITH TIP RIGHTWARDS   |
| 21B2 |    ↲    | DOWNWARDS ARROW WITH TIP LEFTWARDS  |
| 21B3 |    ↳    | DOWNWARDS ARROW WITH TIP RIGHTWARDS |


### keyboard symbols and circle arrows

| CODE | SYMBOLS | EXPLANATION                                         |
|:----:|:-------:|-----------------------------------------------------|
| 21B4 |    ↴    | RIGHTWARDS ARROW WITH CORNER DOWNWARDS              |
| 21B5 |    ↵    | DOWNWARDS ARROW WITH CORNER LEFTWARDS               |
| 23CE |    ⏎    | return symbol                                       |
| 21B6 |    ↶    | ANTICLOCKWISE TOP SEMICIRCLE ARROW                  |
| 21B7 |    ↷    | CLOCKWISE TOP SEMICIRCLE ARROW                      |
| 21B8 |    ↸    | NORTH WEST ARROW TO LONG BAR                        |
| 21B9 |    ↹    | LEFTWARDS ARROW TO BAR OVER RIGHTWARDS ARROW TO BAR |
| 21BA |    ↺    | ANTICLOCKWISE OPEN CIRCLE ARROW                     |
| 21BB |    ↻    | CLOCKWISE OPEN CIRCLE ARROW                         |

### harpoons

| CODE | SYMBOLS | EXPLANATION                            |
|:----:|:-------:|----------------------------------------|
| 21BC |    ↼    | LEFTWARDS HARPOON WITH BARB UPWARDS    |
| 21BD |    ↽    | LEFTWARDS HARPOON WITH BARB DOWNWARDS  |
| 21BE |    ↾    | UPWARDS HARPOON WITH BARB RIGHTWARDS   |
| 21BF |    ↿    | UPWARDS HARPOON WITH BARB LEFTWARDS    |
| 21C0 |    ⇀    | RIGHTWARDS HARPOON WITH BARB UPWARDS   |
| 21C1 |    ⇁    | RIGHTWARDS HARPOON WITH BARB DOWNWARDS |
| 21C2 |    ⇂    | DOWNWARDS HARPOON WITH BARB RIGHTWARDS |
| 21C3 |    ⇃    | DOWNWARDS HARPOON WITH BARB LEFTWARDS  |

### PAIRED ARROWS AND HARPOONS

| CODE | SYMBOLS | EXPLANATION                                |
|:----:|:-------:|--------------------------------------------|
| 21C4 |    ⇄    | RIGHTWARDS ARROW OVER LEFTWARDS ARROW      |
| 21C5 |    ⇅    | UPWARDS ARROW LEFTWARDS OF DOWNWARDS ARROW |
| 21C6 |    ⇆    | LEFTWARDS ARROW OVER RIGHTWARDS ARROW      |
| 21C7 |    ⇇    | LEFTWARDS PAIRED ARROWS                    |
| 21C8 |    ⇈    | UPWARDS PAIRED ARROWS                      |
| 21C9 |    ⇉    | RIGHTWARDS PAIRED ARROWS                   |
| 21CA |    ⇊    | DOWNWARDS PAIRED ARROWS                    |
| 21CB |    ⇋    | LEFTWARDS HARPOON OVER RIGHTWARDS HARPOON  |
| 21CC |    ⇌    | RIGHTWARDS HARPOON OVER LEFTWARDS HARPOON  |

### DOUBLE ARROWS

| CODE | SYMBOLS | EXPLANATION                         |
|:----:|:-------:|-------------------------------------|
| 21CD |    ⇍    | LEFTWARDS DOUBLE ARROW WITH STROKE  |
| 21CE |    ⇎    | LEFT RIGHT DOUBLE ARROW WITH STROKE |
| 21CF |    ⇏    | RIGHTWARDS DOUBLE ARROW WITH STROKE |
| 21D0 |    ⇐    | LEFTWARDS DOUBLE ARROW              |
| 21D1 |    ⇑    | UPWARDS DOUBLE ARROW                |
| 21D2 |    ⇒    | RIGHTWARDS DOUBLE ARROW             |
| 21D3 |    ⇓    | DOWNWARDS DOUBLE ARROW              |
| 21D4 |    ⇔    | LEFT RIGHT DOUBLE ARROW             |
| 21D5 |    ⇕    | UP DOWN DOUBLE ARROW                |
| 21D6 |    ⇖    | NORTH WEST DOUBLE ARROW             |
| 21D7 |    ⇗    | NORTH EAST DOUBLE ARROW             |
| 21D8 |    ⇘    | SOUTH EAST DOUBLE ARROW             |
| 21D9 |    ⇙    | SOUTH WEST DOUBLE ARROW             |

### miscellaneous arrows and keyboard symbols

| CODE | SYMBOLS | EXPLANATION                        |
|:----:|:-------:|------------------------------------|
| 21DA |    ⇚    | LEFTWARDS TRIPLE ARROW             |
| 21DB |    ⇛    | RIGHTWARDS TRIPLE ARROW            |
| 21DC |    ⇜    | LEFTWARDS SQUIGGLE ARROW           |
| 2B33 |    ⬳    | LONG LEFTWARDS SQUIGGLE ARROW      |
| 21DD |    ⇝    | RIGHTWARDS SQUIGGLE ARROW          |
| 21DE |    ⇞    | UPWARDS ARROW WITH DOUBLE STROKE   |
| 21DF |    ⇟    | DOWNWARDS ARROW WITH DOUBLE STROKE |
| 21E0 |    ⇠    | LEFTWARDS DASHED ARROW             |
| 21E1 |    ⇡    | UPWARDS DASHED ARROW               |
| 21E2 |    ⇢    | RIGHTWARDS DASHED ARROW            |
| 21E3 |    ⇣    | DOWNWARDS DASHED ARROW             |
| 21E4 |    ⇤    | LEFTWARDS ARROW TO BAR             |
| 21E5 |    ⇥    | RIGHTWARDS ARROW TO BAR            |

### white arrows and keyboard symbols

| CODE | SYMBOLS | EXPLANATION                                         |
|:----:|:-------:|-----------------------------------------------------|
| 21E6 |    ⇦    | LEFTWARDS WHITE ARROW                               |
| 2B00 |    ⬀    | NORTH EAST WHITE ARROW                              |
| 21E7 |    ⇧    | UPWARDS WHITE ARROW                                 |
| 21E8 |    ⇨    | RIGHTWARDS WHITE ARROW                              |
| 21E9 |    ⇩    | DOWNWARDS WHITE ARROW                               |
| 21EA |    ⇪    | UPWARDS WHITE ARROW FROM BAR                        |
| 21EB |    ⇫    | UPWARDS WHITE ARROW ON PEDESTAL                     |
| 21EC |    ⇬    | UPWARDS WHITE ARROW ON PEDESTAL WITH HORIZONTAL BAR |
| 21ED |    ⇭    | UPWARDS WHITE ARROW ON PEDESTAL WITH VERTICAL BAR   |
| 21EE |    ⇮    | UPWARDS WHITE DOUBLE ARROW                          |
| 21EF |    ⇯    | UPWARDS WHITE DOUBLE ARROW ON PEDESTAL              |
| 21F0 |    ⇰    | RIGHTWARDS WHITE ARROW FROM WALL                    |
| 21F1 |    ⇱    | NORTH WEST ARROW TO CORNER                          |
| 21F2 |    ⇲    | SOUTH EAST ARROW TO CORNER                          |
| 21F3 |    ⇳    | UP DOWN WHITE ARROW                                 |
| 2B04 |    ⬄    | LEFT RIGHT WHITE ARROW                              |

### miscellaneous arrows

| CODE | SYMBOLS | EXPLANATION                                  |
|:----:|:-------:|----------------------------------------------|
| 21F4 |    ⇴    | RIGHT ARROW WITH SMALL CIRCLE                |
| 2B30 |    ⬰    | LEFT ARROW WITH SMALL CIRCLE                 |
| 21F5 |    ⇵    | DOWNWARDS ARROW LEFTWARDS OF UPWARDS ARROW   |
| 21F6 |    ⇶    | THREE RIGHTWARDS ARROWS                      |
| 2B31 |    ⬱    | THREE LEFTWARDS ARROWS                       |
| 21F7 |    ⇷    | LEFTWARDS ARROW WITH VERTICAL STROKE         |
| 21F8 |    ⇸    | RIGHTWARDS ARROW WITH VERTICAL STROKE        |
| 21F9 |    ⇹    | LEFT RIGHT ARROW WITH VERTICAL STROKE        |
| 21FA |    ⇺    | LEFTWARDS ARROW WITH DOUBLE VERTICAL STROKE  |
| 21FB |    ⇻    | RIGHTWARDS ARROW WITH DOUBLE VERTICAL STROKE |
| 21FC |    ⇼    | LEFT RIGHT ARROW WITH DOUBLE VERTICAL STROKE |
| 21FD |    ⇽    | LEFTWARDS OPEN-HEADED ARROW                  |
| 21FE |    ⇾    | RIGHTWARDS OPEN-HEADED ARROW                 |
| 21FF |    ⇿    | LEFT RIGHT OPEN-HEADED ARROW                 |
