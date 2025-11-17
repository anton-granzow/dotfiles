##############################################################################
# EXPORT
################################################################################
ZSH_PLUGIN_PATH=~/.local/share/zsh/
export PATH="$PATH:$HOME/.local/bin"

if command -v nvim &> /dev/null; then
  export EDITOR="/usr/bin/nvim"
else
  mkdir -p ~/.local/bin
  mkdir -p ~/.local/applications
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage
  mv ./nvim-linux-x86_64.appimage ~/.local/applications
  chmod u+x ~/.local/applications/nvim-linux-x86_64.appimage
  ln ~/.local/applications/nvim-linux-x86_64.appimage ~/.local/bin/nvim
  NVIM_PATH=$HOME/.local/bin/nvim
  export EDITOR=NVIM_PATH
fi
# export FZF_DEFAULT_COMMAND="find -L ."
################################################################################
# AUTOLOAD
################################################################################
autoload -Uz compinit colors vcs_info promptinit
colors
promptinit
compinit
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
#Vim mode
bindkey -v
bindkey ^R history-incremental-search-backward 
bindkey ^S history-incremental-search-forward

typeset -g -A key


#set normal Keys in Vim Mode
##
key[Home]="${terminfo[khome]}"
key[End]="${terminfo[kend]}"
key[Insert]="${terminfo[kich1]}"
key[Backspace]="${terminfo[kbs]}"
key[Delete]="${terminfo[kdch1]}"
key[Up]="${terminfo[kcuu1]}"
key[Down]="${terminfo[kcud1]}"
key[Left]="${terminfo[kcub1]}"
key[Right]="${terminfo[kcuf1]}"
key[PageUp]="${terminfo[kpp]}"
key[PageDown]="${terminfo[knp]}"
key[Shift-Tab]="${terminfo[kcbt]}"

[[ -n "${key[Home]}"      ]] && bindkey -- "${key[Home]}"       beginning-of-line
[[ -n "${key[End]}"       ]] && bindkey -- "${key[End]}"        end-of-line
[[ -n "${key[Insert]}"    ]] && bindkey -- "${key[Insert]}"     overwrite-mode
[[ -n "${key[Backspace]}" ]] && bindkey -- "${key[Backspace]}"  backward-delete-char
[[ -n "${key[Delete]}"    ]] && bindkey -- "${key[Delete]}"     delete-char
[[ -n "${key[Up]}"        ]] && bindkey -- "${key[Up]}"         up-line-or-history
[[ -n "${key[Down]}"      ]] && bindkey -- "${key[Down]}"       down-line-or-history
[[ -n "${key[Left]}"      ]] && bindkey -- "${key[Left]}"       backward-char
[[ -n "${key[Right]}"     ]] && bindkey -- "${key[Right]}"      forward-char
[[ -n "${key[PageUp]}"    ]] && bindkey -- "${key[PageUp]}"     beginning-of-buffer-or-history
[[ -n "${key[PageDown]}"  ]] && bindkey -- "${key[PageDown]}"   end-of-buffer-or-history
[[ -n "${key[Shift-Tab]}" ]] && bindkey -- "${key[Shift-Tab]}"  reverse-menu-complete

if (( ${+terminfo[smkx]} && ${+terminfo[rmkx]} )); then
	autoload -Uz add-zle-hook-widget
	function zle_application_mode_start { echoti smkx }
	function zle_application_mode_stop { echoti rmkx }
	add-zle-hook-widget -Uz zle-line-init zle_application_mode_start
	add-zle-hook-widget -Uz zle-line-finish zle_application_mode_stop
fi

# History command search with up/down using the current prompt
#####
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search

[[ -n "${key[Up]}"   ]] && bindkey -- "${key[Up]}"   up-line-or-beginning-search
[[ -n "${key[Down]}" ]] && bindkey -- "${key[Down]}" down-line-or-beginning-search


