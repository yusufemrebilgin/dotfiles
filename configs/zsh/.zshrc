# Shell profiling (enable when optimizing slow startup)
#
#   - Add 'zmodload zsh/zshprof' at top of the ~/.zshrc
#   - Add 'zprof' at bottom of the ~/.zshrc
#
# Measure startup time with 'time zsh -i -c exit'

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

plugins=(
  sudo
  zsh-completions
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-history-substring-search
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

# History configuration
HISTSIZE=50000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE

setopt HIST_NO_STORE
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST

ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_HISTORY_IGNORE=" export *"

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

bindkey '^B' autosuggest-toggle
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND=''
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND=''

# Source a file only if it exists and readable
source_if_exists() { [[ -r "$1" ]] && source "$1"; }

source_if_exists "$HOME/.zsh_aliases"
source_if_exists "$HOME/.zsh_tools"

# zprof (only when profiling is enabled)
