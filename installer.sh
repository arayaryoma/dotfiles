#!/bin/bash

DEV_ROOT=$HOME/dev


# Setup homebrew
if ! command -v brew 1>/dev/null 2>&1; then
  echo "brew is not installed"
  # /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
DEIN_DIR="$HOME/.cache/dein"

if [ -d "$DEIN_DIR" ]; then
    echo "dein.vim is already installed."
else
  echo "dein.vim is not installed."
  ## Install dein
  curl https://raw.githubusercontent.com/Shougo/dein-installer.vim/main/installer.sh > /tmp/installer.sh
  sh /tmp/installer.sh $DEIN_DIR
  vim +"call dein#install()" +qall   
fi



## Setup go
if ! command -v go 1>/dev/null 2>&1; then
  curl https://raw.githubusercontent.com/arayaryoma/golang-tools-install-script/master/goinstall.sh | bash -s -- --version 1.18.5
fi

## Setup recentdirs cache
mkdir -p $HOME/.cache/shell
touch $HOME/.cache/shell/chpwd-recentdirs

# Install Rust
if ! command -v rustup 1>/dev/null 2>&1; then
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
fi

# Install Rosetta
softwareupdate --install-rosetta --agree-to-license

# Setup Node.js
if ! command -v node 1>/dev/null 2>&1; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
fi

# Install Docker
if ! command -v docker 1>/dev/null 2>&1; then
  curl -O https://desktop.docker.com/mac/main/arm64/Docker.dmg --output-dir /tmp
  sudo hdiutil attach /tmp/Docker.dmg
  sudo /Volumes/Docker/Docker.app/Contents/MacOS/install
  sudo hdiutil detach /Volumes/Docker
fi
