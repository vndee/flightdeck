# Agentic-Native Terminal Engineering Setup — Design

**Date:** 2026-06-19
**Status:** Approved
**Owner:** Duy Huynh (@vndee)

## Goal

Replace full GUI IDEs with a high-performance, **agentic-native** terminal
engineering environment on macOS. Optimize for:

1. **Throughput** — run multiple Claude Code agents in parallel on isolated
   git worktrees without collisions.
2. **Focus** — a tight in-editor agent loop for single tasks.
3. **Aesthetics** — one cohesive look (Catppuccin Mocha) across every tool.
4. **Reproducibility** — everything version-controlled in a public, Stow-managed
   dotfiles repo with a one-command bootstrap.

## Current state (before)

- Terminal: **Ghostty** (GPU, native macOS) — keep.
- Shell: **fish** (login shell), minimal config, mid-migration off zsh (legacy
  `.zshrc` + backups present).
- Editor: legacy Neovim — Vimscript `init.vim` + **Packer** (deprecated).
- Multiplexer: **tmux** present, near-empty config.
- Prompt: `starship.toml` exists but the `starship` binary is **not installed**.
- Modern CLI layer **entirely missing**: fzf, fd, bat, eza, zoxide, delta,
  lazygit, yazi, atuin, btop.
- Multiple AI CLIs already tried: claude code, codex, crush, opencode, copilot.
- `dotfile/` repo is **empty** — the canvas for this work.

## Architecture

```
Ghostty (GPU terminal, Catppuccin)
└── fish (login shell) + Starship prompt
    └── tmux  ── the agentic cockpit ───────────────────────────┐
        ├── session: main repo        [nvim | claude | lazygit]  │
        ├── session: wt/feature-a     [nvim | claude]   ◄─ git worktree
        ├── session: wt/feature-b     [nvim | claude]   ◄─ git worktree
        └── sesh + fzf  → jump between agent sessions instantly   │
                                                                  │
   Neovim (LazyVim) ── LSP (Go/Python/TS) · Treesitter · fzf-lua ·│
                       blink.cmp · claudecode.nvim (in-editor agent)
```

### Layers

| Layer | Tool | Notes |
|---|---|---|
| Terminal | Ghostty | themed; keybinds for splits/tabs |
| Shell | fish | consolidate; archive zsh cruft |
| Prompt | Starship | install binary; reuse existing toml |
| Multiplexer | tmux | sesh, resurrect/continuum, vim-tmux-navigator, tpm |
| Editor | Neovim + LazyVim | lazy.nvim, native LSP, Treesitter, blink.cmp |
| Agent (parallel) | Claude Code + `wt` script | worktree-per-task orchestration |
| Agent (in-editor) | claudecode.nvim | selection sharing + diff review in nvim |
| File mgr | yazi | fast TUI file manager |
| Git TUI | lazygit | + delta for diffs |
| History | atuin | searchable, synced shell history |
| CLI core | fzf · fd · ripgrep · bat · eza · zoxide · btop · gh · jq | modern replacements |
| Theme | Catppuccin Mocha | applied to every tool above |
| Dotfiles | GNU Stow | symlink farm, public repo |

## The agentic workflow (the differentiator)

**Parallel mode — `wt <branch>`:**
1. `git worktree add` an isolated checkout for the task.
2. Spawn a dedicated tmux session named after the branch.
3. Open Neovim + a Claude Code pane in that session.
4. `sesh` + fzf hotkey jumps between agent sessions.
→ 2–4 agents work concurrently on separate branches; no file collisions.

**Focus mode — in editor:**
- `claudecode.nvim` runs Claude Code bound to the Neovim instance, sharing the
  current selection/buffer and rendering diffs natively for review/apply.

## Repo layout (Stow packages)

```
dotfile/
├── README.md          # public-facing, screenshots, install
├── LICENSE            # MIT
├── install.sh         # brew bundle + stow all + post-install
├── Brewfile           # every package, pinned via brew
├── docs/plans/        # this design + the implementation plan
├── ghostty/   .config/ghostty/config
├── fish/      .config/fish/{config.fish,conf.d,functions}
├── starship/  .config/starship.toml
├── tmux/      .config/tmux/tmux.conf
├── nvim/      .config/nvim/...            (LazyVim)
├── git/       .config/git/{config,ignore}
├── bat/       .config/bat/config
├── lazygit/   .config/lazygit/config.yml
├── atuin/     .config/atuin/config.toml
├── yazi/      .config/yazi/...
└── bin/       .local/bin/wt              (worktree orchestrator)
```

Each top-level dir is a Stow package; `stow -t "$HOME" nvim` symlinks
`nvim/.config/nvim → ~/.config/nvim`.

## Safety / migration

- **Back up** existing `~/.config/{nvim,fish}`, `~/.tmux.conf`, `~/.zshrc*` to a
  timestamped `~/.dotfiles-backup-<ts>/` before stowing. Never delete.
- **Keep Cursor / VS Code** installed during transition; provide documented
  uninstall commands to run later.
- **Keep Xcode Command Line Tools** (Homebrew + compilers depend on them) even
  if the full Xcode.app is later removed.
- **No secrets** committed (public repo): tokens/keys stay in
  `~/.config/fish/conf.d/secret.fish` which is `.gitignore`d.

## Build phases

1. **CLI core** — Brewfile + install (fzf, fd, bat, eza, zoxide, delta,
   lazygit, yazi, atuin, btop, gh, jq, stow, starship, sesh).
2. **Shell + prompt** — fish config, abbreviations, tool init, Starship, secret
   scaffolding.
3. **tmux** — themed config, plugins, vim-navigator, sesh keybinds.
4. **Ghostty** — themed config + keybinds.
5. **Neovim** — LazyVim base + LSP/format/lint for Go/Python/TS + theme.
6. **Agent layer** — `wt` worktree orchestrator + claudecode.nvim + Claude Code
   tmux helpers.
7. **Stow + bootstrap** — wire everything, write install.sh, README, LICENSE.
8. **Verify** — fresh shell, launch full cockpit, sanity-check each tool.

## Non-goals

- Multi-machine sync / templating (Stow over chezmoi for simplicity now).
- Replacing Claude Code with another agent (it's the primary).
- Removing GUI IDEs in this session (documented for later).
