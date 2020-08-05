<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [setup a colorful tab](#setup-a-colorful-tab)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### setup a colorful tab
#### pick colors
> using `tabset --list`

```bash
> $ while read i; do
>   c=$(echo $i | awk -F':' '{print $1}');
>   echo === $c === ;
>   tabset --add m-$c $c;
> done < csscolors.js

$ tabset --list
```
![tabset list](../screenshot/iterm2/tabset-list-1.png)

### add favor color to a file (`~/.marslo/.colors`)
```bash
$ echo "<color-name>" >> ~/.marslo/.colors
```

#### get color hex (for [`it2setcolor`](https://github.com/gnachman/iterm2-website/blob/master/source/utilities/it2setcolor))
> download original csscolor.js if necessory: `$ curl -fsSL -O https://raw.githubusercontent.com/jonathaneunice/iterm2-tab-set/master/csscolors.js`

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
  yellowgreen :	154, 205, 50 :	9acd32
  wheat :	245, 222, 179 :	f5deb3
  tomato :	255, 99, 71 :	ff6347
  steelblue :	70, 130, 180 :	4682b4
  tan :	210, 180, 140 :	d2b48c
  sandybrown :	244, 164, 96 :	f4a460
  plum :	221, 160, 221 :	dda0dd
  palegoldenrod :	238, 232, 170 :	eee8aa
  palegreen :	152, 251, 152 :	98fb98
  navajowhite :	255, 222, 173 :	ffdead
  olive :	128, 128, 0 :	80800
  moccasin :	255, 228, 181 :	ffe4b5
  chartreuse :	127, 255, 0 :	7fff0
  palegreen :	152, 251, 152 :	98fb98
  mediumorchid :	186, 85, 211 :	ba55d3
  royalblue :	65, 105, 225 :	4169e1
  olivedrab :	107, 142, 35 :	6b8e23
  khaki :	240, 230, 140 :	f0e68c
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

![itit <string> c](../screenshot/iterm2/itit-c.png)

![itit string bc](../screenshot/iterm2/itit-bc.png)
