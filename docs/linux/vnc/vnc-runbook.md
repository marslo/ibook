# TigerVNC on the shared box — Ops Runbook

> **Host** `sj4dl360n4u20` · **OS** Ubuntu 22.04.5 · **Desktop** XFCE 4.16 · **Server** TigerVNC 1.12 · **Updated** 2026-08-29

Running isolated VNC desktops for several users on one server — plus the Chrome file-dialog fix, hardening, and password recovery.

---

## 1. Display map

One display number per user, each a separate X server on its own port with its own `~/.vnc/passwd`. Users are isolated by construction — nobody can enter another display without that display's password.

| Display | Port | User | Service | Managed by |
|---|---|---|---|---|
| `:1` | 5901 | marslo *(owner)* | `vncserver@1` → `tigervncserver@:1` | custom unit today; migrate in §6 |
| `:2` | 5902 | ubuntu *(guest)* | `tigervncserver@:2` | official mechanism |
| `:3` | 5903 | iliad *(guest)* | `tigervncserver@:3` | official mechanism |

> **Why not just `vncserver@2`?** In the custom unit the `@N` is the *display number* and `User=marslo` is hardcoded — so `vncserver@2/@3` would open more desktops **as marslo**, not sessions for the other users. Other users need the official display→user mapping below.

---

## 2. Enable VNC for another account

TigerVNC's packaged multi-user mechanism is already installed: a display→user map in `/etc/tigervnc/vncserver.users` plus the `tigervncserver@` unit, which launches each session as the mapped user through a real PAM login.

```bash
# /etc/tigervnc/vncserver.users — one line per display
sudo tee /etc/tigervnc/vncserver.users >/dev/null <<'EOF'
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

> **Note — two independent systems.** The custom `vncserver@` (marslo) and the packaged `tigervncserver@` are different units. Keep display numbers unique and never start the same display from both. Each guest also needs their own `~/.vnc/xstartup` for XFCE, or they land in the system default session.

---

## 3. Per-user config — `~/.vnc/tigervnc.conf`

The `tigervncserver@` unit reads options from a config file, **not** the command line. It is **Perl syntax** and must end in `1;`. Geometry, depth, and network exposure live here.

```perl
# ~/.vnc/tigervnc.conf — Perl syntax, sourced per user
$geometry  = "1920x1080";
$depth     = "24";
$localhost = "no";   # listen on all interfaces; "yes" = localhost-only
1;
```

> ⚠️ **Warning — the localhost default flips to “yes”.** With the default `VncAuth` security type, TigerVNC defaults to `$localhost="yes"` (**localhost-only**), unlike the old custom unit's `-localhost no`. For direct network access set `$localhost="no"` explicitly. Otherwise guests can only reach it over an SSH tunnel — which is the safer default (see §7).

---

## 4. The `xstartup` reference

Kept in each user's `~/.vnc/xstartup` and honored by both the custom and official units. This is the marslo copy.

```sh
#!/bin/sh
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

# runtime dir (kept alive by enable-linger); avoids apps falling back to /tmp
test -d "/run/user/$(id -u)" && export XDG_RUNTIME_DIR="/run/user/$(id -u)"

# desktop identity (xdg-open, autostart filtering).
# portal is intentionally disabled; append ":GNOME" if you ever want it back
export XDG_CURRENT_DESKTOP=XFCE

# clipboard bridge between vnc viewer and X
vncconfig -nowin &
autocutsel -fork
autocutsel -selection PRIMARY -fork

# disable X screensaver / blanking
xset s off -dpms 2>/dev/null

# DPI has no tigervnc.conf knob — set it here (old unit used -dpi 120)
xrandr --dpi 120 2>/dev/null

