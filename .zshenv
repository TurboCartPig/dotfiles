# Environment variables
# =====================

# Configure the rest of the zsh config files
export ZDOTDIR="$HOME/.config/zsh"

export XDG_CACHE_HOME="$HOME/.cache"

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

# Sourcing
# ========

# Nix
if [ -e /home/dennis/.nix-profile/etc/profile.d/nix.sh ]; then . /home/dennis/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
