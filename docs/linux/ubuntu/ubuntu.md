<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [gnome terminal](#gnome-terminal)
- [install ubuntu theme](#install-ubuntu-theme)
- [open font viewer and install font](#open-font-viewer-and-install-font)
- [show launcher icon](#show-launcher-icon)
- [show the softer renderer](#show-the-softer-renderer)
- [specified context menu](#specified-context-menu)
- [disable ubuntu desktop notification](#disable-ubuntu-desktop-notification)
- [recode activity as a gif file](#recode-activity-as-a-gif-file)
- [goldendict installation](#goldendict-installation)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### gnome terminal
- backup
  ```bash
  $ dconf dump /org/gnome/terminal/ > ubuntu1710_terminal_backup.bak
  ```

- restore
  ```bash
  $ dconf load /org/gnome/terminal/ < ubuntu1710_terminal_backup.bak
  ```

- reset
  ```bash
  $ dconf reset -f /org/gnome/terminal
  ```

- list
  ```bash
  $ gsettings list-recursively | grep -i org.gnome.Terminal
  ```

<details><summary>click to check details ...</summary>
<pre><code>$ gsettings list-recursively | grep -i org.gnome.Terminal
org.gnome.Terminal.ProfilesList list ['b1dcc9dd-5262-4d8d-a863-c897e6d979b9']
org.gnome.Terminal.ProfilesList default 'b1dcc9dd-5262-4d8d-a863-c897e6d979b9'
org.gnome.shell favorite-apps ['firefox.desktop', 'org.gnome.Nautilus.desktop', 'org.gnome.Terminal.desktop']
org.gnome.Terminal.Legacy.Settings new-terminal-mode 'window'
org.gnome.Terminal.Legacy.Settings menu-accelerator-enabled true
org.gnome.Terminal.Legacy.Settings tab-position 'top'
org.gnome.Terminal.Legacy.Settings confirm-close true
org.gnome.Terminal.Legacy.Settings shell-integration-enabled true
org.gnome.Terminal.Legacy.Settings theme-variant 'dark'
org.gnome.Terminal.Legacy.Settings default-show-menubar true
org.gnome.Terminal.Legacy.Settings mnemonics-enabled false
org.gnome.Terminal.Legacy.Settings schema-version uint32 3
org.gnome.Terminal.Legacy.Settings encodings ['UTF-8']
org.gnome.Terminal.Legacy.Settings shortcuts-enabled true
org.gnome.Terminal.Legacy.Settings tab-policy 'automatic'
org.gnome.Terminal.Legacy.Keybindings toggle-menubar 'disabled'
org.gnome.Terminal.Legacy.Keybindings reset-and-clear 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-14 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-normal '<Ctrl>0'
org.gnome.Terminal.Legacy.Keybindings read-only 'disabled'
org.gnome.Terminal.Legacy.Keybindings new-profile 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-out '<Ctrl>minus'
org.gnome.Terminal.Legacy.Keybindings move-tab-left '<Ctrl><Shift>Page_Up'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-20 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-21 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-22 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-23 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-24 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-25 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-26 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-27 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-28 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-29 'disabled'
org.gnome.Terminal.Legacy.Keybindings zoom-in '<Ctrl>plus'
org.gnome.Terminal.Legacy.Keybindings detach-tab 'disabled'
org.gnome.Terminal.Legacy.Keybindings move-tab-right '<Ctrl><Shift>Page_Down'
org.gnome.Terminal.Legacy.Keybindings close-tab '<Ctrl><Shift>w'
org.gnome.Terminal.Legacy.Keybindings paste '<Ctrl><Shift>v'
org.gnome.Terminal.Legacy.Keybindings reset 'disabled'
org.gnome.Terminal.Legacy.Keybindings new-tab '<Ctrl><Shift>t'
org.gnome.Terminal.Legacy.Keybindings find-previous '<Control><Shift>H'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-30 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-31 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-32 'disabled'
org.gnome.Terminal.Legacy.Keybindings select-all 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-34 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-35 'disabled'
org.gnome.Terminal.Legacy.Keybindings preferences 'disabled'
org.gnome.Terminal.Legacy.Keybindings prev-tab '<Control>Page_Up'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-33 'disabled'
org.gnome.Terminal.Legacy.Keybindings find-next '<Control><Shift>G'
org.gnome.Terminal.Legacy.Keybindings find '<Control><Shift>F'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-1 '<Alt>1'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-2 '<Alt>2'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-3 '<Alt>3'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-4 '<Alt>4'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-5 '<Alt>5'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-6 '<Alt>6'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-7 '<Alt>7'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-8 '<Alt>8'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-9 '<Alt>9'
org.gnome.Terminal.Legacy.Keybindings help 'F1'
org.gnome.Terminal.Legacy.Keybindings copy '<Ctrl><Shift>c'
org.gnome.Terminal.Legacy.Keybindings close-window '<Ctrl><Shift>q'
org.gnome.Terminal.Legacy.Keybindings new-window '<Ctrl><Shift>n'
org.gnome.Terminal.Legacy.Keybindings save-contents 'disabled'
org.gnome.Terminal.Legacy.Keybindings find-clear '<Control><Shift>J'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-10 '<Alt>0'
org.gnome.Terminal.Legacy.Keybindings full-screen 'F11'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-12 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-13 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-11 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-15 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-16 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-17 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-18 'disabled'
org.gnome.Terminal.Legacy.Keybindings switch-to-tab-19 'disabled'
org.gnome.Terminal.Legacy.Keybindings profile-preferences 'disabled'
org.gnome.Terminal.Legacy.Keybindings next-tab '<Control>Page_Down'
</code></pre>
</details>

### install ubuntu theme
```bash
$ sudo add-apt-repository ppa:noobslab/themes
$ sudo apt-get update
$ sudo apt-get install nokto-theme
```

### open font viewer and install font
```bash
$ sudo gnome-font-viewer ~/Tools/Monaco/Monaco_Linux.TTF
```

### show launcher icon
```bash
$ gsettings get com.canonical.Unity.Launcher favorites
['application://nautilus.desktop', 'application://gnome-terminal.desktop', 'application://firefox.desktop', 'unity://running-apps', 'application://gvim.desktop', 'unity://desktop-icon', 'unity://expo-icon', 'unity://devices']
```

### show the softer renderer
```bash
$ /usr/lib/nux/unity_support_test -p
OpenGL vendor string:   VMware, Inc.
OpenGL renderer string: Gallium 0.4 on SVGA3D; build: RELEASE;
OpenGL version string:  2.1 Mesa 10.1.0

Not software rendered:    yes
Not blacklisted:          yes
GLX fbconfig:             yes
GLX texture from pixmap:  yes
GL npot or rect textures: yes
GL vertex program:        yes
GL fragment program:      yes
GL vertex buffer object:  yes
GL framebuffer object:    yes
GL version is 1.4+:       yes

Unity 3D supported:       yes
```

### specified context menu
```bash
$ sudo apt-get install nautilus-actions
$ nautilus -q
$ utilus-actions-config-tool
```

### disable ubuntu desktop notification
```bash
$ sudo chmod -x /usr/lib/notify-osd/notify-osd
```

### recode activity as a gif file

> [!NOTE|label:references:]
> - inspired from [here](http://askubuntu.com/a/13462/92979) and [here](http://askubuntu.com/a/107735/92979)

```bash
$ sudo add-apt-repository ppa:fossfreedom/byzanz
$ sudo apt-get update && sudo apt-get install byzanz
```

### goldendict installation
```bash
$ git clone git@github.com:goldendict/goldendict.git
$ sudo apt-get install liblzma-dev qt4-qmake hunspell-dev hunspell build-essential libvorbis-dev zlib1g-dev libhunspell-dev x11proto-record-dev libqt4-dev libqtwebkit-dev libxtst-dev liblzo2-dev libbz2-dev libao-dev libavutil-dev libavformat-dev libtiff5-dev
$ cd goldendict/
$ qmake-qt4
$ qmake "CONFIG+=no_epwing_support"
$ make && sudo make install
```
