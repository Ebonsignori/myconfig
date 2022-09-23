# Default ENVs
export AWS_REGION=us-east-1

# User bin directory, add to path
export PATH=~/.bin:$PATH

# Change default editor
export EDITOR=/usr/local/bin/nvim
export VISUAL=/usr/local/bin/nvim

# Make FZF open with last search (useful for vim)
export FZF_DEFAULT_OPTS="--history=$HOME/.fzf_history"

# Shapeship prompt
SPACESHIP_EXIT_CODE_SHOW=true
SPACESHIP_VI_MODE_COLOR=grey
# spaceship_vi_mode_enable

# Add kubectl autocomplete
# source <(kubectl completion zsh)