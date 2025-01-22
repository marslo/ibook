<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->

- [configure](#configure)
  - [plugins](#plugins)
  - [theme](#theme)
- [troubleshooting](#troubleshooting)
  - [2.8.x to 2.9.x migration](#28x-to-29x-migration)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

> [!TIP|label:references:]
> - [rothgar/awesome-tmux](https://github.com/rothgar/awesome-tmux)
> - [* Getting Started](https://github.com/tmux/tmux/wiki/Getting-Started) | [Advanced Use](https://github.com/tmux/tmux/wiki/Advanced-Use)
> - [man page: tmux — terminal multiplexer](https://man.openbsd.org/tmux)

# configure

> [!NOTE|label:sample dotfiles:]
> - [drn/dots](https://github.com/drn/dots/blob/master/home/tmux.conf)
> - [samoshkin/tmux-config](https://github.com/samoshkin/tmux-config/blob/master/tmux/tmux.conf)
> - [oh my tmux](https://github.com/gpakosz/.tmux)
> - [Guide to customizing tmux.conf](https://hamvocke.com/blog/a-guide-to-customizing-your-tmux-conf/) | [hamvocke/dotfiles](https://github.com/hamvocke/dotfiles)
> - [Use System Clipboard for Vi Copy Mode in Tmux in macOS and Linux](https://www.grailbox.com/2020/08/use-system-clipboard-for-vi-copy-mode-in-tmux-in-macos-and-linux/)

```bash
$ tmux show -g | grep -v --color=never '^#' | grep -v --color=never '^$'
# or
$ tmux show-options -g | grep -v --color=never '^#' | grep -v --color=never '^$'
```

## plugins

> [!NOTE|label:references:]
> - [tmux-plugins](https://github.com/tmux-plugins)
> - [Useful TMUX Plugins Which I Frequently Use At Work](https://medium.com/@hammad.ai/useful-tmux-plugins-which-i-frequently-use-at-work-41a9b46f7bcb)
> - system status
>   - [tmux-plugins/tmux-cpu](https://github.com/tmux-plugins/tmux-cpu)
>   - [tmux-plugins/tmux-battery](https://github.com/tmux-plugins/tmux-battery)
>   - [tmux-plugins/tmux-net-speed](https://github.com/tmux-plugins/tmux-net-speed)
>   - [hendrikmi/tmux-cpu-mem-monitor](https://github.com/hendrikmi/tmux-cpu-mem-monitor)
>   - [samoshkin/tmux-plugin-sysstat](https://github.com/samoshkin/tmux-plugin-sysstat)


## theme

> [!TIP|label:references:]
> - references:
>   - [Everything you need to know about tmux – Status Bar](https://arcolinux.com/everything-you-need-to-know-about-tmux-status-bar/)
> - themes
>   - [jimeh/tmux-themepack](https://github.com/jimeh/tmux-themepack)
>   - [wfxr/tmux-power](https://github.com/wfxr/tmux-power)
>   - [2KAbhishek/tmux2k](https://github.com/2KAbhishek/tmux2k)
>   - [weather: vascomfnunes/tmux-clima](https://github.com/vascomfnunes/tmux-clima)
>   - [catppuccin/tmux](https://github.com/catppuccin/tmux)

# troubleshooting

## 2.8.x to 2.9.x migration

> [!TIP|label:references:]
> - [#1689 Tmux 2.8.X to 2.9.X migration](https://github.com/tmux/tmux/issues/1689)
> - [#754 invalid or unknown command: bind-key -t vi-copy ....](https://github.com/tmux/tmux/issues/754)
> - [#1688 Some options no longer work in 2.9](https://github.com/tmux/tmux/issues/1688)
> - [#1691 tmux not supporting options that worked previously](https://github.com/tmux/tmux/issues/1691)

