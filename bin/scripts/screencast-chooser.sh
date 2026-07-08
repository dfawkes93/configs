#!/usr/bin/env bash
# Output/window chooser for xdg-desktop-portal-wlr (Sway).
#
# xdpw runs this as a `simple` chooser when an app (e.g. Teams) requests a
# screencast. It must print the user's choice on stdout in one of:
#     Monitor: <output-name>                      (a whole screen)
#     Window:  <foreign-toplevel-identifier>      (a single window)
# Printing nothing (or exiting non-zero) is treated as "user declined".
#
# Screens come from `swaymsg -t get_outputs`; windows from `get_tree`'s
# `foreign_toplevel_identifier` field (Sway >= 1.12). Presented as a single
# fuzzel list so you pick from screens *and* windows without a drag-select.

set -uo pipefail

declare -A MAP     # visible label -> token to emit
menu=()

add() {            # $1 = token, $2 = label
  local token="$1" label="$2" key="$2" n=1
  while [[ -n "${MAP[$key]:-}" ]]; do key="$label ($((++n)))"; done
  MAP["$key"]="$token"
  menu+=("$key")
}

# --- Screens (whole outputs) ---
while IFS=$'\t' read -r name make model; do
  [[ -n "$name" ]] && add "Monitor: $name" "🖥  Screen · $name — $make $model"
done < <(swaymsg -t get_outputs 2>/dev/null \
  | jq -r '.[] | select(.active) | [.name, .make, .model] | @tsv' 2>/dev/null)

# --- Windows (single toplevels) ---
while IFS=$'\t' read -r id app title; do
  [[ -n "$id" ]] && add "Window: $id" "🪟  Window · $app — ${title:0:60}"
done < <(swaymsg -t get_tree 2>/dev/null \
  | jq -r '[.. | objects | select(.foreign_toplevel_identifier != null)]
           | .[] | [ .foreign_toplevel_identifier,
                     (.app_id // .window_properties.class // "?"),
                     (.name // "") ] | @tsv' 2>/dev/null)

# Support a --list debug mode: print "TOKEN => LABEL" and exit (no GUI).
if [[ "${1:-}" == "--list" ]]; then
  for key in "${menu[@]}"; do printf '%s => %s\n' "${MAP[$key]}" "$key"; done
  exit 0
fi

((${#menu[@]})) || exit 0

# Present the picker.
#  --no-exit-on-keyboard-focus-loss: keep it up if something steals focus
#    (Teams window, a notification, …) instead of quitting with no selection.
#  Retry loop: fuzzel enforces a single instance per Wayland display via a
#    lock. If the previous share's picker hasn't released the lock yet, a fresh
#    fuzzel exits instantly with "failed to acquire lock: fuzzel already
#    running" and no UI — the "no prompt -> shares nothing" wedge. We retry
#    across that release race. A clean empty result (you pressed Esc) is a
#    real decline and is NOT retried.
pick() {
  local out err rc
  for _ in $(seq 1 15); do
    err="$(mktemp)"
    out="$(printf '%s\n' "${menu[@]}" \
      | fuzzel --dmenu --prompt 'Share ▸ ' --no-exit-on-keyboard-focus-loss 2>"$err")"
    rc=$?
    # Another fuzzel is already up (e.g. Teams fires a 2nd getDisplayMedia and
    # both choosers race the single-instance lock). Wait for it to clear, retry.
    if grep -qiE 'acquire lock|already running' "$err"; then rm -f "$err"; sleep 0.15; continue; fi
    rm -f "$err"; printf '%s' "$out"; return "$rc"
  done
  return 1
}
choice="$(pick)" || exit 0
[[ -n "$choice" ]] || exit 0
printf '%s\n' "${MAP[$choice]:-}"
