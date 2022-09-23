# Sets title of terminal tab to working directory for Mac and Linux
# for ZSH
case "$OSTYPE" in
  darwin*)
    # MAC OS Specific settings
    # Yank to the system clipboard
    function vi-yank-xclip {
        zle vi-yank
      echo "$CUTBUFFER" | pbcopy -i
    }
  ;;
  linux*)
    # Linux Specific settings
    # Yank to the system clipboard
    function vi-yank-xclip {
        zle vi-yank
      echo "$CUTBUFFER" | xclip -i
    }
  ;;
esac

zle -N vi-yank-xclip
bindkey -M vicmd 'y' vi-yank-xclip