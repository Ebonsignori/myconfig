#!/bin/sh
# Config variables
MY_CONFIG_DIR=~/.myconfig
MY_BIN_DIR=$MY_CONFIG_DIR/bin
GIT_COMPLETE_PATH=$MY_BIN_DIR/.git-completion.bash
GIT_PROMPT_PATH=$MY_BIN_DIR/.git-prompt.sh
FALSE=225


# Entry Point
main() {
  check_prereqs
  create_directories

	# DL and set up git auto-completion
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
}

check_prereqs() {
	git --version 2>&1 >/dev/null
	GIT_IS_INSTALLED=$?

	if [ $GIT_IS_INSTALLED -ne 0 ]; then
		echo 'Missing prereq: Install git using package manager'
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

# Export vars to be picked up in shell when this is sourced
export MY_CONFIG_DIR=$MY_CONFIG_DIR
export MY_BIN_DIR=$MY_BIN_DIR

echo 'Initalized .myconifg'

main "$@";