# Ctrl+Left/Right to jump words
key[Control-Left]="${terminfo[kLFT5]}"
key[Control-Right]="${terminfo[kRIT5]}"

[[ -n "${key[Control-Left]}"  ]] && bindkey -- "${key[Control-Left]}"  backward-word
[[ -n "${key[Control-Right]}" ]] && bindkey -- "${key[Control-Right]}" forward-word

## Zsh Hooks
autoload -Uz add-zsh-hook

# hook to remember dirs, use dirs -v to list dirs and cd -<Num> to go to them
DIRSTACKFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dirs"
if [[ -f "$DIRSTACKFILE" ]] && (( ${#dirstack} == 0 )); then
	dirstack=("${(@f)"$(< "$DIRSTACKFILE")"}")
	[[ -d "${dirstack[1]}" ]] && cd -- "${dirstack[1]}"
fi
chpwd_dirstack() {
	print -l -- "$PWD" "${(u)dirstack[@]}" > "$DIRSTACKFILE"
}
add-zsh-hook -Uz chpwd chpwd_dirstack

DIRSTACKSIZE='20'

setopt AUTO_PUSHD PUSHD_SILENT PUSHD_TO_HOME

## Remove duplicate entries
setopt PUSHD_IGNORE_DUPS

## This reverts the +/- operators.
setopt PUSHD_MINUS

# cdr to search recent directories
#


autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
add-zsh-hook chpwd chpwd_recent_dirs
zstyle ':completion:*:*:cdr:*:*' menu selection


################################################################################
# ALIASES
################################################################################
# Play safe!
if command -v trash &> /dev/null; then
  alias 'rm=trash -v'
else
  alias 'rm=rm -i'
fi

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
if command -v lsd &> /dev/null; then
  alias ls='lsd' # changes using lsd as ls util
fi
alias ll='ls -lh'
alias la='ls -a'
alias lt='ls --tree'
# top
if command -v bpytop &> /dev/null; then
  alias top="bpytop"
else
  alias top="htop"
fi
### ranger
# use ranger to change directory
# alias cdr='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'
# kitty
alias icat="kitty +kitten icat"
alias ktheme="kitty +kitten themes"
alias kssh="kitty +kitten ssh"
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
# setopt CORRECT_ALL
# Enable autocompletion
# zstyle ':completion:*' completer _complete _correct _approximate 

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
# Plugins
################################################################################
# noisetorch for microphone input
if command -v noisetorch &> /dev/null; then
    eval "$(noisetorch -i)"
fi

# starship Prompt
if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
else 
  mkdir -p ~/.local/bin
  curl -sS https://starship.rs/install.sh | sh -s -- --bin-dir ~/.local/bin
  eval "$(starship init zsh)"
  # PROMPT='%F{green}%n%f@%F{magenta}%m%f %F{blue}%B%~%b%f %# '
# RPROMPT='[%F{yellow}%?%f]'
fi

# thefuck: command correction
if command -v thefuck &> /dev/null; then
  eval $(thefuck --alias)
fi

if command -v pkgfile &> /dev/null; then
  source /usr/share/doc/pkgfile/command-not-found.zsh
fi

if command -v broot &> /dev/null; then
  source /home/anton/.config/broot/launcher/bash/br
fi

if [ -f ~/.config/zsh/zoxide.zsh ]; then
  source ~/.config/zsh/zoxide.zsh
fi

if [ -f ${ZSH_PLUGIN_PATH}/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source $ZSH_PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
else
  mkdir -p $ZSH_PLUGIN_PATH
  cd $ZSH_PLUGIN_PATH
  eval $(git clone https://github.com/zsh-users/zsh-autosuggestions)
  cd
  source $ZSH_PLUGIN_PATH/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

if [ -f "$ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
else
  mkdir -p $ZSH_PLUGIN_PATH
  cd $ZSH_PLUGIN_PATH
  eval $(git clone https://github.com/zsh-users/zsh-syntax-highlighting.git)
  cd
  source $ZSH_PLUGIN_PATH/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi
