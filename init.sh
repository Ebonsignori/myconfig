#!/bin/zsh

# This script won't work unless this var is set
if [ -z "$MY_CONFIG_PROJECT_DIR" ]; then
  echo "Must have 'MY_CONFIG_PROJECT_DIR' set to myconfig project directory."
  exit 1
fi

# Config variables
MY_CONFIG_DIR=~/.myconfig
MY_BIN_DIR=$MY_CONFIG_DIR/bin
NVIM_CONFIG_DIR=~/.config/nvim

# Terminal files
GIT_COMPLETE_PATH=$MY_BIN_DIR/.git-completion.bash
GIT_COMPLETE_PATH_ZSH=$MY_BIN_DIR/.git-completion.zsh
GIT_PROMPT_PATH=$MY_BIN_DIR/.git-prompt.sh
ZSH_AUTOCOMPLETE_PATH=$MY_BIN_DIR/zsh-autocomplete
ZSH_AUTOCOMPLETE_FILE=$ZSH_AUTOCOMPLETE_PATH/zsh-autocomplete.plugin.zsh

# Dot files
NVIM_CONFIG_ORIGIN_PATH=$MY_CONFIG_PROJECT_DIR/dotfiles/init.vim
NVIM_CONFIG_PATH=~/.config/nvim/init.vim
TMUX_CONFIG_ORIGIN_PATH=$MY_CONFIG_PROJECT_DIR/dotfiles/.tmux.conf
TMUX_CONFIG_PATH=~/.tmux.conf
GLOBAL_GITCONFIG_PATH=~/.gitconfig
GLOBAL_GITCONFIG_ORIGIN_PATH=$MY_CONFIG_PROJECT_DIR/dotfiles/.gitconfig
ZSH_PROFILE_PROJECT_PATH=$MY_CONFIG_PROJECT_DIR/dotfiles/zsh_profile

# Script constants
FALSE=225


# Entry Point
main() {
  check_prereqs
  create_directories

	# DL and source git auto-completion
	if [ ! -f $GIT_COMPLETE_PATH ]; then
    echo 'Downloading .git-completion.bash'
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $GIT_COMPLETE_PATH 
	fi
	if [[ ! -f $GIT_COMPLETE_PATH_ZSH && -n $ZSH_VERSION ]]; then
    echo 'Downloading .git-completion.zsh'
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o $GIT_COMPLETE_PATH_ZSH 
	fi
	if [ ! -f $GIT_PROMPT_PATH ]; then
    echo 'Downloading git-prompt.sh'
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o $GIT_PROMPT_PATH 
  fi
  if [ ! -d $ZSH_AUTOCOMPLETE_PATH ]; then
    echo 'Downloading zsh autocomplete plugin'
    git clone https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_AUTOCOMPLETE_PATH
	fi

  # Load git bash/zsh completion
  case $SHELL in
  */zsh)
     # assume Zsh
    zstyle ':completion:*:*:git:*' script $GIT_COMPLETE_PATH
    fpath=($MY_BIN_DIR $fpath)
    autoload -Uz compinit && compinit
     ;;
  */bash)
     # assume Bash
    source $GIT_COMPLETE_PATH
     ;;
  *)
     # assume something else
  esac

  # Compare dotfiles to see if any changes are made and replace them if there are changes
  create_replace_dotfile $NVIM_CONFIG_PATH $NVIM_CONFIG_ORIGIN_PATH
  create_replace_dotfile $TMUX_CONFIG_PATH $TMUX_CONFIG_ORIGIN_PATH
  create_replace_dotfile $GLOBAL_GITCONFIG_PATH $GLOBAL_GITCONFIG_ORIGIN_PATH

  # Source plugins
  source $GIT_PROMPT_PATH
  if [ -n "$ZSH_VERSION" ]; then
    # Source this to act as a sort of .bash_profile for zsh in this project
    source $ZSH_PROFILE_PROJECT_PATH
    source $ZSH_AUTOCOMPLETE_FILE
  fi

  # Export vars to be picked up in shell when this is sourced
  export MY_CONFIG_DIR=$MY_CONFIG_DIR
  export MY_BIN_DIR=$MY_BIN_DIR

  echo 'Initalized .myconifg'
}

