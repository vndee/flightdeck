# ~/.config/fish/config.fish — managed by flightdeck (github.com/vndee/flightdeck)

# --- Homebrew (must be early so PATH is correct in all sessions) ---
if test -x /opt/homebrew/bin/brew
    /opt/homebrew/bin/brew shellenv | source
end

# --- PATH ---
fish_add_path -g $HOME/.local/bin
fish_add_path -g $HOME/go/bin
fish_add_path -g $HOME/.cargo/bin

# --- Environment ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx PAGER less
set -gx MANPAGER 'nvim +Man!'
set -gx HOMEBREW_NO_ENV_HINTS 1
set -gx BAT_THEME "Catppuccin Mocha"

# fzf: Catppuccin Mocha colors + fd as the default source
set -gx FZF_DEFAULT_COMMAND 'fd --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND 'fd --type=d --hidden --strip-cwd-prefix --exclude .git'
set -gx FZF_DEFAULT_OPTS "\
--height 60% --layout reverse --border --info inline \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
--color=selected-bg:#45475a --multi"

# --- Interactive-only setup ---
if status is-interactive
    set -g fish_greeting   # silence greeting

    # Tool initialisation
    starship init fish | source
    zoxide init fish | source
    atuin init fish --disable-up-arrow | source   # keep ↑ for fish history, Ctrl-R for atuin
    fzf --fish | source

    # Source machine-local secrets if present (gitignored)
    test -f $HOME/.config/fish/conf.d/secret.fish; and source $HOME/.config/fish/conf.d/secret.fish
end
