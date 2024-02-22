# myconfig

This is my personal configuration to follow when setting up a new machine or server dev environment. If doing a non-gui env setup or setting up an existing desktop env with nvim, follow the instructions from [Terminal](#terminal) and ignore the [OS Steps](#os-steps) section. Otherwise start with [OS Steps](#os-steps) and then do the [Terminal](#terminal) set up.

## Terminal

Clone this repo into `~/Projects`

The desired workflow of this project is to make changes to configurations in [dotfiles](./dotfiles) in this project and to copy and replace local configurations with the changes. This way this project serves as myconfig's source of truth. The expections to this are directories/files that are manually backed up. See [Manual Backup](#manual-backup/restore).

For automatic replacement after update, we need to export a variable pointing to where this repo is cloned to and run the [init.sh](./init.sh) script.

We do this by adding the following lines to the end of your `~/.zshrc` or `~/.bashrc` **after** installing the [Prereqs](#prereqs) below.

```
# Load myconfig profile *NOTE:* Place at bottom of .zshrc
export MY_CONFIG_PROJECT_DIR=~/Projects/myconfig
export MY_CONFIG_AUTO_OVERWRITE=true 
source $MY_CONFIG_PROJECT_DIR/init.sh
```

Optionally you can require confirmation prompts when overriding config files:

```
export MY_CONFIG_AUTO_OVERWRITE=false  
```

## Prereqs

- [git](https://git-scm.com/)
- [zsh shell](https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH)
  - NOTE: You may need to `reboot` system for ZSH shell default to update.
  - Then run:
    - `cd ~/Projects/myconfig`
    - `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
    - or on Mac, `brew install zsh-syntax-highlighting`
  - Follow [this](https://github.com/athityakumar/colorls#installation) to install folder colors
     - Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
     - You may need to run `sudo apt-get install ruby-dev` and `sudo apt-get install ubuntu-dev-tools` on Ubuntu
     - You may need to run `gem install colorls --user-install`
     - You may need to add the following to your `~/.zshrc`
     ```
     path+=(
        $(ruby -e 'puts File.join(Gem.user_dir, "bin")')
     )
     export PATH="$HOME/.rbenv/bin:$PATH"
     eval "$(rbenv init -)"
     ```
- [neovim](https://formulae.brew.sh/formula/neovim)
  - Install [Ag](https://github.com/ggreer/the_silver_searcher)
- [asdf](https://asdf-vm.com/guide/getting-started.html)
  - `brew install asdf`
  - Add to zshrc, `echo -e "\n. $(brew --prefix asdf)/libexec/asdf.sh" >> ${ZDOTDIR:-~}/.zshrc`
  - Install nodejs plugin:
  - 1. `asdf plugin add nodejs`
  - 2. `asdf install nodejs latest`
  - 3. `asdf asdf global nodejs latest`
  - 4. Repeat steps 1-3 for `golang` and any other needed languages
- [npm](https://nodejs.org/en/download/) (should install when you install node via nvm)
  - Then run `npm install -g neovim`
  - `npm i -g bash-language-server`
- [python2](https://www.python.org/download/releases/2.0/)
- [python3](https://www.python.org/downloads/)
- [pip3](https://www.educative.io/edpresso/installing-pip3-in-ubuntu)
- [jq](https://stedolan.github.io/jq/)

## OS Steps

- Install [Chrome](https://www.google.com/chrome/)
  - Set up Sync
  - Sign into PW Manager
  - Set downloads path to `~/Downloads/Web`
- Install a [nerd-font](https://github.com/ryanoasis/nerd-fonts) font and set it for your terminal. Follow instructions for Linux or Mac. I prefer [Hack](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack#quick-installation). You can download the fonts directly from [here](https://www.nerdfonts.com/font-downloads).
- Install VSCode: `brew install --cask visual-studio-code`
- Download [Docker](https://docs.docker.com/engine/install/) and [Docker-compose](https://docs.docker.com/compose/install/). (Can use Docker Desktop to get both on Mac)
- Install Break Reminder, [Stretchly](https://hovancik.net/stretchly/downloads/)
- Install Slack and Spotify
- Install offline / no-sync [Atuin](https://github.com/ellie/atuin#offline-only-no-sync)

### Mac OS

- In Preferences -> keyboard -> modifier keys -> Set Caps Lock to Ctrl
- In Preferences -> Mouse -> Toggle "Natural" 🤮 scroll
- In Preferences -> mission control -> uncheck "Automatically rearrange Spaces based on most recent use"
- Install [Brew](https://brew.sh/)
- Install Hack font `brew tap homebrew/cask-fonts`, `brew install --cask font-hack-nerd-font`
- Install ruby, `brew install ruby` and colorls, `gem install colorls --user-install`. May need to [add gem path to .zshrc](https://stackoverflow.com/questions/53979362/you-dont-have-path-in-your-path-gem-executables-will-not-run-while-using)
- Install iTerm2 
  - Set theme to the [custom__light_theme](./mac_os/custom_light_theme.json) and set font to [hack](https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip)
  - Go to preferences -> keyboard and check `Use Option as Meta Key`.
- Download [Spaceship prompt](https://formulae.brew.sh/formula/spaceship)
- Download [CopyQ](https://formulae.brew.sh/cask/copyq)
- Change finder preference and turn on view -> bars 
- Install [Amethyst](https://ianyh.com/amethyst/): `brew install --cask amethyst`
  - TODO: Check if `.amethyst` dotfile support has improved. If it has, move instructions to dotfile
  - Turn on "Mouse follows focused windows" option 
  - Set layouts in this order: `Column`, `3Column Middle`, `Fullscreen`, `Tall`
  - Shortcut <leader-ctrl>a,s,d,f to set layout in order respective to above order
  - Shortcut <leader>q-r to jump to screen
  - Shortcut <leader-ctrl>q-r to throw window to screen
  - Shortcut <leader>enter to switch main window
  - Shortcut <leader>j,k to switch focused window
  - Shortcut <leader>h,l to resize focused window
  - Shortcut <leader>t to toggle tiling on focused window (+ full screen layout to easily full-screen window)
  - Shortcut <leader-ctrl>z Relaunch Amethyst (fix layouts)

### Linux (Gnome)

- Install Gnome Tweak Tool, `sudo apt install gnome-tweak-tool`
- In Gnome Tweak tool set Caps Lock as Ctrl
- Install [Albert](https://albertlauncher.github.io/docs/installing/#using-official-albert-repositories) and enable plugins to replace spotlight. Bind it to `Ctrl + Space`
- Install [deepin-screenshot](https://www.deepin.org/en/original/deepin-screenshot/) and [deeping-screen-recorder](https://www.deepin.org/en/original/deepin-screen-recorder/) and bind them to `shift+ctrl+4` and `shift+ctrl+5` respectively
- Shortcut `Ctrl + Alt + Delete` to Activity Monitor
- Change `Alt+Tab` binding to `Alt + Shift + Tab`
- Change terminal binding to `Ctrl + Shift + Alt + T`
- Add shortcut to start File browser (`nautilus` in Ubuntu): `Ctrl + Shift + Alt + F`
- Download a clipboard manager, like [CopyQ](https://hluk.github.io/CopyQ/).
- Terminal. If not default, I prefer [Gnome Terminal](https://help.gnome.org/users/gnome-terminal/stable/)
  - Set Nerdfont
  - Set new tab/close tab/change tab shortcuts to match Mac OS shortcuts
- `sudo apt-get install gnome-sushi` to get Mac-OS like preview
- Set up Mac OS-Like Theme
  - Get and use [Mac OS themes](https://www.opendesktop.org/p/1220826/).
  - Set them in Gnome tool then move close btns to the LHS with: `gsettings set org.gnome.desktop.wm.preferences button-layout "close,minimize,maximize:"`
  - Get and use [Mac OS icons](https://www.pling.com/p/1102582/).
  - Install and use [Dash To Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/) (Dash to Doc is more mac like but at time of writing doesn't enable hover previews)
    - Enable persistent top-bar, opacity, auto-hide, and change non-active window indicators. 
  - Install and use [BLYR](https://extensions.gnome.org/extension/1251/blyr/)
  - Use Mac San Francisco [Fonts](https://www.gnome-look.org/p/1213208/)
- Add CopyQ, Albert, and Stretchly to Startup Applications via Gnome Tweak Tool
  
## System

For any hardware setup steps

### Keyboard

[Online Ergodox Layout](https://configure.zsa.io/ergodox-ez/layouts/VYRM4/latest/0)

[Archived Layout if zsa goes offline](./system/ergodox_layout.hex)


## Manual Backup / Restore

If on new setup, copy directories below per instructions, otherwise to backup directories run `sh backup.sh`.

- `./dotfiles/coc` to `~/.config/coc`. Only copy snippets folder and mru's. If copying entire folder will need to custom `npm i`. Installing coc via nvim `:PlugInstall` first and then copying over needed files is recommended.

