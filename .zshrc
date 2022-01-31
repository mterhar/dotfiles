## GENERIC 
NEWLINE=$'\n'
export EDITOR=vim
export LANG=en_US.UTF-8
export LC_ALL=$LANG

[ -z "$SHELL" ] && export SHELL=/bin/zsh

autoload -Uz add-zsh-hook

setopt prompt_subst
autoload -Uz compinit
compinit

zstyle ':completion:*' menu select
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*'   force-list always

# Google cloud
[ -d ~/.homebrew/caskroom/google-cloud-sdk/latest/google-cloud-sdk ] && {
  . ~/.homebrew/caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc
  . ~/.homebrew/caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc
}

# ASCII safe typeset
typeset -A emoji
emoji[ok]=√
emoji[error]=Ø
emoji[git]=þ
emoji[git_changed]=╬
emoji[git_untracked]=╩
emoji[git_clean]=║
emoji[right_arrow]=»

# Unicode for real terminals
[ -z $CODER_ENVIRONMENT_NAME ] && {
  typeset -A emoji
  emoji[ok]=$'\U2705 '
  emoji[error]=$'\U274C '
  emoji[git]=$'\U1F500 '
  emoji[git_changed]=$'\U1F37A '
  emoji[git_untracked]=$'\U1F363 '
  emoji[git_clean]=$'\U2728 '
  emoji[right_arrow]=$'\U2794 '
}

## PROMPT

function _vcs_git_indicator () {
  typeset -A git_info
  local git_indicator git_status
  git_status=("${(f)$(git status --porcelain --branch 2> /dev/null)}")
  (( $? == 0 )) && {
    git_info[branch]="${${git_status[1]}#\#\# }"
    shift git_status
    git_info[changed]=${#git_status:#\?\?*}
    git_info[untracked]=$(( $#git_status - ${git_info[changed]} ))
    git_info[clean]=$(( $#git_status == 0 ))
    git_indicator="%{%F{blue}%}${git_info[branch]} %{%f%}"
    if (( ${git_info[clean]} )); then
      git_indicator+="${emoji[git_clean]} "
    else
      git_indicator+="${emoji[git_changed]} "
      (( ${git_info[untracked]} )) && git_indicator+="%{%F{red}%}${git_info[untracked]}*%{%f%}"
      (( ${git_info[changed]}   )) && git_indicator+="%{%F{yellow}%}${git_info[changed]}%{%f%}"
    fi
  }
  _vcs_git_indicator="$git_indicator"
}
whence git >/dev/null && add-zsh-hook precmd _vcs_git_indicator

# Kubernetes context indicator
function _kube_context_indicator () {
  # this will be set up in kubectl function (see below)
}
add-zsh-hook precmd _kube_context_indicator

function {
  local dir='%{%F{blue}%B%}%~%{%b%f%}'
  local now='%{%F{yellow}%}%*%{%f%}'
  local rc="%(?,${emoji[ok]},${emoji[error]} %{%F{red}%}%?%{%f%})"
  local user='%{%F{blue}%}%n%{%f%}'
  local host='%{%F{blue}%}%m%{%f%}'
  [ "$SSH_CLIENT" ] && local via="${${=SSH_CLIENT}[1]} %{%B%}${emoji[right_arrow]} %{%b%} "
  [ "$TERM_PROGRAM" ] && local terminal=$'\e]1;%1~\a'
  local mark=$'\n%# '
  local up=$'%{\e[A%}'
  local down=$'%{\e[B%}'
  PROMPT="$dir $user($via$host) $rc \$_vcs_git_indicator $terminal$mark"
  RPROMPT="$up \$_kube_context_indicator $down"
}

function _window_title_cmd () {
  local pwd="${PWD/~HOME/~}"
  print -n "\e]0;"
  print -n "${pwd##*/} (${HOST%%.*})"
  print -n "\a"
}

function _window_title_exec () {
  local pwd="${PWD/~HOME/~}"
  print -n "\e]0;"
  print -n "${1%% *} (${pwd##*/}) (${HOST%%.*})"
  print -n "\a"
}

[[ "$TERM" =~ "^xterm" ]] && {
  add-zsh-hook precmd _window_title_cmd
  add-zsh-hook preexec _window_title_exec
}


## ALIASES

if [ "$(uname -s)" = "Darwin" ]; then
    alias ls="ls -G"
    alias showdotfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidedotfiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
else
    alias ls="ls --color"
fi

if [ -n "$CODER_ASSETS_ROOT" ]; then
  alias code="$CODER_ASSETS_ROOT/code-server/bin/code-server"
fi

alias v="vim"

## HISTORY
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt inc_append_history # Append history as commands are executed
setopt hist_ignore_all_dups # Don't save duplicates
unsetopt share_history # Disable sharing history between terminals (sessions)

# Expansion and Globbing
setopt extended_glob # treat #, ~, and ^ as part of patterns for filename generation

## FANCY STUFF 

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

function demo_style () {
  PROMPT="%{%F{blue}%B%}${emoji[right_arrow]}%{%b%f%} "
  unset RPROMPT
  add-zsh-hook -d precmd _window_title_cmd
  add-zsh-hook -d preexec _window_title_exec
  print -n "\e]0;terminal\a"
}

# Lazy-load kubectl completion
function kubectl () {
  local real_kubectl="$(whence -p kubectl 2> /dev/null)"
  if [ "$real_kubectl" ]; then
    echo -n "\e[31m$0 completion zsh... \e[0m" > /dev/stderr
    source <("$real_kubectl" completion zsh)
    echo > /dev/stderr
  fi
  unfunction kubectl

  # Set up the context indicator
  function _kube_context_indicator () {
    local current_context="$(kubectl config current-context 2> /dev/null)"
    if [ "$current_context" ]; then
      _kube_context_indicator="${emoji[kube]} %{%F{blue}%}$current_context%{%f%}"
    else
      _kube_context_indicator=""
    fi
  }

  kubectl "$@"
}

# Random string generator
function random_alphanum () {
  local length="$1"
  local count="$2"
  LANG=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "${length:-16}" | head -n "${count:-3}"
}

function random_alphanumsym () {
  local length="$1"
  local count="$2"
  LANG=C tr -dc 'a-zA-Z0-9!#$%&()@/' < /dev/urandom | fold -w "${length:-16}" | head -n "${count:-3}"
}

[ -f ~/.zshrc.local ] && . ~/.zshrc.local

true
