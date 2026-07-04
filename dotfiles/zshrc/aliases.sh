# Aliases
alias vi='nvim'
alias v='nvim'
alias cl='vt claude'
alias update="source ~/.zshrc"
alias l='lsd'
alias ll='lsd -al'
alias ls='lsd'

# Navigation aliases
alias cd-myconfig='cd ~/Projects/myconfig'
alias cd-et='cd ~/Projects/ear-tools'
# github
alias cd-booster='cd ~/Projects/github/how-we-work-booster-pack'
alias cd-booster-testing='cd ~/Projects/github/how-we-work-booster-pack-testing'
alias cd-booster-ebonsignori='cd ~/Projects/github/how-we-work-booster-pack-testing-ebonsignori'

# Git
alias vdiff='git difftool'
alias gcom='git checkout main'

# Install and use package.json version via nvm
alias useNode='nvm install `node -p -e require("./package").engines.node`'

# Docker
alias dup='docker-compose up'

# Slack MCP setup - get token from https://api.slack.com/apps/A01G8NHTM7Y/oauth
alias smcp='~/.local/bin/slack-mcp-setup'

# LLM Echo Server - usage: es 8080 or es 8080 "custom message"
function es {
  node ~/Projects/myconfig/echo-server/echo-server.mjs "$@"
}

# tmax - open a tmux session with a 2x2 grid of panes, all cd'd to a directory.
# usage: tmax ~/Projects/ear-tools   (session named after the dir; -2, -3... on collision)
#        tmax                        (uses the current directory)
function tmax {
  local dir="${1:-$PWD}"
  if [[ ! -d "$dir" ]]; then
    echo "tmax: not a directory: $dir" >&2
    return 1
  fi
  dir="$(cd "$dir" && pwd)"           # absolute, normalized

  local base name i=2
  base="$(basename "$dir")"
  name="$base"
  while tmux has-session -t "=$name" 2>/dev/null; do
    name="${base}-${i}"; (( i++ ))
  done

  tmux new-session -d -s "$name" -c "$dir"
  local n
  for n in 1 2 3; do
    tmux split-window -c "$dir" -t "$name:0"
    tmux select-layout -t "$name:0" tiled >/dev/null
  done
  tmux select-pane -t "$name:0.0"

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$name"     # already inside tmux
  else
    tmux attach-session -t "$name"
  fi
}
