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
- [npm](https://nodejs.org/en/download/)
  - Then run `npm install -g neovim`
  - `npm i -g bash-language-server`
  - `npm install -g spaceship-prompt`
- [nvm](https://github.com/nvm-sh/nvm)
  - Make sure to pipe to zsh shell, e.g. `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | zsh`
- [python2]
  - Then run `python2 -m pip install --user --upgrade pynvim`
- [python3]
  - Then run `python3 -m pip install --user --upgrade pynvim`
- [pip3]
  - Then run `pip3 install neovim-remote`

