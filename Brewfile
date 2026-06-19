# Brewfile — agentic-native terminal setup
# Install with: brew bundle --file=Brewfile

tap "joshmedeski/sesh"

# --- Core: shell, prompt, multiplexer, editor ---
brew "fish"          # login shell
brew "starship"      # prompt
brew "tmux"          # multiplexer / agent cockpit
brew "neovim"        # editor
brew "tree-sitter-cli"  # required by nvim-treesitter (main) to build parsers
brew "stow"          # dotfiles symlink manager

# --- Modern CLI replacements ---
brew "fzf"           # fuzzy finder
brew "fd"            # find
brew "ripgrep"       # grep
brew "bat"           # cat
brew "eza"           # ls
brew "zoxide"        # cd (smart)
brew "git-delta"     # git diff pager
brew "lazygit"       # git TUI
brew "yazi"          # file manager TUI
brew "atuin"         # shell history
brew "btop"          # process monitor
brew "gh"            # GitHub CLI
brew "jq"            # JSON
brew "tlrc"          # tldr (rust client)
brew "sesh"          # tmux session manager

# --- yazi preview deps (light) ---
brew "ffmpegthumbnailer"
brew "sevenzip"
brew "poppler"

# --- Apps / fonts ---
cask "ghostty"                          # GPU terminal (already installed; pinned here)
cask "font-jetbrains-mono-nerd-font"    # Nerd Font for icons
