# Setting up a machine from scratch

These are personal dotfiles managed with **GNU Stow**. Most packages need nothing more
than `./stow-all` — this file documents the ones that **also** require packages to be
installed, services enabled, or system files changed that stow can't manage.

> Convention: each top-level directory is a stow "package". `./stow-all` symlinks them into
> `$HOME` (`.stowrc` sets `--target=$HOME`). `c3270`, `windows`, and `scripts` are **not**
> stowed. Per-host packages (`host-<hostname>/`) are stowed automatically by `stow-all` when
> the hostname matches.

## 0. Bootstrap

```sh
sudo pacman -S --needed git stow zsh
git clone <this repo> ~/projects/configs   # or wherever
cd ~/projects/configs
./stow-all
```

`stow-all` is safe to re-run; use `stow -R <pkg>` to restow a single package after moving files.

---

## Shell & terminal

### zsh
- **Packages:** `zsh`
- **Setup beyond stow:** zsh uses `ZDOTDIR=$HOME/.config/zsh` (where the modular
  `.zshrc` / `zsh-*` component files live). That variable must be exported *before* zsh
  starts, which stow does not bootstrap — set it in `/etc/zsh/zshenv` (or a minimal
  `~/.zshenv`):
  ```sh
  export ZDOTDIR="$HOME/.config/zsh"
  ```
- `.zshrc` branches on `uname -n`; host-specific/sensitive settings live in `zsh-work`
  and the per-host `zsh-local` (shipped in `host-<hostname>/`).
- Make it the login shell: `chsh -s /usr/bin/zsh`.

### bash / starship / tmux / alacritty
- **Packages:** `starship`, `tmux`, `alacritty` (bash is preinstalled).
- **Setup beyond stow:** none — pure config. Per-host alacritty overrides come from
  `host-<hostname>/.config/alacritty/local.toml`.
- _TODO: note tmux plugin manager (tpm) install here if used._

---

## Editors

### nvim
- **Packages:** `neovim` (plus `git`, a C compiler, `ripgrep`, `fd` for Telescope/plugins).
- **Setup beyond stow:** Lua config with **lazy.nvim**; plugins bootstrap on first launch and
  are pinned by `lazy-lock.json`. Run `nvim` once and let it sync, or `:Lazy sync`.

### vim
- **Packages:** `vim`. No extra setup.

---

## Desktop environment

Pick the stack that matches the machine — both are present in the repo.

### Wayland (sway / hypr)
- **Packages:** `sway` *or* `hyprland`, plus `waybar`, `fuzzel`, `nwg-bar`,
  and the usual portals: `xdg-desktop-portal`, `xdg-desktop-portal-wlr` (wlroots) /
  `xdg-desktop-portal-hyprland`.
- **Setup beyond stow:** per-host sway tweaks are sourced from
  `host-<hostname>/.config/sway/local.d/local.conf` (e.g. clamshell/output config).
- ⚠️ **InputCapture portal:** lan-mouse's preferred capture backend needs a portal
  implementing `org.freedesktop.portal.InputCapture`; if it's missing lan-mouse falls back to
  the `layer-shell` backend (works fine on wlroots). No action needed unless you want the
  portal backend.

### X11 (awesome)
- **Packages:** `awesome`, `picom` (compositor), `rofi` (launcher), plus a terminal.
- **Setup beyond stow:** none beyond the WM picking up the config.

---

## Tools

| Package | Arch package | Setup beyond stow |
|---------|--------------|-------------------|
| `git`   | `git`        | none (config only) |
| `ranger`| `ranger`     | none |
| `rbw`   | `rbw`        | Bitwarden CLI client — run `rbw config` / `rbw login` once to point at your server & account |
| `bin`   | —            | scripts land on `~/.local/...`; ensure `~/.local/bin` and `~/.local/scripts` are on `PATH` (handled in `.zshrc`) |

---

## Claude Code + tmux

Running a session (or several) per tmux project needs a bit of glue, since Claude Code has
no idea tmux exists and tmux has no idea Claude Code does. The tmux half lives in
`tmux/tmux.conf`; the scripts live in `bin/scripts/`; the wiring lives in
`~/.claude/settings.json`, which is **not stowed** — Claude Code rewrites that file itself
(`/theme`, `/model`, …), so it is configured by hand:

```json
{
  "statusLine": { "type": "command", "command": "~/.local/scripts/claude-statusline" },
  "hooks": {
    "SessionStart":  [ { "hooks": [ { "type": "command", "command": "~/.local/scripts/claude-session-title" } ] } ],
    "Notification":  [ { "hooks": [ { "type": "command", "command": "~/.local/scripts/claude-tmux-notify"  } ] } ]
  }
}
```

- **Packages:** `jq` (all three scripts parse the hook payload), plus a notification daemon
  such as `mako` for `notify-send`.
- `claude-agents` (**prefix+a**) — opens the agent view with `--cwd <git root>` so the list
  is only this project's sessions. Plain `claude agents` is global across every directory.
- `claude-tmux-notify` — `Notification` hook. Marks the session's tmux window with a
  `@claude_state` user option (amber = blocked on you, green = finished) which
  `window-status-format` renders as a dot, and fires a `notify-send` naming the tmux
  `session:window`. Cleared by the `session-window-changed` / `pane-focus-in` hooks when you
  visit the window. Relies on hooks inheriting `$TMUX_PANE` from Claude Code.
