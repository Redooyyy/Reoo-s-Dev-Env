# Reo's NixOS Configuration

A fully customized, declarative NixOS environment built with Flakes. This repository contains the complete system architecture, dotfiles, and scripts for a seamless, aesthetic, and functional Linux experience.

---

## Features

### Caelestia Desktop Environment
A highly customized, dynamic Hyprland Wayland compositor setup.
- Hyprland: Advanced window rules, smooth animations, dynamic tiling, custom keybinds, and gestures.
- Shell & Terminal: fish shell configured with custom aliases and starship prompt, running in the lightweight foot terminal.
- Browser Integrations: Deep integration and custom CSS styling for Firefox and Zen browsers.
- Editor Aesthetics: Unified theming and configurations across VS Code, Zed, and Micro editors.
- File Management: Thunar configured with custom volume management and user custom actions (UCA).
- System Monitoring: Pre-configured btop and fastfetch for beautiful system insights.
- Media: Custom Spicetify theme for Spotify.
- Utilities: Universal Wayland Session Manager (UWSM) support, custom wrapper scripts for YouTube autoplay and searching.

### Neovim (nvim)
A lightning-fast, highly extensible Neovim setup powered by lazy.nvim.
- Core: Custom keymaps, optimal performance options, and UI enhancements.
- LSP & Formatting: Fully configured Language Server Protocol via Mason, supporting languages like Lua, Svelte, GraphQL, ESLint, and Emmet.
- Treesitter: Advanced syntax highlighting and text objects.
- Plugins: Includes Telescope, Harpoon, GitSigns, Auto-session, Trouble, Which-Key, LazyGit, and many more.

### CLI Music (cli-music)
A complete command-line interface music playback stack.
- Daemon: MPD (Music Player Daemon) background service.
- Client: rmpc (Rust Music Player Client) with custom themes and keybindings.
- Visualizer: Cava audio visualizer for terminal audio reactivity.
- Automation: Custom Python and Fish scripts (yt-lyrics-auto.py, music.fish) to automate lyric fetching and playback control.

### NixOS System & Modules
- Flake Architecture: Fully modularized Nix flake configurations managing all packages and system state declaratively.
- Host (dedSec): Hardware-specific configurations for the primary machine (dedSec).
- System Modules: Core system configuration, desktop environment integration, SDDM themes, and system-wide packages.
- User Modules: Declarative user profiles, dotfile management, and user-level packages.

---

## How to Use

### 1. Prerequisites
Ensure you are running NixOS with Flakes enabled.

### 2. Installation
Clone the repository to your machine:
```bash
git clone https://github.com/Redooyyy/Reoo-s-Dev-Env.git ~/.nixos-config
cd ~/.nixos-config
```

### 3. Apply the System Configuration
Apply the system configuration for the dedSec host. This will evaluate the flake and install the defined system packages, dotfiles, and modules.
```bash
sudo nixos-rebuild switch --flake .#dedSec
```

### 4. Updating
To update all flake inputs (packages) to their latest versions:
```bash
nix flake update
sudo nixos-rebuild switch --flake .#dedSec
```

---

## Development Workflow

This repository uses a structured Git workflow:
- main: Stable, tested configuration.
- dev: Active development and integration branch.
- feat/*: Feature-specific branches (e.g., feat/nvim).

To make changes:
1. Checkout the dev branch: `git checkout dev`
2. Create a new branch for your feature: `git checkout -b update-feature dev`
3. Make your changes and test them using `sudo nixos-rebuild test --flake .#dedSec`
4. Commit your changes using professional commit messages.
5. Merge back into dev:
   ```bash
   git checkout dev
   git merge update-feature
   ```
