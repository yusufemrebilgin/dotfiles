# Shell profiling (enable when optimizing slow startup)
#
#   - Add 'zmodload zsh/zprof' at top of the ~/.zshrc
#   - Add 'zprof' at bottom of the ~/.zshrc
#   - To remove completion cache 'rm -rf ~/.zcompdump*'
#
# Measure startup time with 'time zsh -i -c exit'

export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

zsh_plugin_urls=(
  https://github.com/zsh-users/zsh-completions
  https://github.com/zsh-users/zsh-autosuggestions
  https://github.com/zsh-users/zsh-syntax-highlighting
  https://github.com/zsh-users/zsh-history-substring-search
)

() {
  local repo_url
  local plugin_name plugin_path
  for repo_url in "$@"; do
    plugin_name="${repo_url:t}"
    plugin_path="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin_name"
    if [[ ! -d $plugin_path ]]; then
      echo "Installing zsh plugin $plugin_name"
      git clone --depth=1 "$repo_url" "$plugin_path"
    fi
  done
} $zsh_plugin_urls

zsh_plugin_basenames=(${zsh_plugin_urls[@]:t})
zsh_plugin_basenames=(${zsh_plugin_basenames:#zsh-completions})

plugins=(
  sudo
  $zsh_plugin_basenames
)

fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
source $ZSH/oh-my-zsh.sh

unset zsh_plugin_urls zsh_plugin_basenames

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Check whether a program is installed (ignores aliases and functions)
is_command_installed() { (( $+commands[$1] )); }

# Preferred editor: nvim locally if installed, vim otherwise (and over SSH)
if [[ -z $SSH_CONNECTION ]] && is_command_installed nvim; then
  export EDITOR='nvim'
else
  export EDITOR='vim'
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

alias h='history'
alias hl='history | less +G'
alias hs='history | grep'
alias hsi='history | grep -i'

[[ $EDITOR == nvim ]] && alias vim='nvim'

alias p='pnpm'
alias k='kubectl'

alias c='clear'
alias so='source'
alias reload='exec zsh'

# Source a file only if it exists and readable (missing file is not an error)
source_if_exists() { [[ ! -r "$1" ]] || source "$1"; }

typeset -U PATH path FPATH fpath

# Homebrew shell environment setup
[[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

is_command_installed zoxide && eval "$(zoxide init zsh)"

if is_command_installed fzf; then
  if fzf_init="$(fzf --zsh 2>/dev/null)"; then
    eval "$fzf_init"
  else
    source_if_exists /usr/share/doc/fzf/examples/key-bindings.zsh
    source_if_exists /usr/share/doc/fzf/examples/completion.zsh
  fi
  unset fzf_init
fi

# Auto-completion for kubectl
is_command_installed kubectl && source <(kubectl completion zsh)

# Go
export PATH="$PATH:/usr/local/go/bin"
export PATH="$PATH:$HOME/go/bin"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Node version manager (switches version automatically on cd, reads .nvmrc)
is_command_installed fnm && eval "$(fnm env --use-on-cd --shell zsh)"

# direnv hook
is_command_installed direnv && eval "$(direnv hook zsh)"

# THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
source_if_exists "$SDKMAN_DIR/bin/sdkman-init.sh"

# zprof (only when profiling is enabled)
