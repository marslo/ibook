

## do-release-upgrade

> [!NOTE|label:tips]
> release upgrade from `24.04.5 LTS` -> `26.04.1 LTS`

### prepare

> [!NOTE|label:error log]
> ```bash
> $ sudo do-release-upgrade
> ...
> Foreign Packages Installed
> The following unofficial packages are currently installed:
> bat......................Installed from: unknown origin
> git-delta................Installed from: unknown origin
> libpython3.14............Installed from: LP-PPA-deadsnakes
> libpython3.14-dev........Installed from: LP-PPA-deadsnakes
> libpython3.14-stdlib.....Installed from: LP-PPA-deadsnakes
> nodejs...................Installed from: . nodistro
> python3.14...............Installed from: LP-PPA-deadsnakes
> python3.14-dev...........Installed from: LP-PPA-deadsnakes
> It is recommended to install supported versions from the Ubuntu
> archive, and try the upgrade again.
>
> Do you want to continue the upgrade anyways?
> Continue [yN] y
> Restoring original system state
> Aborting
> Reading package lists... Done
> Building dependency tree... Done
> Reading state information... Done
> === Command terminated with exit status 1 (Mon Oct 26 19:43:40 2026) ===
> ```
>
> log file: `/var/log/dist-upgrade/main.log`:
> ```bash
> $ sudo tail -n 60 /var/log/dist-upgrade/main.log
> ...
> 2026-10-26 19:43:14,567 DEBUG Foreign (before rewriting sources): bat cmake cmake-data diff-so-fancy git-delta libpython3.14 libpython3.14-dev libpython3.14-stdlib nodejs python3.14 python3.14-dev
> 2026-10-26 19:43:14,567 DEBUG Foreign (after rewriting sources): bat git-delta libpython3.14 libpython3.14-dev libpython3.14-stdlib nodejs python3.14 python3.14-dev
> 2026-10-26 19:43:31,209 DEBUG abort called
> ...
> ```

```bash
$ sudo apt purge -y python3.14 python3.14-dev libpython3.14 libpython3.14-dev libpython3.14-stdlib nodejs bat git-delta
$ sudo apt install -y ppa-purge && sudo ppa-purge ppa:deadsnakes/ppa
$ sudo apt autoremove -y
```

```bash
$ sudo apt install -y tmux
$ sudo apt update && sudo apt full-upgrade -y && sudo apt autoremove -y
$ test -f /var/run/reboot-required && sudo reboot
```

```bash
$ tmux new -s upgrade
$ sudo ufw status | grep -q 'Status: active' && sudo ufw allow 1022/tcp
$ sudo do-release-upgrade
# or
$ sudo LANG=C.UTF-8 LC_ALL=C.UTF-8 do-release-upgrade
```

### post-upgrade

> [!NOTE|label:list supported python packages]
> ```bash
> $ apt-cache pkgnames python3.
> python3.14
> python3.14-nopie
> python3.12-venv
> python3.14-tk
> python3.14-venv
> python3.14-full
> python3.14-gdbm
> python3.14-examples
> python3.14-dbg
> python3.14-dev
> python3.14-doc
> python3.14-minimal
> ```

```bash
$ curl -fsSL https://deb.nodesource.com/setup_26.x | sudo -E bash - && sudo apt install -y nodejs
$ curl -fsSL https://github.com/marslo/mytools/raw/main/opt/bat/update.sh | bash
$ sudo apt install -y git-delta

# others
$ npm outdated -g
$ npm update -g
```

```bash
# ── nvim ──
# ruby gem
$ sudo rm /usr/local/bin/neovim-ruby-host && sudo gem install neovim && hash -r && head -1 "$( type -P neovim-ruby-host )"
# ...
# 3 gems installed
# #!/usr/bin/ruby3.3
$ test -d /var/lib/gems/3.2.0 && sudo rm -rf /var/lib/gems/3.2.0
# verify
$ nvim --headless '+checkhealth vim.provider' '+w! /tmp/health.txt' '+qa' >/dev/null 2>&1; command grep -A6 'Ruby provider' /tmp/health.txt

# pip pynvim
$ /usr/bin/python3 --version; /usr/bin/python3 -c 'import pynvim; print(pynvim.__version__, pynvim.__file__)'
# Python 3.14.4
# Traceback (most recent call last):
#   File "<string>", line 1, in <module>
#     import pynvim; print(pynvim.__version__, pynvim.__file__)
#     ^^^^^^^^^^^^^
# ModuleNotFoundError: No module named 'pynvim'
$ sudo apt install -y python3-pynvim
$ /usr/bin/python3 --version; /usr/bin/python3 -c 'import pynvim; print(pynvim.__version__, pynvim.__file__)'
# Python 3.14.4
# 0.6.0 /usr/lib/python3/dist-packages/pynvim/__init__.py
```
