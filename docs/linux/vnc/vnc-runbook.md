# TigerVNC on the shared box — Ops Runbook

> **Host** sj4dl360n4u20 · **OS** Ubuntu 24.04.4 · **Desktop** Xfce 4.18 · **VNC** TigerVNC 1.13.1 · **Portal** xdg-desktop-portal 1.18.4 · **Updated** 2026-08-29

Isolated VNC desktops for several users on one Xubuntu server — the browser upload-dialog saga (resolved by 24.04), the in-place 22.04→24.04 upgrade, hardening, and password recovery.

---

## 1. Display map

| Display | Port | User | Service | Managed by |
|---|---|---|---|---|
| `:1` | 5901 | marslo *(owner)* | `tigervncserver@:1` | migrated off the custom unit (§6) |
| `:2` | 5902 | ubuntu *(guest)* | `tigervncserver@:2` | official mechanism |
| `:3` | 5903 | iliad *(guest)* | `tigervncserver@:3` | official mechanism |

Each display is a separate X server on its own port with its own `~/.vnc/passwd` — users are isolated by construction; nobody enters another display without that display's password.

> **Why not just `vncserver@2`?** The old hand-rolled unit hardcoded `User=marslo`, and `@N` was the *display number* — so `vncserver@2/@3` would have opened more desktops *as marslo*. Multi-user needs the official display→user map.

---

## 2. Enable VNC for another account

```bash
# /etc/tigervnc/vncserver.users — one line per display
sudo tee /etc/tigervnc/vncserver.users >/dev/null <<'EOF'
:1=marslo
:2=ubuntu
:3=iliad
EOF

# each user gets their OWN password (run as that user)
sudo -iu ubuntu vncpasswd
sudo -iu iliad  vncpasswd

# start now + on boot (instance name includes the colon)
sudo systemctl enable --now tigervncserver@:2.service
sudo systemctl enable --now tigervncserver@:3.service
```

Each guest needs their own `~/.vnc` (password + an `xstartup` for XFCE, options in `~/.vnc/tigervnc.conf`).

---

## 3. Per-user config — `~/.vnc/tigervnc.conf`

The `tigervncserver@` unit reads options from this file (not the command line). Perl syntax, must end in `1;`:

```perl
$geometry  = "1920x1080";
$depth     = "24";
$localhost = "no";   # listen on all interfaces; "yes" = localhost-only
1;
```

> ⚠️ With default `VncAuth`, TigerVNC defaults to `$localhost="yes"` (localhost-only), unlike the old custom unit's `-localhost no`. Set `$localhost="no"` for direct network access, or leave it for SSH-tunnel-only (safer, §8).

---

## 4. The `xstartup` reference

```sh
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# runtime dir; avoids apps falling back to /tmp (PAM login also provides it now)
test -d "/run/user/$(id -u)" && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# desktop identity; ":GNOME" makes the portal pick the GTK FileChooser backend (UseIn=gnome)
export XDG_CURRENT_DESKTOP=XFCE:GNOME

# clipboard bridge between vnc viewer and X
vncconfig -nowin &
autocutsel -fork
autocutsel -selection PRIMARY -fork

# disable X screensaver / blanking
xset s off -dpms 2>/dev/null

# DPI has no tigervnc.conf knob — set it here
xrandr --dpi 120 2>/dev/null

exec dbus-run-session -- startxfce4
```

- **`dbus-run-session`** — neither `startxfce4` nor the Xfce `xinitrc` starts a session bus, and `XDG_RUNTIME_DIR` isn't inherited from the system service, so the systemd user bus isn't the default either. This guarantees a private bus and tears it down on logout.
- **`XDG_CURRENT_DESKTOP=XFCE:GNOME`** — the `:GNOME` lets the portal serve the file-chooser (§5). Drop to `XFCE` only if you deliberately disable the portal.

---

## 5. Browser file uploads (Chrome & Firefox)

Chrome ≥123 and Firefox hand the file-picker to `xdg-desktop-portal` when it's reachable. How well it behaves depends almost entirely on the **portal version** — which is why the 24.04 upgrade mattered.