exec dbus-run-session -- startxfce4
```

- **`dbus-run-session`** — this XFCE session has no bus of its own (neither `startxfce4` nor the XFCE `xinitrc` starts one), and because VNC is launched from a systemd *system* service `XDG_RUNTIME_DIR` is empty, so the systemd user bus isn't the default either. `dbus-run-session` guarantees a private bus and tears it down cleanly on logout.
- **`XDG_RUNTIME_DIR` guard** — set only if the dir exists (it does, thanks to `enable-linger`). Becomes redundant once you migrate to the PAM-based unit in §6.

---

## 5. Chrome upload dialog opens at `/`

**Per-user fix.** Chrome ≥123 hands its file dialog to `xdg-desktop-portal` when reachable, and the portal's GTK backend ignores Chrome's saved `last_directory`, opening at the filesystem root. Chrome's own preference is fine — it just isn't consulted in portal mode.

### Fix — disable the portal for your user (keep the packages)

```bash
mkdir -p ~/.local/share/dbus-1/services
tee ~/.local/share/dbus-1/services/org.freedesktop.portal.Desktop.service <<'EOF'
[D-BUS Service]
Name=org.freedesktop.portal.Desktop
Exec=/bin/false
EOF
# then restart the session
```

The user-level file outranks the one in `/usr/share`, so activating the portal runs `/bin/false` and fails → Chrome sees “no portal” and falls back to its built-in GTK dialog, which remembers the last folder. Revert by deleting the file and restarting the session.

> ⚠️ **`systemctl --user mask` does NOT work here.** This session runs on a `dbus-launch`/`dbus-run-session` bus whose `session.conf` has no systemd activation, so the portal is activated *directly* by dbus-daemon — masking the systemd unit is bypassed. Shadowing the D-Bus service file is the reliable, bus-agnostic lever.

> **Note — it's per user.** The shadow lives in one user's `~/.local`. Each guest who uses Chrome hits the same `/` problem and needs the same file in their own home.

---

## 6. Retire the custom unit (optional)

The hand-rolled `/etc/systemd/system/vncserver@.service` is redundant: run marslo's `:1` through the same official mechanism. Bonus — `tigervncsession` opens a real PAM session, so `XDG_RUNTIME_DIR` is populated for free.

1. Move CLI options to `~/.vnc/tigervnc.conf` (§3) — `geometry`, `depth`, `localhost`.
2. Move `-dpi 120` into `~/.vnc/xstartup` (§4) — it has no config knob.
3. `~/.vnc/xstartup` carries over automatically — no change needed there.

```bash
# add marslo to the map alongside :2 / :3
grep -q '^:1=' /etc/tigervnc/vncserver.users \
  || echo ':1=marslo' | sudo tee -a /etc/tigervnc/vncserver.users

# swap the units
sudo systemctl disable --now vncserver@1.service
sudo systemctl enable  --now tigervncserver@:1.service

# optional: remove the now-unused custom unit
sudo rm /etc/systemd/system/vncserver@.service
sudo systemctl daemon-reload
```

---

## 7. Hardening

> 🔒 **VNC auth is weak.** `~/.vnc/passwd` is **reversibly obfuscated** (fixed DES key), not hashed, and only the first **8 characters** matter. Treat a VNC password as low-trust: never reuse it elsewhere.

For a shared server, don't leave the ports open. Prefer **localhost-only + SSH tunnel**:

```bash
# set $localhost="yes" in tigervnc.conf, then tunnel the port (from the client)
ssh -L 5902:localhost:5902 ubuntu@sj4dl360n4u20
# then point the VNC viewer at  localhost:5902
```

- Only SSH-authenticated users can reach the VNC port — the biggest single win.
- If you must expose ports (`$localhost="no"`), firewall `5901-5903` to trusted IPs and give each user a distinct password.

---

## 8. Forgot a VNC password

### Just reset it — no old password needed

```bash
vncpasswd                                   # rewrites ~/.vnc/passwd
sudo systemctl restart vncserver@1.service  # or tigervncserver@:2 etc.
```

### Recover the old plaintext (it's decryptable)

Because the file is fixed-key DES, the original (first 8 chars) can be decrypted. The VNC key `{23,82,107,6,35,78,88,7}` is fed with each byte bit-reversed → `E84AD660C4721AE0`, which standard OpenSSL DES accepts.

```bash
openssl enc -des-ecb -d -nopad -K E84AD660C4721AE0 \
  -provider legacy -provider default \
  -in ~/.vnc/passwd 2>/dev/null | head -c 8 | tr -d '\0'; echo
```

> **Note.** Drop `-provider legacy -provider default` on OpenSSL 1.1 (it doesn't recognize the flags); Ubuntu 22.04 is OpenSSL 3 and needs them. A 16-byte file also holds a view-only password in bytes 9–16 (`tail -c +9 | head -c 8`).

---

## 9. Troubleshooting

### “A Xtigervnc server is already running” on restart

The old custom unit had a latent bug — systemd runs no shell, so the redirect in `ExecStartPre=-/usr/bin/vncserver -kill :%i > /dev/null 2>&1` became literal arguments and the pre-kill failed every time. Fix: drop the redirect (`ExecStartPre=-/usr/bin/vncserver -kill :%i`). If a restart still refuses:

```bash
vncserver -kill :1
# if it complains about stale locks:
rm -f /tmp/.X1-lock /tmp/.X11-unix/X1 ~/.vnc/*:1.pid
sudo systemctl start vncserver@1.service
```

### Bus / env values differ between shells — expected

Values depend on *where* you run the command, not on any misconfig:

| Context | `DBUS_SESSION_BUS_ADDRESS` | `XDG_RUNTIME_DIR` | `DISPLAY` |
|---|---|---|---|
| SSH login shell | `unix:path=/run/user/1100/bus` | `/run/user/1100` | *(empty)* |
| Terminal inside VNC | `unix:abstract=/tmp/dbus-…` | *(empty)* | `:1.0` |

The VNC session runs on its own `dbus-run-session` bus and (as a system-service child) has no `XDG_RUNTIME_DIR`; an SSH login gets the systemd user bus from `pam_systemd`. Migrating to the official unit (§6) makes the VNC session a proper login and fills in `XDG_RUNTIME_DIR`.
