# Aliases
alias vi='nvim'
alias v='nvim'
alias cl='claude'
alias cl-sub='claude --settings ~/.claude/settings-sub.json' # real Anthropic subscription (bypasses copilot-api proxy); needed for Fable 5 etc.
alias cl-figma='claude --mcp-config ~/.claude/mcp-figma.json' # loads the Figma MCP on demand (docs-internal brand-migration work)
# Claude Code on Venice AI (Qwen) via a local LiteLLM proxy on :4142 (started on demand).
# Key: $VENICE_API_KEY, else Keychain: security add-generic-password -a "$USER" -s venice-api-key -w
cl-venice() {
  local key="${VENICE_API_KEY:-$(security find-generic-password -s venice-api-key -w 2>/dev/null)}"
  if [ -z "$key" ]; then
    echo "cl-venice: no Venice key; set VENICE_API_KEY or add Keychain item 'venice-api-key'" >&2
    return 1
  fi
  if ! curl -sf -o /dev/null http://localhost:4142/health/liveliness; then
    echo "cl-venice: starting LiteLLM proxy (log: ~/.cache/litellm-venice.log)..."
    mkdir -p ~/.cache
    VENICE_API_KEY="$key" nohup litellm --config "$MY_CONFIG_PROJECT_DIR/dotfiles/litellm/venice.yaml" \
      --host 127.0.0.1 --port 4142 >~/.cache/litellm-venice.log 2>&1 &!
    local i
    for i in {1..60}; do
      curl -sf -o /dev/null http://localhost:4142/health/liveliness && break
      sleep 0.5
    done
  fi
  claude --settings ~/.claude/settings-venice.json "$@"
}
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
