# Sets title of terminal tab to working directory for Mac and Linux
# for ZSH
case "$OSTYPE" in
  darwin*)
    # MAC OS Specific settings
    # Start ssh-agent
    alias startSsh='eval "$(ssh-agent -s)"'
    # Set gnome-terminal tab titles
    function set-title() {
      echo -ne "\033]0;"$*"\007"
    }
  ;;
  linux*)
    # Alias pbcopy / pbpaste for linux
    alias pbcopy='xsel -ib'
    alias pbpaste='xsel -ob'
    # Alias nautilus to open
    openFunction() {
      nohup nautilus $1 > /dev/null 2>&1 & disown
    }
    alias open='openFunction'
    # Set gnome-terminal tab titles
    function set-title() {
      printf "\e]2;$1\a"
    }
  ;;
esac

precmd() {
  set-title `pwd | sed 's#.*/##'`
}

