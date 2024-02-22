# zshrc is modularized into the files below
autoload -U add-zsh-hook
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/variables.sh
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/aliases.sh
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/versionBump.sh
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/setTerminalTitle.sh
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/useDotNvmVersion.sh
. $MY_CONFIG_PROJECT_DIR/dotfiles/zshrc/vimMode.sh

# Only load zsh syntax highlighting once
if [ -z $ZSH_SYNTAX_HIGHLIGHTING_LOADED ]; then
  export ZSH_SYNTAX_HIGHLIGHTING_LOADED=1
  source ~/Projects/myconfig/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Allow vim mode in zsh
bindkey -v

# Yank to the system clipboard
function vi-yank-xclip {
    zle vi-yank
   echo "$CUTBUFFER" | pbcopy -i
}

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip
