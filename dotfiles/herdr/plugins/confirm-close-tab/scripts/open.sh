#!/bin/sh
# Action entrypoint. Runs without a TTY, so it just opens the confirmation
# overlay and hands the focused tab id (the tab we want to close) to it via
# HERDR_TARGET_TAB_ID. The overlay itself lands in a new pane, so the id must
# be captured here.
set -eu

herdr="${HERDR_BIN_PATH:-herdr}"
target="${HERDR_TAB_ID:-}"

exec "$herdr" plugin pane open \
  --plugin confirm-close-tab \
  --entrypoint confirm \
  --placement overlay \
  --focus \
  --env "HERDR_TARGET_TAB_ID=$target"
