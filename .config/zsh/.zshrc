# Plugins
# =======

source ~/.config/zsh/plugins/zsh-completions/zsh-completions.plugin.zsh
source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh

# Add custom completions
fpath+=~/.config/zsh/completions/

# Autocompletion
# ==============

autoload -U compinit
zmodload zsh/complist

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Autocomplete with interactive menu
zstyle ':completion:*' menu select

# Include hidden files.
_comp_options+=(globdots)

# Autocomplete from the middle of the word
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'

# Autocomplete smartcase like vim
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

compinit

# Zsh options
# ===========

# automatically list choices on ambiguous completion
setopt AUTO_LIST
# show completion menu on a successive tab press
setopt AUTO_MENU
# if completed parameter is a directory, add a trailing slash
setopt AUTO_PARAM_SLASH
# complete from the cursor rather than from the end of the word
setopt COMPLETE_IN_WORD
# do not autoselect the first completion entry
setopt NO_MENU_COMPLETE
setopt HASH_LIST_ALL
setopt ALWAYS_TO_END

# History
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.cache/zsh/history"

# Don't store duplicate lines in the history file
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY

# Write and import history on every command
# setopt SHARE_HISTORY
# setopt HIST_FIND_NO_DUPS

# Allow comments in command line
setopt INTERACTIVE_COMMENTS

# Aliases
# =======

alias ls="exa"
alias ll="exa -la --git-ignore"
alias lt="exa -lT --git-ignore"

alias diff="colordiff"

alias v="nvim"
alias sv="sudo nvim"

# Lazygit for yadm
alias ly="lazygit -g ~/.local/share/yadm/repo.git/"
alias lg="lazygit"

# Environment variables
# =====================

# User configuration
export DEFAULT_USER=dennis

# User installed binaries
export PATH="$HOME/.local/bin/:$PATH"

# Set neovim as default editor and man pager
export EDITOR=nvim
export VISUAL=nvim
export MANPAGER='nvim +Man!'
export MANPATH="$MANPATH:/usr/local/man/"

# Add cargo installed binaries
export PATH="$HOME/.cargo/bin/:$PATH"

# Go
export PATH="$HOME/go/bin/:$PATH"

# Volta node.js
export VOLTA_HOME="$HOME/.volta/"
export PATH="$VOLTA_HOME/bin/:$PATH"

# Node.js
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/config"
export PATH="$HOME/.local/share/npm/bin/:$PATH"

# Haskell
export CABAL_DIR="$HOME/.config/cabal/"
export GHCUP_USE_XDG_DIRS="ON"

# CMake
export CMAKE_GENERATOR="Ninja"
export CMAKE_CONFIG_TYPE="Debug"
export CMAKE_EXPORT_COMPILE_COMMANDS="ON"
export CMAKE_C_COMPILER_LAUNCHER="sccache"
export CMAKE_CXX_COMPILER_LAUNCHER="sccache"

# Fzf configuration
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
export FZF_DEFAULT_OPTS="--layout=reverse --tabstop=4"

export GPG_TTY=$(tty)

# Prompt
# ======

eval $(starship init zsh)

# Hooks
# =====

eval "$(direnv hook zsh)"
