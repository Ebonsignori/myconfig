#!/bin/sh
# Runs inside a real herdr pane (it has a TTY). Asks y/n once; on "y" closes the
# target tab, then exits. Exiting dismisses this overlay automatically.
set -u

herdr="${HERDR_BIN_PATH:-herdr}"
target="${HERDR_TARGET_TAB_ID:-}"

if [ -z "$target" ]; then
  printf 'No tab to close.\n'
  sleep 1
  exit 0
fi

field() { sed -n "s/.*\"$1\":\"\{0,1\}\([^\",}]*\).*/\1/p"; }

# Name the tab and its pane count so it is clear what is about to go.
info=$("$herdr" tab get "$target" 2>/dev/null || true)
label=$(printf '%s' "$info" | field label)
panes=$(printf '%s' "$info" | field pane_count)
workspace=$(printf '%s' "$info" | field workspace_id)

# herdr refuses to close a workspace's last tab, so that case closes the
# workspace itself.
tabs=''
if [ -n "$workspace" ]; then
  ws_info=$("$herdr" workspace get "$workspace" 2>/dev/null || true)
  tabs=$(printf '%s' "$ws_info" | field tab_count)
  ws_label=$(printf '%s' "$ws_info" | field label)
fi

if [ "$tabs" = 1 ]; then
  printf 'Last tab: close workspace "%s" (%s panes)? (y/n): ' "${ws_label:-$workspace}" "${panes:-?}"
else
  printf 'Close tab "%s" (%s panes)? (y/n): ' "${label:-$target}" "${panes:-?}"
fi

# Read a single key without echoing. Restore the terminal on any exit path.
saved=''
if saved=$(stty -g 2>/dev/null); then
  trap 'stty "$saved" 2>/dev/null || true' EXIT INT TERM
  stty -echo -icanon min 1 time 0 2>/dev/null || true
  key=$(dd bs=1 count=1 2>/dev/null)
else
  # No TTY available: fall back to a normal line read.
  key=$(read line && printf '%s' "$line")
fi
printf '\n'

case "$key" in
  y|Y)
    if [ "$tabs" = 1 ]; then
      out=$("$herdr" workspace close "$workspace" 2>&1)
    else
      out=$("$herdr" tab close "$target" 2>&1)
    fi
    if [ $? -ne 0 ]; then
      # Keep the overlay up long enough to read why.
      printf 'failed: %s\n' "$out"
      sleep 3
    fi
    ;;
  *)
    printf 'cancelled.\n'
    ;;
esac
