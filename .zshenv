# Environment variables
# =====================

# Configure the rest of the zsh config files
export ZDOTDIR="$HOME/.config/zsh"

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

# Node.js
export NPM_CONFIG_USERCONFIG="$HOME/.config/npm/config"
export PATH="$HOME/.local/share/npm/bin/:$PATH"

# Oracle sqlcl
export PATH="$(realpath /opt/homebrew/Caskroom/sqlcl/*/sqlcl/bin):$PATH"

# Make JetBrains IDEs launchable from cli
if [[ $(uname) == "Darwin" ]]; then
	export PATH="$PATH:/Users/dennis/Library/Application Support/JetBrains/Toolbox/scripts"
fi

# Fzf configuration
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
export FZF_DEFAULT_OPTS="--layout=reverse --tabstop=4"

export GPG_TTY=$(tty)
