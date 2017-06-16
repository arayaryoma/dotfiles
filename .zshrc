autoload -U compinit
compinit
export PATH=$HOME/.nodenv/shims:$HOME/.nodenv/versions:/usr/local/var/pyenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/share/git-core/contrib/diff-highlight:/sbin
export PYENV_ROOT="/usr/local/var/pyenv"
export PATH=$PYENV_ROOT/shims:$PATH
export GOPATH=$HOME/Workspace/go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export PATH=/usr/local/opt/libressl/bin:$PATH
export PATH=/usr/local/opt/curl/bin:$PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export EDITOR=vim
export AWS_HOME=$HOME/.aws
export DYNAMODB_LOCAL_PATH=/Users/Rio/Workspace/dynamodb_local_2016-05-17
eval "$(direnv hook zsh)"

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
###

### aliases

# aliases for Docker
alias "docker-run"="/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh"
alias dps="docker ps"
alias drm="docker rm"
alias drmi="docker rmi"
alias dkill="docker kill"
alias drm-all-processes="docker ps -q | xargs docker kill && docker ps -a -q | xargs docker rm"
alias drmi-upgraded-images='docker rmi $(docker images --all | grep "^<none>" | awk "{print $3}")'

## aliases for editors
alias rubymine="open -a /Applications/RubyMine.app"
alias webstorm="open -a /Applications/WebStorm.app"

## aliases for shell
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias ls="gls --color"
alias vimrc="vim ~/.vimrc"
alias tx="cd ~ && tmux"
alias hs="python -m http.server"
alias l="ls -al"
alias ll="ls -l"
alias la="ls -a"
alias m="make"
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

## Run `ls` and `git status` when user input only <ENTER>
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
bindkey '^m' do_enter

## aliases for launching apps
alias rubymine="open -a Rubymine.app"
alias ws="open -a WebStorm.app"
alias note="open -a Boostnote.app"
alias vs="open -a Visual\ Studio\ Code.app"
## aliases for git
alias gad="git add"
alias gco="git commit --verbose"
alias gst="git status -sb"
alias gdif="git diff"
alias gch="git checkout"
alias gpsh="git push"
alias gash="git stash"
alias gme="git merge"
alias gbr="git branch"
alias grh="git reset HEAD"
alias glog="git log --oneline --graph --decorate --all"
alias amend="gco --amend"

###

### tmux config
# auto launch tmux when launching shell
#if [ -z "$PS1" ]; then return ; fi

#if [ -z $TMUX ] ; then
#        if [ -z `tmux ls` ] ; then
#                tmux
#        else
#                tmux attach
#        fi
#fi
###


# Enable cdr and add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs

# cdr config
zstyle ':completion:*' recent-dirs-insert both
zstyle ':chpwd:*' recent-dirs-max 500
zstyle ':chpwd:*' recent-dirs-default true
zstyle ':chpwd:*' recent-dirs-file "$HOME/.cache/shell/chpwd-recent-dirs"
zstyle ':chpwd:*' recent-dirs-pushd true

### ruby config
eval "$(rbenv init -)"

### node config
eval "$(nodenv init -)"

### peco config
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
###-begin-npm-completion-###
#
# npm command completion script
#
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
###-end-npm-completion-###


export PATH="$HOME/.yarn/bin:$PATH"