> ✅ **Resolved on 24.04 — keep the portal ON.** With `xdg-desktop-portal 1.18` the dialog **double-clicks to upload AND remembers the last folder**, in both browsers. On 22.04's `1.14` you couldn't get both at once — the upgrade dissolved the trade-off.

| Portal version | Double-click uploads | Opens at |
|---|---|---|
| 1.18 — Ubuntu 24.04 *(now)* | yes | last-used folder |
| 1.14 — Ubuntu 22.04 | closed dialog without uploading | `$HOME` (never last dir) |

**How "portal ON" is wired:** packages `xdg-desktop-portal` + `xdg-desktop-portal-gtk` installed, **no** shadow file, and `XDG_CURRENT_DESKTOP=XFCE:GNOME` (the `:GNOME` makes the portal pick the GTK FileChooser backend — `gtk.portal` declares `UseIn=gnome`).

**Fallback — turn the portal OFF** (rarely needed on 24.04): shadow its D-Bus activation and set `XDG_CURRENT_DESKTOP=XFCE`:

```bash
mkdir -p ~/.local/share/dbus-1/services
tee ~/.local/share/dbus-1/services/org.freedesktop.portal.Desktop.service <<'EOF'
[D-BUS Service]
Name=org.freedesktop.portal.Desktop
Exec=/bin/false
EOF
# restart the session; delete the file to re-enable
```

> ⚠️ **`systemctl --user mask` does NOT work here** — the session runs on a `dbus-run-session` bus with no systemd activation, so the portal is activated *directly* by dbus-daemon. Shadowing the D-Bus service file is the reliable, bus-agnostic lever.

**Firefox — install the deb, not the snap.** The snap fails in this VNC session with `… is not a snap cgroup for tag snap.firefox.firefox`. Use Mozilla's apt repo and pin out the snap so upgrades never switch back:

```bash
sudo install -d -m 0755 /etc/apt/keyrings
wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- \
  | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
  | sudo tee /etc/apt/sources.list.d/mozilla.list > /dev/null

# pin: Mozilla's firefox wins (1000), Ubuntu's snap-stub blocked (-1)
sudo tee /etc/apt/preferences.d/mozilla-firefox >/dev/null <<'EOF'
Package: firefox*
Pin: origin packages.mozilla.org
Pin-Priority: 1000

Package: firefox*
Pin: release o=Ubuntu
Pin-Priority: -1
EOF
sudo apt update; sudo snap remove firefox 2>/dev/null; sudo apt purge -y firefox; sudo apt install -y firefox
```

---

## 6. Retire the custom unit *(done)*

marslo's `:1` was moved off `/etc/systemd/system/vncserver@.service` onto the official mechanism. Bonus — `tigervncsession` opens a real PAM login, so `XDG_RUNTIME_DIR` is populated for free.

- CLI options → `~/.vnc/tigervnc.conf` (§3); `-dpi 120` → `~/.vnc/xstartup` (§4); `xstartup` carries over.

```bash
# :1=marslo added to /etc/tigervnc/vncserver.users, then:
sudo systemctl disable --now vncserver@1.service
sudo systemctl enable  --now tigervncserver@:1.service
```

> The custom unit is **disabled but not deleted** (kept as a fallback). It survived the 24.04 upgrade and `tigervncserver@:1` auto-starts on boot. Rollback: `sudo systemctl disable --now tigervncserver@:1 && sudo systemctl enable --now vncserver@1`.

---

## 7. The 22.04 → 24.04 upgrade

```bash
# ALWAYS in tmux/screen — a dropped SSH mid-upgrade can wreck the box
tmux new -s upgrade
sudo apt update && sudo apt full-upgrade -y && sudo apt --purge autoremove -y
sudo do-release-upgrade   # opens a backup sshd on :1022; keep old configs (sshd_config!)
```

**Disk was 88% full — grow the LV online** (no unmount, no reboot, no data loss; only *shrinking* is risky):

```bash
sudo lvextend -L 200G -r /dev/ubuntu-vg/ubuntu-lv   # -r also grows the ext4 fs
```

