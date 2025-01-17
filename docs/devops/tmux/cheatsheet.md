<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [files](#files)
  - [alias](#alias)
- [sessions](#sessions)
  - [linux commands](#linux-commands)
  - [tmux commands](#tmux-commands)
  - [shortcuts](#shortcuts)
- [windows](#windows)
  - [shortcuts](#shortcuts-1)
  - [tmux commands](#tmux-commands-1)
- [panes](#panes)
  - [shortcuts](#shortcuts-2)
  - [tmux commands](#tmux-commands-2)
- [copy mode](#copy-mode)
  - [shortcuts](#shortcuts-3)
  - [tmux commands](#tmux-commands-3)
- [misc](#misc)
  - [shortcuts](#shortcuts-4)
  - [tmux commands](#tmux-commands-4)
- [help](#help)
  - [linux commands](#linux-commands-1)
  - [tmux commands](#tmux-commands-5)
  - [shortcuts](#shortcuts-5)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!NOTE|label:references:]
> - [tmux cheatsheet](https://tmuxcheatsheet.com/)
> - [awesome tmux](https://github.com/rothgar/awesome-tmux)
> - [MohamedAlaa/tmux-cheatsheet.markdown](https://gist.github.com/MohamedAlaa/2961058)

# files

| FILES                             | DESCRIPTION                      |
|-----------------------------------|----------------------------------|
| `~/.tmux.conf`                    |                                  |
| `$XDG_CONFIG_HOME/tmux/tmux.conf` |                                  |
| `~/.config/tmux/tmux.conf`        | Default tmux configuration file. |
| `/opt/homebrew/etc/tmux.conf`     | System-wide configuration file.  |

## alias

| COMMAND          | ALIAS               |
|------------------|---------------------|
| `attach-session` | `attach`, `at`, `a` |
| `detach-client`  | `detach`            |
| `has-session`    | `has`               |
| `list-clients`   | `lsc`               |
| `list-commands`  | `lscm`              |
| `list-sessions`  | `ls`                |
| `lock-client`    | `lockc`             |
| `lock-session`   | `locks`             |
| `new-session`    | `new`               |
| `refresh-client` | `refresh`           |
| `rename-session` | `rename`            |
| `show-messages`  | `showmsgs`          |
| `source-file`    | `source`            |
| `start-server`   | `start`             |
| `suspend-client` | `suspend`           |
| `switch-client`  | `switchc`           |


# sessions
## linux commands

| COMMAND                                     | DESCRIPTION                                                          |
|---------------------------------------------|----------------------------------------------------------------------|
| `tmux`                                      | start a new session                                                  |
| `tmux new-session`                          | start a new session                                                  |
| `tmux new`                                  | start a new session                                                  |
| `tmux new -s <name>`                        | start a new session with a name                                      |
| `tmux new-session -A -s <name>`             | start a new session or attach to an existing session named mysession |
| `tmux new -s <name> -n <window>`            | start a new session with a name and a window                         |
| `tmux new-session -d -s <name> '<command>'` | start a new session with a name and a command                        |
| `tmux list-sessions`                        | list all sessions                                                    |
| `tmux ls`                                   | list all sessions                                                    |
| `tmux kill-session -t <name>`               | kill/delete a session                                                |
| `tmux kill-ses -t <name>`                   | kill/delete a session                                                |
| `tmux kill-session -a`                      | kill/delete all sessions but the current                             |
| `tmux kill-session -a -t <name>`            | kill/delete all sessions but the <name>                              |
| `tmux attach-session`                       | attach to the last session                                           |
| `tmux attach`                               | attach to the last session                                           |
| `tmux at`                                   | attach to the last session                                           |
| `tmux a`                                    | attach to the last session                                           |
| `tmux attach-session -t <name>`             | attach to a session                                                  |
| `tmux attach -t <name>`                     | attach to a session                                                  |
| `tmux at -t <name>`                         | attach to a session                                                  |
| `tmux a -t <name>`                          | attach to a session                                                  |

## tmux commands

| COMMAND          | DESCRIPTION                                                            |
|------------------|------------------------------------------------------------------------|
| `:new`           | start a new session                                                    |
| `:new -s <name>` | start a new session with a name                                        |
| `:kill-session`  | kill a session                                                         |
| `:attach -d`     | detach others on the session (Maximize window by detach other clients) |

## shortcuts

| SHORTCUTS                                      | DESCRIPTION                      |
|------------------------------------------------|----------------------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>$</kbd>    | rename the current session.      |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>d</kbd>    | detach from the current session. |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>s</kbd>    | list all sessions.               |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>w</kbd>    | session and window preview       |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>(</kbd>    | move to previous session         |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>)</kbd>    | move to next session             |

# windows
## shortcuts

| SHORTCUTS                                      | DESCRIPTION                     |
|------------------------------------------------|---------------------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>c</kbd>    | create a new window             |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>,</kbd>    | rename the current window       |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>&</kbd>    | close the current window        |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>w</kbd>    | list windows                    |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>p</kbd>    | preview window                  |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>n</kbd>    | next window                     |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>0..9</kbd> | switch to window 0..9           |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>l</kbd>    | toggle between last two windows |

## tmux commands

| COMMAND                                         | DESCRIPTION                                        |
|-------------------------------------------------|----------------------------------------------------|
| `:swap-window -s <src> -t <dst>`                | swap window <src> with window <dst>                |
| `:swap-window -t -1`                            | swap window with the previous one                  |
| `:move-window -s src_ses:win -t target_ses:win` | move window from src_ses to target_ses             |
| `:movew -s foo:0 -t bar:9`                      | move window 0 from session foo to 9 in session bar |
| `:movew -s 0:0 -t 1:9`                          | move window 0 from session 0 to 9 in session 1     |
| `:move-window -s src_session:src_window`        | reposition window in the current session           |
| `:movew -s 0:9`                                 | reposition window 9 to the current session         |
| `:move-window -r`                               | renumber windows to remove gap in the sequence     |
| `:movew -r`                                     | renumber windows to remove gap in the sequence     |

# panes
## shortcuts

| SHORTCUTS                                                     | DESCRIPTION                  |
|---------------------------------------------------------------|------------------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>;</kbd>                   | toggle last active pane      |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>%</kbd>                   | split pane vertically        |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>"</kbd>                   | split pane horizontally      |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>{</kbd>                   | move pane left               |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>}</kbd>                   | move pane right              |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>↑</kbd>                   | move pane up                 |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>←</kbd>                   | move pane left               |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>→</kbd>                   | move pane right              |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>␣</kbd>                   | toggle between pane layouts  |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>o</kbd>                   | move to the next pane        |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>q</kbd>                   | show pane numbers            |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>q</kbd> <kbd>0..9</kbd>   | swith/select the pane number |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>z</kbd>                   | toggle pane zoom             |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>!</kbd>                   | convert pannel into a window |
| <kbd>ctrl</kbd> + <kbd>b</kbd> + <kbd>→</kbd>                 | resize current pane width    |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>ctrl</kbd> + <kbd>→</kbd> | resize current pane width    |
| <kbd>ctrl</kbd> + <kbd>b</kbd> + <kbd>←</kbd>                 | resize current pane width    |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>ctrl</kbd> + <kbd>←</kbd> | resize current pane width    |
| <kbd>ctrl</kbd> + <kbd>b</kbd> + <kbd>↓</kbd>                 | resize current pane height   |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>ctrl</kbd> + <kbd>↓</kbd> | resize current pane height   |
| <kbd>ctrl</kbd> + <kbd>b</kbd> + <kbd>↑</kbd>                 | resize current pane height   |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>ctrl</kbd> + <kbd>↑</kbd> | resize current pane height   |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>x</kbd>                   | close/kill the current pane  |

## tmux commands

| COMMAND                   | DESCRIPTION                                                                                                                 |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `:split-window -h`        | == <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>%</kbd><br>split the current pane with a vertical line to create a horizontal layout |
| `:split-window -v`        | == <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>"</kbd><br>split the current pane with a horizontal line to create a vertical layout |
| `:join-pane -s 2 -t 1`    | join two windows as panes (merge window 2 to window 1 as panes)                                                             |
| `:joinp -s 2.1 -t 1.0`    | move pane from one window to another (move pane 1 from window 2 to pane after 0 of window 1)                                |
| `:setw synchronize-panes` | toggle synchronize panes (send command to all panes)                                                                        |

# copy mode
## shortcuts

| SHORTCUTS                                      | DESCRIPTION                               |
|------------------------------------------------|-------------------------------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>[</kbd>    | enter copy mode                           |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>PgUp</kbd> | enter copy mode and scroll up one page up |
| <kbd>q</kbd>                                   | quit copy mode                            |
| <kbd>g</kbd>                                   | go to the top of the buffer               |
| <kbd>G</kbd>                                   | go to the bottom of the buffer            |
| <kbd>↑</kbd>                                   | scroll up one line                        |
| <kbd>↓</kbd>                                   | scroll down one line                      |
| <kbd>k</kbd>                                   | move cursor up                            |
| <kbd>j</kbd>                                   | move cursor down                          |
| <kbd>h</kbd>                                   | move cursor left                          |
| <kbd>l</kbd>                                   | move cursor right                         |
| <kbd>w</kbd>                                   | move cursor forward one worda at a time   |
| <kbd>b</kbd>                                   | move cursor backward one word at a time   |
| <kbd>/</kbd>                                   | search forward                            |
| <kbd>?</kbd>                                   | search backward                           |
| <kbd>n</kbd>                                   | next keyword occurrence                   |
| <kbd>N</kbd>                                   | previous keyword occurrence               |
| <kbd>␣</kbd>                                   | start selection                           |
| <kbd>esc</kbd>                                 | clear selection                           |
| <kbd>⏎</kbd>                                   | copy selection to clipboard               |
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>]</kbd>    | paste selection                           |

## tmux commands

| COMMAND                 | DESCRIPTION                                      |
|-------------------------|--------------------------------------------------|
| `:setw -g mode-keys vi` | set vi mode keys for copy mode                   |
| `:show-buffer`          | show the buffer content                          |
| `:capture-pane`         | copy entire visible contents of pane to a buffer |
| `:list-buffers`         | list all buffers                                 |
| `:choose-buffer`        | choose a buffer to paste                         |
| `:save-buffer <file>`   | save buffer to a file                            |
| `:delete-buffer -b 1`   | delete buffer 1                                  |

# misc
## shortcuts

| SHORTCUTS                                   | DESCRIPTION        |
|---------------------------------------------|--------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>:</kbd> | enter command mode |

## tmux commands

| COMMAND           | DESCRIPTION                 |
|-------------------|-----------------------------|
| `:set -g OPTION`  | set OPTION for all sessions |
| `:setw -g OPTION` | set OPTION for all windows  |
| `:set mouse on`   | enable mouse mode           |

# help
## linux commands

| COMMAND            | DESCRIPTION                                |
|--------------------|--------------------------------------------|
| `$ tmux list-keys` | list key bindings ( shortcuts )            |
| `$ tmux info`      | show every session, window, panes, etc ... |

## tmux commands

| COMMAND      | DESCRIPTION                     |
|--------------|---------------------------------|
| `:list-keys` | list key bindings ( shortcuts ) |

## shortcuts

| SHORTCUTS                                   | DESCRIPTION |
|---------------------------------------------|-------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>?</kbd> | show help   |
