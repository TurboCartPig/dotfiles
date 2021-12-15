# Setup zsh completions from brew
FPATH=/home/linuxbrew/.linuxbrew/share/zsh/site-functions:$FPATH

# Path to your oh-my-zsh installation.
export ZSH=/home/dennis/.config/oh-my-zsh/

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
# ZSH_THEME="kardan"
ZSH_THEME=""

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Fix completion permissions issues
ZSH_DISABLE_COMPFIX=true

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.config/oh-my-zsh-custom/

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
	vi-mode
	command-not-found
	colored-man-pages
	zsh-syntax-highlighting
	zsh-autosuggestions
	zsh-completions
	git
	gh
	docker
	cargo
	rustup
	golang
)

# Reload completions
autoload -U compinit && compinit

source $ZSH/oh-my-zsh.sh

# User configuration
export DEFAULT_USER=dennis
export EDITOR=nvim
export VISUAL=nvim

# Cargo rust
export PATH="$PATH:$HOME/.cargo/bin/"

# Go
export PATH="$PATH:$HOME/go/bin/"

# Volta node.js
export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# Node.js
export PATH="$PATH:$HOME/.config/node-global/bin"

# Haskell
export PATH="$PATH:$HOME/.local/bin/"
export CABAL_DIR="$HOME/.config/cabal"
export GHCUP_USE_XDG_DIRS="ON"

# Cmake
export CMAKE_GENERATOR="Ninja"
export CMAKE_CONFIG_TYPE="Debug"
export CMAKE_EXPORT_COMPILE_COMMANDS="ON"
export CMAKE_C_COMPILER_LAUNCHER="sccache"
export CMAKE_CXX_COMPILER_LAUNCHER="sccache"

# Vcpkg path
export VCPKG_ROOT="$HOME/Projects/vcpkg"

# Fzf configuration
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
export FZF_DEFAULT_OPTS="--layout=reverse --tabstop=4"

# Setup search path for libraries in cuda sdk
export LD_LIBRARY_PATH="/usr/local/cuda-11/lib64":$LD_LIBRARY_PATH
export PATH=$PATH:"/usr/local/cuda-11/bin"

export GPG_TTY=$(tty)

export MANPAGER='nvim +Man!'
export MANPATH="$MANPATH:/usr/local/man"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
#
# My aliases
alias ls="exa"
alias ll="exa -la --git-ignore"
alias lt="exa -lT --git-ignore"
alias diff="colordiff"
alias v="nvim"
alias sv="sudo nvim"
alias vcpkg="/home/dennis/Projects/vcpkg/vcpkg"

# Evals
eval $(starship init zsh)
