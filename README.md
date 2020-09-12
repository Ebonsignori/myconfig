# myconfig

Initialization script that should be sourced within .bashrc / .bash_profile, e.g. `source ~/.myconfig/init/init.sh`

## Prereqs

- [git](https://git-scm.com/)
- [ohmyzsh](https://github.com/ohmyzsh/ohmyzsh)
  - Then run:
    - `cd /usr/local/share/zsh`
    - `git clone https://github.com/zsh-users/zsh-syntax-highlighting.git`
    - `echo "source ${(q-)PWD}/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${ZDOTDIR:-$HOME}/.zshrc`
    - Follow [this](https://github.com/athityakumar/colorls#installation) to install folder colors
       - You may need to run `gem install colorls --user-install`
- [npm](https://nodejs.org/en/download/)
  - Then run `npm install -g neovim`
  - `npm i -g bash-language-server`
  - `npm install -g spaceship-prompt`
- [nvm](https://github.com/nvm-sh/nvm)
  - Make sure to pipe to zsh shell, e.g. `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh`
- [python2](https://www.python.org/download/releases/2.0/)
  - Then run `python2 -m pip install --user --upgrade pynvim`
- [python3](https://www.python.org/downloads/)
  - Then run `python3 -m pip install --user --upgrade pynvim`
- pip3 (should come with python3)
  - Then run `pip3 install neovim-remote`
- Install powerline font for your terminal. Follow instructions for Linux or Mac.
  - For Mac default term install [this](https://github.com/powerline/fonts/archive/master.zip) and run `install.sh`  
