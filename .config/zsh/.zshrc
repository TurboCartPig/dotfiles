# Homebrew
# ========

eval "$(/opt/homebrew/bin/brew shellenv)"

# Plugins
# =======

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Add brew completions
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH
fi

# Autocompletion
# ==============

autoload -U compinit
zmodload zsh/complist

# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/.zcompcache"

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

alias ls="eza"
alias ll="eza -la --git-ignore"
alias lt="eza -lT --git-ignore"

alias v="nvim"
alias vi="nvim"
alias sv="sudo nvim"

# Lazygit for yadm
alias ly="lazygit -g ~/.local/share/yadm/repo.git/"
alias lg="lazygit"

# Prompt
# ======

eval "$(starship init zsh)"

# Make JetBrains IDEs launchable from cli
if [[ $(uname) == "Darwin" ]]; then
	export PATH="$PATH:/Users/dennis/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# JEnv
# ====

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

