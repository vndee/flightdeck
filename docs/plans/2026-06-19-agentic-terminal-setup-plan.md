# Agentic-Native Terminal Setup — Implementation Plan

> **For Claude:** Execute task-by-task. Each task ends with a **Verify** gate
> (command + expected output). Do not proceed past a failing gate.

**Goal:** Build a cohesive, agentic-native terminal engineering environment
(Ghostty + fish + tmux + Neovim/LazyVim + Claude Code orchestration) managed as
a public, Stow-based dotfiles repo with one-command bootstrap.

**Architecture:** Stow packages under `dotfile/` symlink into `~`. Catppuccin
Mocha theming everywhere. Agentic workflow = git-worktree-per-task via a `wt`
script + `claudecode.nvim` for in-editor loops.

**Tech Stack:** Homebrew, GNU Stow, fish, Starship, tmux (+tpm), Neovim/LazyVim
(lazy.nvim), Claude Code, Catppuccin.

---

## Task 0: Safety backup

**Step 1:** Back up existing configs to timestamped dir (never delete).
```bash
ts=$(date +%s); bk="$HOME/.dotfiles-backup-$ts"; mkdir -p "$bk"
for p in .config/nvim .config/fish .tmux.conf .config/tmux .config/ghostty \
         .config/starship.toml; do
  [ -e "$HOME/$p" ] && cp -RL "$HOME/$p" "$bk/" 2>/dev/null
done
```
**Verify:** `ls "$bk"` lists nvim, fish, etc. Record `$bk` path.

## Task 1: CLI core (Brewfile + install)

**Files:** Create `Brewfile`.
**Tools:** stow, fzf, fd, ripgrep, bat, eza, zoxide, zoxide, git-delta, lazygit,
yazi, atuin, btop, gh, jq, starship, sesh, tmux, neovim, fish, tldr,
font-jetbrains-mono-nerd-font.
**Verify:** `brew bundle check --file=Brewfile` → "dependencies are satisfied".

## Task 2: Shell (fish) + prompt (Starship)

**Files:** Create `fish/.config/fish/config.fish`, `conf.d/*.fish`,
`functions/*.fish`, `starship/.config/starship.toml`, `.gitignore` entry for
`conf.d/secret.fish`.
- Tool init (zoxide, atuin, fzf, starship), PATH (`~/.local/bin`),
  abbreviations (g, gs, lg, v=nvim, ll=eza), `$EDITOR=nvim`.
- Catppuccin Starship preset.
**Verify:** `fish -c 'type starship; type z; type __zoxide_z 2>/dev/null; echo OK'`
prints OK with no errors; `fish -c 'starship --version'` works.

## Task 3: Multiplexer (tmux)

**Files:** Create `tmux/.config/tmux/tmux.conf`.
- Prefix `C-a`, mouse on, vi copy-mode, 1-based index, fast escape.
- Plugins (tpm): catppuccin/tmux, tmux-plugins/{tmux-resurrect,tmux-continuum},
  christoomey/vim-tmux-navigator, tmux-plugins/tmux-yank.
- sesh keybind (`prefix + T`) → fzf session switcher.
**Verify:** `tmux -f tmux/.config/tmux/tmux.conf -L test new -d && tmux -L test
kill-server` exits 0 (config parses).

## Task 4: Terminal (Ghostty)

**Files:** Create `ghostty/.config/ghostty/config`.
- theme = catppuccin-mocha, JetBrainsMono Nerd Font, padding, opacity,
  keybinds for split/tab, `macos-option-as-alt`.
**Verify:** `ghostty +show-config --config-file=ghostty/.config/ghostty/config`
exits 0 (or `ghostty +validate-config`).

## Task 5: Editor (Neovim / LazyVim)

**Files:** Create `nvim/.config/nvim/` from LazyVim starter:
- `init.lua`, `lua/config/{lazy,options,keymaps,autocmds}.lua`,
  `lua/plugins/{theme,lang,coding,editor,agent}.lua`,
  `lazyvim.json` enabling extras: lang.go, lang.python, lang.typescript,
  lang.json, lang.markdown, formatting.prettier, editor.fzf, coding.blink.
- Theme plugin → catppuccin mocha.
**Verify:** `nvim --headless "+Lazy! sync" +qa` completes; then
`nvim --headless "+checkhealth" +qa 2>&1 | tail` shows no fatal errors.

## Task 6: Agent layer

**Files:**
- Create `bin/.local/bin/wt` (worktree orchestrator): `wt <branch>` →
  `git worktree add ../<repo>-<branch> -b <branch>`, new tmux session, window 1
  = nvim, window 2 = `claude`, attach/switch. `wt ls`, `wt rm <branch>`.
- Add `nvim/.config/nvim/lua/plugins/agent.lua` → `coder/claudecode.nvim`
  with keymaps under `<leader>a` (toggle, send selection, accept/deny diff).
- Add fish abbrs: `cl=claude`, `wt`.
**Verify:** `bash -n bin/.local/bin/wt` (syntax ok); `wt` with no args prints
usage; claudecode.nvim listed in `nvim --headless "+Lazy! sync" +qa` output.

## Task 7: Supporting configs + Stow + bootstrap

**Files:** Create `git/.config/git/{config,ignore}` (delta pager, aliases),
`bat/.config/bat/config` (catppuccin), `lazygit/.config/lazygit/config.yml`
(catppuccin + delta), `atuin/.config/atuin/config.toml`,
`yazi/.config/yazi/theme.toml` (catppuccin), `install.sh`, `README.md`,
`LICENSE` (MIT), top-level `.gitignore`.
- `install.sh`: `brew bundle`, `stow -t "$HOME" <each package>`, tpm clone,
  fish plugin install, post-notes.
**Verify:** `stow -n -t "$HOME" --adopt=false nvim fish tmux ghostty starship git
bat lazygit atuin yazi bin` (dry run) reports no conflicts after backups moved
aside.

## Task 8: Wire it up (apply) + end-to-end verify

**Step 1:** Move conflicting originals aside, then `stow` all packages.
**Step 2:** Install tpm + tmux plugins, fisher plugins, Starship.
**Step 3:** Sync LazyVim plugins headless.
**Verify (end-to-end):**
- `readlink ~/.config/nvim` → points into the dotfile repo.
- `fish -lc 'echo $EDITOR; starship --version; z --version'` → nvim + versions.
- `tmux new -d -s smoke && tmux ls && tmux kill-session -t smoke` → ok.
- `nvim --headless "+checkhealth" +qa` → no fatal errors.
- `wt` prints usage; `claude --version` works.

## Task 9: Commit + document removal path

**Step 1:** Commit everything in logical chunks.
**Step 2:** Append to README a "Removing GUI IDEs (later)" section with the
exact uninstall commands (keep Xcode CLT).
**Verify:** `git status` clean; README renders the removal section.
