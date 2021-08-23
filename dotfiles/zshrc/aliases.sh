# Aliases
alias vi='nvim'
alias v='nvim'
alias update="source ~/.zshrc"
alias l='colorls --group-directories-first --almost-all --light'
alias ll='colorls --group-directories-first --almost-all --long --light' # detailed list view

# Navigation aliases
alias cd-myconfig='cd ~/Projects/myconfig'
alias cd-pt='cd ~/Projects/pitch-trainer-midi'
# github
alias cd-booster-hww='cd ~/Projects/github/how-we-work-booster-pack'
alias cd-testing-hww='cd ~/Projects/github/how-we-work-booster-pack-testing'
alias cd-ebonsignori-hww='cd ~/Projects/github/how-we-work-booster-pack-testing-ebonsignori'

# Git
alias vdiff='git difftool'
alias gcom='git checkout master'

# Install and use package.json version via nvm
alias useNode='nvm install `node -p -e require("./package").engines.node`'

# Docker
alias dup='docker-compose up'

