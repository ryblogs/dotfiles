# Dotfiles

Personal configuration files managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Overview

This repository contains configuration files for various development tools and terminal applications. Each subdirectory represents a "package" that can be selectively installed using GNU Stow.

## Tools Included

| Tool | Description | Config Location |
|------|-------------|-----------------|
| **atuin** | Enhanced shell history with sync capabilities | `~/.config/atuin/` |
| **ghostty** | Fast, feature-rich terminal emulator | `~/Library/Application Support/com.mitchellh.ghostty/` |
| **micro** | Modern terminal-based text editor | `~/.config/micro/` |
| **neovim** | Extensible Vim-based text editor | `~/.config/nvim/` |
| **starship** | Fast, customizable shell prompt | `~/.config/` |
| **zellij** | Terminal workspace with panes and tabs | `~/.config/zellij/` |
| **zshrc** | Zsh shell configuration | `~/` |

## Prerequisites

- [GNU Stow](https://www.gnu.org/software/stow/) installed on your system
- The respective applications installed for each config you plan to use

### Installing GNU Stow

**macOS (Homebrew):**
```bash
brew install stow
```

**Ubuntu/Debian:**
```bash
sudo apt install stow
```

**Arch Linux:**
```bash
sudo pacman -S stow
```

## Installation

### Individual Packages

Install specific configurations by running stow from the repository root:

```bash
# Install neovim configuration
stow -t ~ neovim

# Install zsh configuration  
stow -t ~ zshrc

# Install starship prompt
stow -t ~ starship
```

### Install All Packages

To install all configurations at once:

```bash
stow -t ~ */
```

Or alternatively:
```bash
stow -t ~ atuin ghostty micro neovim starship zellij zshrc
```

### Selective Installation

You can also install multiple specific packages:

```bash
stow -t ~ neovim starship zshrc
```

## Removal

To remove (unstow) configurations:

```bash
# Remove specific package
stow -D -t ~ neovim

# Remove all packages
stow -D -t ~ */
```

## Directory Structure

```
.
├── .gitignore
├── atuin/              # Shell history tool config
├── ghostty/            # Terminal emulator config + shaders
├── micro/              # Text editor config + colorschemes  
├── neovim/             # Neovim config with plugins
├── starship/           # Shell prompt config
├── zellij/             # Terminal multiplexer config + themes
└── zshrc/              # Zsh shell configuration
```

## Features

### Neovim
- Lazy.nvim plugin manager setup
- Custom keymaps and autocmds
- Telescope fuzzy finder
- Tokyo Night colorscheme

### Ghostty
- Custom configuration
- Collection of cursor shaders for visual effects

### Micro
- Tokyo Night colorscheme
- Custom settings

### Zellij
- Custom layout and keybindings
- Tokyo Night theme

## Usage Notes

- **Backup existing configs**: Stow will fail if conflicting files exist, so backup your current configurations first
- **Symlinks**: Stow creates symlinks, so changes made to files in your home directory will be reflected in this repository
- **Git management**: You can commit and push changes to keep your dotfiles in sync across machines

## Troubleshooting

**Stow conflicts:**
If you get conflicts, you may have existing files. Either back them up or use:
```bash
stow --adopt -t ~ <package>
```
This will move existing files into the stow directory.

**Missing directories:**
Stow will create necessary parent directories automatically.

## Contributing

Feel free to fork this repository and adapt it for your own use. These configurations are personalized but can serve as a starting point for your own dotfiles setup.
