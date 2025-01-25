# Example .zshrc file for zsh 4.0
#
# .zshrc is sourced in interactive shells.  It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#

# THIS FILE IS NOT INTENDED TO BE USED AS /etc/zshrc, NOR WITHOUT EDITING
#return 0	# Remove this line after editing this file as appropriate

# -------------------------------------------------------------------------------------------------------
# Search path for the cd command
cdpath=(.. ~ ~/src ~/zsh)

# -------------------------------------------------------------------------------------------------------
# Use hard limits, except for a smaller stack and no core dumps
unlimit
limit stack 8192
limit core 0
limit -s

umask 022

# -------------------------------------------------------------------------------------------------------
# Set up aliases
alias mv='nocorrect mv'       # no spelling correction on mv
alias cp='nocorrect cp'       # no spelling correction on cp
alias mkdir='nocorrect mkdir' # no spelling correction on mkdir
#alias j=jobs
#alias pu=pushd
#alias po=popd
#alias d='dirs -v'
#alias h=history
#alias grep=egrep
#alias ll='ls -alF'
#alias la='ls -A'
#alias rmi='rm -i'
#alias rmI='rm -I'
alias mv='mv -i'
alias cp='cp -i'

#alias ...='cd ../..'
#alias ....='cd ../../..'

# source environmental-dependent aliases
if [ -f ~/.zsh_aliases ]; then
    . ~/.zsh_aliases
fi

# -------------------------------------------------------------------------------------------------------
# iab
setopt extended_glob

typeset -A abbreviations
abbreviations=(
    '...'   '../..'
    '....'  '../../..'
    "d"     "dirs -v"
    "G"     "| grep"
    "H"     "| head"
    "Hl"    " --help |& less -r"
    "j"     "jobs"
    "ll"    "ls -alF"
    "la"    "ls -A"
    "rmi"   "rm -i"
    "rmI"   "rm -I"
    "L"     "| less"
    "pu"    "pushd"
    "po"    "popd"
    "S"     "| sort -u"
    "T"     "| tail"
    "V"     "| ${VISUAL:-${EDITOR}}"
    "W"     "| wc"
    "X"     "| xargs"
)

