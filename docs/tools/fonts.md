<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [font patcher](#font-patcher)
  - [patch fonts](#patch-fonts)
    - [setup font-patcher](#setup-font-patcher)
    - [patch fonts](#patch-fonts-1)
  - [check fonts](#check-fonts)
- [fonts](#fonts)
  - [highly recommended](#highly-recommended)
    - [Monaco](#monaco)
    - [RecMonoCasual](#recmonocasual)
    - [Comic Mono](#comic-mono)
    - [Agave](#agave)
    - [Operator Mono](#operator-mono)
    - [Gohu](#gohu)
    - [Monaspace RN](#monaspace-rn)
  - [nerd-fonts](#nerd-fonts)
    - [pixel](#pixel)
    - [hand-writing](#hand-writing)
    - [symbole](#symbole)
    - [others](#others)
  - [powerline fonts](#powerline-fonts)
  - [others](#others-1)
- [devicons](#devicons)
  - [coding](#coding)
  - [folders](#folders)
  - [platform](#platform)
  - [math](#math)
  - [graph](#graph)
  - [tiaji](#tiaji)
  - [misc.](#misc)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP]
> - [* 142 Programming Fonts](https://www.programmingfonts.org/)
> - [* arrowtype/recursive](https://github.com/arrowtype/recursive)
> - [* ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
> - [* iMarslo NerdFonts](https://github.com/marslo/fonts/tree/fonts) | [install guild](https://github.com/marslo/fonts/tree/main)
> - [Patch Fonts with Cursive Italic Styles](https://www.sainnhe.dev/post/patch-fonts-with-cursive-italic-styles/)
> - [sainnhe/icursive-nerd-font](https://git.sainnhe.dev/sainnhe/icursive-nerd-font) | [thlineric/icursive-nerd-font](https://github.com/thlineric/icursive-nerd-font) | [sainnhe/mono-nerd-font](https://git.sainnhe.dev/sainnhe/mono-nerd-font) | [40huo/Patched-Fonts](https://github.com/40huo/Patched-Fonts)
> - [INPUT™ fonts](https://input.djr.com/download/)
> - [Consolas font family](https://learn.microsoft.com/en-us/typography/font-list/consolas)
> - [monaspace](https://monaspace.githubnext.com/)
>   - [monaspace nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Monaspace) | [Monaspace.zip](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.zip) | [Monaspace.tar.xz](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz)
> - [ryanoasis/powerline-extra-symbols](https://github.com/ryanoasis/powerline-extra-symbols)
> - [ArrowType](https://www.arrowtype.com/)
> - [oldschool font list](https://int10h.org/oldschool-pc-fonts/fontlist/)
> - [subframe7536/maple-font](https://github.com/subframe7536/Maple-font)

# font patcher
## patch fonts
### setup font-patcher
```bash
# osx
$ brew install fontforge
# ubuntu
$ sudo apt install python3-fontforge

# install font-patcher v3.2.1.1
$ [[ -d /opt/FontPatcher ]] || mkdir -p /opt/FontPatcher
$ curl -o /opt/FontPatcher/FontPatcher.zip \
       -fsSL https://github.com/marslo/fonts/raw/fonts/FontPatcher.v3.2.1.1.zip
$ unzip -o /opt/FontPatcher/FontPatcher.zip /opt/FontPatcher

# setup completion
## osx
$ cp /opt/FontPatcher/completion/font-patcher.sh /usr/local/etc/bash_completion.d/
## centos/rhel/ubuntu/wsl
$ cp /opt/FontPatcher/completion/font-patcher.sh /usr/share/bash-completion/completions/
## centos/rhel
$ cp /opt/FontPatcher/completion/font-patcher.sh /etc/bash_completion.d/

# setup environment
$ cat >> ~/.bashrc << EOF
FONT_PATCHER='/opt/FontPatcher'
test -d "${FONT_PATCHER}" && PATH+=":${FONT_PATCHER}"
export $PATH
EOF
```

[![font-patcher 3.2.1.1 auto completion](https://github.com/marslo/fonts/raw/main/screenshots/font-patcher-v3.2.1.1-auto-completion.png)](https://github.com/marslo/fonts/raw/main/screenshots/font-patcher-v3.2.1.1-auto-completion.png)

### patch fonts

![font-patcher](../screenshot/tools/fonts/font-patcher.png)

- mono
  ```bash
  $ font-patcher RecMonoSemicasual-Regular-1.085.ttf --mono --complete --quiet -ext ttf -out .

  # or patch for folders
  $ while read -r _f; do
      for _e in otf ttf; do
        outpath="$(dirname $(dirname $_f))_NF/$(basename $(dirname $_f))/${_e}";
        [[ -d "${outpath}" ]] || mkdir -p "${outpath}";
        echo ".. ${_e} » $(basename ${_f}) » ${outpath}";
        /opt/FontPatcher/font-patcher $(realpath "${_f}") --mono --complete --quiet -ext ${_e} -out "${outpath}";
      done;
    done < <(fd -u -tf -e ttf -e otf --full-path /path/to/folder)
  ```

- san
  - with name
    ```bash
    $ font-patcher --complete --progressbars --outputdir . --name 'Recursive Mono Casual Static Italic Nerd Font' /path/to/font.ttf 2>/dev/null

    # using name dynamically
    $ font='/path/to/font.ttf'
    $ fontfamily="$(fc-query -f '%{family}' "$(realpath "${font}")" | awk -F, '{print $1}')";
    $ style="$(fc-query -f '%{style}' "$(realpath "${font}")" | awk -F, '{print $1}')";
    $ name="${fontfamily} ${style} Nerd Font";
    $ font-patcher --complete --quiet --outputdir . --name "${name}" "${font}" 2>/dev/null
    ```

## check fonts

> [!NOTE|label:references:]
> - [Which font is used in Visual Studio Code Editor and how to change fonts?](https://stackoverflow.com/a/52789662/2940319)

- list installed fonts
  ```bash
  $ fc-list | sed -re 's/^.+\/([^:]+):\s?([^,:]+),?:?.*$/\1 : \2/g' | column -t -s: -o: | sort -t: -k2

  # or
  $ fc-list | awk '{$1=""}1' | sed -re 's/^\s*([^:,]+:?,?[^,:]+).*$/\1/' | column -t -s:
  ```

  - i.e.:
    ```bash
    $ fc-list | sed -re 's/^.+\/([^:]+):\s?([^,:]+),?:?.*$/\1 : \2/g' | column -t -s: -o: | sort -t: -k2 | grep operator
    OperatorProNerdFont-Italic.ttf                : Operator Pro Nerd Font
    OperatorProNerdFont-Regular.ttf               : Operator Pro Nerd Font
    OperatorMonoNerdFontMono-Light.ttf            : OperatorMono Nerd Font Mono
    OperatorMonoNerdFontMono-LightItalic.ttf      : OperatorMono Nerd Font Mono
    OperatorMonoLigNerdFontMono-Light.otf         : OperatorMonoLig Nerd Font Mono
    OperatorMonoLigNerdFontMono-LightItalic.otf   : OperatorMonoLig Nerd Font Mono
    OperatorProNerdFont-Light.ttf                 : OperatorPro Nerd Font
    OperatorProNerdFont-LightItalic.ttf           : OperatorPro Nerd Font
    ```

- list fonts properties
  ```bash
  $ fc-query /path/to/font.ttf
  ```

  - i.e.:
    ```bash
    $ fc-query Operator/OperatorMonoLigNF/OperatorMonoLigNerdFontMono-Light.ttf | grep -E 'family|style|fullname|weight|slant|spacing|file'
      family: "OperatorMonoLig Nerd Font Mono"(s) "OperatorMonoLig Nerd Font Mono Light"(s)
      familylang: "en"(s) "en"(s)
      style: "Light"(s) "Regular"(s)
      stylelang: "en"(s) "en"(s)
      fullname: "OperatorMonoLig Nerd Font Mono Light"(s)
      fullnamelang: "en"(s)
      slant: 0(i)(s)
      weight: 50(f)(s)
      spacing: 100(i)(s)
      file: "Operator/OperatorMonoLigNF/OperatorMonoLigNerdFontMono-Light.ttf"(s)
    ```

- [list particular field of fonts properties](https://stackoverflow.com/a/43614521/2940319)
  ```bash
  $ fc-query -f '%{family}\n' /path/to/font.ttf
  ```

  - i.e.:
    ```bash
    $ fc-query -f '%{family}\n%{style}\n%{fullname}' Recursive/Recursive_Desktop/RecursiveSansCslSt-LtItalic.ttf
    Recursive Sans Casual Static,Recursive Sn Csl St Lt
    Light Italic,Italic
    Recursive Sn Csl St Lt Italic

    $ fc-query -f '%{family}\n%{style}\n%{fullname}' Recursive/Recursive_Desktop/RecursiveSansCslSt-LtItalic.ttf | awk -F, '{print $1}'
    Recursive Sans Casual Static
    Light Italic
    Recursive Sn Csl St Lt Italic
    ```

# fonts
## highly recommended

> [!TIP]
> - `fontsPath`:
>   - osx: `~/Library/Fonts` or `/System/Fonts`
>   - Linux: `~/.fonts` or `~/.local/share/fonts` or `/usr/share/fonts`

### Monaco

> [!NOTE]
> THE BEST ALWAYS !

- [Monaco](https://www.cufonfonts.com/font/monaco)
- Nerd-Fonts
  - [iMarslo: MonacoNerdFontMono-Regular](https://github.com/marslo/fonts/tree/fonts/Monaco)
  - [Monaco Nerd Font Mono](https://github.com/Karmenzind/monaco-nerd-fonts)
  - [Monaco Nerd Font](https://github.com/thep0y/monaco-nerd-font)
- Powerline
  - [Monaco for Powerline.ttf](https://gist.github.com/lujiacn/32b598b1a6a43c996cbd93d42d466466/raw/5be6ef0e44a3427fdb8343b4dacc29716449c59e/Monaco%2520for%2520Powerline.ttf)
  - [Monaco for Powerline.otf](https://github.com/supermarin/powerline-fonts/tree/master/Monaco)

[![Monaco vim](../screenshot/vim/vim-airline-ale-monaco.png)](https://marslo.github.io/ibook/screenshot/vim/vim-airline-ale-monaco.png)

[![Monaco bash](../screenshot/tools/fonts/bash-Monaco.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-Monaco.png)

### [RecMonoCasual](https://github.com/arrowtype/recursive/tree/main/fonts/ArrowType-Recursive-1.085/Recursive_Code)

> [!TIP|label:tips:]
> - [iMarslo Recursive](https://github.com/marslo/fonts/tree/fonts/Recursive) support both `otf` and `ttf` format

[![devicon diff](https://github.com/marslo/fonts/raw/main/screenshots/devicons.png)](https://github.com/marslo/fonts/raw/main/screenshots/devicons.png)

[![devicon with RecMonoCasual Nerd Font Mono](https://github.com/marslo/fonts/raw/main/screenshots/RecMonoCasualNF.png)](https://github.com/marslo/fonts/raw/main/screenshots/RecMonoCasualNF.png)

```bash
# RecMonoCasual
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoCasual/RecMonoCasualNerdFontMono-Regular.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoCasual/RecMonoCasualNerdFontMono-Italic.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoCasual/RecMonoCasualNerdFontMono-Bold.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoCasual/RecMonoCasualNerdFontMono-BoldItalic.otf

# RecMonoLinear
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoLinear/RecMonoLinearNerdFontMono-Regular.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoLinear/RecMonoLinearNerdFontMono-Italic.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoLinear/RecMonoLinearNerdFontMono-Bold.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoLinear/RecMonoLinearNerdFontMono-BoldItalic.otf

# RecMonoSemicasual
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoSemicasual/RecMonoSmCasualNerdFontMono-Regular.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoSemicasual/RecMonoSmCasualNerdFontMono-Italic.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoSemicasual/RecMonoSmCasualNerdFontMono-Bold.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoSemicasual/RecMonoSmCasualNerdFontMono-BoldItalic.otf

# RecMonoDuotone
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoDuotone/RecMonoDuotoneNerdFontMono-Regular.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoDuotone/RecMonoDuotoneNerdFontMono-Italic.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoDuotone/RecMonoDuotoneNerdFontMono-Bold.otf \
       https://github.com/marslo/fonts/raw/fonts/Recursive/Recursive_Code_NF/RecMonoDuotone/RecMonoDuotoneNerdFontMono-BoldItalic.otf
```

<!--sec data-title="original version" data-id="section0" data-show=true data-collapse=true ces-->

[![RecMonoCasual vim](../screenshot/vim/vim-airline-ale-3.png)](https://marslo.github.io/ibook/screenshot/vim/vim-airline-ale-3.png)

[![RecMonoCasual bash](../screenshot/tools/fonts/bash-RecMonoCasual.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-RecMonoCasual.png)

```bash
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/arrowtype/recursive/raw/main/fonts/ArrowType-Recursive-1.085/Recursive_Code/RecMonoCasual/RecMonoCasual-Regular-1.085.ttf \
       https://github.com/arrowtype/recursive/raw/main/fonts/ArrowType-Recursive-1.085/Recursive_Code/RecMonoDuotone/RecMonoDuotone-Regular-1.085.ttf \
       https://github.com/arrowtype/recursive/raw/main/fonts/ArrowType-Recursive-1.085/Recursive_Code/RecMonoLinear/RecMonoLinear-Regular-1.085.ttf \
       https://github.com/arrowtype/recursive/raw/main/fonts/ArrowType-Recursive-1.085/Recursive_Code/RecMonoSemicasual/RecMonoSemicasual-Regular-1.085.ttf &&
  fc-cache -f -v

# or
$ version=1.085
$ url='https://github.com/arrowtype/recursive/raw/main/fonts/ArrowType-Recursive-1.085/Recursive_Code/'
$ while read -r _t; do
    curl --create-dirs -O --output-dir "${fontsPath}" \
         "${url}"/"RecMono${_t}/RecMono${_t}-Regular-1.085.ttf"
  done < <( echo 'Casual Duotone Linear Semicasual' | fmt -1 )
$ fc-cache -f -v
```
<!--endsec-->

### [Comic Mono](https://dtinth.github.io/comic-mono-font/)

> [!NOTE|label:references:]
> - [knolljo/comic-mono-nerd](https://codeberg.org/knolljo/comic-mono-nerd)

- [Comic Mono](https://dtinth.github.io/comic-mono-font/ComicMono.ttf)
- [Comic Mono for NF](https://github.com/xtevenx/ComicMonoNF) or [here](https://codeberg.org/knolljo/comic-mono-nerd/raw/branch/master/ComicMonoNerd.ttf)

[![ComicMono vim](../screenshot/vim/vim-airline-ale-comicmono.png)](https://marslo.github.io/ibook/screenshot/vim/vim-airline-ale-comicmono.png)

[![ComicMonoNF bash](../screenshot/tools/fonts/bash-ComicMonoNF.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-ComicMonoNF.png)

### [Agave](https://github.com/blobject/agave)

> [!NOTE|label:references:]
> - [Agave Nerd Font Mono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Agave)

- [AgaveNerdFontMono-Regular.ttf](https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf)
- [AgaveNerdFontMono-Bold.ttf](https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Bold.ttf)

```bash
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Bold.ttf
```

[![Agave NF Mono](../screenshot/vim/vim-airline-ale-agave.png)](https://marslo.github.io/ibook/screenshot/vim/vim-airline-ale-agave.png)

[![AgaveNFM bash](../screenshot/tools/fonts/bash-AgaveNFM.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-AgaveNFM.png)

### [Operator Mono](https://www.typography.com/fonts/operator/styles/operatormono)

> [!NOTE|label:referencess:]
> - [40huo/Patched-Fonts - otf](https://github.com/40huo/Patched-Fonts) | [NF patched fonts - otf](https://github.com/keyding/Operator-Mono/tree/c67835e29097946b19fb3061ba661ee3bf61e57e)
> - [* xiyaowong/Operator-Fonts - ttf](https://github.com/xiyaowong/Operator-Fonts) | [mirror](https://github.com/marslo/Operator-Fonts)
> - [* beichensky/Font](https://github.com/beichensky/Font) | [为VSCode 设置好看的字体：Operator Mono](https://blog.csdn.net/zgd826237710/article/details/94137781?spm=1001.2014.3001.5501) | [mirror](https://github.com/imarslo/Font)
> - [补丁字体：Operator Mono的书呆子字体补丁](https://download.csdn.net/download/weixin_42104778/15068342)
> - [ajaybhatia/operator-mono-nerd-fonts](https://github.com/ajaybhatia/operator-mono-nerd-fonts) | [mirror](https://github.com/imarslo/operator-mono-nerd-fonts)
> - [TarunDaCoder/OperatorMono_NerdFont](https://github.com/TarunDaCoder/OperatorMono_NerdFont) | [mirror](https://github.com/imarslo/OperatorMono_NerdFont)
> - ligatures:
>   - [Operator Mono Ligatures Files](https://sourceforge.net/projects/operator-mono-ligatures.mirror/files/v2.5.2/)
>   - [kiliman/operator-mono-lig](https://github.com/kiliman/operator-mono-lig/tree/master)


[![operator mono + airline](../screenshot/tools/fonts/bash-operatorMonoNerd-airline.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-operatorMonoNerd-airline.png)

[![nvim python operator mono nf + coc + nerdtree + devicon](../screenshot/tools/fonts/nvim-operator-mono-nerdtree-devicon-coc.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/nvim-operator-mono-nerdtree-devicon-coc.png)

- patched via `Nerd Fonts Patcher v3.2.1.1 (4.13.1) (ff 20230101)`

  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/marslo/fonts/raw/fonts/Operator/OperatorMono/OperatorMono-Light.otf \
         https://github.com/marslo/fonts/raw/fonts/Operator/OperatorMono/OperatorMono-LightItalic.otf
  ```

  <!--sec data-title="previous version" data-id="section1" data-show=true data-collapse=true ces-->
  ```bash
  # Mono NF otf
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/40huo/Patched-Fonts/raw/master/operator-mono-nerd-font/Operator%20Mono%20Light%20Italic%20Nerd%20Font%20Complete.otf \
         https://github.com/40huo/Patched-Fonts/raw/master/operator-mono-nerd-font/Operator%20Mono%20Light%20Italic%20Nerd%20Font%20Complete.otf

  # Mono NF ttf
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/xiyaowong/Operator-Fonts/raw/master/Operator%20Mono%20Nerd%20Font/Operator%20Mono%20Light%20Italic%20Nerd%20Font%20Complete.ttf \
         https://github.com/xiyaowong/Operator-Fonts/raw/master/Operator%20Mono%20Nerd%20Font/Operator%20Mono%20Light%20Italic%20Nerd%20Font%20Complete.ttf

  # Pro NF
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/xiyaowong/Operator-Fonts/raw/master/Operator%20Pro%20Nerd%20Font/Operator%20Pro%20Light%20Italic%20Nerd%20Font%20Complete.ttf \
         https://github.com/xiyaowong/Operator-Fonts/raw/master/Operator%20Pro%20Nerd%20Font/Operator%20Pro%20Light%20Nerd%20Font%20Complete.ttf

  $ showfonts | grep -e ': Operator.*Nerd Font'
  Operator Mono Light Nerd Font Complete.otf        : OperatorMono Nerd Font
  Operator Pro Light Italic Nerd Font Complete.ttf  : OperatorPro Nerd Font
  Operator Pro Light Nerd Font Complete.ttf         : OperatorPro Nerd Font
  Operator Mono Light Italic Nerd Font Complete.otf : OperatorMono Nerd Font
  ```
  <!--endsec-->

- ligatures

  ```bash
  $ ext='otf'             # or ext='ttf'
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/marslo/fonts/raw/fonts/Operator/OperatorMonoLigNF/OperatorMonoLigNerdFontMono-Light."${ext}" \
         https://github.com/marslo/fonts/raw/fonts/Operator/OperatorMonoLigNF/OperatorMonoLigNerdFontMono-LightItalic."${ext}"
  ```

  <!--sec data-title="previous version" data-id="section2" data-show=true data-collapse=true ces-->
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         -fsSL --remote-name-all \
         https://github.com/beichensky/Font/raw/master/Operator%20Mono%20Lig/OperatorMonoLig-Light.otf \
         https://github.com/beichensky/Font/raw/master/Operator%20Mono%20Lig/OperatorMonoLig-LightItalic.otf

  $ showfonts | grep -e ': operator.*lig'
  OperatorMonoLig-LightItalic.otf                   : Operator Mono Lig
  OperatorMonoLig-Light.otf                         : Operator Mono Lig
  ```
  <!--endsec-->

- vim configure

  [![operator mono](../screenshot/tools/fonts/bash-operatorMonoNerd.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-operatorMonoNerd.png)

  [![nvim operator mono ligatures](../screenshot/tools/fonts/nvim-operator-mono-lig.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/nvim-operator-mono-lig.png)

  ```vim
  Plug 'morhetz/gruvbox'                                              " ╮
  Plug 'sainnhe/gruvbox-material'                                     " ├ theme
  Plug 'luisiacc/gruvbox-baby', { 'branch': 'main' }                  " ╯
  Plug 'rrethy/vim-hexokinase', { 'do': 'make hexokinase' }

  set go=                                                             " hide everything (go = guioptions)
  set cpoptions+=n
  set guifont=OperatorMono\ Nerd\ Font\ Mono:h29                      " ╭ nerd font ╮ keep only one
  set guifont=OperatorMonoLig\ Nerd\ Font\ Mono:h29                   " ╰ ligatures ╯
  set renderoptions=type:directx,renmode:5

  if has( 'gui_running' ) || 'xterm-256color' == $TERM
    set background=dark
    colorscheme gruvbox-material                                      " sainnhe/gruvbox-material
  endif
  ```

### [Gohu](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Gohu)

[![GohuNF vim](../screenshot/vim/vim-airline-ale-2.png)](https://marslo.github.io/ibook/screenshot/vim/vim-airline-ale-2.png)

[![GohuNF bash](../screenshot/tools/fonts/bash-Gohu.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-Gohu.png)

```bash
$ curl --create-dirs -O --output-dir "${fontsPath}" \
       -fsSL --remote-name-all \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/uni-14/GohuFontuni14NerdFontMono-Regular.ttf \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/uni-11/GohuFontuni11NerdFontMono-Regular.ttf \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/14/GohuFont14NerdFontMono-Regular.ttf \
       https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Gohu/11/GohuFont11NerdFontMono-Regular.ttf &&
  fc-cache -f -v
```

### [Monaspace RN](https://monaspace.githubnext.com/)

> [!NOTE|label:references:]
> - [monaspace nerd font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Monaspace)
> - [Monaspace.zip](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.zip) | [Monaspace.tar.xz](https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Monaspace.tar.xz)

[![monaspace rn NF](../screenshot/tools/fonts/bash-MonaspaceRN.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-MonaspaceRN.png)

[![monaspace rn NF + coc + nerdtree + hexokinase](../screenshot/tools/fonts/bash-MonaspaceRN-coc-nerdtree-hexokinase.png)](https://marslo.github.io/ibook/screenshot/tools/fonts/bash-MonaspaceRN-coc-nerdtree-hexokinase.png)

## nerd-fonts

> [!NOTE|label:refereces:]
> - [download](https://www.nerdfonts.com/font-downloads)
> - [Karmenzind/monaco-nerd-fonts](https://github.com/Karmenzind/monaco-nerd-fonts)
> - [xtevenx/ComicMonoNF](https://github.com/xtevenx/ComicMonoNF)
> - [#1103 What does --variable-width-glyphs do now?](https://github.com/ryanoasis/nerd-fonts/discussions/1103#discussioncomment-4852120)
>   - `Nerd Font Mono` (a strictly monospaced variant, created with `--mono`)
>   - `Nerd Font` (a somehow monospaced variant, maybe)
>   - `Nerd Font Propo` (a not monospaced variant, created with `--variable-width-glyphs`)

- [AgaveNerdFontMono](https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Agave/AgaveNerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

- [CodeNewRoman](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CodeNewRoman) another `Monaco`
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/CodeNewRoman/Regular/CodeNewRomanNerdFontMono-Regular.otf &&
    fc-cache -f -v
  ```

- [DejaVuSansMono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/DejaVuSansMono) another `Monaco`
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

### pixel
- [BigBlueTerminal](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/BigBlueTerminal)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/BigBlueTerminal/BigBlueTerm437NerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

### hand-writing
- [Monofur](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Monofur)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Monofur/Regular/MonofurNerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

- [ComicShannsMono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/ComicShannsMono)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/ComicShannsMono/ComicShannsMonoNerdFontMono-Regular.otf &&
    fc-cache -f -v
  ```

- [DaddyTimeMono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/DaddyTimeMono)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DaddyTimeMono/DaddyTimeMonoNerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

- [FantasqueSansMono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/FantasqueSansMono)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/FantasqueSansMono/Regular/FantasqueSansMNerdFontMono-Regular.ttf &&
    fc-cache -f -v
```

- [Hermit](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hermit)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hermit/Regular/HurmitNerdFontMono-Regular.otf &&
    fc-cache -f -v
  ```

### symbole
- [NerdFontsSymbolsOnly](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/NerdFontsSymbolsOnly)
  ```bash
  $ curl --create-dirs -O --output-dir "${fontsPath}" \
         https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFontMono-Regular.ttf &&
    fc-cache -f -v
  ```

### others
- [CascadiaCode](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/CascadiaCode)
- [EnvyCodeR](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/EnvyCodeR)
- [IBMPlexMono](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/IBMPlexMono)
- JetBrains [original](https://www.jetbrains.com/lp/mono/) | [JetBrains Nerd Font](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/JetBrainsMono)

## powerline fonts

> [!NOTE|label:references:]
> - [Comic Mono font](https://www.reddit.com/r/programming/comments/kj0prs/comment/ggvwadd/?utm_source=share&utm_medium=web2x&context=3)
> - [Showing special Unicode characters on MacOS](https://discussions.apple.com/thread/251585417)
> - [GNU Unifont Glyphs](https://unifoundry.com/unifont/)
> - [* lujiacn/Monaco for Powerline.md](https://gist.github.com/lujiacn/32b598b1a6a43c996cbd93d42d466466)
>   - [Monaco for Powerline.ttf](https://gist.github.com/lujiacn/32b598b1a6a43c996cbd93d42d466466/raw/5be6ef0e44a3427fdb8343b4dacc29716449c59e/Monaco%2520for%2520Powerline.ttf)
> - [* supermarin/powerline-fonts](https://github.com/supermarin/powerline-fonts)
>   - [Monaco for Powerline.otf](https://github.com/supermarin/powerline-fonts/tree/master/Monaco)
>   - [Menlo Regular for Powerline.otf](https://github.com/supermarin/powerline-fonts/tree/master/Menlo)
>   - [DejaVu Sans Mono for Powerline.otf](https://github.com/supermarin/powerline-fonts/raw/master/DejaVuSansMono/DejaVu%20Sans%20Mono%20for%20Powerline.otf)
> - [* powerline/fonts](https://github.com/powerline/fonts) ~ [AnwarShah/fonts](https://github.com/AnwarShah/fonts)
>   - [Monofur for Powerline.ttf](https://github.com/powerline/fonts/tree/master/Monofur)
> - [* Twixes/SF-Mono-Powerline](https://github.com/Twixes/SF-Mono-Powerline)
> - [* benbusby/anomaly-mono](https://github.com/benbusby/anomaly-mono)
> - [yumitsu/font-menlo-extra](https://github.com/yumitsu/font-menlo-extra)
> - [ithewei/powerline-fonts](https://gitee.com/ithewei/powerline-fonts)
> - [JayXon/powerline-web-fonts](https://github.com/JayXon/powerline-web-fonts)
> - [github topic: powerline-fonts](https://github.com/topics/powerline-fonts)
> - [ryanoasis/nerd-fonts](https://github.com/ryanoasis/nerd-fonts)
> - [Powerline Fonts](https://sourceforge.net/projects/powerline-fonts.mirror/)
> - windows
>   - [Change font for non-legacy command prompt in Windows 10 with non-ASCII charset - Properties vs default values?](https://superuser.com/a/1202335/112396)
>   - [gdetrez/powerline-test.sh](https://gist.github.com/gdetrez/5845092)


- install via package tool
  ```bash
  # debian
  $ sudo apt-get install fonts-powerline

  # centos/rhel
  $ sudo dnf install powerline-fonts
  ```

- install via cmd

  > [!TIP|label:fonts path in different system:]
  > - linux: `$HOME/.local/share/fonts`
  > - osx : `$HOME/Library/Fonts`
  >   ```bash
  >   $ fontPath=$HOME/Library/Fonts
  >   $ fontPath=$HOME/.local/share/fonts
  >   ```

  - via powershell
    ```powershell
    > Invoke-WebRequest -Uri "https://dtinth.github.io/comic-mono-font/ComicMono.ttf" -OutFile "ComicMono.ttf"; Invoke-WebRequest -Uri "https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf" -OutFile "ComicMono-Bold.ttf"; $fonts = (New-Object -ComObject Shell.Application).Namespace(0x14); Get-ChildItem -include ComicMono* | % { $fonts.CopyHere($_.fullname) }
    ```

  - [cominc mono](https://dtinth.github.io) && [comic mono for powerline](https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Comic-Mono-for-Powerline.ttf)
    ```bash
    # regular
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://dtinth.github.io/comic-mono-font/ComicMono.ttf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://dtinth.github.io/comic-mono-font/ComicMono-Bold.ttf &&
      fc-cache -f -v

    # for powerline/vim-airline
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Comic-Mono-for-Powerline.ttf &&
      fc-cache -f -v
    ```

  - [monaco for powerline osx version](https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Monaco-for-Powerline.otf) && [monaco for powerline windows version](https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Monaco-for-Powerline.ttf)
    ```bash
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Monaco-for-Powerline.otf &&
      fc-cache -f -v
    ```

  - [menlo for powerline](https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Menlo-Regular.ttf)
    ```bash
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/marslo/mytools/raw/master/others/fonts/monospace/Menlo-Regular.ttf &&
      fc-cache -f -v
    ```

  - [monofur for powerline](https://github.com/powerline/fonts/tree/master/Monofur)
    ```bash
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/powerline/fonts/raw/master/Monofur/Monofur%20for%20Powerline.ttf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/powerline/fonts/raw/master/Monofur/Monofur%20Italic%20for%20Powerline.ttf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/powerline/fonts/raw/master/Monofur/Monofur%20Bold%20for%20Powerline.ttf &&
      fc-cache -f -v
    ```

  - [sf-mono for powerline](https://github.com/Twixes/SF-Mono-Powerline)
    ```bash
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/Twixes/SF-Mono-Powerline/raw/master/SF-Mono-Powerline-Regular.otf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/Twixes/SF-Mono-Powerline/raw/master/SF-Mono-Powerline-RegularItalic.otf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/Twixes/SF-Mono-Powerline/raw/master/SF-Mono-Powerline-Bold.otf &&
      curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/Twixes/SF-Mono-Powerline/raw/master/SF-Mono-Powerline-BoldItalic.otf &&
      fc-cache -f -v
    ```

  - [anomaly mono for powerline](https://github.com/benbusby/anomaly-mono)
    ```bash
    $ curl --create-dirs -O --output-dir "${fontsPath}" \
           https://github.com/benbusby/anomaly-mono/raw/master/AnomalyMono-Powerline.otf &&
      fc-cache -f -v
    ```

## others

> [!NOTE|label:references:]
> - [分享字体表中的部分中文字体，自取自用 #46](https://github.com/F9y4ng/GreasyFork-Scripts/discussions/46)

# devicons

> [!NOTE|label:references:]
> - [* iMarslo: useful unicode](../cheatsheet/text-processing/text-processing.md#useful-unicode)
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

## coding

| UNICODE | ICON | HTML ENCODING | COMMENTS   |
|:-------:|:----:|:-------------:|------------|
|  `E614` |     |   `&#xE614;`  | # - css    |
|  `F292` |     |   `&#xF292;`  | #          |
|  `EA90` |     |   `&#xEA90;`  | #          |
|  `F198` |     |   `&#xF198;`  | #          |
| `F0423` |   󰐣  |  `&#xF0423;`  | #          |
| `F0423` |   󰐣  |  `&#xF0423;`  | #          |
| `F0424` |   󰐤  |  `&#xF0424;`  | #          |
| `10995` |   𐦕  |   `&#10995;`  | #          |
| `10E98` |   𐺘  |  `&#x10E98;`  | #          |
| `F0F6D` |   󰽭  |  `&#xF0F6D;`  | #          |
| `F1183` |   󱆃  |  `&#xF1183;`  | #!         |
| `F1501` |   󱔁  |  `&#xF1501;`  | !?#        |
| `F12B7` |   󱊷  |  `&#xF12B7;`  | ESC        |
|  `F295` |     |   `&#xF295;`  | %          |
| `F1278` |   󱉸  |  `&#xF1278;`  | %          |
| `F03F0` |   󰏰  |  `&#xF03F0;`  | %          |
|  `F852` |     |   `&#xF852;`  | %          |
| `F0353` |   󰍓  |  `&#xF0353;`  | %          |
| `F1033` |   󱀳  |  `&#xF1033;`  | %          |
| `F046F` |   󰑯  |  `&#xF046F;`  | %          |
|  `E60C` |     |   `&#xE60C;`  | JS         |
|  `E74E` |     |   `&#xE74E;`  | JS         |
|  `F81D` |     |   `&#xF81D;`  | JS         |
|  `E781` |     |   `&#xE781;`  | JS         |
|  `F898` |     |   `&#xF898;`  | JS         |
| `F0399` |   󰎙  |  `&#xF0399;`  | JS         |
| `F06E6` |   󰛦  |  `&#xF06E6;`  | TS         |
|  `E628` |     |   `&#xE628;`  | TS         |
|  `F81A` |     |   `&#xF81A;`  | C#         |
| `F031B` |   󰌛  |  `&#xF031B;`  | C#         |
|  `E648` |     |   `&#xE648;`  | c#         |
|  `E649` |     |   `&#xE649;`  | C          |
| `F0671` |   󰙱  |  `&#xF0671;`  | C          |
| `F0672` |   󰙲  |  `&#xF0672;`  | C++        |
|  `E61D` |     |   `&#xE61D;`  | C++        |
|  `E646` |     |   `&#xE646;`  | C++        |
|  `E64B` |     |   `&#xE64B;`  | UDA        |
|  `E651` |     |   `&#xE651;`  | D          |
|  `FD42` |   ﵂  |   `&#xFD42;`  | V          |
| `F0844` |   󰡄  |  `&#xF0844;`  | V          |
| `F07D4` |   󰟔  |  `&#xF07D4;`  | R          |
|  `E612` |     |   `&#xE612;`  | txt        |
|  `E64E` |     |   `&#xE64E;`  | txt        |
|  `F2C5` |     |   `&#xF2C5;`  | (fire)     |
|  `E242` |     |   `&#xE242;`  | (fire)     |
| `F10D7` |   󱃗  |  `&#xF10d7;`  | ()         |
| `F10FA` |   󱃺  |  `&#xF10FA;`  | ()         |
| `F0172` |   󰅲  |  `&#xF0172;`  | ()         |
| `F0AE7` |   󰫧  |  `&#xF0AE7;`  | (x)        |
| `F1111` |   󱄑  |  `&#xF1111;`  | (x)        |
|  `E6B2` |     |   `&#xE6B2;`  | [T]        |
|  `EA8A` |     |   `&#xEA8A;`  | []         |
| `F016A` |   󰅪  |  `&#xF016A;`  | []         |
| `F0168` |   󰅨  |  `&#xF0168;`  | []         |
| `F10F5` |   󱃵  |  `&#xF10F5;`  | []         |
| `F10F6` |   󱃶  |  `&#xF10F6;`  | []         |
| `F0A3E` |   󰨾  |  `&#xF0A3E;`  | [..]       |
|  `EA8B` |     |   `&#xEA8B;`  | {}         |
|  `EB0F` |     |   `&#xEB0F;`  | {}         |
| `F10D6` |   󱃖  |  `&#xF10D6;`  | {}         |
| `F10F7` |   󱃷  |  `&#xF10F7;`  | {}         |
| `F10F8` |   󱃸  |  `&#xF10F8;`  | {}         |
|  `E60B` |     |   `&#xE60B;`  | {}         |
| `F0169` |   󰅩  |  `&#xF0169;`  | {}         |
| `F07B5` |   󰞵  |  `&#xF07B5;`  | {}         |
|  `EBE5` |     |   `&#xEBE5;`  | {}         |
|  `EBE6` |     |   `&#xEBE6;`  | {}         |
| `F0626` |   󰘦  |  `&#xF0626;`  | {..}       |
|  `FB25` |   ﬥ  |   `&#xFB25;`  | {...}      |
|  `E618` |     |   `&#xE618;`  | <>         |
|  `F44F` |     |   `&#xF44F;`  | <>         |
| `F0174` |   󰅴  |  `&#xF0174;`  | <>         |
|  `E60E` |     |   `&#xE60E;`  | <>         |
| `F0761` |   󰝡  |  `&#xF0761;`  | <>         |
| `F054F` |   󰕏  |  `&#xF054F;`  | <>         |
| `F0694` |   󰚔  |  `&#xF0694;`  | <>         |
| `F0171` |   󰅱  |  `&#xF0171;`  | <>         |
| `F022E` |   󰈮  |  `&#xF022E;`  | <>         |
|  `F4b0` |     |   `&#xF4b0;`  | <>         |
|  `F40D` |     |   `&#xF40D;`  | <>         |
|  `EAE9` |     |   `&#xEAE9;`  | <>         |
| `F102B` |   󱀫  |  `&#xF102B;`  | <>         |
|  `E7A3` |     |   `&#xE7A3;`  | </>        |
|  `F1C9` |     |   `&#xF1C9;`  | </>        |
|  `E796` |     |   `&#xE796;`  | </>        |
|  `F121` |     |   `&#xF121;`  | </>        |
|  `EAC4` |     |   `&#xEAC4;`  | </>        |
| `F05C0` |   󰗀  |  `&#xF05C0;`  | </>        |
|  `EA92` |     |   `&#xEA92;`  | `<T>`      |
|  `E67C` |     |   `&#xE67C;`  | (:a)       |
|  `F4B5` |     |   `&#xF4B5;`  | >_         |
|  `F120` |     |   `&#xF120;`  | >_         |
|  `E7A2` |     |   `&#xE7A2;`  | >_         |
|  `E683` |     |   `&#xE683;`  | >_         |
| `F07B7` |   󰞷  |  `&#xF07B7;`  | >_         |
|  `F489` |     |   `&#xF489;`  | >_         |
|  `EA85` |     |   `&#xEA85;`  | >_         |
|  `E285` |     |   `&#xE285;`  | >          |
|  `E795` |     |   `&#xE795;`  | >_         |
|  `F460` |     |   `&#xF460;`  | >          |
| `F016C` |   󰅬  |  `&#xF016C;`  | >          |
|  `E758` |     |   `&#xE758;`  | {less}     |
|  `E256` |     |   `&#xE256;`  | java       |
|  `E738` |     |   `&#xE738;`  | java       |
| `F0B37` |   󰬷  |  `&#xF0B37;`  | java       |
|  `E204` |     |   `&#xE204;`  | java       |
|  `E005` |     |   `&#xE005;`  | java       |
|  `E66D` |     |   `&#xE66D;`  | java       |
| `F0617` |   󰘗  |  `&#xF0617;`  | java       |
|  `E61B` |     |   `&#xE61B;`  | cjsx       |
|  `E65E` |     |   `&#xE65E;`  | go         |
|  `E626` |     |   `&#xE626;`  | go         |
|  `E724` |     |   `&#xE724;`  | go         |
|  `F2A5` |     |   `&#xF2A5;`  | g          |
|  `F2A6` |     |   `&#xF2A6;`  | g          |
|  `F0D5` |     |   `&#xF0D5;`  | g+         |
| `F02BD` |   󰊽  |  `&#xF02BD;`  | g+         |
|  `F0D4` |     |   `&#xF0D4;`  | g+         |
|  `F2B3` |     |   `&#xF2B3;`  | g+         |
| `F03BF` |   󰎿  |  `&#xF03BF;`  | g+         |
| `F0CB2` |   󰲲  |  `&#xF0CB2;`  | g+         |
|  `E7B0` |     |   `&#xE7B0;`  | docker     |
|  `F308` |     |   `&#xF308;`  | docker     |
|  `E650` |     |   `&#xE650;`  | docker     |
| `F0868` |   󰡨  |  `&#xF0868;`  | docker     |
|  `E7C5` |     |   `&#xE7C5;`  | vim        |
|  `E62B` |     |   `&#xE62B;`  | vim        |
|  `F194` |     |   `&#xF194;`  | vim        |
|  `F27D` |     |   `&#xF27D;`  | vim        |
|  `FA76` |  勇  |   `&#xFA76;`  | vim        |
|  `FA77` |  勺  |   `&#xFA77;`  | vim        |
|  `F194` |     |   `&#xF194;`  | vim        |
|  `F1CA` |     |   `&#xF1CA;`  | vim        |
|  `F36F` |     |   `&#xF36F;`  | neovim     |
|  `E235` |     |   `&#xE235;`  | python     |
| `F0320` |   󰌠  |  `&#xF0320;`  | python     |
|  `E73E` |     |   `&#xE73E;`  | markdown   |
|  `F853` |     |   `&#xF853;`  | markdown   |
| `F0354` |   󰍔  |  `&#xF0354;`  | markdown   |
| `F072F` |   󰜯  |  `&#xF072F;`  | markdown   |
| `F0DFB` |   󰷻  |  `&#xF0DFB;`  | markdown   |
|  `E673` |     |   `&#xE673;`  | makefile   |
|  `F858` |     |   `&#xF858;`  | maxcdn     |
|  `F136` |     |   `&#xF136;`  | maxcdn     |
|  `E616` |     |   `&#xE616;`  | npm        |
| `F06F7` |   󰛷  |  `&#xF06F7;`  | npm        |
|  `E767` |     |   `&#xE767;`  | jenkins    |
|  `E66E` |     |   `&#xE66E;`  | jenkins    |
|  `F2EC` |     |   `&#xF2EC;`  | *jenkins   |
|  `F4E5` |     |   `&#xF4E5;`  | png        |
| `F0D78` |   󰵸  |  `&#xF0D78;`  | gif        |
| `F0225` |   󰈥  |  `&#xF0225;`  | jpg        |
| `F0E2D` |   󰸭  |  `&#xF0E2D;`  | png        |
| `F0226` |   󰈦  |  `&#xF0226;`  | pdf        |
|  `F4A5` |     |   `&#xF4A5;`  | file       |
|  `EB9D` |     |   `&#xEB9D;`  | file       |
|  `F15C` |     |   `&#xF15C;`  | file       |
|  `EAE8` |     |   `&#xEAE8;`  | file       |
|  `F471` |     |   `&#xF471;`  | file       |
| `F1085` |   󱂅  |  `&#xF1085;`  | log        |
|  `E7B4` |     |   `&#xE7B4;`  | Ai         |
|  `E67F` |     |   `&#xE67F;`  | Ps         |
|  `E73D` |     |   `&#xE73D;`  | php        |
| `F08C0` |   󰣀  |  `&#xF08C0;`  | ssh        |
|  `F1D3` |     |   `&#xF1D3;`  | git        |
|  `F1D2` |     |   `&#xF1D2;`  | git        |
|  `E776` |     |   `&#xE776;`  | ngix       |
|  `E791` |     |   `&#xE791;`  | ruby       |
|  `E739` |     |   `&#xE739;`  | ruby       |
|  `E21E` |     |   `&#xE21E;`  | ruby       |
|  `E719` |     |   `&#xE719;`  | node       |
| `F0AA9` |   󰪩  |  `&#xF0AA9;`  | database   |
| `F0AAA` |   󰪪  |  `&#xF0AAA;`  | database   |
|  `E7AA` |     |   `&#xE7AA;`  | S          |
|  `E72C` |     |   `&#xE72C;`  | TC         |
|  `E7BC` |     |   `&#xE7BC;`  | CS         |
| `F0AAE` |   󰪮  |  `&#xF0AAE;`  | .net       |
|  `E69B` |     |   `&#xE69B;`  | tex        |
| `F044D` |   󰑍  |  `&#xF044D;`  | reddit     |
|  `E704` |     |   `&#xE704;`  | mysql      |
|  `E7A6  |     |   `&#xE7A6;`  | mysql      |
| `F12A7` |   󱊧  |   `&#F12A7;`  | 0x         |
|  `E600` |     |   `&#xE600;`  | stylus     |
|  `E759` |     |   `&#E759;`   | dev stylus |

## folders

| UNICODE | ICON | HTML ENCODING | COMMENTS  |
|:-------:|:----:|:-------------:|-----------|
|  `F07B` |     |   `&#xF07B;`  | close     |
|  `F07C` |     |   `&#xF07C;`  | open      |
|  `F114` |     |   `&#xF114;`  | close     |
|  `y115` |     |   `&#xF115;`  | open      |
|  `F067` |     |   `&#xF067;`  | close (+) |
|  `F068` |     |   `&#xF068;`  | open (-)  |
|  `F45B` |     |   `&#xF45B;`  | open (-)  |
|  `F2D1` |     |   `&#xF2D1;`  | open (-)  |
|  `F48B` |     |   `&#xF48B;`  | open (-)  |

## platform

| UNICODE | ICON | HTML ENCODING | COMMENTS |
|:-------:|:----:|:-------------:|----------|
|  `F302` |     |   `&#xF302;`  | mac      |
|  `E711` |     |   `&#xE711;`  | mac      |
|  `F8FF` |     |   `&#xF8FF;`  | mac      |
| `F0037` |   󰀷  |  `&#xF0037;`  | ios      |
|  `F316` |     |   `&#xF316;`  | redhat   |
|  `E7BB` |     |   `&#xE7BB;`  | redhat   |
|  `E712` |     |   `&#xE712;`  | linux    |
|  `F31A` |     |   `&#xF31A;`  | linux    |
|  `EBC6` |     |   `&#xEBC6;`  | linux    |
|  `F17C` |     |   `&#xF17C;`  | linux    |
| `F033D` |   󰌽  |  `&#xF033D;`  | linux    |
|  `F314` |     |   `&#xF314;`  | opensuse |
|  `F31B` |     |   `&#xF31B;`  | ubuntu   |
|  `EBC9` |     |   `&#xEBC9;`  | ubuntu   |
|  `F31C` |     |   `&#xF31C;`  | ubuntu   |
|  `E73A` |     |   `&#xE73A;`  | ubuntu   |
|  `E62A` |     |   `&#xE62A;`  | windows  |
|  `F17A` |     |   `&#xF17A;`  | windows  |
|  `E70F` |     |   `&#xE70F;`  | windows  |
| `F05B3` |   󰖳  |  `&#xF05B3;`  | windows  |
| `F0A21` |   󰨡  |  `&#xF0A21;`  | windows  |
|  `EBC5` |     |   `&#xEBC5;`  | debian   |
|  `F306` |     |   `&#xF306;`  | debian   |
|  `E77D` |     |   `&#xE77D;`  | debian   |
|  `E722` |     |   `&#xE722;`  | RPi      |
|  `EF5C` |     |   `&#xEF5C;`  | RPi      |
|  `F304` |     |   `&#xF304;`  | centos   |
|  `E70E` |     |   `&#xE70E;`  | android  |
|  `F17B` |     |   `&#xF17B;`  | android  |

## math

| UNICODE | ICON | HTML ENCODING | COMMENTS      |
|:-------:|:----:|:-------------:|---------------|
|  `F89F` |     |   `&#xF89F;`  | 123           |
| `F03A0` |   󰎠  |  `&#xF03A0;`  | 123           |
|  `F4F7` |     |   `&#xF4F7;`  | 123           |
| `F172A` |   󱜪  |  `&#xF172A;`  | 5.1.2         |
| `F1729` |   󱜩  |  `&#xF1729;`  | 2.1           |
| `F1052` |   󱁒  |  `&#xF1052;`  | -1            |
| `F15CB` |   󱗋  |  `&#xF15CB;`  | +1            |
| `F1992` |   󱦒  |  `&#xF1992;`  | 1/2           |
| `F01C9` |   󰇉  |  `&#xF01C9;`  | A/B           |
| `F0195` |   󰆕  |  `&#xF0195;`  | +/-           |
| `F14C9` |   󱓉  |  `&#xF14C9;`  | +/-           |
|  `F440` |     |   `&#xF440;`  | +-            |
|  `EB64` |     |   `&#xEB64;`  | +-x%          |
| `F0993` |   󰦓  |  `&#xF0993;`  | +-            |
| `F01D5` |   󰇕  |  `&#xF01D5;`  | ➗            |
| `F12EA` |   󱋪  |  `&#xF12EA;`  | ➗            |
| `F0963` |   󰥣  |  `&#xF0963;`  | x^y           |
| `F0964` |   󰥤  |  `&#xF0964;`  | x^y           |
|  `F12B` |     |   `&#xF12B;`  | x^2           |
| `F0283` |   󰊃  |  `&#xF0283;`  | x^2           |
|  `F12C` |     |   `&#xF12C;`  | x2 subscript  |
| `F0282` |   󰊂  |  `&#xF0282;`  | x2 subscript  |
|  `F506` |     |   `&#xF506;`  | ./            |
| `F096E` |   󰥮  |  `&#xF096E;`  | >=            |
| `F097D` |   󰥽  |  `&#xF097D;`  | <=            |
| `F098E` |   󰦎  |  `&#xF098E;`  | !=            |
| `F098D` |   󰦍  |  `&#xF098D;`  | !=            |
| `F0170` |   󰅰  |  `&#xF0170;`  | !=            |
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
| `F0295` |   󰊕  |  `&#xF0295;`  | function      |
| `F0871` |   󰡱  |  `&#xF0871;`  | function of x |
| `1D6FB` |   𝛻  |   `&#1D6FB;`  | nabla         |
| `F002B` |   󰀫  |   `&#F002B;`  | alpha         |
| `1D6FC` |   𝛼  |   `&#1D6FC;`  | alpha         |
| `1D6FD` |   𝛽  |   `&#1D6FD;`  | beta          |
| `1D6FE` |   𝛾  |   `&#1D6FE;`  | gamma         |
| `1D6FF` |   𝛿  |   `&#1D6FF;`  | delta         |
| `1D700` |   𝜀  |   `&#1D700;`  | epsilon       |
| `1D701` |   𝜁  |   `&#1D701;`  | zeta          |
| `1D702` |   𝜂  |   `&#1D702;`  | eta           |
| `1D703` |   𝜃  |   `&#1D703;`  | theta         |
| `1D704` |   𝜄  |   `&#1D704;`  | iota          |
| `1D705` |   𝜅  |   `&#1D705;`  | kappa         |
| `1D706` |   𝜆  |   `&#1D706;`  | lambda        |
| `1D707` |   𝜇  |   `&#1D707;`  | mu            |
| `1D708` |   𝜈  |   `&#1D708;`  | nu            |
| `1D709` |   𝜉  |   `&#1D709;`  | xi            |
| `1D70A` |   𝜊  |   `&#1D70A;`  | omicron       |
| `1D70B` |   𝜋  |   `&#1D70B;`  | pi            |
| `1D70C` |   𝜌  |   `&#1D70C;`  | rho           |
| `1D70D` |   𝜍  |   `&#1D70D;`  | sigma         |
| `1D70E` |   𝜎  |   `&#1D70E;`  | tau           |
| `1D70F` |   𝜏  |   `&#1D70F;`  | upsilon       |
| `1D710` |   𝜐  |   `&#1D710;`  | phi           |
| `1D711` |   𝜑  |   `&#1D711;`  | chi           |

## graph

| UNICODE | ICON | HTML ENCODING | COMMENTS          |
|:-------:|:----:|:-------------:|-------------------|
|  `F4BC` |     |   `&#xF4BC;`  | chip - cpu        |
|  `F85A` |     |   `&#xF85A;`  | chip - cpu        |
| `F035B` |   󰍛  |  `&#xF035B;`  | chip - cpu        |
|  `F2DB` |     |   `&#xF2DB;`  | chip - 64bit      |
|  `E266` |     |   `&#xE266;`  | chip              |
| `F0EDF` |   󰻟  |  `&#xF0EDF;`  | chip - 32bit      |
| `F0EE0` |   󰻠  |  `&#xF0EE0;`  | chip - 64bit      |
| `F1362` |   󱍢  |  `&#xF1362;`  | google downasaur  |
| `F1362` |   󱍢  |  `&#xF1362;`  | google downasaur  |
| `F02A0` |   󰊠  |  `&#xF02A0;`  | ghost             |
|  `E241` |     |   `&#xE241;`  | footprint         |
| `F0DFA` |   󰷺  |  `&#xF0DFA;`  | footprint         |
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
| `F1957` |   󱥗  |  `&#xF1957;`  | chips             |
|  `E763` |     |   `&#xE763;`  | cola              |
| `F01E5` |   󰇥  |  `&#xF01E5;`  | dark              |
| `10996` |   𐦖  |   `&#10996;`  | dark              |
| `F02CB` |   󰋋  |  `&#xF02CB;`  | headphone         |
| `F1852` |   󱡒  |   `&#F1852;`  | earbuds           |
| `F04B2` |   󰒲  |  `&#xF04B2;`  | sleep             |
| `F04B3` |   󰒳  |  `&#xF04B3;`  | sleep off         |
|  `E61C` |     |   `&#xE61C;`  | twig              |
|  `E006` |     |   `&#xE006;`  | coconut tree      |
|  `32DB` |  ㋛  |   `&#32DB;`   | smile             |
|  `32E1` |  ㋡  |   `&#32E1;`   | smile             |

## tiaji

| UNICODE | ICON | HTML ENCODING | COMMENTS |
|:-------:|:----:|:-------------:|----------|
| `1D300` |   𝌀  |   `&#1D300;`  | -        |
| `1D301` |   𝌁  |   `&#1D301;`  | -        |
| `1D302` |   𝌂  |   `&#1D302;`  | -        |
| `1D303` |   𝌃  |   `&#1D303;`  | -        |
| `1D304` |   𝌄  |   `&#1D304;`  | -        |
| `1D305` |   𝌅  |   `&#1D305;`  | -        |

## misc.

| UNICODE | ICON | HTML ENCODING | COMMENTS            |
|:-------:|:----:|:-------------:|---------------------|
| `F1050` |   󱁐  |   `&#F1050;`  | space               |
|  `E672` |     |   `&#xE672;`  | lock                |
|  `F023` |     |   `&#xF023;`  | lock                |
|  `F52A` |     |   `&#xF52A;`  | unlock              |
|  `EBE7` |     |   `&#xEBE7;`  | lock                |
|  `EB74` |     |   `&#xEB74;`  | unlock              |
|  `F09C` |     |   `&#xF09C;`  | unlock              |
|  `F084` |     |   `&#xF084;`  | key                 |
|  `F43D` |     |   `&#xF43D;`  | key                 |
| `F030B` |   󰌋  |  `&#xF030B;`  | key                 |
| `F0306` |   󰌆  |  `&#xF0306;`  | key                 |
| `F1184` |   󱆄  |  `&#xF1184;`  | key                 |
| `F1185` |   󱆅  |  `&#xF1185;`  | key                 |
|  `E60A` |     |   `&#xE60A;`  | key                 |
|  `F255` |     |   `&#xF255;`  | mouse drag          |
|  `F256` |     |   `&#xF256;`  | mouse               |
| `F027E` |   󰉾  |  `&#xF027E;`  | ”                   |
| `F0757` |   󰝗  |  `&#xF0757;`  | “                   |
|  `F10D` |     |   `&#xF10D;`  | “                   |
|  `F10E` |     |   `&#xF10E;`  | ”                   |
| `F11A8` |   󱆨  |  `&#xF11A8;`  | ”                   |
| `F11A7` |   󱆧  |  `&#xF11A7;`  | “                   |
|  `EB33` |     |   `&#xEB33;`  | “                   |
| `F1022` |   󱀢  |   `&#F1022;`  | “                   |
| `F1021` |   󱀡  |   `&#F1021;`  | “                   |
| `F0E25` |   󰸥  |   `&#F0E25;`  | ,                   |
| `F0E24` |   󰸤  |   `&#F0E24;`  | ,                   |
| `F0E26` |   󰸦  |   `&#F0E26;`  | ,                   |
| `F0E23` |   󰸣  |   `&#F0E23;`  | ,                   |
|  `F30C` |     |   `&#xF30C;`  | monster             |
|  `E651` |     |   `&#xE651;`  | D                   |
|  `E66D` |     |   `&#xE66D;`  | J                   |
|  `F8E2` |     |   `&#xF8E2;`  | P                   |
|  `E279` |     |   `&#xE279;`  | =                   |
|  `E27A` |     |   `&#xE27A;`  | =>                  |
|  `E374` |     |   `&#xE374;`  | N/A                 |
|  `F893` |     |   `&#xF893;`  | menu                |
|  `E615` |     |   `&#xE615;`  | tool                |
|  `F013` |     |   `&#xF013;`  | tool                |
| `F0493` |   󰒓  |  `&#xF0493;`  | tool                |
| `F0494` |   󰒔  |  `&#xF0494;`  | tool                |
|  `EB65` |     |   `&#xEB65;`  | tool                |
| `F05B7` |   󰖷  |   `&#F05B7;`  | tool                |
|  `EB6D` |     |   `&#xEB6D;`  | tool                |
| `F1064` |   󱁤  |  `&#xF1064;`  | tool                |
|  `F425` |     |   `&#xF425;`  | tool                |
| `F0DDF` |   󰷟  |   `&#F0DDF;`  | tool - nail         |
| `F08EA` |   󰣪  |  `&#xF08EA;`  | hammer              |
|  `F0E3` |     |   `&#xF0E3;`  | hammer              |
| `F1842` |   󱡂󠠂  |  `&#xF1842;`  | hammer              |
| `F08B7` |   󰢷  |   `&#F08B7;`  | hammer              |
|  `EEFF` |     |   `&#EEFF;`   | *hammer             |
|  `F204` |     |   `&#xF204;`  | switch off          |
|  `F205` |     |   `&#xF205;`  | switch on           |
| `F0A19` |   󰨙  |  `&#xF0A19;`  | switch off          |
| `F0A1A` |   󰨚  |  `&#xF0A1A;`  | switch off          |
| `F0521` |   󰔡  |  `&#xF0521;`  | switch on           |
|  `E688` |     |   `&#xE688;`  | -                   |
|  `E717` |     |   `&#xE717;`  | github              |
|  `F4B8` |     |   `&#xF4B8;`  | copilot             |
|  `F480` |     |   `&#xF480;`  | gist                |
|  `E783` |     |   `&#xE783;`  | stretch             |
| `F0274` |   󰉴  |  `&#xF0274;`  | H#                  |
| `F0504` |   󰔄  |  `&#xF0504;`  | °C                  |
|  `E339` |     |   `&#xE339;`  | °C                  |
| `F0505` |   󰔅  |  `&#xF0505;`  | °F                  |
|  `E341` |     |   `&#xE341;`  | °F                  |
|  `E6A2` |     |   `&#xE6A2;`  | WA                  |
| `F0435` |   󰐵  |   `&#F0435;`  | HQ                  |
| `F0A0C` |   󰨌  |   `&#F0A0C;`  | LQ                  |
| `F07EF` |   󰟯  |  `&#xF07EF;`  | SD                  |
| `F07FD` |   󰟽  |  `&#xF07FD;`  | 3D                  |
| `F1A1C` |   󱨜  |  `&#xF1A1C;`  | 2D                  |
| `F083E` |   󰠾  |  `&#xF083E;`  | HK                  |
| `F0A08` |   󰨈  |  `&#xF0A08;`  | police officer      |
| `F0713` |   󰜓  |   `&#F0713;`  | 3G                  |
| `F0714` |   󰜔  |   `&#F0714;`  | 4G                  |
| `F0A6F` |   󰩯  |  `&#xF0A6F;`  | 5G                  |
| `F0D6E` |   󰵮  |  `&#xF0D6E;`  | DEV                 |
| `F100D` |   󱀍  |  `&#xF100D;`  | ABC                 |
| `F002C` |   󰀬  |  `&#xF002C;`  | abc                 |
|  `EA93` |     |   `&#xEA93;`  | abc                 |
| `F100E` |   󱀎  |  `&#xF100E;`  | ABC off             |
| `F132D` |   󱌭  |  `&#xF132D;`  | ab                  |
| `F132F` |   󱌯  |  `&#xF132F;`  | ab                  |
| `F0D47` |   󰵇  |  `&#xF0D47;`  | atm                 |
| `F132E` |   󱌮  |  `&#xF132E;`  | abeta               |
| `F07E4` |   󰟤  |  `&#xF07E4;`  | co2                 |
| `F12FE` |   󱋾  |  `&#xF12FE;`  | CO                  |
| `F13A3` |   󱎣  |  `&#xF13A3;`  | XS                  |
| `F0A78` |   󰩸  |  `&#xF0A78;`  | TM                  |
|  `F25C` |     |   `&#xF25C;`  | TM                  |
|  `E765` |     |   `&#xE765;`  | cisco               |
| `F147D` |   󱑽  |  `&#xF147D;`  | waveform            |
|  `E3BE` |     |   `&#xE3BE;`  | earthquake          |
| `F0A30` |   󰨰  |  `&#xF0A30;`  | bug                 |
|  `EAAF` |     |   `&#xEAAF;`  | bug                 |
| `F0A2F` |   󰨯  |  `&#xF0A2F;`  | bug fixed           |
| `F0A2E` |   󰨮  |  `&#xF0A2E;`  | bug fixed           |
| `F0A3F` |   󰨿  |  `&#xF0A3F;`  | ..]                 |
| `F0A40` |   󰩀  |  `&#xF0A40;`  | [..                 |
| `102E8` |   𐋨  |   `&#102E8;`  | b                   |
| `102C9` |   𐋉  |   `&#102C9;`  | 6                   |
|  `F444` |     |   `&#xF444;`  | dot                 |
|  `EB8A` |     |   `&#xEB8A;`  | dot                 |
|  `F812` |     |   `&#xF812;`  | keyboard            |
| `F09FA` |   󰧺  |   `&#F09FA;`  | keyboard            |
| `F09F9` |   󰧹  |   `&#F09F9;`  | keyboard            |
| `F0313` |   󰌓  |   `&#F0313;`  | keyboard            |
|  `F11C` |     |   `&#F11C;`   | keyboard            |
| `F0E4B` |   󰹋  |   `&#F0E4B;`  | keyboard off        |
| `10669` |   𐙩  |   `&#10669;`  | 中                  |
| `10AE3` |   𐫣  |   `&#10AE3;`  | -                   |
| `16861` |   𖡡  |   `&#16861;`  | map pin             |
| `F0352` |   󰍒  |   `&#F0352;`  | map pin             |
| `F034E` |   󰍎  |   `&#F034E;`  | map pin             |
| `1BC05` |   𛰅  |   `&#1BC05;`  | -                   |
| `1BC06` |   𛰆  |   `&#1BC06;`  | -                   |
| `1BC0A` |   𛰊  |   `&#1BC0A;`  | -                   |
| `1BC0B` |   𛰋  |   `&#1BC0B;`  | -                   |
| `1F000` |   🀀  |   `&#1F000;`  | majiang             |
| `1F001` |   🀁  |   `&#1F001;`  | majiang             |
| `1F002` |   🀂  |   `&#1F002;`  | majiang             |
| `1F003` |   🀃  |   `&#1F003;`  | majiang             |
| `F17C5` |   󱟅  |   `&#F17C5;`  | pH                  |
|  `EE3C` |     |   `&#xEE3C;`  | signature           |
| `F0DFE` |   󰷾  |   `&#F0DFE;`  | signature           |
| `F0DFC` |   󰷼  |   `&#F0DFC;`  | signature           |
| `EE7F`  |     |   `&#EE7F;`   | signature           |
| `1F718` |   🜘  |   `&#1F718;`  | -                   |
| `1F73B` |   🜻  |   `&#1F73B;`  | -                   |
|  `E245` |     |   `&#xE245;`  | -                   |
