# This is a bootstrap script for setting up dotfiles on Windows

# TODO: Find the dotfiles repo programatically
# TODO: Take 'context' as a parameter

# Symlink IdeaVim config
New-Item -ItemType SymbolicLink -Path $HOME\.ideavimrc -Target C:\Projects\dotfiles\.ideavimrc

# SymbolicLink git config with appropriate overrides
New-Item -ItemType Directory -Path $HOME\.config, $HOME\.config\git
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config" -Target "C:\Projects\dotfiles\.config\git\config"
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config.local" -Target "C:\Projects\dotfiles\.config\git\config.local##os.Windows"
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config.context" -Target "C:\Projects\dotfiles\.config\git\config.context##class.Work"