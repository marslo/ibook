<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [enable screensharing](#enable-screensharing)
  - [backup and restore config](#backup-and-restore-config)
  - [setup screen sharing](#setup-screen-sharing)
  - [start application remotelly](#start-application-remotelly)
  - [GDM](#gdm)
  - [login session](#login-session)
  - [Process and SubProcesses](#process-and-subprocesses)
  - [Wayland](#wayland)
- [Reference](#reference)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## enable screensharing

### backup and restore config
```bash
$ dconf dump /org/gnome/desktop/remote-access/ > ubuntu1804_remoteaccess
$ cat ubuntu1804_remoteaccess
[/]
require-encryption=false
vnc-password='bWFyc2xv'
authentication-methods=['vnc']
prompt-enabled=false
$ dconf load /org/gnome/desktop/remote-access/ < ubuntu1804_remoteaccess
```

### setup screen sharing
```bash
$ read -e -p "VNC Password: " -i "ubuntu" VNCPASSWORD
$ dconf write /org/gnome/desktop/remote-access/enabled true
$ dconf write /org/gnome/desktop/remote-access/authentication-methods "['vnc']"
$ dconf write /org/gnome/desktop/remote-access/prompt-enabled false
$ dconf write /org/gnome/desktop/remote-access/require-encryption false
$ dconf write /org/gnome/desktop/remote-access/vnc-password \"\'$(echo -n $VNCPASSWORD | base64)\'\"
$ sudo service lightdm restart
```

#### reset VNC password
```bash
$ echo -n "marslo" | base64
bWFyc2xv
```

#### read all conf
```bash
$ for i in $(gsettings list-keys org.gnome.Vino); do echo -e "$i:\t --> "$(dconf read /org/gnome/desktop/remote-access/$i); done
notify-on-connect:   -->
alternative-port:    -->
disable-background:  -->
use-alternative-port:    -->
icon-visibility:     -->
use-upnp:    -->
view-only:   -->
prompt-enabled:  --> false
disable-xdamage:     -->
authentication-methods:  --> ['vnc']
network-interface:   -->
require-encryption:  --> false
mailto:  -->
lock-screen-on-disconnect:   -->
vnc-password:    --> 'bWFyc2xv'
```

### start application remotelly
```bash
$ export DISPLAY=:0
$ gnome-terminal
```

### [GDM](https://wiki.archlinux.org/index.php/GDM)
```bash
$ cat /lib/systemd/system/gdm.service
[Unit]
Description=GNOME Display Manager

## replaces the getty
Conflicts=getty@tty1.service
After=getty@tty1.service

## replaces plymouth-quit since it quits plymouth on its own
Conflicts=plymouth-quit.service
After=plymouth-quit.service

## Needs all the dependencies of the services it's replacing
## pulled from getty@.service and plymouth-quit.service
## (except for plymouth-quit-wait.service since it waits until
## plymouth is quit, which we do)
After=rc-local.service plymouth-start.service systemd-user-sessions.service

## GDM takes responsibility for stopping plymouth, so if it fails
## for any reason, make sure plymouth still stops
OnFailure=plymouth-quit.service

[Service]
ExecStartPre=/usr/share/gdm/generate-config
ExecStart=/usr/sbin/gdm3
KillMode=mixed
Restart=always
RestartSec=1s
IgnoreSIGPIPE=no
BusName=org.gnome.DisplayManager
StandardOutput=syslog
StandardError=inherit
EnvironmentFile=-/etc/default/locale
ExecReload=/usr/share/gdm/generate-config
ExecReload=/bin/kill -SIGHUP $MAINPID
```

#### [gnome-shell](https://www.archlinux.org/packages/extra/x86_64/gnome-shell/)

#### [AutoLogin](https://wiki.archlinux.org/index.php/GDM##Users_and_login)

##### Login with desired session
```bash
$ cat /var/lib/AccountsService/users/devops
[User]
FormatsLocale=en_US.UTF-8
XSession=gnome-xorg
SystemAccount=false

[InputSource0]
xkb=us
```

##### Auto Login with GDM
```bash
$ grep -i auto /etc/gdm3/custom.conf
[daemon]
## Enabling automatic login
AutomaticLoginEnable = true
AutomaticLogin = devops
```

##### Auto Login with Delay
```bash
$ grep -i time /etc/gdm3/custom.conf
[daemon]
## Enabling timed login
##  TimedLoginEnable = true
##  TimedLogin = user1
##  TimedLoginDelay = 10
```

### login session

![desktop styles](screenshots/desktop-style-2.jpeg)

#### Default Session
```bash
$ cat /etc/X11/default-display-manager
/usr/sbin/gdm3
```

### Process and SubProcesses
#### pstree
```bash
$ pstree 1391
gdm3─┬─gdm-session-wor─┬─gdm-x-session─┬─Xorg───{Xorg}
     │                 │               ├─gnome-session-b─┬─deja-dup-monito───4*[{deja-dup-monito}]
     │                 │               │                 ├─gnome-software───3*[{gnome-software}]
     │                 │               │                 ├─gsd-a11y-settin───3*[{gsd-a11y-settin}]
     │                 │               │                 ├─gsd-clipboard───2*[{gsd-clipboard}]
     │                 │               │                 ├─gsd-color───3*[{gsd-color}]
     │                 │               │                 ├─gsd-datetime───3*[{gsd-datetime}]
     │                 │               │                 ├─gsd-disk-utilit───2*[{gsd-disk-utilit}]
     │                 │               │                 ├─gsd-housekeepin───3*[{gsd-housekeepin}]
     │                 │               │                 ├─gsd-keyboard───3*[{gsd-keyboard}]
     │                 │               │                 ├─gsd-media-keys───3*[{gsd-media-keys}]
     │                 │               │                 ├─gsd-mouse───3*[{gsd-mouse}]
     │                 │               │                 ├─gsd-power───3*[{gsd-power}]
     │                 │               │                 ├─gsd-print-notif───2*[{gsd-print-notif}]
     │                 │               │                 ├─gsd-rfkill───2*[{gsd-rfkill}]
     │                 │               │                 ├─gsd-screensaver───2*[{gsd-screensaver}]
     │                 │               │                 ├─gsd-sharing───3*[{gsd-sharing}]
     │                 │               │                 ├─gsd-smartcard───4*[{gsd-smartcard}]
     │                 │               │                 ├─gsd-sound───3*[{gsd-sound}]
     │                 │               │                 ├─gsd-wacom───2*[{gsd-wacom}]
     │                 │               │                 ├─gsd-xsettings───3*[{gsd-xsettings}]
     │                 │               │                 ├─nautilus-deskto───3*[{nautilus-deskto}]
     │                 │               │                 ├─ssh-agent
     │                 │               │                 ├─update-notifier───3*[{update-notifier}]
     │                 │               │                 └─3*[{gnome-session-b}]
     │                 │               └─2*[{gdm-x-session}]
     │                 └─2*[{gdm-session-wor}]
     └─2*[{gdm3}]
```

#### ps

##### short
```bash
$ ps auxwwf
/usr/sbin/gdm3
 \_ gdm-session-worker [pam/gdm-autologin]
     \_ /usr/lib/gdm3/gdm-x-session --run-script env GNOME_SHELL_SESSION_MODE=ubuntu gnome-session --session=ubuntu
         \_ /usr/lib/xorg/Xorg vt1 -displayfd 3 -auth /run/user/1000/gdm/Xauthority -background none -noreset -keeptty -verbose 3
         \_ /usr/lib/gnome-session/gnome-session-binary --session=ubuntu
             \_ /usr/bin/ssh-agent /usr/bin/im-launch env GNOME_SHELL_SESSION_MODE=ubuntu gnome-session --session=ubuntu
             \_ /usr/lib/gnome-settings-daemon/gsd-power
             \_ /usr/lib/gnome-settings-daemon/gsd-print-notifications
             \_ /usr/lib/gnome-settings-daemon/gsd-rfkill
             \_ /usr/lib/gnome-settings-daemon/gsd-screensaver-proxy
             \_ /usr/lib/gnome-settings-daemon/gsd-sharing
             \_ /usr/lib/gnome-settings-daemon/gsd-smartcard
             \_ /usr/lib/gnome-settings-daemon/gsd-sound
             \_ /usr/lib/gnome-settings-daemon/gsd-xsettings
             \_ /usr/lib/gnome-settings-daemon/gsd-wacom
             \_ /usr/lib/gnome-settings-daemon/gsd-clipboard
             \_ /usr/lib/gnome-settings-daemon/gsd-a11y-settings
             \_ /usr/lib/gnome-settings-daemon/gsd-datetime
             \_ /usr/lib/gnome-settings-daemon/gsd-color
             \_ /usr/lib/gnome-settings-daemon/gsd-keyboard
             \_ /usr/lib/gnome-settings-daemon/gsd-housekeeping
             \_ /usr/lib/gnome-settings-daemon/gsd-mouse
             \_ /usr/lib/gnome-settings-daemon/gsd-media-keys
             \_ /usr/lib/gnome-disk-utility/gsd-disk-utility-notify
             \_ /usr/bin/gnome-software --gapplication-service
             \_ nautilus-desktop
             \_ update-notifier
             \_ /usr/lib/deja-dup/deja-dup-monitor
```

##### full
```bash
$ ps auxwwf
root      1391  0.0  0.1 308176  8340 ?        Ssl  16:58   0:00 /usr/sbin/gdm3
root      1456  0.0  0.1 271860  8720 ?        Sl   16:58   0:00  \_ gdm-session-worker [pam/gdm-autologin]
devops    1497  0.0  0.0 212124  6000 tty1     Ssl+ 16:58   0:00      \_ /usr/lib/gdm3/gdm-x-session --run-script env GNOME_SHELL_SESSION_MODE=ubuntu gnome-session --session=ubuntu
devops    1499  0.4  1.0 370392 81984 tty1     Sl+  16:58   0:02          \_ /usr/lib/xorg/Xorg vt1 -displayfd 3 -auth /run/user/1000/gdm/Xauthority -background none -noreset -keeptty -verbose 3
devops    1518  0.0  0.1 716920 15716 tty1     Sl+  16:58   0:00          \_ /usr/lib/gnome-session/gnome-session-binary --session=ubuntu
devops    1599  0.0  0.0  11304   320 ?        Ss   16:58   0:00              \_ /usr/bin/ssh-agent /usr/bin/im-launch env GNOME_SHELL_SESSION_MODE=ubuntu gnome-session --session=ubuntu
devops    2471  0.0  0.2 527336 23468 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-power
devops    2472  0.0  0.1 349316 10144 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-print-notifications
devops    2475  0.0  0.0 423340  5728 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-rfkill
devops    2481  0.0  0.0 275728  5048 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-screensaver-proxy
devops    2485  0.0  0.1 471340 11980 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-sharing
devops    2493  0.0  0.1 466472 10096 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-smartcard
devops    2495  0.0  0.1 343116  9808 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-sound
devops    2499  0.0  0.2 504824 23460 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-xsettings
devops    2511  0.0  0.2 440656 22568 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-wacom
devops    2530  0.0  0.2 355824 21572 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-clipboard
devops    2531  0.0  0.1 296660  8348 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-a11y-settings
devops    2532  0.0  0.1 476600 15176 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-datetime
devops    2536  0.0  0.3 678216 24396 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-color
devops    2537  0.0  0.2 508124 22096 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-keyboard
devops    2539  0.0  0.1 374712  8804 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-housekeeping
devops    2542  0.0  0.1 296672  8284 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-mouse
devops    2545  0.0  0.3 1155368 24656 tty1    Sl+  16:58   0:00              \_ /usr/lib/gnome-settings-daemon/gsd-media-keys
devops    2589  0.0  0.0 271928  6216 tty1     Sl+  16:58   0:00              \_ /usr/lib/gnome-disk-utility/gsd-disk-utility-notify
devops    2590  0.4  1.8 1318392 152212 tty1   SLl+ 16:58   0:02              \_ /usr/bin/gnome-software --gapplication-service
devops    2599  0.2  0.9 1197708 75864 tty1    Sl+  16:58   0:01              \_ nautilus-desktop
devops    3686  0.0  0.3 605436 28680 tty1     Sl+  16:59   0:00              \_ update-notifier
devops    4017  0.0  0.4 118225468 32448 tty1  Sl+  17:00   0:00              \_ /usr/lib/deja-dup/deja-dup-monitor
```

### [Wayland](https://wiki.archlinux.org/index.php/Wayland)

## Reference
- [GDM Reference Manual](https://help.gnome.org/admin/gdm/stable/index.html.en)
- [GNOME](https://wiki.archlinux.org/index.php/GNOME)
- [How to configure Vino for remote desktop access using command line](https://access.redhat.com/solutions/346033)
- [Vino](https://wiki.archlinux.org/index.php/Vino)
- [Vino. The Remote Desktop Project](https://people.gnome.org/~markmc/remote-desktop.html)
- [VND/Servers](https://help.ubuntu.com/community/VNC/Servers)
