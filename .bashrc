source $HOME/.http.sh
source $HOME/.cargo/env

# environment variables
export GOROOT=$HOME/.go
export GOPATH=$HOME/dev
export DEV_ROOT=$HOME/dev
export PYENV_ROOT="$HOME/.pyenv"
export PATH=/bin:$PATH
export PATH=/sbin:$PATH
export PATH=/usr/bin:$PATH
export PATH=/usr/sbin:$PATH
export PATH=/usr/local/bin:$PATH
export PATH=/usr/local/sbin:$PATH
export PATH=/usr/local/var/pyenv/shims:$PATH
export PATH=/usr/local/share/git-core/contrib/diff-highlight:$PATH
export PATH=$PYENV_ROOT/bin:$PATH
export PATH=$PYENV_ROOT/shims:$PATH
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export PATH=/usr/local/opt/libressl/bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export PATH=/usr/local/GoLand/bin:$PATH
export PATH=/usr/local/WebStorm/bin:$PATH
export PATH=/usr/local/PhpStorm/bin:$PATH
export PATH=/usr/local/idea/bin:$PATH
export PATH=/usr/local/google-cloud-sdk/bin:$PATH
export PATH=/usr/local/go_appengine:$PATH
export PATH=/usr/local/rbenv/bin:$PATH
export PATH=/usr/local/java/jdk-9.0.1/bin:$PATH
export PATH=/usr/local/Postman:$PATH
export PATH=$HOME/.npm-global/bin:$PATH
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="$HOME/Library/Android/sdk/platform-tools:$PATH"
export PATH=$DEV_ROOT/src/github.com/flutter/flutter/bin:$PATH
export PATH=$HOME/.config/yarn/global/node_modules/.bin:$PATH
export PATH=$HOME/.deno/bin:$PATH 
export LANG=en_US.UTF-8
export EDITOR=vim
export AWS_HOME=$HOME/.aws
export NODE_ENV=development
export NVM_DIR="$HOME/.nvm"
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export PS1="\w\n\u\[\e[32m\]\`parse_git_branch\`\[\e[m\]$ "

# Setup direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook bash)"
fi

# Setup rbenv
if type rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# aliases
alias "docker-run"="/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dkill="docker kill"
alias dc="docker-compose"
alias drm-all-processes="docker ps -aq | xargs docker kill && docker ps -a -q | xargs docker rm"
alias drmi-upgraded-images='docker rmi $(docker images --all | grep "^<none>" | awk "{print $3}")'
alias bashrc="vim ~/.bashrc"
alias reload="source ~/.bashrc"
alias vimrc="vim ~/.vimrc"
alias tx="cd ~ && tmux"
alias ls="ls -G"
alias l="ls -al"
alias ll="ls -l"
alias la="ls -a"
alias m="make"
alias clean="rm -rf ./*"
alias g="git"
alias gad="git add"
alias gco="git commit --verbose"
alias gst="git status -sb"
alias gdif="git diff"
alias gch="git checkout"
alias gcl="git clone"
alias gpsh="git push"
alias gash="git stash"
alias gme="git merge"
alias gbr="git branch"
alias grh="git reset HEAD"
alias glog="git log --oneline --graph --decorate --all"
alias gsw="git switch"
alias amend="gco --amend"
alias switch="gbr -a | peco | xargs git switch"
alias webstorm="webstorm $(pwd)"
alias androidstudio="LD_PRELOAD='/usr/lib64/libstdc++.so.6 ' /usr/local/android-studio/bin/studio"
alias adb-restart="adb kill-server && adb start-server"
alias rn-debug-menu="adb shell input keyevent 82"
alias tcp-ports="lsof -iTCP -nP -sTCP:LISTEN"
alias y="yarn"
# required: https://www.npmjs.com/package/http-server
alias homura="hs --ssl --cert $DEV_ROOT/src/github.com/arayaryoma/certificates/homura.dev/live/homura.dev/cert.pem --key $DEV_ROOT/src/github.com/arayaryoma/certificates/homura.dev/live/homura.dev/privkey.pem"

function gi() {
  curl -slw "\n" https://www.toptal.com/developers/gitignore/api/$@ ;
}
function dynamolocal {
	java -Djava.library.path=$DYNAMODB_LOCAL_PATH -jar $DYNAMODB_LOCAL_PATH/DynamoDBLocal.jar -port 3003
}
function asp {
  export AWS_DEFAULT_PROFILE=$1
  export AWS_PROFILE=$1
  echo "AWS_DEFAULT_PROFILE=$AWS_DEFAULT_PROFILE"
  echo "AWS_PROFILE=$AWS_PROFILE"
}
function base64 {
  openssl base64 -in $1 -out $2
}

function do_enter() {
  ls -a
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    echo
    git status
  fi
  return 0
}

 bind -x '"\C-k":"do_enter"'

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	ahead=`echo -n "${status}" 2> /dev/null | grep "Your branch is ahead of" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

if [ -n "`which peco 2> /dev/null`" ]; then

    # unshift the 1st argument string into output
    function peco-unshift() {
        echo "$1"
        while read x; do
            echo $x
        done
    }

    # pd (peco-change-directory)
    # Usage:
    #     - Select ${CD_LINE} to change directory
    #     - Select ${CANCEL_LINE} to cancel
    function pd() {
        local DIR_TMP=""
        local DIR_PATH="$1"
        local CD_LINE="Change-Directory"
        local CANCEL_LINE="Cancel"
        DIR_TMP=$(\ls -1aF ${DIR_PATH} | sed -e "s/@$/\//" | grep / | peco)
        DIR_PATH="${DIR_PATH}${DIR_TMP}"
        cd $DIR_PATH
    }

    # process kill
    function peco-kill() {
        for pid in `ps aux | peco | awk '{print $2}'`
        do
            kill $pid
            echo "Killed ${pid}"
        done
    }

    # select command from history
    function peco-select-history() {
        local tac="tail -r"
        if [ -n "`which tac 2> /dev/null`" ]; then
            tac="tac"
        elif [ -n "`which gtac 2> /dev/null`" ]; then
            tac="gtac"
        fi
        $(history | ${tac} | peco | awk '{for(i=8;i<NF;i++)printf("%s ",$i);print $NF}')
    }
    bind -x '"\C-g":"pd"'
fi
