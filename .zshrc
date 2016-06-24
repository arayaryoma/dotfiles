autoload -U compinit
compinit
export PATH=$HOME/.nodenv/shims:$HOME/.nodenv/versions/5.1.0/bin:/usr/local/var/pyenv/shims:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/usr/local/share/git-core/contrib/diff-highlight
export PYENV_ROOT="/usr/local/var/pyenv"
export PATH=$PYENV_ROOT/shims:$PATH
export GOPATH=$HOME/Workspace/go
export GOROOT="/usr/local/go"
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# match uppercase from lowercarse
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

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

## aliases for Docker
alias "docker-run"="/Applications/Docker/Docker\ Quickstart\ Terminal.app/Contents/Resources/Scripts/start.sh"

## aliases for editors
alias rubymine="open -a /Applications/RubyMine.app"


## aliases for shell
alias zshrc="vim ~/.zshrc"
alias reload="source ~/.zshrc"
alias ls="gls --color"
alias vimrc="vim ~/.vimrc"
alias t="tmux"
alias hs="python -m http.server"
alias l="ls"
alias ll="ls -l"
alias la="ls -a"

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
alias cdrl='cdr -l | peco' 

### ruby config
eval "$(rbenv init -)"
###
