###############################################################################
# EXPORT
################################################################################
export EDITOR="/usr/bin/nvim"
################################################################################
# AUTOLOAD
################################################################################
autoload -Uz compinit colors vcs_info promptinit
colors
promptinit
################################################################################
# STARTUP
################################################################################
# neofetch

### RANDOM COLOR SCRIPT ###
# Get this script from my GitLab: gitlab.com/dwt1/shell-color-scripts
# Or install it from the Arch User Repository: shell-color-scripts
# colorscript random
################################################################################
# KEYBINDINGS
################################################################################
bindkey -v
typeset -g -A key
bindkey '^?' backward-delete-char
bindkey '^[[5~' up-line-or-history
bindkey '^[[3~' delete-char
bindkey '^[[6~' down-line-or-history
bindkey '^[[A' up-line-or-search
bindkey '^[[D' backward-char
bindkey '^[[B' down-line-or-search
bindkey '^[[C' forward-char 
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
################################################################################
# ALIASES
################################################################################
# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'
# dotfiles Repository
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# ls
# alias ls="ls --color -F"
# alias ll="ls --color -lh"
alias ls='lsd' # changes using lsd as ls util
alias ll='ls -lh'
alias la='ls -a'
alias lt='ls --tree'
### ranger
# use ranger to change directory
alias cdr='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# nvim
alias nv='nvim'
alias vi='nvim'
# dnf
alias dnf='sudo dnf'
alias dnfu='sudo dnf upgrade'
alias dnfi='sudo dnf install'
alias dnfs='sudo dnf search'
################################################################################
# HISTORY
################################################################################
# Report command running time if it is more than 3 seconds
REPORTTIME=3
# Keep a lot of history
HISTFILE=~/.zhistory
HISTSIZE=5000
SAVEHIST=5000
# Add commands to history as they are entered, don't wait for shell to exit
setopt INC_APPEND_HISTORY
# Also remember command start time and duration
setopt EXTENDED_HISTORY
# Do not keep duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS
# Do not remember commands that start with a whitespace
setopt HIST_IGNORE_SPACE
# Correct spelling of all arguments in the command line
setopt CORRECT_ALL
# Enable autocompletion
zstyle ':completion:*' completer _complete _correct _approximate 

################################################################################
# TAB COMPLETE
################################################################################
zmodload zsh/complist
compinit
_comp_options+=(globdots)
### arrow-key Auto-completion-menu
# Press Tab twice to activate
zstyle ':completion:*' menu select

zstyle :compinstall filename '/home/anton/.zshrc'
################################################################################
# OTHER
################################################################################
################################################################################
# COLORS
################################################################################

### SETTING THE STARSHIP PROMPT ###
eval "$(starship init zsh)"

### Arch Wiki example
# PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
# RPROMPT='[%F{yellow}%?%f]'


source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/anton/.config/broot/launcher/bash/br
