<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [files](#files)
  - [alias](#alias)
- [sessions](#sessions)
  - [linux commands](#linux-commands)
  - [tmux commands](#tmux-commands)
  - [shortcuts](#shortcuts)
- [windows](#windows)
  - [shortcuts for windows](#shortcuts-for-windows)
  - [tmux commands for windows](#tmux-commands-for-windows)
- [panes](#panes)
  - [shortcuts for panes](#shortcuts-for-panes)
  - [tmux commands for panes](#tmux-commands-for-panes)
- [copy mode](#copy-mode)
  - [shortcuts for copy mode](#shortcuts-for-copy-mode)
  - [tmux commands for copy mode](#tmux-commands-for-copy-mode)
- [misc](#misc)
  - [shortcuts for misc](#shortcuts-for-misc)
  - [tmux commands for misc](#tmux-commands-for-misc)
- [help](#help)
  - [linux commands for help](#linux-commands-for-help)
  - [tmux commands for help](#tmux-commands-for-help)
  - [shortcuts for help](#shortcuts-for-help)
- [tmux format](#tmux-format)

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
## shortcuts for windows

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

## tmux commands for windows

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
## shortcuts for panes

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

## tmux commands for panes

| COMMAND                   | DESCRIPTION                                                                                                                 |
|---------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `:split-window -h`        | == <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>%</kbd><br>split the current pane with a vertical line to create a horizontal layout |
| `:split-window -v`        | == <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>"</kbd><br>split the current pane with a horizontal line to create a vertical layout |
| `:join-pane -s 2 -t 1`    | join two windows as panes (merge window 2 to window 1 as panes)                                                             |
| `:joinp -s 2.1 -t 1.0`    | move pane from one window to another (move pane 1 from window 2 to pane after 0 of window 1)                                |
| `:setw synchronize-panes` | toggle synchronize panes (send command to all panes)                                                                        |

# copy mode
## shortcuts for copy mode

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

## tmux commands for copy mode

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
## shortcuts for misc

| SHORTCUTS                                   | DESCRIPTION        |
|---------------------------------------------|--------------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>:</kbd> | enter command mode |

## tmux commands for misc

| COMMAND           | DESCRIPTION                 |
|-------------------|-----------------------------|
| `:set -g OPTION`  | set OPTION for all sessions |
| `:setw -g OPTION` | set OPTION for all windows  |
| `:set mouse on`   | enable mouse mode           |

# help
## linux commands for help

| COMMAND                  | DESCRIPTION                                |
|--------------------------|--------------------------------------------|
| `$ tmux list-keys`       | list key bindings ( shortcuts )            |
| `$ tmux info`            | show every session, window, panes, etc ... |
| `$ tmux show -g`         | show global options                        |
| `$ tmux show-options -g` | show global options                        |

## tmux commands for help

| COMMAND      | DESCRIPTION                     |
|--------------|---------------------------------|
| `:list-keys` | list key bindings ( shortcuts ) |

## shortcuts for help

| SHORTCUTS                                   | DESCRIPTION |
|---------------------------------------------|-------------|
| <kbd>ctrl</kbd> + <kbd>b</kbd> <kbd>?</kbd> | show help   |


# [tmux format](https://github.com/greymd/tmux-xpanes/wiki/Tmux-Format)

| VARIABLE NAME          | REPLACED WITH                                          |
|------------------------|--------------------------------------------------------|
| alternate_on           | If pane is in alternate screen                         |
| alternate_saved_x      | Saved cursor X in alternate screen                     |
| alternate_saved_y      | Saved cursor Y in alternate screen                     |
| buffer_sample          | First 50 characters from the specified buffer          |
| buffer_size            | Size of the specified buffer in bytes                  |
| client_activity        | Integer time client last had activity                  |
| client_activity_string | String time client last had activity                   |
| client_created         | Integer time client created                            |
| client_created_string  | String time client created                             |
| client_cwd             | Working directory of client                            |
| client_height          | Height of client                                       |
| client_last_session    | Name of the client's last session                      |
| client_prefix          | 1 if prefix key has been pressed                       |
| client_readonly        | 1 if client is readonly                                |
| client_session         | Name of the client's session                           |
| client_termname        | Terminal name of client                                |
| client_tty             | Pseudo terminal of client                              |
| client_utf8            | 1 if client supports utf8                              |
| client_width           | Width of client                                        |
| cursor_flag            | Pane cursor flag                                       |
| cursor_x               | Cursor X position in pane                              |
| cursor_y               | Cursor Y position in pane                              |
| history_bytes          | Number of bytes in window history                      |
| history_limit          | Maximum window history lines                           |
| history_size           | Size of history in bytes                               |
| host                   | Hostname of local host                                 |
| insert_flag            | Pane insert flag                                       |
| keypad_cursor_flag     | Pane keypad cursor flag                                |
| keypad_flag            | Pane keypad flag                                       |
| line                   | Line number in the list                                |
| mouse_any_flag         | Pane mouse any flag                                    |
| mouse_button_flag      | Pane mouse button flag                                 |
| mouse_standard_flag    | Pane mouse standard flag                               |
| mouse_utf8_flag        | Pane mouse UTF-8 flag                                  |
| pane_active            | 1 if active pane                                       |
| pane_current_command   | Current command if available                           |
| pane_current_path      | Current path if available                              |
| pane_dead              | 1 if pane is dead                                      |
| pane_height            | Height of pane                                         |
| pane_id                | Unique pane ID                                         |
| pane_in_mode           | If pane is in a mode                                   |
| pane_index             | Index of pane                                          |
| pane_pid               | PID of first process in pane                           |
| pane_start_command     | Command pane started with                              |
| pane_start_path        | Path pane started with                                 |
| pane_tabs              | Pane tab positions                                     |
| pane_title             | Title of pane                                          |
| pane_tty               | Pseudo terminal of pane                                |
| pane_width             | Width of pane                                          |
| saved_cursor_x         | Saved cursor X in pane                                 |
| saved_cursor_y         | Saved cursor Y in pane                                 |
| scroll_region_lower    | Bottom of scroll region in pane                        |
| scroll_region_upper    | Top of scroll region in pane                           |
| session_attached       | 1 if session attached                                  |
| session_created        | Integer time session created                           |
| session_created_string | String time session created                            |
| session_group          | Number of session group                                |
| session_grouped        | 1 if session in a group                                |
| session_height         | Height of session                                      |
| session_id             | Unique session ID                                      |
| session_name           | Name of session                                        |
| session_width          | Width of session                                       |
| session_windows        | Number of windows in session                           |
| window_active          | 1 if window active                                     |
| window_find_matches    | Matched data from the find-window command if available |
| window_flags           | Window flags                                           |
| window_height          | Height of window                                       |
| window_id              | Unique window ID                                       |
| window_index           | Index of window                                        |
| window_layout          | Window layout description                              |
| window_name            | Name of window                                         |
| window_panes           | Number of panes in window                              |
| window_width           | Width of window                                        |
| wrap_flag              | Pane wrap flag                                         |
