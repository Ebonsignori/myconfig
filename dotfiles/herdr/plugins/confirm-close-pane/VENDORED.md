# Vendored: confirm-close-pane

Upstream: https://github.com/poweroutlet2/herdr-confirm-close-pane
Commit:   cde6341f51366f6fa54ea7ada3a81e390530a514 ("fix README prompt to match actual output")
Vendored: 2026-09-18

Everything except this file is a byte-for-byte copy of upstream. To check for
drift later:

    git clone https://github.com/poweroutlet2/herdr-confirm-close-pane /tmp/ccp
    diff -r /tmp/ccp dotfiles/herdr/plugins/confirm-close-pane -x .git -x VENDORED.md

Vendored rather than `herdr plugin install` so the code is pinned in this repo
and cannot change under us; init.sh registers it with `herdr plugin link`.

## Audit notes (2026-09-18)

Whole plugin is 3 files / ~1.3 KB of POSIX sh, read in full. Findings:

- No network access, no eval, no base64, no obfuscation, no filesystem writes,
  no non-printing characters. The only program it runs is the herdr binary.
- The manifest declares only `[[actions]]` and `[[panes]]` -- no `[build]`,
  `[startup]`, `[[events]]` or `[[link_handlers]]`. Nothing executes at install
  time or in the background; code runs only when the keybinding is pressed.
- Every herdr CLI flag it uses was verified against herdr 0.7.5:
  `plugin pane open --plugin/--entrypoint/--placement/--focus/--env` and
  `pane close <pane_id>` all exist with those exact spellings.
- Shell variables are quoted correctly; no word-splitting or injection paths.

Two upstream README inaccuracies, neither affecting safety:

- It gives the macOS config path as `~/Library/Application Support/herdr/`.
  herdr 0.7.5's own embedded default config says `~/.config/herdr/config.toml`,
  which is what this machine uses.
- It suggests `prefix+shift+x` as the alternate key. That is already herdr's
  default `close_tab` binding -- pick something else if you ever switch keys.

Not replaceable by built-in config: herdr's `ui.confirm_close` confirms closing
a *workspace*, not a pane. There is no built-in pane-close confirmation.
