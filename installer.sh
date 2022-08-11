#!/bin/bash

DEV_ROOT=$HOME/dev
brew install \
	tmux \
	vim \
	yarn \
	peco \
	ghq \
	tig \
brew tap tkengo/highway && brew install highway
# Vim setup
## Install dein
curl https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh
sh /tmp/installer.sh ~/.cache/dein
vim +"call dein#install()" +qall

## Setup Node.js
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

## Setup go
curl https://raw.githubusercontent.com/arayaryoma/golang-tools-install-script/master/goinstall.sh | bash -s -- --version 1.18.5

## Setup recentdirs cache
mkdir -p $HOME/.cache/shell
touch $HOME/.cache/shell/chpwd-recentdirs
