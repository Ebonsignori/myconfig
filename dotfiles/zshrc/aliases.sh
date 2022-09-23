# Aliases
alias vi='nvim'
alias v='nvim'
alias update="source ~/.zshrc"
alias l='colorls --group-directories-first --almost-all --light'
alias ll='colorls --group-directories-first --almost-all --long --light' # detailed list view

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

