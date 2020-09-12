#!/bin/sh

if [ -z "$MY_CONFIG_PROJECT_DIR" ]; then
  echo "Must have 'MY_CONFIG_PROJECT_DIR' set to myconfig project directory."
  exit 1
fi

# Config variables
MY_CONFIG_DIR=~/.myconfig
MY_BIN_DIR=$MY_CONFIG_DIR/bin
PROJECT_DOTFILE_CONFIG_DIR=$MY_CONFIG_PROJECT_DIR/dotfiles
# Backup directories
LOCAL_COC_CONFIG_DIR=~/.config/coc

# Script constants
FALSE=225


# Entry Point
main() {
  backup_directory $LOCAL_COC_CONFIG_DIR $PROJECT_DOTFILE_CONFIG_DIR 
}


# $1 = origin path of dir to backup 
# $2 = project destination of dir
backup_directory() {
  num_args=$#
	if [ $# -lt 2 ]; then
		echo "Dotfile destination and origin path arguments required"
		return $FALSE
	fi

  if [ ! -d $1 ]; then
    echo "Backup for directory '$1' failed. Directory DNE"
    return $FALSE
  fi

  if [ ! -d $2 ]; then
    echo "Invalid project directory: '$2'"
    exit 1
  fi

  cp -r $1 $2
  echo "Backed up '$1' to '$2'"
}

# $1 = origin path of .dotfile to backup 
# $2 = project destination of .dotfile (dir must already exist)
backup_dotfile() {
  num_args=$#
	if [ $# -lt 2 ]; then
		echo "Dotfile destination and origin path arguments required"
		return $FALSE
	fi

  cmp --silent $1 $2
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

main "$@";
echo "Backup complete. Remember to commit and push backup." 
