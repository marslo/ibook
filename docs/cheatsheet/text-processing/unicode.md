<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [unicode](#unicode)
  - [useful unicode](#useful-unicode)
    - [mac keys](#mac-keys)
    - [combining diacritical marks](#combining-diacritical-marks)
  - [arrows](#arrows)
    - [simple arrows](#simple-arrows)
    - [arrows with modifications](#arrows-with-modifications)
    - [arrows with bent tips](#arrows-with-bent-tips)
    - [keyboard symbols and circle arrows](#keyboard-symbols-and-circle-arrows)
    - [harpoons](#harpoons)
    - [paired arrows and harpoons](#paired-arrows-and-harpoons)
    - [double arrows](#double-arrows)
    - [miscellaneous arrows and keyboard symbols](#miscellaneous-arrows-and-keyboard-symbols)
    - [white arrows and keyboard symbols](#white-arrows-and-keyboard-symbols)
    - [miscellaneous arrows](#miscellaneous-arrows)
- [devicons](#devicons)
  - [coding](#coding)
    - [airline](#airline)
    - [prompts](#prompts)
    - [diagnostic](#diagnostic)
    - [ale](#ale)
    - [syntastic](#syntastic)
    - [vim-devicons](#vim-devicons)
  - [folders](#folders)
  - [platform](#platform)
  - [math](#math)
  - [graph](#graph)
  - [tiaji](#tiaji)
  - [spinner](#spinner)
  - [misc.](#misc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# unicode

{% hint style="info" %}
> references:
> - [* iMarslo: unicode in bash](../../linux/basic.md#unicode) | [* iMarslo: unicode in vim](../../vim/tricky.md#characters)
> - [Unicode 16.0 Character Code Charts](https://www.unicode.org/charts/) | [Names List Charts](https://www.unicode.org/charts/nameslist/)
>   - `25A0 - 25FF`: [Geometric Shapes](https://www.unicode.org/charts/nameslist/n_25A0.html) | [Geometric Shapes.pdf](https://www.unicode.org/charts/PDF/U25A0.pdf)
>   - `2B00 - 2BFF`: [Miscellaneous Symbols and Arrows](https://www.unicode.org/charts/nameslist/n_2B00.html) | [Miscellaneous Symbols and Arrows](https://www.unicode.org/charts/nameslist/n_2B00.html) | [Miscellaneous Symbols and Arrows.pdf](https://www.unicode.org/charts/PDF/U2B00.pdf)
>   - `1F780 - 1F7FF`: [Geometric Shapes Extended](https://www.unicode.org/charts/nameslist/n_1F780.html) | [Geometric Shapes Extended.pdf](https://www.unicode.org/charts/PDF/U1F780.pdf)
> - [Unicode](https://www.compart.com/en/unicode/block)
> - [Unicode Character Table](https://unicode-table.com/en/)
>   - [arrow](https://unicode-table.com/en/sets/arrow-symbols/)
>   - [Arrows](https://unicode.org/charts/nameslist/n_2190.html)
> - [amp-what](https://www.amp-what.com/unicode/search/down%20arrow)
> - [devicons](https://devicons.github.io/devicon/) | `E000 - F8FF`: [Private Use Area](https://jrgraphix.net/r/Unicode/E000-F8FF)
> - [nerdfonts](https://www.nerdfonts.com/cheat-sheet)
{% endhint %}

## useful unicode

> [!NOTE|label:reference]
> - [HTML Symbols](https://www.w3schools.com/html/html_symbols.asp)
> - [HTML Entities](https://www.w3schools.com/html/html_entities.asp)
> - [UTF-8 Greek and Coptic](https://www.w3schools.com/charsets/ref_utf_greek.asp)
> - [DerivedAge-14.0.0.txt](http://www.unicode.org/Public/UCD/latest/ucd/DerivedAge.txt)
> - [Other Symbol](https://www.compart.com/en/unicode/category/So)
> - [Other Neutral](https://www.compart.com/en/unicode/bidiclass/ON)
> - [Complete list of github markdown emoji markup](https://gist.github.com/rxaviers/7360908)


| SYMBOLS | UNICODE | HTML ENTITY NUMBER          | ENTITY NAME                                    | DESC                                       |
|:-------:|:-------:|:----------------------------|:-----------------------------------------------|:-------------------------------------------|
|  &#160; |         | `&#160;`                    | `&nbsp;`                                       | space                                      |
|  &#60;  |  `003C` | `&#60;` <br> `&#x3C;`       | `&lt;`                                         | less than                                  |
|  &#62;  |  `003E` | `&#62;`  <br> `&#x3E;`      | `&gt;`                                         | greater than                               |
|    «    |  `00AB` | `&#171;` <br> `&#xab;`      | `&laquo;`                                      | left-pointing double angle quotation mark  |
|    »    |  `00BB` | `&#187` <br> `&#xbb;`       | `&raquo;`                                      | right-pointing Double angle quotation mark |
|    ›    |  `203A` | `&#8250;` <br> `&#x203a;`   | `&rsaquo;`                                     | right-pointing single guillemet            |
|    ‹    |  `2039` | `&#8249;` <br> `&#x2039;`   | `&lsaquo;`                                     | left-pointing single guillemet             |
|  &#38;  |  `0026` | `&#38;` <br> `&#x26;`       | `&amp;`                                        | ampersand                                  |
|  &#124; |  `007C` | `&#124;` <br> `&#x7C;`      | `&verbar;` <br> `&vert;` <br> `&VerticalLine;` | vertical bar                               |
|    ←    |  `2190` | `&#8592;` <br> `&#x2190;`   | `&larr;` <br> `&ShortLeftArrow;`               | leftwards arrow                            |
|    →    |  `2192` | `&#8594;` <br> `&#x2192;`   | `&rarr;` <br> `&rightarrow;`                   | rightwards arrow                           |
|    ↑    |  `2191` | `&#8593;` <br> `&#x2191;`   | `&uarr;` <br> `&ShortUpArrow;`                 | upwards arrow                              |
|    ↓    |  `2193` | `&#8595;` <br> `&#x2193;`   | `&darr;` <br> `&ShortDownArrow;`               | downwards arrow                            |
|    ☐    |  `2610` | `&#9744;` <br> `&#x2610;`   | -                                              | Ballot Box                                 |
| &#8414; |  `20DE` | `&#8414;` <br> `&#x20DE;`   | -                                              | Combining Enclosing Square                 |
|    ▢    |  `25A2` | `&#9634;` <br> `&#x25A2;`   | -                                              | White Square with Rounded C                |
|    ⬚    |  `2B1A` | `&#11034;` <br> `&#x2B1A;`  | -                                              | Dotted Square                              |
|    ✅   |  `2705` | `&#9989;` <br> `&#x2705;`   | -                                              | White Heavy Check Mark                     |
|    ☑    |  `2611` | `&#9745;` <br> `&#x2611;`   | -                                              | Ballot Box with Check                      |
|    ☒    |  `2612` | `&#9746;` <br> `&#x2612;`   | -                                              | Ballot Box with X                          |
|    𐄂    | `10102` | `&#65794;` <br> `&#x10102;` | -                                              | Aegean Check Mark                          |
|    ☓    |  `2613` | `&#9747;` <br> `&#x2613;`   | -                                              | Saltire                                    |
|    ✓    |  `2713` | `&#10003;` <br> `&#x2713;`  | `&check;`                                      | Check Mark                                 |
|    ✔    |  `2714` | `&#10004;` <br> `&#x2714;`  | -                                              | Heavy Check Mark                           |
|    ⍻    |  `237B` | `&#9083;` <br> `&#x237B;`   | -                                              | Not Check Mark                             |
|    √    |  `221A` | `&#8730;` <br> `&#x221A;`   | `&Sqrt;`                                       | Square Root                                |
|    ∛    |  `221B` | `&#8731;` <br> `&#x221B;`   | -                                              | Cube Root                                  |
|    ∜    |  `221C` | `&#8732;` <br> `&#x221C;`   | -                                              | Fourth Root                                |
|    ✕    |  `2715` | `&#10005;` <br> `&#x2715;`  | -                                              | Multiplication X                           |
|    ✖    |  `2716` | `&#10006;` <br> `&#x2716;`  | -                                              | Heavy Multiplication X                     |
|    ✗    |  `2717` | `&#10007;` <br> `&#x2717;`  | -                                              | Ballot X                                   |
|    ✘    |  `2718` | `&#10008;` <br> `&#x2718;`  | -                                              | Heavy Ballot X                             |
|    ⎅    |  `2385` | `&#9093;` <br> `&#x2385;`   | -                                              | White Square with Centre Vertical Line     |
|    ⌗    |  `2317` | `&#8983;` <br> `&#x2317;`   | -                                              | viewdata square                            |

### mac keys

 | KEY | KEY CODE |  | KEY | KEY CODE |  | KEY | KEY CODE |
 |:---:|:--------:|--|:---:|:--------:|--|:---:|:--------:|
 | `␣` |  `2423`  |  | `⇥` |  `21E5`  |  | `⏎` |  `23CE`  |
 | `⌫` |  `232B`  |  | `⌦` |  `2326`  |  | `␊` |  `240A`  |
 | `⎋` |  `238B`  |  | `⌘` |  `2318`  |  | `⎇` |  `2387`  |
 | `⇪` |  `21EA`  |  | `⇧` |  `21EF`  |  | `⇧` |  `21E7`  |
 | `⌃` |   `62`   |  | `⌥` |  `2325`  |  | `⌃` |  `2303`  |
 | `⇱` |  `21F1`  |  | `⇲` |  `21F2`  |  | `⇞` |  `21DE`  |
 | `⇟` |  `21DF`  |  | `←` |  `2190`  |  | `→` |  `2192`  |
 | `↓` |  `2193`  |  | `↑` |  `2191`  |  | `⌨` |  `2328`  |

### [combining diacritical marks](https://www.w3schools.com/html/html_entities.asp)

|  MARK  |  UNICODE |        CHARACTER       | CONSTRUCT |  RESULT |
|:------:|:--------:|:----------------------:|:---------:|:-------:|
| &#768; | `&#768;` | a +&nbsp;     &#xbb; à | `a&#768;` | a&#768; |
| &#769; | `&#769;` | a +&nbsp;     &#xbb; á | `a&#769;` | a&#769; |
| &#770; | `&#770;` | a +&nbsp;     &#xbb; â | `a&#770;` | a&#770; |
| &#771; | `&#771;` | a +&nbsp;     &#xbb; ã | `a&#771;` | a&#771; |
| &#768; | `&#768;` | O +&nbsp;     &#xbb; Ò | `O&#768;` | O&#768; |
| &#769; | `&#769;` | O +&nbsp;     &#xbb; Ó | `O&#769;` | O&#769; |
| &#770; | `&#770;` | O +&nbsp;     &#xbb; Ô | `O&#770;` | O&#770; |
| &#771; | `&#771;` | O +&nbsp;     &#xbb; Õ | `O&#771;` | O&#771; |

## arrows

### simple arrows

|   CODE  | SYMBOLS | EXPLANATION                       |
|:-------:|:-------:|-----------------------------------|
|  `2190` |    ←    | leftwards arrow                   |
|  `20EA` |    ◌⃪    | combining leftwards arrow overlay |
|  `2191` |    ↑    | upwards arrow                     |
|  `2192` |    →    | rightwards arrow                  |
|  `2193` |    ↓    | downwards arrow                   |
|  `2194` |    ↔    | left right arrow                  |
|  `2195` |    ↕    | up down arrow                     |
|  `2196` |    ↖    | north west arrow                  |
|  `2197` |    ↗    | north east arrow                  |
|  `2198` |    ↘    | south east arrow                  |
|  `2199` |    ↙    | south west arrow                  |
|  `E353` |        | heavy upwards arrow               |
|  `E340` |        | heavy downwards arrow             |
|  `E344` |        | heavy leftwards arrow             |
|  `E349` |        | heavy rightwards arrow            |
|  `E37F` |        | heavy north east arrow            |
|  `E352` |        | heavy north west arrow            |
|  `E380` |        | heavy south west arrow            |
|  `E33F` |        | heavy south east arrow            |
|  `EA99` |        | left-right                        |
|  `F416` |        | left-right                        |
|  `EAA1` |        | up                                |
|  `EA9A` |        | down                              |
|  `EA9B` |        | left                              |
|  `EA9C` |        | right                             |
|  `EA9D` |        | down                              |
|  `EA9E` |        | left                              |
|  `EA9F` |        | right                             |
|  `EAA0` |        | up                                |
| `F0441` |    󰑁    | left                              |
| `F0443` |    󰑃    | right                             |
|  `F176` |        | up                                |
|  `F175` |        | down                              |
|  `F424` |        | down-left                         |
|  `F43E` |        | down-right                        |
|  `F45C` |        | up-left                           |
|  `F46C` |        | up-right                          |


### arrows with modifications

|   CODE  | SYMBOLS | EXPLANATION                       |
|:-------:|:-------:|-----------------------------------|
|  `219A` |    ↚    | leftwards arrow with stroke       |
|  `219B` |    ↛    | rightwards arrow with stroke      |
|  `219C` |    ↜    | leftwards wave arrow              |
|  `2B3F` |    ⬿    | wave arrow pointing directly left |
|  `219D` |    ↝    | rightwards wave arrow             |
|  `219E` |    ↞    | leftwards two headed arrow        |
|  `219F` |    ↟    | upwards two headed arrow          |
|  `21A0` |    ↠    | rightwards two headed arrow       |
|  `21A1` |    ↡    | downwards two headed arrow        |
|  `21A2` |    ↢    | leftwards arrow with tail         |
|  `21A3` |    ↣    | rightwards arrow with tail        |
|  `21A4` |    ↤    | leftwards arrow from bar          |
|  `21A5` |    ↥    | upwards arrow from bar            |
|  `21A6` |    ↦    | rightwards arrow from bar         |
|  `21A7` |    ↧    | downwards arrow from bar          |
|  `21A8` |    ↨    | up down arrow with base           |
|  `21A9` |    ↩    | leftwards arrow with hook         |
|  `21AA` |    ↪    | rightwards arrow with hook        |
|  `21AB` |    ↫    | leftwards arrow with loop         |
|  `21AC` |    ↬    | rightwards arrow with loop        |
|  `21AD` |    ↭    | left right wave arrow             |
|  `21AE` |    ↮    | left right arrow with stroke      |
|  `21AF` |    ↯    | downwards zigzag arrow            |
|  `E630` |        | <=>                               |
|  `E875` |        | <=>                               |
|  `EA7D` |        | <-                                |
|  `EAD4` |        | down                              |
| `F01B9` |    󰆹    | down                              |
|  `EAD5` |        | up                                |
| `F01B8` |    󰆸    | up                                |
|  `EAD6` |        | right                             |
| `F01B7` |    󰆷    | right                             |
|  `EB8F` |        | left                              |
|  `EB18` |        | left/share                        |
|  `F148` |        | turn up                           |
|  `F149` |        | turn down                         |
| `F17A1` |    󱞡    | left turn down                    |
| `F17A3` |    󱞣    | right turn down                   |
| `F17A5` |    󱞥    | up turn left                      |
| `F17A9` |    󱞩    | up turn right                     |
| `F17A7` |    󱞧    | down turn left                    |
| `F17AB` |    󱞫    | down turn right                   |
| `F17BD` |    󱞽    | left turn up                      |
| `F17BF` |    󱞿    | right turn up                     |
| `F17A2` |    󱞢    | right turn down                   |
| `F17A4` |    󱞤    | left turn down                    |
| `F17A6` |    󱞦    | up turn left                      |
| `F17AA` |    󱞪    | up turn right                     |
| `F17AC` |    󱞬    | down turn left                    |
| `F17BE` |    󱞾    | right turn up                     |
| `F17C0` |    󱟀    | left turn up                      |
| `F17AD` |    󱞭    | turn down                         |
| `F17AF` |    󱞯    | turn down                         |
| `F17B1` |    󱞱    | turn left                         |
| `F17B3` |    󱞳    | turn left                         |
| `F17B5` |    󱞵    | turn right                        |
| `F17B7` |    󱞷    | turn right                        |
| `F17B9` |    󱞹    | turn up                           |
| `F17BB` |    󱞻    | turn up                           |
| `F17AE` |    󱞮    | turn down                         |
| `F17B0` |    󱞰    | turn down                         |
| `F17B2` |    󱞲    | turn left                         |
| `F17B4` |    󱞴    | turn left                         |
| `F17B6` |    󱞶    | turn right                        |
| `F17B8` |    󱞸    | turn right                        |
| `F17BA` |    󱞺    | turn up                           |
| `F17BC` |    󱞼    | turn up                           |
| `F0D4E` |    󰵎    | rotate                            |
| `F0D53` |    󰵓    | rotate                            |
| `F0D57` |    󰵗    | rotate                            |
| `F09BB` |    󰦻    | arrow decision                    |
| `F09BE` |    󰦾    | arrow decision                    |
| `F09BC` |    󰦼    | arrow decision                    |
| `F09BD` |    󰦽    | arrow decision                    |


### arrows with bent tips

> [!TIP|label:references:]
> Other arrows with bent tips to complete this set can be found in the Miscellaneous Symbols and Arrows block.

|   CODE  | SYMBOLS | EXPLANATION                         |
|:-------:|:-------:|-------------------------------------|
|  `21B0` |    ↰    | upwards arrow with tip leftwards    |
|  `21B1` |    ↱    | upwards arrow with tip rightwards   |
|  `21B2` |    ↲    | downwards arrow with tip leftwards  |
|  `21B3` |    ↳    | downwards arrow with tip rightwards |
| `F060C` |    󰘌    | downwards arrow with tip leftwards  |
| `F060D` |    󰘍    | downwards arrow with tip rightwards |


### keyboard symbols and circle arrows

|  CODE  | SYMBOLS | EXPLANATION                                         |
|:------:|:-------:|-----------------------------------------------------|
| `21B4` |    ↴    | rightwards arrow with corner downwards              |
| `21B5` |    ↵    | downwards arrow with corner leftwards               |
| `23CE` |    ⏎    | return symbol                                       |
| `21B6` |    ↶    | anticlockwise top semicircle arrow                  |
| `21B7` |    ↷    | clockwise top semicircle arrow                      |
| `21B8` |    ↸    | north west arrow to long bar                        |
| `21B9` |    ↹    | leftwards arrow to bar over rightwards arrow to bar |
| `21BA` |    ↺    | anticlockwise open circle arrow                     |
| `21BB` |    ↻    | clockwise open circle arrow                         |
| `E347` |        | down to up                                          |

### harpoons

|  CODE  | SYMBOLS | EXPLANATION                            |
|:------:|:-------:|----------------------------------------|
| `21BC` |    ↼    | leftwards harpoon with barb upwards    |
| `21BD` |    ↽    | leftwards harpoon with barb downwards  |
| `21BE` |    ↾    | upwards harpoon with barb rightwards   |
| `21BF` |    ↿    | upwards harpoon with barb leftwards    |
| `21C0` |    ⇀    | rightwards harpoon with barb upwards   |
| `21C1` |    ⇁    | rightwards harpoon with barb downwards |
| `21C2` |    ⇂    | downwards harpoon with barb rightwards |
| `21C3` |    ⇃    | downwards harpoon with barb leftwards  |

### paired arrows and harpoons

|  CODE  | SYMBOLS | EXPLANATION                                |
|:------:|:-------:|--------------------------------------------|
| `21C4` |    ⇄    | rightwards arrow over leftwards arrow      |
| `21C5` |    ⇅    | upwards arrow leftwards of downwards arrow |
| `21C6` |    ⇆    | leftwards arrow over rightwards arrow      |
| `21C7` |    ⇇    | leftwards paired arrows                    |
| `21C8` |    ⇈    | upwards paired arrows                      |
| `21C9` |    ⇉    | rightwards paired arrows                   |
| `21CA` |    ⇊    | downwards paired arrows                    |
| `21CB` |    ⇋    | leftwards harpoon over rightwards harpoon  |
| `21CC` |    ⇌    | rightwards harpoon over leftwards harpoon  |

### double arrows

|  CODE  | SYMBOLS | EXPLANATION                         |
|:------:|:-------:|-------------------------------------|
| `21CD` |    ⇍    | leftwards double arrow with stroke  |
| `21CE` |    ⇎    | left right double arrow with stroke |
| `21CF` |    ⇏    | rightwards double arrow with stroke |
| `21D0` |    ⇐    | leftwards double arrow              |
| `21D1` |    ⇑    | upwards double arrow                |
| `21D2` |    ⇒    | rightwards double arrow             |
| `21D3` |    ⇓    | downwards double arrow              |
| `21D4` |    ⇔    | left right double arrow             |
| `21D5` |    ⇕    | up down double arrow                |
| `21D6` |    ⇖    | north west double arrow             |
| `21D7` |    ⇗    | north east double arrow             |
| `21D8` |    ⇘    | south east double arrow             |
| `21D9` |    ⇙    | south west double arrow             |

### miscellaneous arrows and keyboard symbols

|  CODE  | SYMBOLS | EXPLANATION                        |
|:------:|:-------:|------------------------------------|
| `21DA` |    ⇚    | leftwards triple arrow             |
| `21DB` |    ⇛    | rightwards triple arrow            |
| `21DC` |    ⇜    | leftwards squiggle arrow           |
| `2B33` |    ⬳    | long leftwards squiggle arrow      |
| `21DD` |    ⇝    | rightwards squiggle arrow          |
| `21DE` |    ⇞    | upwards arrow with double stroke   |
| `21DF` |    ⇟    | downwards arrow with double stroke |
| `21E0` |    ⇠    | leftwards dashed arrow             |
| `21E1` |    ⇡    | upwards dashed arrow               |
| `21E2` |    ⇢    | rightwards dashed arrow            |
| `21E3` |    ⇣    | downwards dashed arrow             |
| `21E4` |    ⇤    | leftwards arrow to bar             |
| `21E5` |    ⇥    | rightwards arrow to bar            |

### white arrows and keyboard symbols

|  CODE  | SYMBOLS | EXPLANATION                                         |
|:------:|:-------:|-----------------------------------------------------|
| `21E6` |    ⇦    | leftwards white arrow                               |
| `2B00` |    ⬀    | north east white arrow                              |
| `21E7` |    ⇧    | upwards white arrow                                 |
| `21E8` |    ⇨    | rightwards white arrow                              |
| `21E9` |    ⇩    | downwards white arrow                               |
| `21EA` |    ⇪    | upwards white arrow from bar                        |
| `21EB` |    ⇫    | upwards white arrow on pedestal                     |
| `21EC` |    ⇬    | upwards white arrow on pedestal with horizontal bar |
| `21ED` |    ⇭    | upwards white arrow on pedestal with vertical bar   |
| `21EE` |    ⇮    | upwards white double arrow                          |
| `21EF` |    ⇯    | upwards white double arrow on pedestal              |
| `21F0` |    ⇰    | rightwards white arrow from wall                    |
| `21F1` |    ⇱    | north west arrow to corner                          |
| `21F2` |    ⇲    | south east arrow to corner                          |
| `21F3` |    ⇳    | up down white arrow                                 |
| `2B04` |    ⬄    | left right white arrow                              |

### miscellaneous arrows

|  CODE  | SYMBOLS | EXPLANATION                                  |
|:------:|:-------:|----------------------------------------------|
| `21F4` |    ⇴    | right arrow with small circle                |
| `2B30` |    ⬰    | left arrow with small circle                 |
| `21F5` |    ⇵    | downwards arrow leftwards of upwards arrow   |
| `21F6` |    ⇶    | three rightwards arrows                      |
| `2B31` |    ⬱    | three leftwards arrows                       |
| `21F7` |    ⇷    | leftwards arrow with vertical stroke         |
| `21F8` |    ⇸    | rightwards arrow with vertical stroke        |
| `21F9` |    ⇹    | left right arrow with vertical stroke        |
| `21FA` |    ⇺    | leftwards arrow with double vertical stroke  |
| `21FB` |    ⇻    | rightwards arrow with double vertical stroke |
| `21FC` |    ⇼    | left right arrow with double vertical stroke |
| `21FD` |    ⇽    | leftwards open-headed arrow                  |
| `21FE` |    ⇾    | rightwards open-headed arrow                 |
| `21FF` |    ⇿    | left right open-headed arrow                 |

# devicons

> [!NOTE|label:references:]
> - [unicodes.jessetane](https://unicodes.jessetane.com/)
> - [Private Use Area: E000 - F8FF](https://jrgraphix.net/r/Unicode/E000-F8FF)
> - [U+E000 - U+F8FF: Private Use Area](https://utf8-chartable.de/unicode-utf8-table.pl)
>   - [U+E600 - U+E9FF](https://utf8-chartable.de/unicode-utf8-table.pl?start=58880&number=1024&utf8=-)
>   - [U+E5FA - U+E9F9](https://utf8-chartable.de/unicode-utf8-table.pl?start=58874&number=1024&utf8=dec&unicodeinhtml=hex)
>   - [U+E9FA - U+EDF9](https://utf8-chartable.de/unicode-utf8-table.pl?start=59898&number=1024&utf8=dec&unicodeinhtml=hex)
>   - [U+EDFA - U+F1F9](https://utf8-chartable.de/unicode-utf8-table.pl?start=60922&number=1024&utf8=dec&unicodeinhtml=hex)
>   - [U+F1FA - U+F5F9](https://utf8-chartable.de/unicode-utf8-table.pl?start=61946&number=1024&utf8=dec&unicodeinhtml=hex)
>   - [U+F0000 - U+F03FF](https://utf8-chartable.de/unicode-utf8-table.pl?start=983040&number=1024&utf8=-)
> - [Font Awesome 5 Code Icons](https://www.w3schools.com/icons/fontawesome5_icons_code.asp)
> - [nerdfont cheatsheet](https://www.nerdfonts.com/cheat-sheet)
>   - `nf-ple`
>   - `nf-md`
>   - `nf-dev`
>   - `nf-fa`
>   - `nf-linux`
> - [Math Symbols](https://www.alt-codes.net/math-symbols-list) | [Mathematical Alphanumeric Symbols](https://jrgraphix.net/r/Unicode/1D400-1D7FF)
>   - [Plus Sign Symbols](https://www.alt-codes.net/plus-sign-symbols)

## coding

| UNICODE | ICON | HTML ENCODING | COMMENTS                |
|:-------:|:----:|:-------------:|-------------------------|
|  `E614` |     |   `&#xE614;`  | # - css                 |
|  `F292` |     |   `&#xF292;`  | #                       |
|  `EA90` |     |   `&#xEA90;`  | #                       |
|  `F198` |     |   `&#xF198;`  | #                       |
| `F0423` |   󰐣  |  `&#xF0423;`  | #                       |
| `F0423` |   󰐣  |  `&#xF0423;`  | #                       |
| `F0424` |   󰐤  |  `&#xF0424;`  | #                       |
| `10995` |   𐦕  |   `&#10995;`  | #                       |
| `10E98` |   𐺘  |  `&#x10E98;`  | #                       |
| `F0F6D` |   󰽭  |  `&#xF0F6D;`  | #                       |
|  `E8C6` |     |   `&#xE8C6;`  | #                       |
| `F1183` |   󱆃  |  `&#xF1183;`  | #!                      |
| `F1501` |   󱔁  |  `&#xF1501;`  | !?#                     |
|  `F295` |     |   `&#xF295;`  | %                       |
| `F1278` |   󱉸  |  `&#xF1278;`  | %                       |
| `F03F0` |   󰏰  |  `&#xF03F0;`  | %                       |
|  `F852` |     |   `&#xF852;`  | %                       |
| `F0353` |   󰍓  |  `&#xF0353;`  | %                       |
| `F1033` |   󱀳  |  `&#xF1033;`  | %                       |
| `F046F` |   󰑯  |  `&#xF046F;`  | %                       |
|  `2C03` |   Ⰳ  |   `&#x2C03;`  | %                       |
|  `FE6A` |  ﹪  |   `&#xfe6a;`  | %                       |
|  `E60C` |     |   `&#xE60C;`  | JS                      |
|  `E74E` |     |   `&#xE74E;`  | JS                      |
|  `F81D` |     |   `&#xF81D;`  | JS                      |
|  `E781` |     |   `&#xE781;`  | JS                      |
|  `F898` |     |   `&#xF898;`  | JS                      |
| `F0399` |   󰎙  |  `&#xF0399;`  | JS                      |
| `F06E6` |   󰛦  |  `&#xF06E6;`  | TS                      |
|  `E628` |     |   `&#xE628;`  | TS                      |
|  `F81A` |     |   `&#xF81A;`  | C#                      |
| `F031B` |   󰌛  |  `&#xF031B;`  | C#                      |
|  `E648` |     |   `&#xE648;`  | c#                      |
|  `E649` |     |   `&#xE649;`  | C                       |
| `F0671` |   󰙱  |  `&#xF0671;`  | C                       |
| `F0672` |   󰙲  |  `&#xF0672;`  | C++                     |
|  `E61D` |     |   `&#xE61D;`  | C++                     |
|  `E646` |     |   `&#xE646;`  | C++                     |
|  `E64B` |     |   `&#xE64B;`  | UDA                     |
|  `E651` |     |   `&#xE651;`  | D                       |
|  `FD42` |   ﵂  |   `&#xFD42;`  | V                       |
| `F0844` |   󰡄  |  `&#xF0844;`  | V                       |
|  `ED1E` |     |   `&#xed1e;`  | re:                     |
| `F07D4` |   󰟔  |  `&#xF07D4;`  | R                       |
|  `E612` |     |   `&#xE612;`  | txt                     |
|  `E64E` |     |   `&#xE64E;`  | txt                     |
|  `F2C5` |     |   `&#xF2C5;`  | (fire)                  |
|  `E242` |     |   `&#xE242;`  | (fire)                  |
|  `E780` |     |   `&#xE780;`  | fire                    |
| `F10D7` |   󱃗  |  `&#xF10d7;`  | ()                      |
| `F10FA` |   󱃺  |  `&#xF10FA;`  | ()                      |
| `F0172` |   󰅲  |  `&#xF0172;`  | ()                      |
| `F0AE7` |   󰫧  |  `&#xF0AE7;`  | (x)                     |
| `F10FB` |   󱃻  |  `&#xF10FB;`  | (x)                     |
| `F1111` |   󱄑  |  `&#xF1111;`  | (x)                     |
| `F10FC` |   󱃼  |  `&#xF10FC;`  | (x)                     |
|  `E6B2` |     |   `&#xE6B2;`  | [T]                     |
|  `EA88` |     |   `&#xEA88;`  | []                      |
|  `EA8A` |     |   `&#xEA8A;`  | []                      |
| `F0168` |   󰅨  |  `&#xF0168;`  | []                      |
| `F016A` |   󰅪  |  `&#xF016A;`  | []                      |
| `F10F5` |   󱃵  |  `&#xF10F5;`  | []                      |
| `F10F6` |   󱃶  |  `&#xF10F6;`  | []                      |
| `f0628` |   󰘨  |  `&#xf0628;`  | [1001]                  |
| `F0A3E` |   󰨾  |  `&#xF0A3E;`  | [..]                    |
|  `E60B` |     |   `&#xE60B;`  | {}                      |
|  `EA8B` |     |   `&#xEA8B;`  | {}                      |
|  `EB0F` |     |   `&#xEB0F;`  | {}                      |
|  `EBE5` |     |   `&#xEBE5;`  | {}                      |
|  `EBE6` |     |   `&#xEBE6;`  | {}                      |
| `F0169` |   󰅩  |  `&#xF0169;`  | {}                      |
| `F07B5` |   󰞵  |  `&#xF07B5;`  | {}                      |
| `F10D6` |   󱃖  |  `&#xF10D6;`  | {}                      |
| `F10F7` |   󱃷  |  `&#xF10F7;`  | {}                      |
| `F10F8` |   󱃸  |  `&#xF10F8;`  | {}                      |
| `F0626` |   󰘦  |  `&#xF0626;`  | {..}                    |
|  `E8B8` |     |   `&#xE8B8;`  | {..}                    |
|  `E850` |     |   `&#xE850;`  | {o}                     |
|  `FB25` |   ﬥ  |   `&#xFB25;`  | {...}                   |
|  `FE37` |  ︷  |   `&#xfe37;`  | {                       |
|  `FE38` |  ︸  |   `&#xfe38;`  | }                       |
|  `E60E` |     |   `&#xE60E;`  | <>                      |
|  `E618` |     |   `&#xE618;`  | <>                      |
|  `EAE9` |     |   `&#xEAE9;`  | <>                      |
|  `EEA7` |     |   `&#xEEA7;`  | <>                      |
|  `F40D` |     |   `&#xF40D;`  | <>                      |
|  `F44F` |     |   `&#xF44F;`  | <>                      |
|  `F4B1` |     |   `&#xF4b1;`  | <> - code scan          |
|  `F4b0` |     |   `&#xF4b0;`  | <>                      |
| `F0171` |   󰅱  |  `&#xF0171;`  | <>                      |
| `F0174` |   󰅴  |  `&#xF0174;`  | <>                      |
| `F022E` |   󰈮  |  `&#xF022E;`  | <>                      |
| `F054F` |   󰕏  |  `&#xF054F;`  | <>                      |
| `F0694` |   󰚔  |  `&#xF0694;`  | <>                      |
| `F0694` |   󰚔  |  `&#xF0694;`  | <>                      |
| `F0761` |   󰝡  |  `&#xF0761;`  | <>                      |
| `F102B` |   󱀫  |  `&#xF102B;`  | <>                      |
|  `F4AF` |     |   `&#xf4af;`  | <>                      |
|  `E796` |     |   `&#xE796;`  | </>                     |
|  `E7A3` |     |   `&#xE7A3;`  | </>                     |
|  `E7C1` |     |   `&#xE7C1;`  | </>                     |
|  `EAC4` |     |   `&#xEAC4;`  | </>                     |
|  `F121` |     |   `&#xF121;`  | </>                     |
|  `F1C9` |     |   `&#xF1C9;`  | </>                     |
| `F05C0` |   󰗀  |  `&#xF05C0;`  | </>                     |
|  `EA92` |     |   `&#xEA92;`  | `<T>`                   |
|  `E67C` |     |   `&#xE67C;`  | (:a)                    |
|  `F4B5` |     |   `&#xF4B5;`  | >_                      |
|  `F120` |     |   `&#xF120;`  | >_                      |
|  `E7A2` |     |   `&#xE7A2;`  | >_                      |
|  `E683` |     |   `&#xE683;`  | >_                      |
| `F07B7` |   󰞷  |  `&#xF07B7;`  | >_                      |
|  `F489` |     |   `&#xF489;`  | >_                      |
|  `EA85` |     |   `&#xEA85;`  | >_                      |
|  `E285` |     |   `&#xE285;`  | >                       |
|  `E795` |     |   `&#xE795;`  | >_                      |
|  `E86C` |     |   `&#xE86C;`  | >_                      |
|  `F460` |     |   `&#xF460;`  | >                       |
|  `E758` |     |   `&#xE758;`  | {less}                  |
|  `E256` |     |   `&#xE256;`  | java                    |
|  `E738` |     |   `&#xE738;`  | java                    |
| `F0B37` |   󰬷  |  `&#xF0B37;`  | java                    |
|  `E204` |     |   `&#xE204;`  | java                    |
|  `E005` |     |   `&#xE005;`  | java                    |
|  `E66D` |     |   `&#xE66D;`  | java                    |
| `F0617` |   󰘗  |  `&#xF0617;`  | java                    |
|  `E61B` |     |   `&#xE61B;`  | cjsx                    |
|  `E65E` |     |   `&#xE65E;`  | go                      |
|  `E626` |     |   `&#xE626;`  | go                      |
|  `E724` |     |   `&#xE724;`  | go                      |
|  `F2A5` |     |   `&#xF2A5;`  | g                       |
|  `F2A6` |     |   `&#xF2A6;`  | g                       |
|  `F0D5` |     |   `&#xF0D5;`  | g+                      |
| `F02BD` |   󰊽  |  `&#xF02BD;`  | g+                      |
|  `F0D4` |     |   `&#xF0D4;`  | g+                      |
|  `F2B3` |     |   `&#xF2B3;`  | g+                      |
| `F03BF` |   󰎿  |  `&#xF03BF;`  | g+                      |
| `F0CB2` |   󰲲  |  `&#xF0CB2;`  | g+                      |
|  `E650` |     |   `&#xE650;`  | docker                  |
|  `E7B0` |     |   `&#xE7B0;`  | docker                  |
|  `F308` |     |   `&#xF308;`  | docker                  |
|  `f21f` |     |   `&#xf21f;`  | docker                  |
| `F0868` |   󰡨  |  `&#xF0868;`  | docker                  |
|  `E81D` |     |   `&#xe81d;`  | kubernetes              |
|  `E7C5` |     |   `&#xE7C5;`  | vim                     |
|  `E62B` |     |   `&#xE62B;`  | vim                     |
|  `F194` |     |   `&#xF194;`  | vim                     |
|  `F27D` |     |   `&#xF27D;`  | vim                     |
|  `FA76` |  勇  |   `&#xFA76;`  | vim                     |
|  `FA77` |  勺  |   `&#xFA77;`  | vim                     |
|  `F194` |     |   `&#xF194;`  | vim                     |
|  `F1CA` |     |   `&#xF1CA;`  | vim                     |
|  `F36F` |     |   `&#xF36F;`  | neovim                  |
|  `E632` |     |   `&#xE632;`  | emacs                   |
|  `E235` |     |   `&#xE235;`  | python                  |
|  `E73C` |     |   `&#xe73c;`  | python                  |
|  `E879` |     |   `&#xE879;`  | python                  |
|  `e606` |     |   `&#xE606;`  | python
| `F0320` |   󰌠  |  `&#xF0320;`  | python                  |
|  `E73E` |     |   `&#xE73E;`  | markdown                |
|  `F853` |     |   `&#xF853;`  | markdown                |
| `F0354` |   󰍔  |  `&#xF0354;`  | markdown                |
| `F072F` |   󰜯  |  `&#xF072F;`  | markdown                |
| `F0DFB` |   󰷻  |  `&#xF0DFB;`  | markdown                |
|  `E673` |     |   `&#xE673;`  | makefile                |
|  `F858` |     |   `&#xF858;`  | maxcdn                  |
|  `F136` |     |   `&#xF136;`  | maxcdn                  |
|  `E616` |     |   `&#xE616;`  | npm                     |
| `F06F7` |   󰛷  |  `&#xF06F7;`  | npm                     |
|  `E767` |     |   `&#xE767;`  | jenkins                 |
|  `E66E` |     |   `&#xE66E;`  | jenkins                 |
|  `F2EC` |     |   `&#xF2EC;`  | *jenkins                |
|  `E7E9` |     |   `&#xE7E9;`  | pipeline/workflow       |
|  `E680` |     |   `&#xe680;`  | pipeline                |
|  `F4E5` |     |   `&#xF4E5;`  | png                     |
| `F0D78` |   󰵸  |  `&#xF0D78;`  | gif                     |
| `F0225` |   󰈥  |  `&#xF0225;`  | jpg                     |
| `F0E2D` |   󰸭  |  `&#xF0E2D;`  | png                     |
|  `E60D` |     |   `&#xE60D;`  | image                   |
| `F0226` |   󰈦  |  `&#xF0226;`  | pdf                     |
|  `F4A5` |     |   `&#xF4A5;`  | file                    |
|  `EB9D` |     |   `&#xEB9D;`  | file                    |
|  `F15C` |     |   `&#xF15C;`  | file                    |
|  `EAE8` |     |   `&#xEAE8;`  | file (binary)           |
|  `F471` |     |   `&#xF471;`  | file (binary)           |
|  `EA7F` |     |   `&#xEA7F;`  | new file                |
| `F1085` |   󱂅  |  `&#xF1085;`  | log                     |
|  `E67F` |     |   `&#xE67F;`  | Ps                      |
|  `E73D` |     |   `&#xE73D;`  | php                     |
| `F08C0` |   󰣀  |  `&#xF08C0;`  | ssh                     |
|  `E65D` |     |   `&#xe65d;`  | git                     |
|  `E702` |     |   `&#xe702;`  | git                     |
|  `E8C4` |     |   `&#xE8C4;`  | git                     |
|  `EFA0` |     |   `&#xEFA0;`  | git                     |
|  `F1D2` |     |   `&#xF1D2;`  | git                     |
|  `F1D3` |     |   `&#xF1D3;`  | git                     |
| `F02A2` |   󰊢  |  `&#xF02A2;`  | git                     |
|  `E776` |     |   `&#xE776;`  | nginx                   |
|  `E791` |     |   `&#xE791;`  | ruby                    |
|  `E739` |     |   `&#xE739;`  | ruby                    |
|  `E21E` |     |   `&#xE21E;`  | ruby                    |
|  `E719` |     |   `&#xE719;`  | node                    |
|  `ED44` |     |   `&#xED44;`  | node                    |
|  `ED48` |     |   `&#xED48;`  | less                    |
|  `E826` |     |   `&#xe826;`  | lua                     |
|  `E824` |     |   `&#xE824;`  | lodash                  |
|  `E7C3` |     |   `&#xE7C3;`  | rest                    |
|  `E7B5` |     |   `&#xE7B5;`  | intellij                |
|  `E75B` |     |   `&#xe75b;`  | sql                     |
| `F0AA9` |   󰪩  |  `&#xF0AA9;`  | database                |
| `F0AAA` |   󰪪  |  `&#xF0AAA;`  | database                |
|  `E8B0` |     |   `&#xE8B0;`  | database                |
|  `E7AA` |     |   `&#xE7AA;`  | S                       |
|  `E72C` |     |   `&#xE72C;`  | TC                      |
|  `E7BC` |     |   `&#xE7BC;`  | CS                      |
| `F0AAE` |   󰪮  |  `&#xF0AAE;`  | .net                    |
|  `E69B` |     |   `&#xE69B;`  | tex                     |
|  `E81F` |     |   `&#xE81F;`  | latex                   |
| `F044D` |   󰑍  |  `&#xF044D;`  | reddit                  |
|  `E74B` |     |   `&#xE74B;`  | saas                    |
|  `E704` |     |   `&#xE704;`  | mysql                   |
|  `E7A6` |     |   `&#xE7A6;`  | mysql                   |
| `F12A7` |   󱊧  |  `&#xF12A7;`  | 0x                      |
|  `E600` |     |   `&#xE600;`  | stylus                  |
|  `E759` |     |   `&#xE759;`  | dev stylus              |
|  `E0A0` |     |   `&#xe0a0;`  | git branch              |
|  `E725` |     |   `&#xE725;`  | git branch              |
|  `EA68` |     |   `&#xEA68;`  | git branch              |
| `F062C` |   󰘬  |  `&#xF062C;`  | git branch              |
|  `F126` |     |   `&#xF126;`  | git fork                |
|  `F418` |     |   `&#xF418;`  | git fork                |
| `F0CD0` |   󰳐  |  `&#xF0CD0;`  | git fork                |
|  `EA63` |     |   `&#xEA63;`  | git forked              |
| `F04C1` |   󰓁  |  `&#xF04C1;`  | git fork                |
|  `E727` |     |   `&#xE727;`  | git merge               |
|  `F419` |     |   `&#xF419;`  | git merge               |
|  `EAFE` |     |   `&#xEAFE;`  | git merge               |
|  `F17F` |     |   `&#xF17F;`  | git merge               |
| `F062D` |   󰘭  |  `&#xF062D;`  | git merge               |
|  `E728` |     |   `&#xE728;`  | git compare             |
|  `EAFD` |     |   `&#xEAFD;`  | git compare             |
|  `f47f` |     |   `&#xF47F;`  | git compare             |
|  `E729` |     |   `&#xE729;`  | git commit              |
|  `F417` |     |   `&#xF417;`  | git commit              |
|  `F4B6` |     |   `&#xF4B6;`  | git commit              |
|  `EAFC` |     |   `&#xEAFC;`  | git commit              |
| `F0718` |   󰜘  |  `&#xF0718;`  | git commit              |
|  `EB61` |     |   `&#xEB61;`  | git commit              |
| `F071B` |   󰜛  |  `&#xF071B;`  | git commit              |
| `F071C` |   󰜜  |  `&#xF071C;`  | git commit              |
| `F071D` |   󰜝  |  `&#xF071D;`  | git commit start        |
| `F0719` |   󰜙  |  `&#xF0719;`  | git commit end          |
| `F071A` |   󰜚  |  `&#xF071A;`  | git commit end          |
| `F10D9` |   󱃙  |  `&#xF10D9;`  | git commits             |
|  `f4c7` |     |   `&#xF4C7;`  | git network             |
|  `EA66` |     |   `&#xEA66;`  | git tag                 |
|  `F4CE` |     |   `&#xF4CE;`  | git tag                 |
|  `F412` |     |   `&#xF412;`  | git tag                 |
| `F04C2` |   󰓂  |  `&#xF04C2;`  | git pull                |
|  `E726` |     |   `&#xE726;`  | git pr                  |
|  `EA64` |     |   `&#xEA64;`  | git pr                  |
|  `F407` |     |   `&#xF407;`  | git pr                  |
|  `EBBC` |     |   `&#xEBBC;`  | git pr create           |
|  `EBDA` |     |   `&#xEBDA;`  | git pr close            |
|  `F4DC` |     |   `&#xF4DC;`  | git pr close            |
|  `EBDB` |     |   `&#xEBDB;`  | git pr draft            |
|  `F4DD` |     |   `&#xF4DD;`  | git pr draft            |
|  `F4DB` |     |   `&#xF4DB;`  | git merge query         |
|  `EC1D` |     |   `&#xEC1D;`  | git fetch               |
|  `EBAB` |     |   `&#xEBAB;`  | git merge               |
| `F14CF` |   󱓏  |  `&#xF14CF;`  | git branch check        |
| `F14CB` |   󱓋  |  `&#xF14CB;`  | git branch minus        |
| `F14CA` |   󱓊  |  `&#xF14CA;`  | git plus                |
| `F14CD` |   󱓍  |  `&#xF14CD;`  | git refresh             |
| `F14CC` |   󱓌  |  `&#xF14CC;`  | git remove              |
| `F14CE` |   󱓎  |  `&#xF14CE;`  | git sync                |
|  `EB8B` |     |   `&#xEB8B;`  | debug stackframe        |
|  `EB8A` |     |   `&#xEB8A;`  | dot                     |
|  `EB89` |     |   `&#xEB89;`  | debug stackframe active |
|  `EAA8` |     |   `&#xEAA8;`  | breakpoint              |
|  `EBA8` |     |   `&#xEBA8;`  | debug                   |
|  `EBC0` |     |   `&#xEBC0;`  | debug rerun             |
|  `EB25` |     |   `&#xEB25;`  | code no new line        |

### airline

| UNICODE |   ICON   | HTML ENCODING | COMMENTS                     |
|:-------:|:--------:|:-------------:|------------------------------|
|  `0246` |     Ɇ    |   `&#x0246;`   | `airline_symbols.notexists`  |
|  `2204` |     ∄    |   `&#x2204;`   | `airline_symbols.notexists`  |
|  `00DE` |     Þ    |   `&#x00DE;`   | `airline_symbols.paste`      |
|  `03C1` |     ρ    |   `&#x03C1;`   | `airline_symbols.paste`      |
|  `2225` |     ∥    |   `&#x2225;`   | `airline_symbols.paste`      |
|  `2387` |     ⎇    |   `&#x2387;`   | `airline_symbols.branch`     |
|  `E0A0` |         |   `&#xE0A0;`   | `airline_symbols.branch`     |
|  `E725` |         |   `&#xE725;`   | `airline_symbols.branch`     |
|  `29FC` |     ⧼    |   `&#x29FC;`   | `airline_symbols.branch`     |
|  `00B6` |     ¶    |   `&#x00B6;`   | `airline_symbols.linenr`     |
|  `240A` |     ␊    |   `&#x240A;`   | `airline_symbols.linenr`     |
|  `2424` | &#x2424; |   `&#x2424;`   | `airline_symbols.linenr`     |
|  `E0A1` |         |   `&#xE0A1;`   | `airline_symbols.linenr`     |
|  `2630` |    ☰    |   `&#x2630;`   | `airline_symbols.maxlinenr`  |
|  `33D1` |    ㏑    |   `&#x33D1;`   | `airline_symbols.maxlinenr`  |
|  `2105` |     ℅    |   `&#x2105;`   | `airline_symbols.colnr`      |
|  `33C7` |    ㏇    |   `&#x33C7;`   | `airline_symbols.colnr`      |
|  `039E` |     Ξ    |   `&#x039E;`   | `airline_symbols.whitespace` |
|  `A7A8` |     Ꞩ    |   `&#xA7A8;`   | `airline_symbols.spell`      |
|  `26A1` |    ⚡    |   `&#x26A1;`   | `airline_symbols.dirty`      |
|  `21AF` |     ↯    |   `&#x21AF;`   | `airline_symbols.dirty`      |
|  `266A` |     ♪    |   `&#x266A;`   | `airline_symbols.dirty`      |
|  `E0A2` |         |   `&#xE0A2;`   | `airline_symbols.readonly`   |
|  `E0B0` |         |   `&#xE0B0;`   | `airline_left_sep`           |
|  `E0B1` |         |   `&#xE0B1;`   | `airline_left_alt_sep`       |
|  `E0B2` |         |   `&#xE0B2;`   | `airline_right_sep`          |
|  `E0B3` |         |   `&#xE0B3;`   | `airline_right_alt_sep`      |
|  `2B60` |     ⭠    |   `&#x2B60;`   | `airline_symbols.branch`     |
|  `2B61` |     ⭡    |   `&#x2B61;`   | `airline_symbols.linenr`     |
|  `2B64` |     ⭤    |   `&#x2B64;`   | `airline_symbols.readonly`   |
|  `2B80` |     ⮀    |   `&#x2B80;`   | `airline_left_sep`           |
|  `2B81` |     ⮁    |   `&#x2B81;`   | `airline_left_alt_sep`       |
|  `2B82` |     ⮂    |   `&#x2B82;`   | `airline_right_sep`          |
|  `2B83` |     ⮃    |   `&#x2B83;`   | `airline_right_alt_sep`      |

### prompts

| UNICODE | ICON | HTML ENCODING |
|:-------:|:----:|:-------------:|
|  `EE00` |     |   `&#xEE00;`  |
|  `EE01` |     |   `&#xEE01;`  |
|  `EE02` |     |   `&#xEE02;`  |
|  `EE03` |     |   `&#xEE03;`  |
|  `EE04` |     |   `&#xEE04;`  |
|  `EE05` |     |   `&#xEE05;`  |
|  `EE06` |     |   `&#xEE06;`  |
|  `EE07` |     |   `&#xEE07;`  |
|  `EE08` |     |   `&#xEE08;`  |
|  `EE09` |     |   `&#xEE09;`  |
|  `EE0A` |     |   `&#xEE0A;`  |
|  `EE0B` |     |   `&#xEE0B;`  |
|  `E0D4` |     |   `&#xE0D4;`  |
|  `E0D2` |     |   `&#xE0D2;`  |
|  `E0D6` |     |   `&#xE0D6;`  |
|  `E0D7` |     |   `&#xE0D7;`  |
|  `E0C5` |     |   `&#xE0C5;`  |
|  `E0C4` |     |   `&#xE0C4;`  |
|  `E0C7` |     |   `&#xE0C7;`  |
|  `E0C6` |     |   `&#xE0C6;`  |
|  `E0CA` |     |   `&#xE0CA;`  |
|  `E0C8` |     |   `&#xE0C8;`  |
|  `E0CD` |     |   `&#xE0CD;`  |
|  `E0CC` |     |   `&#xE0CC;`  |
|  `E0C3` |     |   `&#xE0C3;`  |
|  `E0C1` |     |   `&#xE0C1;`  |
|  `E0C2` |     |   `&#xE0C2;`  |
|  `E0C0` |     |   `&#xE0C0;`  |
|  `E0BE` |     |   `&#xE0BE;`  |
|  `E0BA` |     |   `&#xE0BA;`  |
|  `E0B8` |     |   `&#xE0B8;`  |
|  `E0BC` |     |   `&#xE0BC;`  |
|  `E0B5` |     |   `&#xE0B5;`  |
|  `E0B7` |     |   `&#xE0B7;`  |
|  `E0B4` |     |   `&#xE0B4;`  |
|  `E0B6` |     |   `&#xE0B6;`  |
|  `E0B0` |     |   `&#xE0B0;`  |
|  `E0B2` |     |   `&#xE0B2;`  |
|  `E0B1` |     |   `&#xE0B1;`  |
|  `E0B3` |     |   `&#xE0B3;`  |


### diagnostic

| UNICODE | ICON | HTML ENCODING | COMMENTS                 |
|:-------:|:----:|:-------------:|--------------------------|
|  `2718` |   ✘  |   `&#x2718;`   | `diagnostic.errorSign`   |
|  `2714` |   ✔  |   `&#x2714;`   | -                        |
|  `14C6` |   ᓆ  |   `&#x14C6;`   | `diagnostic.infoSign`    |
|  `1479` |   ᑹ  |   `&#x1479;`   | `diagnostic.warningSign` |
|  `27A4` |   ➤  |   `&#x27A4;`   | `diagnostic.hintSign`    |

### ale

| UNICODE | ICON | HTML ENCODING | COMMENTS                 |
|:-------:|:----:|:-------------:|--------------------------|
| `1F4A2` |  💢  |   `&#x1F4A2;`  | `ale_sign_error`         |
|  `2718` |   ✘  |   `&#x2718;`   | `ale_sign_error`         |
| `1F47E` |  👾  |   `&#x1F47E;`  | `ale_sign_error`         |
| `1F4A3` |  💣  |   `&#x1F4A3;`  | `ale_sign_error`         |
| `1F645` |  🙅  |   `&#x1F645;`  | `ale_sign_error`         |
| `1F926` |  🤦  |   `&#x1F926;`  | `ale_sign_error`         |
|  `1479` |   ᑹ  |   `&#x1479;`   | `ale_sign_warning`       |
|  `26A0` |   ⚠  |   `&#x26A0;`   | `ale_sign_warning`       |
|  `2E2E` |   ⸮  |   `&#x2E2E;`   | `ale_sign_warning`       |
|  `2E18` |   ⸘  |   `&#x2E18;`   | `ale_sign_warning`       |
|  `2639` |   ☹  |   `&#x2639;`   | `ale_sign_warning`       |
|  `14C6` |   ᓆ  |   `&#x14C6;`   | `ale_sign_info`          |
|  `2365` |   ⍥  |   `&#x2365;`   | `ale_sign_style_error`   |
|  `14CD` |   ᓍ  |   `&#x14CD;`   | `ale_sign_style_warning` |

### syntastic

| UNICODE | ICON | HTML ENCODING  | COMMENTS                         |
|:-------:|:----:|:--------------:|----------------------------------|
|  `03CA` |   ϊ  |   `&#x03CA;`   | `syntastic_info_symbol`          |
|  `0835` |   ࠵  |   `&#x0835;`   | `syntastic_info_symbol`          |
|  `0CF2` |   ೲ  |   `&#x0CF2;`   | `syntastic_info_symbol`          |
|  `2717` |   ✗  |   `&#x2717;`   | `syntastic_error_symbol`         |
|  `0FBE` |   ྾  |   `&#x0FBE;`   | `syntastic_error_symbol`         |
|  `0B93` |   ஓ  |   `&#x0B93;`   | `syntastic_error_symbol`         |
|  `0BD0` |   ௐ  |   `&#x0BD0;`   | `syntastic_error_symbol`         |
|  `2368` |   ⍨  |   `&#x2368;`   | `syntastic_warning_symbol`       |
|  `14C6` |   ᓆ  |   `&#x14C6;`   | `syntastic_warning_symbol`       |
|  `14CD` |   ᓍ  |   `&#x14CD;`   | `syntastic_warning_symbol`       |
| `1063F` |   𐘿  |   `&#x1063F;`  | `syntastic_warning_symbol`       |
|  `2365` |   ⍥  |   `&#x2365;`   | `syntastic_style_error_symbol`   |
|  `0C20` |   ఠ  |   `&#x0C20;`   | `syntastic_style_warning_symbol` |
|  `2364` |   ⍤  |   `&#x2364;`   | `syntastic_style_warning_symbol` |
|  `0D60` |   ൠ  |   `&#x0D60;`   | `syntastic_style_warning_symbol` |

### vim-devicons

| UNICODE | ICON | HTML ENCODING | COMMENTS                                                           |
|:-------:|:----:|:-------------:|--------------------------------------------------------------------|
|  `F115` |     |   `&#xF115;`  | `DevIconsDefaultFolderOpenSymbol`                                  |
|  `F114` |     |   `&#xF114;`  | `WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol`               |
|  `E241` |     |   `&#xE241;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['log']`       |
|  `E60B` |     |   `&#xE60B;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['json']`      |
|  `F295` |     |   `&#xF295;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['md']`        |
| `F030B` |   󰌋  |  `&#xF030B;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['perm']`      |
|  `E005` |     |   `&#xE005;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['groovy']`    |
|  `E005` |     |   `&#xE005;`  | `WebDevIconsUnicodeDecorateFileNodesExactSymbols['jenkinsfile']`   |
| `F1183` |   󱆃  |  `&#xF1183;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['sh']`        |
| `F16A5` |     |  `&#xF16A5;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yaml']`      |
| `F16A5` |     |  `&#xF16A5;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['yml']`       |
|  `F1D3` |     |   `&#xF1D3;`  | `WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*git.*$']`    |
|  `E204` |     |   `&#xE204;`  | `WebDevIconsUnicodeDecorateFileNodesExtensionSymbols['gitcommit']` |
| `F0626` |   󰘦  |  `&#xF0626;`  | `WebDevIconsUnicodeDecorateFileNodesExactSymbols['devops']`        |
| `F0DFA` |   󰷺  |  `&#xF0DFA;`  | `WebDevIconsUnicodeDecorateFileNodesExactSymbols['vimrc.d']`       |
| `F1183` |   󱆃  |  `&#xF1183;`  | `WebDevIconsUnicodeDecorateFileNodesExactSymbols['vars']`          |
| `F0D6E` |   󰵮  |  `&#xF0D6E;`  | `WebDevIconsUnicodeDecorateFileNodesExactSymbols['src']`           |
|  `EA92` |     |   `&#xEA92;`  | `WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*ignore$']`   |
| `F1501` |   󱔁  |  `&#xF1501;`  | `WebDevIconsUnicodeDecorateFileNodesPatternSymbols['.*rc$']`       |


- `:echo g:WebDevIconsUnicodeDecorateFileNodesExtensionSymbols`

| UNICODE | ICON | HTML ENCODING | COMMENTS     |
|:-------:|:----:|:-------------:|--------------|
|  `03BB` |   λ  |   `&#x03BB;`  | ml           |
|  `03BB` |   λ  |   `&#x03BB;`  | mli          |
|  `E241` |     |   `&#xE241;`  | log          |
|  `E600` |     |   `&#xE600;`  | style        |
|  `E603` |     |   `&#xE603;`  | sass         |
|  `E603` |     |   `&#xE603;`  | scss         |
|  `E606` |     |   `&#xE606;`  | py           |
|  `E606` |     |   `&#xE606;`  | pyc          |
|  `E606` |     |   `&#xE606;`  | pyd          |
|  `E606` |     |   `&#xE606;`  | pyo          |
|  `E608` |     |   `&#xE608;`  | php          |
|  `E60B` |     |   `&#xE60B;`  | json         |
|  `E60B` |     |   `&#xE60B;`  | webmanifest  |
|  `E60C` |     |   `&#xE60C;`  | mjs          |
|  `E60D` |     |   `&#xE60D;`  | bmp          |
|  `E60D` |     |   `&#xE60D;`  | ico          |
|  `E60D` |     |   `&#xE60D;`  | jpg          |
|  `E60D` |     |   `&#xE60D;`  | webp         |
|  `E60E` |     |   `&#xE60E;`  | ejs          |
|  `E60E` |     |   `&#xE60E;`  | haml         |
|  `E60E` |     |   `&#xE60E;`  | htm          |
|  `E60E` |     |   `&#xE60E;`  | slim         |
|  `E60F` |     |   `&#xE60F;`  | hbs          |
|  `E60F` |     |   `&#xE60F;`  | mustache     |
|  `E614` |     |   `&#xE614;`  | less         |
|  `E615` |     |   `&#xE615;`  | bat          |
|  `E615` |     |   `&#xE615;`  | conf         |
|  `E615` |     |   `&#xE615;`  | ini          |
|  `E615` |     |   `&#xE615;`  | mk           |
|  `E615` |     |   `&#xE615;`  | toml         |
|  `E619` |     |   `&#xE619;`  | rss          |
|  `E61B` |     |   `&#xE61B;`  | coffee       |
|  `E61C` |     |   `&#xE61C;`  | twig         |
|  `E61D` |     |   `&#xE61D;`  | c++          |
|  `E61D` |     |   `&#xE61D;`  | cc           |
|  `E61D` |     |   `&#xE61D;`  | cp           |
|  `E61D` |     |   `&#xE61D;`  | cpp          |
|  `E61D` |     |   `&#xE61D;`  | cxx          |
|  `E61E` |     |   `&#xE61E;`  | c            |
|  `E61F` |     |   `&#xE61F;`  | hs           |
|  `E61F` |     |   `&#xE61F;`  | lhs          |
|  `E620` |     |   `&#xE620;`  | lua          |
|  `E624` |     |   `&#xE624;`  | jl           |
|  `E627` |     |   `&#xE627;`  | go           |
|  `E628` |     |   `&#xE628;`  | ts           |
|  `E62C` |     |   `&#xE62C;`  | elm          |
|  `E62D` |     |   `&#xE62D;`  | eex          |
|  `E62D` |     |   `&#xE62D;`  | ex           |
|  `E62D` |     |   `&#xE62D;`  | exs          |
|  `E62D` |     |   `&#xE62D;`  | heex         |
|  `E62D` |     |   `&#xE62D;`  | leex         |
|  `E706` |     |   `&#xE706;`  | db           |
|  `E706` |     |   `&#xE706;`  | dump         |
|  `E70C` |     |   `&#xE70C;`  | sln          |
|  `E70C` |     |   `&#xE70C;`  | suo          |
|  `E728` |     |   `&#xE728;`  | diff         |
|  `E736` |     |   `&#xE736;`  | html         |
|  `E737` |     |   `&#xE737;`  | scala        |
|  `E738` |     |   `&#xE738;`  | java         |
|  `E738` |     |   `&#xE738;`  | jenkinsfile  |
|  `E73E` |     |   `&#xE73E;`  | markdown     |
|  `E73E` |     |   `&#xE73E;`  | mdx          |
|  `E73E` |     |   `&#xE73E;`  | rmd          |
|  `E745` |     |   `&#xE745;`  | xul          |
|  `E749` |     |   `&#xE749;`  | css          |
|  `E74B` |     |   `&#xe74b;`  | sass         |
|  `E755` |     |   `&#xE755;`  | swift        |
|  `E755` |     |   `&#xE755;`  | xcplayground |
|  `E768` |     |   `&#xE768;`  | clj          |
|  `E768` |     |   `&#xE768;`  | cljc         |
|  `E769` |     |   `&#xE769;`  | pl           |
|  `E769` |     |   `&#xE769;`  | pm           |
|  `E769` |     |   `&#xE769;`  | t            |
|  `E76A` |     |   `&#xE76A;`  | cljs         |
|  `E76A` |     |   `&#xE76A;`  | end          |
|  `E781` |     |   `&#xE781;`  | js           |
|  `E791` |     |   `&#xE791;`  | gemspec      |
|  `E791` |     |   `&#xE791;`  | rake         |
|  `E791` |     |   `&#xE791;`  | rb           |
|  `E798` |     |   `&#xE798;`  | dart         |
|  `E7A2` |     |   `&#xE7A2;`  | awk          |
|  `E7A2` |     |   `&#xE7A2;`  | bash         |
|  `E7A2` |     |   `&#xE7A2;`  | csh          |
|  `E7A2` |     |   `&#xE7A2;`  | fish         |
|  `E7A2` |     |   `&#xE7A2;`  | ksh          |
|  `E7A2` |     |   `&#xE7A2;`  | ps1          |
|  `E7A2` |     |   `&#xE7A2;`  | zsh          |
|  `E7A7` |     |   `&#xE7A7;`  | f#           |
|  `E7A7` |     |   `&#xE7A7;`  | fs           |
|  `E7A7` |     |   `&#xE7A7;`  | fsi          |
|  `E7A7` |     |   `&#xE7A7;`  | fsscript     |
|  `E7A7` |     |   `&#xE7A7;`  | fsx          |
|  `E7A8` |     |   `&#xE7A8;`  | rlib         |
|  `E7A8` |     |   `&#xE7A8;`  | rs           |
|  `E7AF` |     |   `&#xE7AF;`  | d            |
|  `E7B1` |     |   `&#xE7B1;`  | erl          |
|  `E7B1` |     |   `&#xE7B1;`  | hrl          |
|  `E7B4` |     |   `&#xE7B4;`  | Ai           |
|  `E7B8` |     |   `&#xE7B8;`  | psb          |
|  `E7B8` |     |   `&#xE7B8;`  | psd          |
|  `E7BA` |     |   `&#xE7BA;`  | jsx          |
|  `E7BA` |     |   `&#xE7BA;`  | tsx          |
|  `E8BE` |     |   `&#xE8BE;`  | TEX          |
|  `E8D0` |     |   `&#xe8d0;`  | vlang        |
|  `E8D1` |     |   `&#xe8d1;`  | v            |
|  `E8EA` |     |   `&#xE8EA;`  | xml          |
|  `E8EB` |     |   `&#xE8EB;`  | yaml         |
|  `F0FD` |     |   `&#xF0FD;`  | h            |
|  `F0FD` |     |   `&#xF0FD;`  | hh           |
|  `F0FD` |     |   `&#xF0FD;`  | hpp          |
|  `F0FD` |     |   `&#xF0FD;`  | hxx          |
|  `F27D` |     |   `&#xF27D;`  | vim          |
|  `F295` |     |   `&#xF295;`  | md           |
|  `F2A6` |     |   `&#xF2A6;`  | groovy       |
|  `F2EC` |     |   `&#xF2EC;`  | Jenkinsfile  |
|  `F313` |     |   `&#xF313;`  | nix          |
|  `F472` |     |   `&#xF472;`  | sql          |
|  `F499` |     |   `&#xF499;`  | pp           |
|  `F80A` |     |   `&#xF80A;`  | pem          |
|  `FB68` |   ﭨ  |   `&#xFB68;`  | tex          |
|  `FCB9` |   ﲹ  |   `&#xFCB9;`  | sol          |
|  `FCD2` |   ﳒ  |   `&#xFCD2;`  | r            |
|  `FD42` |   ﵂  |   `&#xFD42;`  | vue          |
| `F030B` |   󰌋  |  `&#xF030B;`  | perm         |
| `F0DFA` |   󰷺  |  `&#xF0DFA;`  | snippets     |
| `F1183` |   󱆃  |  `&#xF1183;`  | sh           |
| `F16A5` |   󱚥  |  `&#xF16A5;`  | yaml         |
| `F16A5` |   󱚥  |  `&#xF16A5;`  | yml          |

- `:echo g:WebDevIconsUnicodeDecorateFileNodesExactSymbols`

| UNICODE | ICON | HTML ENCODING | COMMENTS                         |
|:-------:|:----:|:-------------:|----------------------------------|
|  `F27D` |     |   `&#xF27D;`  | .vimrc                           |
|  `E62B` |     |   `&#xE62B;`  | _gvimrc                          |
|  `E62B` |     |   `&#xE62B;`  | _vimrc                           |
|  `E62B` |     |   `&#xE62B;`  | .gvimrc                          |
| `F1183` |   󱆃  |  `&#xF1183;`  | vars                             |
|  `E702` |     |   `&#xE702;`  | .gitignore                       |
|  `E707` |     |   `&#xE707;`  | dropbox                          |
| `F030B` |   󰌋  |  `&#xF030B;`  | license                          |
|  `E607` |     |   `&#xE607;`  | procfile                         |
|  `E7A2` |     |   `&#xE7A2;`  | .bashprofile                     |
|  `E791` |     |   `&#xE791;`  | config.ru                        |
|  `E791` |     |   `&#xE791;`  | gemfile                          |
|  `E611` |     |   `&#xE611;`  | gruntfile.coffee                 |
|  `E702` |     |   `&#xE702;`  | COMMIT_EDITMSG                   |
| `F0D6E` |   󰵮  |  `&#xF0D6E;`  | src/dev                          |
|  `E702` |     |   `&#xE702;`  | .gitmodules                      |
| `F0DFA` |   󰷺  |  `&#xF0DFA;`  | snips                            |
|  `E615` |     |   `&#xE615;`  | makefile                         |
|  `E791` |     |   `&#xE791;`  | rakefile                         |
| `F0626` |   󰘦  |  `&#xF0626;`  | devops                           |
|  `E610` |     |   `&#xE610;`  | gulpfile.coffee                  |
|  `E611` |     |   `&#xE611;`  | gruntfile.js                     |
|  `E7A2` |     |   `&#xE7A2;`  | .zshenv                          |
|  `E611` |     |   `&#xE611;`  | gruntfile.ls                     |
|  `E718` |     |   `&#xE718;`  | node_modules                     |
|  `E610` |     |   `&#xE610;`  | gulpfile.js                      |
|  `E7A2` |     |   `&#xE7A2;`  | .bashrc                          |
| `F06A9` |   󰚩  |  `&#xF06A9;`  | robots.txt                       |
|  `E7A2` |     |   `&#xE7A2;`  | .zshrc                           |
|  `E62D` |     |   `&#xE62D;`  | mix.lock                         |
|  `E610` |     |   `&#xE610;`  | gulpfile.ls                      |
|  `E7B0` |     |   `&#xE7B0;`  | docker-compose.yml               |
|  `E702` |     |   `&#xE702;`  | .gitconfig                       |
|  `E702` |     |   `&#xE702;`  | .gitattributes                   |
|  `E7BA` |     |   `&#xE7BA;`  | react.jsx                        |
|  `E7B0` |     |   `&#xE7B0;`  | dockerfile                       |
|  `E7A2` |     |   `&#xE7A2;`  | .zprofile                        |
|  `E615` |     |   `&#xE615;`  | cmakelists.txt                   |
|  `E615` |     |   `&#xE615;`  | .ds_store                        |
|  `E623` |     |   `&#xE623;`  | favicon.ico                      |
|  `0031` |   1  |   `&#x0031;`  | exact-match-case-sensitive-1.txt |
|  `0032` |   2  |   `&#x0032;`  | exact-match-case-sensitive-2     |

## folders

| UNICODE | ICON | HTML ENCODING | COMMENTS       |
|:-------:|:----:|:-------------:|----------------|
|  `F07B` |     |   `&#xF07B;`  | close          |
|  `F07C` |     |   `&#xF07C;`  | open           |
|  `F114` |     |   `&#xF114;`  | close          |
|  `y115` |     |   `&#xF115;`  | open           |
|  `F067` |     |   `&#xF067;`  | close (+)      |
|  `F068` |     |   `&#xF068;`  | open (-)       |
|  `F45B` |     |   `&#xF45B;`  | open (-)       |
|  `F2D1` |     |   `&#xF2D1;`  | open (-)       |
|  `F48B` |     |   `&#xF48B;`  | open (-)       |
|  `E5FE` |     |   `&#xE5FE;`  | open           |
|  `E5FF` |     |   `&#xE5FF;`  | close          |
|  `E5FA` |     |   `&#xE5FA;`  | closed (npm)   |
|  `E5FB` |     |   `&#xE5FB;`  | close (git)    |
|  `e5fd` |     |   `&#xE5FD;`  | close (github) |
|  `E5FC` |     |   `&#xE5FC;`  | closed (tools) |
|  `E787` |     |   `&#xE787;`  | book           |
|  `EA80` |     |   `&#xEA80;`  | new folder     |
|  `EA83` |     |   `&#xEA83;`  | folder         |
|  `EF81` |     |   `&#xEF81;`  | folder tree    |
|  `F0E8` |     |   `&#xF0E8;`  | folder tree    |
| `F06CF` |   󰛏  |  `&#xF06CF;`  | folder!        |
|  `F50F` |     |   `&#xF50F;`  | share          |
|  `F1E0` |     |   `&#xF1E0;`  | share          |
|  `F1E1` |     |   `&#xF1E1;`  | share          |

## platform

| UNICODE | ICON | HTML ENCODING | COMMENTS    |
|:-------:|:----:|:-------------:|-------------|
|  `F302` |     |   `&#xF302;`  | mac         |
|  `E711` |     |   `&#xE711;`  | mac         |
|  `F8FF` |     |   `&#xF8FF;`  | mac         |
| `F0037` |   󰀷  |  `&#xF0037;`  | ios         |
|  `F316` |     |   `&#xF316;`  | redhat      |
|  `E7BB` |     |   `&#xE7BB;`  | redhat      |
|  `E712` |     |   `&#xE712;`  | linux       |
|  `F31A` |     |   `&#xF31A;`  | linux       |
|  `EBC6` |     |   `&#xEBC6;`  | linux       |
|  `F17C` |     |   `&#xF17C;`  | linux       |
| `F033D` |   󰌽  |  `&#xF033D;`  | linux       |
|  `F314` |     |   `&#xF314;`  | opensuse    |
|  `F31B` |     |   `&#xF31B;`  | ubuntu      |
|  `EBC9` |     |   `&#xEBC9;`  | ubuntu      |
|  `F31C` |     |   `&#xF31C;`  | ubuntu      |
|  `E73A` |     |   `&#xE73A;`  | ubuntu      |
|  `E62A` |     |   `&#xE62A;`  | windows     |
|  `F17A` |     |   `&#xF17A;`  | windows     |
|  `E70F` |     |   `&#xE70F;`  | windows     |
| `F05B3` |   󰖳  |  `&#xF05B3;`  | windows     |
| `F0A21` |   󰨡  |  `&#xF0A21;`  | windows     |
|  `EBC5` |     |   `&#xEBC5;`  | debian      |
|  `F306` |     |   `&#xF306;`  | debian      |
|  `E77D` |     |   `&#xE77D;`  | debian      |
|  `E722` |     |   `&#xE722;`  | RPi         |
|  `EF5C` |     |   `&#xEF5C;`  | RPi         |
|  `F304` |     |   `&#xF304;`  | centos      |
|  `E70E` |     |   `&#xE70E;`  | android     |
|  `F17B` |     |   `&#xF17B;`  | android     |

## math

| UNICODE | ICON | HTML ENCODING | COMMENTS      |
|:-------:|:----:|:-------------:|---------------|
|  `F89F` |     |   `&#xF89F;`  | 123           |
| `F03A0` |   󰎠  |  `&#xF03A0;`  | 123           |
|  `F4F7` |     |   `&#xF4F7;`  | 123           |
| `F172A` |   󱜪  |  `&#xF172A;`  | 5.1.2         |
| `F07F0` |   󰟰  |  `&#xf07f0;`  | 2.0           |
| `F1729` |   󱜩  |  `&#xF1729;`  | 2.1           |
| `F07F1` |   󰟱  |  `&#xF07F1;`  | 3.1           |
| `F07F2` |   󰟲  |  `&#xF07F2;`  | 5.1           |
| `F07F3` |   󰟳  |  `&#xF07F3;`  | 7.1           |
| `F0199` |   󰆙  |  `&#xF0199;`  | 123           |
| `F1052` |   󱁒  |  `&#xF1052;`  | -1            |
| `F15CB` |   󱗋  |  `&#xF15CB;`  | +1            |
|  `FF10` |  １  |   `&#xFF10;`  | 1             |
|  `FF11` |  ２  |   `&#xFF11;`  | 2             |
|  `FF12` |  ３  |   `&#xFF12;`  | 3             |
|  `FF13` |  ４  |   `&#xFF13;`  | 4             |
|  `FF14` |  ５  |   `&#xFF14;`  | 5             |
|  `FF15` |  ６  |   `&#xFF15;`  | 6             |
|  `FF16` |  ７  |   `&#xFF16;`  | 7             |
|  `FF17` |  ８  |   `&#xFF17;`  | 8             |
|  `FF18` |  ９  |   `&#xFF18;`  | 9             |
| `F0F10` |   󰼐  |  `&#xF0F10;`  | 2             |
| `F0F11` |   󰼑  |  `&#xF0F11;`  | 3             |
| `F0F12` |   󰼒  |  `&#xF0F12;`  | 4             |
| `F0F13` |   󰼓  |  `&#xF0F13;`  | 5             |
| `F0F14` |   󰼔  |  `&#xF0F14;`  | 6             |
| `F0F15` |   󰼕  |  `&#xF0F15;`  | 7             |
| `F0F16` |   󰼖  |  `&#xF0F16;`  | 8             |
| `F0F17` |   󰼗  |  `&#xF0F17;`  | 9             |
| `F0F18` |   󰼘  |  `&#xF0F18;`  | 9+            |
| `F03C0` |   󰏀  |  `&#xF03C0;`  | 9+            |
| `F0FEE` |   󰿮  |  `&#xF0FEE;`  | 9+
| `F0FED` |   󰿭  |  `&#xF0FED;`  | 10            |
| `F0FEC` |   󰿬  |  `&#xF0FEC;`  | 10            |
| `F0FEB` |   󰿫  |  `&#xF0FEB;`  | 10            |
| `F0FEA` |   󰿪  |  `&#xF0FEA;`  | 10            |
| `F1153` |   󱅓  |  `&#xF1153;`  | 10            |
| `F0FE9` |   󰿩  |  `&#xF0FE9;`  | 10            |
| `F0D71` |   󰵱  |  `&#xF0D71;`  | 10            |
| `F0AD2` |   󰫒  |  `&#xF0AD2;`  | 09            |
|  `207F` |   ⁿ  |   `&#x207F;`  | ^n            |
|  `00BA` |   º  |    `&#xBA;`   | ^0            |
|  `00B9` |   ¹  |    `&#xB9;`   | ^1            |
|  `00B2` |   ²  |    `&#xB2;`   | ^2            |
|  `00B3` |   ³  |    `&#xB3;`   | ^3            |
|  `2074` |   ⁴  |   `&#x2074;`  | ^4            |
|  `2075` |   ⁵  |   `&#x2075;`  | ^5            |
|  `2076` |   ⁶  |   `&#x2076;`  | ^6            |
|  `2077` |   ⁷  |   `&#x2077;`  | ^7            |
|  `2078` |   ⁸  |   `&#x2078;`  | ^8            |
|  `2079` |   ⁹  |   `&#x2079;`  | ^9            |
|  `2070` |   ⁰  |   `&#x2070;`  | ^0            |
|  `2080` |   ₀  |   `&#x2080;`  | _0            |
|  `2081` |   ₁  |   `&#x2081;`  | _1            |
|  `2082` |   ₂  |   `&#x2082;`  | _2            |
|  `2083` |   ₃  |   `&#x2083;`  | _3            |
|  `2084` |   ₄  |   `&#x2084;`  | _4            |
|  `2085` |   ₅  |   `&#x2085;`  | _5            |
|  `2086` |   ₆  |   `&#x2086;`  | _6            |
|  `2087` |   ₇  |   `&#x2087;`  | _7            |
|  `2088` |   ₈  |   `&#x2088;`  | _8            |
|  `2089` |   ₉  |   `&#x2089;`  | _9            |
| `F12AB` |   󱊫  |  `&#xF12AB;`  | F1            |
| `F12AC` |   󱊬  |  `&#xF12AC;`  | F2            |
| `F12AD` |   󱊭  |  `&#xF12AD;`  | F3            |
| `F12AE` |   󱊮  |  `&#xF12AE;`  | F4            |
| `F12AF` |   󱊯  |  `&#xF12AF;`  | F5            |
| `F12B0` |   󱊰  |  `&#xF12B0;`  | F6            |
| `F12B1` |   󱊱  |  `&#xF12B1;`  | F7            |
| `F12B2` |   󱊲  |  `&#xF12B2;`  | F8            |
| `F12B3` |   󱊳  |  `&#xF12B3;`  | F9            |
| `F12B4` |   󱊴  |  `&#xF12B4;`  | F10           |
| `F12B5` |   󱊵  |  `&#xF12B5;`  | F11           |
| `F12B6` |   󱊶  |  `&#xF12B6;`  | F12           |
|  `215F` |   ⅟  |   `&#x215F;`  | 1/            |
|  `2189` |   ↉  |   `&#x2189;`  | 0/3           |
| `F1992` |   󱦒  |  `&#xF1992;`  | 1/2           |
|   `BD`  |   ½  |    `&#xBD;`   | 1/2           |
|  `2153` |   ⅓  |   `&#x2153;`  | 1/3           |
|  `2154` |   ⅔  |   `&#x2154;`  | 2/3           |
|   `BC`  |   ¼  |    `&#xBC;`   | 1/4           |
|   `BE`  |   ¾  |    `&#xBE;`   | 3/4           |
|  `2155` |   ⅕  |   `&#x2155;`  | 1/5           |
|  `2156` |   ⅖  |   `&#x2156;`  | 2/5           |
|  `2157` |   ⅗  |   `&#x2157;`  | 3/5           |
|  `2158` |   ⅘  |   `&#x2158;`  | 4/5           |
|  `2159` |   ⅙  |   `&#x2159;`  | 1/6           |
|  `215A` |   ⅚  |   `&#x215A;`  | 5/6           |
|  `2150` |   ⅐  |   `&#x2150;`  | 1/7           |
|  `215B` |   ⅛  |   `&#x215B;`  | 1/8           |
|  `215C` |   ⅜  |   `&#x215C;`  | 3/8           |
|  `215D` |   ⅝  |   `&#x215D;`  | 5/8           |
|  `215E` |   ⅞  |   `&#x215E;`  | 7/8           |
|  `2151` |   ⅑  |   `&#x2151;`  | 1/9           |
|  `2152` |   ⅒  |   `&#x2152;`  | 1/10          |
| `F01C9` |   󰇉  |  `&#xF01C9;`  | A/B           |
| `10138` |   𐄸  |  `&#x10138;`  | 22            |
| `F10A2` |   󱂢  |  `&#xF10A2;`  | .00           |
| `F01B5` |   󰆵  |  `&#xF01B5;`  | .00           |
| `F10A4` |   󱂤  |  `&#xF10A4;`  | .00           |
| `F10A3` |   󱂣  |  `&#xF10A3;`  | .0            |
|  `208C` |   ₌  |   `&#x208C;`  | _=            |
|  `208D` |   ₍  |   `&#x208D;`  | _(            |
|  `208E` |   ₎  |   `&#x208E;`  | _)            |
|  `207A` |   ⁺  |   `&#x207A;`  | ^+            |
|  `208A` |   ₊  |   `&#x208A;`  | _+            |
|  `FE62` |  ﹢  |   `&#xFE62;`  | +             |
|  `FF0B` |  ＋  |   `&#xFF0B;`  | +             |
| `F0195` |   󰆕  |  `&#xF0195;`  | +/-           |
| `F14C9` |   󱓉  |  `&#xF14C9;`  | +/-           |
|   `B1`  |   ±  |    `&#xB1;`   | +-            |
|  `F440` |     |   `&#xF440;`  | +-            |
|  `eb43` |     |   `&#xEB43;`  | +-            |
| `F0993` |   󰦓  |  `&#xF0993;`  | +-            |
| `F0A9A` |   󰪚  |  `&#xF0A9A;`  | +-x÷          |
|  `2213` |   ∓  |   `&#x2213;`  | -+            |
|  `2214` |   ∔  |   `&#x2214;`  | .+            |
|  `29FA` |   ⧺  |   `&#x29FA;`  | ++            |
|  `29FB` |   ⧻  |   `&#x29FB;`  | +++           |
|  `EB64` |     |   `&#xEB64;`  | +-x%          |
| `F11D6` |   󱇖  |  `&#xF11D6;`  | xx strategy   |
|  `2295` |   ⊕  |   `&#x2295;`  | O+            |
|  `2A01` |   ⨁  |   `&#x2A01;`  | O+            |
|  `2A22` |   ⨢  |   `&#x2A22;`  | o+            |
|  `2A2D` |   ⨭  |   `&#x2A2D;`  | (+            |
|  `2ABF` |   ⪿  |   `&#x2ABF;`  | (+            |
|  `2AC0` |   ⫀  |   `&#x2AC0;`  | )+            |
|  `2A2E` |   ⨮  |   `&#x2A2E;`  | )+            |
|  `2A23` |   ⨣  |   `&#x2A23;`  | ^+            |
|  `2A24` |   ⨤  |   `&#x2A24;`  | ~+            |
|  `2A25` |   ⨥  |   `&#x2A25;`  | +.            |
|  `2A26` |   ⨦  |   `&#x2A26;`  | +~            |
|  `2A27` |   ⨧  |   `&#x2A27;`  | +2            |
|  `2A28` |   ⨨  |   `&#x2A28;`  | +^            |
|  `2A39` |   ⨹  |   `&#x2A39;`  | triangle +    |
|  `2A3A` |   ⨺  |   `&#x2A3A;`  | triangle -    |
|  `25EC` |   ◬  |   `&#x25EC;`  | triangle .    |
|  `29CC` |   ⧌  |   `&#x29CC;`  | triangle s    |
|  `2A71` |   ⩱  |   `&#x2A71;`  | =+            |
|  `2A72` |   ⩲  |   `&#x2A72;`  | +=            |
|  `223B` |   ∻  |   `&#x223B;`  | ÷             |
|   `F7`  |   ÷  |    `&#xF7;`   | ÷             |
|  `EDF3` |     |   `&#xEDF3;`  | ÷             |
| `F01D5` |   󰇕  |  `&#xF01D5;`  | ÷             |
| `F12EA` |   󱋪  |  `&#xF12EA;`  | ÷             |
|  `2A2B` |   ⨫  |   `&#x2A2B;`  | ÷             |
|  `2A2C` |   ⨬  |   `&#x2A2C;`  | ÷             |
|  `2A6A` |   ⩪  |   `&#x2A6A;`  | half ÷        |
|  `2A6B` |   ⩫  |   `&#x2A6B;`  | ÷             |
|  `2238` |   ∸  |   `&#x2238;`  | half ÷        |
|  `2A2A` |   ⨪  |   `&#x2A2A;`  | half ÷        |
|  `2A38` |   ⨸  |   `&#x2A38;`  | O/            |
|  `29BC` |   ⦼  |   `&#x29BC;`  | o/            |
|  `2215` |   ∕  |   `&#x2215;`  | /             |
|  `2242` |   ≂  |   `&#x2242;`  | -~            |
|  `2A6C` |   ⩬  |   `&#x2A6C;`  | ~-~           |
|  `FF5E` |  ～  |   `&#xFF5E;`  | ~             |
| `F0963` |   󰥣  |  `&#xF0963;`  | x^y           |
| `F0964` |   󰥤  |  `&#xF0964;`  | x^y           |
|  `F12B` |     |   `&#xF12B;`  | x^2           |
| `F0283` |   󰊃  |  `&#xF0283;`  | x^2           |
|  `F12C` |     |   `&#xF12C;`  | x2 subscript  |
| `F0282` |   󰊂  |  `&#xF0282;`  | x2 subscript  |
|  `F506` |     |   `&#xF506;`  | ./            |
| `F016C` |   󰅬  |  `&#xF016C;`  | >             |
| `F016E` |   󰅮  |  `&#xF016E;`  | <             |
|  `2A7B` |   ⩻  |   `&#x2A7B;`  | <?            |
|  `2A7C` |   ⩼  |   `&#x2A7C;`  | >?            |
| `F016D` |   󰅭  |  `&#xF016D;`  | >=            |
| `F096E` |   󰥮  |  `&#xF096E;`  | >=            |
| `F097D` |   󰥽  |  `&#xF097D;`  | <=            |
|  `2264` |   ≤  |   `&#x2264;`  | <=            |
|  `EFC4` |     |   `&#xEFC4;`  | <=            |
|  `2265` |   ≥  |   `&#x2265;`  | >=            |
|  `2266` |   ≦  |   `&#x2266;`  | <=            |
|  `2267` |   ≧  |   `&#x2267;`  | >=            |
|  `2A95` |   ⪕  |   `&#x2A95;`  | <=            |
|  `2A96` |   ⪖  |   `&#x2A96;`  | >=            |
|  `2A7D` |   ⩽  |   `&#x2A7D;`  | <=            |
|  `2A7E` |   ⩾  |   `&#x2A7E;`  | >=            |
|  `2A85` |   ⪅  |   `&#x2A85;`  | <=            |
|  `2A86` |   ⪆  |   `&#x2A86;`  | >=            |
|  `2A8B` |   ⪋  |   `&#x2A8B;`  | <=            |
|  `2A8C` |   ⪌  |   `&#x2A8C;`  | >=            |
|  `2A8D` |   ⪍  |   `&#x2A8D;`  | <=            |
|  `2A8E` |   ⪎  |   `&#x2A8E;`  | >=            |
|  `2A99` |   ⪙  |   `&#x2A99;`  | <=            |
|  `2A9A` |   ⪚  |   `&#x2A9A;`  | >=            |
|  `2268` |   ≨  |   `&#x2268;`  | <!=           |
|  `2269` |   ≩  |   `&#x2269;`  | >!=           |
|  `226A` |   ≪  |   `&#x226A;`  | <<            |
|  `226B` |   ≫  |   `&#x226B;`  | >>            |
|  `2AA1` |   ⪡  |   `&#x2AA1;`  | <<            |
|  `2AA2` |   ⪢  |   `&#x2AA2;`  | >>            |
|  `2AA3` |   ⪣  |   `&#x2AA3;`  | <<            |
|  `2AA4` |   ⪤  |   `&#x2AA4;`  | ><            |
|  `2AA5` |   ⪥  |   `&#x2AA5;`  | ><            |
|  `22D8` |   ⋘  |   `&#x22D8;`  | <<<           |
|  `22D9` |   ⋙  |   `&#x22D9;`  | >>>           |
|  `2A7F` |   ⩿  |   `&#x2A7F;`  | <<<           |
|  `2A80` |   ⪀  |   `&#x2A80;`  | >>>           |
|  `2270` |   ≰  |   `&#x2270;`  | !<=           |
|  `2271` |   ≱  |   `&#x2271;`  | !>=           |
|  `2272` |   ≲  |   `&#x2272;`  | ~<            |
|  `2273` |   ≳  |   `&#x2273;`  | ~>            |
|  `227E` |   ≾  |   `&#x227E;`  | !~            |
|  `227F` |   ≿  |   `&#x227F;`  | !~            |
|  `227D` |   ≽  |   `&#x227D;`  | !~            |
|  `2280` |   ⊀  |   `&#x2280;`  | !>            |
|  `2281` |   ⊁  |   `&#x2281;`  | !<            |
|  `2A87` |   ⪇  |   `&#x2A87;`  | >!~           |
|  `2A88` |   ⪈  |   `&#x2A88;`  | <!~           |
|  `22E6` |   ⋦  |   `&#x22E6;`  | <!~           |
|  `22E7` |   ⋧  |   `&#x22E7;`  | >!~
|  `22E8` |   ⋨  |   `&#x22E8;`  | <~!           |
|  `22E9` |   ⋩  |   `&#x22E9;`  | !~>           |
|  `2274` |   ≴  |   `&#x2274;`  | !~<           |
|  `2275` |   ≵  |   `&#x2275;`  | !~>           |
|  `2278` |   ≸  |   `&#x2278;`  | !<>           |
|  `29C0` |   ⧀  |   `&#x29C0;`  | O<            |
|  `29C1` |   ⧁  |   `&#x29C1;`  | O>            |
|  `2A79` |   ⩹  |   `&#x2A79;`  | o>            |
|  `2A7A` |   ⩺  |   `&#x2A7A;`  | o<            |
| `F016F` |   󰅯  |  `&#xF016F;`  | <=            |
|  `2A73` |   ⩳  |   `&#x2A73;`  | =+            |
|  `2A74` |   ⩴  |   `&#x2A74;`  | ::=           |
|  `2A75` |   ⩵  |   `&#x2A75;`  | ==            |
| `F016B` |   󰅫  |  `&#xF016B;`  | ==            |
|  `2A76` |   ⩶  |   `&#x2A76;`  | ===           |
|  `2338` |   ⌸  |   `&#x2338;`  | ==            |
|  `E279` |     |   `&#xE279;`  | =             |
|  `2260` |   ≠  |   `&#x2260;`  | !=            |
|  `2262` |   ≢  |   `&#x2262;`  | !=            |
|  `236F` |   ⍯  |   `&#x236F;`  | !=            |
|  `EFCB` |     |   `&#xEFCB;`  | !=            |
| `F0170` |   󰅰  |  `&#xF0170;`  | !=            |
| `F098D` |   󰦍  |  `&#xF098D;`  | !=            |
| `F098E` |   󰦎  |  `&#xF098E;`  | !=            |
|  `29E3` |   ⧣  |   `&#x29E3;`  | //==          |
|  `2248` |   ≈  |   `&#x2248;`  | ~=            |
|  `2249` |   ≉  |   `&#x2249;`  | !~=           |
|  `223C` |   ∼  |   `&#x223C;`  | ~             |
|  `223D` |   ∽  |   `&#x223D;`  | ~             |
|  `223E` |   ∾  |   `&#x223E;`  | ~             |
|  `2241` |   ≁  |   `&#x2241;`  | !~            |
|  `22CD` |   ⋍  |   `&#x22CD;`  | ~=            |
|  `2244` |   ≄  |   `&#x2244;`  | !~=           |
|  `224C` |   ≌  |   `&#x224C;`  | ~==           |
|  `2247` |   ≇  |   `&#x2247;`  | !~==          |
|  `225F` |   ≟  |   `&#x225F;`  | =?            |
|  `FE15` |  ︕  |   `&#xFE15;`  | !             |
|  `FF01` |  ！  |   `&#xFF01;`  | !             |
|  `FE16` |  ︖  |   `&#xFE16;`  | ?             |
| `F0A3D` |   󰨽  |  `&#xF0A3D;`  | information   |
| `F0C96` |   󰲖  |  `&#xF0C96;`  | cos           |
| `F0C97` |   󰲗  |  `&#xF0C97;`  | sin           |
| `F0C98` |   󰲘  |  `&#xF0C98;`  | tan           |
| `F09A3` |   󰦣  |  `&#xF09A3;`  | square root   |
| `F0784` |   󰞄  |  `&#xF0784;`  | square root   |
|  `EEE0` |     |   `&#xEEE0;`  | square root   |
|  `F8FE` |     |   `&#xF8FE;`  | pi            |
|  `E22C` |     |   `&#xE22C;`  | pi            |
| `F03FF` |   󰏿  |  `&#xF03FF;`  | pi            |
| `F0400` |   󰐀  |  `&#xF0400;`  | pi            |
| `F0627` |   󰘧  |  `&#xF0627;`  | lambda        |
|  `E6B1` |     |   `&#xE6B1;`  | lambda        |
| `104E0` |   𐓠  |   `&#104E0;`  | alpha         |
| `F00A1` |   󰂡  |  `&#xF00A1;`  | beta          |
| `F10EE` |   󱃮  |  `&#xF10EE;`  | gamma         |
| `F04A0` |   󰒠  |  `&#xF04A0;`  | sigma         |
| `F03C9` |   󰏉  |  `&#xF03C9;`  | omega         |
| `102C8` |   𐋈  |   `&#102C8;`  | ∵             |
| `10B3A` |   𐬺  |   `&#10B3A;`  | ∴             |
| `10B3B` |   𐬻  |   `&#10B3B;`  | ∵             |
| `10B3C` |   𐬼  |   `&#10B3C;`  | ∵             |
| `10B3D` |   𐬽  |   `&#10B3D;`  | ∴             |
| `10B3E` |   𐬾  |   `&#10B3E;`  | ∵             |
| `10B3F` |   𐬿  |   `&#10B3F;`  | ∴             |
| `F0FC9` |   󰿉  |  `&#xF0FC9;`  | function      |
|  `2A0D` |   ⨍  |   `&#x2A0D;`  | function      |
|  `2A0E` |   ⨎  |   `&#x2A0E;`  | function      |
|  `2A0F` |   ⨏  |   `&#x2A0F;`  | function      |
|  `2A17` |   ⨗  |   `&#x2A17;`  | function      |
|  `2A18` |   ⨘  |   `&#x2A18;`  | function x    |
|  `2A19` |   ⨙  |   `&#x2A19;`  | function      |
| `F0295` |   󰊕  |  `&#xF0295;`  | function      |
| `F0871` |   󰡱  |  `&#xF0871;`  | function of x |
| `1D6FB` |   𝛻  |  `&#x1D6FB;`  | nabla         |
| `F002B` |   󰀫  |  `&#xF002B;`  | alpha         |
| `1D6FC` |   𝛼  |  `&#x1D6FC;`  | alpha         |
| `1D6FD` |   𝛽  |  `&#x1D6FD;`  | beta          |
| `1D6FE` |   𝛾  |  `&#x1D6FE;`  | gamma         |
| `1D6FF` |   𝛿  |  `&#x1D6FF;`  | delta         |
| `1D700` |   𝜀  |  `&#x1D700;`  | epsilon       |
| `1D701` |   𝜁  |  `&#x1D701;`  | zeta          |
| `1D702` |   𝜂  |  `&#x1D702;`  | eta           |
| `1D703` |   𝜃  |  `&#x1D703;`  | theta         |
| `1D704` |   𝜄  |  `&#x1D704;`  | iota          |
| `1D705` |   𝜅  |  `&#x1D705;`  | kappa         |
| `1D706` |   𝜆  |  `&#x1D706;`  | lambda        |
| `1D707` |   𝜇  |  `&#x1D707;`  | mu            |
| `1D708` |   𝜈  |  `&#x1D708;`  | nu            |
| `1D709` |   𝜉  |  `&#x1D709;`  | xi            |
| `1D70A` |   𝜊  |  `&#x1D70A;`  | omicron       |
| `1D70B` |   𝜋  |  `&#x1D70B;`  | pi            |
| `1D70C` |   𝜌  |  `&#x1D70C;`  | rho           |
| `1D70D` |   𝜍  |  `&#x1D70D;`  | sigma         |
| `1D70E` |   𝜎  |  `&#x1D70E;`  | tau           |
| `1D70F` |   𝜏  |  `&#x1D70F;`  | upsilon       |
| `1D710` |   𝜐  |  `&#x1D710;`  | phi           |
| `1D711` |   𝜑  |  `&#x1D711;`  | chi           |

## graph

| UNICODE | ICON | HTML ENCODING | COMMENTS          |
|:-------:|:----:|:-------------:|-------------------|
|  `EB1F` |     |   `&#xEB1F;`  | @                 |
|  `F486` |     |   `&#xF486;`  | @                 |
|  `F4BC` |     |   `&#xF4BC;`  | chip - cpu        |
|  `F85A` |     |   `&#xF85A;`  | chip - cpu        |
| `F035B` |   󰍛  |  `&#xF035B;`  | chip - cpu        |
|  `E266` |     |   `&#xE266;`  | chip              |
|  `EC19` |     |   `&#xEC19;`  | chip              |
|  `F2DB` |     |   `&#xF2DB;`  | chip              |
| `F061A` |   󰘚  |  `&#xF061A;`  | chip              |
| `F0EDF` |   󰻟  |  `&#xF0EDF;`  | chip - 32bit      |
| `F0EE0` |   󰻠  |  `&#xF0EE0;`  | chip - 64bit      |
| `F1362` |   󱍢  |  `&#xF1362;`  | google downasaur  |
| `F1362` |   󱍢  |  `&#xF1362;`  | google downasaur  |
| `F02A0` |   󰊠  |  `&#xF02A0;`  | ghost             |
|  `E241` |     |   `&#xE241;`  | footprint         |
| `F0DFA` |   󰷺  |  `&#xF0DFA;`  | footprint         |
|  `EE14` |     |   `&#xEE14;`  | footprint/step    |
|  `E69E` |     |   `&#xE69E;`  | foot              |
|  `F361` |     |   `&#xF361;`  | foot              |
| `F02AC` |   󰊬  |  `&#xF02AC;`  | foot              |
| `F0F52` |   󰽒  |  `&#xF0F52;`  | foot              |
| `F169D` |   󱚝  |  `&#xF169D;`  | robot angry       |
| `F169E` |   󱚞  |  `&#xF169E;`  | robot angry       |
| `F169F` |   󱚟  |  `&#xF169F;`  | robot confused !? |
| `F16A0` |   󱚠  |  `&#xF16A0;`  | robot confused !? |
| `F16A1` |   󱚡  |  `&#xF16A1;`  | robot dead        |
| `F16A2` |   󱚢  |  `&#xF16A2;`  | robot dead        |
| `F1719` |   󱜙  |   `&#F1719;`  | robot happy       |
| `F171A` |   󱜚  |   `&#F171A;`  | robot happy       |
| `F16A3` |   󱚣  |  `&#xF16A3;`  | robot             |
| `F16A4` |   󱚤  |  `&#xF16A4;`  | robot             |
| `F16A5` |   󱚥  |  `&#xF16A5;`  | robot love        |
| `F16A6` |   󱚦  |  `&#xF16A6;`  | robot love        |
|  `F4BE` |     |   `&#xF4BE;`  | robot             |
|  `EB08` |     |   `&#xEB08;`  | robot             |
| `F1957` |   󱥗  |  `&#xF1957;`  | chips             |
|  `E763` |     |   `&#xE763;`  | cola              |
| `F01E5` |   󰇥  |  `&#xF01E5;`  | dark              |
| `10996` |   𐦖  |   `&#10996;`  | dark              |
| `F02CB` |   󰋋  |  `&#xF02CB;`  | headphone         |
|  `EE58` |     |   `&#xEE58;`  | headphone         |
|  `EE59` |     |   `&#xEE59;`  | headphone         |
|  `F025` |     |   `&#xF025;`  | headphone         |
| `F02CC` |   󰋌  |  `&#xF02CC;`  | headphone         |
| `F02CD` |   󰋍  |  `&#xF02CD;`  | headphone         |
| `F02CF` |   󰋏  |  `&#xF02CF;`  | headset dock      |
| `F1852` |   󱡒  |   `&#F1852;`  | earbuds           |
| `F04B2` |   󰒲  |  `&#xF04B2;`  | sleep             |
| `F04B3` |   󰒳  |  `&#xF04B3;`  | sleep off         |
|  `E61C` |     |   `&#xE61C;`  | twig              |
|  `E006` |     |   `&#xE006;`  | coconut tree      |
|  `E2A2` |     |   `&#xE2A2;`  | palm tree         |
|  `EE91` |     |   `&#xEE91;`  | vacation          |
|  `E2A6` |     |   `&#xE2A6;`  | cactus            |
|  `32DB` |  ㋛  |   `&#x32DB;`  | smile             |
|  `32E1` |  ㋡  |   `&#x32E1;`  | smile             |
| `100B7` |   𐂷  |  `&#x100B7;`  | tree              |
| `100A9` |   𐂩  |  `&#x100a9;`  | tree              |
| `F0DB5` |   󰶵  |  `&#xF0DB5;`  | cactus            |

## tiaji

| UNICODE | ICON | HTML ENCODING | COMMENTS |
|:-------:|:----:|:-------------:|----------|
| `1D300` |   𝌀  |   `&#x1D300;`  | -        |
| `1D301` |   𝌁  |   `&#x1D301;`  | -        |
| `1D302` |   𝌂  |   `&#x1D302;`  | -        |
| `1D303` |   𝌃  |   `&#x1D303;`  | -        |
| `1D304` |   𝌄  |   `&#x1D304;`  | -        |
| `1D305` |   𝌅  |   `&#x1D305;`  | -        |


## spinner

> [!NOTE|label:references:]
> - [unicode - Braille Patterns](https://symbl.cc/en/unicode/blocks/braille-patterns/)
> - [wikipedia - Braille Patterns](https://en.wikipedia.org/wiki/Braille_Patterns)
> - [SamEureka/spinner.sh](https://gist.github.com/SamEureka/3e61942d37256550b40d0ffe75bc22c4)
>
>> ![Braille 8 dot Cell Numbering](../../screenshot/shell/unicode-Braille8dotCellNumbering.png)
>>
>> ```
>> +---+---+
>> | 1 | 4 |
>> +---+---+
>> | 2 | 5 |
>> +---+---+
>> | 3 | 6 |
>> +---+---+
>> | 7 | 8 |
>> +---+---+
>> ```


| UNICODE | ICON | HTML ENCODING | COMMENTS |
|:-------:|:----:|:-------------:|----------|
|  `28C4` |   ⣄  |   `&#x28C4;`  | `378`    |
|  `28C6` |   ⣆  |   `&#x28C6;`  | `2378`   |
|  `2847` |   ⡇  |   `&#x2847;`  | `1237`   |
|  `280F` |   ⠏  |   `&#x280F;`  | `1234`   |
|  `280B` |   ⠋  |   `&#x280B;`  | `124`    |
|  `2839` |   ⠹  |   `&#x2839;`  | `1456`   |
|  `28B8` |   ⢸  |   `&#x28B8;`  | `4568`   |
|  `28F0` |   ⣰  |   `&#x28F0;`  | `5678`   |
|  `28E0` |   ⣠  |   `&#x28E0;`  | `678`    |



| UNICODE | ICON | HTML ENCODING | COMMENTS  |
|:-------:|:----:|:-------------:|-----------|
|  `28FE` |   ⣾  |   `&#x28FE;`  | `2345678` |
|  `28FD` |   ⣽  |   `&#x28FD;`  | `1345678` |
|  `28FB` |   ⣻  |   `&#x28FB;`  | `1245678` |
|  `28BF` |   ⢿  |   `&#x28BF;`  | `1234568` |
|  `287F` |   ⡿  |   `&#x287F;`  | `1234567` |
|  `28DF` |   ⣟  |   `&#x28DF;`  | `1234578` |
|  `28EF` |   ⣯  |   `&#x28EF;`  | `1234678` |
|  `28F7` |   ⣷  |   `&#x28F7;`  | `1235678` |


| UNICODE | ICON | HTML ENCODING |
|:-------:|:----:|:-------------:|
| `F0E36` |   󰸶  |  `&#xF0E36;`  |
| `F0E38` |   󰸸  |  `&#xF0E38;`  |
| `F0E37` |   󰸷  |  `&#xF0E37;`  |
| `F0E34` |   󰸴  |  `&#xF0E34;`  |
| `F0E35` |   󰸵  |  `&#xF0E35;`  |
| `F0E33` |   󰸳  |  `&#xF0E33;`  |


| UNICODE | ICON | HTML ENCODING |
|:-------:|:----:|:-------------:|
| `F0ECA` |   󰻊  |  `&#xF0ECA;`  |
| `F0EC9` |   󰻉  |  `&#xF0EC9;`  |

## misc.

| UNICODE | ICON | HTML ENCODING | COMMENTS          |
|:-------:|:----:|:-------------:|-------------------|
| `F1050` |   󱁐  |  `&#xF1050;`  | space             |
| `f1295` |   󱊕  |  `&#xF1295;`  | tray              |
|  `F0E7` |     |   `&#xF0E7;`  | lightning bolt
| `F140B` |   󱐋  |  `&#xF140B;`  | lightning bolt    |
| `F140C` |   󱐌  |  `&#xF140C;`  | lightning bolt    |
|  `E672` |     |   `&#xE672;`  | lock              |
|  `F023` |     |   `&#xF023;`  | lock              |
|  `F52A` |     |   `&#xF52A;`  | unlock            |
|  `EBE7` |     |   `&#xEBE7;`  | lock              |
|  `EB74` |     |   `&#xEB74;`  | unlock            |
|  `F09C` |     |   `&#xF09C;`  | unlock            |
|  `F084` |     |   `&#xF084;`  | key               |
|  `F43D` |     |   `&#xF43D;`  | key               |
| `F030B` |   󰌋  |  `&#xF030B;`  | key               |
| `F0306` |   󰌆  |  `&#xF0306;`  | key               |
| `F1184` |   󱆄  |  `&#xF1184;`  | key               |
| `F1185` |   󱆅  |  `&#xF1185;`  | key               |
|  `E60A` |     |   `&#xE60A;`  | key               |
| `F0307` |   󰌇  |  `&#xF0307;`  | keys              |
|  `F255` |     |   `&#xF255;`  | mouse drag        |
|  `F256` |     |   `&#xF256;`  | mouse             |
|  `FF02` |  ＂  |   `&#xFF02;`  | "                 |
| `F02C9` |   󰋉  |  `&#xF02C9;`  | ”                 |
| `F027E` |   󰉾  |  `&#xF027E;`  | ”                 |
| `F0757` |   󰝗  |  `&#xF0757;`  | “                 |
|  `F10D` |     |   `&#xF10D;`  | “                 |
|  `F10E` |     |   `&#xF10E;`  | ”                 |
| `F11A8` |   󱆨  |  `&#xF11A8;`  | ”                 |
| `F11A7` |   󱆧  |  `&#xF11A7;`  | “                 |
|  `EB33` |     |   `&#xEB33;`  | “                 |
| `F1022` |   󱀢  |  `&#xF1022;`  | “                 |
| `F1021` |   󱀡  |  `&#xF1021;`  | “                 |
| `F0E25` |   󰸥  |  `&#xF0E25;`  | ,                 |
| `F0E24` |   󰸤  |  `&#xF0E24;`  | ,                 |
| `f0e2b` |   󰸫  |  `&#xF0E2B;`  | ,                 |
| `F0E26` |   󰸦  |  `&#xF0E26;`  | ,                 |
| `F0E23` |   󰸣  |  `&#xF0E23;`  | ,                 |
|  `F30C` |     |   `&#xF30C;`  | monster           |
|  `E651` |     |   `&#xE651;`  | D                 |
|  `E66D` |     |   `&#xE66D;`  | J                 |
|  `F8E2` |     |   `&#xF8E2;`  | P                 |
|  `E27A` |     |   `&#xE27A;`  | =>                |
|  `E374` |     |   `&#xE374;`  | N/A               |
|  `E640` |     |   `&#xE640;`  | empty box         |
|  `F893` |     |   `&#xF893;`  | menu              |
|  `E615` |     |   `&#xE615;`  | tool              |
|  `F013` |     |   `&#xF013;`  | tool              |
| `F0493` |   󰒓  |  `&#xF0493;`  | tool              |
| `F0494` |   󰒔  |  `&#xF0494;`  | tool              |
|  `EB65` |     |   `&#xEB65;`  | tool              |
| `F05B7` |   󰖷  |   `&#F05B7;`  | tool              |
|  `EB6D` |     |   `&#xEB6D;`  | tool              |
| `F1064` |   󱁤  |  `&#xF1064;`  | tool              |
|  `F425` |     |   `&#xF425;`  | tool              |
| `F0DDF` |   󰷟  |   `&#F0DDF;`  | tool - nail       |
| `F08EA` |   󰣪  |  `&#xF08EA;`  | hammer            |
|  `F0E3` |     |   `&#xF0E3;`  | hammer            |
| `F1842` |  󱡂󠠂  |  `&#xF1842;`  | hammer            |
| `F08B7` |   󰢷  |   `&#F08B7;`  | hammer            |
|  `EEFF` |     |   `&#EEFF;`   | *hammer           |
|  `F204` |     |   `&#xF204;`  | switch off        |
|  `F205` |     |   `&#xF205;`  | switch on         |
| `F0A19` |   󰨙  |  `&#xF0A19;`  | switch off        |
| `F0A1A` |   󰨚  |  `&#xF0A1A;`  | switch off        |
| `F0521` |   󰔡  |  `&#xF0521;`  | switch on         |
|  `E688` |     |   `&#xE688;`  | -                 |
|  `f470` |     |   `&#xf470;`  | github            |
|  `E717` |     |   `&#xE717;`  | github            |
|  `E709` |     |   `&#xE709;`  | github            |
|  `EA84` |     |   `&#xEA84;`  | github            |
|  `EB00` |     |   `&#xEB00;`  | github            |
|  `EBA1` |     |   `&#xEBA1;`  | github            |
|  `F09B` |     |   `&#xF09B;`  | github            |
|  `E65B` |     |   `&#xE65B;`  | github            |
|  `F092` |     |   `&#xF092;`  | github            |
|  `F408` |     |   `&#xF408;`  | github            |
| `F02A4` |   󰊤  |  `&#xF02A4;`  | github            |
|  `F4B8` |     |   `&#xF4B8;`  | copilot           |
|  `EC1E` |     |   `&#xEC1E;`  | copilot           |
|  `F4B9` |     |   `&#xF4B9;`  | copilot           |
|  `F4BA` |     |   `&#xF4BA;`  | copilot           |
|  `E7EA` |     |   `&#xE7EA;`  | github codespace  |
|  `E7EB` |     |   `&#xE7EB;`  | gitlab            |
|  `F198` |     |   `&#xF198;`  | slack             |
| `F04B1` |   󰒱  |  `&#xf04b1;`  | slack             |
|  `F480` |     |   `&#xF480;`  | gist              |
|  `E783` |     |   `&#xE783;`  | stretch           |
| `F0272` |   󰉲  |  `&#xF0272;`  | H=                |
| `F0274` |   󰉴  |  `&#xF0274;`  | H#                |
| `F0273` |   󰉳  |  `&#xF0273;`  | H>                |
| `F0271` |   󰉱  |  `&#xF0271;`  | H<                |
| `F0270` |   󰉰  |  `&#xF0270;`  | H6                |
| `F0504` |   󰔄  |  `&#xF0504;`  | °C                |
|  `E339` |     |   `&#xE339;`  | °C                |
| `F0505` |   󰔅  |  `&#xF0505;`  | °F                |
|  `E341` |     |   `&#xE341;`  | °F                |
|  `E6A2` |     |   `&#xE6A2;`  | WA                |
| `F0435` |   󰐵  |   `&#F0435;`  | HQ                |
| `F0A0C` |   󰨌  |   `&#F0A0C;`  | LQ                |
| `F07EF` |   󰟯  |  `&#xF07EF;`  | SD                |
| `F07FD` |   󰟽  |  `&#xF07FD;`  | 3D                |
| `F0EC7` |   󰻇  |  `&#xF0EC7;`  | 3D                |
| `F1A1C` |   󱨜  |  `&#xF1A1C;`  | 2D                |
| `F1A10` |   󱨐  |  `&#xF1A10;`  | raw off           |
| `F12B7` |   󱊷  |  `&#xF12B7;`  | ESC               |
| `F083E` |   󰠾  |  `&#xF083E;`  | HK                |
| `F0A08` |   󰨈  |  `&#xF0A08;`  | police officer    |
| `F0713` |   󰜓  |   `&#F0713;`  | 3G                |
| `F0714` |   󰜔  |   `&#F0714;`  | 4G                |
| `F0A6F` |   󰩯  |  `&#xF0A6F;`  | 5G                |
| `F0D6E` |   󰵮  |  `&#xF0D6E;`  | DEV               |
|  `EEF4` |     |   `&#xEEF4;`  | DEV               |
| `F100D` |   󱀍  |  `&#xF100D;`  | ABC               |
| `F002C` |   󰀬  |  `&#xF002C;`  | abc               |
|  `EA93` |     |   `&#xEA93;`  | abc               |
| `F100E` |   󱀎  |  `&#xF100E;`  | ABC off           |
|  `EB80` |     |   `&#xEB80;`  | abc               |
| `F132D` |   󱌭  |  `&#xF132D;`  | ab                |
| `F132F` |   󱌯  |  `&#xF132F;`  | ab                |
|  `EB2E` |     |   `&#xEB2E;`  | AB                |
| `F0113` |   󰄓  |  `&#xF0113;`  | Ab                |
| `F0D47` |   󰵇  |  `&#xF0D47;`  | atm               |
| `F132E` |   󱌮  |  `&#xF132E;`  | abeta             |
| `F07E4` |   󰟤  |  `&#xF07E4;`  | co2               |
| `F12FE` |   󱋾  |  `&#xF12FE;`  | CO                |
| `F13A3` |   󱎣  |  `&#xF13A3;`  | XS                |
| `F13A2` |   󱎢  |  `&#xF13A2;`  | XXS               |
| `F13A4` |   󱎤  |  `&#xF13A4;`  | S                 |
| `F13A5` |   󱎥  |  `&#xF13A5;`  | M                 |
| `F13A7` |   󱎧  |  `&#xF13A7;`  | XL                |
| `F13A8` |   󱎨  |  `&#xF13A8;`  | XXL               |
| `F13A9` |   󱎩  |  `&#xF13A9;`  | 3XL               |
| `F0A78` |   󰩸  |  `&#xF0A78;`  | TM                |
|  `F25C` |     |   `&#xF25C;`  | TM                |
|  `2122` |   ™  |   `&#2122;`   | TM                |
|  `2120` |   ℠  |   `&#2120;`   | SM                |
| `F0CBE` |   󰲾  |  `&#xF0CBE;`  | AM                |
| `F07CF` |   󰟏  |  `&#xf07cf;`  | HD                |
|  `E0A3` |     |   `&#xE0A3;`  | CN                |
|  `E0A1` |     |   `&#xE0A1;`  | LN                |
| `F0EFE` |   󰻾  |  `&#xF0EFE;`  | ID                |
|  `E765` |     |   `&#xE765;`  | cisco             |
| `F147D` |   󱑽  |  `&#xF147D;`  | waveform          |
|  `E3BE` |     |   `&#xE3BE;`  | earthquake        |
| `F0A30` |   󰨰  |  `&#xF0A30;`  | bug               |
|  `EAAF` |     |   `&#xEAAF;`  | bug               |
| `F0A2F` |   󰨯  |  `&#xF0A2F;`  | bug fixed         |
| `F0A2E` |   󰨮  |  `&#xF0A2E;`  | bug fixed         |
| `F0A3F` |   󰨿  |  `&#xF0A3F;`  | ..]               |
| `F0A40` |   󰩀  |  `&#xF0A40;`  | [..               |
| `102E8` |   𐋨  |   `&#102E8;`  | b                 |
| `102C9` |   𐋉  |   `&#102C9;`  | 6                 |
|  `F444` |     |   `&#xF444;`  | dot               |
|  `EB8A` |     |   `&#xEB8A;`  | dot               |
|  `EA71` |     |   `&#xEA71;`  | dot               |
|  `EA7C` |     |   `&#xEA7C;`  | dot dot dot       |
|  `FFED` |   ￭  |   `&#xFFED;`  | square dot        |
|  `FFEE` |   ￮  |   `&#xFFEE;`  | empty dot         |
|  `F812` |     |   `&#xF812;`  | keyboard          |
| `F09FA` |   󰧺  |  `&#xF09FA;`  | keyboard          |
| `F09F9` |   󰧹  |  `&#xF09F9;`  | keyboard          |
| `F0313` |   󰌓  |  `&#xF0313;`  | keyboard          |
|  `F11C` |     |   `&#xF11C;`  | keyboard          |
| `F0E4B` |   󰹋  |  `&#xF0E4B;`  | keyboard off      |
| `10669` |   𐙩  |  `&#x10669;`  | 中                |
| `10AE3` |   𐫣  |  `&#x10AE3;`  | -                 |
| `16861` |   𖡡  |  `&#x16861;`  | map pin           |
| `F0352` |   󰍒  |  `&#xF0352;`  | map pin           |
| `F034E` |   󰍎  |  `&#xF034E;`  | map pin           |
| `1BC05` |   𛰅  |  `&#x1BC05;`  | -                 |
| `1BC06` |   𛰆  |  `&#x1BC06;`  | -                 |
| `1BC0A` |   𛰊  |  `&#x1BC0A;`  | -                 |
| `1BC0B` |   𛰋  |  `&#x1BC0B;`  | -                 |
| `1F000` |   🀀  |  `&#x1F000;`  | majiang           |
| `1F001` |   🀁  |  `&#x1F001;`  | majiang           |
| `1F002` |   🀂  |  `&#x1F002;`  | majiang           |
| `1F003` |   🀃  |  `&#x1F003;`  | majiang           |
| `F17C5` |   󱟅  |  `&#xF17C5;`  | pH                |
|  `EE3C` |     |  `&#xxEE3C;`  | signature         |
| `F0DFE` |   󰷾  |  `&#xF0DFE;`  | signature         |
| `F0DFC` |   󰷼  |  `&#xF0DFC;`  | signature         |
|  `EE7F` |     |   `&#xEE7F;`  | signature         |
| `F0F49` |   󰽉  |  `&#xF0F49;`  | signature         |
| `1F718` |   🜘  |  `&#x1F718;`  | -                 |
| `1F73B` |   🜻  |  `&#x1F73B;`  | -                 |
|  `E245` |     |   `&#xE245;`  | -                 |
|  `29BF` |   ⦿  |   `&#x29BF;`  | circled .         |
|  `2A00` |   ⨀  |   `&#x2A00;`  | circled .         |
|  `29BE` |   ⦾  |   `&#x29BE;`  | circled o         |
|  `29C2` |   ⧂  |   `&#x29C2;`  | circled o         |
|  `29C3` |   ⧃  |   `&#x29C3;`  | circled =         |
|  `2AF1` |   ⫱  |   `&#x2AF1;`  | circled bar       |
|  `27DF` |   ⟟  |   `&#x27DF;`  | circled bar       |
|  `2742` |   ❂  |   `&#x2742;`  | open circled      |
|  `25EF` |   ◯  |   `&#x25EF;`  | circled           |
|  `25D9` |   ◙  |   `&#x25D9;`  | circled           |
|  `26AC` |   ⚬  |   `&#x26AC;`  | circled           |
|  `25CC` |   ◌  |   `&#x25CC;`  | dotted circle     |
|  `25E0` |   ◠  |   `&#x25E0;`  | half circled      |
|  `25E1` |   ◡  |   `&#x25E1;`  | half circled      |
|  `2B29` |   ⬩  |   `&#x2B29;`  | star              |
|  `27E1` |   ⟡  |   `&#x27E1;`  | star              |
|  `27E2` |   ⟢  |   `&#x27E2;`  | star              |
|  `27E3` |   ⟣  |   `&#x27E3;`  | star              |
|  `27D0` |   ⟐  |   `&#x27D0;`  | star              |
|  `25C8` |   ◈  |   `&#x25C8;`  | star              |
|  `2A40` |   ⩀  |   `&#x2A40;`  | u.                |
|  `2A03` |   ⨃  |   `&#x2A03;`  | u.                |
|  `228C` |   ⊌  |   `&#x228C;`  | u<-               |
|  `228D` |   ⊍  |   `&#x228D;`  | u.                |
|  `228E` |   ⊎  |   `&#x228E;`  | u+                |
|  `2A04` |   ⨄  |   `&#x2A04;`  | u+                |
|  `2A41` |   ⩁  |   `&#x2A41;`  | u-                |
|  `2A4B` |   ⩋  |   `&#x2A4B;`  | m                 |
|  `2239` |   ∹  |   `&#x2239;`  | -:                |
|  `2F45` |  ⽅  |   `&#x2F45;`  | 方                |
|  `F0CB` |     |   `&#xF0CB;`  | list              |
|  `F0CA` |     |   `&#xF0CA;`  | list              |
| `F1384` |   󱎄  |  `&#xF1384;`  | list              |
| `F0756` |   󰝖  |  `&#xF0756;`  | list              |
| `F0D07` |   󰴇  |  `&#xF0D07;`  | list              |
| `F0546` |   󰕆  |  `&#xF0546;`  | list              |
| `F0545` |   󰕅  |  `&#xF0545;`  | list              |
| `F15AB` |   󱖫  |  `&#xF15AB;`  | list              |
| `f098f` |   󰦏  |  `&#xF098F;`  | list              |
|  `F27F` |     |   `&#xF27F;`  | :)                |
| `F09AF` |   󰦯  |  `&#xF09AF;`  | 2FA               |
| `F001B` |   󰀛  |  `&#xF001B;`  | AC                |
|  `F1A8` |     |   `&#xF1A8;`  | pied piper        |
|  `EE24` |     |   `&#xEE24;`  | bezier curve      |
|  `EBB6` |     |   `&#xebb6;`  | combine           |
|  `F066` |     |   `&#xF066;`  | compress          |
| `F011B` |   󰄛  |  `&#xF011B;`  | cat               |
|  `F086` |     |   `&#xF086;`  | comments          |
| `F0115` |   󰄕  |  `&#xF0115;`  | cash 100          |
|  `EFCA` |     |   `&#xEFCA;`  | check             |
| `F0C6F` |   󰱯  |  `&#xF0C6F;`  | devil             |
| `F0CBF` |   󰲿  |  `&#xF0CBF;`  | fm                |
| `F18C0` |   󱣀  |  `&#xF18C0;`  | sickls            |
| `F1887` |   󱢇  |  `&#xF1887;`  | hammer and sickls |