magic-abbrev-expand() {
    local MATCH
    LBUFFER=${LBUFFER%%(#m)[.\-+:|_a-zA-Z0-9]#}
    LBUFFER+=${abbreviations[$MATCH]:-$MATCH}
    zle self-insert
}

no-magic-abbrev-expand() {
  LBUFFER+=' '
}

zle -N magic-abbrev-expand
zle -N no-magic-abbrev-expand
bindkey " " magic-abbrev-expand
bindkey "^x " no-magic-abbrev-expand

# -------------------------------------------------------------------------------------------------------
# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias diff='diff --color=always'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# -------------------------------------------------------------------------------------------------------
# List only directories and symbolic links that point to directories
alias lsd='ls -ld *(-/DN)'

# List only file beginning with "."
alias lsa='ls -ld .*'

# Global aliases -- These do not have to be
# at the beginning of the command line.
alias -g M='|more'
alias -g H='|head'
alias -g T='|tail'

# -------------------------------------------------------------------------------------------------------
# Shell functions
setenv() { typeset -x "${1}${1:+=}${(@)argv[2,$#]}" }  # csh compatibility
freload() { while (( $# )); do; unfunction $1; autoload -U $1; shift; done }

# -------------------------------------------------------------------------------------------------------
# Where to look for autoloaded function definitions
fpath=($fpath ~/.zfunc)

# Autoload all shell functions from all directories in $fpath (following
# symlinks) that have the executable bit on (the executable bit is not
# necessary, but gives you an easy way to stop the autoloading of a
# particular shell function). $fpath should not be empty for this to work.
for func in $^fpath/*(N-.x:t); autoload $func

# -------------------------------------------------------------------------------------------------------
# automatically remove duplicates from these arrays
typeset -U path cdpath fpath manpath

# -------------------------------------------------------------------------------------------------------
# Set prompts
#PROMPT='%m%# '    # default prompt

# git-completion & git-prompt
# for prompt # https://qiita.com/ryoichiro009/items/7957df2b48a9ea6803e0
if [ -f ~/.git-prompt.sh ]; then
    source ~/.git-prompt.sh
else
    which wget && wget https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -O ~/.git-prompt.sh
fi

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUPSTREAM=auto
GIT_PROMPT_ONLY_IN_REPO=1
GIT_PROMPT_IGNORE_SUBMODULES=1
GIT_PROMPT_SHOW_UNTRACKED_FILES=no
GIT_PROMPT_FETCH_REMOTE_STATUS=0

function prompt {
    brace_s='%{'
    brace_e='%}'
    
    fg_green='\e[32m'
    fg_reset="%F{default}"
    fg_lightblue='\e[38;5;12m'
    #fg_purple="\x1b[38;2;108;113;196m"
    fg_base1="%F{#93a1a1}"

    if [ ! $TMUX ]; then
        usr_host="${brace_s}${fg_green}${brace_e}%n@%M"
        #colon="${brace_s}${fg_reset}${brace_e}:"
        #cwd="${brace_s}${fg_lightblue}${brace_e}%~"
        doller="${fg_reset}%# "
    else
        doller="${fg_base1}%# ${fg_reset}"
    fi

    prompt="${usr_host}${doller}"
    echo "${prompt}"
}

function git-prompt {
    echo "${fg_yellow}"'$(__git_ps1)%F{default} '
}

if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    fg_yellow="%F{#b58900}"
    fg_base1="%F{#93a1a1}"
fi

PROMPT=`prompt`

RPROMPT=' %~'     # prompt for right side of screen
command -v __git_ps1 > /dev/null 2>&1 && RPROMPT=$RPROMPT"`git-prompt`"

# -------------------------------------------------------------------------------------------------------
# Some environment variables

#export MAIL=/var/spool/mail/$USERNAME
#export LESS=-cex3M
#export HELPDIR=/usr/share/zsh/$ZSH_VERSION/help  # directory for run-help function to find docs
# unalias run-help && autoload -Uz run-help

#MAILCHECK=300
#HISTSIZE=200
#DIRSTACKSIZE=20

# proxy
PROXY="$HOME/.zsh_proxy"
[ -f $PROXY ] && source $PROXY

export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Use ~~ as the trigger sequence instead of the default **
#export FZF_COMPLETION_TRIGGER='~~'

# Kubernetes
export KUBECONFIG=$KUBECONFIG:$HOME/.kube/config:$HOME/.kube/config_ike

#export EDITOR="nvim"

export NVM_DIR="$HOME/.nvm"

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

export DENO_INSTALL="$HOME/.deno"
path+=("$DENO_INSTALL/bin")
export PATH
export NEXTWORD_DATA_PATH="/usr/share/nextword-data-small/"
export TZ='Asia/Tokyo'

# -------------------------------------------------------------------------------------------------------
# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=1000000
setopt append_history
setopt inc_append_history

# Watch for my friends
#watch=( $(<~/.friends) )       # watch for people in .friends file
#watch=(notme)                   # watch for everybody but me
#LOGCHECK=300                    # check every 5 min for login/logout activity
#WATCHFMT='%n %a %l from %m at %t.'

# Set/unset  shell options
setopt   notify globdots correct pushdtohome cdablevars autolist
setopt   autocd recexact
setopt   autoresume histignoredups pushdsilent
setopt   autopushd pushdminus rcquotes
unsetopt autoparamslash
setopt PROMPT_SUBST
setopt transient_rprompt
setopt extended_history
setopt hist_no_store         # do not save a record of history command itself
setopt hist_reduce_blanks    # trail extra spaces when recording history

# -------------------------------------------------------------------------------------------------------
# keybindings
bindkey -e                 # emacs key bindings
#bindkey ' ' magic-space    # also do history expansion on space
bindkey '^I' complete-word # complete on tab, leave expansion to _expand

# -------------------------------------------------------------------------------------------------------
# Completion Styles

# Setup new style completion system. To see examples of the old style (compctl
# based) programmable completion, check Misc/compctl-examples in the zsh
# distribution.
autoload -U compinit
compinit

# list of completers to use
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
    
# insert all expansions for expand completer
zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

# fzf
# Set up fzf key bindings and fuzzy completion
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# kubectl completion
source <(kubectl completion zsh)

# -------------------------------------------------------------------------------------------------------
# Auto add hop-git ssh-key
if [ -f /usr/local/bin/ssh-addkey-svc-git.sh ]; then
	. /usr/local/bin/ssh-addkey-svc-git.sh > /dev/null 2>&1
fi

# -------------------------------------------------------------------------------------------------------
# tmux
if [ -n $TMUX ]; then
    ## Tmux + SSH --------------------------------------------------------
    function ssh_tmux() {
        ssh_host=$(echo $@ | perl -ple 's/(^|\s)-[^\s] *[^\s]+//g' | cut -d" " -f2 )
        tmux    new-window -n $(echo $@ | perl -ple 's/(^|\s)-[^\s] *[^\s]+//g' | cut -d" " -f2 ) "exec ssh $(echo $@)" \; \
                run-shell "[ ! -d $HOME/.tmux/log/${ssh_host} ] && mkdir -p $HOME/.tmux/log/${ssh_host}" \; \
                pipe-pane "cat >> $HOME/.tmux/log/${ssh_host}/$(date +%Y%m%d_%H%M%S.log)" \; \
                display-message "Started logging to $HOME/.tmux/log/${ssh_host}/$(date +%Y%m%d_%H%M%S.log)"
        #tmux    run-shell "[ ! -d $HOME/.tmux/log/${ssh_host} ] && mkdir -p $HOME/.tmux/log/${ssh_host}" \; \
        #        pipe-pane "cat >> $HOME/.tmux/log/${ssh_host}/$(date +%Y%m%d_%H%M%S.log)" \; \
        #        split-window "exec ssh $(echo $@)" \; \
        #        display-message "Started logging to $HOME/.tmux/log/${ssh_host}/$(date +%Y%m%d_%H%M%S.log)" \
        #        2> /dev/null 
        #ssh "$(echo $@)"
        #tmux pipe-pane \; display-message "Logging end."
    }
    compdef ssh_tmux='ssh'

    #if [[ $TERM = screen ]] || [[ $TERM = screen-256color ]] ; then
    #  alias ssh=ssh_tmux
    #fi
fi
