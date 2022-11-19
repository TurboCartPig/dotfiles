# This is a bootstrap script for setting up dotfiles on Windows

# TODO: Find the dotfiles repo programatically

[CmdletBinding()]
Param (
	# Path to dotfiles directory
	[Parameter(Mandatory = $false)]
	[ValidateScript({ Test-Path $_ })]
	[String]
	$DOTFILES = "C:\Projects\dotfiles",

	# Context defines additinal, context specific, git config
	[Parameter(Mandatory = $false)]
	[String]
	$CONTEXT = "Work"
)

# Symlink powershell profile
New-Item -ItemType SymbolicLink -Path "$PROFILE" -Target "$DOTFILES\Microsoft.PowerShell_profile.ps1" -Force

# Symlink IdeaVim config
New-Item -ItemType SymbolicLink -Path "$HOME\.ideavimrc" -Target "$DOTFILES\.ideavimrc" -Force

# Symlink git config with appropriate overrides
New-Item -ItemType Directory -Path "$HOME\.config", "$HOME\.config\git"
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config" -Target "$DOTFILES\.config\git\config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config.local" -Target "$DOTFILES\.config\git\config.local##os.Windows" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\git\config.context" -Target "$DOTFILES\.config\git\config.context##class.$CONTEXT" -Force

# Install additional software
$SoftwareIds = @("Git.Git", "Starship.Starship")

foreach ($Id in $SoftwareIds) {
	winget install --exact --id $Id --source winget
}