create_directories() {
	create_directory $MY_CONFIG_DIR
	create_dir_status=$?
	if ! $(exit $create_dir_status); then
	   echo "Failed to create '$MY_CONFIG_DIR'"
		 exit $create_dir_status 
	fi
  
	create_directory $MY_BIN_DIR
	create_dir_status=$?
	if ! $(exit $create_dir_status); then
	   echo "Failed to create '$MY_BIN_DIR'"
		 exit $crate_dir_status 
	fi

	create_directory $NVIM_CONFIG_DIR
	create_dir_status=$?
	if ! $(exit $create_dir_status); then
	   echo "Failed to create '$NVIM_CONFIG_DIR'"
		 exit $crate_dir_status 
	fi
  
	create_directory $NVIM_CONFIG_DIR
	create_dir_status=$?
	if ! $(exit $create_dir_status); then
	   echo "Failed to create '$NVIM_CONFIG_DIR'"
		 exit $crate_dir_status 
	fi
  
  create_directory $MY_CONFIG_DIR/.vim_undo_history
	create_dir_status=$?
	if ! $(exit $create_dir_status); then
	   echo "Failed to create '$MY_CONFIG_DIR/.vim_undo_history'"
		 exit $crate_dir_status 
	fi

}

check_prereqs() {
  check_prereq "npm -v" "npm"
  # check_prereq "nvm --version" "nvm"
  check_prereq "git --version" "git"
  check_prereq "nvim -v" "nvim"
  # check_prereq "tmux -V" "tmux"
  # check_prereq "pip3 -V" "pip3"
}

check_prereq() {
  if [ $# -lt 2 ]; then
    echo 'Pre-req command and name arguments required'
    return $FALSE
  fi

  eval $1 2>&1 >/dev/null
  PRE_REQ_INSTALLED=$?
  if [ $PRE_REQ_INSTALLED -ne 0 ]; then
    echo "Missing prereq: $2. Please install $2 manually via package manager."
    exit 1
  fi
}

create_directory() {
	if [ $# -eq 0 ]; then
		echo "Directory argument required"
		return $FALSE
	fi
  
	if [ -d $1 ]; then
		return 0
  else
		mkdir -p $1
		echo "'$1' directory created"
		return 0
  fi
}

# $1 = destination of .dotfile (dir must already exist)
# $2 = origin path of .dotfile to copy over
create_replace_dotfile() {
  num_args=$#
	if [ $# -lt 2 ]; then
		echo "Dotfile destination and origin path arguments required"
		return $FALSE
	fi

  cmp --silent $2 $1
  cmpare_status=$?

  if [ ! -f $1 ]; then
    echo "Creating dotfile '$1'"
    if [ -n $MY_CONFIG_AUTO_OVERWRITE ]; then
      echo "Auto overwriting '$1' with changes."
      cp $2 $1 
    else
      cp -i $2 $1 
    fi
  # Dotfile exists, but changes have been made so it needs to be replaced
  elif [[ -f $1 && $cmpare_status -ne 0 ]]; then
    echo "Updates for '$1' detected"
    if [ -n $MY_CONFIG_AUTO_OVERWRITE ]; then
      echo "Auto overwriting '$1' with changes."
      cp $2 $1 
    else
      cp -i $2 $1 
    fi
  fi
}

# $1 = project path of dir to restore 
# $2 = local destination of dir
restore_directory() {
  num_args=$#
	if [ $# -lt 2 ]; then
		echo "Directory destination and origin path arguments required"
		return $FALSE
	fi

  if [ ! -d $1 ]; then
    echo "Restore for directory '$1' failed. Directory DNE"
    return $FALSE
  fi

  if [ ! -d $2 ]; then
    echo "Invalid local directory: '$2'"
    exit 1
  fi

  cp -r $1 $2
  echo "Retored up '$1' to '$2'"
}


main "$@";
