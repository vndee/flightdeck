# Cheatsheet & Usage Guide

Everything you need to drive this setup. Print it, pin it, learn ~10 keys a day.

> Legend: `prefix` = tmux prefix = **`Ctrl-a`**. `<leader>` (Neovim) = **`Space`**.
> `C-x` = Ctrl+x. `M-x` = Alt/Option+x. `cmd` = ⌘ (Ghostty only).

---

## 0. The daily agentic workflow (start here)

```bash
# 1. open Ghostty → you're in fish. cd to a project (or use z)
z myproject

# 2. start the cockpit
tmux                      # or: sesh connect (prefix T from inside tmux)

# 3a. focused work: editor + one agent
nvim .                    # window 1
prefix a                  #  → spawns a Claude Code pane on the right

# 3b. parallel agents: one isolated worktree per task
wt login-bug              # new branch+worktree+session: nvim | claude windows
wt payment-flow           # a SECOND agent, totally isolated
prefix T                  # fuzzy-jump between agent sessions (sesh)

# 4. review & commit
prefix g                  # lazygit popup — stage hunks, commit, push
```

**Two agent modes, pick per task:**
- **Parallel** → `wt <branch>` (throughput; 2–4 agents on separate branches).
- **In-editor** → `<leader>ac` in Neovim (tight loop; inline diff review).

---

## 1. Ghostty (terminal)

| Key | Action |
|---|---|
| `cmd+d` | split right |
| `cmd+shift+d` | split down |
| `cmd+w` | close split/tab |
| `cmd+k` | clear screen |
| `cmd+enter` | fullscreen |
| `cmd+t` / `cmd+1..9` | new tab / jump to tab |

> Day to day you'll mostly use **tmux** splits (persistent, scriptable) rather
> than Ghostty splits. Use Ghostty tabs for separate projects if you like.

---

## 2. fish shell + abbreviations

Abbreviations **expand inline** as you type (press space) so you always see the
real command.

| Abbr | Expands to |
|---|---|
| `v` / `vi` | `nvim` |
| `ls` / `ll` / `la` | `eza` (icons, git, long, all) |
| `lt` | `eza --tree --level=2` |
| `cat` | `bat` |
| `g` `gs` `ga` `gaa` `gc` `gcm` `gco` `gd` `gl` `gp` `gpl` | git shortcuts |
| `lg` | `lazygit` |
| `cl` / `clc` | `claude` / `claude --continue` |
| `..` `...` | `cd ..` / `cd ../..` |
| `top` | `btop` |

| Key | Action |
|---|---|
| `→` / `Ctrl-f` | accept autosuggestion (the grey text) |
| `Alt-→` | accept one word of suggestion |
| `Tab` | completions (fish has great built-ins) |
| `Ctrl-r` | **atuin** history search (fuzzy, full-screen) |
| `↑` | plain fish history (prefix-matched) |
| `Ctrl-t` | **fzf** file picker → inserts path |
| `Alt-c` | **fzf** cd into subdirectory |
| `Ctrl-c` / `Ctrl-l` | cancel line / clear |

---

## 3. Navigation (zoxide · fzf · yazi)

```bash
z foo            # jump to best-matching dir you've visited (frecency)
zi               # interactive zoxide picker (fzf)
y                # open yazi file manager; quit with q → shell cd's there
```

**fzf inside other tools:** `Ctrl-t` (files), `Alt-c` (dirs), `**<Tab>` after a
command for fuzzy completion (e.g. `nvim **<Tab>`, `kill **<Tab>`).

**yazi keys:** `h j k l` move · `space` select · `y`/`x`/`p` yank/cut/paste ·
`a` create · `d` delete · `r` rename · `/` find · `q` quit (cd's via the `y` fn) ·
`Enter` open · `gg`/`G` top/bottom.

---

## 4. tmux (the cockpit)

Prefix = **`Ctrl-a`**. Press prefix, release, then the key.

| Key | Action |
|---|---|
| `prefix \|` | split **right** (keeps cwd) |
| `prefix -` | split **down** (keeps cwd) |
| `prefix c` | new window (keeps cwd) |
| `prefix 1..9` | go to window N |
| `prefix ,` | rename window |
| `prefix z` | zoom/unzoom pane (fullscreen one pane) |
| `prefix H/J/K/L` | resize pane (repeatable) |
| `C-h/C-j/C-k/C-l` | move between panes **and** nvim splits (seamless) |
| `prefix T` | **sesh** session switcher (fuzzy) |
| `prefix L` | last session |
| `prefix d` | detach (session keeps running) |
| `prefix a` | **spawn a Claude Code pane** (right) |
| `prefix g` | **lazygit** popup |
| `prefix [` | copy mode (then `v` select, `y` yank, `q` quit) |
| `prefix r` | reload tmux config |

```bash
tmux             # start / attach
tmux ls          # list sessions
tmux a -t name   # attach to a session
sesh list        # all sessions/projects (used by prefix T)
```

> Sessions survive terminal restarts (resurrect + continuum auto-save/restore).

---

## 5. The `wt` orchestrator (parallel agents)

```bash
wt <branch>      # create/attach: worktree + tmux session (nvim | claude)
wt ls            # list worktrees and tmux sessions
wt cd <branch>   # print worktree path → cd "$(wt cd <branch>)"
wt rm <branch>   # remove worktree + kill its session
```

Worktrees live in `../<repo>.worktrees/<branch>`. Each is a full isolated
checkout on its own branch, so agents never collide. Switch between running
agents with `prefix T`.

---

## 6. Neovim (LazyVim)

Leader = **`Space`**. First launch auto-installs LSPs/formatters via Mason
(watch with `:Mason`).

### Essentials
| Key | Action |
|---|---|
| `<leader>` then wait | **which-key** popup shows every menu |
| `<leader><space>` | find files (root) |
| `<leader>/` | live grep (ripgrep) |
| `<leader>,` | switch buffer |
| `<leader>e` | file explorer (neo-tree) |
| `<leader>fr` | recent files |
| `<C-d>` / `<C-u>` | half-page down/up (centered) |
| `<leader>w` `<leader>q` | save / quit hints under which-key |
| `<S-h>` / `<S-l>` | prev / next buffer |
| `<leader>bd` | close buffer |

### Code / LSP
| Key | Action |
|---|---|
| `gd` / `gr` | go to definition / references |
| `gD` / `gI` | declaration / implementation |
| `K` | hover docs |
| `<leader>ca` | code action |
| `<leader>cr` | rename symbol |
| `<leader>cf` | format buffer |
| `<leader>cd` | line diagnostics |
| `]d` / `[d` | next / prev diagnostic |
| `<leader>ss` | document symbols |

### Editing (vim + LazyVim)
| Key | Action |
|---|---|
| `gcc` / `gc` (visual) | toggle comment line / selection |
| `<leader>sr` | search & replace (grug-far) |
| `s` | flash jump (type 2 chars → label) |
| `ys`/`cs`/`ds` | add/change/delete surround (e.g. `ysiw"`) |
| `<C-\>` | toggle terminal |
| `<leader>gg` | lazygit inside nvim |

### Completion (blink.cmp)
`Tab`/`S-Tab` navigate · `Enter` accept · `C-Space` open · `C-e` close.

---

## 7. Claude Code inside Neovim (`claudecode.nvim`)

| Key | Mode | Action |
|---|---|---|
| `<leader>ac` | n | toggle Claude Code |
| `<leader>af` | n | focus the Claude window |
| `<leader>aC` | n | continue last conversation |
| `<leader>ar` | n | resume a conversation |
| `<leader>ab` | n | add current buffer to context |
| `<leader>as` | **v** | send selection to Claude |
| `<leader>as` | tree | add highlighted file (in neo-tree) |
| `<leader>aa` / `<leader>ad` | n | accept / deny a proposed diff |
| `<leader>am` | n | pick Claude model |

Flow: select code → `<leader>as` → ask Claude to change it → review the diff it
proposes → `<leader>aa` to accept or `<leader>ad` to reject.

---

## 8. Git: lazygit + delta

`lazygit` (or `prefix g`, or `<leader>gg` in nvim):

| Key | Action |
|---|---|
| `space` | stage / unstage file or hunk |
| `a` | stage all |
| `c` | commit (`C` for full editor) |
| `P` / `p` | push / pull |
| `b` | branches view · `space` to checkout |
| `<` `>` | older/newer commit · `Enter` to inspect |
| `d` | diff/discard menu · `z`/`Z` undo/redo |
| `?` | help (every panel has its own keys) |

`git diff`, `git show`, `git log -p` all render through **delta** (syntax
highlighting, line numbers). `git lg` = pretty graph; `git sync` = pull --rebase
&& push.

---

## 9. CLI quick reference

```bash
bat file.go               # cat with syntax + line numbers (paged)
eza -la --git             # ls with icons + git status   (abbr: la)
fd pattern                # find files (respects .gitignore)
rg pattern                # grep (fast, .gitignore-aware)
rg pattern -t go          # only Go files
btop                      # system monitor (abbr: top)
gh pr create / gh pr view # GitHub from the terminal
tldr <cmd>                # concise example-first help
atuin search <q>          # query shell history from CLI
```

---

## 10. Maintenance

```bash
cd ~/flightdeck && git pull       # get updates
./install.sh                      # re-apply (idempotent)
stow -t ~ <package>               # link one package
stow -D -t ~ <package>            # unlink one package
brew bundle --file=~/flightdeck/Brewfile   # sync packages

# Neovim
:Lazy        # plugin manager (U = update, S = sync, x = clean)
:Mason       # LSP/formatter/linter installer
:checkhealth # diagnose issues
:LazyExtras  # toggle language/feature extras

# tmux
prefix I     # install plugins   ·  prefix U = update   ·  prefix r = reload
```

**Secrets:** put API keys in `~/.config/fish/conf.d/secret.fish` (gitignored).
**Backups:** the installer saved your previous configs to
`~/.dotfiles-backup-<timestamp>/`.
