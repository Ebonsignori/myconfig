# myconfig

The desired workflow of this project is to make changes to configurations in [dotfiles](./dotfiles) in this project and to copy and replace local configurations with the changes. This way this project serves as myconfig's source of truth. The expections to this are directories/files that are manually backed up. See [Manual Backup](#manual-backup/restore).

For automatic replacement after update, we need to export a variable pointing to where this repo is cloned to and run the [init.sh](./init.sh) script.

We do this by adding the following lines to the end of your `~/.zshrc` or `~/.bashrc` **after** installing the [Prereqs](#prereqs) below.

```
# Load myconfig profile *NOTE:* Place at bottom of .zshrc
export MY_CONFIG_PROJECT_DIR=~/Projects/myconfig
source $MY_CONFIG_PROJECT_DIR/init.sh
```

Optionally you can add the following to override config files without asking for confirmation

```
export MY_CONFIG_AUTO_OVERWRITE=true  
```

Initialization script that should be sourced within `~/.zshrc` e.g. `source ~/.myconfig/init/init.sh`

## Prereqs

- [git](https://git-scm.com/)
- [zsh shell](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  - Then run:
    - `cd /usr/local/share/zsh`
    - `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
  - Follow [this](https://github.com/athityakumar/colorls#installation) to install folder colors
     - Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
     - You may need to run `gem install colorls --user-install`
- [neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
- [nvm](https://github.com/nvm-sh/nvm)
  - Install [Ag](https://github.com/ggreer/the_silver_searcher)
  - Make sure to pipe to zsh shell, e.g. `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh`
  - `nvm install <node version>
- [npm](https://nodejs.org/en/download/) (should install when you install node via nvm)
  - Then run `npm install -g neovim`
  - `npm i -g bash-language-server`
  - `npm install -g spaceship-prompt`
- [python2](https://www.python.org/download/releases/2.0/)
  - Install [pip with python2](https://pip.pypa.io/en/stable/installing/)
  - Then run `python2 -m pip install --user --upgrade pynvim`
- [python3](https://www.python.org/downloads/)
  - Install [pip w python3](https://pip.pypa.io/en/stable/installing/)
  - Then run `python3 -m pip install --user --upgrade pynvim`
- [pip3](https://www.educative.io/edpresso/installing-pip3-in-ubuntu)
  - Then run `pip3 install neovim-remote`
- Install a [nerd-font](https://github.com/ryanoasis/nerd-fonts) font for your terminal. Follow instructions for Linux or Mac.
  - Try to install using a package manger (e.g. Brew)
  - I prefer [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation).  

## OS-Specific Steps

Copy SYNC files from Google Drive to OS.

### Mac OS

- In xTerminal, go to preferences -> keyboard and check `Use Option as Meta Key`

## Manual Backup / Restore

Run `sh backup.sh` to backup the following directories to this repo. They must manually be restored

- `./dotfiles/coc` to `~/.config/coc`. Only copy snippets folder and mru's. If copying entire folder will need to custom `npm i`. Installing via nvim `:PlugInstall` first and then copying over needed files is recommended

