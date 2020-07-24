autoload -Uz compinit compaudit
compinit -i
source ~/.http.zsh
source $HOME/.cargo/env
typeset -g ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE='20'

### environment variables
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
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export AWS_HOME=$HOME/.aws
export NODE_ENV=development

# Setup direnv
if type direnv > /dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export DYNAMODB_LOCAL_PATH=/Users/Rio/Workspace/dynamodb_local_2016-05-17
export NVM_DIR="$HOME/.nvm"
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS

# match uppercase from lowercarse
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

### Key bindings
bindkey '^e' forward-word
bindkey '^f' forward-word
bindkey '^w' backward-word
bindkey '^p' up-line-or-search
bindkey '^n' down-line-or-search
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

### Visual settings
if [ -f ~/.dircolors ]; then
  if type dircolors > /dev/null 2>&1; then
    eval $(dircolors ~/.dircolors)
  elif type gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ~/.dircolors)
  fi
fi
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# Setup rbenv
# # Setup direnv
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
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias vimrc="vim ~/.vimrc"
alias t="cd ~ && tmux"
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
alias "adb restart"="adb kill-server && adb start-server"
alias rn-debug-menu="adb shell input keyevent 82"
alias tcp-ports="lsof -iTCP -nP -sTCP:LISTEN"
alias y="yarn"
# required: https://www.npmjs.com/package/http-server
alias homura="hs --ssl --cert $DEV_ROOT/src/github.com/arayaryoma/certificates/homura.dev/live/homura.dev/cert.pem --key $DEV_ROOT/src/github.com/arayaryoma/certificates/homura.dev/live/homura.dev/privkey.pem"
if type twty > /dev/null; then
  alias t="twty"
fi
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
function lo {
    open "http://localhost:$1"
}
function base64 {
  openssl base64 -in $1 -out $2
}

function do_enter() {
  if [ -n "$BUFFER" ]; then
    zle accept-line
    return 0
  fi
  echo
  ls -a
  if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    echo
    echo -e "\e[0;33m--- git status ---\e[0m"
    git status
  fi
  zle reset-prompt
  return 0
}
zle -N do_enter

# match uppercase from lowercarse in completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Key bindings
bindkey '^e' forward-word
bindkey '^f' forward-word
bindkey '^w' backward-word
bindkey '^p' up-line-or-search
bindkey '^n' down-line-or-search
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^m' do_enter

# Visual settings
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS
if [ -f ~/.dircolors ]; then
  if type dircolors > /dev/null 2>&1; then
    eval $(dircolors ~/.dircolors)
  elif type gdircolors > /dev/null 2>&1; then
    eval $(gdircolors ~/.dircolors)
  fi
fi
if [ -n "$LS_COLORS" ]; then
  zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
fi

# show git branch
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats \
  '%F{white}[%F{2}%b%F{3}|%F{1}%a%F{white}]%f '
zstyle ':vcs_info:*' formats       \
  '%F{white}[%F{2}%b%F{white}]%f '
zstyle ':vcs_info:*' branchformat '%b%F{1}:%F{3}%r'
zstyle ':vcs_info:*' enable git

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "${vcs_info_msg_0_}"
  fi
}
PROMPT="%{${fg[blue]}%}%~%{${blue}%} 
%n"$'$(vcs_info_wrapper)'"$ "

# Enable cdr and add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr config
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

# peco config
if (( ${+commands[peco]} )); then
  peco-go-to-dir () {
    local line
    local selected="$(
      {
        (
          autoload -Uz chpwd_recent_filehandler
          chpwd_recent_filehandler && for line in $reply; do
            if [[ -d "$line" ]]; then
              echo "$line"
            fi
          done
        )
        ghq list --full-path
        for line in *(-/) ${^cdpath}/*(N-/); do echo "$line"; done | sort -u
      } | peco --query "$LBUFFER"
    )"
    if [ -n "$selected" ]; then
      BUFFER="cd ${(q)selected}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N peco-go-to-dir
  bindkey '^g' peco-go-to-dir
fi

# npm command completion script
# Installation: npm completion >> ~/.bashrc  (or ~/.zshrc)
# Or, maybe: npm completion > /usr/local/etc/bash_completion.d/npm
#
if type complete &>/dev/null; then
  _npm_completion () {
    local words cword
    if type _get_comp_words_by_ref &>/dev/null; then
      _get_comp_words_by_ref -n = -n @ -w words -i cword
    else
      cword="$COMP_CWORD"
      words=("${COMP_WORDS[@]}")
    fi

    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$cword" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${words[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -o default -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    local si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi

# Configure nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion 
###-end-npm-completion-###

fpath=(~/.zsh/completion $fpath)
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

if command -v direnv 1>/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

if command -v thefuck 1>/dev/null 2>&1; then
  eval $(thefuck --alias)
fi


### nvm config
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# zplug config
# export ZPLUG_HOME=/usr/local/opt/zplug
# source $ZPLUG_HOME/init.zsh
# 
# zplug load --verbose

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/araya/dev/src/github.com/HematiteCorp/sakigake-api/y/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/araya/dev/src/github.com/HematiteCorp/sakigake-api/y/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/araya/dev/src/github.com/HematiteCorp/sakigake-api/y/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/araya/dev/src/github.com/HematiteCorp/sakigake-api/y/google-cloud-sdk/completion.zsh.inc'; fi

source ~/.yarn-completion/yarn-completion.plugin.zsh
