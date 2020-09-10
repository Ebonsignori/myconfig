#!/bin/sh
# Config variables
MY_CONFIG_DIR=~/.myconfig
MY_BIN_DIR=$MY_CONFIG_DIR/bin
NVIM_CONFIG_DIR=~/.config/nvim

GIT_COMPLETE_PATH=$MY_BIN_DIR/.git-completion.bash
GIT_PROMPT_PATH=$MY_BIN_DIR/.git-prompt.sh
NVIM_CONFIG_ORIGIN_PATH=./dotfiles/init.vim
NVIM_CONFIG_PATH=~/.config/nvim/init.vim
TMUX_CONFIG_ORIGIN_PATH=./dotfiles/.tmux.conf
TMUX_CONFIG_PATH=~/.tmux.conf
FALSE=225


# Entry Point
main() {
  check_prereqs
  create_directories

	# DL and source git auto-completion
	if [ ! -f $GIT_COMPLETE_PATH ]; then
    echo 'Downloading .git-completion.bash'
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $MY_BIN_DIR/.git-completion.bash
	fi

	if [ ! -f $GIT_PROMPT_PATH ]; then
    echo 'Downloading git-prompt.sh'
		curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o $MY_BIN_DIR/.git-prompt.sh
	fi

	source $MY_BIN_DIR/.git-completion.bash
	source $MY_BIN_DIR/.git-prompt.sh

  # Compare dotfiles to see if any changes are made and replace them if there are changes
  create_replace_dotfile $NVIM_CONFIG_PATH $NVIM_CONFIG_ORIGIN_PATH
  create_replace_dotfile $TMUX_CONFIG_PATH $TMUX_CONFIG_ORIGIN_PATH
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
}

check_prereqs() {
	git --version 2>&1 >/dev/null
	GIT_IS_INSTALLED=$?

	if [ $GIT_IS_INSTALLED -ne 0 ]; then
		echo 'Missing prereq: Install git using package manager'
		exit 1
	fi

  nvim -v 2>&1 >/dev/null
  NVIM_IS_INSTALLED=$?

	if [ $NVIM_IS_INSTALLED -ne 0 ]; then
		echo 'Missing prereq: Install nvim using package manager'
		exit 1
	fi

  tmux -V 2>&1 >/dev/null
  TMUX_IS_INSTALLED=$?

	if [ $TMUX_IS_INSTALLED -ne 0 ]; then
		echo 'Missing prereq: Install tmux using package manager'
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
    cp -i $2 $1 
  # Dotfile exists, but changes have been made so it needs to be replaced
  elif [[ -f $1 && $cmpare_status -ne 0 ]]; then
    echo "Updates for '$1' detected"
    cp -i $2 $1
  fi
}

# Export vars to be picked up in shell when this is sourced
export MY_CONFIG_DIR=$MY_CONFIG_DIR
export MY_BIN_DIR=$MY_BIN_DIR

echo 'Initalized .myconifg'

main "$@";
