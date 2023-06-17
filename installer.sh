#!/bin/bash

DEV_ROOT=$HOME/dev


# Setup homebrew
if ! command -v brew 1>/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# Install packages with brew
brew install \
  	tmux \
  	vim \
  	yarn \
  	peco \
  	ghq \
	git \
  	tig

brew tap tkengo/highway && brew install highway

# Setup Vim with plugins
## Install dein
curl https://raw.githubusercontent.com/Shougo/dein-installer.vim/main/installer.sh > /tmp/installer.sh
sh /tmp/installer.sh ~/.cache/dein
vim +"call dein#install()" +qall

## Setup Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

## Setup go
curl https://raw.githubusercontent.com/arayaryoma/golang-tools-install-script/master/goinstall.sh | bash -s -- --version 1.18.5

## Setup recentdirs cache
mkdir -p $HOME/.cache/shell
touch $HOME/.cache/shell/chpwd-recentdirs

# Install Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Rosetta
softwareupdate --install-rosetta

# Setup Node.js
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
