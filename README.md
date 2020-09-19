# myconfig

This is my personal configuration to follow when setting up a new machine or server dev environment. If doing a non-gui env setup or setting up an existing desktop env with nvim, follow the instructions from [Terminal](#terminal) and ignore the [OS Steps](#os-steps) section. Otherwise start with [OS Steps](#os-steps) and then do the [Terminal](#terminal) set up.

## Terminal

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
  - NOTE: You may need to `reboot` system for ZSH shell default to update.
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

## OS Steps

- Install [Chrome](https://www.google.com/chrome/)
  - Set up Sync
  - Sign into LastPass
  - Sign into Raindrop.io
  - Set downloads path to `~/Downloads/Web`
- Copy SYNC files from Google Drive to OS.
- Install a [nerd-font](https://github.com/ryanoasis/nerd-fonts) font and set it for your terminal. Follow instructions for Linux or Mac. I prefer [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation). You can download the fonts directly from [here](https://www.nerdfonts.com/font-downloads).
- Download [Docker](https://docs.docker.com/engine/install/) and [Docker-compose](https://docs.docker.com/compose/install/)
- Install [Insomnia Core REST Client](https://insomnia.rest/)
- Install [DBeaver](https://dbeaver.io/)
- Install Break Reminder, [Stretchly](https://hovancik.net/stretchly/downloads/)
- Install Slack, Discord, and Spotify with package mangager or in app store.

### Mac OS

- In Preferences -> keyboard -> modifier keys -> Set Caps Lock to Ctrl
- In XTerm
  - Set up theme and set font to NerdFont
  - Go to preferences -> keyboard and check `Use Option as Meta Key`.
- Redeem [BetterSnapTool](https://folivora.ai/bettersnaptool) from App Store.
- Download a clipboard manager, like [CopyClip](https://fiplab.com/apps/copyclip-for-mac).

### Linux (Gnome)

- In Gnome Tweak tool set Caps Lock as Ctrl
- Install [Albert](https://albertlauncher.github.io/docs/installing/#using-official-albert-repositories) and enable plugins to replace spotlight. Bind it to `ctrl + space`
- Get and use [Mac OS themes](https://www.opendesktop.org/p/1220826/).
- Get and use [Mac OS icons](https://www.pling.com/p/1102582/).
- Install [deepin-screenshot](https://www.deepin.org/en/original/deepin-screenshot/) and [deeping-screen-recorder](https://www.deepin.org/en/original/deepin-screen-recorder/) and bind them to shift+ctrl+alt+4 and shift+ctrl+alt+5 respectively
- Download a clipboard manager, like [CopyQ](https://hluk.github.io/CopyQ/).
- Shortcut Ctrl+Alt+Delete to Activity Monitor
- Change Alt+Tab binding to Alt+Shift+Tab
- Terminal. If not default, I prefer [Gnome Terminal](https://help.gnome.org/users/gnome-terminal/stable/)
  - Set Nerdfont
  - Set new tab/close tab/change tab shortcuts to match Mac OS shortcuts

## Manual Backup / Restore

If on new setup, copy directories below per instructions, otherwise to backup directories run `sh backup.sh`.

- `./dotfiles/coc` to `~/.config/coc`. Only copy snippets folder and mru's. If copying entire folder will need to custom `npm i`. Installing coc via nvim `:PlugInstall` first and then copying over needed files is recommended.

