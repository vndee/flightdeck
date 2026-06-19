# dotfiles

> An **agentic-native** terminal engineering environment for macOS. No IDE.
> Ghostty · fish · tmux · Neovim (LazyVim) · Claude Code — themed in Catppuccin
> Mocha and managed with GNU Stow.

Built for a workflow where AI agents are first-class: run several Claude Code
agents in parallel on isolated git worktrees, or drive one from inside Neovim.

## Stack

| Layer | Tool |
|---|---|
| Terminal | [Ghostty](https://ghostty.org) — GPU, native macOS |
| Shell | [fish](https://fishshell.com) + [Starship](https://starship.rs) prompt |
| Multiplexer | [tmux](https://github.com/tmux/tmux) + [sesh](https://github.com/joshmedeski/sesh) + tpm plugins |
| Editor | [Neovim](https://neovim.io) + [LazyVim](https://lazyvim.org) |
| Agent | [Claude Code](https://claude.com/claude-code) + `wt` worktrees + [claudecode.nvim](https://github.com/coder/claudecode.nvim) |
| CLI core | fzf · fd · ripgrep · bat · eza · zoxide · git-delta · lazygit · yazi · atuin · btop · gh |
| Theme | Catppuccin Mocha (everywhere) |

## Install

```bash
git clone https://github.com/vndee/dotfile ~/dotfile
cd ~/dotfile
./install.sh          # installs Homebrew packages, stows configs, sets up plugins
chsh -s "$(command -v fish)"   # make fish your login shell
```

`install.sh` is idempotent and backs up any conflicting files to
`~/.dotfiles-backup-<timestamp>/` before symlinking.

## The agentic workflow

**Parallel agents — `wt`** (the core idea):

```bash
wt my-feature     # git worktree + dedicated tmux session (nvim + claude windows)
wt another-fix    # a second isolated agent, zero collisions
wt ls             # list worktrees and sessions
wt rm my-feature  # tear it down
```

Each task gets its own checkout and tmux session, so 2–4 Claude Code agents run
concurrently on separate branches. Jump between them with `prefix + T` (sesh).

**In-editor agent — `claudecode.nvim`:** press `<leader>ac` in Neovim to toggle
Claude Code bound to the editor; send a visual selection with `<leader>as`;
accept/deny proposed diffs with `<leader>aa` / `<leader>ad`.

## Layout (Stow packages)

```
.
├── Brewfile          # all packages
├── install.sh        # one-command bootstrap
├── ghostty/          # terminal
├── fish/             # shell + abbreviations
├── starship/         # prompt
├── tmux/             # multiplexer cockpit
├── nvim/             # LazyVim
├── git/ bat/ lazygit/ atuin/ yazi/   # tool configs
├── bin/              # ~/.local/bin/wt orchestrator
└── docs/plans/       # design + implementation plan
```

Manage individual packages with `stow -t ~ <package>` / `stow -D -t ~ <package>`.

## Key bindings (cheatsheet)

| Where | Key | Action |
|---|---|---|
| tmux | `Ctrl-a` | prefix |
| tmux | `prefix \|` / `prefix -` | split right / down |
| tmux | `prefix T` | session switcher (sesh + fzf) |
| tmux | `prefix a` | spawn a Claude Code pane |
| tmux | `prefix g` | lazygit popup |
| nvim | `<space>` | leader (LazyVim) |
| nvim | `<leader>ac` | toggle Claude Code |
| nvim | `<leader>as` | send selection to Claude (visual) |
| fish | `Ctrl-r` | atuin history search |
| fish | `Ctrl-t` / `Alt-c` | fzf file / directory |

## Secrets

Machine-local secrets live in `~/.config/fish/conf.d/secret.fish` and git
identity in `~/.gitconfig` — both are gitignored / outside the repo. Copy the
provided `*.example` files on a fresh machine.

## Removing GUI IDEs (when you're ready)

This setup intentionally keeps your GUI editors during the transition. Once the
terminal flow is proven, remove them — **but keep the Xcode Command Line Tools**,
which Homebrew and compilers depend on:

```bash
brew uninstall --cask cursor visual-studio-code   # if installed via brew
# or drag Cursor.app / Visual Studio Code.app to Trash
rm -rf ~/Library/Application\ Support/Cursor ~/Library/Application\ Support/Code  # optional caches

# Keep the CLT (do NOT remove): xcode-select -p  → /Library/Developer/CommandLineTools
# Only remove the full Xcode.app if you don't build Apple platform apps.
```

## License

MIT — see [LICENSE](LICENSE).