> **When the VG itself is full (VFree = 0):** feed capacity from the bottom first — new disk → `pvcreate` + `vgextend`; enlarged disk → `growpart` + `pvresize`; then `lvextend -r`. Diagnose with `vgs` (VFree) / `pvs` (PFree); canonical LV path via `lvs -o lv_path`.

**Third-party apt repos after the upgrade** — `do-release-upgrade` disables them (`*.list.distUpgrade`); re-enable the ones you use for `noble`. Two bit us:

- ⚠️ **Marvell Artifactory mirror** serves an **unsigned** `Release` (`Origin: Artifactory`; no `InRelease`/`Release.gpg`, no key endpoint), so `Signed-By` is impossible. Either:
  - **(a) keep the mirror** — add `Trusted: yes` to its deb822 stanza in `/etc/apt/sources.list.d/third-party.sources` (the leftover `N: Missing Signed-By` lines are harmless notices; only Artifactory-side signing removes them — an IT request), or
  - **(b) switch to official signed sources** — if the box reaches `archive.ubuntu.com`, disable `third-party.sources` and drop in a standard `ubuntu.sources` (`Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg`): no warnings, real verification. Confirm first the mirror isn't mandated by network policy.
- 🔒 **Firefox** — the upgrade reinstalls Ubuntu's snap-transition `firefox` (Mozilla repo disabled). Press `Ok`, finish, then re-enable Mozilla + apply the §5 pin.

---

## 8. Hardening

> 🔒 `~/.vnc/passwd` is **reversibly obfuscated** (fixed DES key), not hashed, and only the first **8 characters** matter. Treat a VNC password as low-trust; never reuse it elsewhere.

Prefer **localhost-only + SSH tunnel** over open ports:

```bash
# set $localhost="yes" in tigervnc.conf, then tunnel (from the client)
ssh -L 5902:localhost:5902 ubuntu@sj4dl360n4u20
# then point the VNC viewer at localhost:5902
```

- Only SSH-authenticated users can reach the VNC port — the biggest single win.
- If you must expose ports (`$localhost="no"`), firewall `5901-5903` to trusted IPs and use distinct passwords.

---

## 9. Forgot a VNC password

**Just reset it** — no old password needed:

```bash
vncpasswd
sudo systemctl restart tigervncserver@:1.service
```

**Recover the old plaintext** — it's fixed-key DES, so decryptable. Key `{23,82,107,6,35,78,88,7}` fed bit-reversed → `E84AD660C4721AE0`:

```bash
openssl enc -des-ecb -d -nopad -K E84AD660C4721AE0 \
  -provider legacy -provider default \
  -in ~/.vnc/passwd 2>/dev/null | head -c 8 | tr -d '\0'; echo
```

> OpenSSL 3 (Ubuntu 22.04+) needs `-provider legacy -provider default`; drop them on OpenSSL 1.1. A 16-byte file also holds a view-only password in bytes 9–16 (`tail -c +9 | head -c 8`).

---

## 10. Troubleshooting

**"A Xtigervnc server is already running" (legacy custom unit)** — systemd runs no shell, so the redirect in `ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1` became literal args and the pre-kill always failed. Drop the redirect. If a restart still refuses:

```bash
vncserver -kill :1
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 ~/.vnc/*:1.pid   # stale locks
```

**Bus / env values differ between shells — expected:**

| Context | `DBUS_SESSION_BUS_ADDRESS` | `XDG_RUNTIME_DIR` | `DISPLAY` |
|---|---|---|---|
| SSH login shell | `unix:path=/run/user/1100/bus` | `/run/user/1100` | *(empty)* |
| Terminal inside VNC | `unix:abstract=/tmp/dbus-…` | `/run/user/1100` | `:1.0` |

The VNC session runs on its own `dbus-run-session` bus (a `/tmp` abstract socket); an SSH login uses the systemd user bus from `pam_systemd`. To poke the VNC session's bus from SSH: `tr '\0' '\n' < /proc/$(pgrep -u marslo -x xfce4-session)/environ`.
