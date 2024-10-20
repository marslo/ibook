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
>   ![extra symbols](https://github.com/ryanoasis/powerline-extra-symbols/blob/master/img/fontforge.png?raw=true)
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