- `claude-session-title` — `SessionStart` hook. Titles the session after its tmux session so
  the agent view rows read as projects. `Ctrl+R` renames one by hand; `Ctrl+S` inside the
  view toggles grouping between state and directory.
- `claude-statusline` — shows tmux session / project / branch / model / context %, so two
  panes side by side are never confused for each other.
- `allow-passthrough on` and the `extended-keys` lines in `tmux.conf` are required
  regardless: without them tmux swallows Claude Code's notification and progress escapes,
  and Shift+Enter submits instead of inserting a newline. Alacritty additionally needs a
  one-off `/terminal-setup`, run in the host terminal rather than inside tmux.

---

## Audio — PipeWire (`host-*`)

- **Packages:** `pipewire`, `pipewire-pulse`, `wireplumber` (+ `pipewire-alsa`/`pipewire-jack`
  as needed).
- **Setup beyond stow:** enable the user services: `systemctl --user enable --now pipewire
  pipewire-pulse wireplumber`. Host-specific drop-ins live under
  `host-<hostname>/.config/pipewire/` and `.../wireplumber/`.

### Network microphone (netmic) — egg → laptop
Streams egg's mic to the laptop over unicast RTP (SAP/multicast is dropped by the mesh WiFi).
- **Sender** (`host-egg/.config/pipewire/pipewire.conf.d/90-netmic-send.conf`): sends to
  `dylan-21hh000qau.local`.
- **Receiver** (`host-dylan-21hh000qau/.config/pipewire/pipewire.conf.d/90-netmic-recv.conf`):
  binds `::` (dual-stack).
- **Requires** the mDNS + IPv4-preference + firewall prerequisites below; otherwise the send
  fails with `sendmsg: Permission denied` or never reaches the receiver.

---

## Input sharing — lan-mouse (`host-*`)

Shares one keyboard/mouse between the laptop and egg.
- **Packages:** `lan-mouse`.
- **Enable:** `systemctl --user enable --now lan-mouse` (unit in `systemd/user/`).
- **Setup beyond stow — important gotchas:**
  1. **Resolve by name (`.lan` FQDN).** lan-mouse resolves the `hostname` field via
     unicast DNS only — **not** mDNS, so a `.local` name does not work. Pi-hole now serves
     the local `.lan` zone, so set `hostname` to the FQDN (`egg.lan`, `dylan-21hh000qau.lan`)
     and drop the static `ips` list. Use the full `.lan` suffix: `resolv.conf` has no search
     domain, so a bare hostname is `NXDOMAIN`. (Static `ips` was the stopgap before Pi-hole;
     it also went stale when the laptop's lease changed.)
  2. **Certificate fingerprints must be committed.** Each peer authorises the other's TLS
     cert fingerprint under `[authorized_fingerprints]`. lan-mouse saves accepted fingerprints
     *into `config.toml`* — but that file is a stow symlink into this repo, so a `git pull`
     wipes any runtime-saved entry. They're committed here so they survive; if you add a new
     machine, get its fingerprint and commit it:
     ```sh
     openssl x509 -in ~/.config/lan-mouse/lan-mouse.pem -noout -fingerprint -sha256
     ```
     (lower-case it; add under the peer's `[authorized_fingerprints]`).
  3. **Open the firewall** — see below.

---

## System-level network prerequisites (NOT managed by stow)

These live in `/etc` and aren't captured by the dotfiles. Required for netmic + lan-mouse,
and for reaching machines by name generally.

### mDNS (`.local` name resolution)
```sh
sudo pacman -S avahi nss-mdns
sudo systemctl enable --now avahi-daemon
```
Add `mdns_minimal [NOTFOUND=return]` to the `hosts:` line in `/etc/nsswitch.conf`, e.g.:
```
hosts: mymachines mdns_minimal [NOTFOUND=return] resolve [!UNAVAIL=return] files myhostname dns
```

### Prefer IPv4 (`/etc/gai.conf`)
mDNS returns an IPv6 ULA/link-local ahead of IPv4, which breaks the netmic RTP send and
flaps resolution. Force IPv4 first **on both hosts**:
```sh
echo 'precedence ::ffff:0:0/96  100' | sudo tee -a /etc/gai.conf
```

### firewalld — open lan-mouse's port
lan-mouse uses **UDP 4242**. Open it in the LAN interface's zone **on both hosts** (the
laptop's `wlan0` is in the `home` zone; check egg's with `firewall-cmd --get-active-zones`):
```sh
sudo firewall-cmd --zone=home --permanent --add-port=4242/udp
sudo firewall-cmd --reload
```
Symptom if missing: `ping` works but lan-mouse logs `failed to connect … Connection timed out`.

---

## systemd units

Stowed to `~/.config/systemd/`. After stowing, reload and enable what you need:
```sh
systemctl --user daemon-reload
systemctl --user enable --now lan-mouse        # systemd/user/lan-mouse.service
```
- `systemd/maccy.service` — _TODO: document what this runs and whether it's user/system._

---

## Excluded / manual packages

Not stowed by `stow-all`; handle manually if needed:
- `c3270` — 3270 terminal emulator config.
- `windows` — Windows-side config.
- `scripts` — repo-local helper scripts (`ta`, `conf`, `fix-worktree-remote`, …); run
  directly from the repo, they are intentionally not symlinked.
