<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [linux terminal with solarized](#linux-terminal-with-solarized)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [* vimcolorschemes](https://vimcolorschemes.com/)
> - [Using GUI color settings in a terminal](https://vim.fandom.com/wiki/Using_GUI_color_settings_in_a_terminal)
> - [Using vim color schemes with Putty](https://vim.fandom.com/wiki/Using_vim_color_schemes_with_Putty)

## linux terminal with solarized
- bundle
  ```vim
  " Vim Bundle
  filetype off
  set rtp+=~/.vim/bundle/snipmate.vim/snippets/
  set rtp+=~/.vim/bundle/Vundle.vim/
  call vundle#begin()

  Bundle 'VundleVim/Vundle.vim'
  Bundle 'tpope/vim-pathogen'
  Bundle 'altercation/vim-colors-solarized'

  call vundle#end()
  call pathogen#infect()
  filetype plugin indent on
  syntax enable on
  ```

- solarized
  ```vim
  if has('gui_running') || 'xterm-256color' == $TERM
    set background=dark
    let psc_style='cool'

    """ solarized
    let &t_Co=256
    set t_Co=256
    let g:solarized_termcolors = 256
    let g:solarized_termtrans  = 1

    let g:solarized_extra_hi_groups = 1        " ┐
    let g:solarized_visibility      = "high"   " | nice to have
    let g:solarized_contrast        = "high"   " |
    let s:base03                    = "255"    " ┘

    " set termguicolors                        " do not enable

    colorscheme solarized
  endif
  ```

- customrized colors
  ```vim
  highlight clear SpellBad Conceal PmenuSel SpecialKey Exception Folded TabLineSel Search CorsorLine
  highlight SpellBad       term=underline   cterm=underline     ctermbg=NONE    ctermfg=160
  highlight Conceal        term=NONE        cterm=NONE          ctermbg=NONE    ctermfg=239
  highlight SpecialKey     term=NONE        cterm=NONE          ctermfg=130
  highlight Constant       term=NONE        ctermfg=99
  highlight LineNr         term=NONE        ctermbg=NONE        ctermfg=235     guifg=#586e75
  highlight CursorLineNr   term=underline   cterm=NONE          ctermbg=NONE    ctermfg=124
  highlight CursorLine     term=NONE        cterm=NONE          ctermbg=NONE    ctermfg=NONE
  highlight Exception      term=bold        ctermbg=NONE        ctermfg=136
  highlight Visual         term=NONE        cterm=underline     ctermbg=NONE
  highlight Comment        ctermfg=234      guifg=#002b36
  highlight Folded         term=underline   cterm=underline     ctermfg=235     ctermbg=0
  highlight FoldColumn     term=NONE        cterm=NONE          ctermfg=235     ctermbg=0
  highlight StatusLineNC   term=NONE        cterm=NONE          ctermfg=235     ctermbg=black
  highlight StatusLine     cterm=NONE       ctermfg=238         ctermbg=black
  highlight CmdLineEnter   cterm=NONE       ctermfg=238
  highlight CmdLineLeave   cterm=NONE       ctermfg=238
  highlight MsgArea        cterm=NONE       ctermfg=238
  highlight vimGroup       term=NONE        cterm=NONE          ctermfg=4
  highlight NonText        cterm=NONE       ctermfg=239
  highlight Pmenu          term=NONE        cterm=NONE          ctermfg=2       ctermbg=NONE
  highlight PmenuSel       term=NONE        cterm=NONE          ctermfg=121     ctermbg=NONE
  highlight PmenuSbar      term=NONE        cterm=NONE          ctermfg=15      ctermbg=234
  highlight PmenuThumb     term=NONE        cterm=NONE          ctermfg=15      ctermbg=234
  highlight TabLineSel     term=underline   cterm=underline     ctermbg=NONE
  highlight VertSplit      cterm=NONE       ctermfg=12          ctermbg=NONE
  highlight MatchParen     term=inverse     cterm=inverse
  highlight Search         term=NONE        cterm=NONE          ctermbg=12      ctermfg=4
  highlight Statement      term=NONE        cterm=NONE          ctermfg=11      ctermbg=NONE
  highlight Type           term=NONE        cterm=NONE          ctermfg=136     ctermbg=NONE
  highlight Visual         term=bold,underline   cterm=bold,underline     ctermfg=NONE    ctermbg=NONE

  highlight Normal         ctermfg=23        guifg=#586e75
  highlight Boolean        ctermfg=196
  highlight Number         ctermfg=61
  highlight String         ctermfg=88
  highlight Function       ctermfg=105
  highlight Structure      ctermfg=202
  highlight Define         ctermfg=179
  highlight Conditional    ctermfg=190
  highlight Operator       ctermfg=208

  highlight PreProc        term=NONE        cterm=NONE          ctermfg=166     ctermbg=NONE
  highlight ColorColumn    cterm=NONE       ctermfg=244         ctermbg=NONE
  highlight CollumnLimit   cterm=NONE       ctermfg=244         ctermbg=NONE
  highlight VertSplit      ctermfg=235      gui=reverse
  highlight IncSearch      term=standout    cterm=standout      ctermfg=148     ctermbg=238
  highlight Search         cterm=NONE       ctermfg=64          ctermbg=238     guifg=Black     guibg=Yellow
  ```
